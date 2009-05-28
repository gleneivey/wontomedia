
rm /home/glenivey/etc/rails_apps/WontoMedia
gem uninstall wontomedia
gem install -l wontomedia
ln -s /home/glenivey/ruby/gems/gems/wontomed* /home/glenivey/etc/rails_apps/WontoMedia

cp /home/glenivey/wm.database.yml /home/glenivey/etc/rails_apps/WontoMedia/config/database.yml
sed --in-place=.backup -e '/^RAILS_GEM_.+VERSION/aGem.use_paths "/home/glenivey/ruby/gems", [ "/home/glenivey/ruby/gems", "/usr/lib/ruby/gems/1.8" ]' /home/glenivey/etc/rails_apps/WontoMedia/config/environment.rb

mkdir /home/glenivey/etc/rails_apps/WontoMedia/log
mkdir /home/glenivey/etc/rails_apps/WontoMedia/tmp
