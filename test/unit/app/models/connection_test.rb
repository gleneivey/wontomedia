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
  test "connection model exists" do
    assert Connection.new
  end

  test "connection has basic properties with Item object" do
    e = Connection.new( :subject => items(:testContainer),
      :predicate => Item.find_by_name("contains"),
      :obj => items(:testIndividual), :kind_of_obj => "item" )
    assert e.save
  end

  test "connection has basic properties with scalar object" do
    e = Connection.new( :subject => items(:testContainer),
      :predicate => Item.find_by_name("contains"),
      :scalar_obj => "an object string", :kind_of_obj => "scalar" )
    assert e.save
  end

  test "connection has connection_desc property" do
    e = Connection.new( :subject => items(:testIndividual),
      :predicate => Item.find_by_name("one_of"), :obj => items(:testCategory),
      :connection_desc => items(:connection_one), :kind_of_obj => "item" )
    assert e.save
  end

  test "connection must have spo values" do
    e = Connection.new( :predicate => Item.find_by_name("parent_of"),
      :obj => items(:testSubcategory), :kind_of_obj => "item" )
    assert !e.save

    e = Connection.new( :subject => items(:testCategory),
      :obj => items(:testSubcategory), :kind_of_obj => "item" )
    assert !e.save

    e = Connection.new( :subject => items(:testCategory),
      :predicate => Item.find_by_name("parent_of") )
    assert !e.save

    e = Connection.new( :subject => items(:testIndividual),
      :predicate => Item.find_by_name("one_of"), :obj => items(:testCategory),
      :connection_desc => items(:connection_one) )
    assert !e.save
  end

  test "connection properties must be items" do
    assert_raise ActiveRecord::AssociationTypeMismatch do
      e = Connection.new( :subject => items(:testIndividual),
        :predicate => items(:one), :obj => connections(:aParentConnection),
        :kind_of_obj => "item" )
    end
  end

  test "scalar object cant be nil" do
    connection = Connection.new(
      :subject => items(:testContainer),
      :predicate => Item.find_by_name("contains"),
      :kind_of_obj => "scalar" )
    assert !connection.save
  end

  test "scalar object cant be empty" do
    connection = Connection.new(
      :subject => items(:testContainer),
      :predicate => Item.find_by_name("contains"),
      :scalar_obj => '',
      :kind_of_obj => "scalar" )
    assert !connection.save
  end

  test "scalar object cant be blank" do
    connection = Connection.new(
      :subject => items(:testContainer),
      :predicate => Item.find_by_name("contains"),
      :scalar_obj => ' 	 ',
      :kind_of_obj => "scalar" )
    assert !connection.save
  end

  test "new connection cant duplicate existing" do
    e = Connection.new(
      :subject=> items(:testIndividual), :predicate => items(:one),
      :obj => items(:testCategory), :kind_of_obj => "item" )
    assert !e.save
  end

  test "new connection cant duplicate existing with a sub-property" do
    # fixtures contain: fu inverse_relationship bar
    e = Connection.new( :subject => items(:fu),
      :obj => items(:bar), :kind_of_obj => "item",
      :predicate => Item.find_by_name("symmetric_relationship")  )
    assert !e.save
  end

  test "new connection cant duplicate existing with a super-property" do
    # fixtures contain: sn symmetric_relationship afu
    e = Connection.new( :subject => items(:sn),
      :obj => items(:afu), :kind_of_obj => "item",
      :predicate => Item.find_by_name("inverse_relationship")  )
    assert !e.save
  end

# group of items used for testing sub_property_of relationship traversal
# structure in fixtures is:
#   A spo B spo C spo D spo E
#         |    spo M spo (same "Y" as below)
#        spo Z spo Y spo X
  test "distantly-related duplicate predicate A implied-spo E" do
    Connection.new( :subject => items(:fu), :predicate => items(:E),
      :obj => items(:bar), :kind_of_obj => "item" ).save
    con = Connection.new( :subject => items(:fu), :predicate => items(:A),
      :obj => items(:bar), :kind_of_obj => "item" )
    assert !con.save
  end

  test "distantly-related duplicate predicate A implied-spo Z" do
    Connection.new( :subject => items(:fu), :predicate => items(:Z),
      :obj => items(:bar), :kind_of_obj => "item" ).save
    con = Connection.new( :subject => items(:fu), :predicate => items(:A),
      :obj => items(:bar), :kind_of_obj => "item" )
    assert !con.save
  end

  test "distantly-related duplicate predicate E implied-super-po A" do
    Connection.new( :subject => items(:fu), :predicate => items(:A),
      :obj => items(:bar), :kind_of_obj => "item" ).save
    con = Connection.new( :subject => items(:fu), :predicate => items(:E),
      :obj => items(:bar), :kind_of_obj => "item" )
    assert !con.save
  end

  test "distantly-related duplicate predicate Z implied-super-po A" do
    Connection.new( :subject => items(:fu), :predicate => items(:A),
      :obj => items(:bar), :kind_of_obj => "item" ).save
    con = Connection.new( :subject => items(:fu), :predicate => items(:Z),
      :obj => items(:bar), :kind_of_obj => "item" )
    assert !con.save
  end
  # done with multi-spo inheritance tests


  test "new connection cant duplicate implied" do
    # fixtures contain: testCategory parent_of testSubcategory
    con = Connection.new( :subject => items(:testSubcategory),
      :predicate => Item.find_by_name( "child_of" ),
      :obj => items(:testCategory), :kind_of_obj => "item" )
    assert !con.save
  end

  test "new connection cant be parent-to-child from individual to category" do
    con = Connection.new( :subject => items(:one),  # IndividualItem
      :predicate => Item.find_by_name( "contains" ),
      :obj => items(:two), :kind_of_obj => "item" )
    assert !con.save
  end

  test "new connection cant be child-to-parent from category to individual" do
    con = Connection.new( :subject => items(:two),  # CategoryItem
      :predicate => Item.find_by_name( "child_of" ),
      :obj => items(:one), :kind_of_obj => "item" )
    assert !con.save
  end

  test "can create acceptable built-in connection-to-self types" do
    item = items(:one)
    [ "peer_of", "value_relationship","symmetric_relationship" ].
        each do |test_relation|
      con = Connection.new( :subject => item,
        :predicate => Item.find_by_name( test_relation ),
        :obj => item, :kind_of_obj => "item" )
      assert con.save
      con.destroy # clean up for next test pass
    end
  end

  test "cant create unacceptable built-in connection-to-self types" do
    item = items(:one)
    [ "one_of", "contains", "parent_of", "child_of", "predecessor_of",
      "successor_of", "inverse_relationship", "sub_property_of",
      "hierarchical_relationship", "ordered_relationship" ].
        each do |test_relation|
      con = Connection.new( :subject => item,
        :predicate => Item.find_by_name( test_relation ),
        :obj => item, :kind_of_obj => "item" )
      assert !con.save
    end
  end
end
