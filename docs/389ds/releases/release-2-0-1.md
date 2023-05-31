---
title: "Releases/2.0.1"
---

389 Directory Server 2.0.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.1

Fedora packages are available on Rawhide (Fedora 34).


Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=54870733>


The new packages and versions are:

- 389-ds-base-2.0.1-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.1.tar.gz)

### Highlights in 2.0.1

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

- Bump version to 2.0.1
- Issue 4420 - change NVR to use X.X.X instead of X.X.X.X
- Issue 4391 - DSE config modify does not call be_postop (#4394)
- Issue 4218 - Verify the new wtime and optime access log keywords (#4397)
- Issue 4176 - CL trimming causes high CPU
- Issue 2058 - Add keep alive entry after on-line initialization - second version (#4399)
- Issue 4403 - RFE - OpenLDAP pw hash migration tests (#4408)


