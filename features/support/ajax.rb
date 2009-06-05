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


require 'spec/expectations'
require 'selenium'


Webrat.configure do |config|
#  config.mode = :selenium
  config.application_environment = :test
end

#World(Webrat::Selenium::Matchers)


# "before all"
browser = Selenium::SeleniumDriver.new("localhost", 4444, "*chrome",
                                       "http://localhost", 15000)

Before do
  c = ActiveRecord::Base.connection
  flag = Node::DATA_IS_UNALTERABLE
  c.execute( "DELETE FROM nodes WHERE (nodes.flags & #{flag}) = 0" )
  flag = Edge::DATA_IS_UNALTERABLE
  c.execute( "DELETE FROM edges WHERE (edges.flags & #{flag}) = 0" )

  @browser = browser
  @browser.start
end

After do
  @browser.stop
end

# "after all"
at_exit do
  browser.close rescue nil
end

