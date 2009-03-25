Feature:  Create, view and edit individual nodes through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to create and view nodes.

  Scenario: Change all fields of an existing node
    Given there is 1 existing node like "fred"
    And I am on the edit nodes page for "fred0"
    And I fill in "node_name" with "nodeD"
    And I fill in "node_title" with "Node D"
    And I fill in "node_description" with "Description for node D ought to be here"
    When I press "node_submit"
    Then I should see "nodeD"
    And I should see "Node D"
    And I should see "Description for node D ought to be here"


  Scenario: Change all fields of an existing node, one in each of three ops
    Given there is 1 existing node like "wilma"
    And I am on the edit nodes page for "wilma0"
    And I fill in "node_name" with "reallyBetty"
    When I press "node_submit"
    Then I should see all of "reallyBetty", "This is wilma node number 0", "Lorem ipsum dolor sit wilma amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."
    And I follow "Edit this node"
    And I fill in "node_title" with "Betty Rubble disguised as Wilma"
    When I press "node_submit"
    Then I should see all of "reallyBetty", "Betty Rubble disguised as Wilma", "Lorem ipsum dolor sit wilma amet, consectetur adipiscing elit. Suspendisse 0 tincidunt mauris vitae lorem."
    And I follow "Edit this node"
    And I fill in "node_description" with "Fred is cheating"
    When I press "node_submit"
    Then I should see all of "reallyBetty", "Betty Rubble disguised as Wilma", "Fred is cheating"



#Test case: modify all three fields of an existing node.
#Test cases: modify each node field in an independent operation.
#Test case: node.name may only be an XML ID
#Test case: node.name must be unique across all nodes
#Test case: node.title may only be one line, no whitespace except %20
#Test case: no field allows an injection attack
#  (verify escaping of input HTML, JS, and SQL)


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
