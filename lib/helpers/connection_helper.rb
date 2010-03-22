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
# transform Connection objects.
module ConnectionHelper

  # This method renders a multi-line string in the 'n3' format (aka
  # 'Notation3' standardized by the W3C, see
  # http://en.wikipedia.org/wiki/Notation3 for an introduction) from
  # an array of Connection models.
  #
  # This is currently a trivial but correct implementation.  It supports
  # our current data model, but will need a significant upgrade when
  # WontoMedia begins to support reiffied edges (blank nodes), etc.
  def self.connection_array_to_n3(connections)
    result = ""
    connections.each do |connection|
      result << "<##{connection.subject.name}> <##{connection.predicate.name}> "
      if connection.kind_of_obj == Connection::OBJECT_KIND_ITEM
        result << "<##{connection.obj.name}> .\n"
      else
        result << "\"#{connection.scalar_obj}\" .\n"
      end
    end
    result
  end

  # An operator usable for sorting, returns 0 for a==b, <0 for a<b
  def self.compare(a, b, factor_hash = {})
    # sort relationships using built-in predicates to the bottom
    aflag = a.predicate.flags & Item::DATA_IS_UNALTERABLE
    bflag = b.predicate.flags & Item::DATA_IS_UNALTERABLE
    return aflag - bflag if aflag != bflag

      # sort relationships to scalar values above those with item objects
    # connection with filled-in scalar valued object
    if a.kind_of_obj && b.kind_of_obj && a.kind_of_obj != b.kind_of_obj
      return a.kind_of_obj == Connection::OBJECT_KIND_ITEM ? 1 : -1
    end
    if a.kind_of_obj.nil? || b.kind_of_obj.nil?
      # connection with blank object intended to be a scalar
      a_kind = Connection.first( :conditions => [
          "subject_id = ? AND predicate_id = ?", a.predicate_id,
          Item.find_by_name('has_scalar_object') ])
      b_kind = Connection.first( :conditions => [
          "subject_id = ? AND predicate_id = ?", b.predicate_id,
          Item.find_by_name('has_scalar_object') ])
      if a_kind != b_kind
        return a_kind.nil? ? 1 : -1
      end
    end

    # relationships w/ predicates constrained by max_uses_per_item:
    #   sort lower maximums closer to top of list.  Sort unconstrained
    #   predicates as "infinite maximum"
    max_uses = Item.find_by_name('max_uses_per_item')
    a_max = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ?", a.predicate_id, max_uses.id ])
    unless a_max.nil?
      a_max = a_max.scalar_obj.nil? ? nil : a_max.scalar_obj.to_i
    end
    b_max = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ?", b.predicate_id, max_uses.id ])
    unless b_max.nil?
      b_max = b_max.scalar_obj.nil? ? nil : b_max.scalar_obj.to_i
    end
    unless a_max == b_max
      return -1 if b_max.nil?
      return  1 if a_max.nil?
      return a_max - b_max
    end

    a_id = a.predicate_id
    b_id = b.predicate_id

    # sort by "predicate external factor" hash, higher numbers better
    # (this is intended to support, among other things, sorting based
    # on the number of times the same predicate is used in the list of
    # connections being sorted.  Requires caller to make a counting
    # pass over the sort set first to build the hash
    a_count = factor_hash[a_id].nil? ? 0 : factor_hash[a_id]
    b_count = factor_hash[b_id].nil? ? 0 : factor_hash[b_id]
    return b_count - a_count if a_count != b_count

    # sort by property ID order (this is essentially arbitrary, but
    # ensures the sort order is stable and that subsequent factors
    # only affect sorting within groups of connections all referencing
    # the same property item)
    return a_id - b_id if a_id != b_id

    # sort connections with missing objects (e.g. "add here"
    # place-holders) below others
    a_blank = a.kind_of_obj.nil? ||
        (a.kind_of_obj == Connection::OBJECT_KIND_ITEM ?
          a.obj : a.scalar_obj ) == nil
    b_blank = b.kind_of_obj.nil? ||
        (b.kind_of_obj == Connection::OBJECT_KIND_ITEM ?
          b.obj : b.scalar_obj ) == nil
    return a_blank ? 1 : -1 if a_blank != b_blank

    # sort connections whose objects are built-in below others
    aflag = a.obj.nil? ? 0 : a.obj.flags & Item::DATA_IS_UNALTERABLE
    bflag = b.obj.nil? ? 0 : b.obj.flags & Item::DATA_IS_UNALTERABLE
    return aflag - bflag
  end
end
