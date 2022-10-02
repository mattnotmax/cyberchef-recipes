#
# Cookbook Name:: rvm
# Library:: Chef::RVM::RubyHelpers
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

class Chef
  module RVM
    module RubyHelpers
      ##
      # Lists all installed RVM Rubies on the system.
      #
      # **Note** that these values are cached for lookup speed. To flush these
      # values and force an update, call #update_installed_rubies.
      #
      # @return [Array] the cached list of currently installed RVM Rubies
      def installed_rubies
        @installed_rubies ||= update_installed_rubies
      end

      ##
      # Updates the list of all installed RVM Rubies on the system
      #
      # @return [Array] the list of currently installed RVM Rubies
      def update_installed_rubies
        @installed_rubies = @rvm_env.list_strings
        @installed_rubies
      end

      ##
      # Determines whether or not the given Ruby is already installed
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [Boolean] is this Ruby installed?
      def ruby_installed?(rubie)
        ! installed_rubies.select { |r| r.end_with?(rubie) }.empty?
      end

      ##
      # Fetches the current default Ruby string, potentially with gemset
      #
      # @return [String] the RVM Ruby string, nil if none is set
      def current_ruby_default
        @rvm_env.list_default
      end

      ##
      # Determines whether or not the given Ruby is the default one
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [Boolean] is this Ruby the default one?
      def ruby_default?(rubie)
        current_default = current_ruby_default

        if current_default.nil?
          if rubie == "system"
            return true
          else
            return false
          end
        end

        current_default.start_with?(rubie)
      end

      ##
      # Determines whether or not the given Ruby could be considered the
      # system Ruby.
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [Boolean] is this Ruby string the a system Ruby?
      def system_ruby?(rubie)
        return true if rubie.nil?         # nil should be system
        return true if rubie.empty?       # an empty string should be system
        return true if rubie == "system"  # keyword system should be system
        return false                      # anything else does not represent system
      end
    end
  end
end
