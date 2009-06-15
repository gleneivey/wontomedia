
Intro
=====


This directory contains scripts (shell, Perl, and Ruby) used for
testing the installation of WontoMedia on a clean/minimal Linux
system.  They have been used on Ubuntu 9.04, and are written assuming
the presence of the Debian package manager `apt-get`.  The scripts
whose names begin "wm_*" are intended to be executed on the test
target (the system being installed on), with the other scripts being
run on your development system (where your WontoMedia Git repository
is located) to allow the target to install from your local development
version of WontoMedia.

Note that the wm_* scripts can *also* be used for the initial
installation and configuration of your development system.  Their
structure follows the instructions in

    http://wiki.wontology.org/InstallFromScratch

and

    http://wiki.wontology.org/SettingUpYourDevelopmentEnvironment

These scripts are (should be) updated any time the installation
instructions are upgraded.


Installation Test Scripts
=========================

There are five wm_* scripts:

 * One for installing WontoMedia runtime dependencies and the
WontoMedia gem.  This script expects to be run as root, and automates
and tests all of steps in the `InstallFromScratch` page, and is the
only script necessary to get a local WontoMedia installation running,
it ends by launching a local WontoMedia instance available at
`localhost:3000`.

 * Three for transitioning from a production/execution environment
based on WontoMedia installed from a gem to a development
configuration based on WontoMedia installed into a local Git
repository.

 * One for reversing all of the steps in the other scripts, returning
the the system to its "clean" configuration.  Note that this
unconditionally uninstalls WontoMedia and *all* of its dependencies.
So, if you are using these scripts on your daily-use system, this
script might break dependencies of other software you use and is not
suggested.  However, it is appropriate for hosts used to
regression-test the WontoMedia install process itself, to ensure that
the system does not acquire new dependencies unnoticed.

Note that all of these scripts expect WontoMedia to be run with
MySQL.  If you want to use a different database server, wm_developer
might still be of use to you.

The following sections describe each script in the order they are
intended to be executed


wm_install_from_scratch.pl
--------------------------

This script expects to be run as root.

It installs Ruby, RubyGems, MySQL, and the gems necessary to run
WontoMedia.  For testing purposes, it also creates a database and user
within MySQL, and creates a matching `database.yml` in the
`gems/wontomedia/config` directory.  For a production installation,
you will likely want to modify or remove these database entities.

If any of the installation steps fails, it will stop at that point
with an error message.  If testing the installation process, run
`wm_purge_to_scratch.pl` before attempting to fix the configuration
problem and reinstall.

On successful completion, the install script will launch WontoMedia
using the standard Rails `script/server` command.  This will start
WontoMedia on port 3000, using the "development" database
configuration, and any installed web server for which Rails has a
default configuration.  (The install script does not install a web
server, so if using it on a clean system, the Ruby built-in server
WEBRick will run.)  To terminate the web server/WontoMedia instance
and allow the script to complete, type Control-C.


wm_ungem
--------

This script expects to be run as root.

on completion of `wm_install_from_scratch.pl`, WontoMedia will have
been installed by RubyGems, likely in a system directory and with
files modifiable only by root.  While this could be a resonable
installation for a server system, it is not desirable for anyone
performing development on WontoMedia.

Executing this script will uninstall the WontoMedia gem, and install
the source-code management tool Git on your system (if it isn't
already present).


wm_git
------

This script should be run while logged into the user account from
which you will do development, and from the directory *within which*
you want you WontoMedia Git repository created.

This script will create a new Git repository containing the WontoMedia
source, by default using the "public clone" URL for an active
development repository on GitHub.  This will allow you to run the
WontoMedia application, run its test suite, and to make changes
locally.  However, you will not be able to "push" any changes you make
directly back to GitHub.  Please see the script comments for more
alternatives.

The script also creates another database in your local MySQL instance,
and creates a default `database.yml` file in your WontoMedia
repository configured for local `development` and `test` databases,
but without a configured `production` database.  (Keep in mind that
`database.yml` is not maintained under source control, but that the
sample configuration files that this and other scripts use,
`config/database-*.yml`, *are*.  If you wish to make changes to
`database.yml` that will be shared with other WontoMedia
installations, be sure to make them in the appropriate sample files.)

Note that `wm_git` assumes the existence of the test database created
by `wm_install_from_scratch.pl` and creates only the development
database.  If you performed the basic installation by hand and have
not run the install script, you can either create the test database by
hand or remove the comment characters ("#") from three lines in the
`wm_git` script (starting from the one that contains `CREATE DATABASE
wm_test_db`) prior to executing it.


wm_developer
------------

This script expects to be run as root.

This will install the Debian packages and RubyGems that are
dependencies of WontoMedia's automated tests and that are used by
other WontoMedia developers.


wm_purge_to_scratch.pl
----------------------

This script expects to be run as root.

When run, this script will unconditionally and thoroughly reverse all
of the steps taken by the preceding scripts.  If you're running on a
host whose primary purpose is testing the WontoMedia install process,
this is a good thing.  If you're on your primary development system,
running this script is probably a very bad idea.

In addition to uninstalling all of the items installed by the other
four scripts, this script:


 * uninstalls all known packages that `apt-get` and `gem` installs
implicitly because packages explicitly installed by the other scripts
depend on them.

 * will completely remove your WontoMedia Git repository (assuming it
is executed from within the same directory where you ran `wm_git`),
causing you to lose any source changes you have not pushed or pulled
into another repository.

 * remove your entire MySQL installation, including all database
files.  This means you will lose not only any content you have created
within your WontoMedia `development` database, but also any other
(non-WontoMedia) databases stored in MySQL by any application on your
system.

In addition, both this script and `wm_install_from_scrach.pl` directly
manipulate the Debian packaging systems configuration file for storing
default password values obtained by package installation scripts.
(This is done so that the install script can install MySQL with a
known root user password and without requiring an operator to interact
with the MySQL installer's setup dialogs.)  To facilitate reversal of
the changes to `/var/cache/debconf/passwords.dat` that the insall
script makes, this script looks for the file
`numOriginalPasswdDatLines` in the directory from which it is run.  If
the install and purge scripts are run from the same directory, and it
is not manually cleaned up in between, then all will be well.  If the
file is lost or removed, then this script will *truncate* the
`passwords.dat` file.  Fortunately, this file is needed almost
exclusively when the different Debian installers are run, and if an
entry is lost, the user will be re-queried for the appropriate
passwords when needed.



Remote and Local Installation
=============================

All of these scripts define configuration variables near the top that
control the locations from which they download/install components.
(`wm_install_from_scratch.pl` also contains an optional variable to
force a particular version of Rails to be used, but this should only
be of interest to people performing install testing during periods
between a new Rails release and when the development branch of
WontoMedia transitions to supporting the new Rails.)

Unmodified, the scripts will install from "normal" public sources,
which is appropriate if you are actually setting up a new system.  If,
however, you are using them to thest the WontoMedia installation
process, especially following changes to your local version of
WontoMedia, then this is likely not desirable.

For testing the installation of a modified version of WontoMedia, the
two most important things to control are the locations from which the
WontoMedia gem is installed and from which the WontoMedia Git
repository is cloned.

In addition to controlling the sources for WontoMedia, there are
configuration variables that control whether `apt-get` and `gem` will
reach out to the Internet for anything at all.  Using these options
can improve the performance of rapid-cycle installation testing or
ensure the stability of the environment in which you're performing
testing.


Serving From Your Development System
------------------------------------

There are two scripts to support your use of your local development
system as a server for installing to other systems.  Both should be
executed while logged in to your development user account.

First is `preload_gem_cache`.  This script will create and populate an
isolated gem repository under your home directory.  This is separate
from the default repository normally used by the `gem` command, and
will not interfere with the configuration of tool and gem versions
that you regularly use.  The isolated set of gems this creates will be
served, along with your locally-created WontoMedia gem, to your target
installation test system, allowing you to avoid repeated download of
dependency gems from RubyForge, GitHub, etc.

The second script is `serve_gem`.  When you have completed a change in
your local WontoMedia development area, you can do the following:

    cd [your development area]/wontomedia
    rake build
    cd pkg
    ../deploy/install-testing/serve_gem

The script will install your just-built WontoMedia gem into the
isolated gem repository created by `preload_gem_cache`, start a gem
server process serving from that repository, and start a (very
liberal) Git server process.  When you're done with installation
testing on your target system, type Control-C to kill the gem server,
and the script will conclude by *uninstalling* the WontoMedia gem from
the test repository.  Note that the Git server remains running and
must be terminated manually if desired.


`Apt-get` with `--no-download`
------------------------------

The script variables to stop `apt-get` from downloading new copies of
Debian packages does not interfere with package manager's attempt to
read from original install media (CDs, DVDs, etc.) if that is where
the most recent version of a package is.  By default, `apt-get` will
not keep a copy of a non-network package file in its local cache
(`/var/cache/apt/archives`), and so will continue to request
media-changes when performing installations from these scripts.  To
prevent `apt-get` from requiring a media change, either remove the
disk(s) from APT's list of package sources (and perform at least one
installation without `--no-download` to load the necessary package
files from the Internet to the archive directory), or manually copy the
relevant packages from the install media to the archive directory
prior to running the install.


Other Network Downloads
-----------------------

Finally, the install script is configured to download the `.tgz` file
for installing RubyGems from the Internet.  However, it checks the
directory from which it is being run for a copy of the install file,
and will not perform a download if it is present.  The
`wm_purge_to_scratch.pl` script does *not* remove this file, so that
successive installations performed in the same directory will all use
the RubyGems installer downloaded during the first attempt.

