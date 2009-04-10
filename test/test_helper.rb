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


ENV["RAILS_ENV"] = "test"
require File.join( File.dirname(__FILE__), "..", "config", "environment" )
require 'test_help'

class ActiveSupport::TestCase
  self.use_instantiated_fixtures  = false
  fixtures :all

  def assert_negative_view_contents
    assert_select "body", { :text => /error/i, :count => 0 },
      "Page cannot say 'error'"
    assert_select "body", { :text => /successfully created/i, :count => 0 },
      "Page cannot say 'successfully created'"
    assert_select "body", { :text => /warranty/i, :count => 0 },
      "Page cannot say 'warranty'"
  end
end

    # load the "seed" data
ActiveRecord::Base.establish_connection(
  ActiveRecord::Base.configurations['test'])
Dir.glob(
  File.join( File.dirname(__FILE__), "..", "db", "fixtures", "**", "*.yml" )).
  each do |path|
    path =~ %r%([^/]+)\.yml$%
    table = $1
    f = Fixtures.new( ActiveRecord::Base.connection, table, nil, path )
    f.insert_fixtures
  end
