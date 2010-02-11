Feature:  Edit individual edges through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to change the information for existing edges.

  Scenario: Change all fields of an existing edge
    Given there are 4 existing items like "item"
    And there is an existing edge "item0" "child_of" "item1"
    And I am on the edit edges page for "item0" "child_of" "item1"
    And I select "item2 : item node number 2" from "Subject"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    And I select "item3 : item node number 3" from "Object"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "item2"
    And I should see "parent_of"
    And I should see "item3"


  Scenario: Change all fields of an existing edge, one in each of three ops
    Given there are 4 existing items like "item"
    And there is an existing edge "item0" "child_of" "item1"
    And I am on the edit edges page for "item0" "child_of" "item1"
    And I select "item2 : item node number 2" from "Subject"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "item2"
    And I should see "child_of"
    And I should see "item1"

    Then I am on the edit edges page for "item2" "child_of" "item1"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "item2"
    And I should see "parent_of"
    And I should see "item1"

    Then I am on the edit edges page for "item2" "parent_of" "item1"
    And I select "item3 : item node number 3" from "Object"
    When I press "Update"
    Then I should see "successfully updated"
    And I should see "item2"
    And I should see "parent_of"
    And I should see "item3"


        # all of the error-checking tests mirror those in for edges_create,
        # but you never can tell.....

  Scenario: I can't change an edge to duplicate an existing one
    Given there are 2 existing items like "thing"
    And there are 2 existing items like "item"
    And there is an existing edge "thing0" "contains" "thing1"
    And there is an existing edge "item0" "peer_of" "item1"
    And I am on the edit edges page for "item0" "peer_of" "item1"
    And I select "thing0 : thing node number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I select "thing1 : thing node number 1" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge to use a sub/super prop of an existing one
    Given there are 2 existing items like "thing"
    And there is an existing edge "thing0" "parent_of" "thing1"
    And there is an existing edge "thing0" "peer_of" "thing1"
    And I am on the edit edges page for "thing0" "parent_of" "thing1"
    And I select "thing0 : thing node number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I select "thing1 : thing node number 1" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge to duplicate an existing implicit one
    Given there are 2 existing items like "thing"
    And there is an existing edge "thing0" "contains" "thing1"
    And there is an existing edge "thing0" "peer_of" "thing1"
    And I am on the edit edges page for "thing0" "contains" "thing1"
    And I select "thing1 : thing node number 1" from "Subject"
    And I select "one_of : One Of (basic relationship)" from "Relates to"
    And I select "thing0 : thing node number 0" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge to be item-contains-category
    Given there is 1 existing class like "myClass"
    And there is 1 existing item like "myItem"
    And there is an existing edge "myItem0" "child_of" "myClass0"
    And I am on the edit edges page for "myItem0" "child_of" "myClass0"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge to be category-containedBy-item
    Given there is 1 existing class like "myClass"
    And there is 1 existing item like "myItem"
    And there is an existing edge "myClass0" "contains" "myItem0"
    And I am on the edit edges page for "myClass0" "contains" "myItem0"
    And I select "one_of : One Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge to close a prohibited loop
    Given there are 3 existing items like "item"
    And there is an existing edge "item0" "predecessor_of" "item1"
    And there is an existing edge "item1" "predecessor_of" "item2"
    And there is an existing edge "item2" "value_relationship" "item0"
    And I am on the edit edges page for "item2" "value_relationship" "item0"
    And I select "predecessor_of : Predecessor Of (basic relationship)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge-to-self to hierarchical_relationship
    Given there is 1 existing item like "myItem"
    And there is an existing edge "myItem0" "value_relationship" "myItem0"
    And I am on the edit edges page for "myItem0" "value_relationship" "myItem0"
    And I select "hierarchical_relationship : Hierarchical Relationship (root relationship type)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an hierarchical_relationship edge into edge-to-self
    Given there are 2 existing items like "myItem"
    And there is an existing edge "myItem0" "hierarchical_relationship" "myItem1"
    And I am on the edit edges page for "myItem0" "hierarchical_relationship" "myItem1"
    And I select "myItem0 : myItem node number 0" from "Object"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change an edge-to-self to ordered_relationship
    Given there is 1 existing item like "myItem"
    And there is an existing edge "myItem0" "peer_of" "myItem0"
    And I am on the edit edges page for "myItem0" "peer_of" "myItem0"
    And I select "ordered_relationship : Ordered Relationship (root relationship type)" from "Relates to"
    When I press "Update"
    Then I should see "error"


  Scenario: I can't change a predecessor_of (implied ordered) into edge-to-self
    Given there are 2 existing items like "myItem"
    And there is an existing edge "myItem0" "predecessor_of" "myItem1"
    And I am on the edit edges page for "myItem0" "predecessor_of" "myItem1"
    And I select "myItem0 : myItem node number 0" from "Object"
    When I press "Update"
    Then I should see "error"





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
