#!/usr/bin/ruby

# WontoMedia - a wontology web application
# Copyright (C) 2010 - Glen E. Ivey
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


$:.unshift File.join( File.dirname(__FILE__) )
require 'lib/files'
require 'lib/file_exceptions'
require 'lib/header_matcher'
require 'lib/file_policies'


# ASSUME the following:
#  * we're being run from rake, and therefore we can count on the
#    working directory when we start to be the top of the source tree
#    that we're supposed to check
#  * the FilePolicies class knows how to find the exceptions file and
#    the sample header text files


@failCount = 0
@policies   = FilePolicies.new
exceptions = FileExceptions.new(@policies)

def failure(file)
  STDERR.puts "Copyright Policy FAILURE."
  STDERR.puts "  File '#{file}' #{@policies.last_failure}"
  @failCount += 1
end

files_for_header_check  = Files.all_files_in_this_tree
files_for_header_check -= Files.template_files
files_for_header_check -= exceptions.exception_definition_files
files_for_header_check -= exceptions.files_excepted_from_header_checks
files_for_header_check -= exceptions.symbolic_links
files_for_header_check.each do |file|
  unless file.meets_header?(@policies) then failure(file) end
end

exceptions.files_included_in_git_checks.each do |file|
  unless file.meets_git?(@policies) then failure(@policies.git_file(file)) end
end

exit @failCount
