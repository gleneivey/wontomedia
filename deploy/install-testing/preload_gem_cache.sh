TESTING_GEMS=/home/gem-testing
mkdir $TESTING_GEMS/bin

      # dependencies for running WontoMedia
gem install       rails --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install       mysql --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin

      # dependencies for WontoMedia development
gem install    nokogiri --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install      webrat --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install       rspec --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install rspec-rails --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install    cucumber --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install   rubyforge --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install     mongrel --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install technicalpickles-jeweler   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install    migration_test_helper   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install          selenium-client   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install           cucumber-rails   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install         database-cleaner   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin

      # optional tools for WontoMedia development
gem install     ZenTest --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
