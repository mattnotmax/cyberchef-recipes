#
# Cookbook Name:: rvm
# Attributes:: default
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2010, 2011, Fletcher Nichol
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

# ruby that will get installed and set to `rvm use default`.
default['rvm']['default_ruby']      = "ruby-1.9.3-p327"
default['rvm']['user_default_ruby'] = "ruby-1.9.3-p327"

# list of additional rubies that will be installed
default['rvm']['rubies']      = []
default['rvm']['user_rubies'] = []

# list of gems to be installed in global gemset of all rubies
_global_gems_ = [
  { 'name'    => 'bundler' }
]
default['rvm']['global_gems']       = _global_gems_.dup
default['rvm']['user_global_gems']  = _global_gems_.dup

# hash of gemsets and their list of additional gems to be installed.
default['rvm']['gems']      = Hash.new
default['rvm']['user_gems'] = Hash.new

# hash of rvmrc options
default['rvm']['rvmrc']         = Hash.new

# a list of user hashes, each an isolated per-user RVM installation
default['rvm']['user_installs'] = []

# system-wide installer options
default['rvm']['installer_url'] = "https://get.rvm.io"
default['rvm']['branch']  = "stable"
default['rvm']['version'] = "head"
default['rvm']['upgrade'] = "none"

# extra system-wide tunables
default['rvm']['root_path']     = "/usr/local/rvm"
default['rvm']['group_id']      = 'default'
default['rvm']['group_users']   = []

# default rvm_gem_options (skip rdoc/ri generation)
default['rvm']['rvm_gem_options'] = "--no-rdoc --no-ri"

# a hook to disable installing any default/additional rubies
default['rvm']['install_rubies']      = "true"
default['rvm']['user_install_rubies'] = "true"

case platform
when "redhat","centos","fedora","scientific","amazon"
  node.set['rvm']['install_pkgs']   = %w{sed grep tar gzip bzip2 bash curl git}
  default['rvm']['user_home_root']  = '/home'
when "debian","ubuntu","suse"
  node.set['rvm']['install_pkgs']   = %w{sed grep tar gzip bzip2 bash curl git-core}
  default['rvm']['user_home_root']  = '/home'
when "gentoo"
  node.set['rvm']['install_pkgs']   = %w{git}
  default['rvm']['user_home_root']  = '/home'
when "mac_os_x", "mac_os_x_server"
  node.set['rvm']['install_pkgs']   = %w{git}
  default['rvm']['user_home_root']  = '/Users'
end
