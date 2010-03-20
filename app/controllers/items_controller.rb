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


#### I've got no idea why this 'require' is necessary.  Without it, all
# the unit tests pass, but the ItemHelper.nouns call below fails when
# run in production.  Even more odd, if run in 'development' (so that
# each Ruby file is reloaded at each request, this 'require' only has
# to be present for the _first_ request serviced after the server
# starts.  It can be deleted, this file reloaded, and then ItemHelper
# references will work normally.  Go figure. -- gei 2010/2/24
require Rails.root.join( 'lib', 'helpers', 'item_helper')
require 'yaml'

# See also the matching model Item
class ItemsController < ApplicationController
  # GET /
  def home
    @nouns = ItemHelper.nouns
    @class_list = all_class_items
    render :layout => "home"
  end

  # GET /items
  #
  # Note that +index+ is capable of rendering in multiple
  # formats. <tt>/items</tt> and <tt>/items.html</tt> yield a
  # human-readable page in HTML markup.  <tt>/items.yaml</tt> renders
  # all fields from all Items in the database as YAML-format text,
  # with no additional prose or links intended for users.
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
    @class_list = all_class_items
  end

  # GET /items/new-pop
  #
  # This operation is intended to provide a version of
  # <tt>/items/new</tt> suitable for Ajax fetching fromm and display
  # in a pop-up <tt><div></tt> in an already-rendered page.  Correct
  # operation of the page fragment rendered by this action depends on
  # the surrounding page having already loaded the form's JavaScript
  # and style dependencies.  Implementing this behavior depends on the
  # <tt>popup_flag</tt> field passed between Items +actions+ and
  # +views+; see their source for additional details.
  def newpop
    @item = Item.new
    @class_list = all_class_items
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
      @class_list = all_class_items
      @this_is_non_information_page = true
      render :action => (@popup_flag ? "newpop" : "new" )
    elsif @item.name =~ /[:.]/ || !@item.save
      @item.errors.add :name, "cannot contain a period (.) or a colon (:)."
      @class_list = all_class_items
      @this_is_non_information_page = true
      render :action => (@popup_flag ? "newpop" : "new" )
    else
      if @popup_flag
        @connection_list = []; @item_hash = {};
        flash.now[:notice] = 'Item was successfully created.'
        render :action => "show", :layout => "popup"
      else
        flash[:notice] = 'Item was successfully created.'
        redirect_to item_by_name_path(@item.name)
      end
    end
  end

  # GET /items/1
  #
  # +show+ is capable of rendering in multiple
  # formats. <tt>/items/1</tt> and <tt>/items/1.html</tt> yield a
  # human-readable page in HTML markup.  <tt>/items/1.json</tt>
  # renders all fields from the specified Item as JSON-format text,
  # with no additional prose or links intended for users.  In the JSON
  # case, only information about the specific Item requested is
  # returned.  When a full web page is generated, information is
  # included about all other Items which are involved in Connections
  # that directly reference the requested Item.
  #
  # As for all controller actions, 'show' populates instance variables
  # for the view to use in generating the page.  However, unlike most
  # of the other controller methods, the data packaging that the show
  # action does for the its view is relatively extensive and several
  # instance variables are created:
  #
  # * *@item* this variable is populated with a single Item object
  #   that holds the model for the page being generated
  # * *@item_hash* is a hash that contains additional Item objects
  #   that will be required to render the output page.  It is indexed
  #   with Item.id values.
  # * *@inverses_map* is a hash indexed by Connection objects which
  #   contains other Connection objects.  Each time 'show' generates a
  #   Connection object for one connection that is implied by the
  #   existence of another connection involving *@item*, it creates an
  #   entry in this hash.  The new entry is indexed by the new
  #   Connection object (which has no "id" as it has not been saved to
  #   the database) and whose value is the Connection object that
  #   implies the new connection.  This allows the view to create
  #   links to an implied connection's "source" connection without
  #   having to go back through the database.
  # * *@connection_list* is an _array_ of _arrays_ of Connection.id
  #   values.  Each array within @connection_list represents a
  #   different logically-similar group of connections, and they are
  #   expected (although it is really up to the view) to be rendered
  #   into the page from top to bottom in the order they occur in the
  #   array.
  #   - The first array of Connections inside of @connection_list
  #     includes all connections that reference *@item* as their
  #     subject item, _and_ which have a predicate item that inherits
  #     from value_relationship.  (Assuming that's a non-empty set.)
  #   - The next some-number-of arrays inside of @connection_list
  #     contain (some of) the remaining Connections (if any) that
  #     reference *@item* as their subject.  Connections are grouped
  #     together based on their references to a common predicate item:
  #     all of the Connections whose subject is *@item* and which have
  #     the _same_ value for *predicate_id*.  Based on this definition,
  #     all of the arrays in this portion of @connection_list will
  #     have two or more element Connection objects.  The arrays in
  #     this group are placed into @connection_list in order based on
  #     the number of Connections in the array:  larger arrays are
  #     sorted ahead of smaller ones.
  #   - The next array in @connection_list, assuming there are
  #     Connection objects for it, contains any Connections that
  #     reference *@item* as their subject that haven't been included
  #     in one of the arrays above.  Given the above definitions, the
  #     view can expect that all of the *predicate_id* values in the
  #     Connections in this array will be different.
  #   - The next array in @connection_list contains all of the
  #     Connection objects whose *obj_id* values are equal to
  #     *@item*.  Like all the other, this array won't be placed into
  #     @connection_list if it would be empty.  Also, in the event of
  #     that a Connection references *@item* as both its subject and
  #     object, that Connection will be included in the appropriate
  #     one of the preceding arrays.  (In generally, the criteria for
  #     placing Connections into the individual arrays contained by
  #     @connection_list are "greedy"; a Connection will be placed
  #     in only one array, and it will be the earliest-generated array
  #     for which it qualifies.)  Connections are sorted within this
  #     array so that ones who share the same *predicate_id* value are
  #     in adjacent positions.
  #   - The final array that may be in @connection_list includes all
  #     of the (remaining) Connections which, given the definitions
  #     above, all reference *@item* as their predicate.
  #
  # Before connections are packaged and the items necessary for their
  # display are gathered, the show action will create temporary,
  # not-saved-to-the-database Connection objects to represent
  # connections implied by existing connection that have the current
  # *@item* as their object.  This allows implied connections to be
  # included in the list of connections-with-@item-as-subject near the
  # top of the list of *@item*'s connections.
  def show
    begin
      @item = params[:name].nil? ?
        Item.find(params[:id]) : Item.find_by_name(params[:name])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
    if @item.nil?
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

    # all of the connections we might want to display
    used_as_subj = Connection.all( :conditions =>
      [ "subject_id = ?", @item.id ])
    used_as_pred = Connection.all( :conditions =>
      [ "predicate_id = ?", @item.id ])
    used_as_obj  = Connection.all( :conditions =>
      [ "obj_id = ?", @item.id ])

    @inverses_map = {}
    # create Connection objects for any implied connections we want to list
    used_as_obj.each do |connection|
      if inverse_property_id = TrippleNavigation.
          propertys_inverse( connection.predicate_id )
        new_connection = Connection.new(
          :subject_id => connection.obj_id,
          :predicate_id => inverse_property_id,
          :obj_id => connection.subject_id
        )
        used_as_subj << new_connection
        @inverses_map[new_connection] = connection
      end
    end

    # find all of the Items referenced by the connections the view will list
    @item_hash = {}
    [ used_as_subj, used_as_pred, used_as_obj ].each do |connection_array|
      connection_array.each do |connection|
        [ connection.subject, connection.predicate, connection.obj ].
          each do |item|
          unless item.nil? or @item_hash.has_key? item.id
            @item_hash[item.id] = item
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
    used_as_subj.each do |connection|
      if TrippleNavigation.check_properties(
          :does => connection.predicate_id, :via => spo_id,
          :inherit_from => value_id )
        connections << connection
      end
    end
    used_as_subj -= connections # if done incrementally, breaks iterator
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
      connection_using_pred[connection.predicate_id] = connection
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
            connections << connection
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


    used_as_obj.sort! do |a,b|
      a.predicate_id <=> b.predicate_id
    end
    unless used_as_obj.empty?
      @connection_list << used_as_obj
    end


    unless used_as_pred.empty?
      @connection_list << used_as_pred
    end
  end

  # GET /items/1/edit
  def edit
    begin
      @item = params[:name].nil? ?
        Item.find(params[:id]) : Item.find_by_name(params[:name])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end
    if @item.nil?
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    @class_list = all_class_items
    @this_is_non_information_page = true
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
      redirect_to item_by_name_path(@item.name)
    elsif (!params[:item].nil? && !params[:item][:name].nil? &&
          params[:item][:name] =~ /[:.]/                     )  ||
        !@item.update_attributes(params[:item])
      @item.errors.add :name, "cannot contain a period (.) or a colon (:)."
      @class_list = all_class_items
      @this_is_non_information_page = true
      render :action => "edit"
    else
      flash[:notice] = 'Item was successfully updated.'
      redirect_to item_by_name_path(@item.name)
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
      redirect_to item_by_name_path(@item.name)
      return
    end

    class_item = @item.class_item
    if class_item
      Connection.first( :conditions =>
        [ "subject_id = ? AND predicate_id = ? AND obj_id = ?",
          @item.id,
          Item.find_by_name('is_instance_of'),
          class_item.id ] ).destroy
    end

    if !(Connection.all( :conditions =>
        [ "subject_id = ? OR predicate_id = ? OR obj_id = ?",
          @item.id, @item.id, @item.id ]).empty?)
      flash[:error] = 'This Item is in use by 1+ Connections. ' +
        'Those must be modified or deleted first.'
      redirect_to item_by_name_path(@item.name)
    else
      @item.destroy
      redirect_to items_url
    end
  end

  # GET /items/lookup?name=anItemName
  #
  # This operation is similar to an abbreviated +show+.  It always
  # sends an HTML fragment (not a complete/valid page) to the
  # requester, either an error message (plus <tt>:status => 404</tt>,
  # if the requested item doesn't exist) or a string representation of
  # the Item's +id+ field (plus <tt>:status => 200</tt>).  While this
  # is technically a RESTful request, it uses a string (rather than a
  # database ID number as is the default for Rails requests) as the
  # request parameter, and the parameter is encoded in the query
  # string portion of the URL (rather than the path portion, in order
  # to simplify creation of the matching route).
  #
  # This request is primarily intended to be used by Ajax code
  # executing within another page that has already been served by
  # WontoMedia.
  def lookup
    # huge kludge for testability.  Need to ensure that we don't respond
    # so quickly (e.g., in setups where client and server are on the same
    # system) that the JavaScript and acceptance tests can't see the
    # "request in progress" state of the page/system.
    if (RAILS_ENV == 'test')
      Kernel.sleep(0.75)
    end

    begin
      item = Item.find_by_name(params[:name])
      if item.nil?
        render :text => "<p>Didn't find Item</p>\n", :status => 404
        return
      end
      id = item.id
    rescue
      render :text => "<p>Didn't find Item</p>\n", :status => 404
      return
    end

    render :text => ("<id>" + id.to_s + "</id>\n")
  end

private

  def all_class_items
    # Get the special property items "sub_class_of" and
    # "is_instance_of"; find all of the connections that use them as
    # predicates; find all of the items that are those connections'
    # subjects ("s_c_o") or objects (both).  At some point we might
    # want to allow sub-properties of the two special ones to also
    # imply that items represent classes.

    class_list = []
    [ 'sub_class_of', 'is_instance_of' ].each do |property_name|
      Connection.all( :conditions => [ "predicate_id = ?",
          Item.find_by_name(property_name).id ]).each do |connection|

        # look at objects of both special properties (assuming con. valid)
        if connection.kind_of_obj == Connection::OBJECT_KIND_ITEM
          class_list << connection.obj
        end

        #and at subjects of just
        if property_name == 'sub_class_of'
          class_list << connection.subject
        end
      end
    end

    class_list.uniq
  end
end
