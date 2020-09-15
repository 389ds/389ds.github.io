---
title: "Releases/1.3.5.17"
---
389 Directory Server 1.3.5.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.17.

Fedora packages are available from the Fedora 24, and 25.

The new packages and versions are:

-   389-ds-base-1.3.5.17-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.17.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.17

-   Security fix, Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.15-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump version to 1.3.5.17
- Issue 49221 - During an upgrade the provided localhost name is ignored
- Issue 49220 - Fix for cve 2017-2668 - Remote crash via crafted LDAP messages
- Issue 49210 - Fix regression when checking is password min  age should be checked
- Issue 49205 - Fix logconv.pl man page
- Issue 49035 - dbmon.sh shows pages-in-use that exceeds the cache size
- Issue 49039 - password min age should be ignored if password needs to be reset

