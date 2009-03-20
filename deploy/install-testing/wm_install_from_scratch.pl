#!/usr/bin/perl

#$testGemSource= "http://10.201.2.101:8808/";
#$aptLoadOptions= "--no-download";
$railsVersion= "-v=2.2.2";

    # Note, when this changes, DUPLICATE in wm_purge_to_scratch.pl
    #  AND the rubygems download URL probably has to, too
$RUBY_GEMS_WITH_VERSION= "rubygems-1.3.1";


sub DoASystemCommand {
    $cmd= $_[0];
    print "$cmd\n";
    (system($cmd) == 0) ||
        die "FAILED to '$cmd'\n";
}



        # first Ruby itself
DoASystemCommand( "apt-get -y $aptLoadOptions install ruby rdoc ri" );
        # now the RubyGems package manager
if (!-e "$RUBY_GEMS_WITH_VERSION.tgz"){
    DoASystemCommand( "wget http://rubyforge.org/frs/download.php/45905f/" .
                           "$RUBY_GEMS_WITH_VERSION.tgz" );
}
DoASystemCommand( "tar -xzf $RUBY_GEMS_WITH_VERSION.tgz" );
DoASystemCommand( "cd $RUBY_GEMS_WITH_VERSION;" .
                  "ruby setup.rb" );
        # and Rails depends on openssl
DoASystemCommand( "apt-get -y $aptLoadOptions install libopenssl-ruby" );

        # let's stay on the locall network if we can....
if (defined $testGemSource &&
    $testGemSource ne ""){
    DoASystemCommand( "gem1.8 sources --add $testGemSource" );
    DoASystemCommand( "gem1.8 sources --remove http://gems.rubyforge.org/" );
}
        # install Rails gem
DoASystemCommand( "gem1.8 install $railsVersion rails" );



        # install MySQL
    # make sure we don't have to deal with config dialogs
`wc /var/cache/debconf/passwords.dat` =~ /^\s*([0-9]+)\s+/;
system "echo $1 > numOriginalPasswdDatLines";
open(PASSDAT, ">>/var/cache/debconf/passwords.dat") ||
    die "Couldn't open config-passwords file for append.\n";
print PASSDAT <<FILESNIPET;

Name: mysql-server/root_password
Template: mysql-server/root_password
Value: mysql
Owners: mysql-server-5.0
Flags: seen

Name: mysql-server/root_password_again
Template: mysql-server/root_password_again
Value: mysql
Owners: mysql-server-5.0
Flags: seen

FILESNIPET
close PASSDAT;
    # and the actual MySQL install
DoASystemCommand( "apt-get -y $aptLoadOptions install " .
                            " mysql-server mysql-client " .
                            " libmysqlclient15-dev ruby1.8-dev "     );



        # create/configure database for testing
open(MYSQL, "|mysql -u root -pmysql") ||
    die "Couldn't start mysql client tool\n";

print MYSQL "CREATE DATABASE wm_test_db;\n";
print MYSQL "GRANT ALL PRIVILEGES ON wm_test_db.* TO 'wm'\@'localhost' IDENTIFIED BY 'wm-pass';\n";
close MYSQL;

        # the Ruby interface library to MySQL that Rails uses
DoASystemCommand( "gem1.8 install      mysql" );
        # and, FINALLY, WontoMedia
DoASystemCommand( "gem1.8 install wontomedia" );



        # now, trivial test that the install we just did works
    # make a locally-valid "database.yml" file from sample
$gemInstallDir= `ls -d /usr/lib/ruby/gems/1.8/gems/wontomedia*`;
chomp $gemInstallDir;
DoASystemCommand(
    "sed -e 's/wontomedia_production/wm_test_db/g' " .
    "    -e 's/wontomedia-user/wm/g' " .
    "    -e 's/replace-bad-passwd/wm-pass/g' " .
    " $gemInstallDir/config/database-mysql.yml > " .
    "   $gemInstallDir/config/database.yml "          );
    # initialize the database
DoASystemCommand( "cd $gemInstallDir; " .
                  "RAILS_ENV=production rake db:schema:load" );
    # and launch WontoMedia
DoASystemCommand( "cd $gemInstallDir; " .
                  "script/server -e production" );

