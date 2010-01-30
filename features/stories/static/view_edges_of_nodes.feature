Feature:  View edges related to a node on that node's "resource" page
  To understand the arrangement of an ontology,
  as a contributor, I want
  to be able to view a node and its edges at the same time.

# a brief description of UI functionality, to guide test case choice:
# (not all behavior described is necessarily "acceptance worthy"; some
# may be validated in development tests)
#  - all edges involving a node will be listed/displayed
#  - each edge listed will have View, Edit, and Destroy links
#  - clicking on the other nodes in an edge will show those node pages
#  - edges will be listed in sorted groups
#   - first groups will be those edges with current node as subject
#    - first/separate group contains all edges whose predicate inherits
#      from value_relationship, sorted by predicate
#    - final group (in this set) contains all edges whose predicate is
#      used only once for this node
#    - each intermediate group contains all those edges which use the
#      same predicate.  In group, edges sorted by object; groups sorted
#      by predicate.
#   - next group will be those edges with current node as object, grouped
#     by predicate, sub-grouped by subject
#   - final group will be those edges with current node as predicate

# these acceptance tests are intentionally agnostic to
#  - what information is displayed for an edge; only the .name of
#    each *other* participating node is checked for
#  - relative order of edge components and links
#  - the formatting of edge display
#  - any in-browser modification to information displayed

  Scenario: Node page should contain a new-edge link
    Given I am on the show nodes page for "parent_of"
    When I follow "Add a new edge"
    Then I should see "Make a new edge"


  Scenario: View a node with no edges
    Given there is 1 existing item like "lonelyNode"
    When I am on the show nodes page for "lonelyNode0"
    Then I should not see "Edges for this node"


  Scenario: View a node with one edge
    Given there is 2 existing items like "friendlyNode"
    And there is an existing edge "friendlyNode0" "peer_of" "friendlyNode1"
    When I am on the show nodes page for "friendlyNode0"
    Then I should see "Edges for this node"
    And I should see "Peer Of (wm built-in relationship)"


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
