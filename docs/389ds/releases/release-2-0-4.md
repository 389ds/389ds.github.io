---
title: "Releases/2.0.4"
---

389 Directory Server 2.0.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.0.4

Fedora packages are available on Fedora 34 and Rawhide

Fedora 34:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=65380611> - Koji

<https://bodhi.fedoraproject.org/updates/FEDORA-2021-123ca32c27> - Bohdi


The new packages and versions are:

- 389-ds-base-2.0.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.0.4.tar.gz)

### Highlights in 2.0.4

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

- Bump version to 2.0.4
- Issue 4680 - 389ds coredump (@389ds/389-ds-base-nightly) in replica install with CA (#4715)
- Issue 3965 - RFE - Implement the Password Policy attribute "pwdReset" (#4713)
- Issue 4700 - Regression in winsync replication agreement (#4712)
- Issue 3965 - RFE - Implement the Password Policy attribute "pwdReset" (#4710)
- Issue 4169 - UI - migrate monitor tables to PF4
- issue 4585 - backend redesign phase 3c - dbregion test removal (#4665)
- Issue 2736 - remove remaining perl references
- Issue 2736 - https://github.com/389ds/389-ds-base/issues/2736
- Issue 4706 - negative wtime in access log for CMP operations
- Issue 3585 - LDAP server returning controltype in different sequence
- Issue 4127 - With Accounts/Account module delete fuction is not working (#4697)
- Issue 4666 - BUG - cb_ping_farm can fail with anonymous binds disabled (#4669)
- Issue 4671 - UI - Fix browser crashes
- Issue 4169 - UI - Add PF4 charts for server stats
- Issue 4648 - Fix some issues and improvement around CI tests (#4651)
- Issue  4654  Updates to tickets/ticket48234_test.py  (#4654)
- Issue 4229 - Fix Rust linking
- Issue 4673 - Update Rust crates
- Issue 4658 - monitor - connection start date is incorrect
- Issue 4169 - UI - migrate modals to PF4
- Issue 4656 - remove problematic language from ds-replcheck
- Issue 4459 - lib389 - Default paths should use dse.ldif if the server is down
- Issue 4656 - Remove problematic language from UI/CLI/lib389
- Issue 4661 - RFE - allow importing openldap schemas (#4662)
- Issue 4659 - restart after openldap migration to enable plugins (#4660)
- Merge pull request #4664 from mreynolds389/issue4663
- issue 4552 - Backup Redesign phase 3b - use dbimpl in replicatin plugin (#4622)
- Issue 4643 - Add a tool that generates Rust dependencies for a specfile (#4645)
- Issue 4646 - CLI/UI - revise DNA plugin management
- Issue 4644 - Large updates can reset the CLcache to the beginning of the changelog (#4647)
- Issue 4649 - crash in sync_repl when a MODRDN create a cenotaph (#4652)
- Issue 4169 - UI - Migrate alerts to PF4
- Issue 4169 - UI - Migrate Accordians to PF4 ExpandableSection
- Issue 4595 - Paged search lookthroughlimit bug (#4602)
- Issue 4169 - UI - port charts to PF4
- Issue 2820 - Fix CI test suite issues
- Issue 4513 - CI - make acl ip address tests more robust
