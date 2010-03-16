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
require 'enumerator'

class ConnectionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:connections)
  end

  test "sould get N3-format all-connections download/index" do
    # make sure we've got a scalar-object'ed connection
    Connection.new(
      :subject => items(:one), :predicate => items(:isAssigned),
      :scalar_obj => "the web resource http://a.site.tld",
      :kind_of_obj => Connection::OBJECT_KIND_SCALAR
    ).save

    get :index, :format => "n3"
    assert @response.header['Content-Type'] =~ /application\/x-n3/

    Connection.all.each do |connection|
      if connection.kind_of_obj == Connection::OBJECT_KIND_ITEM

        connection_re = /#{connection.subject.name}.+#{connection.predicate.name}.+#{connection.obj.name}/
        connection_message =
          "#{connection.subject.name}-" +
          "#{connection.predicate.name}-" +
          "#{connection.obj.name}"

        if connection.flags & Connection::DATA_IS_UNALTERABLE == 0
          assert @response.body =~ connection_re,
            "Expected '#{connection_message}' connection but didn't find"
        else
          assert !(@response.body =~ connection_re),
            "Found '#{connection_message}' connection, but didn't expect"
        end
      else

        connection_re = /#{connection.subject.name}.+#{connection.predicate.name}.+#{connection.scalar_obj}/
        connection_message =
          "#{connection.subject.name}-" +
          "#{connection.predicate.name}-" +
          "#{connection.scalar_obj}"

        if connection.flags & Connection::DATA_IS_UNALTERABLE == 0
          assert @response.body =~ connection_re,
            "Expected '#{connection_message}' connection but didn't find"
        else
          assert !(@response.body =~ connection_re),
            "Found '#{connection_message}' connection, but didn't expect"
        end
      end
    end
  end

  test "should get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:items)
    assert_not_nil assigns(:verbs)
  end

  test "new form should have fresh connection object" do
    get :new
    connection = assigns(:connection)
    assert_not_nil connection
    assert_nil connection.subject_id
    assert_nil connection.predicate_id
    assert_nil connection.obj_id
    assert_nil connection.scalar_obj
    assert_nil connection.kind_of_obj
    assert_nil connection.connection_desc_id
  end

  test "new form should populate arrays for view" do
    get :new

    # spot-check for presence/absence of one known item of each STI child type
    items = assigns(:items)
    assert   items.include?( items(:testCategory) )
    assert   items.include?( items(:testIndividual) )
    assert   items.include?( items(:testProperty) )
    assert !(items.include?( items(:connection_one) ))

    verbs = assigns(:verbs)
    assert !(verbs.include?( items(:testCategory) ))
    assert !(verbs.include?( items(:testIndividual) ))
    assert   verbs.include?( items(:testProperty) )
    assert !(verbs.include?( items(:connection_one) ))
  end

  # possible connection combinations with Items as the connection's object:
  #   class    -- class
  #   class    -- individual
  #   indiv'l  -- individual
  #   indiv'l  -- class    [non-hierarchical only]
  #   property -- property [only type that can use "sub_property_of"]
  #   property -- class
  #   property -- individual
  #   class    -- property
  #   indiv'l  -- property
  # note: checks for rejection of invalid connection cases
  #     are in unit/models/connection
  test "should create all valid connections with item objects" do
    subj_items = [
      items(:testCategory), items(:testIndividual), items(:testProperty) ]
    obj_items  = [
      items(:two), items(:one), items(:isAssigned) ]
    verb_items = [
      Item.find_by_name( "parent_of" ),                    # tC -> tC
      Item.find_by_name( "contains" ),                     # tC -> tI
      Item.find_by_name( "hierarchical_relationship" ),    # tC -> tP
      Item.find_by_name( "one_of" ),                       # tI -> tC
      Item.find_by_name( "peer_of" ),                      # tI -> tI
      items(             :A ),                             # tI -> tP
      Item.find_by_name( "child_of" ),                     # tP -> tC
      items(             :testProperty ),                  # tP -> tI
      Item.find_by_name( "sub_property_of" ),              # tP -> tP
    ]

    verbs = verb_items.to_enum
    subj_items.each do |subj_item|
      obj_items.each do |obj_item|

        assert_difference('Connection.count') do
          post :create, :connection => {
            :subject_id => subj_item.id, :predicate_id => verbs.next.id,
            :obj_id => obj_item.id,
            :kind_of_obj => Connection::OBJECT_KIND_ITEM }
        end
        assert_redirected_to connection_path(assigns(:connection))
        assert_not_nil Connection.find(assigns(:connection).id)
      end
    end
  end

  # possible connection combinations with scalar objects:
  #   class    -- scalar
  #   indiv'l  -- scalar
  #   property -- scalar
  test "should create all valid connections with scalar objects" do
    subj_items = [
      items(:testCategory), items(:testIndividual), items(:testProperty) ]
    verb_item = items(:isAssigned)
    obj_values = [
      'now is the time', '3.14159', 'August 27, 1918 at 3:03pm Eastern',
      'http://wontology.org/', 'Ontology (information science)', '42']

    subj_items.each do |subj_item|
      obj_values.each do |obj_value|
        assert_difference('Connection.count') do
          post :create, :connection => {
            :subject_id => subj_item.id, :predicate_id => verb_item.id,
            :scalar_obj => obj_value,
            :kind_of_obj => Connection::OBJECT_KIND_SCALAR }
        end
        assert_redirected_to connection_path(assigns(:connection))
        assert_not_nil Connection.find(assigns(:connection).id)
      end
    end
  end

  test "should not create a connection if tripple missing predicate" do
    s_id = items(:testContainer).id
    o_id = items(:testIndividual).id

    assert_no_difference('Connection.count') do
      post :create, :connection => { :subject_id => s_id, :obj_id => o_id,
        :kind_of_obj => Connection::OBJECT_KIND_ITEM }
    end
    assert_response :success
    assert_template "connections/new"
    assert_select "body", /Predicate can't be blank/
  end

  test "should not create a connection if tripple missing subject" do
    p_id = items(:testProperty).id

    assert_no_difference('Connection.count') do
      post :create, :connection => { :predicate_id => p_id,
        :scalar_obj => 'Look, a string!',
        :kind_of_obj => Connection::OBJECT_KIND_SCALAR }
    end
    assert_response :success
    assert_template "connections/new"
    assert_select "body", /Subject can't be blank/
  end

  test "should not create a connection if missing kind_of_object" do
    s_id = items(:testIndividual).id
    p_id = items(:testProperty).id

    assert_no_difference('Connection.count') do
      post :create, :connection => { :subject_id => s_id, :predicate_id => p_id,
        :scalar_obj => 'Look, a string!', :obj_id => s_id }
    end
    assert_response :success
    assert_template "connections/new"
    assert_select "body", /Kind of obj isn't valid/
  end

  test "should not create a connection if tripple missing item object" do
    s_id = items(:testIndividual).id
    p_id = items(:testProperty).id

    assert_no_difference('Connection.count') do
      post :create, :connection => { :subject_id => s_id, :predicate_id => p_id,
        :scalar_obj => 'Look, a string!',
        :kind_of_obj => Connection::OBJECT_KIND_ITEM }
    end
    assert_response :success
    assert_template "connections/new"
    assert_select "body", /Obj can't be blank/
  end

  test "should not create a connection if tripple missing scalar object" do
    s_id = items(:testIndividual).id
    p_id = items(:testProperty).id

    assert_no_difference('Connection.count') do
      post :create, :connection => { :subject_id => s_id, :predicate_id => p_id,
        :obj_id => s_id, :kind_of_obj => Connection::OBJECT_KIND_SCALAR }
    end
    assert_response :success
    assert_template "connections/new"
    assert_select "body", /Scalar obj can't be blank/
  end

  test "show connection should populate data--item objectn" do
    id = connections(:aQualifiedConnection).id
    get :show, :id => id
    assert_response :success
    assert connection = assigns(:connection)
    assert connection.id == id

    assert s = assigns(:subject)
    assert p = assigns(:predicate)
    assert o = assigns(:obj)
    assert slf = assigns(:connection_desc)

    assert s == connection.subject
    assert p == connection.predicate
    assert o == connection.obj
    assert slf == connection.connection_desc
  end

  test "show connection should populate data--scalar object" do
    id = connections(:aConnectionToScalar).id
    get :show, :id => id
    assert_response :success
    assert connection = assigns(:connection)
    assert connection.id == id

    assert s = assigns(:subject)
    assert p = assigns(:predicate)

    assert s == connection.subject
    assert p == connection.predicate
  end

  test "should get edit connection page" do
    id = connections(:aQualifiedConnection).id
    get :edit, :id => id
    assert_response :success
    connection = assigns(:connection)
    assert_not_nil connection
    assert_equal id, connection.id
  end

  test "should update connections with changed subject" do
    con = connections(:aParentConnection)
    new_subject_id = items(:B).id
    hash_of_inputs = { :id => con.id,
      :subject_id => new_subject_id, :predicate_id => con.predicate_id,
      :obj_id => con.obj_id, :kind_of_obj => con.kind_of_obj }
    assert_no_difference('Connection.count') do
      put :update, :id => con.id, :connection => hash_of_inputs
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      new_subject_id, con.predicate_id, con.obj_id   ])
  end

  test "should update connections with changed predicate" do
    con = connections(:aConnectionToScalar)
    new_predicate_id = items(:C).id
    hash_of_inputs = { :id => con.id,
      :subject_id => con.subject_id, :predicate_id => new_predicate_id,
      :scalar_obj => con.scalar_obj, :kind_of_obj => con.kind_of_obj }
    assert_no_difference('Connection.count') do
      put :update, :id => con.id, :connection => hash_of_inputs
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND scalar_obj = ?",
      con.subject_id, new_predicate_id, con.scalar_obj   ])
  end

  test "should update connections with item objects" do
    con = connections(:aParentConnection)
    new_obj_id = items(:A).id
    hash_of_inputs = { :id => con.id,
      :subject_id => con.subject_id, :predicate_id => con.predicate_id,
      :obj_id => new_obj_id, :kind_of_obj => con.kind_of_obj }
    assert_no_difference('Connection.count') do
      put :update, :id => con.id, :connection => hash_of_inputs
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      con.subject_id, con.predicate_id, new_obj_id   ])
  end

  test "should update connections with scalar objects" do
    con = connections(:aConnectionToScalar)
    new_scalar_obj = '98'
    hash_of_inputs = { :id => con.id,
      :subject_id => con.subject_id, :predicate_id => con.predicate_id,
      :scalar_obj => new_scalar_obj, :kind_of_obj => con.kind_of_obj }
    assert_no_difference('Connection.count') do
      put :update, :id => con.id, :connection => hash_of_inputs
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND scalar_obj = ?",
      con.subject_id, con.predicate_id, new_scalar_obj   ])
  end

  test "should update connection object from scalar to item" do
    con = connections(:aConnectionToScalar)
    new_obj_id = items(:D).id
    hash_of_inputs = { :id => con.id,
      :subject_id => con.subject_id, :predicate_id => con.predicate_id,
      :obj_id => new_obj_id, :kind_of_obj => Connection::OBJECT_KIND_ITEM }
    assert_no_difference('Connection.count') do
      put :update, :id => con.id, :connection => hash_of_inputs
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil new_con = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      con.subject_id, con.predicate_id, new_obj_id   ])
    assert new_con.kind_of_obj == Connection::OBJECT_KIND_ITEM
  end

  test "should update connection object from item to scalar" do
    con = connections(:nUFAS_isAssigned_B)
    new_scalar_obj = 'http://wontomedia.rubyforge.org/'
    hash_of_inputs = { :id => con.id,
      :subject_id => con.subject_id, :predicate_id => con.predicate_id,
      :scalar_obj => new_scalar_obj,
      :kind_of_obj => Connection::OBJECT_KIND_SCALAR }
    assert_no_difference('Connection.count') do
      put :update, :id => con.id, :connection => hash_of_inputs
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil new_con = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND scalar_obj = ?",
      con.subject_id, con.predicate_id, new_scalar_obj   ])
    assert new_con.kind_of_obj == Connection::OBJECT_KIND_SCALAR
  end

  test "should not update builtin connection" do
    # test define_sub_property_of connection
    subj_n   = Item.find_by_name("sub_property_of")
    obj_n    = Item.find_by_name("hierarchical_relationship")
    change_n = Item.find_by_name("child_of")
    e = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, subj_n.id, obj_n.id   ])

    before = e
    e.predicate = change_n
    h = { :id => e.id, :subject_id => e.subject_id,
      :predicate_id => e.predicate_id, :obj_id => e.obj_id }

    assert_no_difference('Connection.count') do
      put :update, :id => e.id, :connection => h
    end
    assert assigns(:connection) == e
    assert_redirected_to connection_path(e)
    assert after = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, subj_n.id, obj_n.id   ])
    assert before == after
  end

  test "should delete connection" do
    e = connections(:aQualifiedConnection)
    subj_id = e.subject_id; pred_id = e.predicate_id; obj_id = e.obj_id
    assert_difference('Connection.count', -1) do
      delete :destroy, :id => e.id
    end
    assert_redirected_to connections_path
    assert_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_id, pred_id, obj_id   ])
  end

  test "should not delete builtin connection" do
    # test define_inverse_relationship connection
    subj_n = Item.find_by_name("inverse_relationship")
    pred_n = Item.find_by_name("sub_property_of")
    obj_n  = Item.find_by_name("symmetric_relationship")
    e = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, pred_n.id, obj_n.id   ])

    assert_difference('Connection.count', 0) do
      delete :destroy, :id => e.id
    end
    assert assigns(:connection) == e
    assert_redirected_to connection_path(e)
    assert after = Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      subj_n.id, pred_n.id, obj_n.id   ])
    assert e == after
  end
end
