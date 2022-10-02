#
# Cookbook Name:: rvm
# Recipe:: user_install
#
# Copyright 2011 Fletcher Nichol
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

install_pkg_prereqs

Array(node['rvm']['user_installs']).each do |rvm_user|
  version = rvm_user['version'] || node['rvm']['version']
  branch  = rvm_user['branch'] || node['rvm']['branch']

  script_flags      = build_script_flags(branch, version)
  upgrade_strategy  = build_upgrade_strategy(rvm_user['upgrade'])
  installer_url     = rvm_user['installer_url'] || node['rvm']['installer_url']
  rvm_prefix        = rvm_user['home'] ||
                      "#{node['rvm']['user_home_root']}/#{rvm_user['user']}"
  rvm_gem_options   = rvm_user['rvm_gem_options'] || node['rvm']['rvm_gem_options']
  rvmrc             = rvm_user['rvmrc'] || node['rvm']['rvmrc'] 

  rvmrc_template  :rvm_prefix => rvm_prefix,
                  :rvm_gem_options => rvm_gem_options,
                  :rvmrc => rvmrc,
                  :user => rvm_user['user']

  install_rvm     :rvm_prefix => rvm_prefix,
                  :installer_url => installer_url,
                  :script_flags => script_flags,
                  :user => rvm_user['user']

  upgrade_rvm     :rvm_prefix => rvm_prefix,
                  :upgrade_strategy => upgrade_strategy,
                  :user => rvm_user['user']
end
