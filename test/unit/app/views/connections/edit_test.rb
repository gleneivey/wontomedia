# WontoMedia - a wontology web application
# Copyright (C) 2010 - Glen E. Ivey
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



class ConnectionsEditViewTest < ActionController::TestCase
  tests ConnectionsController

  test "should have edit form for connections" do
    get :edit, :id => connections(:aQualifiedConnection).id
    assert_template "connections/edit"
  end

  test "connections edit for should invoke update" do
    e = connections(:aSpoB)
    get :edit, :id => e.id

    assert_select   "form[action=?]", @controller.
        url_for(:action => :update, :only_path => true) do

      assert_select "form[method=post]", true, "edit-connection form uses POST"
      assert_select "select#connection_subject_id", true,
        "edit-connection form contains 'select' control for :subject"
      assert_select "select#connection_predicate_id", true,
        "edit-connection form contains 'select' control for :predicate"
      assert_select "select#connection_obj_id", true,
        "edit-connection form contains 'select' control for :obj"
    end
  end

  test "fresh connections edit form shouldnt contain status" do
    get :edit, :id => connections(:aParentConnection).id
    assert_negative_view_contents
  end
end
