# WontoMedia - a wontology web application
# Copyright (C) 2010 - Glen E. Ivey
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

  test "should show Title of subject node for known edge" do
    get :index
    assert_select "body", /#{regex_escape Edge.first.subject.title}/
  end

  test "should show Title of predicate node for known edge" do
    get :index
    assert_select "body", /#{regex_escape Edge.last.predicate.title}/
  end

  test "should show Title of object node for known edge" do
    get :index
    assert_select "body", /#{regex_escape Edge.all[1].obj.title}/
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

  test "should have Show link for a known edge" do
    get :index
    edge = Edge.all[2]
    assert_select "*##{edge.id} a[href=\"#{edge_path(edge)}\"]", true
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

  def regex_escape(inStr)    # trivial, just what we need for the seed data
    inStr.sub!( /\(/, "\\(" );
    inStr.sub!( /\)/, "\\)" );
    inStr
  end
end
