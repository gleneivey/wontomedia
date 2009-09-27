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

class NodesNewpopViewTest < ActionController::TestCase
  tests NodesController

  test "should have new-popup form for nodes" do
    get :newpop
    assert_template "nodes/newpop"
  end

  test "nodes new-popup form should invoke create" do
    get :new
    assert_select   "form[action=?]",
        @controller.url_for(:action => :create, :only_path => true) do
      assert_select "select#node_sti_type", true,
        "new-popup-node form contains 'select' control for :sti_type attribute"
      assert_select "input#node_name[type=text]", true,
        "new-popup-node form contains 'text' field for :name attribute"
      assert_select "input#node_title[type=text]", true,
        "new-popup-node form contains 'text' field for :title attribute"
      assert_select "textarea#node_description", true,
        "new-popup-node form contains 'textarea' field for :description attribute"
    end
  end

  test "nodes new form shouldnt contain status" do
    get :new
    assert_negative_view_contents
  end
end
