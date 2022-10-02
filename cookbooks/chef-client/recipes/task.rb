#
# Author:: Paul Mooring (<paul@opscode.com>)
# Cookbook Name:: chef
# Recipe:: task
#
# Copyright 2011, Opscode, Inc.
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

class ::Chef::Recipe
  include ::Opscode::ChefClient::Helpers
end
# libraries/helpers.rb method to DRY directory creation resources
client_bin = find_chef_client
node.set["chef_client"]["bin"] = client_bin
create_directories

windows_task "chef-client" do
  run_level :highest
  command "#{node['chef_client']['ruby_bin']} #{node['chef_client']['bin']} \
  -L #{File.join(node['chef_client']['log_dir'], 'client.log')} \
  -c #{File.join(node['chef_client']['conf_dir'], 'client.rb')} -s #{node['chef_client']['splay']}"
  frequency :minute
  frequency_modifier(node['chef_client']['interval'].to_i / 60)
end

