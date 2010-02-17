Feature:  Verify inputs for creation of new item dynamically within the page
  (verify content of Title and Name are valid)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.


# see items_create_checks.feature for basic/common functionality
#
#  - item.name content checks:
#     - only allowed characters:
#        - 1st character [a-zA-Z]
#        - 2nd+ character [a-zA-Z_-]
#
#  - item.title content checks:
#     - only one line (doesn't contain any line-break whitespace)


  Scenario: error flagged if items/new's Name has bad first character
    When I am on the new items page
    Then the element "name_start_char" has the format "font-weight=400"
    And the image "name_error_icon" is "blank_error_icon"

    When I select "Property" from "Type"
    And I fill in "Title" with "A property's title"
    And I fill in "Name" with "temporaryGoodName0-_"
    Then the element "item_submit" has the format "background-color=$active_button_color;"

    When I fill in "Name" with " badNameStartsWithASpace"
    Then the element "name_start_char" has the format "font-weight=bold"
    And the element "name_required" has the format "font-weight=400"
    And the element "name_nth_char" has the format "font-weight=400"
    And the element "name_too_long" has the format "font-weight=400"
    And the image "name_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"


  @extended
  Scenario Outline: More errors flagged if bad first character
    Given I am on the new items page
    And I select "Property" from "Type"
    And I fill in "Title" with "A property's title"
    And I fill in "Name" with "temporaryGoodName0-_"
    When I fill in "Name" with <badName>
    Then the element "name_start_char" has the format "font-weight=bold"
    And the image "name_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    Examples:
      |             badName                   |
      | "4badNameStartsWithADigit"            |
      | "^badNameStartsWithRandomPunctuation" |
      | ".badNameStartsWithPeriod"            |
      | ":badNameStartsWithColon"             |
      | "-badNameStartsWithHyphen"            |
      | "_badNameStartsWithUnderscore"        |



  @extended
  Scenario Outline: error flagged if items/new's Name has bad 2nd+ character
    When I am on the new items page
    Then the element "name_start_char" has the format "font-weight=400"
    And the image "name_error_icon" is "blank_error_icon"

    Given I select "Property" from "Type"
    And I fill in "Title" with "A property's title"
    When I fill in "Name" with <badName>
    Then the element "name_nth_char" has the format "font-weight=bold"
    And the element "name_start_char" has the format "font-weight=400"
    And the element "name_required" has the format "font-weight=400"
    And the element "name_too_long" has the format "font-weight=400"
    And the image "name_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    Examples:
      |             badName             |
      | "badNameHasA Space"             |
      | "badNameHasSome&!^Punctuation"  |
      | "badNameHasMore<[+}Punctuation" |


  # Currently testing with FireFox only.  FF automatically maps invalid
  # control characters (from keyboard or direct assignment) to SPACE, so
  # there's no way to create the error case we're trying to check for.
  # JS development tests exist and pass (within env.js)  Keeping this
  # scenario present in case, when we expand our Selenium testing to
  # more browsers, we find one that accepts CR/LFs unmodified.
  @invalid
  Scenario: error flagged if items/new's Title contains CR and/or LF
    When I am on the new items page
    Then the element "title_multi_line" has the format "font-weight=400"
    And the image "title_error_icon" is "blank_error_icon"

    Given I select "Property" from "Type"
    And I fill in "Name" with "aProperty"

    When I fill in "Title" with "a multi-\012-line title"
    Then the element "title_multi_line" has the format "font-weight=bold"
    And the element "title_too_long" has the format "font-weight=400"
    And the element "title_required" has the format "font-weight=400"
    And the image "title_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    When I fill in "Title" with "a different newline\015 character (CR)"
    Then the element "title_multi_line" has the format "font-weight=bold"
    And the element "title_too_long" has the format "font-weight=400"
    And the element "title_required" has the format "font-weight=400"
    And the image "title_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    # also that transition from one error to another correctly flags new error
    When I fill in "Title" with "A title that is way, way too long.  A title that is way, way too long.  A title that is way, way too long.  A title that is way, way too long.  A title that is way, way too long.  A title that is way, way too long.  A title that is way, way too long.  A title that is way, way too long."
    Then the element "title_multi_line" has the format "font-weight=400"
    And the element "title_too_long" has the format "font-weight=bold"
    And the element "title_required" has the format "font-weight=400"
    And the image "title_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    When I fill in "Title" with "a classic\015\012CR-LF pair"
    Then the element "title_multi_line" has the format "font-weight=bold"
    And the element "title_too_long" has the format "font-weight=400"
    And the element "title_required" has the format "font-weight=400"
    And the image "title_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    When I fill in "Title" with ""
    Then the element "title_multi_line" has the format "font-weight=400"
    And the element "title_too_long" has the format "font-weight=400"
    And the element "title_required" has the format "font-weight=bold"
    And the image "title_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$inactive_button_color;"

    When I fill in "Title" with "An acceptable title string"
    Then the element "title_multi_line" has the format "font-weight=400"
    And the element "title_too_long" has the format "font-weight=400"
    And the element "title_required" has the format "font-weight=400"
    And the image "title_error_icon" is "error_error_icon"
    And the element "item_submit" has the format "background-color=$active_button_color;"



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
