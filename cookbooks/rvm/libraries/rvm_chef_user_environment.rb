#
# Cookbook Name:: rvm
# Library:: RVM::ChefUserEnvironment
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

def create_rvm_chef_user_environment
  klass = Class.new(::RVM::Environment) do
    attr_reader :user, :source_environment

    def initialize(user = nil, environment_name = "default", options = {})
      @source_environment = options.delete(:source_environment)
      @source_environment = true if @source_environment.nil?
      @user = user
      # explicitly set rvm_path if user is set
      if @user.nil?
        config['rvm_path'] = @@root_rvm_path
      else
        config['rvm_path'] = File.join(Etc.getpwnam(@user).dir, '.rvm')
      end

      merge_config! options
      @environment_name = environment_name
      @shell_wrapper = ::RVM::Shell::ChefWrapper.new(@user)
      @shell_wrapper.setup do |s|
        if source_environment
          source_rvm_environment
          use_rvm_environment
        end
      end
    end

    def self.root_rvm_path=(path)
      @@root_rvm_path = path
    end
  end
  ::RVM.const_set('ChefUserEnvironment', klass)

  ::RVM::ChefUserEnvironment.root_rvm_path = node['rvm']['root_path']
end
