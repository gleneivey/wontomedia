
gem   install wontomedia --install-dir ~/gem-testing --bindir ~/gem-testing/bin --local
git daemon --user-path --export-all &
gem server                       --dir ~/gem-testing
gem uninstall wontomedia --install-dir ~/gem-testing --bindir ~/gem-testing/bin -x 