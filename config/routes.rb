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


ActionController::Routing::Routes.draw do |map|
  #### temporary: 301's for old-style REST URLs outside of the /w/ space
  map.redirect '/items/*i', '/w/items', :keep_path => :i, :permanent => true
  map.redirect '/connections/*c', '/w/connections', :keep_path => :c,
    :permanent => true

    # more specific routes that override...
  map.items_lookup '/items/lookup', :controller => :items, :action => :lookup,
    :path_prefix => '/w'
  map.itemCreatePopup '/items/new-pop', :controller => :items,
    :action => :newpop, :path_prefix => '/w'

    # .... these general routes
  map.root :controller => "items", :action => "home"
  map.resources :items, :path_prefix => '/w'

  map.resources :connections, :path_prefix => '/w'

  map.admin_index   '/w/admin', :controller => 'admin', :action => 'index'
  map.admin_item_up '/w/admin/item_up', :controller => 'admin',
    :action => 'item_up'
  map.admin_connection_up '/w/admin/connection_up', :controller => 'admin',
    :action => 'connection_up'
end
