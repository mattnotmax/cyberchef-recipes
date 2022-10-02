#
# Cookbook Name:: rvm
# Resource:: gemset
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

actions :create, :delete, :empty, :update

attribute :gemset,      :kind_of => String, :name_attribute => true
attribute :ruby_string, :kind_of => String, :regex => /^[^@]+$/
attribute :user,        :kind_of => String
attribute :patch,       :kind_of => String

def initialize(*args)
  super
  @action = :create
end
