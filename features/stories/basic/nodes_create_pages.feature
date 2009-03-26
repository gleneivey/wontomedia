Feature:  Create, view and edit individual nodes through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to create and view nodes.

  Scenario: Create new node
    Given I am on the new nodes page
    And I fill in "node_name" with "Category"
    And I fill in "node_title" with "Subcategory"
    And I fill in "node_description" with "The root category in the C topic"
    When I press "node_submit"
    Then I should see "Category"
    And I should see "Subcategory"
    And I should see "The root category in the C topic"


  Scenario: System should prevent entry of invalid node names
    Given I am on the new nodes page
    And I fill in "node_name" with "0bad"
    And I fill in "node_title" with "A good title /\?"
    And I fill in "node_description" with "0 And a (good) description, too."
    When I press "node_submit"
    Then I should see "error"
    And I fill in "node_name" with "bad too"
    When I press "node_submit"
    Then I should see "error"
    And I fill in "node_name" with "BAD>bad"
    When I press "node_submit"
    Then I should see "error"


  Scenario: I can't enter two nodes with same name
    Given I am on the new nodes page
    And I fill in "node_name" with "original"
    And I fill in "node_title" with "Original Node"
    And I fill in "node_description" with "description"
    When I press "node_submit"
    Then I should see "successfully created"
    Given I am on the new nodes page
    And I fill in "node_name" with "original"
    And I fill in "node_title" with "Second Node"
    And I fill in "node_description" with "Actually second node, but bad name"
    When I press "node_submit"
    Then I should see "error"


  Scenario: System should prevent entry of invalid node titles
    Given I am on the new nodes page
    And I fill in "node_name" with "goodName"
    And I fill in "node_title" with "Bad title\012has two lines"
    And I fill in "node_description" with "good"
    When I press "node_submit"
    Then I should see "error"


        # will move to a different "feature" when index pages get smarter
  Scenario: Homepage shows list of existing nodes
    Given there are 5 existing nodes like "kirgagh"
    When I go to the homepage
    Then I should see 5 matches of "kirgagh[0-9]+"


  Scenario: View index of existing nodes
    Given there are 12 existing nodes like "fufubarfu"
    When I go to /nodes
    Then I should see 36 matches of "fufubarfu"


# WontoMedia -- a wontology web application
# Copyright (C) 2009 -- Glen E. Ivey
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
