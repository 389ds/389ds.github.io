---
title: "Releases/1.4.3.24"
---

389 Directory Server 1.4.3.24
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.24

Fedora packages are available on Fedora 32.

<> - Fedora 32

<> - Bodhi


The new packages and versions are:

- 389-ds-base-1.4.3.24-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.3.24.tar.gz)

### Highlights in 1.4.3.24

- Bug fixes

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

- Bump version to 1.4.3.24
- Issue 4719 - lib389 - fix dsconf passthrough auth bugs
- Issue 4778 - RFE - Add changelog compaction task in 1.4.3
- Issue 4778 - RFE - Allow setting TOD for db compaction and add task
- Issue 4764 - replicated operation sometime checks ACI (#4783)
- Issue 4623 - RFE - Monitor the current DB locks (#4762)
- Issue 4781 - There are some typos in man-pages
- Issue 4773 - Enable interval feature of DNA plugin
- Issue 51175 - resolve plugin name leaking
- Issue 4421 - Unable to build with Rust enabled in closed environment
- Issue 4498 - BUG - entryuuid replication may not work (#4503)
- Issue 4326 - entryuuid fixup did not work correctly (#4328)
- Issue 137 - Implement EntryUUID plugin
- Issue 3555 - Fix UI audit issue
- Issue 4747 - Remove unstable/unstatus tests from PRCI (#4748)
- Issue 4725 - Fix compiler warnings
- Issue 4770 - Lower FIPS logging severity

