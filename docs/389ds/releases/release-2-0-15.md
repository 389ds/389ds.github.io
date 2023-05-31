---
title: "Releases/2.0.15"
---

389 Directory Server 2.0.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.15

Fedora packages are available on Fedora 34, and 35

Fedora 35: 

<https://koji.fedoraproject.org/koji/taskinfo?taskID=84608760> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-40544b5314> - Bodhi

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=84609037> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-2558f14c58> - Bodhi

The new packages and versions are:

- 389-ds-base-2.0.15-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.15.tar.gz)

### Highlights in 2.0.15

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

- Bump version to 2.0.15
- Issue 5230 - Race condition in RHDS disk monitoring functions
- Issue 4299 - UI - Add CoS funtionality (#5196)
- Issue 5225 - UI - impossible to manually set entry cache
- Issue 5186 - UI - Fix SASL Mapping regex test feature
- Issue 5221 - User with expired password can still login with full privledges
- Issue 5218 - double-free of the virtual attribute context in persistent search (#5219)
- Issue 5200 - dscontainer should use environment variables with DS_ prefix
- Issue 5193 - Incomplete ruv occasionally returned from ruv search (#5194)
- Issue 5189 - memberOf plugin exclude subtree not cleaning up groups on modrdn
- Issue 5188 - UI - LDAP editor - add entry and group types
- Issue 5184 - memberOf does not work correctly with multiple include scopes
- Issue 5162 - BUG - error on importing chain files (#5164)
- Issue 5186 - UI - Fix SASL Mapping regex validation and other minor improvements
- Issue 5048 - Support for nsslapd-tcp-fin-timeout and nsslapd-tcp-keepalive-time (#5179)
- Issue 5122 - dsconf instance backend suffix set doesn't accept backend name (#5178)
- Issue 5160 - BUG - x- prefix in descr-oid can confuse oid parser (#5161)
- Issue 5098 - Multiple issues around replication and CI test test_online_reinit_may_hang (#5109)
- Issue 5102 - BUG - container may fail with bare uid/gid (#5140)
- Issue 5137 - RFE - improve sssd conf output (#5138)
- Issue 5145 - Fix covscan errors
- Issue 4721 - UI - attribute uniqueness crashes UI when there are no configs
- Issue 5155 - RFE - Provide an option to abort an Auto Member rebuild task
- Issue 4299 - UI - Add Role funtionality (#5163)
- Issue 5050 - bdb bulk op fails if fs page size > 8K (#5150)
- Issue 4775 - Add entryuuid CLI and Fixup (#4776)
- Issue 5142 - CLI - dsctl dbgen is broken
- Issue 4299 - UI - fix minor issues with ldap editor (table view)
- Issue 4299 - UI - fix minor issues with ldap editor
- Issue 5103 - UI - Add support for TPR to web console (#5111)

