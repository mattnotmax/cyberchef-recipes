#
# Cookbook Name:: rvm
# Recipe:: user
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

include_recipe 'rvm::user_install'

Array(node['rvm']['user_installs']).each do |rvm_user|
  perform_install_rubies  = rvm_user['install_rubies'] == true ||
                            rvm_user['install_rubies'] == "true" ||
                            node['rvm']['user_install_rubies'] == true ||
                            node['rvm']['user_install_rubies'] == "true"
  rubies                  = rvm_user['rubies'] ||
                            node['rvm']['user_rubies']
  default_ruby            = rvm_user['default_ruby'] ||
                            node['rvm']['user_default_ruby']
  global_gems             = rvm_user['global_gems'] ||
                            node['rvm']['user_global_gems']
  gems                    = rvm_user['gems'] ||
                            node['rvm']['user_gems']

  if perform_install_rubies
    install_rubies  :rubies => rubies,
                    :default_ruby => default_ruby,
                    :global_gems => global_gems,
                    :gems => gems,
                    :user => rvm_user['user']
  end
end
