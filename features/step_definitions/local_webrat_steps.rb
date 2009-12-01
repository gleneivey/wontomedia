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


require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))


When /^(?:|I )fill in "([^\"]*)" with "(.*)"$/ do |field, value|
  while value =~ /\\([0-7]{3})/ do
    octal = Regexp.last_match[1]
    str = " "
    str[0]= octal.oct                 # Ruby 1.8
#    str.setbyte(0, octal.oct)        # Ruby 1.9
    value.sub!(/\\#{octal}/, str)
  end
  fill_in(field, :with => value)
end


When /^(?:|I )(am on|go to|try to go to) the path "(.+)"$/ do |fu, path|
  visit path
  if !@browser.nil?
    Kernel.sleep(1.5)
  end
end


Then /^there should be an element "([^\"]+)"$/ do |selector|
  assert_have_selector(selector)
end

Then /^there should not be an element "([^\"]+)"$/ do |selector|
  assert_have_no_selector(selector)
end

