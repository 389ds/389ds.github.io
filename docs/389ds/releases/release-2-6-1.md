---
title: "Releases/2.6.1"
---

389 Directory Server 2.6.1
--------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.6.1.

The new packages and versions are:

- 389-ds-base-2.6.1

Source tarballs are available for download at [GitHub Releases page](https://github.com/389ds/389-ds-base/releases/tag/389-ds-base-2.6.1)

- <https://github.com/389ds/389-ds-base/releases/download/389-ds-base-2.6.1/389-ds-base-2.6.1.tar.bz2>

### Highlights in 2.6.1

- Enhancements
  - Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - RFE - CLI - Add logging settings to dsconf
  - Issue [6269](https://github.com/389ds/389-ds-base/issues/6269) - RFE - Add nsslapd-pwdPBKDF2Rounds configuration to PBKDF2-* plugins [#6447](https://github.com/389ds/389-ds-base/pull/6447)

- Bug fixes

### Installation and Upgrade

See [Download](https://www.port389.org/docs/389ds/download.html) for information about setting up your DNF repositories.

To install the server use `dnf install 389-ds-base`

To install the Cockpit UI plugin use `dnf install cockpit-389-ds`

After rpm install completes, run `dscreate interactive`

For upgrades, simply install the package. There are no further steps required.

There are no upgrade steps besides installing the new rpms.

See [Install Guide](https://www.port389.org/docs/389ds/howto/howto-install-389.html) for more information about the initial installation and setup.

See [Source](https://www.port389.org/docs/389ds/development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments here:

- 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>
- 389ds discussion channel: <https://github.com/389ds/389-ds-base/discussions>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

Changelog between 389-ds-base-2.5.3 and 389-ds-base-2.6.1:

- Bump version to 2.6.1
- Issue [6516](https://github.com/389ds/389-ds-base/issues/6516) - Allow to configure the password scheme not updated on bind [#6517](https://github.com/389ds/389-ds-base/pull/6517)
- Issue [6509](https://github.com/389ds/389-ds-base/issues/6509) - Race condition with Paged Result searches
- Issue [6191](https://github.com/389ds/389-ds-base/issues/6191) - Node.js 16 actions are deprecated
- Issue [6453](https://github.com/389ds/389-ds-base/issues/6453) - (cont) Fix memory leaks in entryrdn [#6504](https://github.com/389ds/389-ds-base/pull/6504)
- Issue [6481](https://github.com/389ds/389-ds-base/issues/6481) - UI - When ports that are in use are used to update a DS instance the error message is not helpful [#6482](https://github.com/389ds/389-ds-base/pull/6482)
- Issue [6497](https://github.com/389ds/389-ds-base/issues/6497) - lib389 - Configure replication for multiple suffixes [#6498](https://github.com/389ds/389-ds-base/pull/6498)
- Issue [6453](https://github.com/389ds/389-ds-base/issues/6453) - Fix memory leaks in entryrdn
- Issue [6470](https://github.com/389ds/389-ds-base/issues/6470) - Some replication status data are reset upon a restart [#6471](https://github.com/389ds/389-ds-base/pull/6471)
- Issue [6386](https://github.com/389ds/389-ds-base/issues/6386) - backup/restore broken after db log rotation [#6406](https://github.com/389ds/389-ds-base/pull/6406)
- Issue [6490](https://github.com/389ds/389-ds-base/issues/6490) - Add a new macro function and print rounds on startup [#6496](https://github.com/389ds/389-ds-base/pull/6496)
- Issue [6494](https://github.com/389ds/389-ds-base/issues/6494) - Various errors when using extended matching rule on vlv sort filter [#6495](https://github.com/389ds/389-ds-base/pull/6495)
- Issue [6417](https://github.com/389ds/389-ds-base/issues/6417) - (3rd) If an entry RDN is identical to the suffix, then Entryrdn gets broken during a reindex [#6480](https://github.com/389ds/389-ds-base/pull/6480)
- Issue [6490](https://github.com/389ds/389-ds-base/issues/6490) - Remove the rust error log message for pbkdf2 rounds
- Issue [6485](https://github.com/389ds/389-ds-base/issues/6485) - Fix double free in USN cleanup task
- Issue [6372](https://github.com/389ds/389-ds-base/issues/6372) - Deadlock while doing online backup [#6475](https://github.com/389ds/389-ds-base/pull/6475)
- Issue [6269](https://github.com/389ds/389-ds-base/issues/6269) - RFE - Add nsslapd-pwdPBKDF2Rounds configuration to PBKDF2-* plugins [#6447](https://github.com/389ds/389-ds-base/pull/6447)
- Issue [6417](https://github.com/389ds/389-ds-base/issues/6417) - (2nd) If an entry RDN is identical to the suffix, then Entryrdn gets broken during a reindex [#6460](https://github.com/389ds/389-ds-base/pull/6460)
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - CLI - Remove security log settings that don't exist
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - RFE - CLI - fix cherry-pick error
- Issue [6468](https://github.com/389ds/389-ds-base/issues/6468) - RFE - CLI - Add logging settings to dsconf
- Issue [6472](https://github.com/389ds/389-ds-base/issues/6472) - CLI - Improve error message format
- Issue [6442](https://github.com/389ds/389-ds-base/issues/6442) - Fix latest covscan memory leaks (part 2)
- Issue [6442](https://github.com/389ds/389-ds-base/issues/6442) - Fix latest covscan memory leaks