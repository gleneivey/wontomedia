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
    item = Item.new(:name => name, :title =>  title)
    assert item
    assert_equal name, item.name
    assert_equal title, item.title
    assert item.save
  end

  test "item has description property" do
    description = "description"
    item = Item.new( :name => "name", :title => "Item's title",
                     :description => description )
    assert item
    assert_equal description, item.description
    assert item.save
  end


  test "item can set and save class_item property" do
    class_item = items(:testClass)
    item = Item.new( :name => "name", :title => "Item's title",
                     :class_item => class_item )
    assert item
    assert_equal class_item, item.class_item
    assert_equal class_item.id, item.class_item.id
    assert item.save
    assert Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      item.id,
      Item.find_by_name('is_instance_of').id,
      class_item.id ] )
  end

  test "modifying item_s class_item property updates connections" do
    name = 'testInstance'
    item = items(name.to_sym)
    test_class = items(:testClass)
    another_class = items(:anotherClass)

    assert item.class_item_id == test_class.id
    item.class_item = another_class
    item.save
    assert item = Item.find_by_name(name)
    assert item.class_item_id == another_class.id

    # out with the old
    assert_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      item.id,
      Item.find_by_name('is_instance_of').id,
      test_class.id ] )
    # in with the new
    assert Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      item.id,
      Item.find_by_name('is_instance_of').id,
      another_class.id ] )
  end

  test "clearing item_s class_item property destroys connection" do
    name = 'testInstance'
    item = items(name.to_sym)

    item.class_item = nil
    item.save
    assert item = Item.find_by_name(name)
    assert item.class_item_id.nil?
    assert_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ?",
      item.id, Item.find_by_name('is_instance_of').id ] )
  end



  test "default value for items flags is 0" do
    item = Item.new( :name => "fu", :title => "bar")
    assert item.flags == 0
  end

  test "can set item flags on creation" do
    value = 42
    item = Item.new( :name => "fu", :title => "bar", :flags => value)
    assert item.flags == value
  end

  test "flag values of sample builtin items are correct" do
    item = Item.find_by_name("sub_property_of")
    assert item.flags == Item::DATA_IS_UNALTERABLE
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



          # class-based interrogators
  test "is_class returns negative results" do
    assert items(:testInstance).is_class? == false         # 'nil' doesn't pass
  end

  test "is_class positively identifies is_instance_of object" do
    assert items(:impliedClass).is_class?
  end

  test "is_class positively identifies sub_class_of object" do
    assert Item.find_by_name('Item_Class').is_class?
  end

  test "is_class positively identifies sub_class_of subject" do
    assert items(:testClass).is_class?
  end

  test "superclass_of returns correct if present" do
    assert items(:anotherClass).superclass_of.id ==
      Item.find_by_name('Item_Class').id
  end

  test "superclass_of returns nil if none" do
    assert_nil items(:impliedClass).superclass_of
  end
end
