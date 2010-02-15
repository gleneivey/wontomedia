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

  def wrap_node_name(name)
    len = 30
    wrapped = ''
    [ len, len*2, len*3, len*4 ].each do |wrap_at|
      wrapped += name[wrap_at - len, len].to_s
      if name.length > wrap_at
        wrapped += '<span class="wrapper"> &gt;&gt;&gt;</span><br />'
      end
    end
    wrapped
  end

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

  def generate_edge_links(e)
    @show_help_icon_used, fragment =
      a_help_link( link_to('Show', edge_path(e)),
        @show_help_icon_used, 'Help show edge', 'EdgeShow' )
    concat( fragment )

    if (e.flags & Edge::DATA_IS_UNALTERABLE) == 0
      @edit_help_icon_used, fragment =
        a_help_link( link_to('Edit', edit_edge_path(e), :rel => 'nofollow'),
          @edit_help_icon_used, 'Help edit edge', 'EdgeEdit' )
      concat( fragment )

      @delete_help_icon_used, fragment =
        a_help_link(
          link_to('Delete', edge_path(e), :rel => 'nofollow',
                  :method => :delete, :confirm => 'Are you sure?'),
          @delete_help_icon_used, 'Help delete edge', 'EdgeDelete' )
      concat( fragment )
    end
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

  def generate_edge_links(e)
    @show_help_icon_used, fragment =
      a_help_link( link_to( 'Show', edge_path(e) ),
        @show_help_icon_used, 'Help show edge', 'EdgeShow' )
    concat( fragment )

    if (e.flags & Edge::DATA_IS_UNALTERABLE) == 0
      @edit_help_icon_used, fragment =
        a_help_link( link_to( 'Edit&hellip;', edit_edge_path(e) ),
          @edit_help_icon_used, 'Help edit edge', 'EdgeEdit' )
      concat( fragment )

      @delete_help_icon_used, fragment =
        a_help_link( link_to( 'Delete', edge_path(e), :rel => 'nofollow',
                    :confirm => 'Are you sure?', :method => :delete ),
          @delete_help_icon_used, 'Help delete edge', 'EdgeDelete' )
      concat( fragment )
    end
  end

  def a_help_link( action_link, used_flag, help_alt, which_help )
    help_link = ''
    unless used_flag
      used_flag = true
      help_link = popup_help_icon help_alt, ("WmHelp:Popup/" + which_help)
    end
    return used_flag, ( content_tag( 'span', action_link + help_link,
                                     :style => "white-space: nowrap;" ) + " " )
  end

  def popup_help_icon( alt, target )
    link_to( image_tag( 'help_icon.png', :alt=>alt, :class=>'image-in-text' ),
      WontoMedia.popup_url_prefix + target, :tabindex => '0',
      :class => 'iframeBox' )
  end

  def text_has_tip( id, text, tip )
    span = id.nil? ? '<span>' : "<span id='#{id}'>"
    inner = "#{span}#{text}</span>" +
            "<span class='tip' style='white-space: nowrap;'>#{tip}</span>"
    link_to inner, "#", :class=>'texthastip', :tabindex=>'0'
  end

  def link_has_tip( id, text, href, tip )
    span = id.nil? ? '<span>' : "<span id='#{id}'>"
    inner = "#{span}#{text}</span>" +
            "<span class='tip' style='white-space: nowrap;'>#{tip}</span>"
    link_to inner, href, :class=>'linkhastip', :tabindex=>'0'
  end
end
