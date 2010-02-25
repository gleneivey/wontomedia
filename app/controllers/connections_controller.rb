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


require Rails.root.join( 'lib', 'helpers', 'connection_helper')

class ConnectionsController < ApplicationController
  Mime::Type.register "application/x-n3", :n3


  # GET /connections
  def index
    @connections = Connection.all.reverse
    respond_to do |wants|
      wants.html
      wants.n3 do
        e = @connections.reject { |connection|
          (connection.flags & Connection::DATA_IS_UNALTERABLE) != 0 }
        render :text => ConnectionHelper.connection_array_to_n3(e)
      end
    end
  end

  # GET /connections/new
  def new
    @this_is_non_information_page = true
    @connection = Connection.new
    populate_for_new_update
  end

  # POST /connections
  def create
    @connection = Connection.new(params[:connection])
    @connection.flags = 0

    if @connection.save
      flash[:notice] = 'Connection was successfully created.'
      redirect_to(@connection)
    else
      populate_for_new_update
      @this_is_non_information_page = true
      render :action => "new"
    end
  end

  # GET /connections/1
  def show
      # set @connection for view to use for link building
    begin
      @connection = Connection.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

      # populate these here because I didn't want view causing db queries
    @subject = @connection.subject
    @predicate = @connection.predicate
    @obj = @connection.obj
    @connection_desc = @connection.connection_desc
  end

  # GET /connections/1/edit
  def edit
    begin
      @this_is_non_information_page = true
      @connection = Connection.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    populate_for_new_update
  end

  # PUT /connections/1
  def update
    begin
      @connection = Connection.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if (@connection.flags & Connection::DATA_IS_UNALTERABLE) != 0
      flash[:error] = 'This Connection cannot be altered.'
      redirect_to connection_path(@connection)
    elsif !@connection.update_attributes(params[:connection])
      populate_for_new_update
      @this_is_non_information_page = true
      render :action => "edit"
    else
      flash[:notice] = 'Connection was successfully updated.'
      redirect_to connection_path(@connection)
    end
  end

  # DELETE /connections/1
  def destroy
    begin
      @connection = Connection.find(params[:id])
    rescue
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
      return
    end

    if (@connection.flags & Connection::DATA_IS_UNALTERABLE) != 0
      flash[:error] = 'This Connection cannot be altered.'
      redirect_to connection_path(@connection)
    else
      @connection.destroy
      redirect_to connections_url
    end
  end

private

  def populate_for_new_update
    @items = ItemHelper.not_qualified
    @verbs = PropertyItem.all
  end
end
