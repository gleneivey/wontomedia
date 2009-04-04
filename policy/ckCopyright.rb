#!/usr/bin/ruby

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


# All of the files in 'policy/copyright-notices/' define content that
# should be present in the other files in the directory tree.  *All*
# files in the directory tree, _except_ for those listed in

EXCEPTIONS_FILE = "copyright-notice-exceptions"

# are compared against one or more of the reference files, based on
# matching target files against references based on name matches.
# There are three recognized "base" names for reference files, each of
# which corresponds to a different matching requirement to the
# reference, as follows:
#
#   header.* -- If a file is matched against this type of reference,
#               then the content of the reference must start within
#               five lines of the BEGINNING of the target file
#
#   footer.* -- Files matched against this type of reference must
#               match with no more than five lines between the end of
#               the matching text and the end of the target file
#
#   notice.* -- Target files matching references of this form simply
#               have to contain the content of the reference at any
#               point in their body

HEADER    = 'header'
FOOTER    = 'footer'
NOTICE    = 'notice'
REF_TYPES = [ HEADER, FOOTER, NOTICE]


# Which target files are matched against which references are
# determined by the file extension.  (File extensions are assumed to
# start with the *first* period in a file name, and can contain
# periods.)  "No extension" (e.g., no periods in the file name) is
# also considered to be a file extension for matching purposes.


# The EXCEPTIONS file may contain blank lines, comments (starting with
# "#"), strings that are file or path names or that are file name
# globs, and directives.  Directives must be the first non-whitespace
# on a line, and all begin with "!".  The four supported directives
# are as follows:
#
#   !source <file name>
#
#
#   !lock <git commit number>
#      This directive instructs ckCopyright that the files specified
#      by the following lines are NOT to be compared to any of the
#      reference files, but instead are to be diff'ed against the Git
#      repository.  A file that is "locked" to a particular Git commit
#      number matches policy if and only if it is identical to the
#      version of that file present as of the specified Git commit.
#      The intention of this mechanism is to handle code importend
#      from third parties or auto-generated, which does not need to
#      have "local" copyright notices unless it is modified as part of
#      our project.
#
#   !unlock
#      This directive ends a group of lines that are associated with
#      the preceeding !lock.  Note that !lock/!unlock do not nest or
#      pair.  Each !lock directive effects the lines that follow it,
#      and each !unlock effects the lines following *it* (causing
#      header-file comparison), regardless of what has come before.
#
#   !treat <file> !as <extension>
#      This directive causes ckCopyright to ignore the named file's
#      actual extension, and to match it against header(s) that
#      correspond to the specified extension (if any).





#!! ASSUME that we're being run from rake, and therefore we can count
#!! on the working directory when we start to be the top of the source
#!! tree that we're supposed to check



@special_files = []

def exclusion_list(file_name)
  exclusions = []
  commit = nil
  File.new(file_name).readlines.each do |line|
    line = normalize_path(line)

    if line =~ /^\s*$/ || line =~ /^\s*#/
      # do nothing
    elsif line =~ /^\s*!source\s+(\S+)\s*$/
      exclusions <<= exclusion_list($1)
    elsif line =~ /^\s*!unlock/
      commit = nil
    elsif line =~ /^\s*!lock\s+([0-9a-fA-F]+)\s*$/
      commit = $1 # hex num, but leave as string so we don't have to format
    elsif line =~ /^\s*!treat\s+(\S+)\s+!as\s+(\.\S+)/
      file_path = $1
      extension = $2
      exclusions    <<= file_path # no expansion, can't be path or glob
      @special_files <<= { :path => file_path, :extension => extension }
    else # must actually be a path/name/pattern
      matches = Dir.glob( File.join("**", line.chomp), File::FNM_DOTMATCH ).
        flatten.reject { |path| File.directory?(path) }
      matches <<= Dir.glob( File.join("**", line.chomp, "**", "*"),
                             File::FNM_DOTMATCH ).
        flatten.reject { |path| File.directory?(path) }
      matches.flatten!

      # we're never going to do a content check on matching file(s)
      exclusions <<= matches
      # but might have to check git if match is 'lock'ed
      if commit
        matches.each do |path|
          `git diff --quiet #{commit} #{path}`
          if $?.exitstatus > 0
            STDERR.puts "Copyright Policy FAILURE.  File '#{path}' has changed since git commit number #{commit}, but should not have according to the policy file #{file_name}."
            @failCount += 1
          end
        end 
      end
    end
  end
  exclusions
end


class Matcher
  attr_reader :type, :line_count, :string, :path
  def initialize(type, line_count, string, path)
    @type, @line_count, @string, @path = type, line_count, string, path
  end
end


def normalize_path(path)
  components = path.split('/')
  File.join(components)
end
def denormalize_path(path)
  components = path.split(File::SEPARATOR)
  components.join("/")
end


@failCount = 0
@ref_matchers = {}

all_files  = Dir.glob( File.join("**", "*"), File::FNM_DOTMATCH ).reject {
  |path| File.directory?(path) }

ref_files  = Dir.glob( File.join("policy", "copyright-notices", "*") )
all_files -= ref_files
all_files -= [ File.join("policy", EXCEPTIONS_FILE) ]

all_files -= exclusion_list( File.join("policy", EXCEPTIONS_FILE) ).flatten
             # note that 'exclusion_list' does git commit-number checks
             # internally; may increment @failCount as a side-effect

ref_extensions = []
ref_files.each do |ref_file|
  ref_lines = File.new(ref_file).readlines
  ref_line_count = ref_lines.length
  ref_string = ref_lines.join

  base = File.basename(denormalize_path(ref_file))
  if    base =~ /^([^.]+)(\..+)$/
    ref_type = $1
    ref_extension = $2
  elsif base =~ /^([^.]+)$/
    ref_type = $1
    ref_extension = ""
  else
    STDERR.puts "ERROR: can't parse name of policy reference file" +
                " '#{ref_file}'"
    exit 1
  end

  unless REF_TYPES.include?(ref_type)
    STDERR.puts "ERROR: don't know how to use policy reference file" +
                " '#{ref_file}'"
    exit 1
  end

  ref_extensions <<= ref_extension unless ref_extensions.include?(ref_extension)
  m = Matcher.new(ref_type, ref_line_count, ref_string, ref_file)
  if @ref_matchers.has_key?(ref_extension)
    @ref_matchers[ref_extension] <<= m
  else
    @ref_matchers[ref_extension] = [ m ]
  end
end




def do_matching_for_file(path, extension)
  if @ref_matchers.has_key?(extension)
    @ref_matchers[extension].each do |matcher|
      file_str = 
        case matcher.type
        when NOTICE
          File.new(path).readlines.join
        when HEADER
          f = File.new(path)
          (1..(5 + matcher.line_count)).collect{ f.gets }.join
        when FOOTER
          a = File.new(path).readlines
          to = a.length
          from = to - (5 + matcher.line_count)
          a[from..to].join
        else
          STDERR.puts "ERROR: attempt to process unknown reference file type" +
                      " for '#{path}'.  type=#{type} ext=#{extension}"
          exit 1
        end

      unless file_str.index(matcher.string)
        STDERR.puts "Copyright Policy FAILURE.  File '#{path}' should contain a block matching the header template #{matcher.path}, but doesn't."
        @failCount += 1
      end
    end
  end
end


all_files.each do |path|
  extension = (path =~ /([^.\/]+)(\..+)$/) ? $2 : ""
  do_matching_for_file(path, extension)
end

@special_files.each do |h|
  do_matching_for_file(h[:path], h[:extension])
end


exit @failCount

