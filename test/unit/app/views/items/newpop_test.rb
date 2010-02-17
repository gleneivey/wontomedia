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



require 'test_helper'

class ItemsNewpopViewTest < ActionController::TestCase
  tests ItemsController

  test "should have new-popup form for items" do
    get :newpop
    assert_template "items/newpop"
  end

  test "items new-popup form should invoke create" do
    get :new
    assert_select   "form[action=?]",
        @controller.url_for(:action => :create, :only_path => true) do
      assert_select "select#item_sti_type", true,
        "new-popup-item form contains 'select' control for :sti_type attribute"
      assert_select "input#item_name[type=text]", true,
        "new-popup-item form contains 'text' field for :name attribute"
      assert_select "input#item_title[type=text]", true,
        "new-popup-item form contains 'text' field for :title attribute"
      assert_select "textarea#item_description", true,
        "new-popup-item form contains 'textarea' field for :description attribute"
    end
  end

  test "items new form shouldnt contain status" do
    get :new
    assert_negative_view_contents
  end
end
