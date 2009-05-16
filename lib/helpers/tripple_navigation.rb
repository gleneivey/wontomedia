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


def relation_and_all_superproperties(predicate_id, &block)
  yield predicate_id

  subproperty_id = Node.find_by_name("sub_property_of").id
  edges = Edge.all( :conditions => [
    "subject_id = ? AND predicate_id = ?", predicate_id, subproperty_id ])
  edges.each do |e|
    relation_and_all_superproperties(e.object_id, &block)
  end
end

def relation_and_all_subproperties(predicate_id, &block)
  yield predicate_id

  subproperty_id = Node.find_by_name("sub_property_of").id
  edges = Edge.all( :conditions => [
    "predicate_id = ? AND object_id = ?", subproperty_id, predicate_id ])
  edges.each do |e|
    relation_and_all_subproperties(e.subject_id, &block)
  end
end

def check_properties(hash_of_params)
  unless hash_of_params.has_key?(:does)
    raise ArgumentError, "Expected :does in input hash"
  end
  unless hash_of_params.has_key?(:inherit_from)
    raise ArgumentError, "Expected :inherit_from in input hash"
  end
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

  edges = Edge.all( :conditions => [
    "subject_id = ? AND predicate_id = ?", child_id, via_property_id ])
  edges.each do |e|
    if check_properties(
                         :does         => e.object_id,
                         :inherit_from => parent_id,
                         :via          => via_property_id )
      return true
    end
  end

  return false
end
