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


require Rails.root.join( 'lib', 'helpers', 'node_helper')
require 'yaml'

class AdminController < ApplicationController
  # GET /admin/
  def index
  end

  # POST /admin/node_up
  def node_up
    count = 0
    YAML::load(params[:node_upload][:nodefile]).each do |node|

      # this is magic dependent on the structure of the YAML::Object class
      node_hash = node.instance_eval { @ivars }['attributes']

      n = NodeHelper.new_typed_node node_hash['sti_type']
      n.name        = node_hash['name']
      n.title       = node_hash['title']
      n.description = node_hash['description']
      n.flags       = node_hash['flags']
      n.save
      count += 1
    end

    flash[:notice] = "Created #{count} new nodes."
    redirect_to :action => 'index'
  end

  # POST /admin/edge_up
  def edge_up
    count = 0
    params[:edge_upload][:edgefile].readlines.each do |n3line|
      # this is a really, *really* bad N3 parser. Almost certainly won't
      # handly any but the most trivial input (like what we export :-)
      if n3line =~ /<#([^>]+)>[^<]+<#([^>]+)>[^<]+<#([^>]+)>[^.]+\./
        e = Edge.new
        e.subject   = Node.find_by_name($1)
        e.predicate = Node.find_by_name($2)
        e.obj       = Node.find_by_name($3)
        e.save
        count += 1
      end
    end

    flash[:notice] = "Created #{count} new edges."
    redirect_to :action => 'index'
  end
end
