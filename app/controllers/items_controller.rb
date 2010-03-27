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
require Rails.root.join( 'lib', 'helpers', 'connection_helper')
require 'yaml'

# See also the matching model Item
class ItemsController < ApplicationController
  # GET /
  def home
    @nouns = ItemHelper.nouns
    @class_list = contributor_class_items
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
    @item = Item.new
    setup_for_new
    setup_for_form
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
    @popup_type = params[:popup_type]
    setup_for_new
    setup_for_form
    render :layout => "popup"
  end

  # POST /items
  def create
    type_string = params[:item][:sti_type]
    if type_string.nil?
      recover_from_create_failure(
        'Could not create. Item must have "Type" filled in.' )
    end
    params[:item].delete :sti_type # don't mass-assign protected blah, blah

    @item = ItemHelper.new_typed_item(type_string, params[:item])
    @example = get_an_example_of @item
    @popup_flag = true if params[:popup_flag]

    if @item.nil?
      recover_from_create_failure 'Could not create.', type_string
      render :action => (@popup_flag ? "newpop" : "new" )
    elsif @item.name =~ /[:.]/ || !@item.save
      recover_from_create_failure '' do
        @item.errors.add :name, "cannot contain a period (.) or a colon (:)."
      end
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
          :obj_id => connection.subject_id,
          :kind_of_obj => Connection::OBJECT_KIND_ITEM
        )
        used_as_subj << new_connection
        @inverses_map[new_connection] = connection
      end
    end

    # add blank-object connections to serve as basis for connection "quick add"
    @intances_of_type_item_classes = {}
    if class_item = @item.instance_of
      find_applied_properties( class_item ).select do |property_item|
        if (max_connection = Connection.first( :conditions => [
              "subject_id = ? AND predicate_id = ?",
              property_item.id, Item.find_by_name('max_uses_per_item').id ])) &&
            max_connection.kind_of_obj == Connection::OBJECT_KIND_SCALAR      &&
            (max = max_connection.scalar_obj.to_i) > 0

          count = Connection.all(
              :conditions => [ "subject_id = ? AND predicate_id = ?",
              @item.id, property_item.id ]).
            length

          count < max
        else
          true
        end
      end.each do |property_item|
        if connection = Connection.first( :conditions =>
            [ "subject_id = ? AND predicate_id = ?",
            property_item.id, Item.find_by_name('has_scalar_object').id ])
          new_kind = Connection::OBJECT_KIND_SCALAR
          new_type_item = connection.obj

        elsif Connection.first( :conditions =>
            [ "subject_id = ? AND predicate_id = ?",
            property_item.id, Item.find_by_name('has_item_object').id ])
          new_kind = Connection::OBJECT_KIND_ITEM
          new_type_item = connection = Connection.first( :conditions =>
            [ "subject_id = ? AND predicate_id = ?",
            property_item.id, Item.find_by_name('property_object_is').id ])

          unless connection.nil?
            new_type_item = connection.obj

            unless @intances_of_type_item_classes[new_type_item]
              @intances_of_type_item_classes[new_type_item] =
                Connection.all( :conditions => [
                  "predicate_id = ? AND obj_id = ?",
                  Item.find_by_name('is_instance_of').id,
                  new_type_item.id ]).
                map do |connection|
                  connection.subject
                end
            end
          end
        else
          new_type_item = new_kind = nil
        end

        used_as_subj << Connection.new({ :subject_id => @item.id,
          :predicate_id => property_item.id, :kind_of_obj => new_kind,
          :type_item => new_type_item })
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

      # first group, all connections *from* this item
    # start with explicit connections
    connections = used_as_subj
    # sort and add as a group to array-of-arrays for view
    unless connections.empty?
      count_hash = {}
      connections.each do |con|
        if count_hash[con.predicate_id].nil?
          count_hash[con.predicate_id] = 0
        end
        count_hash[con.predicate_id] += 1
      end

      @connection_list << ( connections.sort do |a,b|
          ConnectionHelper.compare( a, b, count_hash )
        end )
    end


      # next groups
    used_as_obj.sort! do |a,b|
      a.predicate_id <=> b.predicate_id
    end
    unless used_as_obj.empty?
      @connection_list << used_as_obj
    end
    unless used_as_pred.empty?
      @connection_list << used_as_pred
    end


    @properties_of_url_type = {}
    Connection.all( :conditions => [
        "predicate_id = ? AND obj_id = ?",
        Item.find_by_name('has_scalar_object').id,
        Item.find_by_name('URL_Value').id
      ]).each {|con| @properties_of_url_type[con.subject_id] = true }
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

    setup_for_form
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
      setup_for_form
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

  def contributor_class_items
    list = all_class_items.select do |class_item|
      (class_item.flags & Item::DATA_IS_UNALTERABLE) == 0
    end

    iio_item_id = Item.find_by_name('is_instance_of').id
    counts = {}
    list.each do |class_item|
      counts[class_item] = Connection.all( :conditions => [
        "predicate_id = ? AND obj_id = ?", iio_item_id, class_item.id ] ).length
    end

    list.sort{|a,b| counts[b] <=> counts[a]}
  end

  def map_of_item_types_for_class_items( class_items )
    citi_item_id = Item.find_by_name('class_item_type_is').id
    class_to_item_map = {}
    class_items.each do |class_item|
      connection = Connection.first( :conditions => [
        "subject_id = ? AND predicate_id = ?",
        class_item.id, citi_item_id ] )

      unless connection.nil?
        class_to_item_map[class_item] =
          ItemHelper.sti_type_for_ItemType( connection.obj.name )
      end
    end

    class_to_item_map
  end

  def get_an_example_of( proto_item )
    if proto_item && proto_item.class_item_id
      connections_to_instances = Connection.all( :conditions => [
        "(flags & #{Connection::DATA_IS_UNALTERABLE}) = 0 AND " +
          "predicate_id = ? AND obj_id = ?",
        Item.find_by_name('is_instance_of'), proto_item.class_item_id ] )

      # TODO: replace with .choice when we migrate to Ruby 1.9
      len = connections_to_instances.length
      connection = connections_to_instances[ rand(len) ]
      if connection
        return Item.find_by_id connection.subject_id
      end
    end

    return Item.last( :conditions => [
      "(flags & #{Item::DATA_IS_UNALTERABLE}) = 0" ])
  end

  def setup_for_form
    @example = get_an_example_of @item
    @class_list = all_class_items
    @class_to_item_map = map_of_item_types_for_class_items @class_list
    @this_is_non_information_page = true
  end

  def setup_for_new
    if params[:class_item]
      id = params[:class_item]
      class_item = Item.find_by_id(id)
      if class_item
        @item.class_item_id = id

        if params[:sti_type].nil?   # probably no class_item_type_is to find
          citi_item_id = Item.find_by_name('class_item_type_is').id
          connection = Connection.first( :conditions => [
            "subject_id = ? AND predicate_id = ?",
            class_item.id, citi_item_id ] )
          unless connection.nil?
            @item.sti_type =
              ItemHelper.sti_type_for_ItemType( connection.obj.name )
          end
        end
      end
    end

    if params[:sti_type]
      @item.sti_type = params[:sti_type]
    end
  end

  def recover_from_create_failure( message_string, type_string = nil )
    flash.now[:error] = message_string
    @item = Item.new(params[:item]) # keep info already entered
    @item.sti_type = type_string unless type_string.nil?
    yield if block_given?
    setup_for_form
  end

  def find_applied_properties( class_item )
    recursive_find_applied_properties(
      class_item, Item.find_by_name('applies_to_class') ).flatten
  end
  def recursive_find_applied_properties( class_item, joining_prop )
    con_array = Connection.all( :conditions => [
      "predicate_id = ? AND obj_id = ?",
      joining_prop.id, class_item.id ] )
    return [] if con_array.nil?
    con_array.map do |connection|
      item = connection.subject
      if item.sti_type == ItemHelper::ITEM_PROPERTY_CLASS_NAME
        item
      else # prop is_instance_of prop-class; prop-class applied_to_class 'us'
        recursive_find_applied_properties( item,
          Item.find_by_name('is_instance_of') )
      end
    end
  end
end
