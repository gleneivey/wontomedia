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
  def get_nodes_show(name)
    n = nodes(name)
    get :show, :id => n.id
    n
  end

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

  test "node-show page should contain node-edit link" do
    n = get_nodes_show(:two)
    assert_select "a[href=?]", edit_node_path(n)
  end

  test "node-show page should contain node-delete link" do
    n = get_nodes_show(:two)
    assert_select "a[href=?]", node_path(n) #sloppy, should verify :method
  end

  test "node-show page should contain nodes-index link" do
    n = get_nodes_show(:two)
    assert_select "a[href=?]", nodes_path
  end

  test "node-show page should contain edges-new link" do
    n = get_nodes_show(:two)
    assert_select "a[href=?]", new_edge_path
  end

  test "node-show page should contain names & links of each edge's nodes" do
    [ nodes(:one),                          # aReiffiedEdge
      nodes(:testCategory),
      nodes(:testSubcategory),              # subcategoryHasValue
      nodes(:isAssigned)
    ].each do |n|
      get_nodes_show(:testItem)
      assert_select "body", /#{n.name}/
      assert_select "a[href=?]", node_path(n)
    end
  end

  test "node-show page should contain links for edges" do
    [ edges(:aReiffiedEdge),
      edges(:subcategoryHasValue)
    ].each do |e|
      get_nodes_show(:testItem)
      assert_select "a[href=?]", edit_edge_path(e)
      assert_select "a[href=?]", edge_path(e)
    end
  end

  test "node-show page should have and only have correct edit destroy links" do
    Node.all.each do |node|

      if node.sti_type != "ReiffiedNode"
        get :show, :id => node.id

        # other node types all listed
        assert_select "body", /#{node.name}/

        test_sense = (node.flags & Node::DATA_IS_UNALTERABLE) == 0

        # edit link present/absent
        assert_select( "a[href=\"#{edit_node_path(node)}\"]",
          test_sense   )
        # delete link present/absent
        # (attribute check is very Rails specific and a little sloppy, alas...)
        assert_select(
          "a[href=\"#{node_path(node)}\"][onclick*=\"delete\"]",
          test_sense   )
      end
    end
  end

  test "node-show page's edge list should h-o-h correct per-edge links" do
    Node.all.each do |node|

      if node.sti_type != "ReiffiedNode"
        get :show, :id => node.id

        edges = Edge.all( :conditions => [ "subject_id = ?", node.id ])        +
                Edge.all( :conditions => [ "predicate_id = ?", node.id ])      +
                Edge.all( :conditions => [ "obj_id = ?", node.id ])
        edges.each do |edge|
          test_sense = (edge.flags & Edge::DATA_IS_UNALTERABLE) == 0

          # edit link present/absent
          assert_select( "a[href=\"#{edit_edge_path(edge)}\"]", test_sense )
          # delete link present/absent
          assert_select(
            "a[href=\"#{edge_path(edge)}\"][onclick*=\"delete\"]", test_sense )
        end
      end
    end
  end
end
