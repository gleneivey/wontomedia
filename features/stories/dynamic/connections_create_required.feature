Feature:  Verify inputs for creation of new edge dynamically within the page
  (verify all "required" selections set before submission; flag those missing)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.


# The edges/new form can't be submitted until all three drop-down controls,
# (Subject, Predicate, and Object) are non-default.
#
#  - When a control gains focus, check all controls *prior* to it in the
#    tab order.  Mark any preceding, required control that still has its
#    default value (icon + text highlight).
#  - Once a control is flagged, flag stays (regardless of focus) until
#    a selection is made.
#  - Enable "Create" button only when no error conditions detected
#  - onclick for *disabled* "Create" button:  update/refresh all error
#    checks; if errors, display dialog describing

  Scenario: Empty form initially has disabled Create button, focus on Subject
    When I am on the new edges page
    And I pause
    Then the focus is on the "edge_subject_id" element
    And the element "edge_submit" has the format "background-color=$inactive_button_color;"

  Scenario: Empty form incrementally displays flag text/icons
    When I am on the new edges page
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"

    # focus from Subject to Predicate
    When I type the "Tab" special key
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"

    # focus from Predicate to Object
    When I type the "Tab" special key
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"

    # focus from Predicate to Create button
    When I type the "Tab" special key
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "error_error_icon"

    And the element "edge_submit" has the format "background-color=$inactive_button_color;"

  Scenario: Empty form displays flags & dialog on (disabled) Create click
    Given I am on the new edges page
    When I press "Create"
    And I pause
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "error_error_icon"

    # ...and there should be a dialog reporting the problems
    And the "MB_content" element should match "Subject[^\.]+must have"
    And the "MB_content" element should match "Relationship[^\.]+must have"
    And the "MB_content" element should match "Object[^\.]+must have"
    And the element "edge_submit" has the format "background-color=$inactive_button_color;"

  Scenario: Inputs flagged for empty are unflagged when filled, Create enabled
    Given there is 1 existing class like "category"
    And there is 1 existing individual like "indiv"
    And I am on the new edges page
    When I put the focus on the "edge_submit" element
    And I pause
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "error_error_icon"
    And the element "edge_submit" has the format "background-color=$inactive_button_color;"

    When I select "category0 : category node number 0" from "Subject"
    And I select "contains : Contains (basic relationship)" from "Relates to"
    And I select "indiv0 : indiv node number 0" from "Object"
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "edge_submit" has the format "background-color=$active_button_color;"



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
