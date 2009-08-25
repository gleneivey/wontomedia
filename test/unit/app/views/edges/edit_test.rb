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

class EdgesEditViewTest < ActionController::TestCase
  tests EdgesController

  test "should have edit form for edges" do
    get :edit, :id => edges(:aReiffiedEdge).id
    assert_template "edges/edit"
  end

  test "edges edit for should invoke update" do
    e = edges(:aSpoB)
    get :edit, :id => e.id

    assert_select   "form[action=?]", @controller.
        url_for(:action => :update, :only_path => true) do

      assert_select "form[method=post]", true, "edit-edge form uses POST"
      assert_select "select#edge_subject_id", true,
        "edit-edge form contains 'select' control for :subject"
      assert_select "select#edge_predicate_id", true,
        "edit-edge form contains 'select' control for :predicate"
      assert_select "select#edge_obj_id", true,
        "edit-edge form contains 'select' control for :obj"
    end
  end

  test "fresh edges edit form shouldnt contain status" do
    get :edit, :id => edges(:aParentEdge).id
    assert_negative_view_contents
  end
end
