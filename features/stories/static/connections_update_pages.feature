Feature:  Edit individual connections through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to change the information for existing connections.

  Scenario: Change all fields of an existing connection
    Given there are 4 existing individuals like "indiv"
    And there is an existing connection "indiv0" "child_of" "indiv1"
    And I am on the edit connections page for "indiv0" "child_of" "indiv1"
    And I select "indiv2 : indiv item number 2" from "Subject"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    And I select "indiv3 : indiv item number 3" from "Object"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "indiv2"
    And I should see "parent_of"
    And I should see "indiv3"


  Scenario: Change all fields of an existing connection, one in each of three ops
    Given there are 4 existing individuals like "indiv"
    And there is an existing connection "indiv0" "child_of" "indiv1"
    And I am on the edit connections page for "indiv0" "child_of" "indiv1"
    And I select "indiv2 : indiv item number 2" from "Subject"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "indiv2"
    And I should see "child_of"
    And I should see "indiv1"

    Then I am on the edit connections page for "indiv2" "child_of" "indiv1"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "indiv2"
    And I should see "parent_of"
    And I should see "indiv1"

    Then I am on the edit connections page for "indiv2" "parent_of" "indiv1"
    And I select "indiv3 : indiv item number 3" from "Object"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "indiv2"
    And I should see "parent_of"
    And I should see "indiv3"


        # all of the error-checking tests mirror those in for connections_create,
        # but you never can tell.....

  Scenario: I can't change an connection to duplicate an existing one
    Given there are 2 existing individuals like "thing"
    And there are 2 existing individuals like "indiv"
    And there is an existing connection "thing0" "contains" "thing1"
    And there is an existing connection "indiv0" "peer_of" "indiv1"
    And I am on the edit connections page for "indiv0" "peer_of" "indiv1"
    And I select "thing0 : thing item number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I select "thing1 : thing item number 1" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection to use a sub/super prop of an existing one
    Given there are 2 existing individuals like "thing"
    And there is an existing connection "thing0" "parent_of" "thing1"
    And there is an existing connection "thing0" "peer_of" "thing1"
    And I am on the edit connections page for "thing0" "parent_of" "thing1"
    And I select "thing0 : thing item number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I select "thing1 : thing item number 1" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection to duplicate an existing implicit one
    Given there are 2 existing individuals like "thing"
    And there is an existing connection "thing0" "contains" "thing1"
    And there is an existing connection "thing0" "peer_of" "thing1"
    And I am on the edit connections page for "thing0" "contains" "thing1"
    And I select "thing1 : thing item number 1" from "Subject"
    And I select "one_of : One Of (basic relationship)" from "Relates to"
    And I select "thing0 : thing item number 0" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection to be individual-contains-category
    Given there is 1 existing category like "myCategory"
    And there is 1 existing individual like "myItem"
    And there is an existing connection "myItem0" "child_of" "myCategory0"
    And I am on the edit connections page for "myItem0" "child_of" "myCategory0"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection to be category-containedBy-individual
    Given there is 1 existing category like "myCategory"
    And there is 1 existing individual like "myItem"
    And there is an existing connection "myCategory0" "contains" "myItem0"
    And I am on the edit connections page for "myCategory0" "contains" "myItem0"
    And I select "one_of : One Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection to close a prohibited loop
    Given there are 3 existing individuals like "indiv"
    And there is an existing connection "indiv0" "predecessor_of" "indiv1"
    And there is an existing connection "indiv1" "predecessor_of" "indiv2"
    And there is an existing connection "indiv2" "value_relationship" "indiv0"
    And I am on the edit connections page for "indiv2" "value_relationship" "indiv0"
    And I select "predecessor_of : Predecessor Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection-to-self to hierarchical_relationship
    Given there is 1 existing individual like "myItem"
    And there is an existing connection "myItem0" "value_relationship" "myItem0"
    And I am on the edit connections page for "myItem0" "value_relationship" "myItem0"
    And I select "hierarchical_relationship : Hierarchical Relationship (root relationship type)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an hierarchical_relationship connection into connection-to-self
    Given there are 2 existing individuals like "myItem"
    And there is an existing connection "myItem0" "hierarchical_relationship" "myItem1"
    And I am on the edit connections page for "myItem0" "hierarchical_relationship" "myItem1"
    And I select "myItem0 : myItem item number 0" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an connection-to-self to ordered_relationship
    Given there is 1 existing individual like "myItem"
    And there is an existing connection "myItem0" "peer_of" "myItem0"
    And I am on the edit connections page for "myItem0" "peer_of" "myItem0"
    And I select "ordered_relationship : Ordered Relationship (root relationship type)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change a predecessor_of (implied ordered) into connection-to-self
    Given there are 2 existing individuals like "myItem"
    And there is an existing connection "myItem0" "predecessor_of" "myItem1"
    And I am on the edit connections page for "myItem0" "predecessor_of" "myItem1"
    And I select "myItem0 : myItem item number 0" from "Object"
    When I press "Update"
    Then I should see "error"





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
