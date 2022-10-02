#
# Cookbook Name:: rvm
# Library:: Chef::RVM::GemsetHelpers
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
    module GemsetHelpers
      ##
      # Lists all gemsets for a given RVM Ruby.
      #
      # **Note** that these values are cached for lookup speed. To flush these
      # values and force an update, call #update_installed_gemsets.
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [Array] a cached list of gemset names
      def installed_gemsets(rubie)
        @installed_gemsets = Hash.new if @installed_gemsets.nil?
        @installed_gemsets[rubie] ||= update_installed_gemsets(rubie)
      end

      ##
      # Updates the list of all gemsets for a given RVM Ruby on the system
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [Array] the current list of gemsets
      def update_installed_gemsets(rubie)
        original_rubie = @rvm_env.environment_name
        @rvm_env.use rubie

        @installed_gemsets ||= {}
        @installed_gemsets[rubie] = @rvm_env.gemset_list
        @rvm_env.use original_rubie if original_rubie != rubie
        @installed_gemsets[rubie]
      end

      ##
      # Determines whether or not a gemset exists for a given Ruby
      #
      # @param [Hash] the options to query a gemset with
      # @option opts [String] :ruby the Ruby the query within
      # @option opts [String] :gemset the gemset to look for
      def gemset_exists?(opts={})
        return false if opts[:ruby].nil? || opts[:gemset].nil?
        return false unless ruby_installed?(opts[:ruby])

        installed_gemsets(opts[:ruby]).include?(opts[:gemset])
      end
    end
  end
end
