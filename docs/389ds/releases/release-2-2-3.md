---
title: "Releases/2.2.3"
---

389 Directory Server 2.2.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.2.3

Fedora packages are available on Fedora 37

<https://koji.fedoraproject.org/koji/taskinfo?taskID=91505211>

<https://bodhi.fedoraproject.org/updates/FEDORA-2022-2269bbf393> - Bohdi


The new packages and versions are:

- 389-ds-base-2.2.3-1

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.2.3.tar.gz)

### Highlights in 2.2.3

- Enhancements, Security and Bug fixes

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

- Bump verrsion to 2.2.3
- Issue 5012 - Migrate pcre to pcre2 - remove match limit
- Update CI tests
- Issue 5356 - Make Rust non-optional and update default password storage scheme
- Issue 5012 - Migrate pcre to pcre2
- Issue 5428 - Fix regression with nscpEntryWsi computation
- Fix missing 'not' in description (closes #5423) (#5424)
- Issue 5421 - CI - makes replication/acceptance_test.py::test_modify_entry more robust (#5422)
- Issue 3903 - fix repl keep alive event interval
- Issue 5418 - Sync_repl may crash while managing invalid cookie (#5420)
- Issue 5415 - Hostname when set to localhost causing failures in other tests
- Issue 5412 - lib389 - do not set backend name to lowercase
- Issue 5407 - sync_repl crashes if enabled while dynamic plugin is enabled (#5411)
- Issue 5385 - LMDB - import crash in rdncache_add_elem (#5406)
- Issue 5403 - Memory leak in conntection table mulit list (#5404)
- Issue 3903 - keep alive update event starts too soon
- Issue 5397 - Fix various memory leaks
- Issue 5399 - UI - LDAP Editor is not updated when we switch instances (#5400)
- Issue 3903 - Supplier should do periodic updates
- Issue 5377 - Code cleanup: Fix Covscan invalid reference (#5393)
- Issue 5394 - configure doesn't check for lmdb and json-c
- Issue 5392 - dscreate fails when using alternative ports in the SELinux hi_reserved_port_t label range
- Issue 5386 - BUG - Update sudoers schema to correctly support UTF-8 (#5387)
- Issue 5388 - fix use-after-free and deadcode
- Issue 5383 - UI - Various fixes and RFE's for UI
- Issue 4656 - Remove problematic language from source code
- Issue 5380 - Separate cleanAllRUV code into new file
- Issue 5322 - optime & wtime on rejected connections is not properly set
- Issue 5335 - RFE - Add Security Audit Log
- Issue 5375 - CI - disable TLS hostname checking
- Issue 981  - Managed Entries betxnpreoperation - transaction not aborted on managed entry failure (#5369)
- Issue 5373 - dsidm user get_dn fails with search_ext() argument 1 must be str, not function
- Issue 5371 - Update npm and cargo packages
- Issue 3069 - Support ECDSA private keys for TLS (#5365)
- Issue 5290 - Importing certificate chain files via "import-server-key-cert" no longer works (#5293)

