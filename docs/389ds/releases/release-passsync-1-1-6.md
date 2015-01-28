---
title: "Releases/PassSync-1.1.6"
---
389 Directory Password Synchronization 1.1.6
--------------------------------------------

The 389 Directory Server team is proud to announce 389-Passsync version 1.1.6.

389 Directory Password Synchronization packages are available from the [download page](http://directory.fedoraproject.org/wiki/Download#Windows_Password_Synchronization). We encourage you to test and provide feedback to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>.

The new packages and versions are:

-   389-PassSync-1.1.6

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-passsync-1.1.6.tar.bz2)

### Highlights in 1.1.6

PassSync 1.1.6 supports TLS version 1.1 and newer SSL versions supported by NSS.  
SSLv3 is disabled, by default.  To force to enable SSLv3.0, an environment variable
LDAPSSL_ALLOW_OLD_SSL_VERSION has to be set with some non NULL value.

In Computer | Properties | Advanced system settings | Environment Variables | System variables,
add variable: LDAPSSL_ALLOW_OLD_SSL_VERSION, value: 1

### Installation and Upgrade

See [Download](../download.html) for information about installation and upgrade.

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.1.5

-   Support TLS version 1.1 and newer SSL versions supported by NSS

