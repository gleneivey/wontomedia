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
Cucumber::Rails::World.use_transactional_fixtures = false




# "before all"
browser = Selenium::SeleniumDriver.new("localhost", 4444, "*firefox",
                                       "http://localhost", 15000)


Before do
  c = ActiveRecord::Base.connection
  flag = Item::DATA_IS_UNALTERABLE
  c.execute( "DELETE FROM items WHERE (items.flags & #{flag}) = 0" )
  flag = Connection::DATA_IS_UNALTERABLE
  c.execute( "DELETE FROM connections WHERE (connections.flags & #{flag}) = 0" )

  @browser = browser
  @browser.start rescue nil

    # test window must be on top for Tab key to advance focus "normally"
  selenium.get_eval( "window.focus();" )
end

After do
  @browser.stop rescue nil
end
