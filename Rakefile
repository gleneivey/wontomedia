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


have_jeweler = false
begin
  require 'rubygems'
  require 'jeweler'
  have_jeweler = true
rescue LoadError
  unless ENV['NO_RAKE_WARN']
    puts <<-MESSAGE

WARNING: Missing development dependency(ies):
  'Jeweler', and/or 'rubygems' are not available.

Install an individual missing gem with:
    'sudo gem install [gem name]'
('sudo' may not be necessary on your system)

Or install all of Wontomedia's development dependencies with:
    'bundle install'
    MESSAGE
  end
end



require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

if ENV["RAILS_ENV"].nil?
  ENV["RAILS_ENV"] = RAILS_ENV = "test"
end



        ############################################################
        # block to use Jeweler to generate our gemspec, gem, etc.
if have_jeweler
  Jeweler::Tasks.new do |s|
    s.name = "wontomedia"
    s.rubyforge_project = "wontomedia"
    s.summary = "WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme"
    s.description = <<-ENDOSTRING
      WontoMedia is a Ruby-on-Rails web app for community creation of
      an information classification scheme.  WontoMedia is free
      software (licensed under the AGPL v3), and is being developed by
      a dispersed volunteer team using agile methods.
ENDOSTRING

    s.email = "gleneivey@wontology.org"
    s.homepage = "http://wontomedia.rubyforge.org"
    s.authors = ["Glen E. Ivey"]

    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]

    s.files =  FileList["[A-Z]*", "assets/wontomedia-sample.rb",
      "vendor/plugins/asset_packager/**/*",
      "vendor/plugins/redirect_routing/**/*",
      "wontomedia.gemspec",
      "doc/*", "doc/scripts/*",
      "{app,config,bin,db,default-custom,generators,lib,public,script}/**/*"].
          exclude("database.yml", "**/*_packaged.js", "**/*_packaged.css") do |maybe_exclude|
            File.symlink?( maybe_exclude )
          end
    s.test_files = []
    # Note: 1) Explicitly add any other non-testing packages under 'vendor'
    # 2) Exclude all of our symbolic links
    # 3)
    #     .autotest cucumber.yml .gitignore
    # the testing directories
    #     deploy doc features policy test
    # and the working/transitory directories
    #     log pkg tmp
    # aren't included because developers are expected to pull from Git

    s.required_ruby_version = '~>1.8.7'
    s.add_dependency 'rake', '=0.8.7'
    s.add_dependency 'rails', '=2.3.11'

      # eventually move to an optional group for people who don't deploy this way
    s.add_dependency 'mysql', '=2.8.1'
    s.add_dependency 'mongrel'

    s.add_development_dependency 'bundler'
    s.add_development_dependency 'capistrano'
    s.add_development_dependency 'rspec-rails', '=1.3.3'     # gets rspec
    s.add_development_dependency 'webrat'
    s.add_development_dependency 'cucumber', '=0.10.0'
    s.add_development_dependency 'cucumber-rails'            # gets cucumber, nokogiri
    s.add_development_dependency 'database_cleaner'
    s.add_development_dependency 'selenium-client'
    s.add_development_dependency 'technicalpickles-jeweler'  # gets rubyforge
    s.add_development_dependency 'gemcutter'
    s.add_development_dependency 'ZenTest'
    s.add_development_dependency 'migration_test_helper'
  end

  task :build => :gemspec    # don't build a gem from a stale spec
  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "doc:app"
  end
  Jeweler::GemcutterTasks.new
end


  # documented rake_task.clear method missing?
class Rake::Task
  def clear!
    @actions.clear
    @prerequisites.clear
  end
end


        ############################################################
        # update default rake tasks for our test directory structure

namespace :test do
  # make test:units mean what it normally means
  Rake::Task[:units].clear!
  Rake::TestTask.new(:units => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/unit/app/models/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:units'].comment =
    "Run the model tests in test/unit/app/models"

  # but it's still a stupid naming convention:
  task :models => :units
end


        ############################################################
        # new rake tasks for our unit-like tests

namespace :test do
  Rake::TestTask.new(:views => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/unit/app/views/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:views'].comment =
    "Run the view unit tests (test/unit/app/views/**/*_test.rb)"

  Rake::TestTask.new(:helpers => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/unit/app/helpers/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:helpers'].comment =
    "Run the view-helper unit tests (test/unit/app/helpers/**/*_test.rb)"

  Rake::TestTask.new(:dbunits => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/unit/db/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:dbunits'].comment =
    "Run the database unit tests (test/unit/db/**/*_test.rb)"

    # Note: migration tests using migration_test_helper disrupts
    # loaded fixtures, so can't run in same Ruby process as other unit
    # tests, which breaking into separate rake task accomplishes
  Rake::TestTask.new(:dbmigrations => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/db_migrations_test.rb'
    t.verbose = true
  end
  Rake::Task['test:dbmigrations'].comment =
    "Run the database migration unit test (test/db_migrations_test.rb)"

  task :db => [ "test:dbunits", "test:dbmigrations" ]
  Rake::Task['test:db'].comment =
    "Run database tests (test:dbunits, test:dbmigrations)"


        ############################################################
        # now some new "umbrella" test tasks

  desc "Execute all development tests in test/unit."
  Rake::TestTask.new(:devs => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end

  desc "Execute all project-policy audit tests."
  task :policies do
    ruby File.join( "policy", "ckFilesUtils", "buildLinksIgnoreFile.rb" )
    ruby File.join( "policy", "ckFilesUtils", "ckForTabs.rb" )
    ruby File.join( "policy", "ckFilesUtils", "ckCopyrightNotices.rb" )
    ruby File.join( "policy", "ckFilesUtils", "ckCustomizationFilesPresent.rb" )
  end

  # aliases
  task :integrations => :integration  # multiple tests -> plural task name
  task :controllers => :functionals   # Rails naming convention #fail

  desc "Execute all the tests for Ruby code."
  task :ruby_tests => [ "test:devs", "test:db", "test:controllers",
    "test:integrations", "build", "cucumber:static_ok"]
end # namespace :test



# replace Rail's basic test task so that we get a reasonable execution order
Rake::Task[:test].clear!
desc 'Run all unit, integration, and policy checks'
task :tests => [ "test:policies", "asset:packager:build_all",
                    # above two have side effects necessary for setup
                 "test:devs", "test:db", "test:controllers",
                 "test:javascripts", "test:integrations", "build",
                 "cucumber:ok" ]
# alias
task :test => :tests
