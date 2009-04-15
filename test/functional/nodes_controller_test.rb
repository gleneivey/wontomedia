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

class NodesControllerTest < ActionController::TestCase
  test "should get homepage" do
    get :home
    assert_response :success
    assert_not_nil assigns(:nouns)
  end

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

  test "should create node with valid data" do
    name = "nodeName"
    assert_difference('Node.count') do
      post :create, :node => { :name => name, :title => "title",
                               :type => "ClassNode" }
    end
    assert_redirected_to node_path(assigns(:node))
    assert_not_nil Node.find_by_name(name)
  end

  test "should not create node without a type" do
    name = "nodeName"
    assert_no_difference('Node.count') do
      post :create, :node => { :name => name, :title => "title" }
    end
    assert_response :success
    assert_template "nodes/new"
    assert_select "body", /Could not/
  end

  test "should not create node with invalid data" do
    assert_no_difference('Node.count') do
      post :create, :node => { :name => "name", :title => "ti\ttle",
                               :type => "ItemNode" }
    end
    assert_response :success
    assert_template "nodes/new"
    assert_select "body", /error/
  end

  # specific validation tests here because these restrictions are
  # enforced by the controller -- "." and ":" are allowed by the model
  # because they're used in internally-generated node names
  test "should not create a node with a name including a period" do
    assert_no_difference('Node.count') do
      post :create, :node => { :name => "na.me", :title => "title",
                               :type => "ClassNode" }
    end
    assert_response :success
    assert_template "nodes/new"
    assert_select "body", /error/
  end
  test "should not create a node with a name including a colon" do
    assert_no_difference('Node.count') do
      post :create, :node => { :name => "na:me", :title => "title",
                               :type => "ItemNode" }
    end
    assert_response :success
    assert_template "nodes/new"
    assert_select "body", /error/
  end

  test "should show node" do
    assert_controller_behavior_with_id :show
  end

  test "should get edit node page" do
    assert_controller_behavior_with_id :edit
  end

  test "should update node" do
    n, h = prep_for_update(:one)
    h[:name] = new_name = "two"
    assert_no_difference('Node.count') do
      put :update, :id => n.id, :node => h
    end
    assert_redirected_to node_path(assigns(:node))
    assert_not_nil Node.find_by_name(new_name)
  end

  # validation tests here because these restrictions are enforced by
  # the controller -- "." and ":" are allowed by the model because
  # they're used in internally-generated node names
  test "should not update node if name changed to include a period" do
    n, h = prep_for_update(:one)
    h[:name] = "na.me"
    assert_no_difference('Node.count') do
      put :update, :id => n.id, :node => h
    end
    assert_response :success
    assert_template "nodes/edit"
    assert_select "body", /error/
  end
  test "should not update node if name changed to include a colon" do
    n, h = prep_for_update(:one)
    h[:name] = "na:me"
    assert_no_difference('Node.count') do
      put :update, :id => n.id, :node => h
    end
    assert_response :success
    assert_template "nodes/edit"
    assert_select "body", /error/
  end

  test "should delete node" do
    name = nodes(:one).name
    assert_difference('Node.count', -1) do
      delete :destroy, :id => nodes(:one).id
    end
    assert_redirected_to nodes_path
    assert_nil Node.find_by_name(name)
  end


private
  def prep_for_update(fixture_name)
    n = nodes(fixture_name)
    return n, NodeHelper.node_to_hash(n)
  end

  def assert_controller_behavior_with_id(action)
    id = nodes(:one).id
    get action, :id => id
    assert_response :success
    node = assigns(:node)
    assert_not_nil node
    assert_equal id, node.id
  end
end
