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

class ItemsShowViewTest < ActionController::TestCase
  tests ItemsController
  def get_items_show(name)
    n = items(name)
    get :show, :id => n.id
    n
  end

  def get_items_show_json(name, sti_type)
    n = items(name)
    get :show, :id => n.id, :format => 'json'
    return n, ActiveSupport::JSON.decode(@response.body)[sti_type + "_item"]
  end

  test "should have show HTML page for items" do
    get_items_show(:one)
    assert_template "items/show"
  end

  test "item-show HTML page should contain item name" do
    n = get_items_show(:one)
    assert_select "body", /#{n.name}/
  end

  test "item-show HTML page should contain item title" do
    n = get_items_show(:one)
    assert_select "body", /#{n.title}/
  end

  test "item-show HTML page should contain item description" do
    n = get_items_show(:one)
    assert_select "body", /#{n.description}/
  end

  test "items show HTML page shouldnt contain status" do
    get_items_show(:one)
    assert_negative_view_contents
  end

  test "items show JSON response should contain item name" do
    n, j = get_items_show_json(:one, "individual")
    assert j["name"] == n.name,
      "Expected response Name '#{j['name']}' to match item's #{n.name}"
  end

  test "items show JSON response should contain item title" do
    n, j = get_items_show_json(:one, "individual")
    assert j["title"] == n.title,
      "Expected response Title '#{j['title']}' to match item's #{n.title}"
  end

  test "items show JSON response should contain item description" do
    n, j = get_items_show_json(:one, "individual")
    assert j["description"] == n.description,
      "Expected response Description '#{j['description']}' to " +
        "match item's #{n.description}"
  end


        # all following are tests of the HTML page

  test "item-show page should contain item-edit link" do
    item = get_items_show(:two)
    assert_select "a[href=?]", edit_item_by_name_path(item.name)
  end

  test "item-show page 4 unused items should contain item-delete link" do
    item = get_items_show(:two)
      # sloppy, should verify :method
    assert_select "a[href=?]", item_path(item)
  end

  test "item-show page 4 in-use items should contain cant-delete-item link" do
    get_items_show(:one)
    assert_select "a[href=\"#\"][onclick*=\"cantDelete\"]"
  end

  test "item-show page should contain items-index link" do
    get_items_show(:two)
    assert_select "a[href=?]", items_path
  end

  test "item-show page should contain connections-new link" do
    get_items_show(:two)
    assert_select "a[href=?]", new_connection_path
  end

  test "item-show page should contain titles & links of each connection's items" do
    get_items_show(:testIndividual)
    [ items(:one),                          # aQualifiedConnection
      items(:testCategory),
      items(:testSubcategory),              # subcategoryHasValue
      items(:isAssigned),
      items(:testProperty)                  # anotherScalarObj
    ].each do |item|
      assert_select "body", /#{item.title}/
      assert_select "a[href=?]", item_by_name_path(item.name)
    end
  end

  test "item-show page should contain links for connections, item objects" do
    get_items_show(:testIndividual)
    [ connections(:aQualifiedConnection),
      connections(:subcategoryHasValue)
    ].each do |connection|
      assert_select "a[href=?]", edit_connection_path(connection)
      assert_select "a[href=?]", connection_path(connection)
    end
  end

  test "item-show page should contain links for connections, scalar objects" do
    get_items_show(:isAssigned)
    [ connections(:isAssignedIsAValueProperty),
      connections(:subcategoryHasValue),
      connections(:aConnectionToScalar)
    ].each do |connection|
      assert_select "a[href=?]", edit_connection_path(connection)
      assert_select "a[href=?]", connection_path(connection)
    end
  end

  test "item-show page should have and only have correct edit destroy links" do
    Item.all.each do |item|

      if item.sti_type != "QualifiedItem"
        get :show, :id => item.id

        # other item types all listed
        assert_select "body", /#{item.name}/


        test_sense = (item.flags & Item::DATA_IS_UNALTERABLE) == 0

        # edit link present/absent
        assert_select( "a[href=\"#{edit_item_by_name_path(item.name)}\"]",
          test_sense )

        # delete link present/absent
        item_not_in_use =
          Connection.all( :conditions =>
            [ "subject_id = ? OR predicate_id = ? OR obj_id = ?",
              item.id, item.id, item.id ]).
            empty?
        assert_select(
          "a[href=\"#{item_path(item)}\"][onclick*=\"delete\"]",
          test_sense && item_not_in_use )
        assert_select(
          "a[href=\"#\"][onclick*=\"cantDelete\"]",
          test_sense && !item_not_in_use )
      end
    end
  end

  test "item-show page's connection list should h-o-h correct per-connection links" do
    Item.all.each do |item|

      if item.sti_type != "QualifiedItem"
        get :show, :id => item.id

        connections =
          Connection.all( :conditions => [ "subject_id = ?", item.id ])    +
          Connection.all( :conditions => [ "predicate_id = ?", item.id ])  +
          Connection.all( :conditions => [ "obj_id = ?", item.id ])
        connections.each do |connection|
          test_sense = (connection.flags & Connection::DATA_IS_UNALTERABLE) == 0

          # edit link present/absent
          assert_select( "a[href=\"#{edit_connection_path(connection)}\"]",
            test_sense )
          # delete link present/absent
          assert_select(
            "a[href=\"#{connection_path(connection)}\"][onclick*=\"delete\"]",
            test_sense )
        end
      end
    end
  end

  # depends on the follwoing connections in fixtures:
  #   itemUsedFrequentlyAsSubject successor_of D
  #                             E successor_of D
  # to produce implied predecessor_of connections
  test "items-show page s'h' correct links for original and implied con's" do
    get_items_show(:D)
    assert item_hash = assigns(:item_hash)

    [ connections(:nUFAS_successor_of_D),
      connections(:nE_successor_of_D) ].each do |connection|

      assert_select "a[href=\"#{connection_path(connection)}\"]",
        { :text => 'Show' }, 'Missing "Show" link for expected connection'
      assert_select "a[href=\"#{connection_path(connection)}\"]",
        { :text => 'View source' },
        'Missing "View source" link for expected connection'
    end
  end

  test "items-show page should contain text of scalar object values" do
    get_items_show(:testProperty)
    assert_select "body", /#{connections(:aConnectionToScalar).scalar_obj}/
  end
end
