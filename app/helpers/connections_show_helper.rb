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


module ConnectionsShowHelper
  def generate_connection_links(e)
    @show_help_icon_used, fragment =
      a_help_link( '', link_to( 'Show', connection_path(e) ),
        @show_help_icon_used, 'Help show connection', 'ConnectionShow' )
    concat( fragment )

    if (e.flags & Connection::DATA_IS_UNALTERABLE) == 0
      @edit_help_icon_used, fragment =
        a_help_link( '', link_to( 'Edit&hellip;', edit_connection_path(e),
            :rel => 'nofollow' ),
          @edit_help_icon_used, 'Help edit connection', 'ConnectionEdit' )
      concat( fragment )

      @delete_help_icon_used, fragment =
        a_help_link( '', link_to( 'Delete', connection_path(e),
            :rel => 'nofollow', :confirm => 'Are you sure?',
            :method => :delete ),
          @delete_help_icon_used, 'Help delete connection', 'ConnectionDelete' )
      concat( fragment )
    end
  end
end
