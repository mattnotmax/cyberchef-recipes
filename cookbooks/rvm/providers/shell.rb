#
# Cookbook Name:: rvm
# Provider:: shell
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
include Chef::RVM::EnvironmentHelpers
include Chef::RVM::ShellHelpers

def load_current_resource
  @user_rvm     = user_installed_rvm? ? new_resource.user : nil
  @rubie        = normalize_ruby_string(select_ruby(new_resource.ruby_string), @user_rvm)
  @gemset       = select_gemset(new_resource.ruby_string)
  @ruby_string  = @gemset.nil? ? @rubie : "#{@rubie}@#{@gemset}"
  @rvm_env      = ::RVM::ChefUserEnvironment.new(@user_rvm)
end

action :run do
  user_rvm = @user_rvm

  # ensure ruby is installed and gemset exists
  unless env_exists?(@ruby_string)
    e = rvm_environment @ruby_string do
      user    user_rvm
      action :nothing
    end
    e.run_action(:create)
  end

  script_wrapper :run
end

private

##
# Wraps the script resource for RVM-dependent code.
#
# @param [Symbol] action to be performed with gem_package provider
def script_wrapper(exec_action)
  profile = find_profile_to_source

  script_code = <<-CODE
    if [ -s "${HOME}/.rvm/scripts/rvm" ]; then
      source "${HOME}/.rvm/scripts/rvm"
    elif [ -s "#{profile}" ]; then
      source "#{profile}"
    fi

    rvm use #{@ruby_string}

    #{new_resource.code}
  CODE

  if new_resource.user
    user_rvm  = user_installed_rvm?
    user_home = user_dir
  end

  s = script new_resource.name do
    interpreter   "bash"

    if new_resource.user
      user        new_resource.user
      if user_rvm && new_resource.environment
        environment({ 'USER' => new_resource.user, 'HOME' => user_home }.merge(
          new_resource.environment))
      elsif user_rvm
        environment({ 'USER' => new_resource.user, 'HOME' => user_home })
      end
    end

    code          script_code
    creates       new_resource.creates      if new_resource.creates
    cwd           new_resource.cwd          if new_resource.cwd
    group         new_resource.group        if new_resource.group
    path          new_resource.path         if new_resource.path
    returns       new_resource.returns      if new_resource.returns
    timeout       new_resource.timeout      if new_resource.timeout
    umask         new_resource.umask        if new_resource.umask
    action        :nothing
  end
  s.run_action(exec_action)
  new_resource.updated_by_last_action(true) if s.updated_by_last_action?
end

##
# Whether or not the user has an isolated RVM installation
#
# @return [true,false] does the user have RVM installed for themselves?
def user_installed_rvm?
  return false unless new_resource.user

  ::File.exists?("#{user_dir}/.rvm/VERSION")
end

##
# Determines the user's home directory
#
# @return [String] the path to the user's home directory
def user_dir
  return nil unless new_resource.user

  Etc.getpwnam(new_resource.user).dir
end
