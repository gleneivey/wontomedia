Feature:  Verify inputs for creation of new edge dynamically within the page
  (query server for Description of nodes chose in page's Select controls)
  In order to create a wontology,
  as a contributor, I want
  to be given context relating to my selections, so
    I feel more confidence in my actions and make fewer mistakes

# The edges/new form has three drop-down controls, one for each of the
# new edge's Subject, Predicate, and Object.  Each time the selection in
# one of these drop-downs is changed the page will fetch the node's
# description from the server (Ajax) and display it


  Scenario: New edges page interactively displays selected node descriptions
    Given there are 3 existing classes like "aClass"
    And there are 3 existing properties like "aProperty"
    And there are 3 existing individuals like "anItem"
    And I am on the new edges page

    When I select "aClass0 : aClass node number 0" from "Subject"
      # expected "Lorem ipsum" fragments from step_definitions/model_steps.rb
    Then I should see "dolor sit aClass"
    And I should see "Suspendisse 0"

    When I select "aProperty1 : aProperty node number 1" from "Relates to"
    Then I should see "dolor sit aProperty"
    And I should see "Suspendisse 1"

    When I select "anItem2 : anItem node number 2" from "Object"
    Then I should see "dolor sit anItem"
    And I should see "Suspendisse 2"



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
