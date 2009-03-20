#!/usr/bin/perl

    # Note, when this changes, DUPLICATE in wm_install_from_scratch.pl
$RUBY_GEMS_WITH_VERSION= "rubygems-1.3.1";


system "gem1.8 uninstall wontomedia";
system "gem1.8 uninstall mysql";
system "apt-get -y purge libopenssl-ruby libopenssl-ruby1.8 ";


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
			 " libc6-dev zlib1g-dev libdbi-perl " .
			 " libnet-daemon-perl libplrpc-perl linux-libc-dev";


        # get rid of password config lines added for mysql
$lines= `cat numOriginalPasswdDatLines`;
$lines+= 0; # cast to integer
system "head -$lines /var/cache/debconf/passwords.dat > temp";
system "mv temp /var/cache/debconf/passwords.dat";

system "gem1.8 uninstall rake rails actionpack actionmailer " .
                       " activesupport activerecord activeresource" .
                       " --all --executables -I";

system "rm -rf /root/.gem /usr/bin/gem .gem " .
             " /usr/local/lib/site_ruby/1.8/rubygems* " .
	     " /usr/local/lib/site_ruby/1.8/ubygems.rb " .
             " /usr/lib/ruby/gems ";
system "rm -rf $RUBY_GEMS_WITH_VERSION";
system "apt-get -y purge ruby rdoc ri ruby1.8 rdoc1.8 ri1.8 " .
                       " libruby1.8 irb1.8 libreadline-ruby1.8 ";
system "apt-get autoremove";


