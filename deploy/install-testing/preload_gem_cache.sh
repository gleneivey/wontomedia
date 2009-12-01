mkdir ~/gem-testing
mkdir ~/gem-testing/bin

      # dependencies for running WontoMedia
gem install       rails --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install       mysql --install-dir ~/gem-testing --bindir ~/gem-testing/bin

      # dependencies for WontoMedia development
gem install    nokogiri --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install      webrat --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install       rspec --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install rspec-rails --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install    cucumber --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install   rubyforge --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install     mongrel --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install technicalpickles-jeweler   --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install    migration_test_helper   --install-dir ~/gem-testing --bindir ~/gem-testing/bin
gem install          selenium-client   --install-dir ~/gem-testing --bindir ~/gem-testing/bin

      # optional tools for WontoMedia development
gem install     ZenTest --install-dir ~/gem-testing --bindir ~/gem-testing/bin
