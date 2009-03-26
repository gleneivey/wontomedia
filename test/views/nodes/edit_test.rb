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



require 'test_helper'

class NodesEditViewTest < ActionController::TestCase
  tests NodesController

  test "should have edit form for nodes" do
    get :edit, :id => nodes(:one).id
    assert_template "nodes/edit"
  end
    
  test "nodes edit form should invoke create" do
    get :edit, :id => nodes(:one).id
    assert_select   "form[action=?]", @controller.url_for(:action => :update, :only_path => true) do
      assert_select "form[method=post]", true,
        "new-node form uses POST"
      assert_select "input#node_name[type=text]", true,
        "new-node form contains 'text' field for :name attribute"
      assert_select "input#node_title[type=text]", true,
        "new-node form contains 'text' field for :title attribute"
      assert_select "textarea#node_description", true,
        "new-node form contains 'textarea' field for :description attribute"
    end
  end

  test "empty nodes edit form shouldnt contain status" do
    get :edit, :id => nodes(:one).id
    assert_select "body", { :text => /error/i, :count => 0 },
      "Page cannot say 'error'"
    assert_select "body", { :text => /successfully created/i, :count => 0 },
      "Page cannot say 'successfully created'"
#    assert_select "body", { :text => /warranty/i, :count => 0 },
#      "Page cannot say 'warranty'"
  end    
end
