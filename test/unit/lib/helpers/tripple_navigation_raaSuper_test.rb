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


require 'test_helper'
require Rails.root.join( 'lib', 'helpers', 'tripple_navigation')

class RelationAndAllSuperpropertiesTest < ActiveSupport::TestCase
  test "no parents make single invoke only" do
    count = 0
    id = nodes(:one).id
    relation_and_all_superproperties(id) do |sp_id|
      assert sp_id == id
      count += 1
    end
    assert count == 1
  end


# group of nodes used for testing sub_property_of relationship traversal
# structure in fixtures is:
#   A spo B spo C spo D spo E
#         |    spo M spo (same "Y" as below)
#        spo Z spo Y spo X

  def make_relation_and_all_superproperties_call(props)
    count = 0
    checklist = props
    relation_and_all_superproperties( props[0] ) do |sp_id|
      assert props.include?(sp_id)
      checklist -= [ sp_id ]
      count += 1
      assert count < 1000 # no infinite loops.....
    end
    assert checklist == []
  end

  test "one superproperty causes two iterations" do
    props = [ nodes(:D).id, nodes(:E).id ]
    make_relation_and_all_superproperties_call(props)
  end

  test "two superproperty causes three iterations" do
    props = [ nodes(:Z).id, nodes(:Y).id, nodes(:X).id ]
    make_relation_and_all_superproperties_call(props)
  end

  test "finds superproperties with multiple inheritance" do
    props = [ nodes(:C).id, nodes(:D).id, nodes(:E).id, nodes(:M).id,
              nodes(:Y).id, nodes(:X).id ]
    make_relation_and_all_superproperties_call(props)
  end

  test "navigate superproperties with a loop" do
    props = [ nodes(:A).id, nodes(:B).id, nodes(:C).id, nodes(:D).id,
              nodes(:E).id, nodes(:M).id,
              nodes(:Z).id, nodes(:Y).id, nodes(:X).id ]
    make_relation_and_all_superproperties_call(props)
  end
end
