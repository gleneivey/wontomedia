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

class NodeTest < ActiveSupport::TestCase
  test "node model exists" do
    assert Node.new
  end

  test "node has name and title properties" do
    name = "nAME.-_:"
    title = "Node's title"
    n = Node.new(:name => name, :title =>  title)
    assert n
    assert_equal name, n.name
    assert_equal title, n.title
    assert n.save
  end

  test "node has description property" do
    description = "description"
    n = Node.new( :name => "name", :title => "Node's title",
                  :description => description)
    assert n
    assert_equal description, n.description
    assert n.save
  end

  test "default value for nodes flags is 0" do
    n = Node.new( :name => "fu", :title => "bar")
    assert n.flags == 0
  end

  test "can set node flags on creation" do
    value = 42
    n = Node.new( :name => "fu", :title => "bar", :flags => value)
    assert n.flags == value
  end

  test "flag values of sample builtin nodes are correct" do
    n = Node.find_by_name("sub_property_of")
    assert n.flags == Node::DATA_IS_UNALTERABLE
  end


          # verify existence/correctness of :name validations
  test "node name is required" do
    n = Node.new(:name => "", :title => "Node's title",
                 :description => "description")
    assert !n.save
  end

  test "node name cant begin with a number" do
    n = Node.new(:name => "42node", :title => "Node's title",
                 :description => "description")
    assert !n.save
  end

  test "node name cant include white space" do
    ["\t", "\n", " "].each do |bad|
      n = Node.new(:name => "bad#{bad}Bad", :title => "Node's title",
                   :description => "description")
      assert !n.save, "Failed on :#{bad}: character"
    end
  end

  test "node name cant include most punctuation" do
    ["~", "`", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
     "+", "=", "{", "}", "[", "]", "|", "\\", ";", "\"", "'",
     ",", "<", ">", "?", "/"].each do |bad|
      n = Node.new(:name => "bad#{bad}Bad", :title => "Node's title",
                   :description => "description")
      assert !n.save, "Failed on punctuation #{bad}"
    end
  end

  test "node names must be unique" do
    name = nodes(:one).name
    n = Node.new(:name => name, :title => "title", :description => "desc")
    assert !n.save
  end

  test "node names can be 80 characters long" do
    n = Node.new(:title => "long name node", :description => "long", :name =>
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" )
    assert n.save
  end

  test "node names cannot be 81 characters long" do
    n = Node.new(:title => "long name node", :description => "long", :name =>
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX" )
    assert !n.save
  end

  test "node titles can be 255 characters long" do
    title = 'x'*255
    n = Node.new(:name => "name", :title => title, :description => "long" )
    assert n.save
  end

  test "node titles cannot be 256 characters long" do
    title = 'x'*256
    n = Node.new(:name => "name", :title => title, :description => "long" )
    assert !n.save
  end

  test "node descriptions can be 65,000 characters long" do
    desc = 'x'*65000
    n = Node.new(:name => "name", :title => "title", :description => desc )
    assert n.save
  end

  test "node names cannot be 65,001 characters long" do
    desc = 'x'*65001
    n = Node.new(:name => "name", :title => "title", :description => desc )
    assert !n.save
  end


          # verify existence/correctness of :title validations
  test "node title is required" do
    n = Node.new(:name => "node", :title => "", :description => "description")
    assert !n.save
  end

  test "node title cant include non-space white space" do
    ["\t", "\n"].each do |bad|
      n = Node.new(:name => "goodName", :title => "But bad#{bad}title",
                   :description => "description")
      assert !n.save, "Failed on :#{bad}: character"
    end
  end
end
