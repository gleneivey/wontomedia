#--
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
#++


# This module provides a container for methods that manipulate or
# transform Connection objects.
module ConnectionHelper

  # This method renders a multi-line string in the 'n3' format (aka
  # 'Notation3' standardized by the W3C, see
  # http://en.wikipedia.org/wiki/Notation3 for an introduction) from
  # an array of Connection models.
  #
  # This is currently a trivial but correct implementation.  It supports
  # our current data model, but will need a significant upgrade when
  # WontoMedia begins to support reiffied edges (blank nodes), etc.
  def self.connection_array_to_n3(connections)
    result = ""
    connections.each do |connection|
      result << "<##{connection.subject.name}> <##{connection.predicate.name}> "
      if connection.kind_of_obj == Connection::OBJECT_KIND_ITEM
        result << "<##{connection.obj.name}> .\n"
      else
        result << "\"#{connection.scalar_obj}\" .\n"
      end
    end
    result
  end
end
