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
require Rails.root.join( 'lib', 'helpers', 'node_helper' )

class NodesEditViewTest < ActionController::TestCase
  tests NodesController

  test "should have edit form for nodes" do
    get :edit, :id => nodes(:one).id
    assert_template "nodes/edit"
  end
    
  test "nodes edit form should invoke update" do
    n= nodes(:one)
    class_string = NodeHelper::NODE_SUBTYPES_TO_CLASSNAME[n.class]
    get :edit, :id => n.id
    assert_select   "form[action=?]", @controller.url_for(:action => :update, :only_path => true) do
      assert_select "form[method=post]", true,
        "edit-node form uses POST"
      assert_select "input##{class_string}_node_name[type=text]", true,
        "edit-node form contains 'text' field for :name attribute"
      assert_select "input##{class_string}_node_title[type=text]", true,
        "edit-node form contains 'text' field for :title attribute"
      assert_select "textarea##{class_string}_node_description", true,
        "edit-node form contains 'textarea' field for :description attribute"
    end
  end

  test "empty nodes edit form shouldnt contain status" do
    get :edit, :id => nodes(:one).id
    assert_negative_view_contents
  end    
end
