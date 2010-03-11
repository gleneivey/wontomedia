ENV['RAILS_ENV'] = "test"

rails_vendor_path = File.expand_path('../../../vendor/rails')
if File.exist?(rails_vendor_path)
  $:.concat([
    File.join(rails_vendor_path, 'activesupport', 'lib'),
    File.join(rails_vendor_path, 'actionpack', 'lib')
  ])
  require 'active_support'
  require 'action_controller'
  require 'action_controller/test_process'
else
  puts "\n[!] Tests only run when the plugin is installed in the plugins directory, running the tests against anything other than your particular Rails version doesn't really serve a purpose."
  exit -1
end

require 'test/unit'

begin
  TestCase = ActionController::TestCase
rescue NameError
  TestCase = Test::Unit::TestCase
end

$:.unshift File.expand_path('../../lib', __FILE__)
require 'init'

