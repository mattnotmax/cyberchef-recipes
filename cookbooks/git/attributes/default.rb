#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
# Cookbook Name:: git
# Attributes:: default
#
# Copyright 2008-2012, Opscode, Inc.
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

case node['platform_family']
when 'windows'
  default['git']['version'] = "1.8.1.2-preview20130201"
  default['git']['url'] = "https://msysgit.googlecode.com/files/Git-#{node['git']['version']}.exe"
  default['git']['checksum'] = "796ac91f0c7456b53f2717a81f475075cc581af2f447573131013cac5b63bb2a"
  default['git']['display_name'] = "Git version #{ node['git']['version'] }"
when "mac_os_x"
  default['git']['osx_dmg']['app_name']    = "git-1.8.2-intel-universal-snow-leopard"
  default['git']['osx_dmg']['volumes_dir'] = "Git 1.8.2 Snow Leopard Intel Universal"
  default['git']['osx_dmg']['package_id']  = "GitOSX.Installer.git182.git.pkg"
  default['git']['osx_dmg']['url']         = "https://git-osx-installer.googlecode.com/files/git-1.8.2-intel-universal-snow-leopard.dmg"
  default['git']['osx_dmg']['checksum']    = "e1d0ec7a9d9d03b9e61f93652b63505137f31217908635cdf2f350d07cb33e15"
else
  default['git']['prefix'] = "/usr/local"
  default['git']['version'] = "1.8.2.1"
  default['git']['url'] = "https://nodeload.github.com/git/git/tar.gz/v#{node['git']['version']}"
  default['git']['checksum'] = "bdc1768f70ce3d8f3e4edcdcd99b2f85a7f8733fb684398aebe58dde3e6bcca2"
end

default['git']['server']['base_path'] = "/srv/git"
default['git']['server']['export_all'] = "true"
