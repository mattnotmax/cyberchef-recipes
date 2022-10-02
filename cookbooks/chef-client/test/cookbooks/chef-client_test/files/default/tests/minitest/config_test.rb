#
# Author:: Joshua Timberman <joshua@opscode.com>
# Cookbook Name:: chef-client_test
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

require File.expand_path('../support/helpers', __FILE__)

describe 'chef-client::config' do
  include Helpers::ChefClient

  it 'contains the default config settings' do
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match('^chef_server_url')
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match('^validation_client_name')
  end

  it 'disables ohai plugins' do
    regexp = 'Ohai::Config\[:disabled_plugins\] =\s+\["passwd"\]'
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match(/#{regexp}/)
  end

  it 'converts log_level to a symbol' do
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match('^log_level :debug')
  end

  it 'converts ssl_verify_mode to a symbol' do
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match('^ssl_verify_mode :verify_peer')
  end

  it 'enables start_handlers' do
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match(
      '^start_handlers << SimpleReport::UpdatedResources.new'
      )
  end

  it 'enables report_handlers' do
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match(
      '^report_handlers << SimpleReport::UpdatedResources.new'
    )
  end

  it 'enables exception_handlers' do
    file(File.join(node['chef_client']['conf_dir'], 'client.rb')).must_match(
      '^exception_handlers << SimpleReport::UpdatedResources.new'
      )
  end

  it 'creates a directory for including config' do
    directory(File.join(node['chef_client']['conf_dir'], 'client.d')).must_exist
  end
end
