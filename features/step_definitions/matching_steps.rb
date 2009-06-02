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


Then /^I should see ([0-9]+) match(es)? of "(.*)" in "(.*)"$/ do |
    number, foo, text, selector|
  assert_select selector, { :text => /#{text}/, :count => number.to_i }
end

Then /^I should see all of "(.+)"$/ do |patterns|
  patterns.split(/"\s*,?\s*"/).each do |text|
    assert_select "body", /#{text}/
  end
end

Then /^there should(.*)be a node container for "([^\"]+)" including the tag "(.+)"$/ do |test_sense, node_name, selector|

  subst_syntax_re = /\?([^?]+)\?/
  while selector =~ subst_syntax_re
    node_name = $1
    node = Node.find_by_name(node_name)
    selector.sub!(subst_syntax_re, node.id.to_s)
  end

# have_selector appears to be grumpy about my CSS; assert_select & Selenium?
#  response.should have_selector("*##{node_name}") do |tag|
#    if    test_sense == " "
#      tag.should have_selector(selector)
#    elsif test_sense == " not "
#      tag.should_not have_selector(selector)
#    else
#      assert false, "Bad step string."
#    end
#  end

  assert_select "*##{node.name}" do
    if     test_sense == " "
      assert_select selector
    elsif test_sense == " not "
      assert_select selector, false
    else
      assert false, "Bad step string."
    end
  end
end

Then /^the response should contain ([0-9]+) match(es)? of "(.*)"$/ do |
    number, foo, text|
  i = number.to_i
  rb = webrat.response_body
  response_parts = rb.split(/#{text}/)
  if (i == 0)
    assert response_parts.length == 1, "Expected no match for '#{text}'"
  elsif rb =~ /^#{text}$/
    assert i == 1, "Got one match of '#{text}', expecting #{number}"
  else
    i -= 1
    if !( rb =~ /^#{text}/ )
      i += 1
    end
    if !( rb =~ /#{text}$/ )
      i += 1
    end
    assert response_parts.length == i, "Expected #{number} matches of '#{text}'"
  end
end
