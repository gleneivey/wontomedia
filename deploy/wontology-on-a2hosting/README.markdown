Intro
=====

This directory contains scripts *currently* used for deploying
WontoMedia onto a single shared/virtual host provided by
a2hosting.com.  This process is expected to change as the preferred
Git repository for release builds changes, and when we migrate to
supporting multiple hosts and sites, additional/other hosting
providers, etc.

In short, the deployment procedure is as follows:

 * from the root of a wontomedia directory tree:
      $ rake                                   # which will build a release gem
      $ ./deploy/wontology-on-a2hosting/deploy-to-a2.sh

 * from the root of the A2 user account:
      $ ./install-wontomedia.sh


These scripts make the following assumption about the A2 host's configuration:
 * All cPanel setup (database & db user creation, RoR app creation [for
   the 'production' environment], port forwarding) has already been done
 * the A2 account's local user name is:  glenivey
 * the A2 account's user's local gem path is:
      /home/glenivey/ruby/gems
   (the A2 default)
 * the cPanel RoR configuration for the app's home directory is:
      /home/glenivey/etc/rails_apps/WontoMedia
   (the A2 default path for an app named "WontoMedia")
 * the correct contents for the app's config/database.yml file is
   located at:
      /home/glenivey/wm.database.yml

At a high level, installation is accomplished by:
 * building a release gem locally
 * scp'ing the gem to the A2 host
 * performing "gem install -l" on the new gem
 * copying in the config/database.yml file
 * updating the config/environment.rb file to include the account-specific
   gem directory
 * ensuring that the symbolic link from ~/etc for the RoR app points
   to the correct directory in the local gem directory
