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


require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'


        ############################################################
        # block to use Jeweler to generate our gemspec, gem, etc.
begin
  require 'jeweler'
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
    s.authors = ["Glen Ivey"]

    s.has_rdoc = true
    s.extra_rdoc_files = ["README"]

    s.files =  FileList["[A-Z]*",
      "{app,config,bin,db,generators,lib,public,script,test,vendor}/**/*"].
        exclude("database.yml")
    # Note:
    #       .autotest cucumber.yml .gitignore
    # and the testing directories
    #       deploy features policy
    # aren't included because developers are expected to pull from Git

    s.add_dependency 'rails', '~>2.2'
  end

  task :build => :gemspec    # don't build a gem from a stale spec
rescue LoadError
  puts "WARNING: Missing development dependency.  'Jeweler' and/or 'rubyforge' not available. Install them with:\n    'sudo gem install rubyforge'\n    'sudo gem install technicalpickles-jeweler -s http://gems.github.com'"
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

  task :db do
    # nothing
  end
  task :db => [ "test:dbunits", "test:dbmigrations" ]
  Rake::Task['test:db'].comment =
    "Run database tests (test:dbunits, test:dbmigrations)"


        ############################################################
        # now some new "umbrella" test tasks

  desc "Execute all development tests in test/unit."
  Rake::TestTask.new(:dev => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/unit/**/*_test.rb'
    t.verbose = true
  end

  desc "Execute all project-policy audit tests."
  task :policies do
    ruby File.join( "policy", "ckcopyright", "ckcopyright.rb" )
  end
end # namespace :test



# redefine Rail's basic test task so that we get a reasonable execution order
Rake::Task[:test].clear!
desc 'Run all unit, functional and integration tests'
task :test do
  errors = %w(test:dev test:dbmigrations test:functionals test:integration
              features).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence(:locale => :en)}!" if errors.any?
end



# not really done unless we conform to source policies, and check any
# unfinished (build break expected) Cucumber tests very last
task :default => [ "build", "test:policies", "features:unfinished" ]
