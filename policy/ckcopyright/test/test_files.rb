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


require File.join(File.dirname(__FILE__),'spec_helper')
require 'files'


describe Files, "when retrieving file names" do
  it "should return all files, no directories" do
    y = ["a", "x", "aFile.rb"] # pretend files
    x = [".", ".." ].concat y  # plus real directories
    Dir.should_receive(:glob).
      with(File.join("**", "*"), File::FNM_DOTMATCH).
      and_return(x)

    Files.all_files_in_this_tree.should == y
  end
end

describe Files, "when retrieving template file names" do
  it "should return all files" do
    Dir.should_receive(:glob).with(Files::TEMPLATE_FILES_PATH).
      and_return(@sample_template_files)

    Files.template_files.should == @sample_template_files
  end
end
