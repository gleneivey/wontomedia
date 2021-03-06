TESTING_GEMS=/home/gem-testing
mkdir $TESTING_GEMS/bin

# This is intended to match the dependency list in the Rakefile's jeweler
#  section.  That is controlling in the case of any mismatches.


      # dependencies for running WontoMedia
gem install        rake --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install       rails --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install     bundler --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin

gem install       mysql --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
# or another Rails-supported database


      # dependencies for WontoMedia development
gem install                   webrat   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install              rspec-rails   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install                  mongrel   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install                gemcutter   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install technicalpickles-jeweler   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install    migration_test_helper   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install          selenium-client   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install           cucumber-rails   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
gem install         database-cleaner   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin

      # optional tools for WontoMedia development
gem install                  ZenTest   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin
