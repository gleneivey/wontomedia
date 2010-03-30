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


require File.join( File.dirname(__FILE__), 'local')
require 'spec/expectations'
require 'selenium'


Webrat.configure do |config|
  config.mode = :selenium
  config.application_environment = :test
  config.selenium_browser_startup_timeout = 40
end

# we can't use transactional fixtures because Rails and Cucumber have
# separate database connections, so data we create here ("Given...")
# is invisible to the app under test if it is hidden in a fixture.
# The preferred Cucumber solution to this problem is to use the
# DatabaseCleaner gem, but it unconditionally nukes everything, and
# we want to preserve seed and fixture data between execution of
# Scenarios.  So, we've got a custom bit of database-emptying code
# (used here for "dynamic" [e.g., Selenium] tests only) in the
# Cucumber "Before" hook defined below.
Cucumber::Rails::World.use_transactional_fixtures = false




# "before all"
browser = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox",
                                       "http://localhost", 15000)


Before do
  # clean up data created in last Scenario run (if any)
  c = ActiveRecord::Base.connection
  flags = Item::DATA_IS_UNALTERABLE | Item::FIXTURE_DATA
  c.execute( "DELETE FROM items WHERE (items.flags & #{flags}) = 0" )
  flags = Connection::DATA_IS_UNALTERABLE | Connection::FIXTURE_DATA
  c.execute(
    "DELETE FROM connections WHERE (connections.flags & #{flags}) = 0" )

  @browser = browser
  @browser.start rescue nil

    # test window must be on top for Tab key to advance focus "normally"
  selenium.get_eval( "window.focus();" )
end

After do
  @browser.stop rescue nil
end
