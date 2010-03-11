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


# this is based on Rails' built-in assert_recognizes, but only tests that
# all 'expected_options' are recognized in the 'path', not that there's
# an identical match between the options extracted and the expected
ActionController::Assertions::RoutingAssertions.class_eval do
  def assert_does_recognize(path, expected_options, extras={}, message=nil)
    if path.is_a? Hash
      request_method = path[:method]
      path           = path[:path]
    else
      request_method = nil
    end

    clean_backtrace do
      if ActionController::Routing::Routes.empty?
        ActionController::Routing::Routes.reload
      end
      request = recognized_request_for(path, request_method)

      expected_options = expected_options.clone
      extras.each_key { |key| expected_options.delete key } unless extras.nil?

      expected_options.stringify_keys!
      routing_diff = expected_options.diff(request.path_parameters)
      msg = build_message( message,
        "The recognized options <?> did not match <?>, difference: <?>",
        request.path_parameters, expected_options,
        expected_options.diff(request.path_parameters) )

      expected_options.to_a.each do |key_value_pair|
        key   = key_value_pair[0]
        value = key_value_pair[1]
        assert value == request.path_parameters[key], msg
      end
    end
  end
end
