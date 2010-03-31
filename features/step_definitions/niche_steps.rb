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



# You know how the Cucumber Wiki identifies "Feature-Coupled Steps" as
# an anti-pattern?  Well, too bad.  The step definitions here are
# probably not usable outside of the Feature that I wrote them for,
# but trying to use "generic" matchers to accomplish the same effect
# was going to be weird and fragile.  So here we go....



Then /^I should(.*)see an?( enabled | disabled | )Add-new link for "(.+)"$/ do |test_sense, link_status, title_text|

  # We're going to check for a link whose text content matches "Add
  # new", that is a child of a node whose text content matches
  # 'title_text', that has a do-nothing href ("#"), and that has an
  # "onclick" attribute whose content is a credible faximile of a
  # function call name that would do what we want ("/show.*add/i").
  # On the one hand, this might be a little fragile.  On the other,
  # not tying it to node types should help, and at least this step is
  # our only dependency on how exactly the view formats these things.
#  xpath = %Q<//*[matches(text(), "#{title_text}")]/> +
#    %Q<ancestor::li//a[matches(text(), "add.*new", "i")][@href="#"]> +
#      %Q<[matches(@onclick, "show.*add", "i")]>

  # The above ought to work in an XPath 2.0 system that includes 'matches()',
  # but Selenium asks the browser to evaluate an XPath, and FF3.0 doesn't
  # implement matches(), so here's a more brittle, less-general version
  # built on 'contains()'.
  xpath = %Q<//*[contains(text(), "#{title_text}")]/> +
    %Q<ancestor::li//a[contains(text(), "Add new")][@href="#"]> +
      %Q<[contains(@onclick, "showInlineConnectionAdd")]>

  if     test_sense == " "
    assert_have_xpath xpath
    if link_status != ' '
      assert selenium.get_eval( "window.jQuery('#{xpath}').disabled;" ) =~
        (link_status == ' disabled ' ? /^true$/ : /^(false|null)$/ )
    end
  elsif test_sense == " not "
    assert_have_no_xpath xpath
  else
    assert false, "Bad step string."
  end
end
