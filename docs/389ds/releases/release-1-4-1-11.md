---
title: "Releases/1.4.1.11"
---

389 Directory Server 1.4.1.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.1.11

Fedora packages are available on Fedora 30.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=39454357> - Fedora 30

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2019-785461dc7e> - Fedora 30

The new packages and versions are:

- 389-ds-base-1.4.1.11-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.1.11.tar.bz2)

### Highlights in 1.4.1.11

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

|Configuration Tab|Functional|Written in ReactJS |
|-----------------|----------|-------------------|
|Server Tab       |Yes       |No                 |
|Security Tab     |Yes       |Yes                |
|Database Tab     |Yes       |Yes                |
|Replication Tab  |Yes       |Yes                |
|Schema Tab       |Yes       |No (coming soon)   |
|Plugin Tab       |Yes       |Yes                |
|Monitor Tab      |Yes       |Yes                |

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.1.11
- Issue 50499 - Fix npm audit issues
- Issue 50753 - Dumping the changelog to a file doesn't work
- Issue 50734 - lib389 creates non-SSCA cert DBs with misleading README.txt
- Issue 50736 - RetroCL trimming may crash at shutdown if trimming configuration is invalid
- Issue 50439 - Update docker integration for Fedora
- Issue 50747 - Port readnsstate to dsctl
- Issue 50745 - ns-slapd hangs during CleanAllRUV tests
- Issue 50758 - Enable CLI arg completion
- Issue 50701 - Fix type in lint report
- Issue 50701 - Add additional healthchecks to dsconf
- Issue 50711 - 'dsconf security' lacks option for setting nsTLSAllowClientRenegotiation attribute
- Issue 50499 - Fix npm audit issues
- Issue 50634 - Fix CLI error parsing for non-string values



