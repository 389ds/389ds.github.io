---
title: "Releases/1.3.5.14"
---
389 Directory Server 1.3.5.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.14.

Fedora packages are available from the Fedora 24, 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.14-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.5.14.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.14

-   A security bug fix and lots of bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.14-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>
- Ticket 48992 - Total init may fail if the pushed schema is rejected
- Ticket 48832 - Fix CI test suite for password min age
- Ticket 48983 - Configure and Makefile.in from new default paths work.
- Ticket 48983 - Configure and Makefile.in from new default paths work.
- Ticket 48983 - generate install path info from autotools scripts
- Ticket 48944 - on a read only replica invalid state info can accumulate
- Ticket 48766 - use a consumer maxcsn only as anchor if supplier is more advanced
- Ticket 48921 - CI Replication stress tests have limits set too low
- Ticket 48969 - nsslapd-auditfaillog always has an explicit path
- Ticket 48957 - Update repl-monitor to handle new status messages
- Ticket 48832 - Fix CI tests
- Ticket 48975 - Disabling CLEAR password storage scheme will  crash server when setting a password
- Ticket 48369 - Add CI test suite
- Ticket 48970 - Serverside sorting crashes the server
- Ticket 48972 - remove old pwp code that adds/removes ACIs
- Ticket 48957 - set proper update status to replication  agreement in case of failure
- Ticket 48950 - Add systemd warning to the LD_PRELOAD example in /etc/sysconfig/dirsrv
- provide backend dir in suffix template
- Ticket 48953 - Skip labelling and unlabelling ports during the test
- Ticket 48967 - Add CI test and refactor test suite
- Ticket 48967 - passwordMinAge attribute doesn't limit the minimum age of the password
- Fix jenkins warnings about unused vars
- Ticket 48402 - v3 allow plugins to detect a restore or import
- Ticket #48969 - nsslapd-auditfaillog always has an explicit path
- Ticket 48964 - cleanAllRUV changelog purging incorrectly  processes all backends
- Ticket 48965 - Fix building rpms using rpm.mk
- Ticket 48965 - Fix generation of the pre-release version
- Bugzilla 1368956 - man page of ns-accountstatus.pl shows redundant entries for -p port option
- Ticket 48960 - Crash in import_wait_for_space_in_fifo().
- Ticket 48832 - Fix more CI test failures
- Ticket 48958 - Audit fail log doesn't work if audit log disabled.
- Ticket 48956 - ns-accountstatus.pl showing "activated" user even if it is inactivated
- Ticket 48954 - replication fails because anchorcsn cannot be found
- Ticket 48832 - Fix CI tests failures from jenkins server
- Ticket 48950 - Change example in /etc/sysconfig/dirsrv to use tcmalloc


