# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
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
require 'file_policies'


describe String, "when FilePolicies is loaded, Strings are file names and" do
  it "should pass header-check calls to FilePolicies instance" do
    f = "a.file"
    mock_policy = mock("Mock-FilePolicies")
    mock_policy.should_receive(:evaluate_header_policy_on_file_path_in).
      with(f).and_return(true)
    f.meets_header?(mock_policy)
  end

  it "should pass git-check calls to FilePolicies instance" do
    f = "a.file"
    mock_policy = mock("Mock-FilePolicies")
    mock_policy.should_receive(:evaluate_git_policy_on_file_path_in).
      with(f).and_return(false)
    f.meets_git?(mock_policy)
  end
end


describe FilePolicies, "when loading policy information" do
end


describe FilePolicies, "when evaluating policies for files" do
  it "should have no errors to report before first policy test" do
    policy = FilePolicies.new
    policy.last_failure.should == ""
  end
end


