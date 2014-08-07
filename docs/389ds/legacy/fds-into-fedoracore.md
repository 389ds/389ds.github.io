---
title: "FDS Into FedoraCore"
---
This page details the work required to get Fedora Directory Server into Fedora Extras and Fedora Core

Fedora DS core is now in Fedora Extras
======================================

As of 2/14/07, Fedora DS (the core component) is in Fedora Extras. This version is a pre-release of 1.1. It builds using autotools, uses the packages already in the OS rather than bundling its own, and uses the FHS layout - [FHS\_Packaging](FHS_Packaging "wikilink"). See the [Install\_Guide](Install_Guide "wikilink") for information about creating an instance of the server after installing the software.

Component Dependencies
======================

svrcore
-------

Fedora Extras Tracking bug: <https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=196393> Mozilla Tracking bug: <https://bugzilla.mozilla.org/show_bug.cgi?id=363168>

The svrcore library is currently static only and uses the old coreconf build system. It should build into a shared library (properly versioned, of course) and should use autotools for building.

Update (12/15/2006): This has been approved for Fedora Extras!

Update (1/5/2006):

-   Imported into Fedora Extras - /cvs/extras/svrcore
-   Created branches for FC-5 and FC-6
-   Initial build for FC-6 - <http://buildsys.fedoraproject.org/logs/fedora-6-extras/25116-svrcore-4.0.3.01-0.fc6/>
-   All branches tagged and built
-   Closed Fedora Extras tracking bug - NEXTRELEASE

mozldap
-------

Fedora Extras Tracking bug: <https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=196401>

mozldap needs properly versioned libraries e.g. it needs to set the soname to libldap60.so.6.0.0 instead of just libldap60.so during build time. It needs some spec file cleanup as well.

Update (12/15/2006): The required changes to the spec file have been contributed by a member of the Fedora community, and it appears there are no blockers at this time - imminent approval expected

Update (1/8/2007): libldif needs to be made publicly callable - <https://bugzilla.mozilla.org/show_bug.cgi?id=366335>

Update (1/9/2007): mozldap is now in Fedora Extras!

-   added libldif to mozldap - pushed upstream
-   tested on FC6
-   tagged upstream as 6.0.1
-   uploaded new sources, spec file, srpm to mozldap ftp site
-   resubmitted new 6.0.1 sources to FE tracking bug above
-   approved!
-   imported into /cvs/extras
-   branches for FC-5 and FC-6 created
-   all branches tagged and built

perldap
-------

Fedora Extras Tracking Bug: <https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=219869>

Update (12/15/2006): Was submitted to Fedora Extras

Update (1/10/2006): Approved for Fedora extras - all branches tagged and built

Fedora DS Core
==============

db45
----

The latest version of Fedora (devel or fc7) has db45. There is some work involved to port the server to use db45.

Update 2/12/07 - DONE - Fedora DS now builds and runs with db42, db43, db44, and db45.

db43
----

Fedora DS should support being able to build/run with berkeley db 4.3. However, the OpenLDAP team has reported that db43 is not appropriate for production environments due to instability problems. So we will need to be able to "fallback" to db42 for those uses who must support heavy use production environments.

Update - DONE - see db45 above

init scripts
------------

Fedora DS needs to have init scripts for the OS startup and the service command.

This is now done needs some more testing

man pages
---------

Fedora DS has no man pages. There is the wiki documentation on this wiki, plus the extensive on-line manuals at www.redhat.com/docs, but if the user expects to type "man fedora-ds" at the command prompt, they will be disappointed.

Fedora Extras
-------------

Fedora DS has been submitted to Fedora Extras - <https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228555>

Update 2/14/07 - Fedora DS is now in Fedora Extras!

Management Tools
================

jss3
----

We need to get jss3 in for some of the management tools.

-   jss needs to build with gcj - there are some sun-isms in the code currently
-   jss needs its jar signed - how does this work in Fedora?

Update 2/12/07 - Rob Crittenden has tentatively agreed to look into this.

Update 4/19/07 - JSS has been submitted to Fedora - JSS will build with GCJ, and will build the unsigned jar file, which should be fine for most apps that don't use the JCE/JCA (which includes ldapjdk and console)

adminutil
---------

Update 4/19/07 - submitted to Fedora a couple of weeks ago

Update 4/30/07 - Approved

Update 7/25/07 - Current version in Fedora is 1.1.3

Update 8/21/07 - Current version in Fedora is 1.1.4

setuputil
---------

Update 4/19/07 - need to file Fedora bug for inclusion into Fedora

Update 7/24/07 - We have removed the setuputil package. We have replaced setup with a collection of perl modules, and scripts such as setup-ds.pl and migrate-ds.pl.

adminserver
-----------

Update 4/19/07 - Porting code to use FHS paths - many places had hardcoded paths

-   security CGI - all ops except add module and install crl/ckl done - waiting for input from security guys
-   mergeConfig CGI - done
-   admpw CGI - done

Update 4/25/07 - FHS work on CGI code mostly done - testing now

Updaste 7/25/07 - This has been submitted for Fedora - <https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=249548>
