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


require Rails.root.join( 'app', 'helpers', 'format_helper' )
include(FormatHelper)

# Helpers for app/views/items/* pages
module ItemsHelper

  # This method is called with the _ID_ of an Item and returns markup
  # showing the +title+ string for that item which will show a
  # 'tooltip' with the Item's +name+ string on mouse-over.  If the
  # argument Item is the same as the Item for which the current view
  # is being generated (the output page's "self", <tt>@item</tt>),
  # then the +title+ will be displayed as simple text.  If the
  # argument Item is different from the page's item, then the +title+
  # will be displayed as a link to _that_ Item's +show+ page.
  def self_string_or_other_link(item_id)
    item = @item_hash[item_id]
    title = h filter_parenthetical item.title
    if item_id == @item.id    # self
      text_with_tooltip title, h( item.name )
    else                      # other
      link_with_tooltip title, h( item.name ), item_by_name_path(item.name)
    end
  end

  # When called, this helper adds to the current page the
  # open-<tt><table></tt> tag and table-heading cells for the table of
  # connection subject-predicate-object Items within the
  # <tt>app/views/items/show</tt> view.
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

  # When called, this helper adds to the current page the closing
  # <tt></table></tt> tag for the table of connection
  # subject-predicate-object Items within the
  # <tt>app/views/items/show</tt> view.
  def output_table_close
    concat('</table>')
  end

  # When called, this helper adds to the current page "Edit..." and
  # "Delete" links if they are appropriate for the Item instance
  # passed in.  Neither link is "appropriate" for Items flagged in the
  # database as <tt>Item::DATA_IS_UNALTERABLE</tt>.  In addition, the
  # "Delete" link will be output only if there are no existing
  # connections in the database which reference the +item+ (as
  # determined by the ItemsController and passed to the view in the
  # <tt>@not_in_use_hash</tt>).
  def generate_item_links(item)
    if (item.flags & Item::DATA_IS_UNALTERABLE) == 0
      concat(
        link_with_help_icon({
          :destination => link_to( 'Edit&hellip;',
            edit_item_by_name_path(item.name), :rel => 'nofollow'),
        :already_generated => @edit_help_icon_used,
        :help_alt => 'Help edit item',
        :which_help => 'ItemEdit' }) )
      @edit_help_icon_used = true

      if @not_in_use_hash[item.id]
        concat(
          link_with_help_icon({
            :destination => link_to( 'Delete', item_path(item),
              :rel => 'nofollow', :method => :delete,
              :confirm => 'Are you sure?'),
            :already_generated => @delete_help_icon_used,
            :help_alt => 'Help delete item',
            :which_help => 'ItemDelete' }) )
        @delete_help_icon_used = true
      end
    end
  end

  # produce an array of all the system's class items suitable for the
  # "options" argument to select_tag, sorted as follows:
  # * first:  no-selection option
  # * 2nd:  +@item+'s currently-selected class, if any
  # * non-built-in classes, sorted alphabetically
  # * built-in classes
  def class_options_list_for(item)
    option_array = [ [ "- class of item -", "" ] ]

    this_class_item = item.class_item
    unless this_class_item.nil?
      option_array.concat [[ h("#{this_class_item.name}"), this_class_item.id ]]
    end

    groups = @class_list.group_by do |item|
      if this_class_item && item.id == this_class_item.id
        :discard
      elsif (item.flags & Item::DATA_IS_UNALTERABLE) == 0
        :contributor
      else
        :builtin
      end
    end

    if groups[:contributor]
      option_array.concat(
        groups[:contributor].sort{ |a,b|
          a.name.upcase <=> b.name.upcase }.map{ |item|
            [ h("#{item.name}"), item.id ] } )
      option_array.concat [ [ "  ----", "" ] ]
    end

    if groups[:builtin]
      option_array.concat(
        groups[:builtin].sort{ |a,b|
          a.name <=> b.name }.map{ |item|
            [ h("#{item.name}"), item.id ] } )
    end

    options_for_select( option_array,
      this_class_item.nil? ? "" : this_class_item.id )
  end
end
