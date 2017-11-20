---
title: "Releases/1.3.3.0"
---
389 Directory Server 1.3.3.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.0.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.0-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.0.tar.bz2)

### Highlights in 1.3.3.0

-   First cut of 389-ds-base-1.3.3.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.2.23

-   Ticket 53    - Need to update supported locales Cleaning up typos and format.
-   Ticket 538   - hardcoded sasl2 plugin path in ldaputil.c, saslbind.c
-   Ticket 555   - add fixup-memberuid.pl script
-   Ticket 605   - support TLS 1.1
-   Ticket 605   - support TLS 1.1 - Fixing "Coverity 12415 - Logically dead code"
-   Ticket 605   - support TLS 1.1 - adding backward compatibility
-   Ticket 605   - support TLS 1.1 - lower the log level for the supported NSS version range
-   Ticket 381   - Recognize compressed log files
-   Ticket 47368 - Fix Jenkins errors
-   Ticket 47368 - Fix coverity issues
-   Ticket 47368 - IPA server dirsrv RUV entry data excluded from replication
-   Ticket 47368 - fix memory leaks
-   Ticket 47398 - memberOf on a user is converted to lowercase
-   Ticket 47422 - With 1.3.04 and subtree-renaming OFF, when a user is deleted after restarting the server, the same entry can't be added
-   Ticket 47436 - 389-ds-base - shebang with /usr/bin/env
-   Ticket 47437 - Some attributes in cn=config should not be multivalued
-   Ticket 47451 - Remove old code from linked attr plugin
-   Ticket 47451 - add/enable/disable/remove plugins without server restart
-   Ticket 47453 - configure SASL/GSSAPI/Kerberos without server restart
-   Ticket 47457 - default nsslapd-sasl-max-buffer-size should be 2MB
-   Ticket 47466 - Fix coverity issue
-   Ticket 47491 - Update systemd service file to use PartOf directive
-   Ticket 47499 - if nsslapd-cachememsize set to the number larger than the RAM available, should result in proper error message.
-   Ticket 47519 - memory leaks in access control
-   Ticket 47521 - Complex filter in a search request doen't work as expected.
-   Ticket 47525 - Allow memberOf to use an alternate config area
-   Ticket 47525 - Don't modify preop entry in memberOf config
-   Ticket 47525 - Fix memory leak
-   Ticket 47525 - Need to add locking around config area access
-   Ticket 47529 - Automember plug-in should treat MODRDN operations as ADD operations
-   Ticket 47530 - dbscan on entryrdn should show all matching values
-   Ticket 47530 - dbscan on entryrdn should show all matching values
-   Ticket 47535 - Logconv.pl - RFE - add on option for a minimum etime for unindexed search stats
-   Ticket 47535 - update man page
-   Ticket 47552 - logconv: unindexed report should list bind dn
-   Ticket 47553 - Enhance ACIs to have more control over MODRDN operations
-   Ticket 47555 - db2bak.pl issue when specifying non-default directory
-   Ticket 47570 - slapi_ldap_init unusable during independent plugin development
-   Ticket 47573 - schema push can be erronously prevented
-   Ticket 47574 - start dirsrv after ntpd
-   Ticket 47579 - add dbmon.sh
-   Ticket 47582 - agmt_count in Replica could become (PRUint64)-1
-   Ticket 47586 - Need to rebind after a stop (fix to run direct python script)
-   Ticket 47602 - Make ldbm_back_seq independently support transactions
-   Ticket 47602 - txn commit being performed too early
-   Ticket 47603 - Allow RI plugin to use alternate config area
-   Ticket 47603 - should not modify pre op entry during config validation
-   Ticket 47608 - change slapi_entry_attr_get_bool to handle "on"/"off" values, support default value
-   Ticket 47618 - Enable normalized DN cache by default
-   Ticket 47619 - cannot reindex retrochangelog
-   Ticket 47628 - port testcases to new DirSrv interface
-   Ticket 47636 - errorlog-level 16384 is listed as 0 in cn=config
-   Ticket 47644 - Managed Entry Plugin - transaction not aborted upon failure to create managed entry
-   Ticket 47651 - Finaliser to remove instances backups
-   Ticket 47654 - Cleanup old memory leaks reported from valgrind
-   Ticket 47654 - Fix regression (deadlock/crash)
-   Ticket 47654 - fix double free
-   Ticket 47655 - Improve replication total update logging
-   Ticket 47657 - add schema test suite and tests for Ticket #47634
-   Ticket 47659 - ldbm_usn_init: Valgrind reports Invalid read / SIGSEGV
-   Ticket 47664 - Page control does not work if effective rights control is specified
-   Ticket 47667 - Allow nsDS5ReplicaBindDN to be a group DN
-   Ticket 47668 - test: port ticket47490_test to Replica/Agreement interface (47600)
-   Ticket 47675 - logconv errors when search has invalid bind dn
-   Ticket 47701 - Make retro changelog trim interval programmable
-   Ticket 47701 - Make retro changelog trim interval programmable
-   Ticket 47710 - Missing warning for invalid replica backoff configuration
-   Ticket 47711 - improve dbgen rdn generation, output and man page.
-   Ticket 47712 - betxn: retro changelog broken after cancelled transaction
-   Ticket 47714 - [RFE] Update lastLoginTime also in Account Policy plugin if account lockout is based on passwordExpirationTime.
-   Ticket 47725 - compiler error on daemon.c
-   Ticket 47727 - Updating nsds5ReplicaHost attribute in a replication agreement fails with error 53
-   Ticket 47746 - ldap/servers/slapd/back-ldbm/dblayer.c: possible minor problem with sscanf
-   Ticket 47752 - Don't add unhashed password mod if we don't have an unhashed value
-   Ticket 47756 - Improve import logging and abort processing
-   Ticket 47756 - fix coverity issues
-   Ticket 47761 - Return all attributes in rootdse without explicit request
-   Ticket 47790 - Integer config attributes accept invalid  values at server startup
-   Ticket 47791 - Negative value of nsSaslMapPriority is not  reset to lowest priority
-   Ticket 47803 - syncrepl crash if attribute list is non-empty
-   Ticket 47805 - syncrepl doesn't send notification when attribute in search filter changes
-   Ticket 47808 - If be_txn plugin fails in ldbm_back_add, adding entry is double freed
-   Ticket 47810 - investigate betxn plugins to ensure they  return the correct error code
-   Ticket 47812 - logconv.pl missing -U option from usage
-   Ticket 47815 - Add operations rejected by betxn plugins remain in cache
-   Ticket 47819 - Fix memory leak
-   Ticket 47819 - Improve tombstone purging performance
-   Ticket 47823 - attribute uniqueness enforced on all subtrees
-   Ticket 47827 - Fix coverity issue 12695
-   Ticket 47827 - online import crashes server if using verbose error logging
-   Ticket 47829: memberof scope: allow to exclude subtrees
-   Ticket 47832 - attrcrypt_generate_key calls slapd_pk11_TokenKeyGenWithFlags with improper macro
-   Ticket 47838 - harden the list of ciphers available by default
-   Ticket 47843 - Fix various typos in manpages & code
-   Ticket 47844 - Fix hyphens used as minus signed and other manpage mistakes
-   Ticket 47846 - server crashes deleting a replication agreement
-   Ticket 47852 - Updating winsync one-way sync does not affect the behaviour dynamically
-   Ticket 47853 - Missing newline at end of the error log messages in memberof
-   Ticket 47853 - client hangs in add if memberof fails
-   Ticket 47855 - Fix previous commit
-   Ticket 47855 - clear tmp directory at the start of each test
-   Ticket 47859 - Coverity: 12692 & 12717
-   Ticket 47876 - coverity defects in slapd/tools/mmldif.c
-   Ticket 47879 - coverity defects in plugins/replication/windows_protocol_util.c
-   Coverity Issue 12033
-   Update test cases due to new modules: Schema, tasks, plugins and index
-   bump autoconf to 2.69, automake to 1.13.4, libtool to 2.4.2
-   fix assertion failure introduced with fix for ticket 47667
-   fix compiler error with alst coverity commit
-   fix coverity issue 12621
