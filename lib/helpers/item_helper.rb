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


class ItemHelper
  ITEM_KLASS_NAME            = "Item"
  ITEM_CATEGORY_KLASS_NAME   = "CategoryItem"
  ITEM_INDIVIDUAL_KLASS_NAME = "IndividualItem"
  ITEM_PROPERTY_KLASS_NAME   = "PropertyItem"
  ITEM_QUALIFIED_KLASS_NAME  = "QualifiedItem"

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

  def self.find_typed_item(*args)
    n = Item.find(*args)
    if n.nil?                                  ||
       n.sti_type.nil?                         ||
       ITEM_SUBTYPES_FROM_TEXT[n.sti_type].nil?
      return nil
    end

    klass = case n.sti_type
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
#    ITEM_SUBTYPES_FROM_TEXT[n.sti_type].find(*args)
    klass.find(*args)
  end

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
    klass = case type_string
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
#    klass = ITEM_SUBTYPES_FROM_TEXT[type_string]
    k = klass.new(*args)
    k.flags = 0
    k
  end

  def self.item_to_hash(n)
      # again, I ought to be able to make the list programatically....
    { :id => n.id, :name => n.name, :title => n.title, :flags => n.flags,
      :description => n.description, :sti_type => n.sti_type }
  end

  def self.nouns
    CategoryItem.all + IndividualItem.all
  end
  def self.not_qualified
    CategoryItem.all + IndividualItem.all + PropertyItem.all
  end
end
