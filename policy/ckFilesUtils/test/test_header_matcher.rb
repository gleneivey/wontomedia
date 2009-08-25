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
require 'header_matcher'


describe HeaderMatcher, "when processing a template file" do
  it "should read the template file" do
    f = "policy/copyright-headers/header.h"
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return( [ "fu\n" ] )
    File.should_receive(:new).with(f).
      and_return(mock_file)
    HeaderMatcher.new(f)
  end

  it "should handle templates with empty extensions" do
    f = "policy/copyright-headers/footer"
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return( [ "fu\n" ] )
    File.should_receive(:new).with(f).and_return(mock_file)
    HeaderMatcher.new(f)
  end

  it "should object if a template file of unknown type is found" do
    STDERR.should_receive(:puts).with(/ERROR/)
    exit_count = 0

    begin
      HeaderMatcher.new("policy/copyright-headers/bad-file.extension")
    rescue SystemExit
      exit_count += 1
    end

    exit_count.should == 1
  end

  it "should remember the template's type (extension)" do
    f = "policy/copyright-headers/notice.txt"
    mock_file = mock("Mock-File")
    mock_file.stub!(:readlines).and_return( [ "fu\n" ] )
    File.should_receive(:new).with(f).and_return(mock_file)

    hm = HeaderMatcher.new(f)
    hm.apply_to_extension?(".txt").should be_true
    hm.apply_to_extension?(".rm").should be_false
  end
end


describe HeaderMatcher, "when matching a file to a template" do
  it "should match a header at the top of the file" do
    t = "policy/copyright-headers/header.rb"
    s = "fu/bar/code.rb"

    # template file
    mock_template = mock("Template")
    mock_template.stub!(:readlines).and_return( [ "one line\n", "two line\n" ] )
    File.should_receive(:new).with(t).and_return(mock_template)

    # target file
    mock_target = mock("Source")
    mock_target.stub!(:gets).and_return( "one line\n", "two line\n",
      "red line\n", "blue line\n", nil, nil, nil, nil, nil, nil )
    File.should_receive(:new).with(s).and_return(mock_target)

    hm = HeaderMatcher.new(t)
    hm.apply_to_extension?(".rb").should be_true
    hm.match_file?(s, nil).should be_true
  end

  it "should match a header starting in the first five lines of a file" do
    t = "policy/copyright-headers/header.html"
    s = "fu/bar/page.html"

    # template file
    mock_template = mock("Template")
    mock_template.stub!(:readlines).and_return( [ "one line\n", "two line\n" ] )
    File.should_receive(:new).with(t).and_return(mock_template)

    # target file
    mock_target = mock("Source")
    mock_target.stub!(:gets).and_return( "a line\n", "b line\n", "c line\n",
     "d line\n", "one line\n", "two line\n", "red line\n", "blue line\n" )
    File.should_receive(:new).with(s).and_return(mock_target)

    hm = HeaderMatcher.new(t)
    hm.apply_to_extension?(".html").should be_true
    hm.match_file?(s, nil).should be_true
  end

  it "should not match a header starting beyond the 5th line" do
    t = "policy/copyright-headers/header.js"
    s = "fu/bar/script.js"

    # template file
    mock_template = mock("Template")
    mock_template.stub!(:readlines).and_return( [ "one line\n", "two line\n" ] )
    File.should_receive(:new).with(t).and_return(mock_template)

    # target file
    mock_target = mock("Source")
    mock_target.stub!(:gets).and_return( "a line\n", "b line\n", "c line\n",
     "d line\n", "e line\n", "one line\n", "two line\n",
     "red line\n", "blue line\n" )
    File.should_receive(:new).with(s).and_return(mock_target)

    mock_policy = mock("Policy")
    mock_policy.should_receive(:last_failure=)
    hm = HeaderMatcher.new(t)
    hm.apply_to_extension?(".js").should be_true
    hm.match_file?(s, mock_policy).should be_false
  end

  it "should match a footer at the bottom of the file" do
    t = "policy/copyright-headers/footer.feature"
    s = "fu/bar/behavior.feature"

    # template file
    mock_template = mock("Template")
    mock_template.stub!(:readlines).and_return( [ "one line\n", "two line\n" ] )
    File.should_receive(:new).with(t).and_return(mock_template)

    # target file
    mock_target = mock("Source")
    mock_target.stub!(:readlines).and_return( [ "red line\n", "blue line\n",
      "one line\n", "two line\n" ] )
    File.should_receive(:new).with(s).and_return(mock_target)

    hm = HeaderMatcher.new(t)
    hm.apply_to_extension?(".feature").should be_true
    hm.match_file?(s, nil).should be_true
  end




  it "should match a footer ending in the last five lines of a file" do
    t = "policy/copyright-headers/footer.doc"
    s = "fu/bar/text.doc"

    # template file
    mock_template = mock("Template")
    mock_template.stub!(:readlines).and_return( [ "one line\n", "two line\n" ] )
    File.should_receive(:new).with(t).and_return(mock_template)

    # target file
    mock_target = mock("Source")
    mock_target.stub!(:readlines).and_return( [ "red line\n", "blue line\n",
      "one line\n", "two line\n", "a line\n", "b line\n",
       "c line\n", "d line\n" ] )
    File.should_receive(:new).with(s).and_return(mock_target)

    hm = HeaderMatcher.new(t)
    hm.apply_to_extension?(".doc").should be_true
    hm.match_file?(s, nil).should be_true
  end

  it "should not match a footer ending before the last five lines" do
    t = "policy/copyright-headers/footer.xyz"
    s = "fu/bar/file.xyz"

    # template file
    mock_template = mock("Template")
    mock_template.stub!(:readlines).and_return( [ "one line\n", "two line\n" ] )
    File.should_receive(:new).with(t).and_return(mock_template)

    # target file
    mock_target = mock("Source")
    mock_target.stub!(:readlines).and_return( [ "red line\n", "blue line\n",
      "one line\n", "two line\n", "a line\n", "b line\n",
       "c line\n", "d line\n", "e line\n" ] )
    File.should_receive(:new).with(s).and_return(mock_target)

    mock_policy = mock("Policy")
    mock_policy.should_receive(:last_failure=)
    hm = HeaderMatcher.new(t)
    hm.apply_to_extension?(".xyz").should be_true
    hm.match_file?(s, mock_policy).should be_false
  end
end
