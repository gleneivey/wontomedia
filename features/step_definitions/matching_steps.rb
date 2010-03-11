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


# Cucumber steps, depending on Webrat::[Selenium::]Matchers, for more
# interesting result page content checks


require 'nokogiri'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "step_helpers"))



Then /^I should see all of "(.+)"$/ do |patterns|
  patterns.split(/"\s*,?\s*"/).each do |text|
    assert_contain /#{text}/
  end
end


Then /^there should(.*)be an item container for "([^\"]+)" including the tag "(.+)"$/ do |test_sense, item_name, selector|

  selector = item_id_substitute(selector)
  assert_have_selector      "*##{item_name}"
  if     test_sense == " "
    assert_have_selector    "*##{item_name} #{selector}"
  elsif test_sense == " not "
    assert_have_no_selector "*##{item_name} #{selector}"
  else
    assert false, "Bad step string."
  end
end


Then /^I should see ([0-9]+) match(es)? of "([^\"]+)" in "([^\"]+)"$/ do |
    num_str, foo, text, selector|
  path = Nokogiri::CSS.parse(selector)[0].to_xpath
  response_fragment = Nokogiri.HTML(webrat.response_body).document.xpath(path)
  exact_count_match_helper( response_fragment.inner_text, text, num_str.to_i )
end


Then /^I should see ([0-9]+) match(es)? of "([^\"]+)"$/ do |
    num_str, foo, text|
  exact_count_match_helper( Nokogiri.HTML(webrat.response_body).inner_text,
                            text, num_str.to_i )
end


Then /^the response should contain ([0-9]+) match(es)? of "([^\"]+)"$/ do |
    num_str, foo, text|
  exact_count_match_helper( webrat.response_body, text, num_str.to_i )
end


private


def exact_count_match_helper(response_fragment, compare_string, i)
  response_parts = response_fragment.split(/#{compare_string}/m)

  if (i == 0)
    assert response_parts.length == 1,
      "Expected no match for '#{compare_string}'"
  elsif response_fragment =~ /\A#{compare_string}\Z/m
    assert i == 1,
      "Got one match of '#{compare_string}', expecting #{i}"
  else
            # we'll have one more "part" than the matches between
    assert response_parts.length == i+1,
      "Expected #{i} match(es) of '#{compare_string}', " +
      "found #{response_parts.length-1} instances."
  end
end
