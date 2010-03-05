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


require 'test_helper'

class OnpageAlertsLayoutTest < ActionController::TestCase
  tests ItemsController  # mostly arbitrary, but this serves home page

  # home page uses "home" layout
  test "home page should include alert text when available" do
    alert_content_present :home, "Alert! Alert! This is a test alert."
  end
  test "home page should not have alert text when none available" do
    no_alert_content :home
  end

  # all other pages use "application", could test any
  test "Items index should include alert text when available" do
    alert_content_present :index, "This is a test alert. Alert! Alert!"
  end
  test "Items index should not have alert text when none available" do
    no_alert_content :index
  end



  PATH_TO_ALERT_PARTIAL = Rails.root.join( 'app', 'views', 'layouts',
    '_dynamic_alert_content.html' )

  def alert_content_present( action, alert_text )
    populate_alert alert_text
    get action
    remove_alert                 # cleanup before assert or it might not happen
    assert_select "body", /#{alert_text}/
  end

  def no_alert_content( action )
    remove_alert
    get action
    assert_select "body", { :text => /Alert!/i, :count => 0 },
      "Page cannot contain alert text"
    assert_select "body", { :text => /Show Alert/i, :count => 0 },
      "Page cannot contain show-alert link"
  end

  def populate_alert( alert_text )
    File.open( PATH_TO_ALERT_PARTIAL, "w" ) do |partial_file|
      partial_file.puts alert_text
    end
  end

  def remove_alert
    if File.exists? PATH_TO_ALERT_PARTIAL
      File.delete PATH_TO_ALERT_PARTIAL
    end
  end
end
