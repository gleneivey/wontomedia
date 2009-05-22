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
require Rails.root.join( 'lib', 'helpers', 'tripple_navigation')

class NodesController < ApplicationController
  # GET /
  def home
    @nouns = NodeHelper.nouns
  end

  # GET /nodes
  def index
    @nodes = Node.find(:all)
  end

  # GET /nodes/new
  def new
    @node = Node.new
  end

  # POST /nodes
  def create
    type_string = params[:node][:sti_type]
    params[:node].delete :sti_type # don't mass-assign protected blah, blah
    @node = NodeHelper.new_typed_node(type_string, params[:node])

    if @node.nil?
      flash[:error] = 'Could not create. Node must have a type of either "Category" or "Item".'
      @node = Node.new(params[:node]) # keep info already entered
      @node.sti_type = type_string
      render :action => "new"
    elsif @node.name =~ /[:.]/                     ||
          !@node.save
      @node.errors.add :name, "cannot contain a period (.) or a colon (:)."
      render :action => "new"
    else
      flash[:notice] = 'Node was successfully created.'
      redirect_to node_path(@node)
    end
  end

  # GET /nodes/1
  def show
    @node = Node.find(params[:id])
    used_as_subj = Edge.all( :conditions => [ "subject_id = ?", @node.id ])
    used_as_pred = Edge.all( :conditions => [ "predicate_id = ?", @node.id ])
    used_as_obj  = Edge.all( :conditions => [ "obj_id = ?", @node.id ])

    @node_hash = {}
    @edge_hash = {}
    [ used_as_subj, used_as_pred, used_as_obj ].each do |edge_array|
      edge_array.each do |edge|
        unless @edge_hash.has_key? edge.id
          @edge_hash[edge.id] = edge
          [ edge.subject, edge.predicate, edge.obj ].each do |node|
            unless @node_hash.has_key? node.id
              @node_hash[node.id] = node
            end
          end
        end
      end
    end

      # now that we've got all the edges to display, order and group them
    # @edge_list should be an array of arrays, each internal array is
    # a "section" of the display page, containing .id's of edges
    @edge_list = []

    value_id = Node.find_by_name("value_relationship").id
    spo_id   = Node.find_by_name("sub_property_of").id

    # first group, all edges *from* this node with value-type predicates
    edges = []
    edges_to_delete = []
    used_as_subj.each do |edge|
      if check_properties( :does         => edge.predicate_id,
                           :inherit_from => value_id,
                           :via          => spo_id             )
        edges << edge.id
        edges_to_delete << edge
      end
    end
    used_as_subj -= edges_to_delete # if done incrementally, breaks iterator
    unless edges.empty?
      @edge_list << edges
    end


    # next N groups: 1 group for edges *from* this node with >1 of same pred.
    #figure out which predicates occur >1, how many they occur, sort & group
    pred_counts = {}
    edge_using_pred = {}
    used_as_subj.each do |edge|
      if pred_counts[edge.predicate_id].nil?
        pred_counts[edge.predicate_id] = 1
      else
        pred_counts[edge.predicate_id] += 1
      end
      edge_using_pred[edge.predicate_id] = edge.id
    end
    subj_edges = pred_counts.keys
    subj_edges.sort! { |a,b| pred_counts[b] <=> pred_counts[a] }
    array_of_singles = []
    subj_edges.each do |predicate_id|
      if pred_counts[predicate_id] > 1
        edges = []
        used_as_subj.each do |edge|   # lazy, more hashes would eliminate rescan
          if edge.predicate_id == predicate_id
            edges << edge.id
          end
        end
        unless edges.empty?
          @edge_list << edges
        end
      else
        array_of_singles << edge_using_pred[predicate_id]
      end
    end

    # last group of edges *from* current node: all edges w/ used-once pred's
    unless array_of_singles.empty?
      @edge_list << array_of_singles
    end


    obj_edges = used_as_obj.map { |edge| edge.id }
    obj_edges.sort! do |a,b|
      if @edge_hash[a].predicate_id == @edge_hash[b].predicate_id
        @edge_hash[a].obj_id <=> @edge_hash[b].obj_id
      else
        @edge_hash[a].predicate_id <=> @edge_hash[b].predicate_id
      end
    end
    unless obj_edges.empty?
      @edge_list << obj_edges
    end


    pred_edges = used_as_pred.map { |edge| edge.id }
    unless pred_edges.empty?
      @edge_list << pred_edges
    end
  end

  # GET /nodes/1/edit
  def edit
    @node = Node.find(params[:id])
  end

  # PUT /nodes/1
  def update
      # we want to be agnostic WRT processing node subclasses, so remap
      # name of incoming parameters if we're actually handling a child
    params.each do |k,v|
      if k =~ /_node/
        params["node"] = v
      end
    end

    @node = NodeHelper.find_typed_node(params[:id])

    if (!params[:node].nil? && !params[:node][:name].nil? &&
          params[:node][:name] =~ /[:.]/                     )  ||
        !@node.update_attributes(params[:node])
      @node.errors.add :name, "cannot contain a period (.) or a colon (:)."
      render :action => "edit"
    else
      flash[:notice] = 'Node was successfully updated.'
      redirect_to node_path(@node)
    end
  end

  # DELETE /nodes/1
  def destroy
    @node = Node.find(params[:id])
    @node.destroy
    redirect_to nodes_url
  end
end
