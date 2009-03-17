# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wontomedia}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glen Ivey"]
  s.date = %q{2009-03-17}
  s.description = %q{WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme.  WontoMedia is free software (licensed under the AGPL v3), and is being developed by a dispersed volunteer team using agile methods.}
  s.email = %q{gleneivey@wontology.org}
  s.extra_rdoc_files = ["README"]
  s.files = ["COPYING", "LICENSE", "VERSION.yml", "Rakefile", "README", "COPYING.DOCUMENTATION", "cucumber.yml", "app/views", "app/views/layouts", "app/views/layouts/nodes.html.erb", "app/views/nodes", "app/views/nodes/new.html.erb", "app/views/nodes/show.html.erb", "app/controllers", "app/controllers/application.rb", "app/controllers/nodes_controller.rb", "app/helpers", "app/helpers/nodes_helper.rb", "app/helpers/application_helper.rb", "app/models", "app/models/node.rb", "config/routes.rb", "config/locales", "config/locales/en.yml", "config/environment.rb", "config/database-sample-mysql.yml", "config/initializers", "config/initializers/new_rails_defaults.rb", "config/initializers/inflections.rb", "config/initializers/mime_types.rb", "config/environments", "config/environments/development.rb", "config/environments/test.rb", "config/environments/production.rb", "config/database.yml", "config/boot.rb", "db/schema.rb", "db/migrate", "db/migrate/20090312212805_create_nodes.rb", "features/steps", "features/steps/rest_steps.rb", "features/steps/webrat_steps.rb", "features/stories", "features/stories/unfinished", "features/stories/unfinished/basic_nodes.feature", "features/stories/basic", "features/stories/ajax", "features/support", "features/support/paths.rb", "features/support/env.rb", "lib/tasks", "lib/tasks/cucumber.rake", "policy/copyright-notice-ignore", "policy/copyright-notices", "policy/copyright-notices/header.html.erb", "policy/copyright-notices/notice", "policy/copyright-notices/header.rake", "policy/copyright-notices/footer.feature", "policy/copyright-notices/header.html", "policy/copyright-notices/header.rb", "policy/copyright-notices/header", "policy/copyright-notices/header.js", "public/500.html", "public/422.html", "public/dispatch.cgi", "public/404.html", "public/dispatch.fcgi", "public/javascripts", "public/javascripts/controls.js", "public/javascripts/dragdrop.js", "public/javascripts/application.js", "public/javascripts/prototype.js", "public/javascripts/effects.js", "public/robots.txt", "public/favicon.ico", "public/stylesheets", "public/stylesheets/scaffold.css", "public/dispatch.rb", "script/destroy", "script/process", "script/process/inspector", "script/process/reaper", "script/process/spawner", "script/runner", "script/server", "script/console", "script/cucumber", "script/plugin", "script/generate", "script/about", "script/dbconsole", "script/performance", "script/performance/profiler", "script/performance/benchmarker", "script/performance/request", "test/unit", "test/unit/node_test.rb", "test/integration", "test/test_helper.rb", "test/functional", "test/functional/nodes_controller_test.rb", "test/fixtures", "test/fixtures/nodes.yml", "vendor/plugins"]
  s.has_rdoc = true
  s.homepage = %q{http://wontomedia.rubyforge.org}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wontomedia}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 2.2"])
    else
      s.add_dependency(%q<rails>, ["~> 2.2"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 2.2"])
  end
end
