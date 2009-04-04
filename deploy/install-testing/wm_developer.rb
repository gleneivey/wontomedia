#!/usr/bin/ruby

# WontoMedia - a wontology web application
# Copyright (C) 2009 - Glen E. Ivey
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
  exit $?.exitstatus if $?.exitstatus != 0
end

exc "apt-get -y #{apt_load_options} install libxml2-dev libxslt1-dev"
exc "gem1.8 install nokogiri"
exc "gem1.8 install rspec rspec-rails webrat cucumber"
exc "gem1.8 install rubyforge technicalpickles-jeweler ZenTest"


puts "If you want autotest to execute Cucumber tests, remember to add 'export AUTOFEATURE=\"true autospec\"' to the bottom of your .bashrc file (or the equivalent for your shell)."
puts "Don't forget to run 'rake db:schema:load' prior to starting development."

