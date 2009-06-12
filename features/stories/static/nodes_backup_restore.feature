Feature:  Download (for backup) and upload (for restore) all nodes in YAML
  In order to safeguard the content of a wontology,
  as an administrator, I want
  to be able to download and upload the system's nodes.

  @not_for_selenium
  Scenario: Download nodes.yml
    Given there are 3 existing items like "anItem"
    When I go to the path "/nodes.yaml"
    Then the response should contain 9 matches of "anItem"


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
