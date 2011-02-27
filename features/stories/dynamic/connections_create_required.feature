Feature:  Verify inputs for creation of new connection dynamically within the page
  (verify all "required" selections set before submission; flag those missing)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.


# The connections/new form can't be submitted until all three drop-down controls,
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
    When I am on the new connections page
    And I pause
    Then the focus is on the "connection_subject_id" element
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"


  Scenario: Empty form incrementally displays flag text/icons, no object kind
    When I am on the new connections page
    Then the focus is on the "connection_subject_id" element
    And the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from Subject to Predicate
    When I type the "Tab" special key
    And I pause
    Then the focus is on the "connection_predicate_id" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from Predicate to first Radio Button
    When I type the "Tab" special key
    Then the focus is on a "connection_kind_of_obj" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    # also, the object controls should be (have been) disabled at this point
    And the control "connection_obj_id" is disabled
    And the control "connection_scalar_obj" is disabled
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from first to second Radio Button
    When I type the "Tab" special key
    Then the focus is on a "connection_kind_of_obj" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the control "connection_obj_id" is disabled
    And the control "connection_scalar_obj" is disabled
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from second Radio Button to Create button
    When I type the "Tab" special key
    Then the focus is on the "connection_submit" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "error_error_icon"
    And the control "connection_obj_id" is disabled
    And the control "connection_scalar_obj" is disabled
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"


  Scenario: Empty form incrementally displays flag text/icons, pick an obj kind
    When I am on the new connections page
    Then the focus is on the "connection_subject_id" element
    And the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from Subject to Predicate
    When I type the "Tab" special key
    Then the focus is on the "connection_predicate_id" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from Predicate to first Radio Button
    When I type the "Tab" special key
    Then the focus is on a "connection_kind_of_obj" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    # also, the object controls should be (have been) disabled at this point
    And the control "connection_obj_id" is disabled
    And the control "connection_scalar_obj" is disabled
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from first to second Radio Button
    When I type the "Tab" special key
    Then the focus is on a "connection_kind_of_obj" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the control "connection_obj_id" is disabled
    And the control "connection_scalar_obj" is disabled
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # select a radio button -> enables Item-object control
    When I choose "Item"
    Then the control "connection_obj_id" is enabled
    # and this should all be unchanged
    And the control "connection_scalar_obj" is disabled
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from Radio Button to enabled Object control
    When I type the "Tab" special key
    Then the focus is on the "connection_obj_id" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # focus from Object to Create button
    When I type the "Tab" special key
    Then the focus is on the "connection_submit" element
    And the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "error_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"


  Scenario: Empty form displays flags & dialog on (disabled) Create click
    Given I am on the new connections page
    When I press "Create"
    And I pause
    Then the element "subject_required" has the format "font-weight=bold"
    And the element "predicate_required" has the format "font-weight=bold"
    And the element "obj_required" has the format "font-weight=bold"
    And the image "subject_error_icon" is "error_error_icon"
    And the image "predicate_error_icon" is "error_error_icon"
    And the image "kind_of_obj_error_icon" is "error_error_icon"
    And the image "obj_error_icon" is "error_error_icon"
    And the element "connection_submit" has the format "background-color=$inactive_button_color;"

    # ...and there should be a dialog reporting the problems
    And the "MB_content" element should match "Subject[^\.]+must have"
    And the "MB_content" element should match "Relationship[^\.]+must have"
    And the "MB_content" element should match "Object[^\.]+must have"


  Scenario: Flagged inputs are unflagged when filled--with scalar object
    Given there is 1 existing individual like "indiv"
    And there is 1 existing property like "property"
    And I am on the new connections page
    When I put the focus on the "connection_submit" element
    And I pause
    Then the element "connection_submit" has the format "background-color=$inactive_button_color;"

    When I select "indiv0 : indiv item number 0" from "Subject"
    And I select "property0 : property item number 0" from "Relates to"
    And I choose "Value"
    And I fill in "connection_scalar_obj" with "10:05:15"
    Then the element "subject_required" has the format "font-weight=400"
    And the element "predicate_required" has the format "font-weight=400"
    And the element "obj_required" has the format "font-weight=400"
    And the image "subject_error_icon" is "blank_error_icon"
    And the image "predicate_error_icon" is "blank_error_icon"
    And the image "kind_of_obj_error_icon" is "blank_error_icon"
    And the image "obj_error_icon" is "blank_error_icon"
    And the element "connection_submit" has the format "background-color=$active_button_color;"



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
