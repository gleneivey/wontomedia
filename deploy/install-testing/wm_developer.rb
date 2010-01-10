#!/usr/bin/ruby

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


#apt_load_options = "--no-download"
apt_load_options = ""


def exc(cmd)
  puts cmd
  `#{cmd}`
  exit $?.exitstatus if $?.exitstatus != 0
end

exc "apt-get -y #{apt_load_options} install libxml2-dev libxslt1-dev"


      # don't get stuck on accepting-the-license dialog
if `grep sun-dlj /var/cache/debconf/config.dat` =~ /\S/
  exc "sed --in-place=.backup " +
        " -e '/^Template: shared\\/accepted-sun-dlj-v1-1/aValue: true' " +
        " -e '/^Template: shared\\/accepted-sun-dlj-v1-1/aFlags: seen' " +
        "/var/cache/debconf/config.dat"
else
  fileSnipet = <<FILESNIPET

Name: shared/accepted-sun-dlj-v1-1
Template: shared/accepted-sun-dlj-v1-1
Value: true
Owners: sun-java6-bin, sun-java6-jre
Flags: seen

FILESNIPET
  File.open("/var/cache/debconf/config.dat", "a") do |debconf|
    debconf.puts fileSnipet
  end
end
exc "apt-get -y #{apt_load_options} install sun-java6-bin sun-java6-jre java-common rhino"


exc "gem1.8 install nokogiri"
exc "gem1.8 install rspec rspec-rails webrat cucumber"
exc "gem1.8 install rubyforge technicalpickles-jeweler ZenTest"
exc "gem1.8 install migration_test_helper selenium-client mongrel"

exc "ln -s /usr/lib/firefox-3.0.11/firefox /usr/bin/firefox-bin"

puts "If you want autotest to execute Cucumber tests, remember to add 'export AUTOFEATURE=\"true autospec\"' to the bottom of your .bashrc file (or the equivalent for your shell)."
puts "Don't forget to run 'rake db:reseed' (for a new installation) prior to starting development."

