# !!!!! This file was auto-generated by "script/generate cucumber"  IF
# !!!!! YOU MODIFY IT, you *MUST* replace this notice with a WontoMedia
# !!!!! copyright attribute (get from policy/copyright-notices/header.rake) 
# !!!!! *AND* remove the name of this file from the copyright checking
# !!!!! ignore list (policy/copyright-notice-ignore) *BEFORE*
# !!!!! submitting to any version control that feeds back to the
# !!!!! WontoMedia project.


$:.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib')
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end
task :features => 'db:test:prepare'
