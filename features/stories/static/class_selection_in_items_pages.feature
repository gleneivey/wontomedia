Feature:  Create and edit individual items with implicit creation of
          is_instance_of connections between the item and a class item
  In order to create an expressive wontology,
  as a contributor, I want
  to be able to have special support for the manipulation of an item's class

  Scenario: Create a new item with class
    Given there is 1 existing category like "aClass"
    And there is an existing connection "aClass0" "is_subclass_of" "Item_Class"
    And I am on the new items page
    When I select "aClass0" from "Class"
    And I select "Individual" from "Type"
    And I fill in "Name" with "myNewItem"
    And I fill in "Title" with "An item that is an instance of 'aClass'"
    And I fill in "Description" with "has no description"
    When I press "Create"
    Then I should see "successfully created"
    And I should see "aClass0"
    And I should see "myNewItem"
    And I should see "An item that is an instance of 'aClass'"
    And I should see "has no description"

    When I go to the show connections page for "myNewItem" "is_instance_of" "aClass0"
    Then I should see "An item that is an instance of 'aClass'"
    And I should see "Is an Instance Of"
    And I should see "aClass item number 0"


  Scenario: View an item with class
    Given there is 1 existing category like "aClass"
    And there is an existing connection "aClass0" "is_subclass_of" "Item_Class"
    And there is 1 existing individual like "anInstance"
    And there is an existing connection "anInstance0" "is_instance_of" "aClass0"
    When I go to the show items page for "anInstance0"
    Then I should see "Class:"
    And I should see "aClass0"


  Scenario: View an item without class
    And there is 1 existing individual like "notAnInstance"
    When I go to the show items page for "notAnInstance"
    Then I should not see "Class:"


  Scenario: View items index including item type and class
    Given there is 1 existing category like "aClass"
    And there is an existing connection "aClass0" "is_subclass_of" "Item_Class"
    And there is 1 existing individual like "anInstance"
    And there is an existing connection "anInstance0" "is_instance_of" "aClass0"
    When I go to the show items page for "anInstance0"
    Then I should see /Individual:\s+aClass0:/


  Scenario: Edit an item to change its class
    Given there are 2 existing categories like "aClass"
    And there is an existing connection "aClass0" "is_subclass_of" "Item_Class"
    And there is an existing connection "aClass1" "is_subclass_of" "Item_Class"
    And there is 1 existing individual like "anInstance"
    And there is an existing connection "anInstance0" "is_instance_of" "aClass0"

    Given I go to the edit items page for "anInstance0"
    And I select "aClass1" from "Class"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "aClass1"
    And I should not see "aClass0"


  Scenario: Edit an item to remove its class
    Given there is 1 existing category like "aClass"
    And there is an existing connection "aClass0" "is_subclass_of" "Item_Class"
    And there is 1 existing individual like "anInstance"
    And there is an existing connection "anInstance0" "is_instance_of" "aClass0"

    Given I go to the edit items page for "anInstance0"
    And I select "- class of item -" from "Class"
    When I press "Update"
    Then I should see "successfully updated"
    And I should not see "aClass0"


  Scenario: Edit an item to add a class
    Given there is 1 existing category like "aClass"
    And there is an existing connection "aClass0" "is_subclass_of" "Item_Class"
    And there is 1 existing individual like "anInstance"

    Given I go to the edit items page for "anInstance0"
    And I select "aClass0" from "Class"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "aClass0"

    When I go to the show connections page for "anInstance0" "is_instance_of" "aClass0"
    Then I should see "anInstance item number 0"
    And I should see "Is an Instance Of"
    And I should see "aClass item number 0"



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
