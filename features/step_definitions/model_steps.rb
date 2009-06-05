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


# Cucumber steps, particular to WontoMedia's "node", "edge" models


require Rails.root.join( 'lib', 'helpers', 'node_helper' )


Given /^there (are|is) ([0-9]+) existing (\S+) like "(.*)"$/ do |foo,
  number, user_type, text|

  number.to_i.times do |c|
    n = NodeHelper.new_typed_node(user_type,
      :name        => "#{text}#{c}",
      :title       => "#{text} node number #{c}",
      :description => "Lorem ipsum dolor sit #{text} amet, consectetur adipiscing elit. Suspendisse #{c} tincidunt mauris vitae lorem.",
      :flags       => 0                                        )
    n.save
  end
end

Given /^there is an existing edge "([^\"]*)" "([^\"]*)" "([^\"]*)"$/ do |
  subject, predicate, obj|

  e = Edge.new(:subject   => Node.find_by_name(subject),
               :predicate => Node.find_by_name(predicate),
               :obj       => Node.find_by_name(obj)         )
  e.save
end
