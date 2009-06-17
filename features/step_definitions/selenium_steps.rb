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


When /^I type "([^\"]*)" into "([^\"]*)"$/ do |value, field|
  selenium.type_keys field, value
end


When /^I type the "(.+)" special key/ do |key_string|
  key = case key_string
        when /^Back$/     then   8
        when /^Tab$/      then   9
        when /^Enter$/    then  10
        when /^Escape$/   then  27
        when /^Delete$/   then 127
        when /^Up$/       then 224
        when /^Down$/     then 225
        when /^Left$/     then 226
        when /^Right$/    then 227
        else                   151    # asterisk, as good a default as any...
        end
  selenium.key_press_native(key)
end


When /^the focus is on the "([^\"]+)" control/ do |control_name|
  assert selenium.is_element_present(control_name),
    "No such element as '#{control_name}'."
  result = selenium.get_eval "" +
    "window.document.activeElement == " +
    "window.document.getElementById('#{control_name}');"
  assert "true" == result,
    "Element '#{control_name}' doesn't currently have focus."
end
