Feature:  Verify inputs for editing of edges dynamically within the page
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.

# The data fields availiable in edges/##/edit pages are the same as
# those in the edges/new page.  These scenarios verify that the same
# dynamic checks performed in the edges/new page (see the
# 'edges_create*.feature' acceptance tests) are also performed in
# edges/##/edit.


  Scenario: Form initially has enabled Create button, focus on Subject
    Given there is 1 existing item like "apollo"
    And there is 1 existing item like "adama"
    And there is an existing edge "apollo0" "child_of" "adama0"
    When I am on the edit edges page for "apollo0" "child_of" "adama0"
    And I pause
    Then the focus is on the "edge_subject_id" element
    And the element "edge_submit" has the format "background-color=$active_button_color;"

  Scenario: Form incrementally flags/unflags text/icons when selections changed
    Given there is 1 existing item like "athena"
    And there is 1 existing item like "adama"
    And there is 1 existing item like "starbuck"
    And there is 1 existing item like "boomer"
    And there is an existing edge "adama0" "parent_of" "athena0"

    When I am on the edit edges page for "adama0" "parent_of" "athena0"
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"

    When I select "- this object -" from "Subject"
    And I pause
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"

    When I select "- has this relationship -" from "Relates to"
    And I select "starbuck0 : starbuck node number 0" from "Subject"
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"

    When I select "- to this object -" from "Object"
    And I select "peer_of : Peer Of (wm built-in relationship)" from "Relates to"
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "error_error_icon"
    And the element "edge_submit" has the format "background-color=$inactive_button_color;"

    When I select "boomer0 : boomer node number 0" from "Object"
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "edge_submit" has the format "background-color=$active_button_color;"

    When I press "Update"
    Then I should see "successfully updated"


  Scenario: Edit edges page interactively displays selected node descriptions
    Given there are 3 existing classes like "ColonialViper"
    And there are 3 existing properties like "shootsAt"
    And there are 3 existing items like "CylonRaider"
    And there is an existing edge "ColonialViper0" "shootsAt1" "CylonRaider2"

    When I am on the edit edges page for "ColonialViper0" "shootsAt1" "CylonRaider2"
    And I pause
      # expected "Lorem ipsum" fragments from step_definitions/model_steps.rb
    Then I should see "dolor sit ColonialViper"
    And I should see "Suspendisse 0"
    And I should see "dolor sit shootsAt"
    And I should see "Suspendisse 1"
    And I should see "dolor sit CylonRaider"
    And I should see "Suspendisse 2"

    When I select "CylonRaider1 : CylonRaider node number 1" from "Subject"
    And I pause
    Then I should not see "dolor sit ColonialViper"
    And I should not see "Suspendisse 0"
    And I should see "dolor sit CylonRaider"
    And I should see "Suspendisse 1"
    And I should see "Suspendisse 2"
    And I should see "dolor sit shootsAt"

    When I select "shootsAt0 : shootsAt node number 0" from "Relates to"
    And I pause
    Then I should not see "dolor sit ColonialViper"
    And I should see "dolor sit CylonRaider"
    And I should see "Suspendisse 1"
    And I should see "dolor sit shootsAt"
    And I should see "Suspendisse 0"
    And I should see "Suspendisse 2"

    When I select "ColonialViper1 : ColonialViper node number 1" from "Object"
    And I pause
    Then I should see "dolor sit CylonRaider"
    And I should see "Suspendisse 1"
    And I should see "dolor sit shootsAt"
    And I should see "Suspendisse 0"
    And I should see "dolor sit ColonialViper"
    And I should not see "Suspendisse 2"


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
