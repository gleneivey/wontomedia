TESTING_GEMS=/home/gem-testing

gem install           pkg/wontomedia   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin --local
git daemon --user-path --export-all &
gem server --dir $TESTING_GEMS


gem uninstall         pkg/wontomedia   --install-dir $TESTING_GEMS --bindir $TESTING_GEMS/bin -x
