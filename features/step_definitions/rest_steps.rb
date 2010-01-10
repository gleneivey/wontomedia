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



When /^I (am on|go to|try to go to) the (\S+) (\S+) page$/ do |fu, action,
                                                                   controller|
  if action == "index"
    visit "/#{controller}/"
  else
    visit "/#{controller}/#{action}"
  end
  if !@browser.nil?
    selenium.get_eval( "window.focus();" )
    Kernel.sleep(1.5)
  end
end

When /^I (am on|go to|try to go to) the (\S+) edges page for "(.+)" "(.+)" "(.+)"$/ do |fu, action, subj_name, pred_name, obj_name|
  s = Node.first(:conditions => "name = '#{subj_name}'")
  p = Node.first(:conditions => "name = '#{pred_name}'")
  o = Node.first(:conditions => "name = '#{obj_name}'" )

  if s.nil? || p.nil? || o.nil?
    e = nil
  else
    e = Edge.first(:conditions => [
          "subject_id = ? AND predicate_id = ? AND obj_id = ?",
          s.id, p.id, o.id ])
  end

  if action == "show"
    if e.nil?
      visit "/edges/0"
    else
      visit "/edges/#{e.id}"
    end
  else
    if e.nil?
      visit "/edges/0/#{action}"
    else
      visit "/edges/#{e.id}/#{action}"
    end
  end
  if !@browser.nil?
    Kernel.sleep(1.5)
  end
end

# it would be cool to generate a model class from the controller name, but...
When /^I (am on|go to|try to go to) the (\S+) nodes page for "([^"]+)"$/ do |fu, action, item|
  n = Node.first(:conditions => "name = '#{item}'")
  if action == "show"
    if n.nil?
      visit "/nodes/0"
    else
      visit "/nodes/#{n.id}"
    end
  else
    if n.nil?
      visit "/nodes/0/#{action}"
    else
      visit "/nodes/#{n.id}/#{action}"
    end
  end
  if !@browser.nil?
    Kernel.sleep(1.5)
  end
end
