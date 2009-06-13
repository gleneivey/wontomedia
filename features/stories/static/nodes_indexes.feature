Feature:  Show existing ontology information in app home and index pages
  In order to work with a wontology,
  as a contributor, I want
  to be able to view lists of the wontologies current contents


  Scenario: Homepage doesn't show property nodes
    When I go to "the homepage"
    Then I should see 0 matches of "peer_of" in "body"
    And I should see 0 matches of "value_relationship" in "body"


  Scenario: Homepage shows list of existing nodes
    Given there are 2 existing classes like "kirgagh0"
    Given there are 3 existing items like "kirgagh1"
    Given there are 4 existing properties like "kirgagh2"
    Given there are 1 existing reiffied-properties like "kirgagh3"
    When I go to "the homepage"
      # three instances each of strings for "class" and "item", none for others
    Then I should see 15 matches of "kirgagh" in "td"


  Scenario: Node index shows property nodes
    When I go to the index nodes page
    Then I should see 1 match of "one_of" in "body"
    Then I should see 1 match of "symmetric_relationship" in "body"


  Scenario: View index of existing nodes
    Given there are 5 existing classes like "fufubarfu0"
    Given there are 3 existing items like "fufubarfu1"
    Given there are 4 existing properties like "fufubarfu2"
    Given there are 1 existing reiffied-properties like "fufubarfu3"
    When I go to the index nodes page
      # three instances of string for each node created
    Then I should see 39 matches of "fufubarfu" in "td"



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
