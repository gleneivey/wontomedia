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


When /^I am on the (\S+) (\S+) page$/ do |action, controller|
  visit "/#{controller}/#{action}"
end

When /^I am on the (\S+) edges page for "(.+)" "(.+)" "(.+)"$/ do |action,
    subj_name, pred_name, obj_name|
  subj_id = 
  id = Edge.first(:conditions => [
    "subject_id = ? AND predicate_id = ? AND obj_id = ?",
    Node.first(:conditions => "name = '#{subj_name}'").id,
    Node.first(:conditions => "name = '#{pred_name}'").id,
    Node.first(:conditions => "name = '#{obj_name}'" ).id       ]).id
  if action == "show"
    visit "/edges/#{id}"
  else
    visit "/edges/#{id}/#{action}"
  end
end

# it would be cool to generate a model class from the controllere name, but...
When /^I am on the (\S+) nodes page for "([^"]+)"$/ do |action, item|
  id = Node.first(:conditions => "name = '#{item}'").id
  if action == "show"
    visit "/nodes/#{id}"
  else
    visit "/nodes/#{id}/#{action}"
  end
end


