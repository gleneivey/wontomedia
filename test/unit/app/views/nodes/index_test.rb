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

class NodesIndexViewTest < ActionController::TestCase
  tests NodesController

  test "should have index page for nodes" do
    get :index
    assert_template "nodes/index"
  end

  test "should show Name of known node" do
    get :index
    assert_select "body", /#{nodes(:one).name}/
  end

  test "should show Title of known node" do
    get :index
    assert_select "body", /#{nodes(:one).title}/
  end

  test "should show Description of known node" do
    get :index
    assert_select "body", /#{nodes(:one).description}/
  end

  test "nodes index page shouldnt contain status" do
    get :index
    assert_negative_view_contents
  end

  test "nodes index page should have and only have right edit destroy links" do
    get :index

    Node.all.each do |node|
      if node.sti_type == "ReiffiedNode"
        # nodes representing reiffied edges aren't listed
        assert_select "body", { :text => node.name, :count => 0 }
      else
        # other node types all listed
        assert_select "body", /#{node.name}/

        test_sense = (node.flags & Node::DATA_IS_UNALTERABLE) == 0

        # edit link present/absent
        assert_select( "*##{node.name} a[href=\"#{edit_node_path(node)}\"]",
          test_sense   )
        # delete link present/absent
        # (attribute check is very Rails specific and a little sloppy, alas...)
        assert_select(
          "*##{node.name} a[href=\"#{node_path(node)}\"][onclick*=\"delete\"]",
          test_sense   )
      end
    end
  end
end
