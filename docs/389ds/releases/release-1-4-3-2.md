---
title: "Releases/1.4.3.2"
---

389 Directory Server 1.4.3.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.3.2

Fedora packages are available on rawhide.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=40928882> - Rawhide


The new packages and versions are:

- 389-ds-base-1.4.3.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.3.2.tar.bz2)

### Highlights in 1.4.3.2

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
|Server Tab         |Yes         |No (coming soon)   |
|Security Tab       |Yes         |Yes                |
|Database Tab       |Yes         |Yes                |
|Replication Tab    |Yes         |Yes                |
|Schema Tab         |Yes         |Yes                |
|Plugin Tab         |Yes         |Yes                |
|Monitor Tab        |Yes         |Yes                |


### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Pagure project: <https://pagure.io/389-ds-base>

- Bump version to 1.4.3.2
- Issue 49254 - Fix compiler failures and warnings
- Issue 50741 - cont bdb_start - Detected Disorderly Shutdown
- Issue 50836 - Port Schema UI tab to React
- Issue 50842 - Decrease 389-console Cockpit component size
- Issue 50790 - Add result text when filter is invalid
- Issue 50627 - Add ASAN logs to HTML report
- Issue 50834 - Incorrectly setting the NSS default SSL version max
- Issue 50829 - Disk monitoring rotated log cleanup causes heap-use-after-free
- Issue 50709 - (cont) Several memory leaks reported by Valgrind for 389-ds 1.3.9.1-10
- Issue 50784 - performance testing scripts
- Issue 50599 - Fix memory leak when removing db region files
- Issue 49395 - Set the default TLS version min to TLS1.2
- Issue 50818 - dsconf pwdpolicy get error
- Issue 50824 - dsctl remove fails with "name 'ensure_str' is not defined"
- Issue 50599 - Remove db region files prior to db recovery
- Issue 50812 - dscontainer executable should be placed under /usr/libexec/dirsrv/
- Issue 50816 - dsconf allows the root password to be set to nothing
- Issue 50798 - incorrect bytes in format string(fix import issue)

