#
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: chef-client
# Recipe:: config
#
# Copyright 2008-2013, Opscode, Inc
# Copyright 2009, 37signals
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

class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end

chef_node_name = Chef::Config[:node_name] == node["fqdn"] ? false : Chef::Config[:node_name]
case node["chef_client"]["log_file"]
when String
  log_path = File.join(node["chef_client"]["log_dir"], node["chef_client"]["log_file"])
  node.default['chef_client']['config']['log_location'] = "'#{log_path}'"

  case node['platform_family']
  when 'rhel','debian','fedora'
    logrotate_app 'chef-client' do
      path [ log_path ]
      rotate node['chef_client']['logrotate']['rotate']
      frequency node['chef_client']['logrotate']['frequency']
      options [ 'compress' ]
      postrotate '/etc/init.d/chef-client condrestart >/dev/null || :'
    end
  end
else
  log_path = 'STDOUT'
end

# libraries/helpers.rb method to DRY directory creation resources
create_directories

if log_path != "STDOUT"
  file log_path do
    mode 00640
  end
end

chef_requires = []
node["chef_client"]["load_gems"].each do |gem_name, gem_info_hash|
  gem_info_hash ||= {}
  chef_gem gem_name do
    action gem_info_hash[:action] || :install
    version gem_info_hash[:version] if gem_info_hash[:version]
  end
  chef_requires.push(gem_info_hash[:require_name] || gem_name)
end

# We need to set these local variables because the methods aren't
# available in the Chef::Resource scope
d_owner = dir_owner
d_group = dir_group

template "#{node["chef_client"]["conf_dir"]}/client.rb" do
  source "client.rb.erb"
  owner d_owner
  group d_group
  mode 00644
  variables(
    :chef_config => node['chef_client']['config'],
    :chef_requires => chef_requires,
    :ohai_disabled_plugins => node['ohai']['disabled_plugins'],
    :start_handlers => node['chef_client']['config']['start_handlers'],
    :report_handlers => node['chef_client']['config']['report_handlers'],
    :exception_handlers => node['chef_client']['config']['exception_handlers']
  )
  notifies :create, "ruby_block[reload_client_config]", :immediately
end

directory ::File.join(node['chef_client']['conf_dir'], 'client.d') do
  recursive true
  owner d_owner
  group d_group
  mode 00755
end

ruby_block "reload_client_config" do
  block do
    Chef::Config.from_file("#{node["chef_client"]["conf_dir"]}/client.rb")
  end
  action :nothing
end
