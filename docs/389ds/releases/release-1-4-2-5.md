---
title: "Releases/1.4.2.5"
---

389 Directory Server 1.4.2.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.2.5

Fedora packages are available on Fedora 31 and rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39454569> - Rawhide

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39454576> - Fedora 31

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-ad190c32de>

The new packages and versions are:

- 389-ds-base-1.4.2.5-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.2.5.tar.bz2)

### Highlights in 1.4.2.5

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

### New UI Progress (Cockpit plugin)

The new UI is fully functional.  There are still parts that need to be converted to ReactJS, but every feature is available.

|Configuration Tab  |Functional  |Written in ReactJS |
|-------------------|------------|-------------------|
|Server Tab         |Yes         |No                 |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |No (coming soon)   |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.2.5
- Issue 50747 - Port readnsstate to dsctl
- Issue 50758 - Enable CLI arg completion
- Issue 50753 - Dumping the changelog to a file doesn't work
- Issue 50745 - ns-slapd hangs during CleanAllRUV tests
- Issue 50734 - lib389 creates non-SSCA cert DBs with misleading README.txt
- Issue 48851 - investigate and port TET matching rules filter tests(cert)
- Issue 50443 - Create a module in lib389 to Convert a byte sequence to a properly escaped for LDAP
- Issue 50664 - DS can fail to recover if an empty directory exists in db
- Issue 50736 - RetroCL trimming may crash at shutdown if trimming configuration is invalid
- Issue 50741 - bdb_start - Detected Disorderly Shutdown last time Directory Server was running
- Issue 50572 - After running cl-dump dbdir/cldb/*ldif.done are not deleted
- Issue 50701 - Fix type in lint report
- Issue 50729 - add support for gssapi tests on suse
- Issue 50701 - Add additional healthchecks to dsconf
- Issue 50711 - 'dsconf security' lacks option for setting nsTLSAllowClientRenegotiation attribute
- Issue 50439 - Update docker integration for Fedora
- Issue 48851 - Investigate and port TET matching rules filter tests(last test cases for match)
- Issue 50499 - Fix npm audit issues
- Issue 50722 - Test IDs are not unique
- Issue 50712 - Version comparison doesn't work correctly on git builds
- Issue 50499 - Fix npm audit issues
- Issue 50706 - Missing lib389 dependency - packaging



