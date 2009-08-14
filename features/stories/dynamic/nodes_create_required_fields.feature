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


  Scenario: Empty form incrementally displays "required" flags
    # new page: focus on Type, all inputs blank, none flagged
    When I am on the new nodes page
    Then the element "sti_type_required" has the format "font-weight=400"
    And the element "title_required" has the format "font-weight=400"
    And the element "name_required" has the format "font-weight=400"
    And the element "description_recommended" has the format "font-weight=400"
    And the image "sti_type_error_icon" is "blank_error_icon"
    And the image "title_error_icon" is "blank_error_icon"
    And the image "name_error_icon" is "blank_error_icon"
    And the image "description_error_icon" is "blank_error_icon"

    # focus from Type to Title -> Type gets flagges as "required"
    When I type the "Tab" special key
    Then the element "sti_type_required" has the format "font-weight=bold"
    And the element "title_required" has the format "font-weight=400"
    And the element "name_required" has the format "font-weight=400"
    And the element "description_recommended" has the format "font-weight=400"
    And the image "sti_type_error_icon" is "error_error_icon"
    And the image "title_error_icon" is "blank_error_icon"
    And the image "name_error_icon" is "blank_error_icon"
    And the image "description_error_icon" is "blank_error_icon"

    # focus from Title to Name -> Title also flagged as "required"
    When I type the "Tab" special key
    Then the element "sti_type_required" has the format "font-weight=bold"
    And the element "title_required" has the format "font-weight=bold"
    And the element "name_required" has the format "font-weight=400"
    And the element "description_recommended" has the format "font-weight=400"
    And the image "sti_type_error_icon" is "error_error_icon"
    And the image "title_error_icon" is "error_error_icon"
    And the image "name_error_icon" is "blank_error_icon"
    And the image "description_error_icon" is "blank_error_icon"

    # focus from Name to Description -> now Name flagged as "required" too
    When I type the "Tab" special key
    Then the element "sti_type_required" has the format "font-weight=bold"
    And the element "title_required" has the format "font-weight=bold"
    And the element "name_required" has the format "font-weight=bold"
    And the element "description_recommended" has the format "font-weight=400"
    And the image "sti_type_error_icon" is "error_error_icon"
    And the image "title_error_icon" is "error_error_icon"
    And the image "name_error_icon" is "error_error_icon"
    And the image "description_error_icon" is "blank_error_icon"

    # focus from Description to Create button -> plus Description flagged
    When I type the "Tab" special key
    Then the element "sti_type_required" has the format "font-weight=bold"
    And the element "title_required" has the format "font-weight=bold"
    And the element "name_required" has the format "font-weight=bold"
    And the element "description_recommended" has the format "font-weight=bold"
    And the image "sti_type_error_icon" is "error_error_icon"
    And the image "title_error_icon" is "error_error_icon"
    And the image "name_error_icon" is "error_error_icon"
    And the image "description_error_icon" is "warn_error_icon"


  Scenario: Empty form displays all blank flags on (disabled) Create click
    # by default, a new/empty form can't be submitted
    When I am on the new nodes page
    And the element "node_submit" has the format "background-color=rgb(255, 255, 255)"

    # all the messages/icons should be in "unflagged" state, but rely
    # on the preceding case for that

    # after clicking "Create", everything should be flagged...
    When I press "Create"
    Then the element "sti_type_required" has the format "font-weight=bold"
    And the element "title_required" has the format "font-weight=bold"
    And the element "name_required" has the format "font-weight=bold"
    And the element "description_recommended" has the format "font-weight=bold"
    And the image "sti_type_error_icon" is "error_error_icon"
    And the image "title_error_icon" is "error_error_icon"
    And the image "name_error_icon" is "error_error_icon"
    And the image "description_error_icon" is "warn_error_icon"

    # ...and there should be a dialog reporting the problems
    And the "MB_content" element should match "Type[^\.]+required"
    And the "MB_content" element should match "Title[^\.]+required"
    And the "MB_content" element should match "Name[^\.]+required"


# Fill in fields one at a time; observe removal of "required" flag as each is changed.

# Fill in each field in correct order, tab between them, observe no "required" flags displayed.

# Fill in form in reverse tab-order. Observe removal of "required" flags as changes are made. Empty each input field in random order, observing appearance of "required" flags. Rotate focus through all fields after each change.


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
