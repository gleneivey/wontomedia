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


# Cucumber steps, depending on Webrat::Matchers, for more interesting
# result page content checks


Then /^I should see ([0-9]+) matches of "(.*)"$/ do |number, text|
  assert_select "body", /#{text}/, number.to_i
end

Then /^I should see all of "(.+)"$/ do |patterns|
  patterns.split(/"\s*,?\s*"/).each do |text|
    assert_select "body", /#{text}/
  end
end

