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

class NodesShowHelperTest < ActionView::TestCase
  test "generate self-node name text" do
    name = "test_node"
    @node = Node.new( :name => name, :title => "a test node")
    @node.save
    @node_hash= {}
    @node_hash[@node.id] = @node

    assert name == self_string_or_other_link(@node.id)
  end

  test "generate link to other node including name text" do
    name = "one_node"
    n = Node.new( :name => name, :title => "one test node")
    @node = Node.new( :name => "another_node", :title => "another test node")
    n.save; @node.save
    @node_hash= {}
    @node_hash[n.id] = n
    @node_hash[@node.id] = @node

    assert "<a href=\"#{node_path(n)}\">#{name}</a>" ==
      self_string_or_other_link(n.id)
  end
end
