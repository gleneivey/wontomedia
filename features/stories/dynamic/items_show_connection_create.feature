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


  Scenario: Fresh show page contains add links, but no edit controls
    When I go to the show items page for "Fiesta"
    Then I should not see an Add-new link for "Manufacturing began in"
    And I should see an enabled Add-new link for "Manufacturing ended in"
    And I should see an enabled Add-new link for "Make is"
    And there should not be a displayed select tag
    And there should not be a displayed text input


  # expected connection sequence numbers given fixture data:
  #   1) 'Manufacturing began in' "1976"
  #   2) 'Manufacturing ended in' Add-new
  #   3) 'Make is' Add-new
  #   4) is_instance_of 'Automobile Model'
  Scenario: Add-new links open associated controls
    Given I am on the show items page for "Fiesta"
      # (below) I'd rather have used an xpath and matches(@id, "2"), but...
    When I follow "Add new" within "#inline-add-2-link"
    Then there should be a displayed text input
    And there should not be a displayed select tag

    When I follow "Add new" within "#inline-add-3-link"
    Then there should be a displayed text input
    And there should be a displayed select tag


  Scenario: Create a new scalar-valued connection
    Given I am on the show items page for "Fiesta"
    And I click "Add new" within "#inline-add-2-link"
    When I fill in "connection_scalar_obj" with "not yet"
      # (below) depends on a RAILS_ENV='test' kludge in the inline partials
    And I press "2"
    Then I should see "not yet"
    And I should not see an Add-new link for "Manufacturing ended in"
    And I should see an enabled Add-new link for "Make is"


  Scenario: Create a new item-valued connection
    Given I am on the show items page for "Fiesta"
    And I click "Add new" within "#inline-add-3-link"
    When I select "Ford : Ford Motor Company" from "connection_obj_id"
    And I press "3"
    Then I should see "Ford Motor Company"
    And I should not see an Add-new link for "Make is"
    And I should see an enabled Add-new link for "Manufacturing ended in"



# (2) Each "Add" button inactive until matching control gets
# value. (3) When one control is non-empty, disable other controls and
# "Add new" links are disabled.


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
