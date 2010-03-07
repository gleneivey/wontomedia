Copyright (C) 2010 - Glen E. Ivey
  (see the end of this file for copyright/licensing information)

Intro
=====

This directory contains scripts *currently* used for deploying
WontoMedia onto a single shared/virtual host provided by
a2hosting.com.  This process is expected to change as the preferred
Git repository for release builds changes, and when we migrate to
supporting multiple hosts and sites, additional/other hosting
providers, etc.

In short, the deployment procedure is as follows (note: parameters for
'wontology.org' installation):

 * from any web browser, back up the current database content by fetching
   both a 'items.yaml' and an 'connections.n3' file from
   http://wontology.org/admin

 * from the root of a wontomedia directory tree:
      $ rake                                   # which will build a release gem
      $ ./deploy/wontology-on-a2hosting/deploy-to-a2.sh

 * from the root of the A2 user account:
     [  shutdown WontoMedia via web/cPanel RoR widget ]
      $ ./install-wontomedia.rb wontology
      $ cd etc/rails_apps/WontoMedia                   # if necessary
      $ RAILS_ENV=production rake db:reseed            # if necessary
     [  start WontoMedia via web/cPanel RoR widget ]
     [  restore from items.yaml connections.n3 ]       # if necessary


These scripts make the following assumption about the A2 host's configuration:
 * All cPanel setup (database & db user creation, RoR app creation [for
   the 'production' environment], port forwarding) has already been done
 * the A2 account's local user name is:  glenivey
 * the A2 account's directories are organized as indicated by the constants
   at the top of install-wontomedia.rb

At a high level, installation is accomplished by:
 * building a release gem locally
 * scp'ing the gem to the A2 host
 * performing "gem install -l" on the new gem
 * copying in and updating the config/* files
 * ensuring that there is symbolic link from the point in ~/etc where A2
   expects the RoR app that points to the correct place in the local
   gem install directory

----------------------------------------------------------------

    Permission is granted to copy, distribute and/or modify this
    document under the terms of the GNU Free Documentation License,
    Version 1.3, published by the Free Software Foundation; with no
    Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.

    You should have received a copy of the GNU Free Documentation
    License along with document in the file COPYING.DOCUMENTATION.  If
    not, see <http://www.gnu.org/licenses/>.
