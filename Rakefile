# WontoMedia -- a wontology web application
# Copyright (C) 2009 -- Glen E. Ivey
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

    s.add_dependency 'rails', '2.2.2'
  end

  task :build => :gemspec    # don't build a gem from a stale spec
rescue LoadError
  puts "WARNING: Missing development dependency.  'Jeweler' not available. Install it with: 'sudo gem install technicalpickles-jeweler -s http://gems.github.com'"
end


namespace :test do
  Rake::TestTask.new(:views => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/views/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:views'].comment =
    "Run the view tests (test/views/**/*_test.rb)"

  Rake::TestTask.new(:helpers => "db:test:prepare") do |t|
    t.libs << "test"
    t.pattern = 'test/helpers/**/*_test.rb'
    t.verbose = true
  end
  Rake::Task['test:helpers'].comment =
    "Run the view-helper tests (test/helpers/**/*_test.rb)"
end

task :test => [ "test:views", "test:helpers" ]
