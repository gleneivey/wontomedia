# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
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


  #### NOTE: this deployment configuration is intended to deploy an
  ####   "uncustomized" instance of WontoMedia to our "demo"
  ####   environment on A2 Hosting.  For a more realistic example of
  ####   how to deploy WontoMedia to host a production web site, see
  ####   the Git repositories at:
  ####       https://github.com/gleneivey/wontology.org
  ####       https://github.com/gleneivey/staging.wontology.org

set :application, "demo.wontology.org"
set :repository,  "git://github.com/gleneivey/wontomedia.git"

load File.join File.dirname(__FILE__), 'deploy_wontomedia.rb'
load File.join File.dirname(__FILE__), 'deploy_on_a2hosting.rb'
require 'bundler/capistrano'

role :app, 'wontology.org'
role :web, 'wontology.org', :deploy => false
role :db,  'wontology.org', :primary => true

set :app_to_customize,   release_path
set :app_to_run,         current_path
set :app_customization,  File.join( release_path, 'default-custom' )
set :a2_port,            12035

