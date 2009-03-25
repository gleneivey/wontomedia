Feature:  Create, view and edit individual nodes through non-Ajax pages
  In order to create a wontology,
  as a contributor, I want
  to be able to create and view nodes.

  Scenario: Create new node
    Given I am on the new nodes page
    When I fill in "node_name" with "Category"
    And I fill in "node_title" with "Subcategory"
    And I fill in "node_description" with "The root category in the C topic"
    When I press "node_submit"
    Then I should see "Category"
    And I should see "Subcategory"
    And I should see "The root category in the C topic"


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
