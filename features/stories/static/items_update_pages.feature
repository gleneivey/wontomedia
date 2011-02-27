Feature:  Edit individual items through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to change the information for existing items.

  Scenario: Change all fields of an existing item
    Given there is 1 existing category like "fred"
    And I am on the edit items page for "fred0"
    And I fill in "Name" with "itemD"
    And I fill in "Title" with "Item D"
    And I fill in "Description" with "Description for item D ought to be here"
    When I press "Update"
    Then I should see "itemD"
    And I should see "Item D"
    And I should see "Description for item D ought to be here"


  Scenario: Change all fields of an existing item, one in each of three ops
    Given there is 1 existing individual like "wilma"
    And I am on the edit items page for "wilma0"
    And I fill in "Name" with "reallyBetty"
    When I press "Update"
    Then I should see all of "reallyBetty", "wilma item number 0", "Lorem ipsum dolor sit wilma amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."
    And I follow "Edit this item"
    And I fill in "Title" with "Betty Rubble disguised as Wilma"
    When I press "Update"
    Then I should see all of "reallyBetty", "Betty Rubble disguised as Wilma", "Lorem ipsum dolor sit wilma amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."
    And I follow "Edit this item"
    And I fill in "Description" with "Fred is cheating"
    When I press "Update"
    Then I should see all of "reallyBetty", "Betty Rubble disguised as Wilma", "Fred is cheating"


  Scenario: I can't change one item name to match another
    Given there are 2 existing qualified-connections like "someItem"
    And I am on the edit items page for "someItem0"
    And I fill in "Name" with "someItem1"
    When I press "Update"
    Then I should see "error"


  Scenario: When I try to delete an item, it deletes
    Given there is 1 existing property like "propFamily"
    And I am on the show items page for "propFamily0"
    And I follow "Delete this item", accepting confirmation
    When I try to go to the show items page for "propFamily0"
    Then I should see "doesn't exist"


  Scenario: When I try to delete an in-use item, it doesn't
    Given there are 2 existing properties like "propFamily"
    And there is an existing connection "propFamily1" "child_of" "propFamily0"
    And I am on the show items page for "propFamily0"
    When I follow "Can't delete this item", accepting confirmation
    Then I should see all of "propFamily0", "propFamily item number 0", "Lorem ipsum dolor sit propFamily amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."


  Scenario: Delete links for user items, not for built-in items
    Given there is 1 existing individual like "anItem"
    When I go to the index items page
    Then there should be an item container for "anItem0" including the tag "a[href="/w/items/?anItem0?"][onclick*="delete"]"
    And there should not be an item container for "sub_property_of" including the tag "a[href="/w/items/?sub_property_of?"][onclick*="delete"]"


  Scenario: Edit links for user items, not for built-in items
    Given there is 1 existing category like "aCategory"
    When I go to the index items page
    Then there should be an item container for "aCategory0" including the tag "a[href="/aCategory0/edit"]"
    And there should not be an item container for "parent_of" including the tag "a[href="/sub_property_of/edit"]"



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
