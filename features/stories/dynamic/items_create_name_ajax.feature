Feature:  Verify inputs for creation of new item dynamically within the page
  (query server to verify that Name is unique before submitting form)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.


# see items_create_checks.feature for basic/common functionality
#
#  - check that Name value from user doesn't conflict with an existing item
#     - if focus on Name field, begin uniqueness check 0.4s after last change
#     - on any focus change in page, check Name for changes since last
#       uniqueness check.  If Name changed, start new check
#     - on Name change,
#        - if displaying a "check OK" icon, clear to blank
#        - if check is in progress, clear icon to blank and abandon HTTP GET
#  - performing check causes:
#     - on start of uniqueness check, display "checking" icon
#     - on failure of uniqueness check, clear check icon to blank
#       (no specific error message, just no longer checking and no result)
#     - on completion of uniqueness check, display icon ("bad" icon and set
#       error status if result==404, "check OK" icon otherwise)


  Scenario: Name check identifies unique and already-used values
    Given there is 1 existing individual like "alreadyExisting"
    When I am on the new items page
    Then the image "name_status_icon" is "blank_status_icon"

    When I fill in "Name" with "alreadyExisting0"
    Then the element "name_is_unique" has the format "color=$inactive_confirmation_color;"
    And the element "name_must_be_unique" has the format "font-weight=400"

    # total elapsed time from item.Name.onchange > 0.40
    When I wait 0.20 seconds
    Then the image "name_status_icon" is "working_status_icon"
    And the element "name_must_be_unique" has the format "font-weight=400"
    And the element "name_is_unique" has the format "color=$inactive_confirmation_color;"

    When I wait for Ajax requests to complete
    Then the image "name_status_icon" is "error_status_icon"
    And the element "name_must_be_unique" has the format "font-weight=bold"
    And the element "name_is_unique" has the format "color=$inactive_confirmation_color;"

    When I fill in "Name" with "anUnusedItemName"
    Then the image "name_status_icon" is not "error_status_icon"
    And the element "name_must_be_unique" has the format "font-weight=400"
    And the element "name_is_unique" has the format "color=$inactive_confirmation_color;"

    When I wait for Ajax requests to complete
    And I pause
    Then the image "name_status_icon" is "good_status_icon"
    And the element "name_must_be_unique" has the format "font-weight=400"
    And the element "name_is_unique" has the format "color=$active_confirmation_color;"


#### Note: add checks for no "Name is unique" flagging to Name tests
#### in the items_create_invalid -checks feature

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
