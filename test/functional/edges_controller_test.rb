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


require 'enumerator'
require 'test_helper'

class EdgesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:edges)
  end

  test "sould get N3-format all-edges download/index" do
    get :index, :format => "n3"
    assert @response.header['Content-Type'] =~ /application\/x-n3/

    Edge.all.each do |edge|
      if edge.flags & Edge::DATA_IS_UNALTERABLE == 0
        assert @response.body =~
          /#{edge.subject.name}.+#{edge.predicate.name}.+#{edge.obj.name}/,
          "Expected '#{edge.subject.name}-#{edge.predicate.name}-" +
            "#{edge.obj.name}' edge but didn't find"
      else
        assert !(@response.body =~
          /#{edge.subject.name}.+#{edge.predicate.name}.+#{edge.obj.name}/),
          "Found '#{edge.subject.name}-#{edge.predicate.name}-" +
            "#{edge.obj.name}' edge, but didn't expect"
      end
    end
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:nodes)
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

  test "new form should populate arrays for view" do
    get :new

    # spot-check for presence/absence of one known node of each STI child type
    ns = assigns(:nodes)
    assert   ns.include?( nodes(:testCategory) )
    assert   ns.include?( nodes(:testItem) )
    assert   ns.include?( nodes(:testProperty) )
    assert !(ns.include?( nodes(:edge_one) ))

    vs = assigns(:verbs)
    assert !(vs.include?( nodes(:testCategory) ))
    assert !(vs.include?( nodes(:testItem) ))
    assert   vs.include?( nodes(:testProperty) )
    assert !(vs.include?( nodes(:edge_one) ))
  end

  # possible edge combinations:
  #   class    -- class
  #   class    -- item
  #   item     -- item
  #   item     -- class    [non-hierarchical only]
  #   property -- property [only type that can use "sub_property_of"]
  #   property -- class
  #   property -- item
  #   class    -- property
  #   item     -- property
  # note: checks for rejection of invalid edge cases are in unit//models/edge
  test "should create all valid edges" do
    subj_nodes = [
      nodes(:testCategory), nodes(:testItem), nodes(:testProperty) ]
    obj_nodes  = [
      nodes(:two), nodes(:one), nodes(:isAssigned) ]
    verb_nodes = [
      Node.find_by_name( "parent_of" ),                    # tC -> tC
      Node.find_by_name( "contains" ),                     # tC -> tI
      Node.find_by_name( "hierarchical_relationship" ),    # tC -> tP
      Node.find_by_name( "one_of" ),                       # tI -> tC
      Node.find_by_name( "peer_of" ),                      # tI -> tI
      nodes(             :A ),                             # tI -> tP
      Node.find_by_name( "child_of" ),                     # tP -> tC
      nodes(             :testProperty ),                  # tP -> tI
      Node.find_by_name( "sub_property_of" ),              # tP -> tP
    ]

    verbs = verb_nodes.to_enum
    subj_nodes.each do |subj_node|
      obj_nodes.each do |obj_node|

        assert_difference('Edge.count') do
          post :create, :edge => { :subject_id   => subj_node.id,
                                   :predicate_id => verbs.next.id,
                                   :obj_id       => obj_node.id      }
        end
        assert_redirected_to edge_path(assigns(:edge))
        assert_not_nil Edge.find(assigns(:edge).id)
      end
    end
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

  test "should not update builtin edge" do
    # test define_sub_property_of edge
    subj_n   = Node.find_by_name("sub_property_of")
    obj_n    = Node.find_by_name("hierarchical_relationship")
    change_n = Node.find_by_name("child_of")
    e = Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, subj_n.id, obj_n.id   ])

    before = e
    e.predicate = change_n
    h = { :id => e.id, :subject_id => e.subject_id,
      :predicate_id => e.predicate_id, :obj_id => e.obj_id }

    assert_no_difference('Edge.count') do
      put :update, :id => e.id, :edge => h
    end
    assert assigns(:edge) == e
    assert_redirected_to edge_path(e)
    assert after = Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, subj_n.id, obj_n.id   ])
    assert before == after
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

  test "should not delete builtin edge" do
    # test define_inverse_relationship edge
    subj_n = Node.find_by_name("inverse_relationship")
    pred_n = Node.find_by_name("sub_property_of")
    obj_n  = Node.find_by_name("symmetric_relationship")
    e = Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, pred_n.id, obj_n.id   ])

    assert_difference('Edge.count', 0) do
      delete :destroy, :id => e.id
    end
    assert assigns(:edge) == e
    assert_redirected_to edge_path(e)
    assert after = Edge.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, pred_n.id, obj_n.id   ])
    assert e == after
  end
end
