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

class CheckPropertiesInheritTest < ActiveSupport::TestCase
  test "node with no properties doesnt inherit from anything" do
    assert !check_properties( :does         => nodes(:two).id,
                              :inherit_from => nodes(:one).id,
                              :via          => nodes(:A).id     )
  end

  test "node with simple property doesnt inherit" do
    assert !check_properties( :does         => nodes(:testCategory).id,
                              :inherit_from => nodes(:testIndividual).id,
                              :via          => nodes(:one).id     )
  end


# group of nodes used for testing sub_property_of relationship traversal
# structure in fixtures is:
#   A spo B spo C spo D spo E
#         |    spo M spo (same "Y" as below)
#        spo Z spo Y spo X

  test "node inherits from itself regardless" do
    assert check_properties(  :does         => nodes(:A).id,
                              :inherit_from => nodes(:A).id,
      :via => Node.find_by_name("sub_property_of").id )
  end

  test "node with single-edge inheritence" do
    assert check_properties(  :does         => nodes(:A).id,
                              :inherit_from => nodes(:B).id,
      :via => Node.find_by_name("sub_property_of").id )
  end

  test "node inherits through multiple nodes" do
    assert check_properties(  :does         => nodes(:A).id,
                              :inherit_from => nodes(:E).id,
      :via => Node.find_by_name("sub_property_of").id )
  end
end
