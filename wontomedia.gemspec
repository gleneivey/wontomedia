# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wontomedia}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glen E. Ivey"]
  s.date = %q{2010-01-29}
  s.description = %q{      WontoMedia is a Ruby-on-Rails web app for community creation of
      an information classification scheme.  WontoMedia is free
      software (licensed under the AGPL v3), and is being developed by
      a dispersed volunteer team using agile methods.
}
  s.email = %q{gleneivey@wontology.org}
  s.files = [
    "COPYING",
     "COPYING.DOCUMENTATION",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "app/controllers/admin_controller.rb",
     "app/controllers/application_controller.rb",
     "app/controllers/edges_controller.rb",
     "app/controllers/nodes_controller.rb",
     "app/helpers/nodes_show_helper.rb",
     "app/models/class_node.rb",
     "app/models/edge.rb",
     "app/models/item_node.rb",
     "app/models/node.rb",
     "app/models/property_node.rb",
     "app/models/reiffied_node.rb",
     "app/views/admin/index.html.erb",
     "app/views/common/_amazon_ads.html.erb",
     "app/views/common/_google_ads.html.erb",
     "app/views/common/_language_select.html.erb",
     "app/views/common/_login_controls.html.erb",
     "app/views/common/_master_help.html.erb",
     "app/views/common/_navigation_menu.html.erb",
     "app/views/common/_search_box.html.erb",
     "app/views/common/_status_msgs.html.erb",
     "app/views/edges/_index_outbound_links.html.erb",
     "app/views/edges/_spo_select_controls.html.erb",
     "app/views/edges/edit.html.erb",
     "app/views/edges/index.html.erb",
     "app/views/edges/new.html.erb",
     "app/views/edges/show.html.erb",
     "app/views/layouts/application.html.erb",
     "app/views/layouts/base.html.erb",
     "app/views/layouts/home.html.erb",
     "app/views/layouts/popup.html.erb",
     "app/views/nodes/_content_examples.html.erb",
     "app/views/nodes/_core_tasks.html.erb",
     "app/views/nodes/_form_fields.html.erb",
     "app/views/nodes/_list_outbound_links.html.erb",
     "app/views/nodes/_screen_select.html.erb",
     "app/views/nodes/_show_outbound_links.html.erb",
     "app/views/nodes/_type_select.html.erb",
     "app/views/nodes/edit.html.erb",
     "app/views/nodes/index.html.erb",
     "app/views/nodes/new.html.erb",
     "app/views/nodes/newpop.html.erb",
     "app/views/nodes/show.html.erb",
     "config/boot.rb",
     "config/cucumber.yml",
     "config/database-mysql-development.yml",
     "config/database-mysql.yml",
     "config/environment.rb",
     "config/environments/cucumber.rb",
     "config/environments/development.rb",
     "config/environments/production.rb",
     "config/environments/test.rb",
     "config/initializers/inflections.rb",
     "config/initializers/mime_types.rb",
     "config/initializers/new_rails_defaults.rb",
     "config/initializers/wontomedia-sample.rb",
     "config/initializers/wontomedia.rb",
     "config/locales/en.yml",
     "config/routes.rb",
     "db/fixtures/edges.yml",
     "db/fixtures/nodes.yml",
     "db/migrate/20090312212805_create_nodes.rb",
     "db/migrate/20090406221320_create_edges.rb",
     "db/migrate/20090411014503_add_type_for_node_subclasses.rb",
     "db/migrate/20090415142152_rename_node_type.rb",
     "db/migrate/20090518022918_rename_object_and_self.rb",
     "db/migrate/20090529171442_add_flags_to_nodes.rb",
     "db/migrate/20090529171508_add_flags_to_edges.rb",
     "db/migrate/20090605213800_flags_columns_not_null.rb",
     "db/migrate/20090605215028_flags_columns_default_zero.rb",
     "db/schema.rb",
     "default-custom/app/views/nodes/_home_extern_list.html.erb",
     "default-custom/app/views/nodes/_home_introductory_text.html.erb",
     "default-custom/app/views/nodes/home.html.erb",
     "default-custom/public/images/logo.png",
     "default-custom/public/images/logo.svg",
     "default-custom/public/stylesheets/wm.css",
     "lib/helpers/edge_helper.rb",
     "lib/helpers/node_helper.rb",
     "lib/helpers/tripple_navigation.rb",
     "lib/tasks/cucumber.rake",
     "lib/tasks/customize.rake",
     "lib/tasks/db.rake",
     "lib/tasks/javascript_testing_tasks.rake",
     "public/404.html",
     "public/422.html",
     "public/500.html",
     "public/dispatch.cgi",
     "public/dispatch.fcgi",
     "public/dispatch.rb",
     "public/favicon.ico",
     "public/images/blank_error_icon.png",
     "public/images/blank_status_icon.png",
     "public/images/error_error_icon.png",
     "public/images/error_status_icon.png",
     "public/images/good_status_icon.png",
     "public/images/twitter_icon.png",
     "public/images/warn_error_icon.png",
     "public/images/working_status_icon.gif",
     "public/javascripts/application.js",
     "public/javascripts/controls.js",
     "public/javascripts/dragdrop.js",
     "public/javascripts/effects.js",
     "public/javascripts/event.simulate.js",
     "public/javascripts/forEdgesForms.js",
     "public/javascripts/forNodesForms.js",
     "public/javascripts/modalbox.js",
     "public/javascripts/nodeCreatePopup.js",
     "public/javascripts/nodeTitleToName.js",
     "public/javascripts/prototype.js",
     "public/not_logged_in.html",
     "public/robots.txt",
     "public/stylesheets/modalbox.css",
     "public/stylesheets/scaffold.css",
     "public/stylesheets/spinner.gif",
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
     "script/server"
  ]
  s.homepage = %q{http://wontomedia.rubyforge.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{wontomedia}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme}
  s.test_files = [
    "test/unit/db/schema_test.rb",
     "test/unit/db/test_helper.rb",
     "test/unit/db/fixtures/nodes_test.rb",
     "test/unit/db/assert_current_schema.rb",
     "test/unit/app/views/edges/index_test.rb",
     "test/unit/app/views/edges/edit_test.rb",
     "test/unit/app/views/edges/show_test.rb",
     "test/unit/app/views/edges/new_test.rb",
     "test/unit/app/views/layouts/application_test.rb",
     "test/unit/app/views/nodes/index_test.rb",
     "test/unit/app/views/nodes/edit_test.rb",
     "test/unit/app/views/nodes/newpop_test.rb",
     "test/unit/app/views/nodes/show_test.rb",
     "test/unit/app/views/nodes/home_test.rb",
     "test/unit/app/views/nodes/new_test.rb",
     "test/unit/app/helpers/nodes_show_helper_test.rb",
     "test/unit/app/models/node_test.rb",
     "test/unit/app/models/reiffied_node_test.rb",
     "test/unit/app/models/item_node_test.rb",
     "test/unit/app/models/property_node_test.rb",
     "test/unit/app/models/class_node_test.rb",
     "test/unit/app/models/edge_test.rb",
     "test/unit/lib/helpers/tripple_navigation_ck_inherit_test.rb",
     "test/unit/lib/helpers/tripple_navigation_raaSuper_test.rb",
     "test/unit/lib/helpers/tripple_navigation_raaSub_test.rb",
     "test/unit/lib/helpers/tripple_navigation_ck_link_test.rb",
     "test/unit/config/routes_test.rb",
     "test/db_migrations_test.rb",
     "test/integration/home_create_nodes_test.rb",
     "test/integration/test_helper.rb",
     "test/test_helper.rb",
     "test/functional/admin_controller_test.rb",
     "test/functional/nodes_controller_test.rb",
     "test/functional/edges_controller_test.rb",
     "test/seed_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 2.2"])
    else
      s.add_dependency(%q<rails>, ["~> 2.2"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 2.2"])
  end
end
