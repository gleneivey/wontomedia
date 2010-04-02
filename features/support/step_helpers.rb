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



def item_id_substitute(selector)
  subst_syntax_re = /\?([^?]+)\?/
  while selector =~ subst_syntax_re
    subst_name = $1
    item = Item.find_by_name(subst_name)
    selector.sub!(subst_syntax_re, item.id.to_s)
  end
  selector
end

# test_sense must be one of the strings ' ' and ' not ' (note spaces).
def assert_selenium_whether_displayed(test_sense, element_finding_js_source)
  # depends on page template including test-only JavaScript when appropriate;
  # a small cheat, but too much code to be the argument to 'get_eval'
  result = selenium.get_eval(
    "window.isDisplayedMatchOfSelector(\"#{element_finding_js_source}\");" )

  if     test_sense == " "
    assert result == 'true'
  elsif test_sense == " not "
    assert result == 'false'
  else
    assert false, "Bad step string."
  end
end
