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

class EdgesShowViewTest < ActionController::TestCase
  tests EdgesController
  def get_edges_show() get :show, :id => edges(:aReiffiedEdge).id; end

  test "should have show page for edges" do
    get_edges_show
    assert_template "edges/show"
  end

  test "edge-show page should contain edge's subject Node's title" do
    get_edges_show
    assert_select "body", /#{edges(:aReiffiedEdge).subject.title}/
  end

  test "edge-show page should contain edge's predicate Node's title" do
    get_edges_show
    assert_select "body", /#{edges(:aReiffiedEdge).predicate.title}/
  end

  test "edge-show page should contain edge's object Node's title" do
    get_edges_show
    assert_select "body", /#{edges(:aReiffiedEdge).obj.title}/
  end

  test "edges show page shouldnt contain status" do
    get_edges_show
    assert_negative_view_contents
  end    

  test "edges show page should have and only have right edit destroy links" do
    Edge.all.each do |edge|
      get :show, :id => edge.id

      test_sense = (edge.flags & Edge::DATA_IS_UNALTERABLE) == 0

      # edit link present/absent
      assert_select( "a[href=\"#{edit_edge_path(edge)}\"]", test_sense )
      # delete link present/absent
      assert_select(
        "a[href=\"#{edge_path(edge)}\"][onclick*=\"delete\"]", test_sense )
    end
  end
end
