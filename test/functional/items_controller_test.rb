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

class ItemsControllerTest < ActionController::TestCase
  test "should get homepage" do
    get :home
    assert_response :success
    assert_not_nil assigns(:nouns)
  end

  test "should get HTML index page" do
    get :index
    assert_response :success
    assert_not_nil assigns(:items)
    assert_not_nil assigns(:not_in_use_hash)
  end

  test "sould get YAML-format all-items download/index" do
    get :index, :format => "yaml"
    assert @response.header['Content-Type'] =~ /application\/x-yaml/

    Item.all.each do |item|
      if item.flags & Item::DATA_IS_UNALTERABLE == 0
        assert @response.body =~ /#{item.name}/,
          "Expected '#{item.name}' but didn't find"
      elsif not [ 'one_of' ].include?( item.name ) # special, used in desc. text
        assert !(@response.body =~ /#{item.name}/),
          "Found '#{item.name}', unexpected"
      end
    end
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "new form should have fresh item object" do
    get :new
    item = assigns(:item)
    assert_not_nil item
    assert_nil item.name
    assert_nil item.title
    assert_nil item.description
  end

  test "should get new-pop" do
    get :newpop
    assert_response :success
  end

  test "new-pop form should have fresh item object" do
    get :newpop
    item = assigns(:item)
    assert_not_nil item
    assert_nil item.name
    assert_nil item.title
    assert_nil item.description
  end

  test "new-pop form should have type parameter" do
    knownTypeValue = "noun"
    get :newpop, :type => knownTypeValue
    type = assigns(:type)
    assert_not_nil type
    assert_equal type, knownTypeValue
  end

  test "should create item with valid data" do
    name = "itemName"
    assert_difference('Item.count') do
      post :create, :item => { :name => name, :title => "title",
                               :sti_type => "CategoryItem" }
    end
    assert_redirected_to item_by_name_path(name)
    assert_not_nil Item.find_by_name(name)
  end

  test "should not create item without a type" do
    name = "itemName"
    assert_no_difference('Item.count') do
      post :create, :item => { :name => name, :title => "title" }
    end
    assert_response :success
    assert_template "items/new"
    assert_select "body", /Could not/
  end

  test "should not create item with invalid data" do
    assert_no_difference('Item.count') do
      post :create, :item => { :name => "name", :title => "ti\ttle",
        :sti_type => "IndividualItem" }
    end
    assert_response :success
    assert_template "items/new"
    assert_select "body", /error/
  end

  # specific validation tests here because these restrictions are
  # enforced by the controller -- "." and ":" are allowed by the model
  # because they're used in internally-generated item names
  test "should not create a item with a name including a period" do
    assert_no_difference('Item.count') do
      post :create, :item => { :name => "na.me", :title => "title",
        :sti_type => "CategoryItem" }
    end
    assert_response :success
    assert_template "items/new"
    assert_select "body", /error/
  end
  test "should not create a item with a name including a colon" do
    assert_no_difference('Item.count') do
      post :create, :item => { :name => "na:me", :title => "title",
        :sti_type => "IndividualItem" }
    end
    assert_response :success
    assert_template "items/new"
    assert_select "body", /error/
  end

  test "should show item" do
    assert_controller_behavior_with_id :show
    assert_not_nil assigns(:connection_list)
    assert_not_nil assigns(:connection_hash)
    assert_not_nil assigns(:item_hash)
  end

  test "should show JSON-format item" do
    id = items(:one).id
    get :show, :id => id, :format => 'json'
    assert_response :success
    item = assigns(:item)
    assert_not_nil item
    assert_equal id, item.id
  end

  test "should show first connection for item with value" do
    n = items(:testSubcategory)
    get :show, :id => n.id

    e = connections(:subcategoryHasValue)
    assert assigns(:item_hash)[e.predicate_id]
    assert assigns(:item_hash)[e.obj_id]

    assert array_of_arrays = assigns(:connection_list)
    assert array_of_arrays.length >= 1
    array_of_value_connections = array_of_arrays.first
    assert array_of_value_connections.length >= 1
    assert array_of_value_connections.include?( e.id )
  end

  test "should correctly group/sort is-subject connections" do
    n = items(:itemUsedFrequentlyAsSubject)
    get :show, :id => n.id

    # given content of test/fixtures/connections.yml,
    #   expect connection_list as follows:
    #     [[2 value connections], [3 peer_of connections],
    #      [2 successor_of connections], [2 random]]
    assert connection_list = assigns(:connection_list)
    assert connection_list.length == 4
    value_connection_array,
      peer_connection_array,
      successor_connection_array,
      random_connection_array = *connection_list

    assert value_connection_array.length == 2
    assert value_connection_array.include?( connections(:nUFAS_value_A).id )
    assert value_connection_array.include?( connections(:nUFAS_isAssigned_B).id )

    assert peer_connection_array.length == 3
    assert peer_connection_array.include?( connections(:nUFAS_peer_of_X).id )
    assert peer_connection_array.include?( connections(:nUFAS_peer_of_Y).id )
    assert peer_connection_array.include?( connections(:nUFAS_peer_of_Z).id )

    assert successor_connection_array.length == 2
    assert successor_connection_array.include?(
      connections(:nUFAS_successor_of_C).id )
    assert successor_connection_array.include?(
      connections(:nUFAS_successor_of_D).id )

    assert random_connection_array.length == 2
    assert random_connection_array.include?(
      connections(:nUFAS_predecessor_of_E).id )
    assert random_connection_array.include?( connections(:nUFAS_child_of_M).id )
  end

  test "should correctly group is-object connections" do
    n = items(:itemUsedFrequentlyAsObject)
    get :show, :id => n.id

    # given content of test/fixtures/connections.yml,
    #   expect connection_list as follows:
    #     [[6 connection IDs, sorted (primarily) by connection's predicate ]]
    assert connection_list = assigns(:connection_list)
    assert connection_list.length == 1
    connections = connection_list.first
    assert connections.length == 6
    assert connections.include?( connections(:a_isAssigned_nUFAO).id )
    assert connections.include?( connections(:b_isAssigned_nUFAO).id )
    assert connections.include?( connections(:c_isAssigned_nUFAO).id )
    assert connections.include?( connections(:d_isAssigned_nUFAO).id )
    assert connections.include?( connections(:e_isAssigned_nUFAO).id )
    assert connections.include?( connections(:c_peer_of_nUFAO).id )
    # minimal sort-order test
    assert Connection.find(connections.first).predicate_id !=
      Connection.find(connections.last).predicate_id
  end

  test "should show all predicate connections in last group" do
    n = Item.find_by_name("sub_property_of")
    get :show, :id => n.id

    # this time, check built-in "seed" schema.  Lots o' indiv's use sub_prop_of
    # connection_list should look like: [ ... [many connections]]
    assert connection_list = assigns(:connection_list)
    assert connection_list.length >= 1
    connections = connection_list.last
    assert connections.length >= 19
    # and check some representative items
    spo_id = Item.find_by_name("sub_property_of").id
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?", spo_id, spo_id,
        Item.find_by_name("hierarchical_relationship").id ]).id )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        Item.find_by_name("contains").id, spo_id,
        Item.find_by_name("parent_of").id ]).id )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        Item.find_by_name("successor_of").id, spo_id,
        Item.find_by_name("ordered_relationship").id ]).id )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        items(:isAssigned).id, spo_id,
        Item.find_by_name("value_relationship").id ]).id )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        items(:B).id, spo_id, items(:C).id ]).id )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        items(:B).id, spo_id, items(:Z).id ]).id )
  end

  test "should do-the-right-thing with item used in all kinds of connections" do
        # to minimize fixture size/complexity, copy all connections from
        # preceding cases to a new target item
    # stuff we'll need a lot
    target = items(:veryBusyItem)
    spo_id = Item.find_by_name("sub_property_of").id
    value_id = Item.find_by_name("value_relationship").id

    # connections from 'should show first connection for item with value' test
    source = items(:testSubcategory)
    known_value_connections = []
    Connection.all( :conditions => "subject_id = #{source.id}").
        each do |connection|
      if TrippleNavigation.check_properties(
          :does         => connection.predicate.id,
          :inherit_from => value_id,
          :via          => spo_id )
        connection_copy = Connection.new( :subject   => target,
                              :predicate => connection.predicate,
                              :obj       => connection.obj          )
        assert connection_copy.save
        known_value_connections << connection_copy.id
      end
    end

    # connections from 'should correctly group/sort is-subject connections' test
    source = items(:itemUsedFrequentlyAsSubject)
    known_nonvalue_subject_connections = []
    Connection.all( :conditions => "subject_id = #{source.id}").
        each do |connection|
      connection_copy = Connection.new( :subject   => target,
                            :predicate => connection.predicate,
                            :obj       => connection.obj            )
      assert connection_copy.save

      if TrippleNavigation.check_properties(
          :does         => connection.predicate.id,
          :inherit_from => value_id,
          :via          => spo_id )
        known_value_connections << connection_copy.id
     else
        known_nonvalue_subject_connections << connection_copy.id
      end
    end

    # connections from 'should correctly group is-object connections' test
    source = items(:itemUsedFrequentlyAsObject)
    known_object_connections = []
    Connection.all( :conditions => "obj_id = #{source.id}" ).
        each do |connection|
      connection_copy = Connection.new( :subject   => connection.subject,
                            :predicate => connection.predicate,
                            :obj       => target            )
      assert connection_copy.save
      known_object_connections << connection_copy.id
    end

    # 'should show all predicate connections in last group' test
    source = Item.find_by_name("sub_property_of")
    known_predicate_connections = []
    Connection.all( :conditions => "predicate_id = #{source.id}" ).
        each do |connection|
      connection_copy = Connection.new( :subject => connection.subject,
        :predicate => target, :obj => connection.obj  )
      assert connection_copy.save
      known_predicate_connections << connection_copy.id
    end

        # now, execute the "show" action
    get :show, :id => target.id

        # and perform checks
    assert connection_list = assigns(:connection_list)
    # value connections come first
    connections = connection_list.delete_at(0)
    assert connections.sort == known_value_connections.sort

    # predicate connections come last
    connections = connection_list.delete_at(-1)
    assert connections.sort == known_predicate_connections.sort

    # object connections second to last
    connections = connection_list.delete_at(-1)
    assert connections.sort == known_object_connections.sort

    # and all thats left should be groups of non-value is-subject connections
    assert connection_list.length    == 3 # constants from preceding test
    assert connection_list[0].length == 3
    assert connection_list[1].length == 2
    assert connection_list[2].length == 2
    assert connection_list.flatten.sort ==
      known_nonvalue_subject_connections.sort
  end

  test "should get edit item page" do
    assert_controller_behavior_with_id :edit
  end

  test "should update item" do
    n, h = prep_for_update(:one)
    h[:name] = new_name = "two"
    assert_no_difference('Item.count') do
      put :update, :id => n.id, :item => h
    end
    assert_redirected_to item_by_name_path(new_name)
    assert_not_nil Item.find_by_name(new_name)
  end

  test "should not update builtin item" do
    name = "sub_property_of"
    before = Item.find_by_name(name)
    during = before
    during.name = "VeryVeryBad"
    assert_no_difference('Item.count') do
      put :update, :id => during.id, :item => ItemHelper.item_to_hash(during)
    end

    # db unchanged?
    after = Item.find_by_name(name)
    assert before == after

    # right output?
    assert assigns(:item) == before
    assert_redirected_to item_by_name_path(name)
  end

  # validation tests here because these restrictions are enforced by
  # the controller -- "." and ":" are allowed by the model because
  # they're used in internally-generated item names
  test "should not update item if name changed to include a period" do
    n, h = prep_for_update(:one)
    h[:name] = "na.me"
    assert_no_difference('Item.count') do
      put :update, :id => n.id, :item => h
    end
    assert_response :success
    assert_template "items/edit"
    assert_select "body", /error/
  end
  test "should not update item if name changed to include a colon" do
    n, h = prep_for_update(:one)
    h[:name] = "na:me"
    assert_no_difference('Item.count') do
      put :update, :id => n.id, :item => h
    end
    assert_response :success
    assert_template "items/edit"
    assert_select "body", /error/
  end

  test "should delete item" do
    n = items(:two)
    name = n.name
    assert_difference('Item.count', -1) do
      delete :destroy, :id => n.id
    end
    assert_redirected_to items_path
    assert_nil Item.find_by_name(name)
  end

  test "should not delete builtin item" do
    assert_item_wont_delete(Item.find_by_name("value_relationship"))
  end

  test "should not delete item in use by an connection" do
    assert_item_wont_delete(items(:testIndividual))
  end

  test "should lookup existing item" do
    name = "testCategory"
    get :lookup, :name => name
    assert_response :success
    id = Item.find_by_name(name).id.to_s
    assert @response.body =~ /^<id>\s*#{id}\s*<\/id>\s*$/
  end

  test "should 404 on attempt to lookup non-existent item" do
    get :lookup, :name => "notAItem"
    assert_response :missing
  end


private
  def prep_for_update(fixture_name)
    n = items(fixture_name)
    return n, ItemHelper.item_to_hash(n)
  end

  def assert_controller_behavior_with_id(action)
    id = items(:one).id
    get action, :id => id
    assert_response :success
    item = assigns(:item)
    assert_not_nil item
    assert_equal id, item.id
  end

  def assert_item_wont_delete(n)
    name = n.name
    assert_difference('Item.count', 0) do
      delete :destroy, :id => n.id
    end
    assert_redirected_to item_by_name_path(name)
    assert_not_nil n == Item.find_by_name(name)
  end
end
