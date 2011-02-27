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


require 'active_record'
require 'active_record/fixtures'


namespace :db do
  desc "Load YAML seed data from db/fixtures"
  task :seed => :environment do
    load_all_YAML_globbed_from(
      File.join( RAILS_ROOT, 'db', 'fixtures', '**', '*.yml' ))
  end

  desc "This drops the db, builds the db, and seeds the data."
  task :reseed => [:environment, 'db:reset', 'db:seed']

  desc "Load YAML developtment test data from test/fixtures"
  task :test_fixtures => :environment do
    load_all_YAML_globbed_from(
      File.join( RAILS_ROOT, 'test', 'fixtures', '**', '*.yml' ))
  end
end

def load_all_YAML_globbed_from(pattern)
  ensure_ActiveRecord_available
  Dir.glob(pattern).each do |path|
    load_YAML_from path
  end
end

def ensure_ActiveRecord_available
  unless ActiveRecord::Base.connected?
    ActiveRecord::Base.establish_connection(
      ActiveRecord::Base.configurations[RAILS_ENV] )
  end
end

def load_YAML_from(path)
  path =~ %r%([^/_]+)\.yml$%
  table = $1
  path.sub!(/\.yml$/, "")

  begin
    f = Fixtures.new( ActiveRecord::Base.connection, table, nil, path )
    f.insert_fixtures
  rescue ActiveRecord::StatementInvalid
    # must have already loaded this data
  end
end
