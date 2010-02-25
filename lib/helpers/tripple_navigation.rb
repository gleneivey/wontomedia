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


# This module contains methods for navigating through (walking) the
# inheritence hierarchy between the properties of connections.  They
# allow callers to make queries about a property, and receive answers
# that take into account the 'sub_property_of' relationships between
# the immediately queried property and the property inheritance tree.
module TrippleNavigation

  # This method finds all existing PropertyItem's that are super
  # properties of the PropertyItem identified by +predicate_id+.  The
  # immediate super properties of an item are the objects of any
  # connection of the form "item sub_property_of object".  The set of
  # super properties found by this method includes immediate super
  # properties and all of _their_ super properties.  This method
  # accepts a block, and iteratively yields _its original argument_
  # and the _IDs_ of the argument property's super properties to that
  # block.
  def self.relation_and_all_superproperties(predicate_id, &block)
    yield predicate_id

    spo_id = Item.find_by_name("sub_property_of").id
    connections = Connection.all( :conditions => [
      "subject_id = ? AND predicate_id = ?", predicate_id, spo_id ])
    connections.each do |e|
      relation_and_all_superproperties(e.obj_id, &block)
    end
  end

  # This method finds all existing PropertyItem's that are sub
  # properties of the PropertyItem identified by +predicate_id+.  The
  # immediate sub properties of an item are the subjects of any
  # connection of the form "subject sub_property_of item".  The set of
  # sub properties found by this method includes immediate sub
  # properties and all of _their_ sub properties.  This method accepts
  # a block, and iteratively yields _its original argument_ and the
  # _IDs_ of the argument property's sub properties to that block.
  def self.relation_and_all_subproperties(predicate_id, &block)
    yield predicate_id

    spo_id = Item.find_by_name("sub_property_of").id
    connections = Connection.all( :conditions => [
      "predicate_id = ? AND obj_id = ?", spo_id, predicate_id ])
    connections.each do |e|
      relation_and_all_subproperties(e.subject_id, &block)
    end
  end

  # This method tests for chains of relationships between
  # PropertyItem's.  Its parameters are packaged in a single hash
  # argument.  The value of each entry in the hash is the _ID_ of an
  # Item in the database.  It returns a boolean that answers the
  # "question" phrased in the parameter hash.
  #
  # Currently, there are two supported combinations of argument
  # symbols:
  #
  # * <tt>:does</tt> xxxx <tt>:inherit_from</tt> xxxx <tt>:via</tt> xxxx
  # * <tt>:does</tt> xxxx <tt>:link_to</tt> xxxx <tt>:through_children_of</tt> xxxx
  #
  # Both of these combinations form a question, the answer to which is
  # in the boolean returned by this method (+true+ for yes).  The
  # symbols used to index the argument hash are:
  #
  # [:does] The value in the hash associated with <tt>:does</tt> is the ID of the Item for which the caller is querying the connections stored in the database.
  # [:inherit_from] The value in the hash associated with <tt>:inherit_from</tt> is the ID of a PropertyItem (different from the <tt>:does</tt> Item) in the database.  check_properties() will test for the presence of specific connections between this PropertyItem and the one specified by <tt>:does</tt>.
  # [:via] The value in the hash associated with <tt>:via</tt> is the ID of the PropertyItem that must be present as the predicate of a connection for that connection to "count" toward establishing a chain of connections from the <tt>:does</tt> item to the <tt>:inherit_from</tt> item.  Note that <tt>:via</tt> is directional:  When <tt>:inherit_from</tt> is used, only connections where the <tt>:does</tt> item is the subject, the <tt>:inherit_from</tt> is the object, and all intervening connections "point" in that same direction will be tested, and this method will return <tt>true</tt> only when a chain of connections using the <tt>:via</tt> PropertyItem as their predicates can be found.
  # [:link_to] The value in the hash associated with <tt>:link_to</tt> is the ID of another Item, to which check_properties will try to find a chain of connections from the <tt>:does</tt> Item.  Note that unlike calls to check_properties using <tt>:inherit_from</tt>, when <tt>:link_to</tt> is used the starting and ending items can be of any type, not just PropertyItems.
  # [:through_children_of] The value in the hash associated with <tt>:through_children_of</tt> is the ID of a PropertyItem.  check_properties attempts to find a chain of connections between the other two Item parameters (in either direction) where the connections use the <tt>:through_children_of</tt> PropertyItem _or_ any PropertyItem that is a _child_ of the specified PropertyItem through the built-in <tt>sub_property_of</tt> relationship.  Unlike calls using <tt>:inherit_from</tt>, when checking <tt>:link_to</tt> connections present in either direction between the items found in a chain can produce a <tt>true</tt> result.
  def self.check_properties(hash_of_params)
    unless hash_of_params.has_key?(:does)
      raise ArgumentError, "Expected :does in input hash"
    end

    if hash_of_params.has_key?(:inherit_from)
      # TODO: ':via' is *almost* always a reference to
      # sub_property_of.  Change this method and refactor callers so
      # that when :via isn't present, it defaults to s_p_o.  (If we
      # keep asking ActiveRecord to find_by_name(s_p_o), will it be
      # cached or a huge performance hit?  Experiment and if
      # A.R. really goes to the database each time, have a static
      # variable here so that we only have to fetch from the db the
      # first time.)
      unless hash_of_params.has_key?(:via)
        raise ArgumentError, "Expected :via in input hash"
      end

      child_id = hash_of_params[:does]
      parent_id = hash_of_params[:inherit_from]
      via_property_id = hash_of_params[:via]
      # treat "self" as a form of inheritence
      if child_id == parent_id
        return true
      end

      connections = Connection.all( :conditions => [
        "subject_id = ? AND predicate_id = ?", child_id, via_property_id ])
      connections.each do |e|
        if check_properties(
            :does         => e.obj_id,
            :inherit_from => parent_id,
            :via          => via_property_id )
          return true
        end
      end
    elsif hash_of_params.has_key?(:link_to)
      unless hash_of_params.has_key?(:through_children_of)
        raise ArgumentError, "Expected :through_children_of in input hash"
      end

      from_item_id = hash_of_params[:does]
      to_item_id   = hash_of_params[:link_to]
      kind_of_path = hash_of_params[:through_children_of]
      spo_id       = Item.find_by_name("sub_property_of").id

      connections = Connection.all( :conditions =>
        [ "subject_id = ?", from_item_id ])
      connections.each do |e|
        if check_properties(
            :does         => e.predicate_id,
            :inherit_from => kind_of_path,
            :via          => spo_id )
          if e.obj_id == to_item_id
            return true
          else
            if check_properties(
                :does                => e.obj_id,
                :link_to             => to_item_id,
                :through_children_of => kind_of_path )
              return true
            end
          end
        end
      end
    else
      raise ArgumentError, "Expected :inherit_from or :link_to in input hash"
    end
    return false
  end
end
