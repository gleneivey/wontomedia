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

class IndividualNodeTest < ActiveSupport::TestCase
  test "individual_node model exists" do
    assert IndividualNode.new
  end

  test "individual_node inherits from node" do
    name = "in"
    individual = IndividualNode.new( :name => name, :title => "individual" )
    assert individual.save
    assert_equal Node.find_by_name(name).name, name
  end
end
