# WontoMedia - a wontology web application
# Copyright (C) 2009 - Glen E. Ivey
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


class FileExceptions

  EXCEPTIONS_FILE = File.join("policy", "copyright-notice-exceptions")

   # basic structure:  in the initialize() method (below) we read in,
   # parse, and process the "root" EXCEPTIONS_FILE and anything that
   # it "!source"s.  We keep the results of that in our internal
   # state, and return different parts of it in response to all of the
   # simple methods, immediately below.

  def exception_definition_files
    @exception_definition_files
  end

  def files_excepted_from_header_checks
    @header_exceptions
  end

  def files_included_in_git_checks
    @git_includes
  end

  def initialize(policies)
    @exception_definition_files = []
    @header_exceptions = []
    @git_includes = []
    @policies = policies
    process_an_exceptions_file(EXCEPTIONS_FILE)
  end

private

  def process_an_exceptions_file(file_name)
    @exception_definition_files <<= file_name

    commit = nil
    input_file = File.new(file_name)
    if input_file.nil? then return nil; end
    input_file.readlines.each do |line|
      line = Files.denormalize_path(line)

      if line =~ /^\s*$/ || line =~ /^\s*#/
        # blank/comment: do nothing

      elsif line =~ /^\s*!source\s+(\S+)\s*$/
        exceptions_file = $1
        more_exceptions = process_an_exceptions_file(exceptions_file)
        if more_exceptions.nil?
          STDERR.puts "WARNING: Could not read file !source'ed exceptions " +
            "file '#{exceptions_file}'"
        end

      elsif line =~ /^\s*!unlock/
        commit = nil

      elsif line =~ /^\s*!lock\s+([0-9a-fA-F]+)\s*$/
        commit = $1 # hex num, but leave as string; avoid formatting later

      elsif line =~ /^\s*!treat\s+(\S+)\s+!as\s+(\.\S+)/
        file_path = $1
        extension = $2
        @header_exceptions <<= file_path
        @policies.add_remapped_file(file_path, extension)

      else # must be a path/name/pattern
        # exclude all files, from any directory, that match this line
        matches = Dir.glob( File.join("**", line.chomp), File::FNM_DOTMATCH ).
          reject { |path| File.directory?(path) }

        # exclude all files *under* any directory matching this line
        matches += Dir.glob( File.join("**", line.chomp, "**", "*"),
                             File::FNM_DOTMATCH ).
          reject { |path| File.directory?(path) }

        # we're never going to do a content check on matching file(s)
        @header_exceptions += matches
        # but we might have to check git if match is '!lock'ed
        if commit
          matches.each do |path|
            @git_includes <<= "#{commit} #{path}"
          end 
        end
      end
    end

    "not nil"
  end
end
