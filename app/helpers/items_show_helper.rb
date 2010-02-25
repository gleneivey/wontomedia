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


require Rails.root.join( 'app', 'helpers', 'format_helper' )
include(FormatHelper)

module ItemsShowHelper
  def self_string_or_other_link(item_id)
    n = @item_hash[item_id]
    title = h filter_parenthetical n.title
    if item_id == @item.id    # self
      text_with_tooltip title, h( n.name )
    else                      # other
      link_with_tooltip title, h( n.name ), item_path(n)
    end
  end

  def output_table_open
    header_style = 'display: block; position: relative;'
    concat(tag 'table', nil, true)  # generate an "open" table tag
    concat(content_tag( 'thead',
      content_tag( 'tr',
        content_tag( 'th', '' ) +
        content_tag( 'th',
          content_tag( 'span', '<em>is</em> or <em>has</em>',
            :style => "#{header_style} left: -3em;" )) +
        content_tag( 'th',
          content_tag( 'span', '<em>to</em> or <em>with</em>',
            :style => "#{header_style} left: -1em;" ))
      )
    ))
  end

  def output_table_close
    concat('</table>')
  end

  def generate_item_links(n, not_in_use)
    if (n.flags & Item::DATA_IS_UNALTERABLE) == 0
      concat(
        link_with_help_icon({
          :destination => link_to( 'Edit&hellip;', edit_item_path(n),
            :rel => 'nofollow'),
        :already_generated => @edit_help_icon_used,
        :help_alt => 'Help edit item',
        :which_help => 'ItemEdit' }) )
      @edit_help_icon_used = true

      if not_in_use
        concat(
          link_with_help_icon({
            :destination => link_to( 'Delete', item_path(n), :rel => 'nofollow',
              :method => :delete, :confirm => 'Are you sure?'),
            :already_generated => @delete_help_icon_used,
            :help_alt => 'Help delete item',
            :which_help => 'ItemDelete' }) )
        @delete_help_icon_used = true
      end
    end
  end
end
