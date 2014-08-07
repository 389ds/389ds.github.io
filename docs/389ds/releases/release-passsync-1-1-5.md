---
title: "Releases/PassSync-1.1.5"
---
389 Directory Password Synchronization 1.1.5
--------------------------------------------

The 389 Directory Server team is proud to announce 389-Passsync version 1.1.5.

389 Directory Password Synchronization packages are available from the [download page](http://directory.fedoraproject.org/wiki/Download#Windows_Password_Synchronization). We encourage you to test and provide feedback to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>.

The new packages and versions are:

-   389-PassSync-1.1.5

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-passsync-1.1.5.tar.bz2)

### Highlights in 1.1.5

Fixed following 4 bugs.

-   If a password set on the Active Directory contains 8-th bit characters, the characters were incorrectly synchronized to the Directory Server.
-   If a user was inactivated, resetting the user's password put the password synchronization in the endless loop.
-   The timing of abandoning old password was after replaying the modify, which could have synchronized old password unexpectedly.
-   PassSync service failed to open changelog if the changelog did not exist first then got generated.

### Installation and Upgrade

See [Download](../download.html) for information about installation and upgrade.

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.1.4

-   bump verison to 1.1.5
-   Ticket \#363 - Passsync/Winsync handles passwords with 8-th bit characters incorrectly
-   ticket 47352 - Abandon old password changes prior to syncing
-   Ticket \#47351 - Passsync loops when updating password of locked user
-   Ticket \#47357 - Update the PassSync build environment
-   Ticket \#47353 - PassSync fails to open changelog

