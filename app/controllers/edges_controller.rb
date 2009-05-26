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

class EdgesController < ApplicationController
  before_filter :temporary_page_protection
  def temporary_page_protection
    if ENV['RAILS_ENV'] != 'test' && session[:who_am_i].nil?
      render :file => "#{RAILS_ROOT}/public/not_logged_in.html"
      return
    end
  end


  # GET /edges
  def index
    @edges = Edge.all
  end

  # GET /edges/new
  def new
    @edge = Edge.new
    populate_for_new_update
  end

  # POST /edges
  def create
    @edge = Edge.new(params[:edge])

    if @edge.save
      flash[:notice] = 'Edge was successfully created.'
      redirect_to(@edge)
    else
      populate_for_new_update
      render :action => "new"
    end
  end

  # GET /edges/1
  def show
      # set @edge for view to use for link building
    begin
      @edge = Edge.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

      # populate these here because I didn't want view causing db queries
    @subject = @edge.subject
    @predicate = @edge.predicate
    @obj = @edge.obj
    @edge_desc = @edge.edge_desc
  end

  # GET /edges/1/edit
  def edit
    begin
      @edge = Edge.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    populate_for_new_update
  end

  # PUT /edges/1
  def update
    begin
      @edge = Edge.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if !@edge.update_attributes(params[:edge])
      populate_for_new_update
      render :action => "edit"
    else
      flash[:notice] = 'Edge was successfully updated.'
      redirect_to edge_path(@edge)
    end
  end

  # DELETE /edges/1
  def destroy
    begin
      @edge = Edge.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    @edge.destroy
    redirect_to edges_url
  end

private

  def populate_for_new_update
    @nodes = NodeHelper.not_reiffied
    @verbs = PropertyNode.all
  end
end
