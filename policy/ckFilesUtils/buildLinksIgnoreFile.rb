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


# ASSUME the following:
#  * we're being run from rake, and therefore we can count on the
#    working directory when we start to be the top of the source tree
#    that we're supposed to check

File.open( File.join( ".git", "info", "exclude"), "w" ) do |exclude_file|
  Dir[File.join( "**", "*" )].each do |possible_file|
    if File.symlink?( possible_file )
      exclude_file.puts possible_file
    end
  end
end
