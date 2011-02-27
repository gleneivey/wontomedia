#!/usr/bin/ruby

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


#apt_load_options = "--no-download"
apt_load_options = ""

def exc(cmd)
  puts cmd
  `#{cmd}`
end


          # get rid of the gem-installed version of WontoMedia, so
          # we don't bump into it running from our Git repository
exc "gem1.8 uninstall wontomedia"

          # need to install Git so we can use it to install WontoMedia
exc "apt-get -y #{apt_load_options} install git-core"
exit $?.exitstatus if $?.exitstatus != 0
