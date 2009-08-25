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
require 'file_exceptions'


describe FileExceptions, "when processing exception files" do
  it "should tolerate missing default exception file" do
    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(nil)
    FileExceptions.new(nil)
  end

  it "should read the default exception file" do
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return( [ "a\n", "b\n", "c\n" ] )
    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(mock_file)
    FileExceptions.new(nil)
  end

  context "should report the default exception file" do
    it "whether it exists" do
      mock_file = mock("Mock-File")
      mock_file.stub!(:readlines).and_return( [ "a\n", "b\n", "c\n" ] )
      File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
        and_return(mock_file)

      ex = FileExceptions.new(nil)
      ex.exception_definition_files.should == [FileExceptions::EXCEPTIONS_FILE]
    end

    it "or doesn't exist" do
      File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
        and_return(nil)

      ex = FileExceptions.new(nil)
      ex.exception_definition_files.should == [FileExceptions::EXCEPTIONS_FILE]
    end
  end

  it "should read additional files in '!source' directives" do
    xf = "xfile"; yf = "ydir/zfile"
    file_root = mock("Root-Exception")
    file_root.stub!(:readlines).and_return( [
"a\n",
"\n",
"!source #{xf}\n",
"# this is a comment\n",
"b\n",
"    	\n",
"!source #{yf}\n",
"c\n" ] )
    file_x = mock("Exception-X")
    file_x.stub!(:readlines).and_return( [ "d\n", "e\n" ] )
    file_z = mock("Exception-Y")
    file_z.stub!(:readlines).and_return( [ "f\n", "g\n" ] )

    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(file_root)
    File.should_receive(:new).with(xf).
      and_return(file_x)
    File.should_receive(:new).with(yf).
      and_return(file_z)

    ex = FileExceptions.new(nil)
    ex.exception_definition_files.should == [ FileExceptions::EXCEPTIONS_FILE,
                                              xf, yf ]
  end

  it "should warn on missing !source'ed exception file" do
    file_root = mock("Root-Exception")
    file_root.stub!(:readlines).and_return( [ "!source missing.file\n" ] )

    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(file_root)
    File.should_receive(:new).with("missing.file").
      and_return(nil)

    STDERR.should_receive(:puts).with(/WARN.+missing.file/)
    FileExceptions.new(nil)
  end


  it "should pass !treat'ed files to policy object" do
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return(
      [ "!treat ruby_script !as .rb\n" ] )
    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(mock_file)

    mock_policy = mock("Mock-FilePolicies-Object")
    mock_policy.should_receive(:add_remapped_file).with("ruby_script", ".rb")

    FileExceptions.new(mock_policy)
  end

  # return platform-specific path
  def n(canonical_path)
    components = canonical_path.split('/')
    File.join(components)
  end

  it "should add !lock'ed files to git_checks list" do
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return( [
"a\n",
"!lock    6ac5825b85a2fd5a2cf9ae8bf4f24586e4a0b7e3\n",
"b\n",
"c/d/e.rb\n",
"!lock	d6865e2d0348cf0bcd928eec0c8aac98dbc6fbbd\n",
"f-dir\n",
"g.html\n",
"!source more-exceptions\n",
"i/j.js\n",
"!unlock\n",
"k\n" ] )
    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(mock_file)

    mock_source = mock("Mock-Sourced-File")
    mock_source.stub!(:readlines).and_return( [ "fu-file\n" ] )
    File.should_receive(:new).with("more-exceptions").and_return(mock_source)

    # we expect FileExceptions to do the following:
    #    Dir.glob( File.join("**", line.chomp), File::FNM_DOTMATCH )
    #    Dir.glob( File.join("**", line.chomp, "**", "*"), File::FNM_DOTMATCH )
    # for each path-like line in the exceptions file(s), so
    x = File::FNM_DOTMATCH
    Dir.should_receive(:glob).with(n("**/a"), x).and_return(
      [ "fu/a", "bar/a" ])
    Dir.should_receive(:glob).with(n("**/a/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/b"), x).and_return(["b"])
    Dir.should_receive(:glob).with(n("**/b/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/c/d/e.rb"), x).and_return(["x/c/d/e.rb"])
    Dir.should_receive(:glob).with(n("**/c/d/e.rb/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/f-dir"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/f-dir/**/*"), x).and_return(
      [ ".", "..", "f-dir/p", "f-dir/q", "f-dir/r" ])
    Dir.should_receive(:glob).with(n("**/g.html"), x).and_return(["g.html"])
    Dir.should_receive(:glob).with(n("**/g.html/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/fu-file"), x).and_return(
      ["fu/fu-file"])  #note: !lock does *not* affect !source'ed files
    Dir.should_receive(:glob).with(n("**/fu-file/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/i/j.js"), x).and_return(["i/j.js"])
    Dir.should_receive(:glob).with(n("**/i/j.js/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/k"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/k/**/*"), x).and_return(
      [ ".", "..", "k/l.m"])


    ex = FileExceptions.new(nil)
    ex.files_included_in_git_checks.sort.should == [
      "6ac5825b85a2fd5a2cf9ae8bf4f24586e4a0b7e3 b",
      "6ac5825b85a2fd5a2cf9ae8bf4f24586e4a0b7e3 x/c/d/e.rb",
      "d6865e2d0348cf0bcd928eec0c8aac98dbc6fbbd f-dir/p",
      "d6865e2d0348cf0bcd928eec0c8aac98dbc6fbbd f-dir/q",
      "d6865e2d0348cf0bcd928eec0c8aac98dbc6fbbd f-dir/r",
      "d6865e2d0348cf0bcd928eec0c8aac98dbc6fbbd g.html",
      "d6865e2d0348cf0bcd928eec0c8aac98dbc6fbbd i/j.js"
    ].sort
  end

  it "should add exception files to header-check exception list" do
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return( [
"z\n",
"!lock    6ac5825b85aAAAAAAAA9ae8bf4f24586e4a0b7e3\n",
"y\n",
"x/w/v.rb\n",
"!lock	d686FFFFFFFFcf0bcd928eec0c8aac98dbc6fbbd\n",
"u-dir\n",
"t.html\n",
"!source more-exceptions\n",
"s/r.js\n",
"!unlock\n",
"q\n" ] )
    File.should_receive(:new).with(FileExceptions::EXCEPTIONS_FILE).
      and_return(mock_file)

    mock_source = mock("Mock-Sourced-File")
    mock_source.stub!(:readlines).and_return( [ "fu.file" ] )
    File.should_receive(:new).with("more-exceptions").and_return(mock_source)

    x = File::FNM_DOTMATCH
    Dir.should_receive(:glob).with(n("**/z"), x).and_return(
      exp1 = [ "bar/z", "foo/z" ])
    Dir.should_receive(:glob).with(n("**/z/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/y"), x).and_return(exp2 = ["y"])
    Dir.should_receive(:glob).with(n("**/y/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/x/w/v.rb"), x).and_return(
      exp3 = ["xx/x/w/v.rb"])
    Dir.should_receive(:glob).with(n("**/x/w/v.rb/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/u-dir"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/u-dir/**/*"), x).and_return(
      [ ".", ".." ] + (exp4 = [ "u-dir/a", "u-dir/b", "u-dir/c" ]) )
    Dir.should_receive(:glob).with(n("**/t.html"), x).and_return(
      exp5 = ["t.html"])
    Dir.should_receive(:glob).with(n("**/t.html/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/fu.file"), x).and_return(
      exp6 = ["foo/fu.file"])
    Dir.should_receive(:glob).with(n("**/fu.file/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/s/r.js"), x).and_return(
      exp7 = ["s/r.js"])
    Dir.should_receive(:glob).with(n("**/s/r.js/**/*"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/q"), x).and_return([])
    Dir.should_receive(:glob).with(n("**/q/**/*"), x).and_return(
      [ ".", ".." ] + (exp8 = ["q/p.o"]) ); 

    ex = FileExceptions.new(nil)
    ex.files_excepted_from_header_checks.sort.should ==
      (exp1 + exp2 + exp3 + exp4 + exp5 + exp6 + exp7 + exp8).sort
  end
end
