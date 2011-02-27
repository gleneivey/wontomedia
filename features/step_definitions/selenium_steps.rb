# WontoMedia - a wontology web application
# Copyright (C) 2011 - Glen E. Ivey
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
    elsif key >= 0x61 && key <= 0x7a
      selenium.key_press_native(key - 0x20)
    else
      selenium.key_press_native(key)
    end

    Kernel.sleep(0.1)
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


When /^I click the "([^\"]+)" element$/ do |elemId|
  selenium.get_eval "window.document.getElementById('#{elemId}').click();"
end


When /^I put the focus on the "([^\"]+)" element$/ do |element_name|
  selenium.focus(element_name)
end


Then /^the focus is on (the|a) "([^\"]+)" element$/ do |
    article, element|

  if article == "the"
    assert selenium.is_element_present(element),
      "No such element as '#{element}'."
  end

  Kernel.sleep(0.1)   # ensure browser finishes procesing JS from last event
  result = selenium.get_eval "window.document.activeElement.id;"

  if article == "a"
    assert result =~ Regexp.new(element),
      "Element '#{result}' currently has focus, doesn't match '#{element}'."
  else
    assert result == element,
      "Element '#{result}' currently has focus instead of '#{element}'."
  end
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


Then /^the image "([^\"]+)" is( not)? "([^\"]+)"$/ do |imgId, sense, srcSubstr|
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
  if sense.nil? || sense == ""
    assert result, "Image source didn't match substring, actual was: "+imgSrc
  else
    assert !result, "Image source matched substring and shouldn't have"
  end
end


Then /^the "([^\"]+)" element's "([^\"]+)" attribute is "([^\"]*)"$/ do |
    elemId, attrName, attrValue|
  result = selenium.get_eval(
    "window.document.getElementById('#{elemId}').#{attrName};")
  assert result == attrValue,
    "$(#{elemId}).#{attrName} should have been #{attrValue}, was '#{result}'"
end


Then /^"([^\"]+)" is selected from "([^\"]+)"$/ do |expectedText, elemId|
  currentText = selenium.get_eval(
    "var selElem = window.document.getElementById('#{elemId}');              \
     selElem.options[selElem.selectedIndex].text;")
  assert currentText == expectedText,
    "<select> element '#{elemId}' should have had the option '#{expectedText}' selected, but the selected option was '#{currentText}'"
end


Then /the control "([^\"]+)" is (en|dis)abled/ do |controlId, state|
  disabledState = selenium.get_eval(
    "window.document.getElementById('#{controlId}').disabled;" );
  if    state == "en"
    assert disabledState == "false",
      "'#{controlId}' has disabled flag '#{disabledState}', instead of " +
      "being enabled."
  elsif state == "dis"
    assert disabledState == "true",
      "'#{controlId}' has disabled flag '#{disabledState}', instead of " +
      "being disabled."
  else
    assert false, "Control state must be either 'enabled' or 'disabled'"
  end
end


When /^I wait ([0-9.]+)( more)? seconds$/ do |time, fu|
  Kernel.sleep(time.to_f)
end

When /^I wait for Ajax requests to complete$/ do
  selenium.wait_for_ajax
end


When /^a debug alert "([^\"]+)"$/ do |alert_text|
  selenium.get_eval "alert('#{alert_text}');"
end


