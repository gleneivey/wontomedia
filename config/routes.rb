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
  map.admin_index   '/admin', :controller => 'admin', :action => 'index'
  map.admin_node_up '/admin/node_up', :controller => 'admin',
    :action => 'node_up'
  map.admin_edge_up '/admin/edge_up', :controller => 'admin',
    :action => 'edge_up'

  map.nodes_lookup '/nodes/lookup', :controller => :nodes, :action => :lookup
  map.nodeCreatePopup '/nodes/new-pop',
    :controller => :nodes, :action => :newpop
  map.resources :nodes

  map.resources :edges
  map.root :controller => "nodes", :action => "home"

  # Install the default routes as the lowest priority.
#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'
end
