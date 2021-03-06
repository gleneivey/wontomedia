#--
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
#++


ActiveSupport::Dependencies.require_or_load Rails.root.join(
  'lib', 'helpers', 'item_helper')
require 'yaml'

# There is no model matching this controller.  It is intended to
# provide access to and processing of pages used to administer a
# WontoMedia installation.
class AdminController < ApplicationController

  # GET /admin/
  #
  # This action renders the primary administration page.  This page
  # includes links to <tt>/w/items.yaml</tt> and
  # <tt>/w/connections.n3</tt> so that an administrator can download the
  # complete content of a wontology for backup.  It also includes form
  # controls for uploading <tt>.yaml</tt> files of Item records and
  # <tt>.n3</tt> files of Connection records to be added to the
  # installation's database.
  def index
    @this_is_non_information_page = true
  end

  # POST /admin/item_up
  #
  # This is a form processing action supporting a file-upload control
  # for <tt>.yaml</tt> files of Items.
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
  #
  # This is a form processing action supporting a file-upload control
  # for <tt>.n3</tt> files of Connections.  <b>Note</b> that
  # WontoMedia currently uses a <em>trivial, fragile</em> N3 processor
  # that is unlikely to process N3 files other than those that
  # WontoMedia produces.
  def connection_up
    @this_is_non_information_page = true
    count = unparsed = 0
    flash[:error] =""

    params[:connection_upload][:connectionfile].readlines.each do |n3line|
      err_str = nil;

          # this is a really, *really* bad N3 parser. Almost certainly won't
          # handly any but the most trivial input (like what we export :-)
      # handle connections whose objects are scalar constants
      if n3line =~ /<#([^>]+)>[^<]+<#([^>]+)>[^"]+"([^"]+)"[^.]+\./
        e = Connection.new(
          :subject     => Item.find_by_name($1),
          :predicate   => Item.find_by_name($2),
          :scalar_obj  => $3,
          :kind_of_obj => Connection::OBJECT_KIND_SCALAR,
          :flags       => 0
                     )
        if e.nil?
          err_str = "Couldn't create connection for #{$1} #{$2} '#{$3}'.\n"
        else
          if e.save
            count += 1
          else
            err_str = "Couldn't save connection for #{$1} #{$2} '#{$3}'.\n"
          end
        end
      # handle connections whose objects are Items
      elsif n3line =~ /<#([^>]+)>[^<]+<#([^>]+)>[^<]+<#([^>]+)>[^.]+\./
        e = Connection.new(
          :subject     => Item.find_by_name($1),
          :predicate   => Item.find_by_name($2),
          :obj         => Item.find_by_name($3),
          :kind_of_obj => Connection::OBJECT_KIND_ITEM,
          :flags       => 0
                     )
        if e.nil?
          err_str = "Couldn't create connection for #{$1} #{$2} #{$3}.\n"
        else
          if e.save
            count += 1
          else
            err_str = "Couldn't save connection for #{$1} #{$2} #{$3}.\n"
          end
        end
      else
        unparsed += 1
      end

      if (err_str)
        logger.error(err_str)
        flash[:error] << err_str
      end
    end

    flash[:notice] = "Created #{count} new connections."
    if unparsed > 0
      flash[:notice] <<
        "(Discarded #{unparsed} non-connection lines from input file)"
    end
    redirect_to :action => 'index'
  end

  def search
    @title_text = 'Search Results'
    @search_query = params[:q].sub( /\+/, ' ')
    render :layout => "search"
  end

  def sitemap
    result_text = <<PLAIN_XML
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>#{root_url}</loc>
    <changefreq>monthly</changefreq>
    <priority>0.25</priority>
  </url>
  <url>
    <loc>#{items_url}</loc>
    <changefreq>monthly</changefreq>
    <priority>0.4</priority>
  </url>
  <url>
    <loc>#{connections_url}</loc>
    <changefreq>monthly</changefreq>
    <priority>0.35</priority>
  </url>
PLAIN_XML

    Item.all.each do |item|
      result_text += "  <url>\n"
      result_text += "    <loc>#{item_by_name_url(item.name)}</loc>\n"
      result_text += "    <lastmod>#{item.updated_at.to_s(:w3c) }</lastmod>\n"
      result_text += "    <changefreq>monthly</changefreq>\n"
      priority = (item.flags & Item::DATA_IS_UNALTERABLE)==0 ? '1.0' : '0.1'
      result_text += "    <priority>#{priority}</priority>\n"
      result_text += "  </url>\n"
    end

    Connection.all.each do |connection|
      result_text += "  <url>\n"
      result_text += "    <loc>#{connection_url(connection)}</loc>\n"
      result_text += "    <lastmod>" +
        "#{connection.updated_at.to_s(:w3c)}</lastmod>\n"
      result_text += "    <changefreq>monthly</changefreq>\n"
      priority = (connection.flags & Connection::DATA_IS_UNALTERABLE)==0 ?
        '0.5' : '0.1'
      result_text += "    <priority>#{priority}</priority>\n"
      result_text += "  </url>\n"
    end

    result_text += "</urlset>\n"
    render :text => result_text
  end
end
