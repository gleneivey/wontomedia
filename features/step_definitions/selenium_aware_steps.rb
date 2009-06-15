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



require 'nokogiri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "step_helpers"))



When /^I follow "([^\"]*)", accepting confirmation$/ do |link|
  if @browser.nil?
    click_link(link)
  else
    selenium.click("link=#{link}")
    assert selenium.get_confirmation
  end
end