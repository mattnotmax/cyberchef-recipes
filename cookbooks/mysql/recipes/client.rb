#
# Cookbook Name:: mysql
# Recipe:: client
#
# Copyright 2008-2011, Opscode, Inc.
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

# Include Opscode helper in Recipe class to get access
# to debian_before_squeeze? and ubuntu_before_lucid?
::Chef::Recipe.send(:include, Opscode::Mysql::Helpers)

case node['platform']
when "windows"
  package_file = node['mysql']['client']['package_file']
  remote_file "#{Chef::Config[:file_cache_path]}/#{package_file}" do
    source node['mysql']['client']['url']
    not_if { File.exists? "#{Chef::Config[:file_cache_path]}/#{package_file}" }
  end

  windows_package node['mysql']['client']['packages'].first do
    source "#{Chef::Config[:file_cache_path]}/#{package_file}"
  end
  windows_path node['mysql']['client']['bin_dir'] do
    action :add
  end
  def package(*args, &blk)
    windows_package(*args, &blk)
  end
when "mac_os_x"
  include_recipe 'homebrew'
end

node['mysql']['client']['packages'].each do |mysql_pack|
  package mysql_pack do
    action :install
  end
end

if platform? 'windows'
  ruby_block "copy libmysql.dll into ruby path" do
    block do
      require 'fileutils'
      FileUtils.cp "#{node['mysql']['client']['lib_dir']}\\libmysql.dll", node['mysql']['client']['ruby_dir']
    end
    not_if { File.exist?("#{node['mysql']['client']['ruby_dir']}\\libmysql.dll") }
  end
end
