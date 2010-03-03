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


# This module contains a collection of page- and model-independent
# formatting methods.  All return a string suitable for including
# directly in a page.
module FormatHelper

  # This method takes in a string, and returns a version of it
  # excluding any sub-strings enclosed in parentheticals.  Nested and
  # multiple parentheticals are supported.  This method is intended to
  # support the WontoMedia behavior where sometimes an Item.title
  # string is displayed in its entirety, and sometimes it is
  # abbreviated (for space) by stripping any parentheticals it contains.
  def filter_parenthetical(title_in)
    local_copy = title_in
    begin
      title_out = local_copy
      local_copy = local_copy.sub(/\s*\([^()]*\)/, "")
    end until local_copy == title_out
    title_out
  end

  # This method is used to wrap long strings that don't contain spaces
  # (which would allow the browser to wrap them), such as an
  # <tt>Item.name</tt> string.  The +len+ parameter is a length in
  # _characters_, and the default is tuned to produce reasonably good
  # results in the table in the items/index page.  The return value is
  # an HTML snippet including a marker to indicate that wrapping has
  # occurred.
  #--
  # TODO: It would be better if wrapping were done
  # dynamically in JavaScript as the page is resized, as sometimes
  # wrapping the string statically doesn't produce a really great
  # result.  Of course, to really do it right, we'd rewrap any time
  # the page width is adjusted, and use the actual width of the text
  # (rather than character count) as the basis for wrapping.
  def wrap_item_name(name, len = 30)
    wrapped = ''
    [ len, len*2, len*3, len*4 ].each do |wrap_at|
      wrapped += name[wrap_at - len, len].to_s
      if name.length > wrap_at
        wrapped += '<span class="wrapper"> &gt;&gt;&gt;</span><br />'
      end
    end
    wrapped
  end

  # This method generates an HTML snipet for an icon that will cause a
  # pop-up help box to be displayed when clicked.  This helper is tied
  # very tightly to WontoMedia's style sheet, included JavaScript
  # libraries, and image assets.  The parameters are used as follows:
  #
  # [alt] This string is used as the 'alt' attribute for the <img> tag that is generated, and allows each help image/link generated by this helper to have unique alt text that describes the kind of help the link points to.
  # [target] This string specifies the source of the help page that should be rendered into the popup <iframe>.  A complete URL is created by appending the value of +target+ to the configuration value <tt>WontoMedia.popup_url_prefix</tt> from the file <tt>config/initializers/wontomedia.rb</tt>.
  # [text] The content of this string, if any, is placed immediately _before_ the popup help icon (the <img> tag) that this helper generates.  This text is not part of the link that will cause the help popup to be opened.  When present, the value is packaged along with the help icon in a <span> with the <tt>nowrap</tt> style.  This will prevent the browser from separating the help icon from the label that precedes it due to text wrapping.  If this argument is <tt>nil</tt>, then no span is generated.  An empty string will produce a span with no content aside from the generated link.
  def popup_help_icon( alt, target, text = nil )
    content = ''
    if text
      content += '<span style="white-space: nowrap;">' + text
    end
    content += link_to(
      (
        image_tag( 'help_icon.png', :alt=>alt, :class=>'image-in-text' ) +
        '<span class="tip">Help</span>'
      ),
      WontoMedia.popup_url_prefix + target, :tabindex => '0',
      :class => 'iframeBox linkhastip' )
    if text
      content += '</span>'
    end
    content
  end

  # This method wraps a block of text in HTML markup that provides it
  # with a (CSS-based) 'tooltip'-like popup on mouse-over.  The
  # arguments are:
  #
  # [text] The text string to wrap and make sensitive to mouse-over.  It may contain additional HTML markup, but cannot contain outbound links (e.g., <tt><a href=...></tt>).
  # [tip] The content for the popup 'tooltip'.  This may also contain HTML markup, but links should be avoided because of both usability considerations (moving the mouse within the tooltip can be challenging because it could go away if the cursors path strays outside the union of the text's and tip's bounding boxes) and the fact that some browsers will confuse links in the tooltip with the dummy link tag that this helper creates.
  # [id] This helper creates a <tt><span></tt> tag around the supplied +text+.  If +id+ is non-+nil+, its value will be used to create an +id+ attribute for the span.
  def text_with_tooltip( text, tip, id = nil )
    span = id.nil? ? '<span>' : "<span id='#{id}'>"
    inner = "#{span}#{text}</span>" +
      "<span class='tip'>#{tip}</span>"
    link_to inner, "#", :class=>'texthastip', :tabindex=>'0'
  end

  # This method creates a link wraped in HTML markup that provides it
  # with a (CSS-based) 'tooltip'-like popup on mouse-over.  The
  # arguments are:
  #
  # [text] The content for the link (anchor tag) generated.  It may be any HTML string that would be valid within a link.
  # [tip] The content for the popup 'tooltip'.  This may also contain HTML markup, but links should be avoided because of both usability considerations (moving the mouse within the tooltip can be challenging because it could go away if the cursors path strays outside the union of the text's and tip's bounding boxes) and the fact that some browsers will confuse links in the tooltip with the link that causes the tooltip to be displayed.
  # [href] The value of this argument will be used to generate the +href+ attribute of the link created.  It is passed directly to Rails' <tt>link_to</tt> helper, so any string, or Rails object or route that can be converted to a URL can be used.
  # [id] This helper creates a <tt><span></tt> tag around the content of the +text+ argument.  If +id+ is non-+nil+, its value will be used to create an +id+ attribute for the span.
  def link_with_tooltip( text, tip, href, id = nil )
    span = id.nil? ? '<span>' : "<span id='#{id}'>"
    inner = "#{span}#{text}</span>" +
      "<span class='tip'>#{tip}</span>"
    link_to inner, href, :class=>'linkhastip', :tabindex=>'0'
  end

  # This helper constructs a text link optionally followed by an image
  # link which, when clicked, will open a popup box in the window
  # populated by a page from the installation's help wiki.  The markup
  # generated ensures that word-wrap in the browser will not separate
  # the help icon from the link that precedes it.  The helper's
  # parameters are packaged in a single hash argument.  The symbols
  # used to index the argument hash are:
  #
  # [:destination] The value in the hash associated with <tt>:destination</tt> should be a complete HTML link, such as the return value from the Rails' helper <tt>link_to</tt>.
  # [:already_generated] The value in the hash associated with <tt>:already_generated</tt> will be evaluated as a boolean to determine whether a popup help icon (image link) should be generated by this call to link_with_help_icon.  When it evaluates to false/nil (including simply not being present in the argument hash at all), HTML for a help icon _is_ generated/returned.
  # [:help_alt] The string in the hash associated with <tt>:help_alt</tt> will be used as the value for the +alt+ attribute of the anchor tag for the help icon/link (if generated).  (The +alt+ tag, if any, for <tt>:destination</tt> should be incorporated in the link's markup before it is passed to this helper.)
  # [:which_help] The string in the hash associated with <tt>:which_help</tt> is used as a component in the URL to the desired page from the installation's help wiki.  It is combined with the installation's popup_url_prefix configuration value (see popup_help_icon) after being prefixed with <tt>Help:Popup/</tt>.  That is, this helper assumes that within the help wiki, the content for all help displayed in a popup box in the page is stored as a <em>sub-page</em> of the help wiki's page +Popup+ within the wiki's namespace +Help+.
  # [:text] The _optional_ value in the hash associated with <tt>:text</tt> will, if present, be included in the generated HTML between the content of <tt>:destination</tt> and the generated help icon.  See the +text+ argument to popup_help_icon.
  def link_with_help_icon( params )
    help_link = ''
    unless params[:already_generated]
      unless params.has_key?(:help_alt)
        raise ArgumentError, "Missing :help_alt entry from parameter hash"
      end
      unless params.has_key?(:which_help)
        raise ArgumentError, "Missing :which_help entry from parameter hash"
      end

      help_link = popup_help_icon params[:help_alt],
        ("Help:Popup/" + params[:which_help]), params[:text]
    end

    unless params.has_key?(:destination)
      raise ArgumentError, "Missing :destination entry from parameter hash"
    end
    return content_tag( 'span', params[:destination] + help_link,
      :style => "white-space: nowrap;" ) + " "
  end

  def logo_image
    logo_name = (File.exists?(
      Rails.root.join( 'public', 'images', 'logo.jpg'))) ?
        '/images/logo.jpg' :
        '/images/logo.png'
    image_tag( logo_name, :alt=>'Logo', :width=>'99%',
      :style=>'margin-bottom: 0.7ex;' )
  end
end
