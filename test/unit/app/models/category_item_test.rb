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


class CategoryItemTest < ActiveSupport::TestCase
  test "category_item model exists" do
    assert CategoryItem.new
  end

  test "category_item inherits from item" do
    name = "cn"
    cn = CategoryItem.new( :name => name, :title => "class" )
    assert cn.save
    assert_equal Item.find_by_name(name).name, name
  end
end
