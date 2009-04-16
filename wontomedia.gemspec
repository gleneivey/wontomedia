# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wontomedia}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glen Ivey"]
  s.date = %q{2009-04-16}
  s.description = %q{WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme.  WontoMedia is free software (licensed under the AGPL v3), and is being developed by a dispersed volunteer team using agile methods.}
  s.email = %q{gleneivey@wontology.org}
  s.extra_rdoc_files = [
    "README"
  ]
  s.files = [
    "COPYING",
    "COPYING.DOCUMENTATION",
    "LICENSE",
    "README",
    "Rakefile",
    "VERSION.yml",
    "app/controllers/application_controller.rb",
    "app/controllers/edges_controller.rb",
    "app/controllers/nodes_controller.rb",
    "app/helpers/application_helper.rb",
    "app/helpers/nodes_helper.rb",
    "app/models/class_node.rb",
    "app/models/edge.rb",
    "app/models/item_node.rb",
    "app/models/node.rb",
    "app/models/property_node.rb",
    "app/models/reiffied_node.rb",
    "app/views/edges/_spo_select_controls.html.erb",
    "app/views/edges/index.html.erb",
    "app/views/edges/new.html.erb",
    "app/views/edges/show.html.erb",
    "app/views/layouts/application.html.erb",
    "app/views/nodes/_form_fields.html.erb",
    "app/views/nodes/edit.html.erb",
    "app/views/nodes/home.html.erb",
    "app/views/nodes/index.html.erb",
    "app/views/nodes/new.html.erb",
    "app/views/nodes/show.html.erb",
    "config/boot.rb",
    "config/database-mysql-development.yml",
    "config/database-mysql.yml",
    "config/environment.rb",
    "config/environments/development.rb",
    "config/environments/production.rb",
    "config/environments/test.rb",
    "config/initializers/inflections.rb",
    "config/initializers/mime_types.rb",
    "config/initializers/new_rails_defaults.rb",
    "config/locales/en.yml",
    "config/routes.rb",
    "db/fixtures/edges.yml",
    "db/fixtures/nodes.yml",
    "db/migrate/20090312212805_create_nodes.rb",
    "db/migrate/20090406221320_create_edges.rb",
    "db/migrate/20090411014503_add_type_for_node_subclasses.rb",
    "db/migrate/20090415142152_rename_node_type.rb",
    "db/schema.rb",
    "lib/helpers/node_helper.rb",
    "lib/tasks/cucumber.rake",
    "lib/tasks/db.rake",
    "public/404.html",
    "public/422.html",
    "public/500.html",
    "public/dispatch.cgi",
    "public/dispatch.fcgi",
    "public/dispatch.rb",
    "public/favicon.ico",
    "public/javascripts/application.js",
    "public/javascripts/controls.js",
    "public/javascripts/dragdrop.js",
    "public/javascripts/effects.js",
    "public/javascripts/prototype.js",
    "public/robots.txt",
    "public/stylesheets/scaffold.css",
    "script/about",
    "script/console",
    "script/cucumber",
    "script/dbconsole",
    "script/destroy",
    "script/generate",
    "script/performance/benchmarker",
    "script/performance/profiler",
    "script/performance/request",
    "script/plugin",
    "script/process/inspector",
    "script/process/reaper",
    "script/process/spawner",
    "script/runner",
    "script/server",
    "test/db_migrations_test.rb",
    "test/fixtures/edges.yml",
    "test/fixtures/nodes.yml",
    "test/functional/edges_controller_test.rb",
    "test/functional/nodes_controller_test.rb",
    "test/integration/home_create_nodes_test.rb",
    "test/integration/test_helper.rb",
    "test/seed_helper.rb",
    "test/test_helper.rb",
    "test/unit/app/models/class_node_test.rb",
    "test/unit/app/models/edge_test.rb",
    "test/unit/app/models/item_node_test.rb",
    "test/unit/app/models/node_test.rb",
    "test/unit/app/models/property_node_test.rb",
    "test/unit/app/models/reiffied_node_test.rb",
    "test/unit/app/views/edges/index_test.rb",
    "test/unit/app/views/edges/new_test.rb",
    "test/unit/app/views/edges/show_test.rb",
    "test/unit/app/views/layouts/application_test.rb",
    "test/unit/app/views/nodes/edit_test.rb",
    "test/unit/app/views/nodes/home_test.rb",
    "test/unit/app/views/nodes/index_test.rb",
    "test/unit/app/views/nodes/new_test.rb",
    "test/unit/app/views/nodes/show_test.rb",
    "test/unit/config/routes_test.rb",
    "test/unit/db/assert_current_schema.rb",
    "test/unit/db/fixtures/nodes_test.rb",
    "test/unit/db/schema_test.rb",
    "test/unit/db/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://wontomedia.rubyforge.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wontomedia}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme}
  s.test_files = [
    "test/unit/db/schema_test.rb",
    "test/unit/db/test_helper.rb",
    "test/unit/db/fixtures/nodes_test.rb",
    "test/unit/db/assert_current_schema.rb",
    "test/unit/app/views/edges/index_test.rb",
    "test/unit/app/views/edges/show_test.rb",
    "test/unit/app/views/edges/new_test.rb",
    "test/unit/app/views/layouts/application_test.rb",
    "test/unit/app/views/nodes/index_test.rb",
    "test/unit/app/views/nodes/edit_test.rb",
    "test/unit/app/views/nodes/show_test.rb",
    "test/unit/app/views/nodes/home_test.rb",
    "test/unit/app/views/nodes/new_test.rb",
    "test/unit/app/models/node_test.rb",
    "test/unit/app/models/reiffied_node_test.rb",
    "test/unit/app/models/item_node_test.rb",
    "test/unit/app/models/property_node_test.rb",
    "test/unit/app/models/class_node_test.rb",
    "test/unit/app/models/edge_test.rb",
    "test/unit/config/routes_test.rb",
    "test/db_migrations_test.rb",
    "test/integration/home_create_nodes_test.rb",
    "test/integration/test_helper.rb",
    "test/test_helper.rb",
    "test/functional/nodes_controller_test.rb",
    "test/functional/edges_controller_test.rb",
    "test/seed_helper.rb"
  ]

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
