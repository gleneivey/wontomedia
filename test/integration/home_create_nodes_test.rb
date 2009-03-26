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


require "#{File.dirname(__FILE__)}/test_helper"

class HomeThroughCreateTest < ActionController::IntegrationTest
  test "home through create" do
    # start at home page
    visit "/"
    assert_response :success,
      "home page GET failed"

    # follow "new node" link on home page to nodes-new form
    click_link "New node"
    assert_response :success,
      "nodes-new form GET failed"

    # post the node-new form, expect to arrive at node-show page
    fill_in "name",        :with => "nodeB"
    fill_in "title",       :with => "Test node"
    fill_in "description", :with =>
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    click_button "Create"
    assert_response :success,
      "nodes-create POST failed"
    assert_match %r%/nodes/[0-9]+%, path,
      "New node creation didn't end up at nodes-show page"

    # check node-show page contents:
    assert_contain "nodeB"
    assert_contain "Test node"
    assert_contain "Lorem ipsum dolor sit"

    # to node-index page, new content there too?
    visit "/nodes"
    assert_response :success,
      "node-index page GET failed"
    assert_contain "nodeB"
  end
end
