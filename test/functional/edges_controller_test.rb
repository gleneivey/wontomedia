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

class EdgesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edges)
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:nouns)
    assert_not_nil assigns(:verbs)
  end

  test "new form should have fresh edge object" do
    get :new
    edge = assigns(:edge)
    assert_not_nil edge
    assert_nil edge.subject_id
    assert_nil edge.predicate_id
    assert_nil edge.obj_id
    assert_nil edge.edge_desc_id
  end

  test "should create edge with valid data" do
    s_id = nodes(:testContainer).id
    p_id = Node.find_by_name("parent_of").id
    o_id = nodes(:testItem).id

    assert_difference('Edge.count') do
      post :create, :edge => { :subject_id => s_id, :predicate_id => p_id,
                               :obj_id => o_id }
    end
    assert_redirected_to edge_path(assigns(:edge))
    assert_not_nil Edge.find(assigns(:edge).id)
  end

  test "should not create an edge if missing an element of triple" do
    s_id = nodes(:testContainer).id
    o_id = nodes(:testItem).id

    assert_no_difference('Edge.count') do
      post :create, :edge => { :subject_id => s_id, :obj_id => o_id }
    end
    assert_response :success
    assert_template "edges/new"
    assert_select "body", /Predicate can't be blank/
  end

  test "show edge should populate data" do
    id = edges(:aReiffiedEdge).id
    get :show, :id => id
    assert_response :success
    assert edge = assigns(:edge)
    assert edge.id == id

    assert s = assigns(:subject)
    assert p = assigns(:predicate)
    assert o = assigns(:obj)
    assert slf = assigns(:edge_desc)

    assert s == edge.subject
    assert p == edge.predicate
    assert o == edge.obj
    assert slf == edge.edge_desc
  end

  test "should get edit edge page" do
    id = edges(:aReiffiedEdge).id
    get :edit, :id => id
    assert_response :success
    edge = assigns(:edge)
    assert_not_nil edge
    assert_equal id, edge.id
  end

  test "should update edge" do
    e = edges(:aParentEdge)
    e.obj_id = nodes(:A).id
    h = { :id => e.id, :subject_id => e.subject_id,
      :predicate_id => e.predicate_id, :obj_id => e.obj_id }
    assert_no_difference('Edge.count') do
      put :update, :id => e.id, :edge => h
    end
    assert_redirected_to edge_path(assigns(:edge))
    assert_not_nil Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      e.subject_id, e.predicate_id, e.obj_id   ])
  end

  test "should delete edge" do
    e = edges(:aReiffiedEdge)
    subj_id = e.subject_id; pred_id = e.predicate_id; obj_id = e.obj_id
    assert_difference('Edge.count', -1) do
      delete :destroy, :id => e.id
    end
    assert_redirected_to edges_path
    assert_nil Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_id, pred_id, obj_id   ])
  end
end
