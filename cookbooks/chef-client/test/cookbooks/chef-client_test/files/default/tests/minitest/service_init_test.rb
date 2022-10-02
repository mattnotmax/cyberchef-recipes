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
  it 'enables and starts the init service' do
    service('chef-client').must_be_running
    file('/etc/init.d/chef-client').must_have(:mode, "0755")
  end
end
