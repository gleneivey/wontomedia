Feature:  Create and view new individual connections through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to create and view connections.

  Scenario: Create new category-hierarchy-category connection
    Given there are 2 existing categories like "itemFamily"
    And I am on the new connections page
    And I select "itemFamily0 : itemFamily item number 0" from "Subject"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "itemFamily1 : itemFamily item number 1" from "Object"
    When I press "Create"
    Then I should see "successfully created"
    And I should see "itemFamily0"
    And I should see "parent_of"
    And I should see "itemFamily1"

  Scenario: Create new property-sub_property_of-property connection
    Given there is 1 existing property like "newProp"
    And I am on the new connections page
    And I select "newProp0 : newProp item number 0" from "Subject"
    And I select "sub_property_of : SubProperty Of (basic relationship type)" from "Relates to"
    And I choose "Item"
    And I select "predecessor_of : Predecessor Of (basic relationship)" from "Object"
    When I press "Create"
    Then I should see "successfully created"
    And I should see "newProp0"
    And I should see "sub_property_of"
    And I should see "predecessor_of"

  Scenario: Create new connection with scalar object
    Given there is 1 existing individual like "someone"
    And I am on the new connections page
    And I select "someone0 : someone item number 0" from "Subject"
    And I select "child_of : Child Of (basic relationship)" from "Relates to"
    And I choose "Value"
    And I fill in "connection_scalar_obj" with "someone older"
    When I press "Create"
    Then I should see "successfully created"
    And I should see "someone0"
    And I should see "child_of"
    And I should see "someone older"

  Scenario: I can't create an connection duplicating an existing one
    Given there are 2 existing individuals like "thing"
    And there is an existing connection "thing0" "contains" "thing1"
    And I am on the new connections page
    And I select "thing0 : thing item number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "thing1 : thing item number 1" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an connection using a sub/super property of an existing one
    Given there are 2 existing individuals like "thing"
    And there is an existing connection "thing0" "contains" "thing1"
    And I am on the new connections page
    And I select "thing0 : thing item number 0" from "Subject"
    And I select "parent_of : Parent Of (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "thing1 : thing item number 1" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an explicit connection duplicating an existing implicit one
    Given there are 2 existing individuals like "thing"
    And there is an existing connection "thing0" "contains" "thing1"
    And I am on the new connections page
    And I select "thing1 : thing item number 1" from "Subject"
    And I select "one_of : One Of (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "thing0 : thing item number 0" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an individual-contains-category connection
    Given there is 1 existing category like "myCategory"
    And there is 1 existing individual like "myItem"
    And I am on the new connections page
    And I select "myItem0 : myItem item number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "myCategory0 : myCategory item number 0" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an category-containedBy-individual connection
    Given there is 1 existing category like "myCategory"
    And there is 1 existing individual like "myItem"
    And I am on the new connections page
    And I select "myCategory0 : myCategory item number 0" from "Subject"
    And I select "child_of : Child Of (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "myItem0 : myItem item number 0" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an connection which would close a prohibited loop
    Given there are 3 existing individuals like "indiv"
    And there is an existing connection "indiv0" "predecessor_of" "indiv1"
    And there is an existing connection "indiv1" "predecessor_of" "indiv2"
    And I am on the new connections page
    And I select "indiv2 : indiv item number 2" from "Subject"
    And I select "predecessor_of : Predecessor Of (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "indiv0 : indiv item number 0" from "Object"
    When I press "Create"
    Then I should see "error"


    # Check various prohibited connection-to-self cases.  Verify each
    # fundamental prohibition, plus one property type that is
    # prohibited by inheritence
  Scenario: I can't create an hierarchical_relationship connection-to-self
    Given there is 1 existing individual like "myItem"
    And I am on the new connections page
    And I select "myItem0 : myItem item number 0" from "Subject"
    And I select "hierarchical_relationship : Hierarchical Relationship (root relationship type)" from "Relates to"
    And I choose "Item"
    And I select "myItem0 : myItem item number 0" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an ordered_relationship connection-to-self
    Given there is 1 existing individual like "myItem"
    And I am on the new connections page
    And I select "myItem0 : myItem item number 0" from "Subject"
    And I select "ordered_relationship : Ordered Relationship (root relationship type)" from "Relates to"
    And I choose "Item"
    And I select "myItem0 : myItem item number 0" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an one_of (implied hierarchical) connection-to-self
    Given there is 1 existing individual like "myItem"
    And I am on the new connections page
    And I select "myItem0 : myItem item number 0" from "Subject"
    And I select "one_of : One Of (basic relationship)" from "Relates to"
    And I choose "Item"
    And I select "myItem0 : myItem item number 0" from "Object"
    When I press "Create"
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
