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

class EdgesNewViewTest < ActionController::TestCase
  tests EdgesController

  test "should have new form for edges" do
    get :new
    assert_template "edges/new"
  end
    
  test "edges new form should invoke create" do
    get :new
    assert_select   "form[action=?]", @controller.url_for(:action => :create, :only_path => true) do
      assert_select "form[method=post]", true,
        "edge-new form uses POST"
      assert_select "select#edge_subject_id", true,
        "edge-new form contains 'select' input control for :subject attribute"
      assert_select "select#edge_predicate_id", true,
        "edge-new form contains 'select' input control for :predicate attribute"
      assert_select "select#edge_object_id", true,
        "edge-new form contains 'select' input control for :object attribute"
    end
  end

  test "edges new form shouldnt contain status" do
    get :new
    assert_negative_view_contents
  end    
end
