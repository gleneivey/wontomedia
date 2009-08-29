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


When /^I type "([^\"]*)"$/ do |value|
  value.each_byte{ |key|              # probably not good for anything but ASCII
    if key >= 0x41 && key <= 0x5a
      selenium.key_down_native(16)    # SHIFT key down for cap alphas
      selenium.key_press_native(key)
      selenium.key_up_native(16)
    elsif key > 0x61 && key <= 0x7a
      selenium.key_press_native(key - 0x20)
    else
      selenium.key_press_native(key)
    end
  }
end


When /^I type the "(.+)" special key$/ do |key_string|
  key = case key_string
        when /^Back$/     then   8
        when /^Tab$/      then   9
        when /^Enter$/    then  10    # Note: Firefox ignores, grrr...
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


When /^I put the focus on the "([^\"]+)" element$/ do |element_name|
  selenium.focus(element_name)
end


When /^the focus is on the "([^\"]+)" element$/ do |element_name|
  assert selenium.is_element_present(element_name),
    "No such element as '#{element_name}'."
  result = selenium.get_eval "" +
    "window.document.activeElement == " +
    "window.document.getElementById('#{element_name}');"
  assert "true" == result,
    "Element '#{element_name}' doesn't currently have focus."
end


Then /^the element "([^\"]+)" has the format "([^\"]+)"$/ do |selector, fmt|
  style_keyword, style_value = fmt.split( /=/ )
  result = selenium.get_eval(
    "e = window.document.getElementById('#{selector}'); " +
    "e = Element.extend(e); " +
    "e.getStyle('#{style_keyword}');" )
  assert result == style_value,
    "'#{selector}' element should have had the format '#{fmt}', " +
      "but was '#{result}'"
end


When /^a debug alert "([^\"]+)"$/ do |alert_text|
  selenium.get_eval "alert('#{alert_text}');"
end


Then /^the "([^\"]+)" element should(.*)match "([^\"]+)"$/ do |
    elemId, sense, re|
  result = selenium.get_eval(
    "window.document.getElementById('#{elemId}').innerHTML.search(/#{re}/)" ).
      to_i

  if     sense == " "
    assert result >= 0, "Pattern not present"
  elsif sense == " not "
    assert result == -1, "Unwanted pattern was present"
  else
    assert false, "Bad step string."
  end
end


Then /^the image "([^\"]+)" is "([^\"]+)"$/ do |imgId, srcSubstr|
  assert_have_selector "img##{imgId}"
  imgSrc = selenium.get_eval( "window.document.getElementById('#{imgId}').src" )
  result = /^#{srcSubstr}$/ =~ imgSrc                       ||
           /\/#{srcSubstr}$/ =~ imgSrc                      ||
           /^#{srcSubstr}\?/ =~ imgSrc                      ||
           /\/#{srcSubstr}\?/ =~ imgSrc                     ||
           /^#{srcSubstr}\.[a-zA-Z]+$/ =~ imgSrc            ||
           /\/#{srcSubstr}\.[a-zA-Z]+$/ =~ imgSrc           ||
           /^#{srcSubstr}\.[a-zA-Z]+\?/ =~ imgSrc           ||
           /\/#{srcSubstr}\.[a-zA-Z]+\?/ =~ imgSrc
  assert result, "Image source didn't match substring"
end


Then /^the "([^\"]+)" element's "([^\"]+)" attribute is "([^\"]*)"$/ do |
    elemId, attrName, attrValue|
  result = selenium.get_eval(
    "window.document.getElementById('#{elemId}').#{attrName};")
  assert result == attrValue,
    "$(#{elemId}).#{attrName} should have been #{attrValue}, was '#{result}'"
end


When /^I click the "([^\"]+)" element$/ do |elemId|
  selenium.get_eval "window.document.getElementById('#{elemId}').click();"
end


When /^I wait ([0-9.]+)( more)? seconds$/ do |time, fu|
  gotTimeout = false
  begin
    selenium.wait_for_text "this text will never occur in a web page",
      :timeout_in_seconds => time.to_f
  rescue Selenium::CommandError => e
    gotTimeout = e.message =~ /ed out after/;
  end

  assert gotTimeout, "Selenium didn't wait a full #{time} seconds."
end

When /^I pause$/ do
  gotTimeout = false
  begin
    selenium.wait_for_text "this text will never occur in a web page",
      :timeout_in_seconds => 0.10
  rescue Selenium::CommandError => e
    gotTimeout = e.message =~ /ed out after/;
  end

  assert gotTimeout, "Selenium didn't wait the full pause."
end

When /^I wait for Ajax requests to complete$/ do
  selenium.wait_for_ajax
end


