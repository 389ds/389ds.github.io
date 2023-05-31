---
title: "Releases/2.0.6"
---

389 Directory Server 2.0.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.6

Fedora packages are available on Fedora 34 and Rawhide

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=70696310> - Koji
<https://bodhi.fedoraproject.org/updates/FEDORA-2021-6cec1584ab> - Bodhi

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=70730267> - Koji


The new packages and versions are:

- 389-ds-base-2.0.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.6.tar.gz)

### Highlights in 2.0.6

- Bug & security fixes

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

- Bump version to 2.0.6
- Issue 4803 - Improve DB Locks Monitoring Feature Descriptions
- Issue 4803 - Improve DB Locks Monitoring Feature Descriptions (#4810)
- Issue 4169 - UI - Migrate Typeaheads to PF4 (#4808)
- Issue 4414 - disk monitoring - prevent division by zero crash
- Issue 4788 - CLI should support Temporary Password Rules attributes (#4793)
- Issue 4656 - Fix replication plugin rename dependency issues
- Issue 4656 - replication name change upgrade code causes crash with dynamic plugins
- Issue 4506 - Improve SASL logging
- Issue 4709 - Fix double free in dbscan
- Issue 4093 - Fix MEP test case
- Issue 4747 - Remove unstable/unstatus tests (followup) (#4809)
- Issue 4791 - Missing dependency for RetroCL RFE (#4792)
- Issue 4794 - BUG - don't capture container output (#4798)
- Issue 4593 - Log an additional message if the server certificate nickname doesn't match nsSSLPersonalitySSL value
- Issue 4797 - ACL IP ADDRESS evaluation may corrupt c_isreplication_session connection flags (#4799)
- Issue 4169 - UI Migrate checkbox to PF4 (#4769)
- Issue 4447 - Crash when the Referential Integrity log is manually edited
- Issue 4773 - Add CI test for DNA interval assignment
- Issue 4789 - Temporary password rules are not enforce with local password policy (#4790)
- Issue 4379 - fixing regression in test_info_disclosure
- Issue 4379 - Allow more than 1 empty AttributeDescription for ldapsearch, without the risk of denial of service
- Issue 4379 - Allow more than 1 empty AttributeDescription for ldapsearch, without the risk of denial of service
- Issue 4575 Update test docstrings metadata
- Issue 4753 - Adjust our tests to 389-ds-base-snmp missing in RHEL 9 Appstream
- removed the snmp_present() from utils.py as we have get_rpm_version() in conftest.py
- Issue 4753 - Adjust our tests to 389-ds-base-snmp missing in RHEL 9 Appstream

