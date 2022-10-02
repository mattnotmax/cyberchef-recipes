#
# Cookbook Name:: rvm
# Library:: Chef::RVM::EnvironmentHelpers
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
      # stub to satisfy EnvironmentHelpers (library load order not guarenteed)
    end

    module GemsetHelpers
      # stub to satisfy EnvironmentHelpers (library load order not guarenteed)
    end

    module EnvironmentHelpers
      include RubyHelpers
      include GemsetHelpers

      ##
      # Determines whether or not and ruby/gemset environment exists
      #
      # @param [String, #to_s] the fully qualified RVM ruby string
      # @return [Boolean] does this environment exist?
      def env_exists?(ruby_string)
        return true if system_ruby?(ruby_string)

        rubie   = select_ruby(ruby_string)
        gemset  = select_gemset(ruby_string)

        if gemset
          gemset_exists?(:ruby => rubie, :gemset => gemset)
        else
          ruby_installed?(rubie)
        end
      end
    end
  end
end
