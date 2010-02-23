
# execute this script from the directory containing the wontomedia*.gem file

INSTALL_DIR=/home/glenivey/etc/rails_apps/WontoMedia
HOSTING_HOME_DIR=/home/glenivey
GEMPATH_SED_COMMAND="/^RAILS_GEM_VERSION/aGem.use_paths \"/home/glenivey/ruby/gems\", [ \"/home/glenivey/ruby/gems\", \"/usr/lib/ruby/gems/1.8\" ]"

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
cp public/stylesheets/*.gif  public
sed --in-place=.backup -e "$GEMPATH_SED_COMMAND" config/environment.rb

RAILS_ENV=production rake customize[default-custom:~/wontology.org]
RAILS_ENV=production rake asset:packager:build_all

    # put gzip'ed versions of static packages in place for performance
    # only useful for the .htaccess/mod_rewrite setup we use on A2 Hosting
 # our packaged CSS style sheets
rm $HOSTING_HOME_DIR/www/stylesheets/*
mkdir $HOSTING_HOME_DIR/www/stylesheets
cp $INSTALL_DIR/public/stylesheets/*_packaged.css $HOSTING_HOME_DIR/www/stylesheets
gzip $HOSTING_HOME_DIR/www/stylesheets/*
 # and our packaged JavaScript sources
rm $HOSTING_HOME_DIR/www/javascripts/*
mkdir $HOSTING_HOME_DIR/www/javascripts
cp $INSTALL_DIR/public/javascripts/*_packaged.js $HOSTING_HOME_DIR/www/javascripts
gzip $HOSTING_HOME_DIR/www/javascripts/*
