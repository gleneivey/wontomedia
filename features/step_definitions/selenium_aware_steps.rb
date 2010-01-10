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

Then /^the "([^\"]*)" field should contain "([^\"]*)"$/ do |field, value|
  if @browser.nil?
    field_labeled(field).value.should =~ /#{value}/
  else
    fromPage = selenium.get_eval(
      "window.document.getElementById('#{field}').value")
    fromPage.should =~ /#{value}/
  end
end

Then /^the "([^\"]*)" field should be "([^\"]*)"$/ do |field, value|
  if @browser.nil?
    field_labeled(field).value == value
  else
    fromPage = selenium.get_eval(
      "window.document.getElementById('#{field}').value")
    fromPage.should == value
  end
end

Then /^the "([^\"]*)" field should not contain "([^\"]*)"$/ do |field, value|
  if @browser.nil?
    field_labeled(field).value.should_not =~ /#{value}/
  else
    value = selenium.get_eval(
      "window.document.getElementById('#{field}').value")
    value.should_not =~ /#{value}/
  end
end

When /^I pause$/ do
  if !@browser.nil?
    Kernel.sleep(1.0)
  end
end


######## originally in 'webrat_steps.rb'

When /^I go to "(.+)"$/ do |page_name|
  visit path_to(page_name)
  if !@browser.nil?
    Kernel.sleep(1.5)
  end
end

When /^(?:|I )press "([^\"]*)"$/ do |button|
  click_button(button)
  if !@browser.nil?
    Kernel.sleep(1.5)
  end
end

When /^(?:|I )follow "([^\"]*)"$/ do |link|
  click_link(link)
  if !@browser.nil?
    Kernel.sleep(1.5)
  end
end
