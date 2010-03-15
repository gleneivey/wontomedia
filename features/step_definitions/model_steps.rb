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


# Cucumber steps, particular to WontoMedia's "item", "connection" models


require Rails.root.join( 'lib', 'helpers', 'item_helper' )


Given /^there (are|is) ([0-9]+) existing (\S+) like "(.*)"$/ do |foo,
  number, user_type, text|

  number.to_i.times do |c|
    n = ItemHelper.new_typed_item(user_type,
      :name        => "#{text}#{c}",
      :title       => "#{text} item number #{c}",
      :description => "Lorem ipsum dolor sit #{text} amet, consectetur adipiscing elit. Suspendisse #{c} tincidunt mauris vitae lorem.",
      :flags       => 0                                        )
    n.save
  end
end

Given /^there is an existing connection "([^\"]*)" "([^\"]*)" "([^\"]*)"$/ do |
  subject, predicate, obj|

  con = Connection.new(
    :subject   => Item.find_by_name(subject),
    :predicate => Item.find_by_name(predicate),
    :obj       => Item.find_by_name(obj),
    :kind_of_obj => Connection::OBJECT_KIND_ITEM    )
  con.save
end

Given /^there is an existing connection "([^\"]*)" "([^\"]*)" '([^\"]*)'$/ do |
  subject, predicate, scalar|

  con = Connection.new(
    :subject     => Item.find_by_name(subject),
    :predicate   => Item.find_by_name(predicate),
    :scalar_obj  => scalar,
    :kind_of_obj => Connection::OBJECT_KIND_SCALAR    )
  con.save
end
