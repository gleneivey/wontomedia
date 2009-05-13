Feature:  Create and view new individual edges through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to create and view edges.

  Scenario: Create new edge 
    Given there are 2 existing classes like "itemFamily"
    And I am on the new edges page
    And I select "itemFamily node number 0" from "Subject"
    And I select "Parent Of (wm built-in relationship)" from "Relates to"
    And I select "itemFamily node number 1" from "Object"
    When I press "Create"
    Then I should see "successfully created"
    And I should see "itemFamily0"
    And I should see "parent_of"
    And I should see "itemFamily1"

  Scenario: I can't create an edge duplicating an existing one
    Given there are 2 existing items like "thing"
    And there is an existing edge "thing0" "contains" "thing1"
    And I am on the new edges page
    And I select "thing node number 0" from "Subject"
    And I select "Contains (wm built-in relationship)" from "Relates to"
    And I select "thing node number 1" from "Object"
    When I press "Create"
    Then I should see "error"


  Scenario: I can't create an explicit edge duplicating an existing implicit one

  Scenario: I can't create an item-contains-category edge


    # Check various prohibited edge-to-self cases.  Verify each
    # fundamental prohibition, plus one property type that is
    # prohibited by inheritence
  Scenario: I can't create an hierarchical_relationship edge-to-self

  Scenario: I can't create an ordered_relationship edge-to-self

  Scenario: I can't create an one_of (implied hierarchical) edge-to-self



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