---
title: "Releases/2.0.10"
---

389 Directory Server 2.0.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.10

Fedora packages are available on Fedora 34 and Rawhide

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=76007874> - Koji

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=76009801> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-702e5d17e2> - Bodhi

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=76011441> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-e763069c23> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.10-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.10.tar.gz)

### Highlights in 2.0.10

- Bug fixes
- Cockpit UI fully migrated to Patternfly 4

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

- Bump version to 2.0.10
- Issue 4908 - Updated several dsconf --help entries (typos, wrong descriptions, etc.)
- Issue 4912 - Account Policy plugin does not set the config entry DN
- Issue 4863 - typos in logconv.pl
- Issue 4796 - Add support for nsslapd-state to CLI & UI
- Issue 4894 - IPA failure in ipa user-del --preserve (#4907)
- Issue 4912 - dsidm command crashing when account policy plugin is enabled
- Issue 4910 - db reindex corrupts RUV tombstone nsuiqueid index
- Issue 4869 - Fix retro cl trimming misuse of monotonic/realtime clocks
- Issue 4887 - UI - fix minor regression from camelCase fixup


