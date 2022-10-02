#
# Cookbook Name:: rvm
# Library:: Chef::RVM::RecipeHelpers
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2013, Fletcher Nichol
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

def require_library(name)
  require File.expand_path(File.join(
    File.dirname(__FILE__), '../../../../libraries', "#{name}.rb"
  ))
end

require 'minitest/autorun'
require_library 'chef_rvm_recipe_helpers'

class Dummy
  include Chef::RVM::RecipeHelpers
end

describe 'Chef::RVM::RecipeHelpers' do

  subject do
    Dummy.new
  end

  describe '.build_script_flags' do

    it 'sets branch and version flags' do
      subject.build_script_flags("stable", "head").
        must_equal " -s -- --branch stable --version head"
    end

    it 'sets a missing branch to "head"' do
      subject.build_script_flags("cool").
        must_equal " -s -- --branch cool --version head"
    end

    it 'only emits version with branch=stable and version=x.y.z' do
      subject.build_script_flags("stable", "1.2.3").
        must_equal " -s -- --version 1.2.3"
    end

    it 'only emits version with branch=master and version=x.y.z' do
      subject.build_script_flags("master", "4.5.6").
        must_equal " -s -- --version 4.5.6"
    end

    it 'only emits version with branch=none and version=x.y.z' do
      subject.build_script_flags("none", "7.3.5").
        must_equal " -s -- --version 7.3.5"
    end

    it 'emits version and branch with branch not stable|master and version=x.y.z' do
      subject.build_script_flags("foo/bar", "0.9.8").
        must_equal " -s -- --branch foo/bar --version 0.9.8"
    end
  end
end
