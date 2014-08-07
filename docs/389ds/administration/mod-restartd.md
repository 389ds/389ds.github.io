---
title: "Mod restartd"
---

# Mod restartd
--------------

What is mod\_restartd?
----------------------

mod\_restartd is an Apache module that allows CGIs to start up our servers as root. By default, Apache does not run as root (and for good reason). However, the management console and the Admin Express web app have CGIs that allow the administrator to start and restart the directory server listening on port 389. But only root (or init) may access port numbers \< 1024. mod\_restartd is a slight change to the regular Apache mod\_cgid to allow root to run a severely limited number of CGIs as the root user.

Where can I get it?
-------------------

This is included in the admin server source tarball at [Source](../development/source.html). To check out the source anonymously use

` CVSROOT=:pserver:anonymous@cvs.fedoraproject.org:/cvs/dirsec ; export CVSROOT`
` cvs login`

(password is empty i.e. just press Enter or Return)

If you have commit access, use

` CVSROOT=:ext:yourlogin@cvs.fedoraproject.org:/cvs/dirsec ; export CVSROOT`

You will have to apply for commit access - see our [contributing](../development/contributing.html) page on more information on how to get CVS commit access.

Now you're ready to pull the source:

`cvs -z3 co -r RELEASETAG mod_restartd`

The current release tag is FedoraDirSvrAdmin112

How do I build it?
------------------

mod\_restartd is built as part of the Admin Server build - see [AdminServer](adminserver.html) for more information.
