
cat/home/glenivey/etc/rails_apps/WontoMedia/log/mongrel.log    >> /home/glenivey/WmLogs/mongrel.log
cat/home/glenivey/etc/rails_apps/WontoMedia/log/production.log >> /home/glenivey/WmLogs/production.log
rm /home/glenivey/etc/rails_apps/WontoMedia
gem uninstall wontomedia

gem install -l wontomedia
ln -s /home/glenivey/ruby/gems/gems/wontomed* /home/glenivey/etc/rails_apps/WontoMedia

cp /home/glenivey/wm.database.yml /home/glenivey/etc/rails_apps/WontoMedia/config/database.yml
sed --in-place=.backup -e '/^RAILS_GEM_VERSION/aGem.use_paths "/home/glenivey/ruby/gems", [ "/home/glenivey/ruby/gems", "/usr/lib/ruby/gems/1.8" ]' /home/glenivey/etc/rails_apps/WontoMedia/config/environment.rb

mkdir /home/glenivey/etc/rails_apps/WontoMedia/log
mkdir /home/glenivey/etc/rails_apps/WontoMedia/tmp
