---
title: "Releases/1.3.6.4"
---
389 Directory Server 1.3.6.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.4

Fedora packages are available from the Fedora 26 and Rawhide repositories.

https://bodhi.fedoraproject.org/updates/FEDORA-2017-7f0a10c808

The new packages and versions are:

-   389-ds-base-1.3.6.4-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.4.tar.bz2)

### Highlights in 1.3.6.4

-   Security fix, Bug fixes, and enhancements

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

- Bump verson to 1.3.6.4-1
- Ticket 49228 - Fix SSE4.2 detection.
- Ticket 49229 - Correct issues in latest commits
- Ticket 49226 - Memory leak in ldap-agent-bin
- Ticket 49214 - Implement htree concept
- Ticket 49119 - Cleanup configure.ac options and defines
- Ticket 49097 - whitespace fixes for pblock change
- Ticket 49097 - Pblock get/set cleanup
- Ticket 49222 - Resolve various test issues on rawhide
- Issue 48978 - Fix the emergency logging functions severity levels
- Issue 49227 - ldapsearch for nsslapd-errorlog-level returns  incorrect values
- Ticket 49041 - nss won't start if sql db type set
- Ticket 49223 - Fix sds queue locking
- Issue 49204 - Fix 32bit arch build failures
- Issue 49204 - Need to update function declaration
- Ticket 49204 - Fix lower bounds on import autosize + On small VM, autotune breaks the access of the suffixes
- Issue 49221 - During an upgrade the provided localhost name is ignored
- Issue 49220 - Remote crash via crafted LDAP messages (SECURITY FIX)
- Ticket 49184 - Overflow in memberof
- Ticket 48050 - Add account policy tests to plugins test suite
- Ticket 49207 - Supply docker POC build for DS.
- Issue 47662 - CLI args get removed
- Issue 49210 - Fix regression when checking is password min  age should be checked
- Ticket 48864 - Add cgroup memory limit detection to 389-ds
- Issue 48085 - Expand the repl acceptance test suite
- Ticket 49209 - Hang due to omitted replica lock release
- Ticket 48864 - Cleanup memory detection before we add cgroup support
- Ticket 48864 - Cleanup up broken format macros and imports
- Ticket 49153 - Remove vacuum lock on transaction cleanup
- Ticket 49200 - provide minimal dse.ldif for python installer
- Issue 49205 - Fix logconv.pl man page
- Issue 49177 - Fix pkg-config file
- Issue 49035 - dbmon.sh shows pages-in-use that exceeds the cache size
- Ticket 48432 - Linux capabilities on ns-slapd
- Ticket 49196 - Autotune generates crit messages
- Ticket 49194 - Lower default ioblock timeout
- Ticket 49193 - gcc7 warning fixes
- Issue 49039 - password min age should be ignored if password needs to be reset
- Ticket 48989 - Re-implement lock counter
- Issue 49192 - Deleting suffix can hang server
- Issue 49156 - Modify token :assert: to :expectedresults:
- Ticket 48989 - missing return in counter
- Ticket 48989 - Improve counter overflow fix
- Ticket 49190 - Upgrade lfds to 7.1.1
- Ticket 49187 - Fix attribute definition
- Ticket 49185 - Fix memleak in compute init




