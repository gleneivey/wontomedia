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


class CheckPropertiesInheritTest < ActiveSupport::TestCase
  test "item with no properties doesnt inherit from anything" do
    assert !TrippleNavigation.check_properties(
      :does         => items(:two).id,
      :inherit_from => items(:one).id,
      :via          => items(:A).id     )
  end

  test "item with simple property doesnt inherit" do
    assert !TrippleNavigation.check_properties(
      :does         => items(:testCategory).id,
      :inherit_from => items(:testIndividual).id,
      :via          => items(:one).id     )
  end


# group of items used for testing sub_property_of relationship traversal
# structure in fixtures is:
#   A spo B spo C spo D spo E
#         |    spo M spo (same "Y" as below)
#        spo Z spo Y spo X

  test "item inherits from itself regardless" do
    assert TrippleNavigation.check_properties(
      :does         => items(:A).id,
      :inherit_from => items(:A).id,
      :via => Item.find_by_name("sub_property_of").id )
  end

  test "item with single-connection inheritence" do
    assert TrippleNavigation.check_properties(
      :does         => items(:A).id,
      :inherit_from => items(:B).id,
      :via => Item.find_by_name("sub_property_of").id )
  end

  test "item inherits through multiple items" do
    assert TrippleNavigation.check_properties(
      :does         => items(:A).id,
      :inherit_from => items(:E).id,
      :via => Item.find_by_name("sub_property_of").id )
  end
end
