Copyright (C) 2011 - Glen E. Ivey
  (see the end of this file for copyright/licensing information)

# rake customize[directory-path:directory-path]

This rake task operates recursively through each directory provided,
and creates symbolic links to the files in that directory from
matching, same-named points in the main wontomedia installation
directory.  It is intended to merge installation-specific
customization files maintained in separate directories (and version
control repositories) from the core of the WontoMedia web application.

As many directories as desired can be specified on the command line
(one minimum).  The directory name list must be enclosed in square
brackets, and placed immediately after the task name `customize` (no
space).  Each directory is separated from the next by a colon (like a
UNIX `PATH`).  Recall that rake always operates relative to the top
directory of your project, regardless of your working directory when
you execute the rake command.  Therefore, any relative paths you
include are evaluated relative to the root of the wontomedia
installation directory.

Depending on your shell and the content of your directory names, you
may need to include quotation marks or escape characters in the
command line you type in order for rake to receive a command line
formatted as shown.  In particular, the entire parameterized task,
from the task name (`customize`) through the closing square-bracket
must be parsed by the shell and passed to rake as a single
command-line argument.

As an example of the `customize` task's operation, the command

    rake customize[~/myWontology]

will recursively find all files and directories under your
`myWontology` directory, and make it appear as though they've been
copied into your WontoMedia directory (in which the rake command was
executed).  Assuming the following directory structure/content:

    ~/myWontology/app/views/items/_home_introductory_text.html.erb

this rake task will do the equivalent of:

    ln -s ~/myWontology/app/views/items/_home_introductory_text.html.erb $RAILS_ROOT/app/views/items

However, the rake task uses absolute paths, so it will have to be
re-executed if you later move either the WontoMedia directory or one
of the customization directories in your file system.

In this example, there was only one argument directory and only one
file, so only one link was created.  This task will also create any
directories needed to hold the created links, although this was not
needed for the example above because a standard Ruby-on-Rails
directory was used.

When more than one directory is specified on the command line, this
task processes them in the order provided.  If multiple directory
arguments are provided, and two or more of them contain a file with
the same relative path and name, only the link from the last
(right-most) directory will remain when the task is complete.  This
allows installation customizations to be derived from each other.  For
example, running the following command from the root of your
WontoMedia directory:

    rake customize[default-custom:~/myWontology]

will first create links to the minimum set of required customization
files under the `default-custom` directory, and then create links to
the files in your `myWontology` directory.  Your `myWontology` could
then contain as little as a single file (with the correct,
Rails-matching relative path) that replaced only a single link
pointing into the `default-custom` directory.

----------------------------------------------------------------

    Permission is granted to copy, distribute and/or modify this
    document under the terms of the GNU Free Documentation License,
    Version 1.3, published by the Free Software Foundation; with no
    Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.

    You should have received a copy of the GNU Free Documentation
    License along with document in the file COPYING.DOCUMENTATION.  If
    not, see <http://www.gnu.org/licenses/>.
