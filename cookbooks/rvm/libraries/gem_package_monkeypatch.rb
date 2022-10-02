#
# Cookbook Name:: rvm
# Library: gem_package resource monkey patch
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
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

##
# Patch Chef::Resource::GemPackage resource to use the RVMRubygems provider.
# This has potentially dangerous side effects and should be considered
# experimental. You have been warned.
def patch_gem_package
  ::Chef::Resource::GemPackage.class_eval do
    def initialize(name, run_context=nil)
      super
      @resource_name = :gem_package
      @provider = Chef::Provider::Package::RVMRubygems
    end
  end
end
