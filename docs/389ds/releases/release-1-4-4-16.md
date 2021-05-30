---
title: "Releases/1.4.4.16"
---

389 Directory Server 1.4.4.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.16

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=69004283> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-67a3b7ca78> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.16-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.16.tar.gz)

### Highlights in 1.4.4.16

- Bug and Security fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install the server use **dnf install 389-ds-base**

To install the Cockpit UI plugin use **dnf install cockpit-389-ds**

After rpm install completes, run **dscreate interactive**

For upgrades, simply install the package.  There are no further steps required.

There are no upgrade steps besides installing the new rpms

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation and setup

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.4.16
- Issue 4711 - SECURITY FIX - SIGSEV with sync_repl (#4738)
- Issue 4778 - RFE - Allow setting TOD for db compaction and add task
- Issue 4623 - RFE - Monitor the current DB locks (#4762)
- Issue 4725 - RFE - Update the password policy to support a Temporary Password Rules (#4727)
- Issue 4701 - RFE - Exclude attributes from retro changelog (#4723)
- Issue 4773 - RFE - Enable interval feature of DNA plugin
- Issue 4719 - lib389 - fix dsconf passthrough auth bugs
- Issue 4764 - replicated operation sometime checks ACI (#4783)
- Issue 4781 - There are some typos in man-pages
- Issue 3555 - Fix UI audit issue
- Issue 4747 - Remove unstable/unstatus tests from PRCI (#4748)
- Issue 4725 - Fix compiler warnings
- Issue 4770 - Lower FIPS logging severity
- Issue 4759 - Fix coverity issue (#4760)
- Issue 4742 - UI - should always use LDAPI path when calling CLI
- Issue 4667 - incorrect accounting of readers in vattr rwlock (#4732)
- Issue 4637 - ndn cache leak (#4724)
- Issue 4577 - Fix ASAN flags in specfile

