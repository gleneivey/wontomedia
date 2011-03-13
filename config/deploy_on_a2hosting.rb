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


set :deploy_to,        "/home/glenivey/#{application}"
set :apps_config_root, '/home/glenivey/SiteConfigs'
set :bundle_flags, ''

ssh_options[:port] = 7822
set :use_sudo, false
set :user, "glenivey"


namespace :deploy do
  desc "Start the app servers"
  task :start, :roles => :app do
    a2_mongrel_start
  end

  desc "Stop the app servers"
  task :stop, :roles => :app do
    a2_mongrel_stop
  end

  desc "Restart the app servers"
  task :restart, :roles => :app do
    a2_mongrel_stop
    a2_mongrel_start
  end
end

def a2_mongrel_start
  run "cd #{app_to_run} && " +
      "bundle exec mongrel_rails start -d -p #{a2_port} -e production -P log/mongrel.pid < /dev/null >& /dev/null"
end

def a2_mongrel_stop
  run "cd #{app_to_run} && bundle exec mongrel_rails stop"
end
