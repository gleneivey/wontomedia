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

class NodesShowViewTest < ActionController::TestCase
  tests NodesController
  def get_nodes_show(name) get :show, :id => nodes(name).id; end

  test "should have show page for nodes" do
    get_nodes_show(:one)
    assert_template "nodes/show"
  end

  test "node-show page should contain node name" do
    get_nodes_show(:one)
    assert_select "body", /#{nodes(:one).name}/
  end

  test "node-show page should contain node title" do
    get_nodes_show(:one)
    assert_select "body", /#{nodes(:one).title}/
  end

  test "node-show page should contain node description" do
    get_nodes_show(:one)
    assert_select "body", /#{nodes(:one).description}/
  end

  test "nodes show page shouldnt contain status" do
    get_nodes_show(:one)
    assert_negative_view_contents
  end    
end
