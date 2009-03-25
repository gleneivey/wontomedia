# WontoMedia -- a wontology web application
# Copyright (C) 2009 -- Glen E. Ivey
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


# Cucumber steps, particular to WontoMedia's "node" model


When /^there (are|is) ([0-9]+) existing nodes? like "(.*)"$/ do |foo,
  number, text|

  number.to_i.times do |c|
    n = Node.new(:name        => "#{text}#{c}",
                 :title       => "This is #{text} node number #{c}",
                 :description => "Lorem ipsum dolor sit #{text} amet, consectetur adipiscing elit. Suspendisse #{c} tincidunt mauris vitae lorem.")
    n.save
  end
end

