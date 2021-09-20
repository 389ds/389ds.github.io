---
title: "Releases/1.4.4.17"
---

389 Directory Server 1.4.4.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.17

Fedora packages are available on Fedora 33.

Fedora 33:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=76027095> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-1c2247a1ec> - Bohdi


The new packages and versions are:

- 389-ds-base-1.4.4.17-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-1.4.4.17.tar.gz)

### Highlights in 1.4.4.17

- Bug fixes
- Cockpit UI migrated to Patternfly 4 (fixed all security vulnerabilities)

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

- Bump version to 1.4.4.17
- Issue 4927 - rebase lib389 and cockpit in 1.4.4
- Issue 4908 - Updated several dsconf --help entries (typos, wrong descriptions, etc.)
- Issue 4912 - Account Policy plugin does not set the config entry DN
- Issue 4796 - Add support for nsslapd-state to CLI & UI
- Issue 4894 - IPA failure in ipa user-del --preserve (#4907)
- Issue 4169 - backport lib389 cert list fix
- Issue 4912 - dsidm command crashing when account policy plugin is enabled
- Issue 4910 - db reindex corrupts RUV tombstone nsuiqueid index
- Issue 4869 - Fix retro cl trimming misuse of monotonic/realtime clocks
- Issue 4696 - Password hash upgrade on bind (#4840)
- Issue 4875 - CLI - Add some verbosity to installer
- Issue 4884 - server crashes when dnaInterval attribute is set to zero
- Issue 4877 - RFE - EntryUUID to validate UUIDs on fixup (#4878)
- Issue 4734 - import of entry with no parent warning (#4735)
- Issue 4872 - BUG - entryuuid enabled by default causes replication issues (#4876)
- Issue 4763 - Attribute Uniqueness Plugin uses wrong subtree on ModRDN (#4871)
- Issue 4851 - Typos in "dsconf pwpolicy set --help" (#4867)
- Issue 4736 - lib389 - fix regression in certutil error checking
- Issue 4736 - CLI - Errors from certutil are not propagated
- Issue 4460 - Fix isLocal and TLS paths discovery (#4850)
- Issue 4443 - Internal unindexed searches in syncrepl/retro changelog
- Issue 4817 - BUG - locked crypt accounts on import may allow all passwords (#4819)
- Issue 4656 - (2nd) Remove problematic language from UI/CLI/lib389
- Issue 4262 - Fix Index out of bound in fractional test (#4828)
- Issue 4822 - Fix CI temporary password: fixture leftover breaks them (#4823)
- Issue 4656 - remove problematic language from ds-replcheck
- Issue 4803 - Improve DB Locks Monitoring Feature Descriptions
- Issue 4803 - Improve DB Locks Monitoring Feature Descriptions (#4810)
- Issue 4788 - CLI should support Temporary Password Rules attributes (#4793)
- Issue 4506 - Improve SASL logging
- Issue 4093 - Fix MEP test case
- Issue 4747 - Remove unstable/unstatus tests (followup) (#4809)
- Issue 4789 - Temporary password rules are not enforce with local password policy (#4790)
- Issue 4797 - ACL IP ADDRESS evaluation may corrupt c_isreplication_session connection flags (#4799)
- Issue 4447 - Crash when the Referential Integrity log is manually edited
- Issue 4773 - Add CI test for DNA interval assignment
- Issue 4750 - Fix compiler warning in retrocl (#4751)

