# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
#    www.wontology.com
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License version
# 3 as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program in the file COPYING and/or LICENSE.  If not,
# see <http://www.gnu.org/licenses/>.



# sneakiness:  don't need any information to identify/handle a file
# except for the String with the file's path.  But there are places
# where the code is a lot more readable if we can act on "individual
# files".  So, add our convenience methods directly to String so that
# we don't have to instantiate a zillion trivial wrapper objects
class String
  def meets_header?(policies)
    policies.evaluate_header_policy_on_file_path_in(self)
  end
  def meets_git?(policies)
    policies.evaluate_git_policy_on_file_path_in(self)
  end
end



class FilePolicies
  attr_accessor :last_failure

  def add_remapped_file(file_path, extension)
    @remap_hash[file_path] = extension
  end

  def evaluate_header_policy_on_file_path_in(file_string)
    if @remap_hash[file_string]
      ext = @remap_hash[file_string]
    else
      ext = (file_string =~ /([^.\/]+)(\..+)$/) ? $2 : ""
    end

    @templates.inject(true) do |boolean_product,t|
      boolean_product &&
        ( (not t.apply_to_extension?(ext))       ||
               t.match_file?(file_string, self)     )
    end
  end

  GIT_FILESTRING_DECODER = /^([0-9a-fA-F]+) (.+)$/
  def git_file(file_string)
    file_string =~ GIT_FILESTRING_DECODER
    return $2
  end
  def evaluate_git_policy_on_file_path_in(file_string)
    file_string =~ GIT_FILESTRING_DECODER
    commit, path = $1, $2
    `git diff --quiet #{commit} #{path}`
    unless $?.exitstatus == 0
      @last_failure =
        "has changed since git commit number #{commit}, but should not have."
    end

    $?.exitstatus == 0
  end

  def initialize
    @last_failure = ""
    @remap_hash = {}
    @templates = []
    Files.template_files.each do |file|
      @templates <<= HeaderMatcher.new(file)
    end
  end
end

