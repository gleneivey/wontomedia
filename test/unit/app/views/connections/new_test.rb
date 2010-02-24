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



class ConnectionsNewViewTest < ActionController::TestCase
  tests ConnectionsController

  test "should have new form for connections" do
    get :new
    assert_template "connections/new"
  end

  test "connections new form should invoke create" do
    get :new
    assert_select   "form[action=?]", @controller.url_for(:action => :create,
                                        :only_path => true) do
      assert_select "form[method=post]", true,
        "connection-new form uses POST"
      assert_select "select#connection_subject_id", true,
"connection-new form contains 'select' input control for :subject attribute"
      assert_select "select#connection_predicate_id", true,
"connection-new form contains 'select' input control for :predicate attribute"
      assert_select "select#connection_obj_id", true,
        "connection-new form contains 'select' input control for :obj attribute"
    end
  end

  test "connections new form shouldnt contain status" do
    get :new
    assert_negative_view_contents
  end
end
