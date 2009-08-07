Feature:  Verify inputs for creation of new node dynamically within the page
  (verify all "required" fields present before submission; flag those missing)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.


# see nodes_create_checks.feature for basic/common functionality
#
#  - field requirement checks:
#     - required: Type, Title, Name
#     - when a control gains focus, check all controls *prior* to it
#       in the tab order.  Mark any preceding, required control that
#       has not yet been given a value with an icon and emphasis of
#       the "required" instruction text.
#     - once a control is flagged, flag stays (regardless of focus)
#       until it is filled in
#     - enable "Create" button only when no error conditions detected
#     - onclick for *disabled* "Create" button:  update/refresh all
#       error checks; if errors, display dialog describing
#
#     - recomended: Description
#     - when a control gains focus, check all controls *prior* to it
#       in the tab order.  Mark any preceding, recommended control that
#       has not yet been given a value with an icon and emphasis of
#       the "recommended" instruction text.


  @unfinished
  Scenario: Empty form incrementally displays "required" flags
    # new page: focus on Type, all blank, no flags
    When I am on the new nodes page
    Then the element "type_required" has the format "font-weight=400"
    Then the element "title_required" has the format "font-weight=400"
    Then the element "name_required" has the format "font-weight=400"
    Then the element "description_recommended" has the format "font-weight=400"
    Then the image "type_error_icon" is "blank_error_icon"
    Then the image "title_error_icon" is "blank_error_icon"
    Then the image "name_error_icon" is "blank_error_icon"
    Then the image "description_error_icon" is "blank_error_icon"

    # focus from Type to Title
    When I type the "Tab" special key
    Then the element "type_required" has the format "font-weight=bold"
    Then the element "title_required" has the format "font-weight=400"
    Then the element "name_required" has the format "font-weight=400"
    Then the element "description_recommended" has the format "font-weight=400"
    Then the image "type_error_icon" is "error_error_icon"
    Then the image "title_error_icon" is "blank_error_icon"
    Then the image "name_error_icon" is "blank_error_icon"
    Then the image "description_error_icon" is "blank_error_icon"

    # focus from Title to Name
    When I type the "Tab" special key
    Then the element "type_required" has the format "font-weight=bold"
    Then the element "title_required" has the format "font-weight=bold"
    Then the element "name_required" has the format "font-weight=400"
    Then the element "description_recommended" has the format "font-weight=400"
    Then the image "type_error_icon" is "error_error_icon"
    Then the image "title_error_icon" is "error_error_icon"
    Then the image "name_error_icon" is "blank_error_icon"
    Then the image "description_error_icon" is "blank_error_icon"

    # focus from Name to Description
    When I type the "Tab" special key
    Then the element "type_required" has the format "font-weight=bold"
    Then the element "title_required" has the format "font-weight=bold"
    Then the element "name_required" has the format "font-weight=bold"
    Then the element "description_recommended" has the format "font-weight=400"
    Then the image "type_error_icon" is "error_error_icon"
    Then the image "title_error_icon" is "error_error_icon"
    Then the image "name_error_icon" is "error_error_icon"
    Then the image "description_error_icon" is "blank_error_icon"

    # focus from Description to Create button
    When I type the "Tab" special key
    Then the element "type_required" has the format "font-weight=bold"
    Then the element "title_required" has the format "font-weight=bold"
    Then the element "name_required" has the format "font-weight=bold"
    Then the element "description_recommended" has the format "font-weight=bold"
    Then the image "type_error_icon" is "error_error_icon"
    Then the image "title_error_icon" is "error_error_icon"
    Then the image "name_error_icon" is "error_error_icon"
    Then the image "description_error_icon" is "warn_error_icon"


  @unfinished
  Scenario: Empty form displays all blank flags on (disabled) Create click
    # by default, a new/empty form can't be submitted
    When I am on the new nodes page
    Then the element "node_submit"s "disabled" attribute is "true"

    # all the messages/icons should be in "unflagged" state, but rely
    # on the preceding case for that

    # after clicking "Create", everything should be flagged...
    When I press "Create"
    Then the element "type_required" has the format "font-weight=bold"
    Then the element "title_required" has the format "font-weight=bold"
    Then the element "name_required" has the format "font-weight=bold"
    Then the element "description_recommended" has the format "font-weight=bold"
    Then the image "type_error_icon" is "error_error_icon"
    Then the image "title_error_icon" is "error_error_icon"
    Then the image "name_error_icon" is "error_error_icon"
    Then the image "description_error_icon" is "warn_error_icon"

    # ...and there should be a dialog reporting the problems
    Then the "dialogDiv" element should match "Type[^\.]+required"
    Then the "dialogDiv" element should match "Title[^\.]+required"
    Then the "dialogDiv" element should match "Name[^\.]+required"


# Fill in fields one at a time; observe removal of "required" flag as each is changed.

# Fill in each field in correct order, tab between them, observe no "required" flags displayed.

# Fill in form in reverse tab-order. Observe removal of "required" flags as changes are made. Empty each input field in random order, observing appearance of "required" flags. Rotate focus through all fields after each change.


  @unfinished
  Scenario:
    Given 
    When 
    Then 


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
