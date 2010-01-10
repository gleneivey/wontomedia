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


require Rails.root.join( 'lib', 'helpers', 'node_helper')
require 'yaml'

class AdminController < ApplicationController
  # GET /admin/
  def index
  end

  # POST /admin/node_up
  def node_up
    count = 0
    flash[:error] ||= ""
    YAML::load(params[:node_upload][:nodefile]).each do |node|

      if node.is_a? Node
        # need to create a new node object so that it saves to db as "new"
        node_hash = NodeHelper.node_to_hash(node)
        name = node.name
      elsif node.is_a? YAML::Object
        # this is magic dependent on the internals of the YAML::Object class
        node_hash = node.instance_eval { @ivars }['attributes']
        name = node_hash['name'] || node_hash[:name]
      else
        flash[:error] <<
          "YAML parser generated an object of type '#{node.class}'.\n"
        redirect_to :action => 'index'
        return
      end

      n = NodeHelper.new_typed_node(
        node_hash['sti_type'] || node_hash[:sti_type] )
      if n.nil?
        err_str = "No/bad sti_type for node '#{name}', " +
          "tried to create '#{node_hash.inspect}'.\n"
        logger.error(err_str)
        flash[:error] << err_str
      else
        # even if ID present, don't copy; let db assign a new value
        n.name        = name
        n.title       = node_hash['title']       || node_hash[:title]
        n.description = node_hash['description'] || node_hash[:description]
        n.flags       = node_hash['flags']       || node_hash[:flags]
        if n.flags.nil?
          n.flags = 0
        end

        if n.save
          count += 1
        else
          err_str = "Could not save node named 'n.name': #{n.errors.inspect}\n"
          logger.error(err_str)
          flash[:error] << err_str
        end
      end
    end

    flash[:notice] = "Created #{count} new nodes."
    redirect_to :action => 'index'
  end

  # POST /admin/edge_up
  def edge_up
    count = unparsed = 0
    flash[:error] =""

    params[:edge_upload][:edgefile].readlines.each do |n3line|
      # this is a really, *really* bad N3 parser. Almost certainly won't
      # handly any but the most trivial input (like what we export :-)
      if n3line =~ /<#([^>]+)>[^<]+<#([^>]+)>[^<]+<#([^>]+)>[^.]+\./
        e = Edge.new(
          :subject   => Node.find_by_name($1),
          :predicate => Node.find_by_name($2),
          :obj       => Node.find_by_name($3),
          :flags     => 0
                     )
        if e.nil?
          err_stry = "Couldn't create edge for #{$1} #{$2} #{$3}.\n"
          logger.error(err_str)
          flash[:error] << err_str
        else
          if e.save
            count += 1
          else
            err_stry = "Couldn't save edge for #{$1} #{$2} #{$3}.\n"
            logger.error(err_str)
            flash[:error] << err_str
          end
        end
      else
        unparsed += 1
      end
    end

    flash[:notice] = "Created #{count} new edges."
    if unparsed > 0
      flash[:notice] << "(Discarded #{unparsed} non-edge lines from input file)"
    end
    redirect_to :action => 'index'
  end
end
