---
title: "Mod admserv"
---

# Mod admserv
-------------

What is mod\_admserv?
---------------------

mod\_admserv is the replacement for the Netscape Enterprise Server adminserver plug-in, re-written as a module for the [Apache](http://httpd.apache.org) web server. It performs LDAP based authentication using its corresponding Configuration Directory Server, providing authentication services for the console and for the Admin Server web based applications. It also does access control - all CGIs and tasks are modeled as entries in the directory (under o=NetscapeRoot), so the regular Directory Server access control mechanisms are used to allow/deny access to CGIs and console tasks. It does not use mod\_authz\_ldap but instead has it's own LDAP functionality using the Mozilla LDAP C SDK.

Where can I get it?
-------------------

This is included in the admin server source tarball at [Source](../development/source.html). To check out the source anonymously use

    CVSROOT=:pserver:anonymous@cvs.fedoraproject.org:/cvs/dirsec ; export CVSROOT
    cvs login

(password is empty i.e. just press Enter or Return)

If you have commit access, use

    CVSROOT=:ext:yourlogin@cvs.fedoraproject.org:/cvs/dirsec ; export CVSROOT

You will have to apply for commit access - see our [contributing](../development/contributing.html) page on more information on how to get CVS commit access.

Now you're ready to pull the source:

    cvs -z3 co -r RELEASETAG mod_admserv

The current release tag is FedoraDirSvrAdmin112

How do I build it?
------------------

mod\_admserv is built as part of the Admin Server build - see [AdminServer](adminserver.html) for more information.
