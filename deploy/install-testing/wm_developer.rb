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

selenium_ver = "1.0.1"
selenium_dir = "selenium-remote-control-#{selenium_ver}"
unless File.exist?("#{selenium_dir}-dist.zip")
  exc "wget http://release.seleniumhq.org/selenium-remote-control/" +
    "#{selenium_ver}/#{selenium_dir}-dist.zip"
end
exc "unzip -o #{selenium_dir}-dist.zip"

exc "apt-get -y #{apt_load_options} install libxml2-dev libxslt1-dev"


      # don't get stuck on accepting the license dialog
exc "sed --in-place=.backup " +
      " -e '/^Template: shared\\/accepted-sun-dlj-v1-1/aValue: true' " +
      " -e '/^Template: shared\\/accepted-sun-dlj-v1-1/aFlags: seen' " +
      "/var/cache/debconf/config.dat"
exc "apt-get -y #{apt_load_options} install sun-java6-bin sun-java6-jre java-common rhino"


exc "gem1.8 install nokogiri"
exc "gem1.8 install rspec rspec-rails webrat cucumber"
exc "gem1.8 install rubyforge technicalpickles-jeweler ZenTest"
exc "gem1.8 install migration_test_helper Selenium selenium-client mongrel"

gems_dir = "/usr/lib/ruby/gems/1.8/gems"
exc "cp #{selenium_dir}/selenium-server-#{selenium_ver}/selenium-server.jar " +
      "#{gems_dir}/webrat-0.4.4/vendor"
exc "cp #{selenium_dir}/selenium-server-#{selenium_ver}/selenium-server.jar " +
      "#{gems_dir}/Selenium-1.1.14/lib/selenium/openqa/selenium-server.jar.txt"
exc "ln -s /usr/lib/firefox-3.0.11/firefox /usr/bin/firefox-bin"

puts "If you want autotest to execute Cucumber tests, remember to add 'export AUTOFEATURE=\"true autospec\"' to the bottom of your .bashrc file (or the equivalent for your shell)."
puts "Don't forget to run 'rake db:reseed' prior to starting development."

