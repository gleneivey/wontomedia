Feature:  Edit individual nodes through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to change the information for existing nodes.

  Scenario: Change all fields of an existing node
    Given there is 1 existing class like "fred"
    And I am on the edit nodes page for "fred0"
    And I fill in "Name" with "nodeD"
    And I fill in "Title" with "Node D"
    And I fill in "Description" with "Description for node D ought to be here"
    When I press "Update"
    Then I should see "nodeD"
    And I should see "Node D"
    And I should see "Description for node D ought to be here"


  Scenario: Change all fields of an existing node, one in each of three ops
    Given there is 1 existing item like "wilma"
    And I am on the edit nodes page for "wilma0"
    And I fill in "Name" with "reallyBetty"
    When I press "Update"
    Then I should see all of "reallyBetty", "wilma node number 0", "Lorem ipsum dolor sit wilma amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."
    And I follow "Edit this node"
    And I fill in "Title" with "Betty Rubble disguised as Wilma"
    When I press "Update"
    Then I should see all of "reallyBetty", "Betty Rubble disguised as Wilma", "Lorem ipsum dolor sit wilma amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."
    And I follow "Edit this node"
    And I fill in "Description" with "Fred is cheating"
    When I press "Update"
    Then I should see all of "reallyBetty", "Betty Rubble disguised as Wilma", "Fred is cheating"


  Scenario: I can't change one node name to match another
    Given there are 2 existing reiffied-properties like "someNode"
    And I am on the edit nodes page for "someNode0"
    And I fill in "Name" with "someNode1"
    When I press "Update"
    Then I should see "error"


  Scenario: When I delete a node, edges that use it go too
    Given there are 2 existing properties like "propFamily"
    And there is an existing edge "propFamily1" "child_of" "propFamily0"
    And I am on the show nodes page for "propFamily0"
    And I follow "Delete this node", accepting confirmation
    When I try to go to the show nodes page for "propFamily0"
    Then I should see "doesn't exist"
    When I try to go to the show edges page for "propFamily1" "child_of" "propFamily0"
    Then I should see "doesn't exist"


  Scenario: No delete links for built-in nodes
    Given there is 1 existing item like "anItem"
    When I go to the index nodes page
    Then there should be a node container for "anItem0" including the tag "a[href="/nodes/?anItem0?"][onclick*="delete"]"
    And there should not be a node container for "sub_property_of" including the tag "a[href="/nodes/?sub_property_of?"][onclick*="delete"]"


  Scenario: No edit links for built-in nodes
    Given there is 1 existing class like "aClass"
    When I go to the index nodes page
    Then there should be a node container for "aClass0" including the tag "a[href="/nodes/?aClass0?/edit"]"
    And there should not be a node container for "parent_of" including the tag "a[href="/nodes/?sub_property_of?/edit"]"



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
