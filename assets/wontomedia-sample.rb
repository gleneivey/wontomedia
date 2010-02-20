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


require "ostruct"

WontoMedia = OpenStruct.new({
  :site_title => "",                           # last element in page <title>
  :site_tagline => "",                         # top of home page

    # change these if you use a local wiki, but will work to use public
  :help_url_prefix  => "http://wiki.wontology.org/wiki/help.php?title=",
  :popup_url_prefix => "http://wiki.wontology.org/wiki/popup.php?title=",

  :ads => OpenStruct.new({
#    :amazon => OpenStruct.new({
#      :associate_id => "your-amazon-id-here"
#    }),
#    :google => OpenStruct.new({
#      :publisher_id => "your-google-id-here",
#              # "data page" is used in the partial common/_google_ads,
#              # which is used in [items or connections]/[index or show] pages
#      :data_page_slot => "your-google-slot-number-here"
#              # create additional _slot variables for different Google ad units
#    })
  }),

  :analytics => OpenStruct.new({
#    :google => OpenStruct.new({
#      :profile_id => "your-UA-number-here"
#    })
  })
})
