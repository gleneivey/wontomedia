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


require Rails.root.join( 'lib', 'helpers', 'item_helper')
require Rails.root.join( 'lib', 'helpers', 'tripple_navigation')
require 'yaml'

class ItemsController < ApplicationController
  # GET /
  def home
    @nouns = ItemHelper.nouns
    render :layout => "home"
  end

  # GET /items
  def index
    @items = Item.all.reverse
    @not_in_use_hash = {}
    @items.each do |item|
      @not_in_use_hash[item.id] =
        Connection.all( :conditions =>
          [ "subject_id = ? OR predicate_id = ? OR obj_id = ?",
            item.id, item.id, item.id ]).
          empty?
    end

    respond_to do |wants|
      wants.html
      wants.yaml do
        render :text =>
          @items.reject { |item|
            (item.flags & Item::DATA_IS_UNALTERABLE) != 0 }.
          to_yaml
      end
    end
  end

  # GET /items/new
  def new
    @this_is_non_information_page = true
    @item = Item.new
  end

  # GET /items/new-pop
  def newpop
    @item = Item.new
    @type = params[:type]
    render :layout => "popup"
  end

  # POST /items
  def create
    type_string = params[:item][:sti_type]
    params[:item].delete :sti_type # don't mass-assign protected blah, blah
    @item = ItemHelper.new_typed_item(type_string, params[:item])
    @popup_flag = true if params[:popup_flag]

    if @item.nil?
      flash.now[:error] =
'Could not create. Item must have a type of either "Category" or "Individual".'
      @item = Item.new(params[:item]) # keep info already entered
      @item.sti_type = type_string
      @this_is_non_information_page = true
      render :action => (@popup_flag ? "newpop" : "new" )
    elsif @item.name =~ /[:.]/ || !@item.save
      @item.errors.add :name, "cannot contain a period (.) or a colon (:)."
      @this_is_non_information_page = true
      render :action => (@popup_flag ? "newpop" : "new" )
    else
      if @popup_flag
        @connection_list = []; @item_hash = {}; @connection_hash = {}
        flash.now[:notice] = 'Item was successfully created.'
        render :action => "show", :layout => "popup"
      else
        flash[:notice] = 'Item was successfully created.'
        redirect_to item_path(@item)
      end
    end
  end

  # GET /items/1
  def show
    begin
      @item = Item.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if request.format.json?
      # huge kludge for testability.  Need to ensure that we don't respond
      # so quickly (e.g., in setups where client and server are on the same
      # system) that the JavaScript and acceptance tests can't see the
      # "request in progress" state of the page/system.
      if (RAILS_ENV == 'test')
        Kernel.sleep(0.75)
      end

      render :json => @item
      return
    end

    used_as_subj = Connection.all( :conditions =>
      [ "subject_id = ?", @item.id ])
    used_as_pred = Connection.all( :conditions =>
      [ "predicate_id = ?", @item.id ])
    used_as_obj  = Connection.all( :conditions =>
      [ "obj_id = ?", @item.id ])

    @item_hash = {}
    @connection_hash = {}
    [ used_as_subj, used_as_pred, used_as_obj ].each do |connection_array|
      connection_array.each do |connection|
        unless @connection_hash.has_key? connection.id
          @connection_hash[connection.id] = connection
          [ connection.subject, connection.predicate, connection.obj ].
            each do |item|
            unless @item_hash.has_key? item.id
              @item_hash[item.id] = item
            end
          end
        end
      end
    end

      # now that we've got all the connections to display, order and group them
    # @connection_list should be an array of arrays, each internal array is
    # a "section" of the display page, containing .id's of connections
    @connection_list = []

    value_id = Item.find_by_name("value_relationship").id
    spo_id   = Item.find_by_name("sub_property_of").id

    # first group, all connections *from* this item with value-type predicates
    connections = []
    connections_to_delete = []
    used_as_subj.each do |connection|
      if check_properties( :does => connection.predicate_id, :via => spo_id,
          :inherit_from => value_id )
        connections << connection.id
        connections_to_delete << connection
      end
    end
    used_as_subj -= connections_to_delete # done incrementally, breaks iterator
    unless connections.empty?
      @connection_list << connections
    end


    # next N groups: 1 group for connections *from* this item with >1 of
    #   same pred.
    #figure out which predicates occur >1, how many they occur, sort & group
    pred_counts = {}
    connection_using_pred = {}
    used_as_subj.each do |connection|
      if pred_counts[connection.predicate_id].nil?
        pred_counts[connection.predicate_id] = 1
      else
        pred_counts[connection.predicate_id] += 1
      end
      connection_using_pred[connection.predicate_id] = connection.id
    end
    subj_connections = pred_counts.keys
    subj_connections.sort! { |a,b| pred_counts[b] <=> pred_counts[a] }
    array_of_singles = []
    subj_connections.each do |predicate_id|
      if pred_counts[predicate_id] > 1
        connections = []
        used_as_subj.each do |connection|
            # lazy, more hashes would eliminate rescan
          if connection.predicate_id == predicate_id
            connections << connection.id
          end
        end
        unless connections.empty?
          @connection_list << connections
        end
      else
        array_of_singles << connection_using_pred[predicate_id]
      end
    end

    # last group of connections *from* current item:
    #   all connections w/ used-once pred's
    unless array_of_singles.empty?
      @connection_list << array_of_singles
    end


    obj_connections = used_as_obj.map { |connection| connection.id }
    obj_connections.sort! do |a,b|
      if @connection_hash[a].predicate_id == @connection_hash[b].predicate_id
        @connection_hash[a].obj_id <=> @connection_hash[b].obj_id
      else
        @connection_hash[a].predicate_id <=> @connection_hash[b].predicate_id
      end
    end
    unless obj_connections.empty?
      @connection_list << obj_connections
    end


    pred_connections = used_as_pred.map { |connection| connection.id }
    unless pred_connections.empty?
      @connection_list << pred_connections
    end
  end

  # GET /items/1/edit
  def edit
    begin
      @this_is_non_information_page = true
      @item = Item.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
  end

  # PUT /items/1
  def update
      # we want to be agnostic WRT processing item subclasses, so remap
      # name of incoming parameters if we're actually handling a child
    params.each do |k,v|
      if k =~ /_item/
        params["item"] = v
      end
    end

    begin
      @item = ItemHelper.find_typed_item(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if (@item.flags & Item::DATA_IS_UNALTERABLE) != 0
      flash[:error] = 'This Item cannot be altered.'
      redirect_to item_path(@item)
    elsif (!params[:item].nil? && !params[:item][:name].nil? &&
          params[:item][:name] =~ /[:.]/                     )  ||
        !@item.update_attributes(params[:item])
      @item.errors.add :name, "cannot contain a period (.) or a colon (:)."
      @this_is_non_information_page = true
      render :action => "edit"
    else
      flash[:notice] = 'Item was successfully updated.'
      redirect_to item_path(@item)
    end
  end

  # DELETE /items/1
  def destroy
    begin
      @item = Item.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if (@item.flags & Item::DATA_IS_UNALTERABLE) != 0
      flash[:error] = 'This Item cannot be altered.'
      redirect_to item_path(@item)
    elsif !(Connection.all( :conditions =>
        [ "subject_id = ? OR predicate_id = ? OR obj_id = ?",
          @item.id, @item.id, @item.id ]).empty?)
      flash[:error] = 'This Item is in use by 1+ Connections. ' +
        'Those must be modified or deleted first.'
      redirect_to item_path(@item)
    else
      @item.destroy
      redirect_to items_url
    end
  end

  # LOOKUP /items/lookup?name=aItemName
  def lookup
    # huge kludge for testability.  Need to ensure that we don't respond
    # so quickly (e.g., in setups where client and server are on the same
    # system) that the JavaScript and acceptance tests can't see the
    # "request in progress" state of the page/system.
    if (RAILS_ENV == 'test')
      Kernel.sleep(0.75)
    end

    begin
      n = Item.find_by_name(params[:name])
      if n.nil?
        render :text => "<p>Didn't find Item</p>\n", :status => 404
        return
      end
      id = n.id
    rescue
      render :text => "<p>Didn't find Item</p>\n", :status => 404
      return
    end

    render :text => ("<id>" + id.to_s + "</id>\n")
  end
end
