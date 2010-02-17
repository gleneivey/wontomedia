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
require Rails.root.join( 'lib', 'helpers', 'tripple_navigation')

class RelationAndAllSubpropertiesTest < ActiveSupport::TestCase
  test "no children make single invoke only" do
    count = 0
    id = items(:one).id
    relation_and_all_subproperties(id) do |sp_id|
      assert sp_id == id
      count += 1
    end
    assert count == 1
  end


# group of items used for testing sub_property_of relationship traversal
# structure in fixtures is:
#   A spo B spo C spo D spo E
#         |    spo M spo (same "Y" as below)
#        spo Z spo Y spo X

  def make_relation_and_all_subproperties_call(props)
    count = 0
    checklist = props
    relation_and_all_subproperties( props[0] ) do |sp_id|
      assert props.include?(sp_id)
      checklist -= [ sp_id ]
      count += 1
      count < 1000 # no infinite loops
    end
    assert checklist == []
  end

  test "one subproperty causes two iterations" do
    props = [ items(:B).id, items(:A).id ]
    make_relation_and_all_subproperties_call(props)
  end

  test "two subproperty causes three iterations" do
    props = [ items(:C).id, items(:B).id, items(:A).id ]
    make_relation_and_all_subproperties_call(props)
  end

  test "finds subproperties with multiple inheritance" do
    props = [ items(:X).id, items(:Y).id, items(:Z).id, items(:M).id,
              items(:C).id, items(:B).id, items(:A).id ]
    make_relation_and_all_subproperties_call(props)
  end
end
