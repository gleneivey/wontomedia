"README" file for general-documentation directory of the WontoMedia package
Copyright (C) 2010 - Glen E. Ivey
  (see the end of this file for copyright/licensing information)

This directory contains documentation for the WontoMedia application.
There are two kinds of things located here:  the
automatically-generated RDoc documentation if/when you build it from
the WontoMedia source code, and more general hand-written
documentation.  The files and sub-directories here are as follows:

 * __scripts__:  This directory contains documentation for scripts and
   `rake` tasks that are part of the WontoMedia project.

 * __wiki__:  This directory contains the source documents (raw
   MediaWiki markup) for the content of wiki.wontology.org.  In
   addition to providing a local and cannonical set of documentation
   for WontoMedia's internals, the content of `wiki/Help` can be used
   to seed your own local MediaWiki installation if you'd rather use
   it than the general public content for WontoMedia's integrated help
   that is hosted at `wiki.wontology.org/Help:`.

 * __README_FOR_APP__:  This file (in RDoc/SimpleMarkup syntax) is
   incorporated as the content of the project's documentation "home
   page" when RDoc is used to build HTML source-code documentation.

 * __app__: This directory (which does not yet exist when a new
   WontoMedia directory tree is created from a gem or from a Git
   repository) holds the HTML files that make up the detailed
   source-code documentation for WontoMedia.  If you want to use this
   documentation, it is extracted from the WontoMedia source code by
   executing the command `rake doc:app`, after which you can view the
   documentation by loading the file `doc/app/index.html` from your
   web browser.

----------------------------------------------------------------

    Permission is granted to copy, distribute and/or modify this
    document under the terms of the GNU Free Documentation License,
    Version 1.3, published by the Free Software Foundation; with no
    Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.

    You should have received a copy of the GNU Free Documentation
    License along with document in the file COPYING.DOCUMENTATION.  If
    not, see <http://www.gnu.org/licenses/>.
