#
# Cookbook Name:: mysql_test
# Recipe:: server
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

node.set['mysql']['server_debian_password'] = "ilikerandompasswords"
node.set['mysql']['server_root_password']   = "ilikerandompasswords"
node.set['mysql']['server_repl_password']   = "ilikerandompasswords"

include_recipe "mysql::ruby"
include_recipe "yum::epel" if platform_family?('rhel')

file "/etc/sysconfig/network" do
  content "NETWORKING=yes"
  action :create_if_missing
  only_if { platform_family?('rhel', 'fedora') }
end

include_recipe 'mysql::server'

mysql_connection = {:host => "localhost", :username => 'root',
                    :password => node['mysql']['server_root_password']}

mysql_database node['mysql_test']['database'] do
  connection mysql_connection
  action :create
end

mysql_database_user node['mysql_test']['username'] do
  connection mysql_connection
  password node['mysql_test']['password']
  database_name node['mysql_test']['database']
  host 'localhost'
  privileges [:select,:update,:insert, :delete]
  action [:create, :grant]
end

mysql_conn_args = "--user=root --password='#{node['mysql']['server_root_password']}'"

execute 'create-sample-data' do
  command %Q{mysql #{mysql_conn_args} #{node['mysql_test']['database']} <<EOF
    CREATE TABLE tv_chef (name VARCHAR(32) PRIMARY KEY);
    INSERT INTO tv_chef (name) VALUES ('Alison Holst');
    INSERT INTO tv_chef (name) VALUES ('Nigella Lawson');
    INSERT INTO tv_chef (name) VALUES ('Paula Deen');
EOF}
  not_if "echo 'SELECT count(name) FROM tv_chef' | mysql #{mysql_conn_args} --skip-column-names #{node['mysql_test']['database']} | grep '^3$'"
end
