# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
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


require File.join( File.dirname(__FILE__), '..', 'test_helper' )

class ItemsDataTest < ActiveSupport::TestCase
  test "items seed data present" do
    [ 'peer_of', 'one_of', 'contains', 'parent_of', 'child_of',
      'sub_class_of', 'is_instance_of', 'class_item_type_is',
      'Value_ItemType_Category', 'Value_ItemType_Individual',
      'inverse_relationship', 'sub_property_of', 'symmetric_relationship',
      'value_relationship', 'hierarchical_relationship'].each do |name|
      assert Item.find_by_name(name)
    end
  end
end
