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



# so we can make sure the 'test' db is seeded before tests run
require File.join( RAILS_ROOT, 'test', 'seed_helper' )


begin   # don't force Blue Ridge dependency on non-developers

  plugin_prefix = "#{RAILS_ROOT}/vendor/plugins/blue-ridge"
  require File.join(plugin_prefix, "lib", "blue_ridge")

  rhino_command = "java -Dblue.ridge.prefix=\"#{plugin_prefix}\" " +
                      " -jar #{plugin_prefix}/lib/env-js.jar -w -debug"
  test_runner_command = "#{rhino_command} #{plugin_prefix}/lib/test_runner.js"


  @link_root = "js-test-files"
  @test_path = "test/javascript/fixtures"


  # Support Test::Unit & Test/Spec style
  namespace :test do
    desc "Runs all the JavaScript tests and outputs the results."
    task :javascripts => :environment do
      Dir.chdir("#{RAILS_ROOT}/test/javascript") do
        all_fine = true

        begin
          load_wontomedia_app_seed_data
          setup_for_js_testing

          if ENV["TEST"]
            all_fine = false unless
              system "#{test_runner_command} #{ENV["TEST"]}_spec.js"
          else
            Dir.glob("**/*_spec.js").each do |file|
              all_fine = false unless system "#{test_runner_command} #{file}"
            end
          end
        ensure
          cleanup_after_js_testing
        end

        raise "JavaScript test failures" unless all_fine
      end
    end
  end


  namespace :js do
    task :fixtures => :environment do
      begin
        load_wontomedia_app_seed_data
        setup_for_js_testing

        ENV["BLUERIDGE_PREFIX"] = "http://localhost:3001/#{@link_root}"
        js_spec_dir = BlueRidge.find_javascript_spec_dir
        fixture_path = BlueRidge.generateSpecIndexFile(js_spec_dir)

        if PLATFORM[/darwin/]
          system "open #{fixture_path}"
        elsif PLATFORM[/linux/]
          system "firefox #{fixture_path}"
        end
      ensure
        cleanup_after_js_testing
      end
    end

    task :shell do
      rlwrap = `which rlwrap`.chomp
      system "#{rlwrap} #{rhino_command} -f #{plugin_prefix}/lib/shell.js -f -"
    end
  end


  private


  # use webrat's machinery for starting up a test server running our app
  require 'webrat'
  require 'webrat/selenium/application_servers/rails'

  def setup_for_js_testing
    # Link the JavaScript test folder under /public to avoid "same
    # origin policy" (DEVELOPTMENT ONLY!).
    system "ln -s #{RAILS_ROOT} #{RAILS_ROOT}/public/#{@link_root}"

    # Start a test web server.  (Note, originally tried the Webrat::Selenium
    # classes to do this, but found that their automatically calling
    # server stop() at_exit caused Rake to fail when multiple attempts
    # to stop the same server occurred.  Making ApplicationServer.start()
    # and .stop() internally veryify the absence/presence of the Mongrel
    # pid also solved the problem, but I didn't want to have to patch Webrat.

    system "mongrel_rails start -d --chdir='#{RAILS_ROOT}' " +
           "--port=#{Webrat.configuration.application_port} " +
           "--environment=#{Webrat.configuration.application_environment} " +
           "--pid #{Webrat::Selenium::ApplicationServers::Rails.new.pid_file} &"
  end

  def cleanup_after_js_testing
    STDOUT.puts                    # Blue Ridge doesn't put a \n after last "."
    system "rm #{RAILS_ROOT}/public/#{@link_root}"
    silence_stream(STDOUT) do
      system "mongrel_rails stop -c #{RAILS_ROOT} " +
             "--pid #{Webrat::Selenium::ApplicationServers::Rails.new.pid_file}"
    end
  end

rescue LoadError
  puts "WARNING: Missing development dependency.  'Blue Ridge', 'Webrat', or a dependency not available. To install, see 'http://wiki.wontology.org/SettingUpYourDevelopmentEnvironment'"
end

