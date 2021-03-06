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

  test "new form without params should have fresh item object" do
    get :new
    assert_not_nil item = assigns(:item)
    assert_nil item.class_item_id
    assert_nil item.sti_type
    assert_nil item.name
    assert_nil item.title
    assert_nil item.description
  end

  test "new form with class param should set class" do
    target_class_id = items(:anotherClass).id
    get :new, :class_item => target_class_id
    assert_not_nil item = assigns(:item)
    assert item.class_item_id == target_class_id
    assert_nil item.sti_type
    assert_nil item.name
    assert_nil item.title
    assert_nil item.description
  end

  test "new form with class that specifies type should set both" do
    target_class_id = items(:testClass).id
    get :new, :class_item => target_class_id
    assert_not_nil item = assigns(:item)
    assert item.class_item_id == target_class_id
    assert item.sti_type == 'IndividualItem'
    assert_nil item.name
    assert_nil item.title
    assert_nil item.description
  end

  test "new form with class and type params should set both" do
    target_class_id = items(:anotherClass).id
    target_type = 'CategoryItem'
    get :new, :class_item => target_class_id, :sti_type => target_type
    assert_not_nil item = assigns(:item)
    assert item.class_item_id == target_class_id
    assert item.sti_type == target_type
    assert_nil item.name
    assert_nil item.title
    assert_nil item.description
  end

  test "new form should have list of available classes" do
    get :new
    assert_not_nil class_list = assigns(:class_list)
    assert class_list.include? items(:testClass)
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

  test "new-pop form should have list of available classes" do
    get :newpop
    assert_not_nil class_list = assigns(:class_list)
    assert class_list.include? items(:anotherClass)
  end

  test "new-pop form should have type parameter" do
    knownTypeValue = "noun"
    get :newpop, :popup_type => knownTypeValue
    assert assigns(:popup_type) == knownTypeValue
  end

  test "should create item with valid data-no class" do
    name = "itemName"
    assert_difference('Item.count') do
      post :create, :item => {
        :name => name, :title => "title", :sti_type => "CategoryItem" }
    end
    assert_redirected_to item_by_name_path(name)
    assert_not_nil Item.find_by_name(name)
  end

  test "should create item with valid data and class" do
    name = "instanceName"
    class_item = items(:testClass)
    assert_difference('Item.count') do
      post :create, :item => {
        :name => name, :title => "title", :sti_type => "IndividualItem",
        :class_item_id => class_item.id }
    end
    assert_redirected_to item_by_name_path(name)
    assert_not_nil item = Item.find_by_name(name)
    assert_not_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      item.id,
      Item.find_by_name('is_instance_of').id,
      class_item.id ] )
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
    item = items(:testSubcategory)
    get :show, :id => item.id

    connection = connections(:subcategoryHasValue)
    assert assigns(:item_hash)[connection.predicate_id]
    assert assigns(:item_hash)[connection.obj_id]

    assert array_of_arrays = assigns(:connection_list)
    assert array_of_arrays.length >= 1
    array_of_value_connections = array_of_arrays.first
    assert array_of_value_connections.length >= 1
    assert array_of_value_connections.include?( connection )
  end

  # relevant fixture content:
  #   testInstance is_instance_of testClass
  #   testProperty applies_to_class testClass
  #   [but nothing like: testInstance testProperty ____]
  test "first group should include add connection element for class" do
    item = items(:testInstance)
    property = items(:testProperty)
    get :show, :id => item.id

    assert assigns(:item_hash)[property.id]
    assert connection_group = assigns(:connection_list)[0]
    assert assigns(:item_hash)[property.id]
    assert_not_nil connection_group.find do |connection|
      connection.subject_id == item.id &&
        connection.predicate_id == property.id &&
        connection.obj_id == nil
    end
  end

  # The next several tests confirm that the controller's 'show' method
  # correctly populates the @connection_list array-of-arrays that
  # contains references for all of the edges that reference the page's
  # item.  This is expected to be used to populate a list of
  # connections in the items/show page, and the definition of how the
  # arrays are composed is in the RDoc for Items.show.
  test "should correctly group/sort is-subject connections" do
    item = items(:itemUsedFrequentlyAsSubject)
    get :show, :id => item.id

    assert is_subj_connections = assigns(:connection_list)[0]
    assert is_subj_connections.length >= 9
    assert is_subj_connections.include?( connections(:nUFAS_value_A) )
    assert is_subj_connections.include?( connections(:nUFAS_isAssigned_B) )
    assert is_subj_connections.include?( connections(:nUFAS_peer_of_X) )
    assert is_subj_connections.include?( connections(:nUFAS_peer_of_Y) )
    assert is_subj_connections.include?( connections(:nUFAS_peer_of_Z) )
    assert is_subj_connections.include?( connections(:nUFAS_successor_of_C) )
    assert is_subj_connections.include?( connections(:nUFAS_successor_of_D) )
    assert is_subj_connections.include?( connections(:nUFAS_predecessor_of_E) )
    assert is_subj_connections.include?( connections(:nUFAS_child_of_M) )
  end

  test "should correctly group is-object connections" do
    item = items(:itemUsedFrequentlyAsObject)
    get :show, :id => item.id

    # given content of test/fixtures/connections.yml,
    #   expect connection_list as follows:
    #     [[6 connection IDs, sorted (primarily) by connection's predicate ]]
    assert connection_list = assigns(:connection_list)
    assert connection_list.length == 1
    connections = connection_list.first
    assert connections.length == 6
    assert connections.include?( connections(:a_isAssigned_nUFAO) )
    assert connections.include?( connections(:b_isAssigned_nUFAO) )
    assert connections.include?( connections(:c_isAssigned_nUFAO) )
    assert connections.include?( connections(:d_isAssigned_nUFAO) )
    assert connections.include?( connections(:e_isAssigned_nUFAO) )
    assert connections.include?( connections(:c_peer_of_nUFAO) )
    # minimal sort-order test
    assert connections.first.predicate_id != connections.last.predicate_id
  end

  test "should show all predicate connections in last group" do
    item = Item.find_by_name("sub_property_of")
    get :show, :id => item.id

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
        Item.find_by_name("hierarchical_relationship").id ]) )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        Item.find_by_name("contains").id, spo_id,
        Item.find_by_name("parent_of").id ]) )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        Item.find_by_name("successor_of").id, spo_id,
        Item.find_by_name("ordered_relationship").id ]) )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        items(:isAssigned).id, spo_id,
        Item.find_by_name("value_relationship").id ]) )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        items(:B).id, spo_id, items(:C).id ]) )
    assert connections.include?( Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
        items(:B).id, spo_id, items(:Z).id ]) )
  end

  test "should do-the-right-thing with item used in all kinds of connections" do
        # to minimize fixture size/complexity, copy all connections from
        # preceding cases to a new target item
    # stuff we'll need a lot
    target = items(:veryBusyItem)
    spo_id = Item.find_by_name("sub_property_of").id
    value_id = Item.find_by_name("value_relationship").id

    # connections from 'should correctly group is-object connections' test
    source = items(:itemUsedFrequentlyAsObject)
    known_object_connections = []
    Connection.all( :conditions => "obj_id = #{source.id}" ).
        each do |connection|
      connection_copy = Connection.new(
        :subject     => connection.subject,
        :predicate   => connection.predicate,
        :obj         => target,
        :kind_of_obj => connection.kind_of_obj   )
      connection_copy.save  # fails for duplicating what's in fixture, but OK
      known_object_connections << connection_copy
    end

    # 'should show all predicate connections in last group' test
    source = Item.find_by_name("sub_property_of")
    known_predicate_connections = []
    Connection.all( :conditions => "predicate_id = #{source.id}" ).
        each do |connection|
      connection_copy = Connection.new(
        :subject => connection.subject, :predicate => target,
        :obj => connection.obj, :kind_of_obj => connection.kind_of_obj )
      connection_copy.save  # fails for duplicating what's in fixture, but OK
      known_predicate_connections << connection_copy
    end

        # now, execute the "show" action
    get :show, :id => target.id
    assert connection_list = assigns(:connection_list)

        # and perform checks
    # predicate connections come last
    connections = connection_list.delete_at(-1)
    assert_connections_lists_have_identical_content(
      connections, known_predicate_connections )

    # object connections second to last
    connections = connection_list.delete_at(-1)
    assert_connections_lists_have_identical_content(
      connections, known_object_connections )

    # subject connections came first
    connections = connection_list.delete_at(0)
    assert_connection_list_contains_another( connections,
      Connection.all( :conditions => "subject_id = #{target.id}") )
  end

  # fixtures contain the following connections that should imply others:
  #   testCategory parent_of testSubcategory
  #   itemUsedFrequentlyAsSubject child_of M
  #   itemUsedFrequentlyAsSubject successor_of C
  #   itemUsedFrequentlyAsSubject successor_of D
  #                             E successor_of D
  #   itemUsedFrequentlyAsSubject predecessor_of E
  # all of which can be used to test operations
  test "should show single implied connection" do
    # items/show for testSubcategory should have @connection_list =
    #  [ [ testSubcategory isAssigned testIndividual,   # value property
    #      testSubcategory *child_of* testCategory   ], # single-use pred
    #    [ testCategory parent_of testSubcategory ] ]   # non-subj connections
    item = items(:testSubcategory)
    get :show, :id => item.id

    assert inverses_map = assigns(:inverses_map)
    assert con_list = assigns(:connection_list)
    assert con_list.length == 2

    # yes, I could fold these assert blocks into a loop, but keeping
    # them distinct gives separate source line numbers if an assert fails
    con_array = con_list[0]
    assert con_array.length == 2
    assert con_array[0].predicate_id == items(:isAssigned).id

    child_id = Item.find_by_name("child_of").id
    implied_connection = con_array[1]
    assert implied_connection.predicate_id == child_id

    con_array = con_list[1]
    assert con_array.length == 1
    assert source_connection = con_array[0]
    assert source_connection.predicate_id == Item.find_by_name("parent_of").id

    assert item_hash = assigns(:item_hash)
    assert item_hash[child_id]
    assert inverses_map[implied_connection] == source_connection
  end

  test "should show multiple implied connections" do
    # items/show for D should have @connection_list =
    #  [ [ D isAssigned itemUsedFrequentlyAsObject,     # value property
    #      D *predecessor_of* E,                        # common properties
    #      D *predecessor_of* itemUsedFrequentlyAsSubject,
    #      D sub_property_of E                     ],   # @item as subj.
    #    [ E successor_of D,                            # @item as obj.
    #      C sub_property_of D,
    #      itemUsedFrequentlyAsSubject successor_of D ] ]
    item = items(:D)
    get :show, :id => item.id

    assert con_list = assigns(:connection_list)
    assert con_list.length == 2

    # now that we've checked the array-of-arrays length, just assert for
    # the sub-lengths and connections we expect to have been added
    assert con_list[0].length == 4
    assert con_list[1].length == 3

    pred = Item.find_by_name("predecessor_of")
    known_array = [
      Connection.new( :subject => item, :predicate => pred,
        :obj => items(:itemUsedFrequentlyAsSubject),
        :kind_of_obj => Connection::OBJECT_KIND_ITEM                      ),
      Connection.new( :subject => item, :predicate => pred,
        :obj => items(:E), :kind_of_obj => Connection::OBJECT_KIND_ITEM   )
    ]
    assert_connection_list_contains_another( con_list[0], known_array )

    assert item_hash = assigns(:item_hash)
    assert item_hash[pred.id]

    assert inverses_map = assigns(:inverses_map)
    con_list[0].select{|con| con.predicate_id == pred.id }.each do |connection|
      assert inverses_map[connection]
    end
  end

  test "should get edit item page" do
    assert_controller_behavior_with_id :edit
  end

  test "should get edit item page for item with class" do
    assert_controller_behavior_with_id :edit, :testInstance
    assert_not_nil class_list = assigns(:class_list)
    assert class_list.include? items(:anotherClass)
  end

  test "should update item" do
    item, h = prep_for_update(:testInstance)
    h[:name] = new_name = "two"
    another_class_id = items(:anotherClass).id
    h[:class_item_id] = another_class_id
    assert_no_difference('Item.count') do
      put :update, :id => item.id, :item => h
    end
    assert_redirected_to item_by_name_path(new_name)
    assert_not_nil item = Item.find_by_name(new_name)
    assert item.class_item.id == another_class_id
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
    item = items(:two)
    name = item.name
    assert_difference('Item.count', -1) do
      delete :destroy, :id => item.id
    end
    assert_redirected_to items_path
    assert_nil Item.find_by_name(name)
  end

  test "should delete even items with a class" do
    item = items(:testInstance)
    name = item.name
    assert_difference('Item.count', -1) do
      assert_difference('Connection.count', -1) do
        delete :destroy, :id => item.id
      end
    end
    assert_redirected_to items_path
    assert_nil Item.find_by_name(name)
    assert_nil Connection.first( :conditions => [
      "subject_id = ? OR predicate_id = ? OR obj_id = ?",
      item.id, item.id, item.id ] )
  end

  test "should not delete builtin item" do
    assert_item_wont_delete(Item.find_by_name("value_relationship"))
  end

  test "should not delete item in use by a connection" do
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
  def prep_for_update(fixture_symbol)
    item = items(fixture_symbol)
    return item, ItemHelper.item_to_hash(item)
  end

  def assert_controller_behavior_with_id(action, item_symbol = :one)
    id = items(item_symbol).id
    get action, :id => id
    assert_response :success
    item = assigns(:item)
    assert_not_nil item
    assert_equal id, item.id
  end

  def assert_item_wont_delete(item)
    name = item.name
    assert_difference('Item.count', 0) do
      delete :destroy, :id => item.id
    end
    assert_redirected_to item_by_name_path(name)
    assert_not_nil item == Item.find_by_name(name)
  end

  def assert_connections_lists_have_identical_content(
      one_input_set, another_input_set )
    another_set = Array.new( another_input_set )

    one_input_set.each do |connection|
      found_match = false
      another_set.each do |possible_match|
        if  connection.subject_id   == possible_match.subject_id and
            connection.predicate_id == possible_match.predicate_id and
            connection.obj_id       == possible_match.obj_id
          found_match = true
          another_set.delete possible_match
          break;
        end
      end
      assert found_match
    end
  end

  def assert_connection_list_contains_another( superset, subset )
    subset.each do |connection|
      found_match = false
      superset.each do |possible_match|
        if  connection.subject_id   == possible_match.subject_id and
            connection.predicate_id == possible_match.predicate_id and
            connection.obj_id       == possible_match.obj_id
          found_match = true
          break;
        end
      end
      assert found_match
    end
  end
end
