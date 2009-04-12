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


class NodesController < ApplicationController
  # GET /
  def home
    @nouns = (ClassNode.find(:all) + ItemNode.find(:all))
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
    @node = Node.new(params[:node])

    respond_to do |format|
      if @node.name =~ /[:.]/                     ||
          !@node.save
        @node.errors.add :name, "cannot contain a period (.) or a colon (:)."
        format.html { render :action => "new" }
      else
        flash[:notice] = 'Node was successfully created.'
        format.html { redirect_to(@node) }
      end
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

    @node = Node.find(params[:id])

    respond_to do |format|
      if (!params[:node].nil? && !params[:node][:name].nil? &&
            params[:node][:name] =~ /[:.]/                     )  ||
          !@node.update_attributes(params[:node])
        @node.errors.add :name, "cannot contain a period (.) or a colon (:)."
        format.html { render :action => "edit" }
      else
        flash[:notice] = 'Node was successfully updated.'
        format.html { redirect_to node_path(@node) }
      end
    end
  end

  # DELETE /nodes/1
  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to(nodes_url) }
    end
  end
end
