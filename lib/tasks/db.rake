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


namespace :db do
  desc "Load YAML seed data from db/fixtures"
  task :seed => :environment do
    require 'active_record'
    require 'active_record/fixtures'

    unless ActiveRecord::Base.connected?
      ActiveRecord::Base.establish_connection(
        ActiveRecord::Base.configurations[RAILS_ENV] )
    end

    pattern = File.join( RAILS_ROOT, 'db', 'fixtures', '**', '*.yml' )
    Dir.glob(pattern).each do |path|
      path =~ %r%([^/_]+)\.yml$%
      table = $1
      path.sub!(/\.yml$/, "")

      f = Fixtures.new( ActiveRecord::Base.connection, table, nil, path )
      f.insert_fixtures
    end
  end

  desc "This drops the db, builds the db, and seeds the data."
  task :reseed => [:environment, 'db:reset', 'db:seed']
end
