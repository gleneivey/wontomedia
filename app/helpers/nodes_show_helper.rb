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
  def filter_parenthetical(title_in)
    new = title_in
    begin
      title_out = new
      new = new.sub(/\s*\([^()]*\)/, "")
    end until new == title_out
    title_out
  end

  def self_string_or_other_link(node_id)
    n = @node_hash[node_id]
    title = h filter_parenthetical n.title
    if node_id == @node.id    # self
      title
    else                      # other
      link_to title, node_path(n)
    end
  end

  def output_table_open
    header_style = 'display: block; position: relative; left: -2em;'
    concat(tag 'table', nil, true)  # generate an "open" table tag
    concat(content_tag( 'thead',
      content_tag( 'tr',
        content_tag( 'th', '' ) +
        content_tag( 'th',
          content_tag( 'span', '<em>is</em> or <em>has</em>',
            :style => header_style )) +
        content_tag( 'th',
          content_tag( 'span', '<em>to</em> or <em>with</em>',
            :style => header_style ))
      )
    ))
  end

  def output_table_close
    concat('</table>')
  end

  def generate_edge_links(e)
    @show_help_icon_used, fragment =
      an_edge_link( link_to('Show', edge_path(e)),
        @show_help_icon_used, 'Help show edge', 'EdgeShow' )
    concat( fragment )

    if (e.flags & Edge::DATA_IS_UNALTERABLE) == 0
      @edit_help_icon_used, fragment =
        an_edge_link( link_to('Edit', edit_edge_path(e), :rel => 'nofollow'),
          @edit_help_icon_used, 'Help edit edge', 'EdgeEdit' )
      concat( fragment )

      @delete_help_icon_used, fragment =
        an_edge_link(
          link_to('Delete', edge_path(e), :rel => 'nofollow',
                  :method => :delete, :confirm => 'Are you sure?'),
          @delete_help_icon_used, 'Help delete edge', 'EdgeDelete' )
      concat( fragment )
    end
  end

  def an_edge_link( action_link, used_flag, help_alt, which_help )
    help_link = ''
    unless used_flag
      used_flag = true
      help_link = content_tag( 'a', image_tag(
          "help_icon.png", :alt=>help_alt, :class=>"image-in-text" ),
        :href => WontoMedia.popup_url_prefix + "WmHelp:Popup/" + which_help,
        :class => "iframeBox", :tabindex => "0" )
    end
    return used_flag, ( content_tag( 'span', action_link + help_link,
                                     :style => "white-space: nowrap;" ) + " " )
  end
end
