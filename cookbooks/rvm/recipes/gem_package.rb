#
# Cookbook Name:: rvm
# Recipe:: gem_package
#
# Copyright 2011, Fletcher Nichol
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

node_val = node['rvm']['gem_package']['rvm_string']
case node_val
when String
  rvm_descriptor = node_val + " RVM Ruby"
when Array
  last = node_val.pop
  rvm_descriptor = [ node_val.join(', '), last ].join(' & ') + " RVM Rubies"
end

patch_gem_package

::Chef::Log.info "gem_package resource has been patched to use provider " <<
  "Chef::Provider::Package::RVMRubygems and will install gems to " <<
  "the #{rvm_descriptor}."
