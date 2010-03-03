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
require Rails.root.join( 'app', 'helpers', 'format_helper' )
include(FormatHelper)

class ConnectionsIndexViewTest < ActionController::TestCase
  tests ConnectionsController

  test "should have index page for connections" do
    get :index
    assert_template "connections/index"
  end

  test "should show Title of subject item for known connection" do
    get :index
    assert_select "body", /#{regex_escape Connection.first.subject.title}/
  end

  test "should show Title of predicate item for known connection" do
    get :index
    assert_select "body",
      /#{regex_escape FormatHelper.filter_parenthetical Connection.last.predicate.title}/
  end

  test "should show Title of object item for known connection" do
    get :index
    assert_select "body",
      /#{regex_escape FormatHelper.filter_parenthetical Connection.all[1].obj.title}/
  end

  test "should show Name of self item for known connection" do
    get :index
    e = Connection.first(:conditions => "connection_desc_id IS NOT NULL")
    assert_select "body", /#{e.connection_desc.name}/
  end

  test "items index page shouldnt contain status" do
    get :index
    assert_negative_view_contents
  end

  test "should have Show link for a known connection" do
    get :index
    connection = Connection.all[2]
    assert_select ''+
      "*##{connection.id} a[href=\"#{connection_path(connection)}\"]", true
  end

  test "connections index page should have and only have right edit destroy links" do
    get :index

    Connection.all.each do |connection|
      test_sense = (connection.flags & Connection::DATA_IS_UNALTERABLE) == 0

      # edit link present/absent
      assert_select(
        "*##{connection.id} a[href=\"#{edit_connection_path(connection)}\"]",
        test_sense   )
      # delete link present/absent
      assert_select( "*##{connection.id} " +
        "a[href=\"#{connection_path(connection)}\"][onclick*=\"delete\"]",
        test_sense   )
    end
  end

  def regex_escape(inStr)    # trivial, just what we need for the seed data
    inStr.sub!( /\(/, "\\(" );
    inStr.sub!( /\)/, "\\)" );
    inStr
  end
end
