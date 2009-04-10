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

# define method in any context where 'require'ed; no fixed namespace/class
def load_wontomedia_app_seed_data
  unless ActiveRecord::Base.connected?
    ActiveRecord::Base.establish_connection(
      ActiveRecord::Base.configurations['test'])
  end
  Dir.glob(
    File.join( File.dirname(__FILE__), "..", "db", "fixtures",
               "**", "*.yml" )).each do |path|
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
end

