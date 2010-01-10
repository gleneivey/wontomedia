# WontoMedia - a wontology web application
# Copyright (C) 2010 - Glen E. Ivey
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


path_to_db_tests = File.join( File.dirname(__FILE__), 'unit', 'db' )
require File.join( File.join( path_to_db_tests, 'test_helper' ) )
require File.join( File.join( path_to_db_tests, 'assert_current_schema' ) )

class CreateEdgesTest < Test::Unit::TestCase
  include MigrationTestHelper
  include AssertCurrentSchema

  def test_the_current_schema
    drop_all_tables

    # we shouldn't have any tables
    assert_schema do |s|
    end

    migrate

    assert_current_schema
  end
end

