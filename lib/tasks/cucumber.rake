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

    Cucumber::Rake::Task.new(:basic_acceptance => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p basic_acceptance"
      t.feature_list = Dir.glob("features/**/basic/**/*.feature")
    end

    Cucumber::Rake::Task.new(:ajax_acceptance => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p ajax_acceptance"
      t.feature_list = Dir.glob("features/**/ajax/**/*.feature")
    end

    Cucumber::Rake::Task.new(:basic_unfinished => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p basic_unfinished"
      t.feature_list = Dir.glob("features/**/basic/**/*.feature")
    end

    Cucumber::Rake::Task.new(:ajax_unfinished => 'db:test:prepare') do |t|
      t.fork = true
      t.cucumber_opts = "-p ajax_unfinished"
      t.feature_list = Dir.glob("features/**/ajax/**/*.feature")
    end

    task :acceptance => [ "features:basic_acceptance",
                          "features:ajax_acceptance"   ]
    task :unfinished => [ "features:basic_unfinished",
                          "features:ajax_unfinished"   ]
  end

  task :features => [ "features:acceptance",
                      "features:unfinished"   ]

rescue LoadError
  puts "WARNING: Missing development dependency.  'Cucumber' not available. To install, see 'http://wiki.github.com/aslakhellesoy/cucumber/ruby-on-rails'"
end

