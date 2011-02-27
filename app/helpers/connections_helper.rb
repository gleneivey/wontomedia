#--
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
#++


# Helpers for app/views/connections/* pages
module ConnectionsHelper

  # This method appends its output directly to the page being built.
  # It takes a Connection model instance, and generates a set of HTML
  # links to that connection.  It generates a "Show" link to the
  # Connection's <tt>connections/show</tt> page.  Unless the
  # Connection is flagged as <tt>DATA_IS_UNALTERABLE</tt>, it also
  # generates an "Edit..." link to +con+'s <tt>connections/edit</tt>
  # page and a "Delete" link that will invoke
  # <tt>connections/destroy</tt>.  The links are generated with a
  # "help" icon linking to a popup (see
  # FormatHelper.link_with_help_icon) _if_ the link being generated is
  # the first occurrance of that link in the current view.  An instance
  # variable is created within the current view object to flag the
  # generation of each type of link.
  def generate_connection_links(con, after_delete = nil)
    concat(
      link_with_help_icon({
        :destination => link_to( 'Show', connection_path(con) ),
        :already_generated => @show_help_icon_used,
        :help_alt => 'Help show connection',
        :which_help => 'ConnectionShow' }) )
    @show_help_icon_used = true

    if (con.flags & Connection::DATA_IS_UNALTERABLE) == 0
      concat(
        link_with_help_icon({
          :destination => link_to(
            'Edit&hellip;', edit_connection_path(con), :rel => 'nofollow' ),
          :already_generated => @edit_help_icon_used,
          :help_alt => 'Help edit connection',
          :which_help => 'ConnectionEdit' }) )
      @edit_help_icon_used = true

      goto_param = after_delete ? '?goto='+after_delete : ''
      concat(
        link_with_help_icon({
          :destination => link_to(
            'Delete', connection_path(con)+goto_param, :rel => 'nofollow',
            :confirm => 'Are you sure?', :method => :delete ),
          :already_generated => @delete_help_icon_used,
          :help_alt => 'Help delete connection',
          :which_help =>'ConnectionDelete' }) )
      @delete_help_icon_used = true
    end
  end

  # This method appends its output directly to the page being built.
  # It takes a Connection model instance and creates an HTML link to
  # that connection.  It should be used as an alternative to
  # "generate_connection_links()" for those cases where instead of
  # generating links to the Connection the user is looking at, we're
  # generating a link to the Connection that _implied_ whatever the
  # user is looking at.  A popup help icon will be added on the first
  # call to generate_inverse_link for a particular page.
  def generate_inverse_link(con)
    concat(
      link_with_help_icon({
        :destination => link_to( 'View source', connection_path(con) ),
        :already_generated => @viewsource_help_icon_used,
        :help_alt => 'Help view source',
        :which_help =>'ConnectionViewSource' }) )
    @viewsource_help_icon_used = true
  end
end
