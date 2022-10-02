#
# Copyright 2012, Opscode, Inc.
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

describe 'chef-client::cron' do
  include Helpers::ChefClient
  it 'creates the cron job for chef-client' do
    if node['chef_client']['cron']['use_cron_d']
      file("/etc/cron.d/chef-client").must_exist
    else
      cron("chef-client").must_exist
    end
  end

  it 'creates the cron command' do
    if node['chef_client']['cron']['use_cron_d']
      file("/etc/cron.d/chef-client").must_match %r{/bin/sleep \d+; (([A-Za-z]+=.*)?) /usr/bin/chef-client > /dev/null 2>&1}
    else
      cron("chef-client").command.
        must_match %r{/bin/sleep \d+; (([A-Za-z]+=.*)?)|[\s] /usr/bin/chef-client > /dev/null 2>&1}
    end
  end
end
