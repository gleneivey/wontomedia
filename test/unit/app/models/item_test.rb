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

class ItemTest < ActiveSupport::TestCase
  test "item model exists" do
    assert Item.new
  end

  test "item has name and title properties" do
    name = "nAME.-_:"
    title = "Item's title"
    n = Item.new(:name => name, :title =>  title)
    assert n
    assert_equal name, n.name
    assert_equal title, n.title
    assert n.save
  end

  test "item has description property" do
    description = "description"
    n = Item.new( :name => "name", :title => "Item's title",
                  :description => description)
    assert n
    assert_equal description, n.description
    assert n.save
  end

  test "default value for items flags is 0" do
    n = Item.new( :name => "fu", :title => "bar")
    assert n.flags == 0
  end

  test "can set item flags on creation" do
    value = 42
    n = Item.new( :name => "fu", :title => "bar", :flags => value)
    assert n.flags == value
  end

  test "flag values of sample builtin items are correct" do
    n = Item.find_by_name("sub_property_of")
    assert n.flags == Item::DATA_IS_UNALTERABLE
  end


          # verify existence/correctness of :name validations
  test "item name is required" do
    n = Item.new(:name => "", :title => "Item's title",
      :description => "description")
    assert !n.save
  end

  test "item name cant begin with a number" do
    n = Item.new(:name => "42item", :title => "Item's title",
      :description => "description")
    assert !n.save
  end

  test "item name cant include white space" do
    ["\t", "\n", " "].each do |bad|
      n = Item.new(:name => "bad#{bad}Bad", :title => "Item's title",
        :description => "description")
      assert !n.save, "Failed on :#{bad}: character"
    end
  end

  test "item name cant include most punctuation" do
    ["~", "`", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")",
     "+", "=", "{", "}", "[", "]", "|", "\\", ";", "\"", "'",
     ",", "<", ">", "?", "/"].each do |bad|
      n = Item.new(:name => "bad#{bad}Bad", :title => "Item's title",
        :description => "description")
      assert !n.save, "Failed on punctuation #{bad}"
    end
  end

  test "item names must be unique" do
    name = items(:one).name
    n = Item.new(:name => name, :title => "title", :description => "desc")
    assert !n.save
  end

  test "item names can be 80 characters long" do
    n = Item.new(:title => "long name item", :description => "long", :name =>
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" )
    assert n.save
  end

  test "item names cannot be 81 characters long" do
    n = Item.new(:title => "long name item", :description => "long", :name =>
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX" )
    assert !n.save
  end

  test "item titles can be 255 characters long" do
    title = 'x'*255
    n = Item.new(:name => "name", :title => title, :description => "long" )
    assert n.save
  end

  test "item titles cannot be 256 characters long" do
    title = 'x'*256
    n = Item.new(:name => "name", :title => title, :description => "long" )
    assert !n.save
  end

  test "item descriptions can be 65,000 characters long" do
    desc = 'x'*65000
    n = Item.new(:name => "name", :title => "title", :description => desc )
    assert n.save
  end

  test "item names cannot be 65,001 characters long" do
    desc = 'x'*65001
    n = Item.new(:name => "name", :title => "title", :description => desc )
    assert !n.save
  end


          # verify existence/correctness of :title validations
  test "item title is required" do
    n = Item.new(:name => "item", :title => "", :description => "description")
    assert !n.save
  end

  test "item title cant include non-space white space" do
    ["\t", "\n"].each do |bad|
      n = Item.new(:name => "goodName", :title => "But bad#{bad}title",
                   :description => "description")
      assert !n.save, "Failed on :#{bad}: character"
    end
  end
end
