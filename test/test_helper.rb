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


RAILS_ENV = "test"
require File.join( File.dirname(__FILE__), "..", "config", "environment" )
require 'action_view/test_case'
require 'test_help'

class ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  fixtures :all

  require File.join( File.dirname(__FILE__), 'seed_helper' )
  setup :load_wontomedia_app_seed_data

  def assert_negative_view_contents
    assert_select "body", { :text => /error/i, :count => 0 },
      "Page cannot say 'error'"
    assert_select "body", { :text => /successfully created/i, :count => 0 },
      "Page cannot say 'successfully created'"
    assert_select "body", { :text => /warranty/i, :count => 0 },
      "Page cannot say 'warranty'"
  end
end
