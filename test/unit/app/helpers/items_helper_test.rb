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


class ItemsHelperTest < ActionView::TestCase
  test "generate self-item title text" do
    title = "a test item"
    name  = "test_item"
    @item = Item.new( :name => name, :title => title)
    @item.save
    @item_hash= {}
    @item_hash[@item.id] = @item

    result = self_string_or_other_link(@item.id)
    assert /#{title}/ =~ result
    assert /#{name}/  =~ result
    assert /href/     =~ result
  end

  test "generate link to other item including title text" do
    title = "one test item"
    name = "one_item"
    n = Item.new( :name => name, :title => title )
    @item = Item.new( :name => "another_item", :title => "another test item")
    n.save; @item.save
    @item_hash= {}
    @item_hash[n.id] = n
    @item_hash[@item.id] = @item

    result = self_string_or_other_link(n.id)
    assert /#{title}/ =~ result
    assert /#{name}/  =~ result
    assert /href/     =~ result
  end
end
