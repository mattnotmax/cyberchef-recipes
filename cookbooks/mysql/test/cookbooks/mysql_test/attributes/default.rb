#
# Cookbook Name:: mysql_test
# Attributes:: default
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

# Must be specified for chef-solo for successful re-converge
override['mysql']['server_root_password'] = 'e;br$il<vOp&Ceth!Hi.en>Roj7'

default['mysql_test']['database'] = 'mysql_test'
default['mysql_test']['username'] = 'test_user'
default['mysql_test']['password'] = 'neshFiapog'

override['mysql']['bind_address'] = 'localhost'
