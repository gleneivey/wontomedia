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


require Rails.root.join( 'lib', 'helpers', 'node_helper')
require Rails.root.join( 'lib', 'helpers', 'tripple_navigation')

class Edge < ActiveRecord::Base
  before_validation :complex_validations
#  validates_presence_of :subject, :predicate, :obj
#explicitly do the equivalent of the above in complex_validations because
#c_v has to be a "before" callback (so it's return value is checked), which
#means other validations aren't run yet, so can't count on these IDs to
#be present/valid.  Ugh.
#  validates_uniqueness_of :subject_id, :scope => [:predicate_id, :obj_id]
#this works, but is subsumed by checks in c_v, so eliminated duplication

  belongs_to :subject,   :class_name => "Node"
  belongs_to :predicate, :class_name => "Node"
  belongs_to :obj,       :class_name => "Node"
  belongs_to :edge_desc, :class_name => "Node"

private
  def complex_validations
    [ [subject_id, :subject], [predicate_id, :predicate],
      [obj_id, :obj] ].each do |tocheck|
      field, symbol = *tocheck
      if field.nil?
        errors.add symbol, "can't be blank."
        return false
      end
    end

        # is there an existing edge with a predicate that is a sub-property
        # or super-property of the current predicate?
    # check for duplicate edge and all super-properties
    relation_and_all_superproperties(predicate_id) do |super_prop|
      unless (Edge.all( :conditions => [
          "subject_id = ? AND predicate_id = ? AND obj_id = ?",
          subject_id, super_prop, obj_id ] ).empty? )
        errors.add :subject, 'relationship (or equivalent) already exists.'
        return false
      end
    end

    # check for sub-properties
    relation_and_all_subproperties(predicate_id) do |sub_prop|
      unless (Edge.all( :conditions => [
          "subject_id = ? AND predicate_id = ? AND obj_id = ?",
          subject_id, sub_prop, obj_id ] ).empty? )
        errors.add :subject, 'equivalent relationship already exists.'
        return false
      end
    end


        # is there an existing implied opposing edge?
    # find all edges back-connecting our subject and object, determine
    # if any of their predicates has an (inherited)
    # inverse_relationship to current predicate
    if edges = Edge.all( :conditions => [
        "subject_id = ? AND obj_id = ?", obj_id, subject_id ] )

      inverse_id = Node.find_by_name("inverse_relationship").id

      edges.each do |e|
        relation_and_all_superproperties(predicate_id) do |proposed_rel|
          relation_and_all_superproperties(e.predicate_id) do |existing_rel|
            if Edge.all( :conditions => [
              "subject_id = ? AND predicate_id = ? AND obj_id = ?",
                proposed_rel, inverse_id, existing_rel ] )
              errors.add :subject, 'already has this relationship implied.'
              return false
            end
          end
        end
      end
    end


        # would this create an "item parent_of category" relationship?
    subNode = Node.find(subject_id)
    objNode = Node.find(obj_id)
    spo_id  = Node.find_by_name("sub_property_of").id
    # check for "item parent_of category"
    if subNode.sti_type == NodeHelper::NODE_ITEM_KLASS_NAME  &&
       objNode.sti_type == NodeHelper::NODE_CLASS_KLASS_NAME
      if check_properties(
          :does => predicate_id,
          :inherit_from => Node.find_by_name("parent_of").id,
          :via => spo_id)
        errors.add :predicate, 'an item cannot be the parent of a category'
        return false
      end
    end

    # check for "category child_of item"
    if subNode.sti_type == NodeHelper::NODE_CLASS_KLASS_NAME  &&
       objNode.sti_type == NodeHelper::NODE_ITEM_KLASS_NAME
      if check_properties(
          :does => predicate_id,
          :inherit_from => Node.find_by_name("child_of").id,
          :via => spo_id)
        errors.add :predicate, 'a category cannot be the child of an item'
        return false
      end
    end


        # would this create a loop (including edge-to-self) of
        # hierarchical or ordered relationships?
    # if this is the kind of property we have to worry about?
    [
      Node.find_by_name("parent_of").id,
      Node.find_by_name("child_of").id,
      Node.find_by_name("sub_property_of").id,
      Node.find_by_name("predecessor_of").id,
      Node.find_by_name("successor_of").id
    ].each do |prop_id|
      if check_properties(
          :does => predicate_id, :inherit_from => prop_id, :via => spo_id)
        if check_properties(
            :does => obj_id, :link_to => subject_id,
            :through_children_of => prop_id )
          errors.add :subject, 'this relationship would create a loop'
          return false
        end
      end
    end

    true
  end
end
