Feature:  View connections related to a item on that item's "resource" page
  To understand the arrangement of an ontology,
  as a contributor, I want
  to be able to view a item and its connections at the same time.

# a brief description of UI functionality, to guide test case choice:
# (not all behavior described is necessarily "acceptance worthy"; some
# may be validated in development tests)
#  - all connections involving a item will be listed/displayed
#  - each connection listed will have View, Edit, and Destroy links
#  - clicking on the other items in an connection will show those item pages
#  - connections will be listed in sorted groups
#   - first groups will be those connections with current item as subject
#    - first/separate group contains all connections whose predicate inherits
#      from value_relationship, sorted by predicate
#    - final group (in this set) contains all connections whose predicate is
#      used only once for this item
#    - each intermediate group contains all those connections which use the
#      same predicate.  In group, connections sorted by object; groups sorted
#      by predicate.
#   - next group will be those connections with current item as object, grouped
#     by predicate, sub-grouped by subject
#   - final group will be those connections with current item as predicate

# these acceptance tests are intentionally agnostic to
#  - what information is displayed for an connection; only the .name of
#    each *other* participating item is checked for
#  - relative order of connection components and links
#  - the formatting of connection display
#  - any in-browser modification to information displayed

  Scenario: Item page should contain a new-connection link
    Given I am on the show items page for "parent_of"
    When I follow "Add a new connection"
    Then I should see "Make a new connection"


  Scenario: View a item with no connections
    Given there is 1 existing individual like "lonelyItem"
    When I am on the show items page for "lonelyItem0"
    Then I should see 5 matches of "lonelyItem"


  Scenario: View a item with one connection
    Given there is 2 existing individuals like "friendlyItem"
    And there is an existing connection "friendlyItem0" "peer_of" "friendlyItem1"
    When I am on the show items page for "friendlyItem0"
    Then I should see 9 matches of "friendlyItem"
    And I should see "Peer Of"


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
