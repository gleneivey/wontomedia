# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wontomedia}
  s.version = "1.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Glen E. Ivey"]
  s.date = %q{2011-06-02}
  s.description = %q{      WontoMedia is a Ruby-on-Rails web app for community creation of
      an information classification scheme.  WontoMedia is free
      software (licensed under the AGPL v3), and is being developed by
      a dispersed volunteer team using agile methods.
}
  s.email = %q{gleneivey@wontology.org}
  s.files = [
    "COPYING",
     "COPYING.DOCUMENTATION",
     "Capfile",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "app/controllers/admin_controller.rb",
     "app/controllers/application_controller.rb",
     "app/controllers/connections_controller.rb",
     "app/controllers/items_controller.rb",
     "app/helpers/connections_helper.rb",
     "app/helpers/format_helper.rb",
     "app/helpers/items_helper.rb",
     "app/models/category_item.rb",
     "app/models/connection.rb",
     "app/models/individual_item.rb",
     "app/models/item.rb",
     "app/models/property_item.rb",
     "app/models/qualified_item.rb",
     "app/views/admin/index.html.erb",
     "app/views/admin/search.html.erb",
     "app/views/connections/_index_outbound_links.html.erb",
     "app/views/connections/_spo_select_controls.html.erb",
     "app/views/connections/edit.html.erb",
     "app/views/connections/index.html.erb",
     "app/views/connections/new.html.erb",
     "app/views/connections/show.html.erb",
     "app/views/items/_active_content.html.erb",
     "app/views/items/_class_select.html.erb",
     "app/views/items/_content_examples.html.erb",
     "app/views/items/_core_tasks.html.erb",
     "app/views/items/_form_fields.html.erb",
     "app/views/items/_inline_add_popopen.html.erb",
     "app/views/items/_inline_item_add_form.html.erb",
     "app/views/items/_inline_scalar_add_form.html.erb",
     "app/views/items/_list_outbound_links.html.erb",
     "app/views/items/_most_populous_classes.html.erb",
     "app/views/items/_screen_select.html.erb",
     "app/views/items/_show_outbound_links.html.erb",
     "app/views/items/_topic_list.html.erb",
     "app/views/items/_type_select.html.erb",
     "app/views/items/edit.html.erb",
     "app/views/items/index.html.erb",
     "app/views/items/new.html.erb",
     "app/views/items/newpop.html.erb",
     "app/views/items/show.html.erb",
     "app/views/layouts/_amazon_ads.html.erb",
     "app/views/layouts/_dynamic_alert_framework.html.erb",
     "app/views/layouts/_footer.html.erb",
     "app/views/layouts/_glossary_help_box.html.erb",
     "app/views/layouts/_google_ads.html.erb",
     "app/views/layouts/_language_select.html.erb",
     "app/views/layouts/_login_controls.html.erb",
     "app/views/layouts/_master_help.html.erb",
     "app/views/layouts/_navigation_menu.html.erb",
     "app/views/layouts/_search_box.html.erb",
     "app/views/layouts/_status_msgs.html.erb",
     "app/views/layouts/application.html.erb",
     "app/views/layouts/base.html.erb",
     "app/views/layouts/home.html.erb",
     "app/views/layouts/popup.html.erb",
     "app/views/layouts/search.html.erb",
     "assets/wontomedia-sample.rb",
     "config/asset_packages.yml",
     "config/boot.rb",
     "config/caliper.yml",
     "config/cucumber.yml",
     "config/database-mysql-development.yml",
     "config/database-mysql.yml",
     "config/deploy.rb",
     "config/deploy_on_a2hosting.rb",
     "config/deploy_wontomedia.rb",
     "config/environment.rb",
     "config/environments/cucumber.rb",
     "config/environments/development.rb",
     "config/environments/production.rb",
     "config/environments/test.rb",
     "config/initializers/extensions.rb",
     "config/initializers/inflections.rb",
     "config/initializers/mime_types.rb",
     "config/initializers/mongrel.rb",
     "config/initializers/new_rails_defaults.rb",
     "config/locales/en.yml",
     "config/preinitializer.rb",
     "config/routes.rb",
     "db/fixtures/connections.yml",
     "db/fixtures/items.yml",
     "db/migrate/20090312212805_create_items.rb",
     "db/migrate/20090406221320_create_connections.rb",
     "db/migrate/20090411014503_add_type_for_item_subclasses.rb",
     "db/migrate/20090415142152_rename_item_type.rb",
     "db/migrate/20090518022918_rename_object_and_self.rb",
     "db/migrate/20090529171442_add_flags_to_items.rb",
     "db/migrate/20090529171508_add_flags_to_connections.rb",
     "db/migrate/20090605213800_flags_columns_not_null.rb",
     "db/migrate/20090605215028_flags_columns_default_zero.rb",
     "db/migrate/20100315135952_provide_scalar_objects.rb",
     "db/migrate/20100321042343_add_timestamp_columns.rb",
     "db/schema.rb",
     "default-custom/app/views/items/_home_introductory_text.html.erb",
     "default-custom/app/views/items/home.html.erb",
     "default-custom/app/views/layouts/_local_navigation.html.erb",
     "default-custom/config/initializers/wontomedia.rb",
     "default-custom/public/favicon.ico",
     "default-custom/public/images/logo.png",
     "default-custom/public/robots.txt",
     "default-custom/public/stylesheets/wm.css",
     "doc/README.markdown",
     "doc/README_FOR_APP",
     "doc/customization.markdown",
     "doc/scripts/rake-customize.markdown",
     "lib/helpers/connection_helper.rb",
     "lib/helpers/item_helper.rb",
     "lib/helpers/tripple_navigation.rb",
     "lib/tasks/asset_packager_tasks.rake",
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
     "public/images/blank_error_icon.png",
     "public/images/blank_status_icon.png",
     "public/images/error_error_icon.png",
     "public/images/error_status_icon.png",
     "public/images/good_status_icon.png",
     "public/images/help_icon.png",
     "public/images/transparent_ltblue_background.png",
     "public/images/transparent_white_background.png",
     "public/images/twitter_icon.png",
     "public/images/warn_error_icon.png",
     "public/images/working_status_icon.gif",
     "public/javascripts/application.js",
     "public/javascripts/controls.js",
     "public/javascripts/cookies.js",
     "public/javascripts/dragdrop.js",
     "public/javascripts/effects.js",
     "public/javascripts/event.simulate.js",
     "public/javascripts/fancybox.js",
     "public/javascripts/forConnectionsForms.js",
     "public/javascripts/forItemsForms.js",
     "public/javascripts/forItemsShow.js",
     "public/javascripts/itemCreatePopup.js",
     "public/javascripts/itemTitleToName.js",
     "public/javascripts/jquery.js",
     "public/javascripts/modalbox.js",
     "public/javascripts/prototype.js",
     "public/javascripts/reconcileJQueryAndPrototype.js",
     "public/stylesheets/blank.gif",
     "public/stylesheets/fancy_close.png",
     "public/stylesheets/fancy_loading.png",
     "public/stylesheets/fancy_nav_left.png",
     "public/stylesheets/fancy_nav_right.png",
     "public/stylesheets/fancy_shadow_e.png",
     "public/stylesheets/fancy_shadow_n.png",
     "public/stylesheets/fancy_shadow_ne.png",
     "public/stylesheets/fancy_shadow_nw.png",
     "public/stylesheets/fancy_shadow_s.png",
     "public/stylesheets/fancy_shadow_se.png",
     "public/stylesheets/fancy_shadow_sw.png",
     "public/stylesheets/fancy_shadow_w.png",
     "public/stylesheets/fancy_title_left.png",
     "public/stylesheets/fancy_title_main.png",
     "public/stylesheets/fancy_title_over.png",
     "public/stylesheets/fancy_title_right.png",
     "public/stylesheets/fancybox.css",
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
     "script/server",
     "vendor/plugins/asset_packager/CHANGELOG",
     "vendor/plugins/asset_packager/README",
     "vendor/plugins/asset_packager/Rakefile",
     "vendor/plugins/asset_packager/about.yml",
     "vendor/plugins/asset_packager/init.rb",
     "vendor/plugins/asset_packager/install.rb",
     "vendor/plugins/asset_packager/lib/jsmin.rb",
     "vendor/plugins/asset_packager/lib/synthesis/asset_package.rb",
     "vendor/plugins/asset_packager/lib/synthesis/asset_package_helper.rb",
     "vendor/plugins/asset_packager/test/asset_package_helper_development_test.rb",
     "vendor/plugins/asset_packager/test/asset_package_helper_production_test.rb",
     "vendor/plugins/asset_packager/test/asset_packager_test.rb",
     "vendor/plugins/asset_packager/test/asset_packages.yml",
     "vendor/plugins/asset_packager/test/assets/javascripts/application.js",
     "vendor/plugins/asset_packager/test/assets/javascripts/bar.js",
     "vendor/plugins/asset_packager/test/assets/javascripts/controls.js",
     "vendor/plugins/asset_packager/test/assets/javascripts/dragdrop.js",
     "vendor/plugins/asset_packager/test/assets/javascripts/effects.js",
     "vendor/plugins/asset_packager/test/assets/javascripts/foo.js",
     "vendor/plugins/asset_packager/test/assets/javascripts/prototype.js",
     "vendor/plugins/asset_packager/test/assets/stylesheets/bar.css",
     "vendor/plugins/asset_packager/test/assets/stylesheets/foo.css",
     "vendor/plugins/asset_packager/test/assets/stylesheets/header.css",
     "vendor/plugins/asset_packager/test/assets/stylesheets/screen.css",
     "vendor/plugins/asset_packager/test/assets/stylesheets/subdir/bar.css",
     "vendor/plugins/asset_packager/test/assets/stylesheets/subdir/foo.css",
     "vendor/plugins/redirect_routing/MIT-LICENSE",
     "vendor/plugins/redirect_routing/README",
     "vendor/plugins/redirect_routing/Rakefile",
     "vendor/plugins/redirect_routing/VERSION.yml",
     "vendor/plugins/redirect_routing/init.rb",
     "vendor/plugins/redirect_routing/lib/redirect_routing.rb",
     "vendor/plugins/redirect_routing/lib/redirect_routing/routes.rb",
     "vendor/plugins/redirect_routing/lib/redirect_routing_controller.rb",
     "vendor/plugins/redirect_routing/redirect_routing.gemspec",
     "vendor/plugins/redirect_routing/test/redirect_routing_test.rb",
     "vendor/plugins/redirect_routing/test/test_helper.rb",
     "wontomedia.gemspec"
  ]
  s.homepage = %q{http://wontomedia.rubyforge.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("~> 1.8.7")
  s.rubyforge_project = %q{wontomedia}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{WontoMedia is a Ruby-on-Rails web app for community creation of an information classification scheme}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, ["= 0.8.7"])
      s.add_runtime_dependency(%q<rails>, ["= 2.3.11"])
      s.add_runtime_dependency(%q<mysql>, ["= 2.8.1"])
      s.add_runtime_dependency(%q<mongrel>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<capistrano>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["= 1.3.3"])
      s.add_development_dependency(%q<webrat>, [">= 0"])
      s.add_development_dependency(%q<cucumber>, ["= 0.10.0"])
      s.add_development_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<selenium-client>, [">= 0"])
      s.add_development_dependency(%q<technicalpickles-jeweler>, [">= 0"])
      s.add_development_dependency(%q<gemcutter>, [">= 0"])
      s.add_development_dependency(%q<ZenTest>, [">= 0"])
      s.add_development_dependency(%q<migration_test_helper>, [">= 0"])
    else
      s.add_dependency(%q<rake>, ["= 0.8.7"])
      s.add_dependency(%q<rails>, ["= 2.3.11"])
      s.add_dependency(%q<mysql>, ["= 2.8.1"])
      s.add_dependency(%q<mongrel>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<capistrano>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["= 1.3.3"])
      s.add_dependency(%q<webrat>, [">= 0"])
      s.add_dependency(%q<cucumber>, ["= 0.10.0"])
      s.add_dependency(%q<cucumber-rails>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<selenium-client>, [">= 0"])
      s.add_dependency(%q<technicalpickles-jeweler>, [">= 0"])
      s.add_dependency(%q<gemcutter>, [">= 0"])
      s.add_dependency(%q<ZenTest>, [">= 0"])
      s.add_dependency(%q<migration_test_helper>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, ["= 0.8.7"])
    s.add_dependency(%q<rails>, ["= 2.3.11"])
    s.add_dependency(%q<mysql>, ["= 2.8.1"])
    s.add_dependency(%q<mongrel>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<capistrano>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["= 1.3.3"])
    s.add_dependency(%q<webrat>, [">= 0"])
    s.add_dependency(%q<cucumber>, ["= 0.10.0"])
    s.add_dependency(%q<cucumber-rails>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<selenium-client>, [">= 0"])
    s.add_dependency(%q<technicalpickles-jeweler>, [">= 0"])
    s.add_dependency(%q<gemcutter>, [">= 0"])
    s.add_dependency(%q<ZenTest>, [">= 0"])
    s.add_dependency(%q<migration_test_helper>, [">= 0"])
  end
end
