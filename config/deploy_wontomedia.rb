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

set :scm, :git
set :branch, 'master'
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

before 'deploy:symlink', 'deploy:link:submodule'
before 'deploy:symlink', 'deploy:link:customize'
before 'deploy:symlink', 'deploy:link:database_yml'


namespace :deploy do
  namespace :link do
    desc 'create links/dirs to allow wontomedia to execute outside the cap deploy directory'
    task :submodule, :roles => [ :app, :db ] do
      bundle_dir = File.join app_to_customize, '.bundle'
      run "if [ ! -e #{bundle_dir} ]; then " +
          "  mkdir -p #{bundle_dir};      " +
          "  ln -s #{File.join release_path, '.bundle', 'config'} #{File.join bundle_dir, 'config'};" +
          "fi"

      log_dir = File.join app_to_customize, 'log'
      run "if [ ! -e #{log_dir} ]; then " +
          "  ln -s #{File.join shared_path, 'log'} #{log_dir};" +
          "fi"

      run "mkdir -p #{File.join app_to_customize, 'tmp'}"
    end

    desc 'create links to fill in customizations'
    task :customize, :roles => [ :app, :db ] do
      do_rake "customize[#{app_customization}]", app_to_customize
    end

    desc 'link to production database.yml'
    task :database_yml, :roles => [ :app, :db ] do
      run "ln -s #{File.join apps_config_root, application+'-database.yml'} " +
                "#{File.join app_to_customize, 'config', 'database.yml'}"
    end
  end
end

namespace :deploy do
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


def do_fixtures_load; do_rake "db:fixtures:load", app_to_run; end
def do_seed; do_rake "db:reseed", app_to_run; end

def do_rake(task, path = nil)
  run "cd #{path || release_path} && RAILS_ENV=production #{rake} #{task}"
end
