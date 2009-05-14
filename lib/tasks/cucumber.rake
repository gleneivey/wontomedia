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

  Cucumber::Rake::Task.new(:features => 'db:test:prepare') do |t|
    t.fork = true
    t.cucumber_opts = "--format progress -r features"
    t.feature_list = Dir.glob("features/**/*.feature").reject do |path|
        path =~ %r%/unfinished/%
      end
  end

  namespace :features do
    Cucumber::Rake::Task.new(:unfinished => 'db:test:prepare') do |t|
    t.fork = true
      t.cucumber_opts = "--format progress -r features"
      t.feature_list = Dir.glob("features/**/unfinished/**/*.feature")
    end
  end
rescue LoadError
  puts "WARNING: Missing development dependency.  'Cucumber' not available. To install, see 'http://wiki.github.com/aslakhellesoy/cucumber/ruby-on-rails'"
end

