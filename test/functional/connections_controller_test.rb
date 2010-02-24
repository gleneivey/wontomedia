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


require 'enumerator'

class ConnectionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:connections)
  end

  test "sould get N3-format all-connections download/index" do
    get :index, :format => "n3"
    assert @response.header['Content-Type'] =~ /application\/x-n3/

    Connection.all.each do |connection|
      if connection.flags & Connection::DATA_IS_UNALTERABLE == 0
        assert @response.body =~
/#{connection.subject.name}.+#{connection.predicate.name}.+#{connection.obj.name}/,
          "Expected '#{connection.subject.name}-#{connection.predicate.name}-" +
            "#{connection.obj.name}' connection but didn't find"
      else
        assert !(@response.body =~
/#{connection.subject.name}.+#{connection.predicate.name}.+#{connection.obj.name}/),
          "Found '#{connection.subject.name}-#{connection.predicate.name}-" +
            "#{connection.obj.name}' connection, but didn't expect"
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
    assert_nil connection.connection_desc_id
  end

  test "new form should populate arrays for view" do
    get :new

    # spot-check for presence/absence of one known item of each STI child type
    ns = assigns(:items)
    assert   ns.include?( items(:testCategory) )
    assert   ns.include?( items(:testIndividual) )
    assert   ns.include?( items(:testProperty) )
    assert !(ns.include?( items(:connection_one) ))

    vs = assigns(:verbs)
    assert !(vs.include?( items(:testCategory) ))
    assert !(vs.include?( items(:testIndividual) ))
    assert   vs.include?( items(:testProperty) )
    assert !(vs.include?( items(:connection_one) ))
  end

  # possible connection combinations:
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
  #     are in unit//models/connection
  test "should create all valid connections" do
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
            :obj_id => obj_item.id  }
        end
        assert_redirected_to connection_path(assigns(:connection))
        assert_not_nil Connection.find(assigns(:connection).id)
      end
    end
  end

  test "should not create an connection if missing an element of triple" do
    s_id = items(:testContainer).id
    o_id = items(:testIndividual).id

    assert_no_difference('Connection.count') do
      post :create, :connection => { :subject_id => s_id, :obj_id => o_id }
    end
    assert_response :success
    assert_template "connections/new"
    assert_select "body", /Predicate can't be blank/
  end

  test "show connection should populate data" do
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

  test "should get edit connection page" do
    id = connections(:aQualifiedConnection).id
    get :edit, :id => id
    assert_response :success
    connection = assigns(:connection)
    assert_not_nil connection
    assert_equal id, connection.id
  end

  test "should update connection" do
    e = connections(:aParentConnection)
    e.obj_id = items(:A).id
    h = { :id => e.id, :subject_id => e.subject_id,
      :predicate_id => e.predicate_id, :obj_id => e.obj_id }
    assert_no_difference('Connection.count') do
      put :update, :id => e.id, :connection => h
    end
    assert_redirected_to connection_path(assigns(:connection))
    assert_not_nil Connection.first( :conditions => [
      "subject_id = ? AND predicate_id = ? AND obj_id = ?",
      e.subject_id, e.predicate_id, e.obj_id   ])
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
