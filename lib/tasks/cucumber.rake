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


# Find vendored gem or plugin of cucumber
vendored_cucumber_dir =
  Dir["#{RAILS_ROOT}/vendor/{gems,plugins}/cucumber*"].first
$LOAD_PATH.unshift("#{vendored_cucumber_dir}/lib") unless
  vendored_cucumber_dir.nil?

unless ARGV.any? {|a| a =~ /^gems/}

begin
  require 'cucumber/rake/task'

  # Use vendored cucumber binary if possible. If it's not vendored,
  # Cucumber::Rake::Task will automatically use installed gem's cucumber binary
  vendored_cucumber_binary =
    "#{vendored_cucumber_dir}/bin/cucumber" unless vendored_cucumber_dir.nil?

  namespace :cucumber do
    Cucumber::Rake::Task.new({:static_ok => 'db:test:prepare'},
        'Run non-Selenium features that should pass') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = false
      t.profile = "static_acceptance"
    end

    Cucumber::Rake::Task.new({:dynamic_ok => 'db:test:prepare'},
        'Run need-Selenium-to-test features that should pass') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = false
      t.profile = "dynamic_acceptance"
    end

    Cucumber::Rake::Task.new({:static_wip => 'db:test:prepare'},
        'Run non-Selenium features that are being worked on') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = false
      t.profile = "static_unfinished"
    end

    Cucumber::Rake::Task.new({:dynamic_wip => 'db:test:prepare'},
        'Run need-Selenium-to-test features that are being worked on') do |t|
      t.binary = vendored_cucumber_binary
      t.fork = false
      t.profile = "dynamic_unfinished"
    end

    desc 'Run features that should pass'
    task :ok => [:static_ok, :dynamic_ok]
    desc 'Run features that are being worked on'
    task :wip => [:static_wip, :dynamic_wip]
    desc 'Run all features'
    task :all => [:ok, :wip]
  end

  desc 'Alias for cucumber:ok'
  task :cucumber => 'cucumber:ok'
  task :default => :cucumber

rescue LoadError
  desc 'cucumber rake task not available (cucumber not installed)'
  task :cucumber do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

end
