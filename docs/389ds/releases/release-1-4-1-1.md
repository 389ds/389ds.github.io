---
title: "Releases/1.4.1.1"
---

389 Directory Server 1.4.1.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.1

Fedora packages are available on Fedora 28(rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=32348343>   - Fedora 30 (rawhide)

The new packages and versions are:

-   389-ds-base-1.4.1.1-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.1.tar.bz2)

### Highlights in 1.4.1.1

- Version change

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base cockpit-389-ds**  After install completes, run **dscreate interactive**

There are no upgrade steps besides installing the new rpms 

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

-  Bump version to 1.4.1.1
-  Ticket 50151 - lib389 support cli add/replace/delete on objects
-  Ticket 50041 - CLI and WebUI - Add memberOf plugin functionality
-  Rebased from 389-ds-base-1.4.0.20-1


