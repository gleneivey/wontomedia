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


require Rails.root.join( 'lib', 'helpers', 'item_helper')
require Rails.root.join( 'lib', 'helpers', 'tripple_navigation')

# Model for the representation of "connections" (which are used to
# make statements about the relationships between "item") in
# WontoMedia's database.  The schema listing the data fields for a
# Connection is, of course, in db/schema.rb.  And Rails'
# automatically-provided model methods are based on the field names
# there.
#
# A great deal of this model's behavior is provided by Rails
# <tt>belongs_to</tt> relations between Connection object fields and
# Item objects (see source).
class Connection < ActiveRecord::Base

  # This constant is a bit mask for Item.flags.  A non-zero value
  # indicates that the Item instance should not be user-modifiable.
  DATA_IS_UNALTERABLE = 1
  OBJECT_KIND_ITEM = 'item'
  OBJECT_KIND_SCALAR = 'scalar'


  # convenience attribute allows item representing a connection's object's
  # type (if specified by a relationship somewhere in the database) to
  # be attached to the connection once it has been looked up once
  attr_accessor :type_item


  before_validation :complex_validations
#  validates_presence_of :subject, :predicate
#explicitly do the equivalent of the above in complex_validations because
#c_v has to be a "before" callback (so it's return value is checked), which
#means other validations aren't run yet, so can't count on these IDs to
#be present/valid.  Ugh.

#  validates_inclusion_of :kind_of_obj, :in => %w(item scalar)
#  validates_uniqueness_of :subject_id, :scope => [:predicate_id, :obj_id]
#these work, but are subsumed by checks in c_v, so eliminated duplication

  belongs_to :subject,   :class_name => "Item"
  belongs_to :predicate, :class_name => "Item"
  belongs_to :obj,       :class_name => "Item"
  belongs_to :connection_desc, :class_name => "Item"



  # This method is a hack to provide a legitimate default value for
  # the +flags+ field of an Item that hasn't been initialized yet.
  # Alternative at http://blog.phusion.nl/2008/10/03/47/
  def flags #:nodoc:
    # Note that the default value returned here must/does match the
    # column default specified in the database schema
    self[:flags] or 0
  end


private

  # This method performs checks to determine whether an individual
  # Connection, if placed in the context of the rest of WontoMedia's
  # database, would violate any rules about the structure of the
  # relationship network.  It is automatically invoked using Rails'
  # <tt>before_validation</tt> hook.  In the event that one or more
  # checks fail, this method returns +false+ and places the
  # appropriate message(s) in the +errors+ flash.
  def complex_validations() #:doc:
    if kind_of_obj == OBJECT_KIND_ITEM
      [ [subject_id, :subject], [predicate_id, :predicate],
        [obj_id, :obj] ].each do |tocheck|
        field, symbol = *tocheck
        if field.nil?
          errors.add symbol, "can't be blank."
          return false
        end
      end

          # is there an existing connection with a predicate that is a
          # sub-property or super-property of the current predicate?
      # check for duplicate connection and all super-properties
      TrippleNavigation.relation_and_all_superproperties(
          predicate_id) do |super_prop|
        unless (Connection.all( :conditions => [
            "subject_id = ? AND predicate_id = ? AND obj_id = ?",
            subject_id, super_prop, obj_id ] ).empty? )
          errors.add :subject, 'relationship (or equivalent) already exists.'
          return false
        end
      end

      # check for sub-properties
      TrippleNavigation.relation_and_all_subproperties(
          predicate_id) do |sub_prop|
        unless (Connection.all( :conditions => [
            "subject_id = ? AND predicate_id = ? AND obj_id = ?",
            subject_id, sub_prop, obj_id ] ).empty? )
          errors.add :subject, 'equivalent relationship already exists.'
          return false
        end
      end


          # is there an existing implied opposing connection?
      # find all connections back-connecting our subject and object, determine
      # if any of their predicates has an (inherited)
      # inverse_relationship to current predicate
      if connections = Connection.all( :conditions => [
          "subject_id = ? AND obj_id = ?", obj_id, subject_id ] )

        inverse_id = Item.find_by_name("inverse_relationship").id

        connections.each do |e|
          TrippleNavigation.relation_and_all_superproperties(
              predicate_id) do |proposed_rel|
            TrippleNavigation.relation_and_all_superproperties(
                e.predicate_id) do |existing_rel|
              if Connection.all( :conditions => [
                "subject_id = ? AND predicate_id = ? AND obj_id = ?",
                  proposed_rel, inverse_id, existing_rel ] ).length > 0
                errors.add :subject, 'already has this relationship implied.'
                return false
              end
            end
          end
        end
      end


      #used in many subsequent tests
      spo_id  = Item.find_by_name("sub_property_of").id


          # would this create an "individual parent_of category" relationship?
      subItem = Item.find(subject_id)
      objItem = Item.find(obj_id)
      # check for "individual parent_of category"
      if subItem.sti_type == ItemHelper::ITEM_INDIVIDUAL_CLASS_NAME  &&
         objItem.sti_type == ItemHelper::ITEM_CATEGORY_CLASS_NAME
        if TrippleNavigation.check_properties(
            :does => predicate_id,
            :inherit_from => Item.find_by_name("parent_of").id,
            :via => spo_id)
          errors.add :predicate,
                     'an individual cannot be the parent of a category.'
          return false
        end
      end

      # check for "category child_of individual"
      if subItem.sti_type == ItemHelper::ITEM_CATEGORY_CLASS_NAME  &&
         objItem.sti_type == ItemHelper::ITEM_INDIVIDUAL_CLASS_NAME
        if TrippleNavigation.check_properties(
            :does => predicate_id,
            :inherit_from => Item.find_by_name("child_of").id,
            :via => spo_id)
          errors.add :predicate,
                     'a category cannot be the child of an individual.'
          return false
        end
      end


          # would this create a loop (including connection-to-self) of
          # hierarchical or ordered relationships?
      # if this is the kind of property we have to worry about?
      [
        Item.find_by_name("parent_of").id,
        Item.find_by_name("child_of").id,
        Item.find_by_name("sub_property_of").id,
        Item.find_by_name("predecessor_of").id,
        Item.find_by_name("successor_of").id
      ].each do |prop_id|
        if TrippleNavigation.check_properties(
            :does => predicate_id, :inherit_from => prop_id, :via => spo_id)
          if TrippleNavigation.check_properties(
              :does => obj_id, :link_to => subject_id,
              :through_children_of => prop_id )
            errors.add :subject, 'this relationship would create a loop.'
            return false
          end
        end
      end

          # is this a "bad" connection-to-self?
      if subject_id == obj_id
        [ "inverse_relationship", "hierarchical_relationship",
          "ordered_relationship" ].each do |relation_name|
          if TrippleNavigation.check_properties(
              :does         => predicate_id,
              :inherit_from => Item.find_by_name(relation_name).id,
              :via          => spo_id  )
            errors.add :subject,
  'cannot create an ordered/hierarchical relationship from an item to itself'
            return false
          end
        end
      end


    elsif kind_of_obj == OBJECT_KIND_SCALAR
      [ [subject_id, :subject], [predicate_id, :predicate],
        [scalar_obj, :scalar_obj] ].each do |tocheck|
        field, symbol = *tocheck
        if field.nil?
          errors.add symbol, "can't be blank."
          return false
        end
      end


    else
      errors.add :kind_of_obj, "isn't valid (#{kind_of_obj})"
      return false
    end


    true
  end
end
