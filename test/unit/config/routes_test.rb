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
require File.join( File.dirname(__FILE__), 'route_asserts' )

class ItemIdRestRoutesTest < ActionController::IntegrationTest
  test "home page is items-index" do
    assert_routing '/', { :controller => "items", :action => "home" }
  end

  test "index item page" do
    assert_routing '/w/items', { :controller => "items", :action => "index" }
    assert_equal   '/w/items', url_for( :controller => "items",
      :action => "index", :only_path => true )
  end

  test "new item form" do
    assert_routing '/w/items/new', { :controller => "items", :action => "new" }
    assert_equal '/w/items/new', url_for(:controller => "items",
      :action => "new", :only_path => true)
  end

  test "show item page" do
    assert_routing '/w/items/42', { :controller => "items",
      :action => "show", :id => "42" }
    assert_equal '/w/items/42',
      url_for(:controller => "items", :action => "show", :id => "42",
      :only_path => true)
  end

  test "edit item page" do
    assert_routing '/w/items/42/edit', { :controller => "items",
      :action => "edit", :id => "42" }
    assert_equal '/w/items/42/edit', url_for(:controller => "items",
      :action => "edit", :id => "42", :only_path => true)
  end

  test "update item action" do
    assert_routing(
      { :method => 'put', :path => '/w/items/42' },
      { :controller => "items", :action => "update", :id => "42" } )
    assert_equal '/w/items/42', url_for(:controller => "items",
      :action => "update", :id => "42", :only_path => true)
  end
end

class ConnectionIdRestRoutesTest < ActionController::IntegrationTest
  test "index connection page" do
    assert_routing '/w/connections', { :controller => "connections",
      :action => "index" }
    assert_equal   '/w/connections', url_for( :controller => "connections",
      :action => "index", :only_path => true )
  end

  test "new connection form" do
    assert_routing '/w/connections/new', { :controller => "connections",
      :action => "new" }
    assert_equal '/w/connections/new', url_for(:controller => "connections",
      :action => "new", :only_path => true)
  end

  test "show connection page" do
    assert_routing '/w/connections/42', { :controller => "connections",
      :action => "show", :id => "42" }
    assert_equal '/w/connections/42',
      url_for(:controller => "connections", :action => "show", :id => "42",
      :only_path => true)
  end

  test "edit connection page" do
    assert_routing '/w/connections/42/edit', { :controller => "connections",
      :action => "edit", :id => "42" }
    assert_equal '/w/connections/42/edit', url_for(:controller => "connections",
      :action => "edit", :id => "42", :only_path => true)
  end

  test "update connection action" do
    assert_routing(
      { :method => 'put', :path => '/w/connections/42' },
      { :controller => "connections", :action => "update", :id => "42" } )
    assert_equal '/w/connections/42', url_for(:controller => "connections",
      :action => "update", :id => "42", :only_path => true)
  end
end

class OldIdRoutesRedirectTest < ActionController::IntegrationTest
  def assert_redirected( path )
    assert_does_recognize path, { :controller => "redirect_routing",
      :action => "redirect" }
  end

  test "index item page"       do  assert_redirected '/items'; end
  test "new item form"         do  assert_redirected '/items/new'; end
  test "show item page"        do  assert_redirected '/items/42'; end
  test "edit item page"        do  assert_redirected '/items/42/edit'; end
  test "update item action"    do  assert_redirected(
    { :method => 'put', :path => '/items/42' } );       end
  test "index connection page" do  assert_redirected '/connections'; end
  test "new connection form"   do  assert_redirected '/connections/new'; end
  test "show connection page"  do  assert_redirected '/connections/42'; end
  test "edit connection page"  do  assert_redirected '/connections/42/edit'; end
  test "update connection action" do  assert_redirected(
    { :method => 'put', :path => '/connections/42' } ); end
end
