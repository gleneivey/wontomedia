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
end

def do_rake(task, path = nil)
  run "cd #{path || release_path} && RAILS_ENV=production #{rake} #{task}"
end
