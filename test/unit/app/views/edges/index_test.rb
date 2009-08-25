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

class EdgesIndexViewTest < ActionController::TestCase
  tests EdgesController

  test "should have index page for edges" do
    get :index
    assert_template "edges/index"
  end

  test "should show Name of subject node for known edge" do
    get :index
    assert_select "body", /#{Edge.first.subject.name}/
  end

  test "should show Name of predicate node for known edge" do
    get :index
    assert_select "body", /#{Edge.last.predicate.name}/
  end

  test "should show Name of object node for known edge" do
    get :index
    assert_select "body", /#{Edge.all[1].obj.name}/
  end

  test "should show Name of self node for known edge" do
    get :index
    e = Edge.first(:conditions => "edge_desc_id IS NOT NULL")
    assert_select "body", /#{e.edge_desc.name}/
  end

  test "nodes index page shouldnt contain status" do
    get :index
    assert_negative_view_contents
  end

  test "edges index page should have and only have right edit destroy links" do
    get :index

    Edge.all.each do |edge|
      test_sense = (edge.flags & Edge::DATA_IS_UNALTERABLE) == 0

      # edit link present/absent
      assert_select( "*##{edge.id} a[href=\"#{edit_edge_path(edge)}\"]",
        test_sense   )
      # delete link present/absent
      assert_select(
        "*##{edge.id} a[href=\"#{edge_path(edge)}\"][onclick*=\"delete\"]",
        test_sense   )
    end
  end
end
