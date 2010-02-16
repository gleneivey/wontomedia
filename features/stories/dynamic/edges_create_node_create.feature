Feature:  Create new nodes in the process of creating an edge
  In order to create a wontology,
  as a contributor, I want
  to be able create a new node during the creation of a new edge, so
    that I don't have to alternate between the two types of creation screens
    or abandon creation of an edge if I hadn't already put the nodes in place

# The edges/new form has three drop-down controls (Subject, Predicate,
# and Object), each contains a "no selection yet" entry and a list of
# all of the relevant nodes.  With the addition of this feature, each
# drop-down selection list also contains a "create a new [node type]"
# entry.  When this entry is selected, a "lightbox"-style <div> is
# superimposed above the main page content, and filled with a new
# nodes/create page from the server.
#
# The overlayed node creation page is generated from the URL
# nodes/new-pop?type=[].  It uses a pared-down version of the
# nodes/new page (without the explanatory text for each node type),
# and may have a restricted set of available node types.  (The "type="
# argument will be "noun" if the node is being created for a Subject
# or Object, and "verb" if it is for use as a Predicate.)
#
# If the user clicks the "Cancel" link in the pop-up node creation
# form, the form will be cleared, and the drop-down control's
# selection changed back to its previous value.  If the user clicks
# the "Create" button, the form content will be POSTed to nodes/create
# with an additional parameter indicating the source.  On a failure, a
# populated form with error messages is returned and the user
# continues.  On success, it returns a page of JavaScript that closes
# the pop-up, adds the new node to the appropriate control(s), and
# sets the value of the original select control.


  Scenario: Can create a new node during edge creation
    Given I am on the new edges page
    When I select "- create a new node for this object -" from "Subject"
    And I pause
    And I wait for Ajax requests to complete
    Then the "MB_content" element should match "Selection of a type is required"
    And the "MB_content" element should match "No more than 255 characters"

    Given I select "Individual" from "node_sti_type"
    And I fill in "Name" with "aNewSubject"
    And I fill in "Title" with "A new node for a new edge's Subject"
    And I fill in "Description" with "New subject node: test test test"
    When I press "Create"
    And I wait for Ajax requests to complete
    Then there should not be an element "MB_content"
    And "aNewSubject : A new node for a new edge's Subject" is selected from "edge_subject_id"


  Scenario: Can cancel the creation of a node during edge creation
    Given I am on the new edges page
    And I select "peer_of : Peer Of (basic relationship)" from "Relates to"
    When I select "- create a new property for this relationship -" from "Relates to"
    And I wait for Ajax requests to complete
    And I pause
    Then the "MB_content" element should match "Describe what this node"

    Given I fill in "Name" with "congruent_with"
    And I fill in "Title" with "Congruent With"
    And I fill in "Description" with "Too lazy to write one"
    When I follow "Cancel node creation"
    Then there should not be an element "MB_content"
    And "peer_of : Peer Of (basic relationship)" is selected from "edge_predicate_id"


  Scenario: Node created during cancelled edge creation still persists
    Given I am on the new edges page
    And I select "- create a new node for this object -" from "Object"
    And I wait for Ajax requests to complete
    And I select "Category" from "node_sti_type"
    And I fill in "Name" with "newNode"
    And I fill in "Title" with "New node"
    And I press "Create"
    And I wait for Ajax requests to complete
    When I follow "Cancel, show node list"
    Then I should see 1 match of "newNode"
    And I should see 1 match of "New node"


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
