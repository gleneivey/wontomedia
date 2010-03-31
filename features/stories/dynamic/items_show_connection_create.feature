Feature:  Create new connections from within a "show item" page
  In order to quickly and easily add to a wontology,
  as a contributor, I want
  to be able to add to an item those connections that are commonly associated
    with items of the same class, without having to visit a new page and
    explicitly select the subject and predicate items

# The items/show page lists not just the existing connections for an
# item, but also "anticipated" connections based on the item's class
# (an existing 'item is_instance_of class-item' connection) and on any
# existing 'property-item applies_to_class class-item' connections
# that apply to the class.

######
#### DEPENDS ON data from features/fixtures/items.yml and .../connections.yml
######


  @wip
  Scenario: Fresh show page contains add links, but no edit controls
    When I go to the show items page for "Fiesta"
    Then I should not see an Add-new link for "Manufacturing began in"
    Then I should see an Add-new link for "Manufacturing ended in"
    Then I should see an Add-new link for "Make is"



# (1) help icons on all forms; no way to predict which will
# display. (2) Each "Add" button inactive until matching control gets
# value. (3) When one control is non-empty, disable other controls and
# "Add new" links are disabled. (4) Reduce margin between
# per-connection links and right edge.






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
