#--
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
#++


# This module provides a container for methods that manipulate or
# transform Item objects, and constants related to Item objects.  The
# constants are related to the single-table-inheritance structure
# between Item and its specialized child classes, and don't fit into
# any of the individual model classes themselves.
module ItemHelper

  ITEM_CLASS_NAME            = "Item"
  ITEM_CATEGORY_CLASS_NAME   = "CategoryItem"
  ITEM_INDIVIDUAL_CLASS_NAME = "IndividualItem"
  ITEM_PROPERTY_CLASS_NAME   = "PropertyItem"
  ITEM_QUALIFIED_CLASS_NAME  = "QualifiedItem"

  ITEM_SUBTYPES_FROM_TEXT = {
    "item"                 => Item,           "Item"           => Item,
    "category"             => CategoryItem,   "CategoryItem"   => CategoryItem,
    "individual"           => IndividualItem,
      "IndividualItem" => IndividualItem,
    "property"             => PropertyItem,   "PropertyItem"   => PropertyItem,
    "qualified-connection" => QualifiedItem,  "QualifiedItem"  => QualifiedItem
  }
  ITEM_CLASSNAME_TO_SUBTYPE_SHORT = {
    "CategoryItem" => 'category', "IndividualItem" => 'individual',
    "PropertyItem" => 'property', "QualifiedItem" => 'qualified'
  }
  ITEM_SUBTYPES_TO_HUMAN = {
    'CategoryItem' => 'Category',
    'IndividualItem' => 'Individual',
    'PropertyItem' => 'Property Type',
    'QualifiedItem' => 'Qualified Connection'
  }


  # This method is a wrapper for Rails' Item.find(), except that it
  # checks the sti_type of the item found, then creates and returns an
  # instance of the correct Item child class.
  def self.find_typed_item(*args)
    n = Item.find(*args)
    if n.nil?                                  ||
       n.sti_type.nil?                         ||
       ITEM_SUBTYPES_FROM_TEXT[n.sti_type].nil?
      return nil
    end

# I think that this statement:
#    ITEM_SUBTYPES_FROM_TEXT[n.sti_type].find(*args)
# ought to work.  But it doesn't.  So instead, we do the following:
    class_of_item_to_find = case n.sti_type
            when "Item"                 then Item
            when "item"                 then Item
            when "CategoryItem"         then CategoryItem
            when "category"             then CategoryItem
            when "IndividualItem"       then IndividualItem
            when "individual"           then IndividualItem
            when "PropertyItem"         then PropertyItem
            when "property"             then PropertyItem
            when "QualifiedItem"        then QualifiedItem
            when "qualified-connection" then QualifiedItem
            end
    class_of_item_to_find.find(*args)
  end

  # Use this method in place of <tt>new Item</tt> in order to create
  # an Item child class (STI) instance matching a type string you have
  # available.  (Note: if you know when writing a piece of code what
  # item subtype you're trying to create, simply create that directly
  # rather than using this method.  _E.g._, <tt>new
  # PropertyItem</tt>.)
  def self.new_typed_item(type_string, *args)
    if type_string.nil?
      return nil
    end
    if ITEM_SUBTYPES_FROM_TEXT[type_string].nil?
      type_string = type_string.singularize
      if ITEM_SUBTYPES_FROM_TEXT[type_string].nil?
        return nil
      end
    end

# absolutely no idea why this ugly thing works, but simply hash lookup
# below causes failure deep in Rails' guts during new()
    class_of_item_to_create = case type_string
            when "Item"                 then Item
            when "item"                 then Item
            when "CategoryItem"         then CategoryItem
            when "category"             then CategoryItem
            when "IndividualItem"       then IndividualItem
            when "individual"           then IndividualItem
            when "PropertyItem"         then PropertyItem
            when "property"             then PropertyItem
            when "QualifiedItem"        then QualifiedItem
            when "qualified-connection" then QualifiedItem
            end
#    class_of_item_to_create = ITEM_SUBTYPES_FROM_TEXT[type_string]
    new_item = class_of_item_to_create.new(*args)
    new_item.flags = 0
    new_item
  end

  # Takes an Item object, +n+, and returns a symbol-indexed hash
  # containing each of the Item's data fields.
  def self.item_to_hash(item)
# Really ought to be doing this programatically from the schema....
    { :id => item.id, :name => item.name, :title => item.title,
      :flags => item.flags, :description => item.description,
      :sti_type => item.sti_type, :class_item_id => item.class_item_id }
  end

  # Map from an Item.name of a built-in item representing an item type
  # (e.g., is_instance_of ItemType_Item) to the matching internal
  # Item.sti_type string
  def self.sti_type_for_ItemType( type_item_name )
    case type_item_name
      when 'Value_ItemType_Category'   then 'CategoryItem'
      when 'Value_ItemType_Individual' then 'IndividualItem'
      when 'Value_ItemType_Property'   then 'PropertyItem'
      else ''
      end
  end


  # This method is equivalent to Rails' Item.all(), except that it
  # only finds/returns "noun"-type items (Category and Individual
  # items, but not Property or Qualified items).
  def self.nouns
    CategoryItem.all + IndividualItem.all
  end

  # This method is equivalent to Rails' Item.all(), except that it
  # only finds/returns Items with an sti_type other than Qualified.
  def self.not_qualified
    CategoryItem.all + IndividualItem.all + PropertyItem.all
  end
end
