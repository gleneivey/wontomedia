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


module FormatHelper
  def filter_parenthetical(title_in)
    new = title_in
    begin
      title_out = new
      new = new.sub(/\s*\([^()]*\)/, "")
    end until new == title_out
    title_out
  end

  def wrap_item_name(name)
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

  def generate_connection_links(e)
    @show_help_icon_used, fragment =
      a_help_link( link_to( 'Show', connection_path(e) ),
        @show_help_icon_used, 'Help show connection', 'ConnectionShow' )
    concat( fragment )

    if (e.flags & Connection::DATA_IS_UNALTERABLE) == 0
      @edit_help_icon_used, fragment =
        a_help_link( link_to( 'Edit&hellip;', edit_connection_path(e),
            :rel => 'nofollow' ),
          @edit_help_icon_used, 'Help edit connection', 'ConnectionEdit' )
      concat( fragment )

      @delete_help_icon_used, fragment =
        a_help_link( link_to( 'Delete', connection_path(e), :rel => 'nofollow',
            :confirm => 'Are you sure?', :method => :delete ),
          @delete_help_icon_used, 'Help delete connection', 'ConnectionDelete' )
      concat( fragment )
    end
  end

  def popup_help_icon( alt, target )
    link_to(
      (
        image_tag( 'help_icon.png', :alt=>alt, :class=>'image-in-text' ) +
        '<span class="tip">Help</span>'
      ),
      WontoMedia.popup_url_prefix + target, :tabindex => '0',
      :class => 'iframeBox linkhastip' )
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

  def a_help_link( action_link, used_flag, help_alt, which_help )
    help_link = ''
    unless used_flag
      used_flag = true
      help_link = popup_help_icon help_alt, ("WmHelp:Popup/" + which_help)
    end
    return used_flag, ( content_tag( 'span', action_link + help_link,
                                     :style => "white-space: nowrap;" ) + " " )
  end
end
