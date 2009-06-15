#!/usr/bin/perl

            #### from here, uninstall developer stuff and Git version
system "gem1.8 uninstall mongrel --all --executables -I";
system "gem1.8 uninstall migration_test_helper Selenium selenium-client --all --executables -I";
system "gem1.8 uninstall technicalpickles-jeweler ZenTest --all --executables -I";
system "gem1.8 uninstall rspec rspec-rails webrat cucumber --all --executables -I";
system "gem1.8 uninstall builder diff-lcs peterwald-git polyglot treetop term-ansicolor --all --executables -I";
system "gem1.8 uninstall nokogiri --all --executables -I";
system "apt-get -y purge avahi-daemon gsfonts-x11 libavahi-core5 libdaemon0 ";
system "apt-get -y purge libnss-mdns odbcinst1debian1 unixodbc ";
system "apt-get -y purge sun-java6-bin sun-java6-jre java-common rhino ";
system "apt-get -y purge libxml2-dev libxslt1-dev ";

system "rm -rf wontomedia";
system "apt-get -y purge git-core liberror-perl libdigest-sha1-perl ";


            #### from here, uninstall Gem version and runtime dependencies

    # Note, when this changes, DUPLICATE in wm_install_from_scratch.pl
$RUBY_GEMS_WITH_VERSION= "rubygems-1.3.1";


system "gem1.8 uninstall wontomedia";
system "gem1.8 uninstall mysql";
system "apt-get -y purge libopenssl-ruby libopenssl-ruby1.8 " .
                       " openssl-blacklist ssl-cert ";


system "rm -rf /root/.mysql_history /home/gei/.mysql_history " .
             " /usr/share/app-install/icons/*mysql* " .
             " /usr/share/app-install/desktop/*mysql* " .
             " /usr/share/app-install/desktop/*MySQL* ";

        # pre-answer config question:
        #  "are you sure you want to remove existing databases?" -- yes
system "sed --in-place=.backup " .
            " -e '/^Template: mysql-server-5.0\\/postrm_remove_databases/" .
                   "aValue: true' /var/cache/debconf/config.dat";

system "DEBIAN_FRONTEND=noninteractive apt-get -y purge " .
                         " mysql-server mysql-client " .
			 " mysql-server-5.0 mysql-client-5.0 " .
			 " mysql-common ruby1.8-dev libdbd-mysql-perl " .
			 " libmysqlclient15off libmysqlclient15-dev " .
			 " zlib1g-dev libdbi-perl " .
			 " libnet-daemon-perl libplrpc-perl linux-libc-dev";


        # get rid of password config lines added for mysql
$lines= `cat numOriginalPasswdDatLines`;
$lines+= 0; # cast to integer
system "head -$lines /var/cache/debconf/passwords.dat > temp";
system "mv temp /var/cache/debconf/passwords.dat";

system "gem1.8 uninstall rake rails rack actionpack actionmailer " .
                       " activesupport activerecord activeresource" .
                       " --all --executables -I";

system "rm -rf /root/.gem /root/.gemrc /usr/bin/gem .gem " .
             " /home/gei/.gem /home/gei/.gemrc " .
             " /usr/local/lib/site_ruby/1.8/rubygems* " .
	     " /usr/local/lib/site_ruby/1.8/ubygems.rb " .
             " /usr/lib/ruby/gems ";
system "rm -rf $RUBY_GEMS_WITH_VERSION";
system "apt-get -y purge ruby rdoc ri ruby1.8 rdoc1.8 ri1.8 " .
                       " libruby1.8 irb1.8 libreadline-ruby1.8 ";
system "apt-get autoremove";


