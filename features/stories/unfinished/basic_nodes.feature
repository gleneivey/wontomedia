Feature:  Basic node-related operations
  In order to create a wontology,
  as a contributor, I want
  to be able to create and view nodes.

  Scenario: Create new node
    Given I am on the new nodes page
    When I fill in "node_name" with "Category"
    And I fill in "node_title" with "Subcategory"
    And I fill in "node_description" with "The root category in the C topic"
    And I press "node_submit"
    Then I should see "Category"
    And I should see "Subcategory"
    And I should see "The root category in the C topic"



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
