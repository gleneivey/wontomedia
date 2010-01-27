
# execute this script from the directory containing the wontomedia*.gem file

INSTALL_DIR=/home/glenivey/etc/rails_apps/WontoMedia
HOSTING_HOME_DIR=/home/glenivey
GEMPATH_SED_COMMAND='/^RAILS_GEM_VERSION/aGem.use_paths "/home/glenivey/ruby/gems", [ "/home/glenivey/ruby/gems", "/usr/lib/ruby/gems/1.8" ]'

cat $INSTALL_DIR/log/mongrel.log    >> $HOSTING_HOME_DIR/WmLogs/mongrel.log
cat $INSTALL_DIR/log/production.log >> $HOSTING_HOME_DIR/WmLogs/production.log
rm $INSTALL_DIR
gem uninstall wontomedia

gem install -l wontomedia
ln -s $HOSTING_HOME_DIR/ruby/gems/gems/wontomed* $INSTALL_DIR

cd $INSTALL_DIR
mkdir log
mkdir tmp

cp $HOSTING_HOME_DIR/wm.database.yml config/database.yml
cp $HOSTING_HOME_DIR/wm.wontomedia.rb config/initializers/wontomedia.rb
sed --in-place=.backup -e $GEMPATH_SED_COMMAND config/environment.rb

RAILS_ENV=production rake customize[default-custom]
