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


#### lines copied from env.rb, which we don't use any more

ENV["RAILS_ENV"] ||= "cucumber"
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')

require 'cucumber/formatter/unicode'
require 'cucumber/rails/rspec'
require 'cucumber/rails/world'
require 'cucumber/rails/active_record'
require 'cucumber/web/tableish'

require 'webrat'
require 'webrat/core/matchers'
# see "static.rb" and "dynamic.rb" for Webrat.configure....

ActionController::Base.allow_rescue = false


######## really local stuff

$KCODE = "u"

require File.join( File.dirname(__FILE__), '..', '..', 'test', 'seed_helper' )
require File.join( File.dirname(__FILE__), 'style_info' )
load_wontomedia_app_seed_data


######## Cucumber doesn't have a switch to prevent use of DatabaseCleaner,
########  so we stub it out here

module DatabaseCleaner
  class << self
    def start
      nil
    end
    def clean
      nil
    end
  end
end
