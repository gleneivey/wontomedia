# WontoMedia - a wontology web application
# Copyright (C) 2009 - Glen E. Ivey
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
  test "home page is nodes-index" do
    assert_routing '/', { :controller => "nodes", :action => "home" }
  end

  test "index node page" do
    assert_routing '/nodes', { :controller => "nodes", :action => "index" }
    assert_equal   '/nodes', url_for( :controller => "nodes",
                                      :action => "index", :only_path => true )
  end

  test "new node form" do
    assert_routing '/nodes/new', {     :controller => "nodes",
                                       :action => "new" }
    assert_equal '/nodes/new', url_for(:controller => "nodes",
                                       :action => "new", :only_path => true)
  end

  test "show node page" do
    assert_routing '/nodes/42', { :controller => "nodes",
      :action => "show", :id => "42" }
    assert_equal '/nodes/42', url_for(:controller => "nodes", :action => "show",
                                      :id => "42", :only_path => true)
  end

  test "edit node page" do
    assert_routing '/nodes/42/edit', { :controller => "nodes",
      :action => "edit", :id => "42" }
    assert_equal '/nodes/42/edit', url_for(:controller => "nodes",
                                           :action => "edit", :id => "42",
                                           :only_path => true)
  end

  test "update node action" do
    assert_routing(
      { :method => 'put', :path => '/nodes/42' },
      { :controller => "nodes", :action => "update", :id => "42" } )
    assert_equal '/nodes/42', url_for(:controller => "nodes",
                                      :action => "update", :id => "42",
                                      :only_path => true)
  end
end
