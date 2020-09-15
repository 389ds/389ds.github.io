---
title: "Releases/1.4.0.14"
---

389 Directory Server 1.4.0.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.0.14

Fedora packages are available on Fedora 28 and 29(rawhide).

Rawhide(F29)

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28969308>

F28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28970373>

The new packages and versions are:

- 389-ds-base-1.4.0.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.0.14.tar.bz2)

### Highlights in 1.4.0.14

Bug fixes and security fix

### Installation and Upgrade 

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **dnf install 389-ds-base**, then run **dscreate**.  For Cockput UI plugin use "dnf install cockpit-389-ds"

See [Install\_Guide](../howto/howto-install-389.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.4.0.14
- Ticket 49891 - Use "__python3" macro for python scripts
- Ticket 49890 - SECURITY FIX - ldapsearch with server side sort crashes the ldap server
- Ticket 49029 - RFE -improve internal operations logging
- Ticket 49893 - disable nunc-stans by default
- Ticket 48377 - Update file name for LD\_PRELOAD
- Ticket 49884 - Improve nunc-stans test to detect socket errors sooner
- Ticket 49888 - Use perl filter in rpm specfile
- Ticket 49866 - Add password policy features to CLI/UI
- Ticket 49881 - Missing check for crack.h
- Ticket 48056 - Add more test cases to the basic suite
- Ticket 49761 - Fix replication test suite issues
- Ticket 49381 - Refactor the plugin test suite docstrings
- Ticket 49837 - Add new password policy attributes to UI
- Ticket 49794 - RFE - Add pam_pwquality features to password syntax checking
- Ticket 49867 - Fix CLI tools' double output


