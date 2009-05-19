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
#   - next group will be those edges with current node as object, sorted
#     by predicate, sub-sorted by subject
#   - final group will be those edges with current node as predicate

# these acceptance tests are intentionally agnostic to
#  - what information is displayed for an edge; only the .name of
#    each *other* participating node is checked for
#  - relative order of edge components and links
#  - the formatting of edge display
#  - any in-browser modification to information displayed

  Scenario: Node page should contain a new-edge link
    Given I am on the show nodes page for "parent_of"
    When I follow "Add new edge"
    Then I should see "New edge"


  Scenario: View a node with no edges

  Scenario: View a node with one edge

  Scenario: View a node with multiple edges all using the same predicate

  Scenario: View a node with many edges all using different predicates

  Scenario: View a node with edges that will fill each (sub)group type

  Scenario: View a node with many edges, all of which use node as predicate

