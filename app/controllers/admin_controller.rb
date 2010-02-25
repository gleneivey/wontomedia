#--
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
#++


require 'yaml'

class AdminController < ApplicationController
  # GET /admin/
  def index
    @this_is_non_information_page = true
  end

  # POST /admin/item_up
  def item_up
    @this_is_non_information_page = true
    count = 0
    flash[:error] ||= ""
    YAML::load(params[:item_upload][:itemfile]).each do |item|

      if item.is_a? Item
        # need to create a new item object so that it saves to db as "new"
        item_hash = ItemHelper.item_to_hash(item)
        name = item.name
      elsif item.is_a? YAML::Object
        # this is magic dependent on the internals of the YAML::Object class
        item_hash = item.instance_eval { @ivars }['attributes']
        name = item_hash['name'] || item_hash[:name]
      else
        flash[:error] <<
          "YAML parser generated an object of type '#{item.class}'.\n"
        redirect_to :action => 'index'
        return
      end

      n = ItemHelper.new_typed_item(
        item_hash['sti_type'] || item_hash[:sti_type] )
      if n.nil?
        err_str = "No/bad sti_type for item '#{name}', " +
          "tried to create '#{item_hash.inspect}'.\n"
        logger.error(err_str)
        flash[:error] << err_str
      else
        # even if ID present, don't copy; let db assign a new value
        n.name        = name
        n.title       = item_hash['title']       || item_hash[:title]
        n.description = item_hash['description'] || item_hash[:description]
        n.flags       = item_hash['flags']       || item_hash[:flags]
        if n.flags.nil?
          n.flags = 0
        end

        if n.save
          count += 1
        else
          err_str = "Could not save item named 'n.name': #{n.errors.inspect}\n"
          logger.error(err_str)
          flash[:error] << err_str
        end
      end
    end

    flash[:notice] = "Created #{count} new items."
    redirect_to :action => 'index'
  end

  # POST /admin/connection_up
  def connection_up
    @this_is_non_information_page = true
    count = unparsed = 0
    flash[:error] =""

    params[:connection_upload][:connectionfile].readlines.each do |n3line|
      # this is a really, *really* bad N3 parser. Almost certainly won't
      # handly any but the most trivial input (like what we export :-)
      if n3line =~ /<#([^>]+)>[^<]+<#([^>]+)>[^<]+<#([^>]+)>[^.]+\./
        e = Connection.new(
          :subject   => Item.find_by_name($1),
          :predicate => Item.find_by_name($2),
          :obj       => Item.find_by_name($3),
          :flags     => 0
                     )
        if e.nil?
          err_stry = "Couldn't create connection for #{$1} #{$2} #{$3}.\n"
          logger.error(err_str)
          flash[:error] << err_str
        else
          if e.save
            count += 1
          else
            err_stry = "Couldn't save connection for #{$1} #{$2} #{$3}.\n"
            logger.error(err_str)
            flash[:error] << err_str
          end
        end
      else
        unparsed += 1
      end
    end

    flash[:notice] = "Created #{count} new connections."
    if unparsed > 0
      flash[:notice] <<
        "(Discarded #{unparsed} non-connection lines from input file)"
    end
    redirect_to :action => 'index'
  end
end
