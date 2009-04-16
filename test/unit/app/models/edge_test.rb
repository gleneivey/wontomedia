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

class EgdeTest < ActiveSupport::TestCase
  test "edge model exists" do
    assert Edge.new
  end

  test "edge has basic properties" do
    e = Edge.new( :subject => nodes(:testContainer),
                  :predicate => Node.find_by_name("contains"),
                  :object => nodes(:testItem) )
    assert e.save
  end

  test "edge has self property" do
    e = Edge.new( :subject => nodes(:testItem),
                  :predicate => Node.find_by_name("one_of"),
                  :object => nodes(:testCategory),
                  :self => nodes(:edge_one) )
    assert e.save
  end

  test "edge must have spo values" do
    e = Edge.new( :predicate => Node.find_by_name("parent_of"),
                  :object => nodes(:testSubcategory) )
    assert !e.save

    e = Edge.new( :subject => nodes(:testCategory),
                  :object => nodes(:testSubcategory) )
    assert !e.save

    e = Edge.new( :subject => nodes(:testCategory),
                  :predicate => Node.find_by_name("parent_of") )
    assert !e.save
  end

  test "edge properties must be nodes" do
    n1 = Node.new( :name => "testCategory", :title => "testCategory" )
    n3 = Node.new( :name => "", :title => "testSubcategory" )
    n2 = Node.find_by_name( "parent_of" )

    assert e1 = Edge.new( :subject => n1, :predicate => n2,
                          :object => n3 )
    assert e1.save
    assert_raise ActiveRecord::AssociationTypeMismatch do
      e2 = Edge.new( :subject => n1, :predicate => n2, :object => e1 )
    end
  end
end
