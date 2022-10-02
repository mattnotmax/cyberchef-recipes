#
# Cookbook Name:: rvm
# Library:: Chef::RVM::StringHelpers
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
    module StringHelpers
      ##
      # Filters out any gemset declarations in an RVM Ruby string
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [String] the Ruby string, minus gemset
      def select_ruby(ruby_string)
        ruby_string.split('@').first
      end

      ##
      # Filters out any Ruby declaration in an RVM Ruby string
      #
      # @param [String, #to_s] the RVM Ruby string
      # @return [String] the gemset string, minus Ruby or nil if no gemset given
      def select_gemset(ruby_string)
        if ruby_string.include?('@')
          ruby_string.split('@').last
        else
          nil
        end
      end

      ##
      # Sanitizes a Ruby string so that it's more normalized.
      #
      # @param [String, #to_s] an RVM Ruby string
      # @param [String] a specific user RVM or nil for system-wide
      # @return [String] a fully qualified RVM Ruby string
      def normalize_ruby_string(ruby_string, user = new_resource.user, patch = new_resource.patch)
        return "system" if ruby_string == "system"
        fetched_ruby_string = StringCache.fetch(ruby_string, user)
        return "#{fetched_ruby_string} --patch #{patch}" if patch
        fetched_ruby_string
      end
    end
  end
end
