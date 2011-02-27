Copyright (C) 2010 - Glen E. Ivey
  (see the end of this file for copyright/licensing information)

Mechanism for Per-Instalation WontoMedia Customization
======================================================

WontoMedia is a web application intended to be installed in a large
number and in a wide variety of systems.  For many of these systems,
some of the included text or functionality may not be appropriate.  We
have tried to separate portions of WontoMedia that may need to be
customized (replaced) for different installations into separate files
from the core application.

To make things easier for those WontoMedia users who are also
developers, we have segregated the instances of those files particular
to a given WontoMedia installation from the core application files.
Unfortunately, the conventions used by Ruby-on-Rails make things
significantly easier if all files are located together based on
function.  If we included customization files in the standard Rails
directory hierarchy, then changes to them might inadvertently be
included in commit's to the Git repositories for WontoMedia, or other
people's changes to the sample version of the customization files
might accidentally be applied to the custom versions for a particular
installation.

We have reconciled these conflicting needs as follows:

 * customization files are kept in one or more "customization
   directories" separate from any of the standard Rails directories

 * within a customization directory is a sub-directory hierarchy
   that mirrors the standard Rails directory structure

 * a set of customization files, that can be viewed as examples and be
   used as-is to get a new WontoMedia installation going, is located
   in:

        wontomedia/default-custom

 * a rake task is provided that will create symbolic links to all
   files found under all customization directories from the matching
   point in the WontoMedia root directory hierarchy.  This allows
   files "outside" of the normal directory structure (for version
   control purposes) to appear "inside" where Rails expects them
   during execution.

 * a script is executed by rake (first step in `"rake test:policies"`)
   that finds all symbolic links in the project directory, and
   replaces the file `$GIT_DIR/info/exclude` with a list of them.  In
   a different type of project, where keeping symbolic links under
   version control was important, this would be a problem.  However,
   we have chosen the convention that symbolic links will be used in
   the WontoMedia directory structure only for installation
   customization.  This step prevents any symbolic links from being
   committed to Git, and therefore any individual installations
   configuration of cusomization files from being incorporated into
   any updates to WontoMedia.

   The "exclude" file is used, rather than `.gitignore`, so that an
   individual site's extensions can include files above and beyond the
   minimal set of entry points that the WontoMedia core expects.  If
   `.gitignore` were used, then people would still have to manually
   prevent customization files they added to their system from being
   listed in Git commits they share with others.

 * a script is executed by `rake` (run as part of `"rake
   test:policies"`) that recurses through the `default-custom`
   directory and fails that a symbolic link exists in the application
   directory hierarchy for each file under `default-custom`.  In this
   way, the content of `default-custom` not only provides a sample of
   customization files, but serves as the definition for all of the
   files referenced from portions of the core application.

The `customize` rake task is documented in

    wontomedia/doc/script/rake-customize.markdown

and its use in creating a new, *uncustomized* WontoMedia installation
is mentioned in the WontoMedia wiki at:

    http://wiki.wontology.org/InstallFromScratch
    http://wiki.wontology.org/SettingUpYourDevelopmentEnvironment

----------------------------------------------------------------

    Permission is granted to copy, distribute and/or modify this
    document under the terms of the GNU Free Documentation License,
    Version 1.3, published by the Free Software Foundation; with no
    Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.

    You should have received a copy of the GNU Free Documentation
    License along with document in the file COPYING.DOCUMENTATION.  If
    not, see <http://www.gnu.org/licenses/>.
