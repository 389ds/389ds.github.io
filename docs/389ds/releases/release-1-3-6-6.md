---
title: "Releases/1.3.6.6"
---
389 Directory Server 1.3.6.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.6

Fedora packages are available from the Fedora 26 and Rawhide repositories.

https://bodhi.fedoraproject.org/updates/FEDORA-2017-8ab2f264a3

The new packages and versions are:

-   389-ds-base-1.3.6.6-1  Fedora 26
-   389-ds-base-1.3.6.6-2  Rawhide(F27)

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.6.6.tar.bz2)

### Highlights in 1.3.6.6

-   Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.3.6.6-1
- Ticket 49157 - fix error in ds-logpipe.py
- Ticket 48864 - remove config.h from spal header.
- Ticket 48681 - logconv.pl - Fix SASL Bind stats and rework report format
- Ticket 49261 - Fix script usage and man pages
- Ticket 49238 - AddressSanitizer: heap-use-after-free in libreplication
- Ticket 48864 - Fix FreeIPA build
- Ticket 49257 - Reject dbcachesize updates while auto cache sizing is enabled
- Ticket 49249 - cos_cache is erroneously logging schema checking failure
- Ticket 49258 - Allow nsslapd-cache-autosize to be modified while the server is running
- Ticket 49247 - resolve build issues on debian
- Ticket 49246 - ns-slapd crashes in role cache creation
- Ticket 49157 - ds-logpipe.py crashes for non-existing users
- Ticket 49241 - Update man page and usage for db2bak.pl
- Ticket 49075 - Adjust logging severity levels
- Ticket 47662 - db2index not properly evaluating arguments
- Ticket 48989 - fix perf counters



