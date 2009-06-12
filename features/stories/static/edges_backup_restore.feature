Feature:  Download (for backup) and upload (for restore) all edges in N3
  In order to safeguard the content of a wontology,
  as an administrator, I want
  to be able to download and upload the system's edges.

  @not_for_selenium
  Scenario: Download edges.n3
    Given there are 4 existing items like "item"
    And there is an existing edge "item1" "child_of" "item0"
    And there is an existing edge "item2" "child_of" "item1"
    And there is an existing edge "item3" "child_of" "item2"
    When I go to the path "/edges.n3"
    Then the response should contain 6 matches of "item"




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
