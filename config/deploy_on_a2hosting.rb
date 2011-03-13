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
  run "cd #{current_path} && " +
      "bundle exec mongrel_rails start -d -p 12035 -e production -P log/mongrel.pid < /dev/null >& /dev/null"
end

def a2_mongrel_stop
  run "cd #{current_path} && bundle exec mongrel_rails stop"
end
