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


module NodesShowHelper
  def self_string_or_other_link(node_id)
    n = @node_hash[node_id]
    title = h filter_parenthetical n.title
    if node_id == @node.id    # self
      text_has_tip nil, title, h( n.name )
    else                      # other
      link_has_tip nil, title, node_path(n), h( n.name )
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

  def generate_node_links(n, not_in_use)
    if (n.flags & Node::DATA_IS_UNALTERABLE) == 0
      @edit_help_icon_used, fragment =
        a_help_link( link_to('Edit&hellip;', edit_node_path(n),
                     :rel => 'nofollow'),
          @edit_help_icon_used, 'Help edit node', 'NodeEdit' )
      concat( fragment )

      if not_in_use
        @delete_help_icon_used, fragment =
          a_help_link(
            link_to('Delete', node_path(n), :rel => 'nofollow',
                    :method => :delete, :confirm => 'Are you sure?'),
            @delete_help_icon_used, 'Help delete node', 'NodeDelete' )
        concat( fragment )
      end
    end
  end
end
