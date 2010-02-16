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
require Rails.root.join( 'app', 'helpers', 'format_helper' )
include(FormatHelper)


class NodesShowHelperTest < ActionView::TestCase
  test "generate self-node title text" do
    title = "a test node"
    name  = "test_node"
    @node = Node.new( :name => name, :title => title)
    @node.save
    @node_hash= {}
    @node_hash[@node.id] = @node

    result = self_string_or_other_link(@node.id)
    assert /#{title}/ =~ result
    assert /#{name}/  =~ result
    assert /href/     =~ result
  end

  test "generate link to other node including title text" do
    title = "one test node"
    name = "one_node"
    n = Node.new( :name => name, :title => title )
    @node = Node.new( :name => "another_node", :title => "another test node")
    n.save; @node.save
    @node_hash= {}
    @node_hash[n.id] = n
    @node_hash[@node.id] = @node

    result = self_string_or_other_link(n.id)
    assert /#{title}/ =~ result
    assert /#{name}/  =~ result
    assert /href/     =~ result
  end
end
