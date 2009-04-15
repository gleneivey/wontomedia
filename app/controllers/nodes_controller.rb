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
    n = Node.new(params[:node])
    @node = NodeHelper.new_typed_node(params[:node][:sti_type], params[:node])

    if @node.nil?
      flash[:error] = 'Could not create. Node must have a type of either "Category" or "Item".'
      @node = n # don't lose info already entered
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
  end

  # GET /nodes/1/edit
  def edit
    @node = Node.find(params[:id])
  end

  # PUT /nodes/1
  def update
      # we want to be agnostic WRT processing node subclasses, so remap
      # name of incoming parameters if we're actually handling a child
    params.keys.each do |k|
      if k =~ /_node/
        params["node"] = params[k]
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
