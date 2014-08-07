---
title: Development Page
---

# 389 Directory Server Development
----------------------------------

{% include toc.md %}

Developer's
-----------

Developers should check out our [building](development/building.html) and [install](legacy/install-guide.html) guides to see how to build and install the server from source. Then you can get working on fixing [bugs](FAQ/bugs.html), adding new [features](FAQ/features.html), adding new test cases to [lib389 Continuous Integration](FAQ/upstream-test-framework.html), or improving our [documentation](documentation.html).  For other ideas see [ways to contribute](FAQ/ways-to-contribute.html).

To browse through our backlog of development tickets, access the [389 Trac instance](FAQ/bugs.html).

If you want to contribute code to the project you should look at our [contributing](development/contributing.html) page. It contains information on the process you have to go through to be able to submit patches we will accept as well as getting a git. From a more technical standpoint, before submitting a patch you should check out our [coding style](development/coding-style.html) guide. Once your patch is approved, see the [Git rules](development/git-rules.html) before checking anything in.

Please take some time to review our [license](FAQ/licensing.html).

<a name="source"></a>

Source Code and Build Instructions
--------------------------------------------------------

-   [Download Source Code](development/source.html)
-   [Coding Style](development/coding-style.html)
-   [Git Rules](development/git-rules.html) - rules and guidelines for submitting patches and pushing to upstream
-   [Git information](http://git-scm.com/)
    -   [Official Git tutorial](http://www.kernel.org/pub/software/scm/git/docs/gittutorial.html)
    -   [Everyday Git](http://www.kernel.org/pub/software/scm/git/docs/everyday.html) - day to day usage examples for different roles
    -   [Git Users Manual](http://www.kernel.org/pub/software/scm/git/docs/user-manual.html)
    -   [Reference Manual](http://www.kernel.org/pub/software/scm/git/docs/) - man pages
    -   [Git Community Book](http://book.git-scm.com/)
    -   [Git Visual Cheat Sheet](http://zrusin.blogspot.com/2007/09/git-cheat-sheet.html)
    -   [Linus Torvalds on Git](http://www.youtube.com/watch?v=4XpnKHJAok8)
-   [How to Build RPMS on CentOS ](howto/howto-buildrpmsforcentos-rhel.html)


|Component|GIT Repository|Clone the Repository|
|---------|------|
|**Directory Server** ([build instructions](development/building.html))| <https://git.fedorahosted.org/git/389/ds.git>| git clone git://git.fedorahosted.org/git/389/ds.git<br>git clone ssh://git.fedorahosted.org/git/389/ds.git|
|**AdminUtil** ([build instructions](administration/adminutil.html)) | <https://git.fedorahosted.org/git/389/adminutil.git>| git clone git://git.fedorahosted.org/git/389/adminutil.git<br>git clone ssh://git.fedorahosted.org/git/389/adminutil.git|
|**Admin Server** ([build instructions](administration/adminserver.html)) | <https://git.fedorahosted.org/git/389/admin.git>| git clone git://git.fedorahosted.org/git/389/admin.git<br>git clone ssh://git.fedorahosted.org/git/389/admin.git|
|**IDM Console Framework** ([build instructions](development/buildingconsole.html#framework)) | <https://git.fedorahosted.org/git/idm-console-framework.git>| git clone git://git.fedorahosted.org/git/idm-console-framework.git<br>git clone ssh://git.fedorahosted.org/git/idm-console-framework.git|
|**389 Console** ([build instructions](development/buildingconsole.html#console)) | <https://git.fedorahosted.org/git/389/console.git>| git clone git://git.fedorahosted.org/git/389/console.git<br>git clone ssh://git.fedorahosted.org/git/389/console.git|
|**DS Console** ([build instructions](development/buildingconsole.html#ds-console)) | <https://git.fedorahosted.org/git/389/ds-console.git>| git clone git://git.fedorahosted.org/git/389/ds-console.git<br>git clone ssh://git.fedorahosted.org/git/389/ds-console.git|
|**Admin Console** ([build instructions](development/buildingconsole.html#admin-console)) | <https://git.fedorahosted.org/git/389/admin-console.git>| git clone git://git.fedorahosted.org/git/389/admin-console.git<br>git clone ssh://git.fedorahosted.org/git/389/admin-console.git|
|**DSGW & Web Apps** ([build instructions](administration/dsgw-building.html)) | <https://git.fedorahosted.org/git/389/dsgw.git>| git clone git://https://git.fedorahosted.org/git/389/dsgw.git<br>git clone ssh://https://git.fedorahosted.org/git/389/dsgw.git|
|**DSML Gateway** ([build instructions](administration/dsml-gateway-building.html)) | <https://git.fedorahosted.org/git/389/dsmlgw.git>| git clone git://git.fedorahosted.org/git/389/dsmlgw.git<br>git clone ssh://git.fedorahosted.org/git/389/dsmlgw.git|
|**Passync/Winsync** ([build instructions](development/buildingpasssync.html)) | <https://git.fedorahosted.org/git/389/winsync.git>| git clone git://git.fedorahosted.org/git/389/winsync.git<br>git clone ssh://git.fedorahosted.org/git/389/winsync.git|
|**Continuous Integration Testing** ([documentation](FAQ/upstream-test-framework.html))| <https://git.fedorahosted.org/git/389/lib389.git>| git clone git://git.fedorahosted.org/git/389/lib389.git<br>git clone ssh://git.fedorahosted.org/git/389/lib389.git|


Design Documents
----------------

[Design Docs](design/design.html) - Feature Design Documents

FHS style packaging
-------------------

389 can be built to use FHS style, /opt FHS style, or user specified prefix - see [FHS Packaging](development/fhs-packaging.html)

Directory Server Plugins
------------------------

It is possible to write plugins that allow you to extend the functionality of the Directory Server. Our [plugins](design/plugins.html) page contains information on the API and the scope of the functionality. You might also want to look at our [annotated license](FAQ/annotated-gpl-exception-license.html) page for some legal information on using the plugin api.

Release Engineering
-------------------

[Release Procedure](development/release-procedure.html)

Nightly Builds
--------------

[Nightly Builds](development/nightly-builds.html)

Testing
-------

Not a coder? No problem. You can help by finding new [bugs](FAQ/bugs.html), verifying existing bugs, polishing [documentation](documentation.html) and generally improving the quality of the server.

A good way to contribute to improving the quality of the server would be to add automated tests for each of the features. Developers and contributors to the 389 Project are encouraged to write unit tests for any new features, updates and bug fixes being contributed. Where possible, the tests should be data driven. This allows for greater numbers of test cases covering more of the feature under test, to be written with minimal effort. We suggest tests be written in a scripting language like python, sh, or Perl ( Perl::Test ).

There are a number of other LDAP test tools available from other groups and companies which may be of interest:

-   [DirectoryMark](http://www.mindcraft.com/directorymark) from Mindcraft, is an LDAP benchmarking tool
-   [Slamd](http://www.slamd.com/) is a distributed LDAP load generation engine
-   [Using SystemTap](howto/howto-use-systemtap.html) - an example of using SystemTap to profile thread contention

If you know python, you can add to the *Continuous Integration Testing Framework (lib389)*, and help make the product more stable, and have less regressions in new releases.

-    [Upstream Testing Framework](FAQ/upstream-test-framework.html)

What can you do?
----------------

-   [How to contribute](FAQ/ways-to-contribute.html)
-   [Roadmap](FAQ/roadmap.html)
-   Timelines
-   [Wishlist](FAQ/wishlist.html)
-   [History](FAQ/history.html)
-   [File bugs](FAQ/bugs.html)

Contributors
------------

-   [Mailing Lists, IRC](mailing-lists.html)
-   [389 Trac instance](FAQ/bugs.html)
-   Players (people involved)

