Feature:  Verify inputs for creation of new item dynamically within the page
  (verify the automatic generation of Name from Title)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.


# see items_create_checks.feature for basic/common functionality
#
#  - when the user has not (yet) explicitly provided a item.Name,
#    but they have provided (are providing) a item.Title, auto-generate
#    a suggested Name from the current contents of Title
#  - once the user explicitly alters item.Name, stop updating it to
#    reflect any changes in item.Title
#  - if the user *empties* the item.Name field, and subsequently alters
#    item.Title before providing a new value for item.Name, resume
#    auto-generation of item.Name
#
#  - the auto-generated item.Name suggestion must conform to the rules
#    for Name's content (except for uniqueness WRT existing items)
#  - the generated Name will be CamelCase, with the very first letter
#    generated being upper-case when item.Type is "Category" or "Individual",
#    and lower-case when Type is "Property"
#  - ignore any characters at the beginning of item.Title that are not
#    letters
#  - ignore any punctuation at the end of item.Title, except ')'
#  - ignore single quotation marks
#  - ignore the case of letters from item.Title when constructing
#    item.Name.  Letters in item.Name will always be generated CamelCase.
#  - Any number of contiguous whitespace and/or double-quote characters
#    and/or hyphen characters in item.Title form a word boundary.  No
#    characters are added to item.Name for a word boundary, but the next
#    character is capitalized.
#  - Digit characters are copied from item.Title to item.Name unmodified
#    (unless they occur at the beginning, where they are ignored)
#  - Any number of contiguous punctuation characters (not already mentioned)
#    in item.Title will cause a single underscore to be added to item.Name
#    AND be treated as a word boundary.
#
#  - These rules have the following implications:
#     - a hypen will not be included in the generated item.Name
#     - the character following an underscore, if it is a letter, will
#       always be capitalized


  Scenario: page generates a Name from a Title
    Given I am on the new items page
    And I select "Category" from "Type"
    When I fill in "Title" with "42 isn't a good start--for a name}"
    Then the "item_name" field should be "IsntAGoodStartForAName"


  @extended
  Scenario Outline: More page generates a Name from a Title
    Given I am on the new items page
    And I select "Property" from "Type"
    When I fill in "Title" with "<inputTitle>"
    Then the "item_name" field should be "<outputName>"

    Examples:
      |         inputTitle                |         outputName            |
      | 42 Is the 'Answer'                | isTheAnswer                   |
      | +-_ Starting with "punctuation"   | startingWithPunctuation       |
      | Question: 6 * 9                   | question_6_9                  |
      | Don't miss a"word"                | dontMissAWord                 |
      | BattleStar Galactica (TV Series+) | battlestarGalactica_TvSeries_ |
      | This title would make a Name more than 80 characters long, if the conversion process didn't truncate it correctly. | thisTitleWouldMakeANameMoreThan80CharactersLong_IfTheConversionProcessDidntTrunc |


  Scenario: auto Name generation disabled/enabled by editing Name
    Given I am on the new items page
    And I select "Individual" from "Type"
    When I put the focus on the "item_title" element
    And I pause
    And I type "another good title--for testing!"
    Then the "item_name" field should be "AnotherGoodTitleForTesting"

    When I put the focus on the "item_name" element
    And I pause
    And I type "Again"
    Then the "item_name" field should be "AnotherGoodTitleForTestingAgain"

    When I fill in "Title" with "but not this title!"
    Then the "item_name" field should be "AnotherGoodTitleForTestingAgain"

    Given I fill in "Name" with ""
    And  I fill in "Title" with ""
    And I put the focus on the "item_title" element
    And I pause
    When I type "auto-gen again"
    Then the "item_name" field should be "AutoGenAgain"
    And the element "name_required" has the format "font-weight=400"
    And the image "name_error_icon" is "blank_error_icon"


  Scenario: non-changing acts on Name field don't block auto generation
    Given I am on the new items page
    And I select "Property" from "Type"
    When I put the focus on the "item_title" element
    And I pause
    And I type "PoRtIo"
    And I pause
    Then the "item_name" field should be "portio"

    When I type the "Tab" special key
    And I type the "Left" special key
    And I type the "Left" special key
    Then the "item_name" field should be "portio"

    When I put the focus on the "item_title" element
    And I pause
    And I type "n of a t"
    Then the "item_name" field should be "portionOfAT"

    Given I put the focus on the "item_name" element
    And I pause
    When I type the "Up" special key
    And I type the "Left" special key
    And I type the "Escape" special key
    And I type the "Left" special key
    And I type the "Down" special key
    Then the "item_name" field should be "portionOfAT"

    Given I put the focus on the "item_title" element
    And I pause
    When I type "itle"
    And I pause
    Then the "item_name" field should be "portionOfATitle"


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
