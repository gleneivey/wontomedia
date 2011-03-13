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
set :deploy_to,   "/home/glenivey/#{application}"
set :repository,  "git://github.com/gleneivey/wontomedia.git"

load File.join File.dirname(__FILE__), 'deploy_on_a2hosting.rb'

set :bundle_flags, ''
require 'bundler/capistrano'

set :scm, :git
set :branch, 'master'
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

role :app, 'wontology.org'
role :web, 'wontology.org', deploy => false
role :db,  'wontology.org', :primary => true



set :apps_config_root,   '/home/glenivey/SiteConfigs'
set :app_customization,  'default-custom'
before 'deploy:symlink', 'deploy:link:customize'
after  'deploy:symlink', 'deploy:link:database_yml'


namespace :deploy do
  namespace :link do

    desc 'create links to fill in customizations'
    task :customize, :roles => [ :app, :db ] do
      do_rake "customize[#{app_customization}]"
    end

    desc 'link to production database.yml'
    task :database_yml, :roles => [ :app, :db ] do
      run "ln -s #{File.join apps_config_root, application+'-database.yml'} " +
                 "#{File.join release_path, 'config', 'database.yml'}"
    end
  end

  namespace:db do
    desc 'empties database and reloads w/ seeds,fixtures -- use in demo environment only'
    task :reload, :roles => :db, :except => { :primary => false } do
      do_fixtures_load
      do_seed
    end

    desc 'repopulate database with seed data'
    task :seed, :roles => :db, :except => { :primary => false } do
      do_seed
    end

    desc 'reload (demo) database with fixture data'
    task :fixtures, :roles => :db, :except => { :primary => false } do
      do_fixtures_load
    end
  end
end


def do_fixtures_load; do_rake "db:fixtures:load", current_path; end
def do_seed; do_rake "db:reseed", current_path; end


def do_rake(task, path = nil)
  run "cd #{path || release_path} && RAILS_ENV=production #{rake} #{task}"
end
