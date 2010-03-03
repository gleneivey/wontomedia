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

class ItemsIndexViewTest < ActionController::TestCase
  tests ItemsController

  test "should have index page for items" do
    get :index
    assert_template "items/index"
  end

  test "should show Name of known item" do
    get :index
    assert_select "body", /#{items(:one).name}/
  end

  test "should show Title of known item" do
    get :index
    assert_select "body", /#{items(:one).title}/
  end

  test "should show Description of known item" do
    get :index
    assert_select "body", /#{items(:one).description}/
  end

  test "items index page shouldnt contain status" do
    get :index
    assert_negative_view_contents
  end

  test "items index page should have and only have right edit destroy links" do
    get :index

    Item.all.each do |item|
      if item.sti_type == "QualifiedItem"
        # items representing qualified connections aren't listed
        assert_select "body", { :text => item.name, :count => 0 }
      else
        # other item types all listed
        assert_select "body", /#{item.name}/

        test_sense = (item.flags & Item::DATA_IS_UNALTERABLE) == 0

        # edit link present/absent
        assert_select( "*##{item.name} a[href=\"#{edit_item_path(item)}\"]",
          test_sense   )

        # delete link present/absent
        # (attribute check is very Rails specific and a little sloppy, alas...)
        item_not_in_use =
          Connection.all( :conditions =>
                    [ "subject_id = ? OR predicate_id = ? OR obj_id = ?",
                      item.id, item.id, item.id ]).
            empty?
        test_sense &= item_not_in_use
        assert_select(
          "*##{item.name} a[href=\"#{item_path(item)}\"][onclick*=\"delete\"]",
          test_sense   )
      end
    end
  end
end
