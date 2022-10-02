#
# Cookbook Name:: chef-client
# Recipe:: windows_service
#
# Author:: Julian Dunn (<jdunn@opscode.com>)
#
# Copyright 2013, Opscode, Inc.
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

# Fall back to winsw on older Chef Clients without the service manager
if Gem::Requirement.new("< 11.5").satisfied_by?(Gem::Version.new(::Chef::VERSION))
  include_recipe "chef-client::winsw_service"
else
  # libraries/helpers.rb method to DRY directory creation resources
  create_directories

  # Will also avoid touching any winsw service if it exists
  execute "register-chef-service" do
    command "chef-service-manager -a install"
    only_if { WMI::Win32_Service.find(:first, :conditions => {:name => 'chef-client'}).nil? }
  end

  service "chef-client" do
    action [:enable, :start]
  end
end
