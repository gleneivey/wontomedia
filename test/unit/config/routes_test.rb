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

class RoutesTest < ActionController::IntegrationTest
  test "home page is items-index" do
    assert_routing '/', { :controller => "items", :action => "home" }
  end

  test "index item page" do
    assert_routing '/items', { :controller => "items", :action => "index" }
    assert_equal   '/items', url_for( :controller => "items",
      :action => "index", :only_path => true )
  end

  test "new item form" do
    assert_routing '/items/new', { :controller => "items", :action => "new" }
    assert_equal '/items/new', url_for(:controller => "items",
      :action => "new", :only_path => true)
  end

  test "show item page" do
    assert_routing '/items/42', { :controller => "items",
      :action => "show", :id => "42" }
    assert_equal '/items/42', url_for(:controller => "items", :action => "show",
      :id => "42", :only_path => true)
  end

  test "edit item page" do
    assert_routing '/items/42/edit', { :controller => "items",
      :action => "edit", :id => "42" }
    assert_equal '/items/42/edit', url_for(:controller => "items",
      :action => "edit", :id => "42", :only_path => true)
  end

  test "update item action" do
    assert_routing(
      { :method => 'put', :path => '/items/42' },
      { :controller => "items", :action => "update", :id => "42" } )
    assert_equal '/items/42', url_for(:controller => "items",
      :action => "update", :id => "42", :only_path => true)
  end
end
