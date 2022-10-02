#
# Author:: John Dewey (<john@dewey.ws>)
# Cookbook Name:: chef-client
# Recipe:: cook-2169-root
#
# Copyright 2012, John Dewey
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

%w{run_path cache_path backup_path log_dir conf_dir}.each do |key|
  directory node["chef_client"][key] do
    recursive true
    action :nothing
  end.run_action(:delete)
end

execute "rm /usr/local/bin/chef-server" do
  action :nothing

  only_if { ::File.exists? "/usr/local/bin/chef-server" }
end.run_action(:run)

include_recipe "chef-client::cron"
