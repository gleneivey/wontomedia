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

class EgdeTest < ActiveSupport::TestCase
  test "edge model exists" do
    assert Edge.new
  end

  test "edge has basic properties" do
    e = Edge.new( :subject => nodes(:testContainer),
                  :predicate => Node.find_by_name("contains"),
                  :obj => nodes(:testItem) )
    assert e.save
  end

  test "edge has edge_desc property" do
    e = Edge.new( :subject => nodes(:testItem),
                  :predicate => Node.find_by_name("one_of"),
                  :obj => nodes(:testCategory),
                  :edge_desc => nodes(:edge_one) )
    assert e.save
  end

  test "edge must have spo values" do
    e = Edge.new( :predicate => Node.find_by_name("parent_of"),
                  :obj => nodes(:testSubcategory) )
    assert !e.save

    e = Edge.new( :subject => nodes(:testCategory),
                  :obj => nodes(:testSubcategory) )
    assert !e.save

    e = Edge.new( :subject => nodes(:testCategory),
                  :predicate => Node.find_by_name("parent_of") )
    assert !e.save
  end

  test "edge properties must be nodes" do
    assert_raise ActiveRecord::AssociationTypeMismatch do
      e = Edge.new( :subject   => nodes(:testItem),
                    :predicate => nodes(:one),
                    :obj       => edges(:aParentEdge)  )
    end
  end

  test "new edge cant duplicate existing" do
    e = Edge.new( :subject   => nodes(:testItem),
                  :predicate => nodes(:one),
                  :obj       => nodes(:testCategory)  )
    assert !e.save
  end

  test "new edge cant duplicate existing with a sub-property" do
    # fixtures contain: fu inverse_relationship bar
    e = Edge.new( :subject   => nodes(:fu),
                  :predicate => Node.find_by_name("symmetric_relationship"),
                  :obj       => nodes(:bar)  )
    assert !e.save
  end

  test "new edge cant duplicate existing with a super-property" do
    # fixtures contain: sn symmetric_relationship afu
    e = Edge.new( :subject   => nodes(:sn),
                  :predicate => Node.find_by_name("inverse_relationship"),
                  :obj       => nodes(:afu)  )
    assert !e.save
  end

# group of nodes used for testing sub_property_of relationship traversal
# structure in fixtures is:
#   A spo B spo C spo D spo E
#         |    spo M spo (same "Y" as below)
#        spo Z spo Y spo X
  test "distantly-related duplicate predicate A implied-spo E" do
    Edge.new(     :subject   => nodes(:fu),
                  :predicate => nodes(:E),
                  :obj       => nodes(:bar)).save
    e = Edge.new( :subject   => nodes(:fu),
                  :predicate => nodes(:A),
                  :obj       => nodes(:bar))
    assert !e.save
  end

  test "distantly-related duplicate predicate A implied-spo Z" do
    Edge.new(     :subject   => nodes(:fu),
                  :predicate => nodes(:Z),
                  :obj       => nodes(:bar)).save
    e = Edge.new( :subject   => nodes(:fu),
                  :predicate => nodes(:A),
                  :obj       => nodes(:bar))
    assert !e.save
  end

  test "distantly-related duplicate predicate E implied-super-po A" do
    Edge.new(     :subject   => nodes(:fu),
                  :predicate => nodes(:A),
                  :obj       => nodes(:bar)).save
    e = Edge.new( :subject   => nodes(:fu),
                  :predicate => nodes(:E),
                  :obj       => nodes(:bar))
    assert !e.save
  end

  test "distantly-related duplicate predicate Z implied-super-po A" do
    Edge.new(     :subject   => nodes(:fu),
                  :predicate => nodes(:A),
                  :obj       => nodes(:bar)).save
    e = Edge.new( :subject   => nodes(:fu),
                  :predicate => nodes(:Z),
                  :obj       => nodes(:bar))
    assert !e.save
  end
  # done with multi-spo inheritance tests


  test "new edge cant duplicate implied" do
    # fixtures contain: testCategory parent_of testSubcategory
    e = Edge.new( :subject   => nodes(:testSubcategory),
                  :predicate => Node.find_by_name( "child_of" ),
                  :obj       => nodes(:testCategory)  )
    assert !e.save
  end

  test "new edge cant be hierarchical parent-to-child from item to category" do
    e = Edge.new( :subject   => nodes(:one),  # ItemNode
                  :predicate => Node.find_by_name( "contains" ),
                  :obj       => nodes(:two)  )
    assert !e.save
  end

  test "new edge cant be hierarchical child-to-parent from category to item" do
    e = Edge.new( :subject   => nodes(:two),  # ClassNode
                  :predicate => Node.find_by_name( "child_of" ),
                  :obj       => nodes(:one)  )
    assert !e.save
  end

  test "can create acceptable built-in edge-to-self types" do
    n = nodes(:one)
    [ "peer_of", "value_relationship","symmetric_relationship" ].
        each do |test_relation|
      e = Edge.new( :subject   => n,
                    :predicate => Node.find_by_name( test_relation ),
                    :obj       => n )
      assert e.save
      e.destroy # clean up for next test pass
    end
  end

  test "cant create unacceptable built-in edge-to-self types" do
    n = nodes(:one)
    [ "one_of", "contains", "parent_of", "child_of", "predecessor_of",
      "successor_of", "inverse_relationship", "sub_property_of",
      "hierarchical_relationship", "ordered_relationship" ].
        each do |test_relation|
      e = Edge.new( :subject   => n,
                    :predicate => Node.find_by_name( test_relation ),
                    :obj       => n )
      assert !e.save
    end
  end
end
