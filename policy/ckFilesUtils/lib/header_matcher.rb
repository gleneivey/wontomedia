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


class HeaderMatcher

  HEADER    = 'header'
  FOOTER    = 'footer'
  NOTICE    = 'notice'
  REF_TYPES = [ HEADER, FOOTER, NOTICE ]

  def initialize(file_name)
    name = Files.normalize_path(file_name)
    if name =~ /([^.\/]+)(\..+)$/
      @type = $1
      @extension = $2
    elsif file_name =~ /([^.\/]+)$/
      @type = $1
      @extension = ""
    else
      STDERR.puts "ERROR: can't parse name of policy reference file '#{file_name}'"
      exit -1
    end

    unless REF_TYPES.include?(@type)
      STDERR.puts "ERROR: don't know how to use policy reference file '#{file_name}'"
      exit -2
    end

    @name = file_name
    f = File.new(@name)
    if f.nil? then return nil; end
    lines = f.readlines
    @count = lines.length
    @content = lines.join
  end

  def apply_to_extension?(ext)
    ext == @extension
  end

  def match_file?(path, policy)
    file_str =
      case @type
      when NOTICE
        File.new(path).readlines.join
      when HEADER
        f = File.new(path)
        (1..(4 + @count)).collect{ f.gets }.join
      when FOOTER
        a = File.new(path).readlines
        to = a.length
        from = to - (4 + @count)
        if from < 0 then from = 0 end
        a[from..to].join
      else
        STDERR.puts "ERROR: attempt to process unknown reference file type" +
                    " for '#{path}'.  type=#{@type} ext=#{@extension}"
        exit 1
      end

    if file_str.index(@content).nil?
      policy.last_failure = "should contain a block matching the " +
        "header template #{@name}, but doesn't."
      false
    else
      true
    end
  end
end

