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



class TempLoginController < ApplicationController
  # GET /temporary-login/new
  def login_form
  end

  # POST /temporary-login/verify
  def login_verify
    people = {
      "gei@mcn.org"         => "1968",
      "esh@qualitytree.com" => "1986",
      "bill@netwidget.com"  => "1989",
      "pivey@mcn.org"       => "1989",
      "dongar37@gmail.com"  => "2007",
      "joe@jsinnott.net"    => "2005"
    }

    if !people.has_key? params[:token1]
      render :file => "#{RAILS_ROOT}/public/not_logged_in.html"
      return
    end

    if people[params[:token1]] != params[:token2]
      render :file => "#{RAILS_ROOT}/public/not_logged_in.html"
      return
    end

    session[:who_am_i] = "logged in"
    redirect_to "/"
  end
end
