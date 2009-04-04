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


# So, the basic flow for this comparison program is as follows:
#  - make array of all files in source tree
#  - remove reference files themselves from array
#
#  - process copyright-notice-exceptions file
#   - if line blank, starts with "#", do nothing
#   - if /^!lock/, store commit number
#   - if /^!unlock/, clear commit number
#   - else
#    - glob file name to array
#    - if no commit number (not currently locked)
#     - allFilesArray-= currentArray
#    - else, foreach file in currentArray
#     - FAIL if "git diff current file v. file@locked commit" has output
#
#  - iterate over the files in 'policy/copyright-notices/'
#      > build an array of filename-matching patterns
#      > read each reference file, get a line count, store as a string
#
#  - foreach still in allFilesArray
#   - if file extension doesn't match 1+ reference file, do nothing
#   - for each matching reference file, do
#    - case "header" reference
#     - read first (5+length of ref file) lines from target
#     - concatentate lines to string
#    - case "footer" reference
#     - read all lines from target
#     - concatenate last (5+length of ref file) lines to string
#    - case "notice" reference
#     - read all lines from target
#     - concatenate all lines to string
#
#    - FAIL if ref string isn't contained within target string
#
# on FAIL: print error message to STDERR; increment counter
# at end, exit with error counter as program status



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

puts "    Matching for #{path}"
puts "  file_str:"
puts file_str
puts "  matcher.string"
puts matcher.string
puts "  compare: #{file_str.index(matcher.string)}"

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
