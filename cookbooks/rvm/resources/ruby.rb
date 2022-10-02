#
# Cookbook Name:: rvm
# Resource:: ruby
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

actions :install, :uninstall, :remove

attribute :ruby_string,      :kind_of => String, :name_attribute => true
attribute :user,             :kind_of => String
attribute :patch,            :kind_of => String
attribute :rubygems_version, :kind_of => String

def initialize(*args)
  super
  @action = :install
end
