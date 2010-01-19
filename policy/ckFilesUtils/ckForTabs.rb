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


@failCount = 0
@tabFail   = false
@eofFail   = false
@wsFail    = false
@policies   = FilePolicies.new
exceptions = FileExceptions.new(@policies)

def tabFailure(file)
  return if @tabFail
  STDERR.puts "Source files must not contain TAB characters:"
  STDERR.puts "  File '#{file}'"
  @failCount += 1
  @tabFail = true
end

def eofFailure(file)
  return if @eofFail
  STDERR.puts "Source files must not end without a newline:"
  STDERR.puts "  File '#{file}'"
  @failCount += 1
  @eofFail = true
end

def wsFailure(file, line)
  unless @wsFail
    STDERR.puts "Source files must not contain white space at end of lines:"
  end
  STDERR.puts "  File '#{file}', line #{line}"
  @failCount += 1
  @wsFail = true
end


files_for_header_check  = Files.all_files_in_this_tree
files_for_header_check -= exceptions.files_excepted_from_header_checks
files_for_header_check -= exceptions.binary_files
files_for_header_check -= exceptions.symbolic_links
files_for_header_check.each do |file|
  @tabFail   = false
  @eofFail   = false
  @wsFail    = false

  file_lines = File.new(file).readlines
  last_line = file_lines[-1]
  file_str = file_lines.join

  if file_str =~ /\t/m
    tabFailure(file)
  end
  unless last_line =~ /\n$/m
    eofFailure(file)
  end
  file_lines.each_with_index do |line, lineNo|
    if line =~ /\s\n$/
      wsFailure(file, lineNo+1)
    end
  end
end

exit @failCount
