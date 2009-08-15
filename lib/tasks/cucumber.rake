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


begin    # don't force Cucumber dependency on non-developers
  $LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if
    File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
  require 'cucumber/rake/task'

  namespace :features do

    # note, real definitions of what these tasks do left to option profiles
    # defined in wontomedia/cucumber.yml

    Cucumber::Rake::Task.new(:static_acceptance => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p static_acceptance"
      t.feature_list = Dir.glob("features/**/static/**/*.feature")
    end

    Cucumber::Rake::Task.new(:dynamic_acceptance => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p dynamic_acceptance"
      t.feature_list = Dir.glob("features/**/dynamic/**/*.feature")
    end

    Cucumber::Rake::Task.new(:static_unfinished => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p static_unfinished"
      t.feature_list = Dir.glob("features/**/static/**/*.feature")
    end

    Cucumber::Rake::Task.new(:dynamic_unfinished => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p dynamic_unfinished"
      t.feature_list = Dir.glob("features/**/dynamic/**/*.feature")
    end

    Cucumber::Rake::Task.new(:selenium => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p selenium"
      t.feature_list = Dir.glob("features/**/*.feature")
    end

    task :acceptance => [ "features:static_acceptance",
                          "features:dynamic_acceptance"   ]
    task :unfinished => [ "features:static_unfinished",
                          "features:dynamic_unfinished"   ]
    task :static     => [ "features:static_acceptance",
                          "features:static_unfinished"   ]
    task :dynamic    => [ "features:dynamic_acceptance",
                          "features:dynamic_unfinished"   ]
  end

  task :features => [ "features:acceptance",
                      "features:unfinished"   ]

rescue LoadError
  puts "WARNING: Missing development dependency.  'Cucumber' not available. To install, see 'http://wiki.github.com/aslakhellesoy/cucumber/ruby-on-rails'"
end

