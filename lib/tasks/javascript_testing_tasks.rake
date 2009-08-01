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


#### This file originated from the same-named file in the Blue Ridge
#### package at GitHub http://github.com/relevance/blue-ridge/tree/master
#### as of the 8th of May, 2009.  It's original license notice is
#### below.  If you want to use this source without incurring the
#### requirements of the AGPL present on our changes, please go back
#### to this original and start from there.
#
# Copyright (c) 2008-2009 Relevance, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


plugin_prefix = "#{RAILS_ROOT}/vendor/plugins/blue-ridge"
rhino_command = "java -cp #{plugin_prefix}/lib/js.jar:#{plugin_prefix}/lib/mainForEnvjs.jar org.wontology.floss.rhino.envjs.EnvjsRhinoMain -w -debug"
test_runner_command = "#{rhino_command} #{plugin_prefix}/lib/test_runner.js"


# Support Test::Unit & Test/Spec style
namespace :test do
  desc "Runs all the JavaScript tests and outputs the results"
  task :javascripts do
    Dir.chdir("#{RAILS_ROOT}/test/javascript") do
      all_fine = true
      if ENV["TEST"]
        all_fine = false unless system("#{test_runner_command} #{ENV["TEST"]}_spec.js")
      else
        Dir.glob("**/*_spec.js").each do |file|
          all_fine = false unless system("#{test_runner_command} #{file}")
        end
      end
      raise "JavaScript test failures" unless all_fine
    end
  end
end


# use webrat's machinery for starting up a test server running our app
require 'webrat'
require 'webrat/selenium'
require 'webrat/selenium/selenium_session'

#require 'webrat/selenium/application_server_factory'   # github 6/18/09
require 'webrat/selenium/application_server'            # webrat 0.4.4

namespace :js do
  task :fixtures do
    link_root = "js-test-files"
    test_path = "test/javascript/fixtures"

    begin
      # Link the JavaScript test folder under /public to avoid "same
      # origin policy" (DEVELOPTMENT ONLY!).  Create an "index.html"
      # file listing JS test fixtures because Rails won't
      # automatically index accesses to directories under /public.
      # Start a test web server

      system("ln -s #{RAILS_ROOT} #{RAILS_ROOT}/public/#{link_root}")
      # don't need to "undo"--cleans up itself at_exit
#      Webrat::Selenium::ApplicationServerFactory.app_server_instance.boot#git
      Webrat::Selenium::ApplicationServer.boot#0.4.4

      fixture_dir = "http://localhost:3001/#{link_root}/#{test_path}/index.html"
      if PLATFORM[/darwin/]
        system("open #{fixture_dir}")
      elsif PLATFORM[/linux/]
        system("firefox #{fixture_dir}")
      else
        puts "You can run your in-browser fixtures from #{fixture_dir}."
      end
    ensure
      system("rm #{RAILS_ROOT}/public/#{link_root}")
    end
  end
  
  task :shell do
    rlwrap = `which rlwrap`.chomp
    system("#{rlwrap} #{rhino_command} -f #{plugin_prefix}/lib/shell.js -f -")
  end
end

