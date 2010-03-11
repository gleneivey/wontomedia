require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the test plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the test plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Test'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |spec|
    spec.name = "redirect_routing"

    spec.author = "Manfred Stienstra"
    spec.email = "manfred@fngtps.com"

    spec.description = <<-EOF
      simple redirects straight from your routes.rb file
    EOF
    spec.summary = <<-EOF
      simple redirects straight from your routes.rb file
    EOF
    spec.homepage = "http://github.com/seamusabshere/redirect_routing/tree/master"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end