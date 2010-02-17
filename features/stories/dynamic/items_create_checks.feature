Feature:  Verify inputs for creation of new item dynamically within the page
  (set focus on Type onload; highlight descriptive text matching Type selection)
  In order to create a wontology,
  as a contributor, I want
  to be told about bad inputs before I submit a page.

# a brief description of UI functionality to guide test case choice/design:
# (not all behavior described is necessarily "acceptance worthy"; some
# may be validated in development tests)
#
#  - focus is automatically on first form control when page is loaded
#  - form tab-order is: Type, Title, Name, Description, Create(button)
#
#  - item.sti_type choice feedback: emphasize type name in descriptive/help
#     text to match the type currently selected in the control
#
#  - see "items_create_required_fields" for required input behaviors
#  - see "items_create_too_long" for text input content too long behaviors
#  - see "items_create_invalid" for text input invalid behaviors
#  - see "items_create_auto_name" for auto-generation of Name from Title
#  - see "items_create_name_ajax" for Name uniqueness pre-submit check


  Scenario: items/new form defaults focus to Type "select" control
    When I am on the new items page
    Then the focus is on the "item_sti_type" element


  Scenario: items/new form has correct Tab order to controls
    Given I am on the new items page
    When I type the "Tab" special key
    Then the focus is on the "item_title" element
    When I type the "Tab" special key
    Then the focus is on the "item_name" element
    When I type the "Tab" special key
    Then the focus is on the "item_description" element
    When I type the "Tab" special key
    Then the focus is on the "item_submit" element


  Scenario: selection of item.sti_type should highlight matching descr. text
    Given I am on the new items page
    When I select "Category" from "Type"
    Then the element "category_title" has the format "font-weight=bold"
    And the element "category_title" has the format "text-decoration=underline"
    And the element "category_desc" has the format "font-weight=bold"


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
