Feature:  Verify inputs for creation of new node dynamically within the page
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
#  - see "nodes_create_checks_required_fields" for "required input" behaviors
#
#  - node.sti_type choice feedback: emphasize type name in descriptive/help
#     text to match the type currently selected in the control
#
#  - node.title content checks:
#     - only one line (doesn't contain any line-break whitespace)
#
#  - node.name auto-generation:
#     - on keys typed into node.Title control, if node.Name control is
#       empty, set auto-generation flag
#     - on changes to node.Name control when focus is on that control,
#       clear auto-generation flag
#     - on changes to node.Title control, if auto-generate flag==true,
#       create/set new value to node.Name control from current
#       node.Title control content.  New value is node.Title content,
#       whitespace removed, converted to CamelCase (lower C.C. if a
#       Property, upper C.C. otherwise)
#
#  - node.name content checks:
#     - no unallowed characters
#        - 1st character
#        - 2nd+ character


  Scenario: nodes/new form defaults focus to Type "select" control
    When I am on the new nodes page
    Then the focus is on the "node_sti_type" element


  Scenario: nodes/new form has correct Tab order to controls
    Given I am on the new nodes page
    When I type the "Tab" special key
    Then the focus is on the "node_title" element
    When I type the "Tab" special key
    Then the focus is on the "node_name" element
    When I type the "Tab" special key
    Then the focus is on the "node_description" element
    When I type the "Tab" special key
    Then the focus is on the "node_submit" element


  Scenario: selection of node.sti_type should highlight matching descr. text
    Given I am on the new nodes page
    When I select "Category" from "Type"
    Then the element "category_title" has the format "font-weight=bold"
    And the element "category_title" has the format "text-decoration=underline"
    And the element "category_desc" has the format "font-weight=bold"


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
