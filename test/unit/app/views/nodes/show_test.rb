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

  def get_nodes_show_json(name, sti_type)
    n = nodes(name)
    get :show, :id => n.id, :format => 'json'
    return n, ActiveSupport::JSON.decode(@response.body)[sti_type + "_node"]
  end

  test "should have show HTML page for nodes" do
    get_nodes_show(:one)
    assert_template "nodes/show"
  end

  test "node-show HTML page should contain node name" do
    n = get_nodes_show(:one)
    assert_select "body", /#{n.name}/
  end

  test "node-show HTML page should contain node title" do
    n = get_nodes_show(:one)
    assert_select "body", /#{n.title}/
  end

  test "node-show HTML page should contain node description" do
    n = get_nodes_show(:one)
    assert_select "body", /#{n.description}/
  end

  test "nodes show HTML page shouldnt contain status" do
    get_nodes_show(:one)
    assert_negative_view_contents
  end

  test "nodes show JSON response should contain node name" do
    n, j = get_nodes_show_json(:one, "item")
    assert j["name"] == n.name,
      "Expected response Name '#{j['name']}' to match node's #{n.name}"
  end

  test "nodes show JSON response should contain node title" do
    n, j = get_nodes_show_json(:one, "item")
    assert j["title"] == n.title,
      "Expected response Title '#{j['title']}' to match node's #{n.title}"
  end

  test "nodes show JSON response should contain node description" do
    n, j = get_nodes_show_json(:one, "item")
    assert j["description"] == n.description,
      "Expected response Description '#{j['description']}' to " +
        "match node's #{n.description}"
  end


        # all following are tests of the HTML page

  test "node-show page should contain node-edit link" do
    n = get_nodes_show(:two)
    assert_select "a[href=?]", edit_node_path(n)
  end

  test "node-show page 4 unused nodes should contain node-delete link" do
    n = get_nodes_show(:two)
    assert_select "a[href=?]", node_path(n) #sloppy, should verify :method
  end

  test "node-show page 4 in-use nodes should contain cant-delete-node link" do
    n = get_nodes_show(:one)
    assert_select "a[href=\"#\"][onclick*=\"cantDelete\"]"
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
        assert_select( "a[href=\"#{edit_node_path(node)}\"]", test_sense )

        # delete link present/absent
        node_not_in_use =
          Edge.all( :conditions =>
                    [ "subject_id = ? OR predicate_id = ? OR obj_id = ?",
                      node.id, node.id, node.id ]).
            empty?
        assert_select(
          "a[href=\"#{node_path(node)}\"][onclick*=\"delete\"]",
          test_sense && node_not_in_use )
        assert_select(
          "a[href=\"#\"][onclick*=\"cantDelete\"]",
          test_sense && !node_not_in_use )
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
