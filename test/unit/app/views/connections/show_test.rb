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

class ConnectionsShowViewTest < ActionController::TestCase
  tests ConnectionsController
  def get_connections_show()
    get :show, :id => connections(:aQualifiedConnection).id;
  end

  test "should have show page for connections" do
    get_connections_show
    assert_template "connections/show"
  end

    # subject
  test "connection-show page should contain connection's subject Item's title" do
    get_connections_show
    assert_select "body", /#{connections(:aQualifiedConnection).subject.title}/
  end

  test "connection-show page should contain connection's subject Item's name" do
    get_connections_show
    assert_select "body", /#{connections(:aQualifiedConnection).subject.name}/
  end

  test "connection-show page should contain connection's subject Item's description" do
    get_connections_show
    assert_select "body",
      /#{connections(:aQualifiedConnection).subject.description}/
  end

    # predicate
  test "connection-show page should contain connection's predicate Item's title" do
    get_connections_show
    assert_select "body",
      /#{connections(:aQualifiedConnection).predicate.title}/
  end

  test "connection-show page should contain connection's predicate Item's name" do
    get_connections_show
    assert_select "body", /#{connections(:aQualifiedConnection).predicate.name}/
  end

  test "connection-show page should contain connection's predicate Item's description" do
    get_connections_show
    assert_select "body",
      /#{connections(:aQualifiedConnection).predicate.description}/
  end

    # object
  test "connection-show page should contain connection's object Item's title" do
    get_connections_show
    assert_select "body", /#{connections(:aQualifiedConnection).obj.title}/
  end

  test "connection-show page should contain connection's object Item's name" do
    get_connections_show
    assert_select "body", /#{connections(:aQualifiedConnection).obj.name}/
  end

  test "connection-show page should contain connection's object Item's description" do
    get_connections_show
    assert_select "body",
      /#{connections(:aQualifiedConnection).obj.description}/
  end

  test "connection-show page should contain connection's scalar object value" do
    connection = connections(:aConnectionToScalar)
    get :show, :id => connection.id;
    assert_select "body", /#{connection.scalar_obj}/
  end

  test "connections show page shouldnt contain status" do
    get_connections_show
    assert_negative_view_contents
  end

  test "connections show page should have and only have right edit destroy links" do
    Connection.all.each do |connection|
      get :show, :id => connection.id

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
