#
# Cookbook Name:: rvm
# Recipe:: system_install
#
# Copyright 2010, 2011 Fletcher Nichol
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

include_recipe 'rvm'

script_flags      = build_script_flags(node['rvm']['branch'], node['rvm']['version'])
upgrade_strategy  = build_upgrade_strategy(node['rvm']['upgrade'])
installer_url     = node['rvm']['installer_url']
rvm_prefix        = ::File.dirname(node['rvm']['root_path'])
rvm_gem_options   = node['rvm']['rvm_gem_options']
rvmrc             = node['rvm']['rvmrc']

install_pkg_prereqs

# Build the rvm group ahead of time, if it is set. This allows avoiding
# collision with later processes which may set a guid explicitly
if node['rvm']['group_id'] != 'default'
  g = group 'rvm' do
    group_name 'rvm'
    gid        node['rvm']['group_id']
    action     :nothing
  end
  g.run_action(:create)
end

rvmrc_template  :rvm_prefix => rvm_prefix,
                :rvm_gem_options => rvm_gem_options,
                :rvmrc => rvmrc,
                :rvmrc_file => "/etc/rvmrc"

install_rvm     :rvm_prefix => rvm_prefix,
                :installer_url => installer_url,
                :script_flags => script_flags

upgrade_rvm     :rvm_prefix => rvm_prefix,
                :upgrade_strategy => upgrade_strategy
