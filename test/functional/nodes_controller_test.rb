# WontoMedia -- a wontology web application
# Copyright (C) 2009 -- Glen E. Ivey
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

class NodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "new form should have fresh node object" do
    get :new
    node = assigns(:node)
    assert_not_nil node
    assert_nil node.name
    assert_nil node.title
    assert_nil node.description
  end

  test "should create node" do
    assert_difference('Node.count') do
      post :create, :node => { }
    end
    assert_redirected_to node_path(assigns(:node))
  end

  test "should show node" do
    id = nodes(:one).id
    get :show, :id => id
    assert_response :success
    node = assigns(:node)
    assert_not_nil node
    assert_equal id, node.id
  end
end
