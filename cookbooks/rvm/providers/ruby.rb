#
# Cookbook Name:: rvm
# Provider:: ruby
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Chef::RVM::StringHelpers
include Chef::RVM::RubyHelpers

def load_current_resource
  @rubie        = normalize_ruby_string(select_ruby(new_resource.ruby_string))
  @ruby_string  = new_resource.ruby_string
  @rvm_env      = ::RVM::ChefUserEnvironment.new(
    new_resource.user, "default",
    :rvm_rubygems_version => new_resource.rubygems_version,
    :source_environment => false
  )
end

action :install do
  next if skip_ruby?

  if ruby_installed?(@ruby_string)
    Chef::Log.debug("rvm_ruby[#{@rubie}] is already installed, so skipping")
  else
    install_start   = Time.now
    install_options = {:rvm_by_path => true}
    install_options[:patch] = new_resource.patch if new_resource.patch

    install_ruby_dependencies @rubie

    Chef::Log.info("Building rvm_ruby[#{@rubie}], this could take awhile...")

    if @rvm_env.install(@rubie, install_options)
      Chef::Log.info("Installation of rvm_ruby[#{@rubie}] was successful.")
      @rvm_env.use @rubie
      update_installed_rubies
      new_resource.updated_by_last_action(true)

      Chef::Log.info("Importing initial gemsets for rvm_ruby[#{@rubie}]")
      if @rvm_env.gemset_initial
        Chef::Log.debug("Initial gemsets for rvm_ruby[#{@rubie}] are installed")
      else
        Chef::Log.warn(
          "Failed to install initial gemsets for rvm_ruby[#{@rubie}] ")
      end
    else
      Chef::Log.warn("Failed to install rvm_ruby[#{@rubie}]. " +
        "Check logs in #{::RVM.path}/log/#{@rubie}")
    end

    Chef::Log.info("rvm_ruby[#{@rubie}] build time was " +
      "#{(Time.now - install_start)/60.0} minutes.")
  end
end

action :uninstall do
  next if skip_ruby?

  if ruby_installed?(@rubie)
    Chef::Log.info("Uninstalling rvm_ruby[#{@rubie}]")

    if @rvm_env.uninstall(@rubie, :rvm_by_path => true)
      update_installed_rubies
      Chef::Log.debug("Uninstallation of rvm_ruby[#{@rubie}] was successful.")
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.warn("Failed to uninstall rvm_ruby[#{@rubie}]. " +
        "Check logs in #{::RVM.path}/log/#{@rubie}")
    end
  else
    Chef::Log.debug("rvm_ruby[#{@rubie}] was not installed, so skipping")
  end
end

action :remove do
  next if skip_ruby?

  if ruby_installed?(@rubie)
    Chef::Log.info("Removing rvm_ruby[#{@rubie}]")

    if @rvm_env.remove(@rubie, :rvm_by_path => true)
      update_installed_rubies
      Chef::Log.debug("Removal of rvm_ruby[#{@rubie}] was successful.")
      new_resource.updated_by_last_action(true)
    else
      Chef::Log.warn("Failed to remove rvm_ruby[#{@rubie}]. " +
        "Check logs in #{::RVM.path}/log/#{@rubie}")
    end
  else
    Chef::Log.debug("rvm_ruby[#{@rubie}] was not installed, so skipping")
  end
end

private

def skip_ruby?
  if @rubie.nil?
    Chef::Log.warn("#{self.class.name}: RVM ruby string `#{@rubie}' " +
      "is not known. Use `rvm list known` to get a full list.")
    true
  else
    false
  end
end

##
# Installs any package dependencies needed by a given ruby
#
# @param [String, #to_s] the fully qualified RVM ruby string
def install_ruby_dependencies(rubie)
  pkgs = []
  case rubie
  when /^ruby-/, /^ree-/, /^rbx-/, /^kiji/
    case node['platform']
      when "debian","ubuntu"
        pkgs  = %w{ build-essential openssl libreadline6 libreadline6-dev
                    zlib1g zlib1g-dev libssl-dev libsqlite3-dev
                    sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev
                    ncurses-dev automake libtool bison ssl-cert pkg-config libgdbm-dev libffi-dev}
        pkgs += %w{ subversion }  if rubie =~ /^ruby-head$/
      when "suse"
        pkgs = %w{ gcc-c++ patch zlib zlib-devel libffi-devel
                   sqlite3-devel libxml2-devel libxslt-devel }
        if node['platform_version'].to_f >= 11.0
          pkgs += %w{ libreadline5 readline-devel libopenssl-devel }
        else
          pkgs += %w{ readline readline-devel openssl-devel }
        end
        pkgs += %w{ git subversion autoconf } if rubie =~ /^ruby-head$/
      when "centos","redhat","fedora","scientific","amazon"
        pkgs = %w{ gcc-c++ patch readline readline-devel zlib zlib-devel
                   libffi-devel openssl-devel
                   make bzip2 autoconf automake libtool bison
                   libxml2 libxml2-devel libxslt libxslt-devel }
        pkgs += %w{ git subversion autoconf } if rubie =~ /^ruby-head$/
      when "gentoo"
        pkgs = %w{ libiconv readline zlib openssl libyaml sqlite libxslt libtool gcc autoconf automake bison m4 }
    end
  when /^jruby/
    begin
      resource_collection.find("ruby_block[update-java-alternatives]").
        run_action(:create)
    rescue Chef::Exceptions::ResourceNotFound
      Chef::Log.debug(
        "java cookbook not loaded or not on ubuntu/debian, so skipping")
    end

    # TODO: need to figure out how to pull in java recipe only when needed. For
    # now, users of jruby will have to add the "java" recipe to their run_list.
    #include_recipe "java"
    case node['platform']
    when "debian","ubuntu"
      pkgs += %w{ g++ ant }
    end
  end

  pkgs.each do |pkg|
    package pkg do
      action :nothing
    end.run_action(:install)
  end
end
