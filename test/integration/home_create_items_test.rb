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


require File.join( File.dirname(__FILE__), 'test_helper' )

class HomeThroughCreateTest < ActionController::IntegrationTest
  test "home through create" do
    # start at home page
    visit "/"
    assert_response :success,
      "home page GET failed"

    # follow "new item" link on home page to items-new form
    click_link "New item"
    assert_response :success,
      "items-new form GET failed"

    # post the item-new form, expect to arrive at item-show page
    name = "itemB"
    fill_in "name",        :with => name
    fill_in "title",       :with => "Test item"
    fill_in "description", :with =>
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    select  "Category",    :from => "Type"
    click_button "Create"
    assert_response :success,
      "items-create POST failed"
    assert_match %r%^/#{name}$%, path,
      "New item creation didn't end up at items-show page"
    assert_select "body", /successfully created/


    # check item-show page contents:
    assert_contain "itemB"
    assert_contain "Test item"
    assert_contain "Lorem ipsum dolor sit"

    # to item-index page, new content there too?
    visit "/w/items"
    assert_response :success,
      "item-index page GET failed"
    assert_contain "itemB"
  end
end
