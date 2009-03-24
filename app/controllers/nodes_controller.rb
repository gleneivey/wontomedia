# WontoMedia -- a wontology web application
# Copyright (C) 2009 -- Glen E. Ivey
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
    index        # not DRY, but eventually will have different template
  end

  # GET /nodes
  def index
    @nodes = Node.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /nodes/new
  def new
    @node = Node.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /nodes
  def create
    @node = Node.new(params[:node])

    respond_to do |format|
      if @node.save
        flash[:notice] = 'Node was successfully created.'
        format.html { redirect_to(@node) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # GET /nodes/1
  def show
    @node = Node.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end
end
