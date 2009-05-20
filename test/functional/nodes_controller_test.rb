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
                               :sti_type => "ClassNode" }
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
                               :sti_type => "ItemNode" }
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
                               :sti_type => "ClassNode" }
    end
    assert_response :success
    assert_template "nodes/new"
    assert_select "body", /error/
  end
  test "should not create a node with a name including a colon" do
    assert_no_difference('Node.count') do
      post :create, :node => { :name => "na:me", :title => "title",
                               :sti_type => "ItemNode" }
    end
    assert_response :success
    assert_template "nodes/new"
    assert_select "body", /error/
  end

  test "should show node" do
    assert_controller_behavior_with_id :show
    assert_not_nil assigns(:edge_list)
    assert_not_nil assigns(:edge_hash)
    assert_not_nil assigns(:node_hash)
  end

  test "should show first edge for node with value" do
    n = nodes(:testSubcategory)
    get :show, :id => n.id

    e = edges(:subcategoryHasValue)
    assert assigns(:node_hash)[e.predicate_id]
    assert assigns(:node_hash)[e.obj_id]

    array_of_arrays = assigns(:edge_list)
    assert array_of_arrays.length >= 1
    array_of_value_edges = array_of_arrays.delete_at(0)
    assert array_of_value_edges.length >= 1
    assert array_of_value_edges.include? e.id
  end

  test "should correctly group/sort is-subject edges" do
    n = nodes(:nodeUsedFrequentlyAsSubject)
    get :show, :id => n.id

    # given content of test/fixtures/edges.yml, expect edge_list as follows:
    # [[2 value edges], [3 peer_of edges], [2 successor_of eges], [2 random]]
    edge_list = assigns(:edge_list)
    assert edge_list.length == 4
    value_edge_array,
      peer_edge_array,
      successor_edge_array,
      random_edge_array = *edge_list

    assert value_edge_array.length == 2
    assert value_edge_array.include? edges(:nUFAS_value_A).id
    assert value_edge_array.include? edges(:nUFAS_isAssigned_B).id

    assert peer_edge_array.length == 3
    assert peer_edge_array.include? edges(:nUFAS_peer_of_X).id
    assert peer_edge_array.include? edges(:nUFAS_peer_of_Y).id
    assert peer_edge_array.include? edges(:nUFAS_peer_of_Z).id

    assert successor_edge_array.length == 2
    assert successor_edge_array.include? edges(:nUFAS_successor_of_C).id
    assert successor_edge_array.include? edges(:nUFAS_successor_of_D).id

    assert random_edge_array.length == 2
    assert random_edge_array.include? edges(:nUFAS_predecessor_of_E).id
    assert random_edge_array.include? edges(:nUFAS_child_of_M).id
  end

  test "should correctly group is-object edges" do
    n = nodes(:nodeUsedFrequentlyAsObject)
    get :show, :id => n.id

    # given content of test/fixtures/edges.yml, expect edge_list as follows:
    # [[6 edge IDs, sorted (primarily) by edge's predicate ]]
    edge_list = assigns(:edge_list)
    assert edge_list.length == 1
    edges = edge_list.first
    assert edges.length == 6
    assert edges.include? edges(:a_isAssigned_nUFAO).id
    assert edges.include? edges(:b_isAssigned_nUFAO).id
    assert edges.include? edges(:c_isAssigned_nUFAO).id
    assert edges.include? edges(:d_isAssigned_nUFAO).id
    assert edges.include? edges(:e_isAssigned_nUFAO).id
    assert edges.include? edges(:c_peer_of_nUFAO).id
    # minimal sort-order test
    assert Edge.find(edges.first).predicate_id !=
             Edge.find(edges.last).predicate_id
  end

  test "should show all predicate edges in last group" do
    n = Node.find_by_name("sub_property_of")
    get :show, :id => n.id

    # this time, check built-in "seed" schema.  Lots o' items use sub_prop_of
    # edge_list should look like: [ ... [many edges]]
    edge_list = assigns(:edge_list)
    assert edge_list.length >= 1
    edges = edge_list.last
    assert edges.length >= 19
    # and check some representative items
    spo_id = Node.find_by_name("sub_property_of").id
    assert edges.include? Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?", spo_id, spo_id,
        Node.find_by_name("hierarchical_relationship").id ]).id
    assert edges.include? Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        Node.find_by_name("contains").id, spo_id,
        Node.find_by_name("parent_of").id ]).id
    assert edges.include? Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        Node.find_by_name("successor_of").id, spo_id,
        Node.find_by_name("ordered_relationship").id ]).id
    assert edges.include? Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        nodes(:isAssigned).id, spo_id,
        Node.find_by_name("value_relationship").id ]).id
    assert edges.include? Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        nodes(:B).id, spo_id, nodes(:C).id ]).id
    assert edges.include? Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        nodes(:B).id, spo_id, nodes(:Z).id ]).id
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
