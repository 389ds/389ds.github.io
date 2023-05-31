---
title: "Releases/1.3.x Archive"
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


389 Directory Server 1.3.3.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.10.

Fedora packages are available from the Fedora 21, 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.10-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.10.tar.bz2)

### Highlights in 1.3.3.10

-   One important security bug was fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.10-1.fc21> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.10-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.8

-   Bug 1216203 - CVE-2015-1854 389ds-base: access control bypass with modrdn [fedora-all]


389 Directory Server 1.3.3.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.12.

Fedora packages are available from the Fedora 21, 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.12-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.12.tar.bz2)

### Highlights in 1.3.3.12

-   Several critical bugs including a security bug were fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.12-1.fc21> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.12-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.10

-   Bug 1232896  - CVE-2015-3230 389-ds-base: nsSSL3Ciphers preference not enforced server side (Ticket 48194)
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48190 - idm/ipa 389-ds-base entry cache converges to 500 KB in dblayer_is_cachesize_sane
-   Ticket 48183 - bind on db chained to AD returns err=32
-   Ticket 47753 - Fix testecase
-   Ticket 47828 - fix testcase "import" issue
-   Ticket 48158 - cleanAllRUV task limit not being enforced correctly
-   Ticket 48158 - Remove cleanAllRUV task limit of 4
-   Ticket 48146 - async simple paged results issue; need to close a small window for a pr index competed among multiple threads.
-   Ticket 48146 - async simple paged results issue; log pr index
-   Ticket 48146 - async simple paged results issue
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)
-   Ticket 48177 - dynamic plugins should not return an error when modifying a critical plugin
-   Ticket 48151 - fix coverity issues
-   Ticket 48151 - Improve CleanAllRUV logging
-   Ticket 48136 - v2v2 accept auxilliary objectclasse in replication agreements
-   Ticket 48132 - modrdn crashes server (invalid read/writes)
-   Ticket 48133 - Non tombstone entry which dn starting with "nsuniqueid=...," cannot be deleted


389 Directory Server 1.3.3.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.13.

Fedora packages are available from the Fedora 21 repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.13-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.13.tar.bz2)

### Highlights in 1.3.3.13

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.13-1.fc21>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.12

-   Ticket 48265 - Complex filter in a search request doen't work as expected. (regression)
-   Ticket 47981 - COS cache doesn't properly mark vattr cache as invalid when there are multiple suffixes
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 48254 - CLI db2index fails with usage errors
-   Ticket 47831 - remove debug logging from retro cl
-   Ticket 48245 - Man pages and help for remove-ds.pl doesn't display "-a" option
-   Ticket 47931 - Fix coverity issues
-   Ticket 47931 - memberOf & retrocl deadlocks
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48215 - update dbverify usage in main.c
-   Ticket 48215 - update dbverify usage
-   Ticket 48215 - verify_db.pl doesn't verify DB specified by -a option
-   Ticket 47810 - memberOf plugin not properly rejecting updates
-   Ticket 48231 - logconv autobind handling regression caused by 47446
-   Ticket 48232 - winsync lastlogon attribute not syncing between DS and AD.
-   Ticket 48206 - Crash during retro changelog trimming
-   Ticket 48224 - redux 2 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48224 - redux - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48224 - redux - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48224 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48212 - Dynamic nsMatchingRule changes had no effect on the attrinfo thus following reindexing, as well.
-   Ticket 48195 - Slow replication when deleting large quantities of multi-valued attributes
-   Ticket 48175 - Avoid using regex in ACL if possible


389 Directory Server 1.3.3.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.14.

Fedora packages are available from the Fedora 21 repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.14-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.14.tar.bz2)

### Highlights in 1.3.3.14

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.14-1.fc21>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.13

-   Ticket 47553 - Automated the verification procedure
-   Ticket 47957 - Add replication test suite for a wait async feature
-   Ticket 47976 - deadlock in mep delete post op
-   Ticket 47978 - Deadlock between two MODs on the same entry between entry cache and backend lock
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48208 - CleanAllRUV should completely purge changelog
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48264 - Ticket 47553 tests refactoring
-   Ticket 48266 - Fractional replication evaluates several times the same CSN
-   Ticket 48266 - coverity issue
-   Ticket 48266 - do not free repl keep alive entry on error
-   Ticket 48266 - Online init crashes consumer
-   Ticket 48273 - Update lib389 tests for new valgrind functions
-   Ticket 48283 - many attrlist_replace errors in connection with cleanallruv
-   Ticket 48284 - free entry when internal add fails
-   Ticket 48299 - pagedresults - when timed out, search results could have been already freed.
-   Ticket 48304 - ns-slapd - LOGINFO:Unable to remove file
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48325 - Add lib389 test script
-   Ticket 48325 - Replica promotion leaves RUV out of order
-   Ticket 48338 - SimplePagedResults -- abandon could happen between the abandon check and sending results


389 Directory Server 1.3.3.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.2.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.2-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.2.tar.bz2)

### Highlights in 1.3.3.2

-   Several bugs are fixed.

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

### Detailed Changelog since 1.3.3.0

-   Ticket 47889 - DS crashed during ipa-server-install on test_ava_filter
-   Ticket 47895 - If no effective ciphers are available, disable security setting.
-   Ticket 47838 - harden the list of ciphers available by default
-   Ticket 47885 - did not always return a response control
-   Ticket 47890 - minor memory leaks in utilities
-   Ticket 47834 - Tombstone_to_glue: if parents are also converted to glue, the target entry's DN must be adjusted.
-   Ticket 47748 - Simultaneous adding a user and binding as the user could fail in the password policy check
-   Ticket 47875 - dirsrv not running with old openldap
-   Ticket 47885 - deref plugin should not return references with noc access rights


389 Directory Server 1.3.3.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.3.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.3-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.3.tar.bz2)

### Highlights in 1.3.3.3

-   Several bugs are fixed.

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

### Detailed Changelog since 1.3.3.0

-   Ticket 47892 - coverity defects found in 1.3.3.1
-   Ticket 47889 - DS crashed during ipa-server-install on test_ava_filter
-   Ticket 47895 - If no effective ciphers are available, disable security setting.
-   Ticket 47838 - harden the list of ciphers available by default
-   Ticket 47885 - did not always return a response control
-   Ticket 47890 - minor memory leaks in utilities
-   Ticket 47834 - Tombstone_to_glue: if parents are also converted to glue, the target entry's DN must be adjusted.
-   Ticket 47748 - Simultaneous adding a user and binding as the user could fail in the password policy check
-   Ticket 47875 - dirsrv not running with old openldap
-   Ticket 47885 - deref plugin should not return references with noc access rights


389 Directory Server 1.3.3.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.5.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.5-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.5.tar.bz2)

### Highlights in 1.3.3.5

-   Several bugs are fixed.

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

### Detailed Changelog since 1.3.3.3

-   Ticket 47750 - Creating a glue fails if one above level is a conflict or missing
-   Ticket 47838 - harden the list of ciphers available by default (phase 2)
-   Ticket 47880 - provide enabled ciphers as search result
-   Ticket 47892 - Fix remaining compiler warnings
-   Ticket 47892 - coverity defects found in 1.3.3.x
-   Ticket 47897 - Need to move slapi_pblock_set(pb, SLAPI_MODRDN_EXISTING_ENTRY, original_entry->ep_entry) prior to original_entry overwritten
-   Ticket 47899 - Fix slapi_td_plugin_lock_init prototype
-   Ticket 47900 - Adding an entry with an invalid password as rootDN is incorrectly rejected
-   Ticket 47900 - Server fails to start if password admin is set
-   Ticket 47907 - ldclt: assertion failure with -e "add,counteach" -e "object=<ldif file>,rdn=uid:test[A=INCRNNOLOOP(0;24999;5)]"
-   Ticket 47908 - 389-ds 1.3.3.0 does not adjust cipher suite configuration on upgrade, breaks itself and pki-server
-   Ticket 47912 - Proper handling of "No original_tombstone for changenumber" errors
-   Ticket 47916 - plugin logging parameter only triggers result logging
-   Ticket 47918 - result of dna_dn_is_shared_config is incorrectly used
-   Ticket 47919 - ldbm_back_modify SLAPI_PLUGIN_BE_PRE_MODIFY_FN does not return even if one of the preop plugins fails.
-   Ticket 47920 - Encoding of SearchResultEntry is missing tag
-   Ticket 47922 - dynamically added macro aci is not evaluated on the fly


389 Directory Server 1.3.3.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.8.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.8-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.8.tar.bz2)

### Highlights in 1.3.3.8

-   Several bugs are fixed including security bugs -- stop using DES and old SSL version.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.8-1.fc21>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.5

-   Ticket 47451 - Dynamic plugins
-   Ticket 47462 - Stop using DES in the reversible password encryption plug-in
-   Ticket 47525 - Crash if setting invalid plugin config area for MemberOf Plugin
-   Ticket 47553 - Enhance ACIs to have more control over MODRDN operations
-   Ticket 47617 - replication changelog trimming setting validation
-   Ticket 47636 - Error log levels not displayed correctly
-   Ticket 47722 - Using the filter file does not work
-   Ticket 47738 - use PL_strcasestr instead of strcasestr
-   Ticket 47750 - During delete operation do not refresh cache entry if it is a tombstone
-   Ticket 47750 - Need to refresh cache entry after called betxn postop plugins
-   Ticket 47807 - SLAPI_REQUESTOR_ISROOT not set for extended operation plugins
-   Ticket 47810 - RI plugin does not return result code if update fails
-   Ticket 47905 - Bad manipulation of passwordhistory
-   Ticket 47928 - Disable SSL v3, by default.
-   Ticket 47934 - nsslapd-db-locks modify not taking into account.
-   Ticket 47935 - Error: failed to open an LDAP connection to host 'example.org' port '389' as user 'cn=Directory Manager'. Error: unknown.
-   Ticket 47937 - Crash in entry_add_present_values_wsi_multi_valued
-   Ticket 47939 - Malformed cookie for LDAP Sync makes DS crash
-   Ticket 47942 - DS hangs during online total update
-   Ticket 47945 - Add SSL/TLS version info to the access log
-   Ticket 47947 - start dirsrv after chrony on RHEL7 and Fedora
-   Ticket 47948 - ldap_sasl_bind fails assertion (ld != NULL) if it is called from chainingdb_bind over SSL/startTLS
-   Ticket 47949 - logconv.pl -- support parsing/showing/reporting different protocol versions
-   Ticket 47950 - Bind DN tracking unable to write to internalModifiersName without special permissions
-   Ticket 47952 - PasswordAdminDN attribute is not properly returned to client
-   Ticket 47953 - Should not check aci syntax when deleting an aci
-   Ticket 47958 - Memory leak in password admin if the admin entry does not exist
-   Ticket 47960 - cookie_change_info returns random negative number if there was no change in a tree
-   Ticket 47963 - RFE - memberOf - add option to skip nested  group lookups during delete operations
-   Ticket 47964 - Incorrect search result after replacing an empty attribute
-   Ticket 47965 - Fix coverity issues 
-   Ticket 47967 - cos_cache_build_definition_list does not stop during server shutdown
-   Ticket 47969 - COS memory leak when rebuilding the cache
-   Ticket 47970 - Account lockout attributes incorrectly updated after failed SASL Bind
-   Ticket 47973 - During schema reload sometimes the search returns no results
-   Ticket 47980 - Nested COS definitions can be incorrectly  processed
-   Ticket 47981 - COS cache doesn't properly mark vattr cache as  invalid when there are multiple suffixes
-   Ticket 47988 - Schema learning mechanism, in replication, unable to extend an existing definition
-   Ticket 47989 - Windows Sync accidentally cleared raw_entry
-   Ticket 47991 - upgrade script fails if /etc and /var are on different file systems
-   Ticket 47996 - ldclt needs to support SSL Version range
-   Ticket 48001 - ns-activate.pl fails to activate account if it was disabled on AD


389 Directory Server 1.3.3.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.9.

Fedora packages are available from the Fedora 21, 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.9-1

A source tarball is available for download at [Download Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.3.9.tar.bz2)

### Highlights in 1.3.3.9

-   Several bugs are fixed including 2 security bugs

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.9-1.fc21> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.3.9-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.8

-   Bug 1199675 - CVE-2014-8112 CVE-2014-8105 389-ds-base: various flaws [fedora-all]
-   Ticket 47431 - Duplicate values for the attribute nsslapd-pluginarg are not handled correctly
-   Ticket 47451 - dynamic plugins - fix crash caused by invalid plugin config
-   Ticket 47728 - compilation failed with ' incomplete struct/union/enum' if not set USE_POSIX_RWLOCKS
-   Ticket 47742 - 64bit problem on big endian: auth method not supported
-   Ticket 47801 - RHDS keeps on logging write_changelog_and_ruv: failed to update RUV for unknown
-   Ticket 47828 - DNA scope: allow to exlude some subtrees
-   Ticket 47836 - Do not return '0' as empty fallback value of nsds5replicalastupdatestart and nsds5replicalastupdatestart
-   Ticket 47901 - After total init, nsds5replicaLastInitStatus can report an erroneous error status (like 'Referral')
-   Ticket 47936 - Create a global lock to serialize write operations over several backends
-   Ticket 47957 - Make ReplicaWaitForAsyncResults configurable
-   Ticket 48001 - ns-activate.pl fails to activate account if it was disabled on AD
-   Ticket 48003 - add template scripts
-   Ticket 48003 - build "suite" framework
-   Ticket 48005 - ns-slapd crash in shutdown phase
-   Ticket 48021 - nsDS5ReplicaBindDNGroup checkinterval not working properly
-   Ticket 48027 - revise the rootdn plugin configuration validation
-   Ticket 48030 - spec file should run "systemctl stop" against each running instance instead of dirsrv.target
-   Ticket 48048 - Fix coverity issues - 2015/2/24
-   Ticket 48048 - Fix coverity issues - 2015/3/1
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)


389 Directory Server 1.3.4.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.0.

Fedora packages are available from the Fedora 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.0-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.0.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.4.tar.bz2).

### Highlights in 1.3.4.0

-   A new version is available featuring [Nunc Stans](../design/nunc-stans.html).

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.0-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.3.12

-   Enable nunc-stans in the build.
-   Ticket 47490 - test case failing if 47721 is also fixed
-   Ticket 47640 - Linked attributes transaction not aborted when  linked entry does not exit
-   Ticket 47669 - CI test: added test cases for ticket 47669
-   Ticket 47669 - Retro Changelog Plugin accepts invalid value in nsslapd-changelogmaxage attribute
-   Ticket 47723 - winsync sets AccountUserControl in AD to 544
-   Ticket 47787 - Make the test case more robust
-   Ticket 47833 - TEST CASE only (modrdn fails if renamed entry member of a group and is out of memberof scope)
-   Ticket 47878 - Improve setup-ds update logging
-   Ticket 47893 - should use Sys::Hostname instead Net::Domain
-   Ticket 47910 - allow logconv.pl -S/-E switches to work even when timestamps not present in access log
-   Ticket 47913 - remove-ds.pl should not remove /var/lib/dirsrv
-   Ticket 47921 - indirect cos does not reflect changes in the cos attribute
-   Ticket 47927 - Uniqueness plugin: should allow to exclude some subtrees from its scope
-   Ticket 47953 - testcase for removing invalid aci
-   Ticket 47966 - CI test: added test cases for ticket 47966
-   Ticket 47966 - slapd crashes during Dogtag clone reinstallation
-   Ticket 47972 - make parsing of nsslapd-changelogmaxage more fault tolerant
-   Ticket 47972 - make parsing of nsslapd-changelogmaxage more fool proof
-   Ticket 47998 - cleanup WINDOWS ifdef's
-   Ticket 47998 - remove remaining obsolete OS code/files
-   Ticket 47998 - remove "windows" files
-   Ticket 47999 - address several race conditions in tests
-   Ticket 47999 - lib389 individual tests not running correctly  when run as a whole
-   Ticket 48003 - build "suite" framework
-   Ticket 48008 - db2bak.pl man page should be improved.
-   Ticket 48017 - add script to generate lib389 CI test script
-   Ticket 48019 - Remove refs to constants.py and backup/restore from lib389 tests
-   Ticket 48023 - replace old replication check with lib389 function
-   Ticket 48025 - add an option '-u' to dbgen.pl for adding group entries with uniquemembers
-   Ticket 48026 - fix invalid write for friendly attribute names
-   Ticket 48026 - Fix memory leak in uniqueness plugin
-   Ticket 48026 - Support for uniqueness plugin to enforce uniqueness on a set of attributes.
-   Ticket 48032 - change C code license to GPLv3; change C code license to allow openssl
-   Ticket 48035 - nunc-stans - Revise shutdown sequence
-   Ticket 48036 - ns_set_shutdown should call ns_job_done
-   Ticket 48037 - ns_thrpool_new should take a config struct rather than many parameters
-   Ticket 48038 - logging should be pluggable
-   Ticket 48039 - nunc-stans malloc should be pluggable
-   Ticket 48040 - preserve the FD when disabling a listener
-   Ticket 48043 - use nunc-stans config initializer
-   Ticket 48103 - update DS for new nunc-stans header file
-   Ticket 48110 - Free all the nunc-stans signal jobs when shutdown is detected
-   Ticket 48111 - "make clean" wipes out original files
-   Ticket 48122 - nunc-stans FD leak
-   Ticket 48127 - Using RPM, allows non root user to create/remove DS instance
-   Ticket 48141 - aci with wildcard and macro not correctly evaluated
-   Ticket 48143 - Password is not correctly passed to perl command line tools if it contains shell special characters.
-   Ticket 48149 - ns-slapd double free or corruption crash
-   Ticket 48154 - abort cleanAllRUV tasks should not certify-all by default
-   Ticket 48169 - support NSS 3.18
-   Ticket 48170 - Parse nsIndexType correctly
-   Ticket 48175 - Avoid using regex in ACL if possible
-   Ticket 48178 - add config param to enable nunc-stans
-   Ticket 48191 - CI test: added test cases for ticket 48191
-   Ticket 48191 - RFE: Adding nsslapd-maxsimplepaged-per-conn
-   Ticket 48191 - RFE: Adding nsslapd-maxsimplepaged-per-conn Adding nsslapd-maxsimplepaged-per-conn
-   Ticket 48194 - CI test: added test cases for ticket 48194
-   Ticket 48197 - error texts from preop plugins not sent to client


389 Directory Server 1.3.4.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.14.

Fedora packages are available from the Fedora 23 repository.

The new packages and versions are:

-   389-ds-base-1.3.4.14-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.14.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.14

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.14-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.9

-   CVE-2016-4992 389-ds-base: Information disclosure via repeated use of LDAP ADD operation, etc.
-   Ticket 47538 - Fix repl-monitor color and lag times
-   Ticket 47538 - repl-monitor.pl legend not properly sorted
-   Ticket 47538 - repl-monitor.pl not displaying correct color code for lag time
-   Ticket 47819 - RFE - improve tombstone purging performance
-   Ticket 47888 - DES to AES password conversion fails if a backend is empty
-   Ticket 47888 - Add CI test
-   Ticket 48078 - CI test - paged_results - TET part
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)
-   Ticket 48492 - heap corruption at schema replication.
-   Ticket 48497 - uncomment pytest from CI test
-   Ticket 48636 - Fix config validation check
-   Ticket 48636 - Improve replication convergence
-   Ticket 48752 - Page result search should return empty cookie if there is no returned entry
-   Ticket 48752 - Add CI test
-   Ticket 48755 - moving an entry could make the online init fail
-   Ticket 48766 - Replication changelog can incorrectly skip over updates
-   Ticket 48767 - flow control in replication also blocks receiving results
-   Ticket 48795 - Make various improvements to create_test.py
-   Ticket 48798 - Enable DS to offer weaker DH params in NSS
-   Ticket 48799 - objectclass values could be dropped on the consumer
-   Ticket 48799 - Test cases for objectClass values being dropped.
-   Ticket 48808 - Add test case
-   Ticket 48808 - Paged results search returns the blank list of entries
-   Ticket 48813 - password history is not updated when an admin resets the password
-   Ticket 48848 - modrdn deleteoldrdn can fail to find old attribute value, perhaps due to case folding
-   Ticket 48854 - Running db2index with no options breaks replication
-   Ticket 48862 - At startup DES to AES password conversion causes timeout in start script
-   Ticket 48889 - ldclt - fix man page and usage info
-   Ticket 48898 - Crash during shutdown if nunc-stans is enabled
-   Ticket 48900 - Add connection perf stats to logconv.pl
-   Ticket 48922 - Fix crash when deleting backend while import is running
-   Ticket 48924 - Fixup tombstone task needs to set proper flag when updating tombstones
-   Ticket 48930 - Paged result search can hang the server
-   Ticket 48935 - Update dirsrv.systemd file


389 Directory Server 1.3.4.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.1.

Fedora packages are available from the Fedora 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.1-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.1.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.1

-   Bugs reported by Coverity are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.1-1.fc22>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.0

-   Enable nunc-stans only for x86_64.
-   Ticket 48203 - Fix coverity issues - 06/22/2015
-   Bug 1234277 - distro-wide architecture set overriden by buildsystem; Upgrade nunc-stans to 0.1.5.


389 Directory Server 1.3.4.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.4.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.4-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.4.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.4

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.4-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.4-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.1

-   Ticket 48255 - total update request can be lost
-   Ticket 48263 - allow plugins to detect tombstone operations
-   Ticket 48265 - Complex filter in a search request doen't work as expected. (regression)
-   Ticket 47981 - COS cache doesn't properly mark vattr cache as invalid when there are multiple suffixes
-   Ticket 48204 - Convert all python scripts to support python3
-   Ticket 48258 - dna plugin needs to handle binddn groups for authorization
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48252 - db2index creates index entry from deleted records
-   Ticket 47757 - Unable to dereference unqiemember attribute because it is dn [#UID] not dn syntax
-   Ticket 48254 - Shell CLI fails with usage errors if an argument containing white spaces is given
-   Ticket 48254 - CLI db2index fails with usage errors
-   Ticket 47831 - remove debug logging from retro cl
-   Ticket 48243 - replica upgrade failed in starting dirsrv service due to upgrade scripts did not run
-   Ticket 48233 - Server crashes in ACL_LasFindFlush during shutdown if ACIs contain IP addresss restrictions
-   Ticket 48250 - Slapd crashes reported from latest build
-   Ticket 48249 - sync_repl uuid may be invalid
-   Ticket 48245 - Man pages and help for remove-ds.pl doesn't display "-a" option
-   Ticket 47511 - bashisms in 389-ds-base admin scripts
-   Ticket 47686 - removing chaining database links trigger valgrind read errors
-   Ticket 47931 - memberOf & retrocl deadlocks
-   Ticket 48228 - wrong password check if passwordInHistory is decreased.
-   Ticket 48215 - update dbverify usage in main.c
-   Ticket 48215 - verify_db.pl doesn't verify DB specified by -a option
-   Ticket 47810 - memberOf plugin not properly rejecting updates
-   Ticket 48231 - logconv autobind handling regression caused by 47446
-   Ticket 48232 - winsync lastlogon attribute not syncing between DS and AD.
-   Ticket 48204 - Add Python 3 compatibility to ds-logpipe
-   Ticket 48010 - winsync range retrieval gets only 5000 values upon initialization
-   Ticket 48206 - Crash during retro changelog trimming
-   Ticket 48224 - redux 2 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 47910 - logconv.pl - check that the end time is greater than the start time
-   Ticket 48179 - Starting a replica agreement can lead to  deadlock
-   Ticket 48226 - CI test: added test cases for ticket 48226
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48224 - redux - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 48203 - Fix coverity issues - 07/14/2015
-   Ticket 48194 - CI test: fixing test cases for ticket 48194
-   Ticket 48224 - logconv.pl should handle *.tar.xz, *.txz, *.xz log files
-   Ticket 47910 - logconv.pl - validate start and end time args
-   Ticket 48223 - Winsync fails when AD users have multiple spaces (two)inside the value of the rdn attribute
-   Ticket 47878 - Remove warning suppression in 1.3.4
-   Ticket 48119 - Silent install needs to properly exit when INF file is missing
-   Ticket 48216 - crash in ns-slapd when deleting winSyncSubtreePair from sync agreement
-   Ticket 48217 - cleanAllRUV hangs shutdown if not all of the  replicas are online
-   Ticket 48013 - Inconsistent behaviour of DS when LDAP Sync is used with an invalid cookie
-   Ticket 47799 - Any negative LDAP error code number reported as Illegal error by ldclt.
-   Ticket 48208 - CleanAllRUV should completely purge changelog
-   Ticket 48203 - Fix coverity issues - 07/07/2015
-   Ticket 48119 - setup-ds.pl does not log invalid --file path errors the same way as other errors.
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48214 - CI test: added test cases for ticket 48213
-   Ticket 48214 - ldapsearch on nsslapd-maxbersize returns 0 instead of current value
-   Ticket 48212 - CI test: added test cases for ticket 48212
-   Ticket 48212 - Dynamic nsMatchingRule changes had no effect on the attrinfo thus following reindexing, as well.
-   Ticket 48195 - Slow replication when deleting large quantities of multi-valued attributes


389 Directory Server 1.3.4.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.5.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.5-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.5.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.5

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.5-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.5-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.4

-   Ticket 47511 - bashisms in 389-ds-base admin scripts
-   Ticket 47553 - Automated the verification procedure
-   Ticket 47761 - Added a few testcases to the basic testsuite
-   Ticket 47957 - Add replication test suite for a wait async feature
-   Ticket 47976 - deadlock in mep delete post op
-   Ticket 47978 - Deadlock between two MODs on the same entry between entry cache and backend lock
-   Ticket 48188 - segfault in ns-slapd due to accessing Slapi_DN freed in pre bind plug-in
-   Ticket 48192 - Individual abandoned simple paged results request has no chance to be cleaned up
-   Ticket 48204 - update lib389 test scripts for python 3
-   Ticket 48217 - cleanallruv - fix regression with server shutdown
-   Ticket 48226 - In MMR, double free coould occur under some special condition
-   Ticket 48227 - rpm.mk doesn't build srpms for 389-ds and nunc-stans
-   Ticket 48254 - Shell CLI fails with usage errors if an argument containing white spaces is given
-   Ticket 48264 - Ticket 47553 tests refactoring
-   Ticket 48266 - Fractional replication evaluates several times the same CSN
-   Ticket 48266 - coverity issue
-   Ticket 48266 - do not free repl keep alive entry on error
-   Ticket 48266 - Online init crashes consumer
-   Ticket 48267 - Add config setting to MO plugin to add objectclass
-   Ticket 48273 - Update lib389 tests for new valgrind functions
-   Ticket 48276 - initialize free_flags in reslimit_update_from_entry()
-   Ticket 48279 - Check NULL reference in nssasl_mutex_lock etc. (saslbind.c)
-   Ticket 48283 - many attrlist_replace errors in connection with cleanallruv
-   Ticket 48284 - free entry when internal add fails
-   Ticket 48298 - ns-slapd crash during ipa-replica-manage del
-   Ticket 48299 - pagedresults - when timed out, search results could have been already freed.
-   Ticket 48304 - ns-slapd - LOGINFO:Unable to remove file
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48311 - nunc-stans: Attempt to release connection that is not acquired
-   Ticket 48316 - Perl-5.20.3-328: Use of literal control characters in variable names is deprecated
-   Ticket 48325 - Add lib389 test script
-   Ticket 48325 - Replica promotion leaves RUV out of order
-   Ticket 48338 - SimplePagedResults -- abandon could happen between the abandon check and sending results
-   Ticket 48339 - Share nsslapd-threadnumber in the case nunc-stans is enabled, as well.
-   Ticket 48344 - acl - regression - trailing ', (comma)' in macro matched value is not removed.
-   Ticket 48348 - Running /usr/sbin/setup-ds.pl fails with Can't locate bigint.pm, plus two warnings


389 Directory Server 1.3.4.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.7.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.7-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.7.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.7

-   Various bugs including a security bug 1299417 are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.7-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.7-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.5

-   Ticket 47788 - Supplier can skip a failing update, although  it should retry
-   Ticket 48289 - 389-ds-base: ldclt-bin killed by SIGSEGV
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48312 - Crash when doing modrdn on managed entry
-   Ticket 48332 - allow users to specify to relax the FQDN constraint
-   Ticket 48341 - deadlock on connection mutex
-   Ticket 48362 - With exhausted range, part of DNA shared configuration is deleted after server restart
-   Ticket 48369 - RFE - Add config setting to always send the  password expiring time
-   Ticket 48370 - The 'eq' index does not get updated properly when deleting and re-adding attributes in the same modify operation
-   Ticket 48375 - SimplePagedResults -- in the search error case, simple paged results slot was not released.
-   Ticket 48388 - db2ldif -r segfaults from time to time
-   Ticket 48406 - Avoid self deadlock by PR_Lock(conn->c_mutex)
-   Ticket 48412 - worker threads do not detect abnormally closed  connections


389 Directory Server 1.3.4.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.8.

Fedora packages are available from the Fedora 22, 23 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.8-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.8.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.8

-   Various bugs including a security bug 1299417 are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.8-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.8-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.5

-   Ticket 47788 - Supplier can skip a failing update, although  it should retry
-   Ticket 48289 - 389-ds-base: ldclt-bin killed by SIGSEGV
-   Ticket 48305 - perl module conditional test is not conditional when checking SELinux policies
-   Ticket 48312 - Crash when doing modrdn on managed entry
-   Ticket 48332 - allow users to specify to relax the FQDN constraint
-   Ticket 48341 - deadlock on connection mutex
-   Ticket 48362 - With exhausted range, part of DNA shared configuration is deleted after server restart
-   Ticket 48369 - RFE - Add config setting to always send the  password expiring time
-   Ticket 48370 - The 'eq' index does not get updated properly when deleting and re-adding attributes in the same modify operation
-   Ticket 48375 - SimplePagedResults -- in the search error case, simple paged results slot was not released.
-   Ticket 48388 - db2ldif -r segfaults from time to time
-   Ticket 48406 - Avoid self deadlock by PR_Lock(conn->c_mutex)
-   Ticket 48412 - worker threads do not detect abnormally closed  connections
-   Ticket 48445 - keep alive entries can break replication
-   Ticket 48448 - dirsrv start-stop fail in certain shell environments.
-   Ticket 48492 - heap corruption at schema replication.
-   Ticket 48536 - Crash in slapi_get_object_extension


389 Directory Server 1.3.4.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.9.

Fedora packages are available from the Fedora 22 and 23 repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.9-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.4.9.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.5.tar.bz2).

### Highlights in 1.3.4.9

-   Various bugs are fixed.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.9-1.fc22> and <https://admin.fedoraproject.org/updates/389-ds-base-1.3.4.9-1.fc23>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.4.8

-   Ticket 48759 - no plugin calls in tombstone purging
-   Ticket 48757 - License tag does not match actual license of code
-   Ticket 48746 - Crash when indexing an attribute with a matching rule
-   ticket 48497 - extended search without MR indexed attribute prevents later indexing with that MR
-   Ticket 48368 - Resolve the py.test conflicts with the create_test.py issue
-   Ticket 48420 - change severity of some messages related to "keep alive" entries
-   Ticket 48748 - Fix memory_leaks test suite teardown failure
-   Ticket 48270 - fail to index an attribute with a specific matching rule



389 Directory Server 1.3.5.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.13.

Fedora packages are available from the Fedora 24, 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.13-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.13.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.13

-   A security bug fix and lots of bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.13-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.5.4

-   CVE-2016-4992 389-ds-base: Information disclosure via repeated use of LDAP ADD operation, etc.
-   Ticket 47538 - Fix repl-monitor color and lag times
-   Ticket 47538 - repl-monitor.pl legend not properly sorted
-   Ticket 47538 - repl-monitor.pl not displaying correct color code for lag time
-   Ticket 47664 - Move CI test to the pr suite and refactor
-   Ticket 47824 - Remove CI test from tickets and add logging
-   Ticket 47911 - split out snmp agent into a subpackageTicket 47911
-   Ticket 47976 - Add fixed CI test case
-   Ticket 47982 - Fix log hr timestamps when invalid value is set in cn=config
-   Ticket 48109 - substring index with nssubstrbegin: 1 is not being used with filters like (attr=x*)
-   Ticket 48144 - Add /usr/sbin/status-dirsrv script to get the status of the directory server instance.
-   Ticket 48191 - Move CI test to the pr suite and refactor
-   Ticket 48234 - "matching rules" in ACI's "bind rules not fully evaluated
-   Ticket 48234 - CI test: test case for ticket 48234
-   Ticket 48275 - search returns no entry when OR filter component contains non readable attribute
-   Ticket 48326  - Move CI test to config test suite and refactor
-   Ticket 48336 - Missing semanage dependency
-   Ticket 48336 - setup-ds should detect if port is already defined
-   Ticket 48346 - ldaputil code cleanup
-   Ticket 48346 - log too verbose when re-acquiring expired  ticket
-   Ticket 48354 - Review of default ACI in the directory server
-   Ticket 48363 - CI test - add test suite
-   Ticket 48366 - proxyauth does not work bound as directory manager
-   Ticket 48404 - libslapd owned by libs and devel
-   Ticket 48449 - Import readNSState from richm's repo
-   Ticket 48449 - Import readNSState.py from RichM's repo
-   Ticket 48450 - Add prestart work around for systemd ask password
-   Ticket 48450 - Autotools components for ds_systemd_ask_password_acl
-   Ticket 48617 - Coverity fixes
-   Ticket 48636 - Fix config validation check
-   Ticket 48636 - Improve replication convergence
-   Ticket 48637 - DN cache is not always updated when ADD  operation fails
-   Ticket 48743 - If a cipher is disabled do not attempt to look it up
-   Ticket 48745 - Matching Rule caseExactIA5Match indexes incorrectly values with upper cases
-   Ticket 48745 - Matching Rule caseExactIA5Match indexes incorrectly values with upper cases
-   Ticket 48747 - dirsrv service fails to start when nsslapd-listenhost is configured
-   Ticket 48752 - Page result search should return empty cookie if there is no returned entry
-   Ticket 48752 - Add CI test
-   Ticket 48754 - ldclt should support -H
-   Ticket 48755 - moving an entry could make the online init fail
-   Ticket 48755 - CI test: test case for ticket 48755
-   Ticket 48766 - Replication changelog can incorrectly skip over updates
-   Ticket 48767 - flow control in replication also blocks receiving results
-   Ticket 48795 - Make various improvements to create_test.py
-   Ticket 48799 - Test cases for objectClass values being dropped.
-   Ticket 48815 - ns-accountstatus.pl - fix DN normalization
-   Ticket 48832 - Fix timing and localhost issues
-   Ticket 48832 - CI tests
-   Ticket 48833 - 389 showing inconsistent values for shadowMax and shadowWarning in 1.3.5.1
-   Ticket 48834 - Fix jenkins: discared qualifier on auditlog.c
-   Ticket 48834 - Modifier's name is not recorded in the audit log with modrdn and moddn operations
-   Ticket 48844 - Regression introduced in matching rules by DS 48746
-   Ticket 48846 - 32 bit systems set low vmsize
-   Ticket 48846 - Older kernels do not expose memavailable
-   Ticket 48846 - Rlimit checks should detect RLIM_INFINITY
-   Ticket 48848 - modrdn deleteoldrdn can fail to find old attribute value, perhaps due to case folding
-   Ticket 48849 - Systemd introduced incompatible changes that breaks ds build
-   Ticket 48850 - Correct memory leaks in pwdhash-bin and ns-slapd
-   Ticket 48854 - Running db2index with no options breaks replication
-   Ticket 48855 - Add basic pwdPolicy tests
-   Ticket 48858 - Segfault changing nsslapd-rootpw
-   Ticket 48862 - At startup DES to AES password conversion causes timeout in start script
-   Ticket 48863 - remove check for vmsize from util_info_sys_pages
-   Ticket 48870 - Correct plugin execution order due to changes in exop
-   Ticket 48872 - Fix segfault and use after free in plugin shutdown
-   Ticket 48873 - Backend should accept the reduced cache allocation when issane == 1
-   Ticket 48877 - Fixes for RPM spec with spectool
-   Ticket 48880 - adding pre/post extop ability
-   Ticket 48882 - server can hang in connection list processing
-   Ticket 48889 - ldclt - fix man page and usage info
-   Ticket 48891 - ns-slapd crashes during the shutdown after adding attribute with a matching rule
-   Ticket 48892 - Wrong result code display in audit-failure log
-   Ticket 48893 - cn=config should not have readable components to anonymous
-   Ticket 48895 - tests package should be noarch
-   Ticket 48898 - Crash during shutdown if nunc-stans is enabled
-   Ticket 48899 - Values of dbcachetries/dbcachehits in cn=monitor could overflow.
-   Ticket 48900 - Add connection perf stats to logconv.pl
-   Ticket 48902 - Strdup pwdstoragescheme name to prevent misbehaving plugins
-   Ticket 48904 - syncrepl search returning error 329; plugin sending a bad error code
-   Ticket 48905 - coverity defects
-   Ticket 48912 - ntUserNtPassword schema
-   Ticket 48914 - db2bak.pl task enters infinitive loop when bak fs is almost full
-   Ticket 48916 - DNA Threshold set to 0 causes SIGFPE
-   Ticket 48918 - Upgrade to 389-ds-base >= 1.3.5.5 doesn't install 389-ds-base-snmp
-   Ticket 48919 - Compiler warnings while building 389-ds-base on RHEL7
-   Ticket 48920 - Memory leak in pwdhash-bin
-   Ticket 48921 - Adding replication and reliability tests
-   Ticket 48922 - Fix crash when deleting backend while import is running
-   Ticket 48924 - Fixup tombstone task needs to set proper flag when updating tombstones
-   Ticket 48925 - slapd crash with SIGILL: Dsktune should detect lack of CMPXCHG16B
-   Ticket 48928 - log of page result cookie should log empty cookie with a different value than 0
-   Ticket 48930 - Paged result search can hang the server
-   Ticket 48934 - remove-ds.pl deletes an instance even if wrong prefix was specified
-   Ticket 48935 - Update dirsrv.systemd file
-   Ticket 48936 - Duplicate collation entries
-   Ticket 48939 - nsslapd-workingdir is empty when ns-slapd is started by systemd
-   Ticket 48940 - DS logs have warning:ancestorid not indexed
-   Ticket 48943 - When fine-grained policy is applied, a sub-tree has a priority over a user while changing password
-   Ticket 48943 - Add CI Test for the password test suite

389 Directory Server 1.3.5.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.14.

Fedora packages are available from the Fedora 24, 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.14-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.14.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.14

-   Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.14-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

-   Ticket 48992 - Total init may fail if the pushed schema is rejected
-   Ticket 48832 - Fix CI test suite for password min age
-   Ticket 48983 - Configure and Makefile.in from new default paths work.
-   Ticket 48983 - Configure and Makefile.in from new default paths work.
-   Ticket 48983 - generate install path info from autotools scripts
-   Ticket 48944 - on a read only replica invalid state info can accumulate
-   Ticket 48766 - use a consumer maxcsn only as anchor if supplier is more advanced
-   Ticket 48921 - CI Replication stress tests have limits set too low
-   Ticket 48969 - nsslapd-auditfaillog always has an explicit path
-   Ticket 48957 - Update repl-monitor to handle new status messages
-   Ticket 48832 - Fix CI tests
-   Ticket 48975 - Disabling CLEAR password storage scheme will  crash server when setting a password
-   Ticket 48369 - Add CI test suite
-   Ticket 48970 - Serverside sorting crashes the server
-   Ticket 48972 - remove old pwp code that adds/removes ACIs
-   Ticket 48957 - set proper update status to replication  agreement in case of failure
-   Ticket 48950 - Add systemd warning to the LD_PRELOAD example in /etc/sysconfig/dirsrv
-   provide backend dir in suffix template
-   Ticket 48953 - Skip labelling and unlabelling ports during the test
-   Ticket 48967 - Add CI test and refactor test suite
-   Ticket 48967 - passwordMinAge attribute doesn't limit the minimum age of the password
-   Fix jenkins warnings about unused vars
-   Ticket 48402 - v3 allow plugins to detect a restore or import
-   Ticket #48969 - nsslapd-auditfaillog always has an explicit path
-   Ticket 48964 - cleanAllRUV changelog purging incorrectly  processes all backends
-   Ticket 48965 - Fix building rpms using rpm.mk
-   Ticket 48965 - Fix generation of the pre-release version
-   Bugzilla 1368956 - man page of ns-accountstatus.pl shows redundant entries for -p port option
-   Ticket 48960 - Crash in import_wait_for_space_in_fifo().
-   Ticket 48832 - Fix more CI test failures
-   Ticket 48958 - Audit fail log doesn't work if audit log disabled.
-   Ticket 48956 - ns-accountstatus.pl showing "activated" user even if it is inactivated
-   Ticket 48954 - replication fails because anchorcsn cannot be found
-   Ticket 48832 - Fix CI tests failures from jenkins server
-   Ticket 48950 - Change example in /etc/sysconfig/dirsrv to use tcmalloc


389 Directory Server 1.3.5.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.15.

Fedora packages are available from the Fedora 24, 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.15-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.14.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.15

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.15-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

-   bz1358565 - Clear and unsalted password types are vulnerable to timing attack (SECURITY FIX)
-   Ticket 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
-   Ticket 48328 - Add missing dependency
-   Ticket 49009 - args debug logging must be more restrictive
-   Ticket 49014 - ns-accountstatus.pl shows wrong status for accounts inactivated by Account policy plugin
-   Ticket 47703 - remove search limit for aci group evaluation
-   Ticket 48909 - Replication stops working in FIPS mode


389 Directory Server 1.3.5.16
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.16.

Fedora packages are available from the Fedora 24, and 25.

The new packages and versions are:

-   389-ds-base-1.3.5.16-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.16.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.16

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.15-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump version to 1.3.5.16-1
- Issue 49188 - retrocl can crash server at shutdown
- Issue 49179 - Missing components in 1.3.5 defaults.inf
- Issue 48989 - Overflow in counters and monitor
- Issue 49095 - targetattr wildcard evaluation is incorrectly case sensitive
- Issue 49065 - dbmon.sh fails if you have nsslapd-require-secure-binds enabled
- Issue 49157 - ds-logpipe.py crashes for non-existing users
- Issue 49045 - Fix double-free in _cl5NewDBFile() error path
- Issue 49170 - sync plugin thread count not handled correctly
- Issue 49158 - fix latest coverity issues
- Issue 49122 - Filtered nsrole that uses nsrole crashes the  server
- Issue 49121 - ns-slapd crashes in ldif_sput due to the output buf size is less than the real size.
- Issue 49008 - check if ruv element exists
- Issue 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
- Issue 49104 - Add CI test
- Issue 49104 - dbscan-bin crashing due to a segmentation fault
- Issue 49079 - deadlock on cos cache rebuild
- Issue 49008 - backport 1.3.5 : aborted operation can leave RUV in incorrect state
- Issue 47973 - custom schema is registered in small caps after schema reload
- Issue 49088 - 389-ds-base rpm postinstall script bugs
- Issue 49082 - Adjusted the CI test case to the fix.
- Issue 49082 - Fix password expiration related shadow attributes
- Issue 49080 - shadowExpire should not be a calculated value
- Issue 49074 - incompatible nsEncryptionConfig object definition prevents RHEL 7->6 schema replication
- Issue 48964 - should not free repl name after purging changelog
- Issue 48964 - cleanallruv changelog purging removes wrong  rid
- Issue 49072 - fix log refactoring
- Issue 49072 - validate memberof fixup task args
- Issue 49071 - Import with duplicate DNs throws unexpected errors
- Issue 47966 - CI test: added test cases for ticket 47966
- Issue 48987 - Heap use after free in dblayer_close_indexes
- Issue 49068 - 1.3.5 use std c99
- Issue 49020 - do not treat missing csn as fatal
- Issue 48133 - v2 Non tombstone entry which dn starting with "nsuniqueid=...," cannot be delete
- Issue 47911 - Move dirsrv-snmp.service to 389-ds-base-snmp package

389 Directory Server 1.3.5.17
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.17.

Fedora packages are available from the Fedora 24, and 25.

The new packages and versions are:

-   389-ds-base-1.3.5.17-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.17.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.17

-   Security fix, Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.15-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump version to 1.3.5.17
- Issue 49221 - During an upgrade the provided localhost name is ignored
- Issue 49220 - Fix for cve 2017-2668 - Remote crash via crafted LDAP messages
- Issue 49210 - Fix regression when checking is password min  age should be checked
- Issue 49205 - Fix logconv.pl man page
- Issue 49035 - dbmon.sh shows pages-in-use that exceeds the cache size
- Issue 49039 - password min age should be ignored if password needs to be reset


389 Directory Server 1.3.5.18
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.18.

Fedora packages are available from the Fedora 24, and 25.

The new packages and versions are:

-   389-ds-base-1.3.5.18-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.18.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.18

-   Bug fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have an Admin Server installed (389-admin), otherwise just run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have an Admin Server installed (389-admin), otherwise just run **setup-ds.pl -u** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as: 

F24 <https://bodhi.fedoraproject.org/updates/FEDORA-2017-f0ace457f7>
F25 <https://bodhi.fedoraproject.org/updates/FEDORA-2017-a4824a5fb4>


If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump version to 1.3.5.18
- Ticket 49273 - Fix logging from previous patch
- Ticket 49273 - bak2db doesn't operate with dbversion
- Ticket 49273 - crash when DBVERSION is corrupt.
- Ticket 49241 - add symblic link location to db2bak.pl output
- Ticket 49157 - fix error in ds-logpipe.py
- Ticket 49246 - ns-slapd crashes in role cache creation
- Ticket 48989 - Re-implement lock counter
- Ticket 48989 - missing return in counter
- Ticket 48989 - Improve counter overflow fix
- Ticket 49157 - ds-logpipe.py crashes for non-existing users
- Ticket 49241 - Update man page and usage for db2bak.pl
- Ticket 49209 - Hang due to omitted replica lock release


389 Directory Server 1.3.5.19
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.19.

Fedora packages are available from the Fedora 25.

The new packages and versions are:

-   389-ds-base-1.3.5.19-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.19.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.19

-   Bugand security fixes

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have an Admin Server installed (389-admin), otherwise just run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have an Admin Server installed (389-admin), otherwise just run **setup-ds.pl -u** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as: 

F25 <https://bodhi.fedoraproject.org/updates/FEDORA-2017-4333359de8>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://github.com/389ds/389-ds-base/new_issue>

- Bump verison to 1.3.5.19
- Ticket 49336 - SECURITY 1.3.5.x: Locked account provides different return code
- Ticket 49330 - Improve ndn cache performance 1.3.5


389 Directory Server 1.3.5.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.1.

Fedora packages are available from the Fedora 24 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.1-2

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.1.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.1

-   Initial 389-ds-base-1.3.5 release.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.1-2.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Initial Changelog

-   nunc-stans - bump version to 0.1.8
-   Ticket 132   - Makefile.am must include header files and template scripts
-   Ticket 142   - [RFE] Default password syntax settings don't work with fine-grained policies
-   Ticket 548   - RFE: Allow AD password sync to update shadowLastChange
-   Ticket 47788 - Only check postop result if its a replication operation
-   Ticket 47840 - add configure option to disable instance specific scripts
-   Ticket 47968 - [RFE] Send logs to journald
-   Ticket 47977 - [RFE] Implement sd_notify mechanism
-   Ticket 47982 - improve timestamp resolution in logs
-   Ticket 48016 - search, matching rules and filter error "unsupported type 0xA9"
-   Ticket 48144 - Add /usr/sbin/status-dirsrv script to get the status of the directory server instance.
-   Ticket 48145 - RFE Add log file for rejected changes
-   Ticket 48147 - Unable to enable DS service for auto start
-   Ticket 48151 - Improve CleanAllRUV task logging
-   Ticket 48218 - cleanAllRUV - modify the existing "force" option to bypass the "replica online" checks
-   Ticket 48244 - No validation check for the value for nsslapd-db-locks.
-   Ticket 48257 - Fix coverity issues - 08/24/2015
-   Ticket 48263 - allow plugins to detect tombstone operations
-   Ticket 48269 - RFE: need an easy way to detect locked accounts locked by inactivity.
-   Ticket 48270 - fail to index an attribute with a specific matching rule/48269
-   Ticket 48280 - enable logging of internal ops in the audit log
-   Ticket 48285 - The dirsrv user/group should be created in rpm %pre, and ideally with fixed uid/gid
-   Ticket 48289 - 389-ds-base: ldclt-bin killed by SIGSEGV
-   Ticket 48290 - No man page entry for - option '-u' of dbgen.pl for adding group entries with uniquemembers
-   Ticket 48294 - Linked Attributes plug-in - won't update links after MODRDN operation
-   Ticket 48295 - Entry cache is not rolled back -- Linked Attributes plug-in - wrong behaviour when adding valid and broken links
-   Ticket 48311 - nunc-stans: Attempt to release connection that is not acquired
-   Ticket 48317 - SELinux port labeling retry attempts are excessive
-   Ticket 48326 - [RFE] it could be nice to have nsslapd-maxbersize default to bigger than 2Mb
-   Ticket 48350 - configure.ac add options for debbuging and security analysis / hardening.
-   Ticket 48351 - Fix buffer overflow error when reading url with len 0
-   Ticket 48363 - Support for rfc3673 '+' to return operational attributes
-   Ticket 48368 - Resolve the py.test conflicts with the create_test.py issue
-   Ticket 48369 - [RFE] response control for password age should be sent by default by RHDS
-   Ticket 48383 - import tasks with dynamic buffer sizes
-   Ticket 48384 - Server startup should warn about values consuming too much ram
-   Ticket 48386 - Clean up dsktune code
-   Ticket 48387 - ASAN invalid read in cos_cache.c
-   Ticket 48394 - lower password history minimum to 1
-   Ticket 48395 - ASAN - Use after free in uiduniq 7bit.c
-   Ticket 48398 - Coverity defect 13352 - Resource leak in auditlog.c
-   Ticket 48400 - ldclt - segmentation fault error while binding
-   Ticket 48420 - change severity of some messages related to "keep alive" entries
-   Ticket 48445 - keep alive entries can break replication
-   Ticket 48446 - logconv.pl displays negative operation speeds
-   Ticket 48497 - extended search without MR indexed attribute prevents later indexing with that MR
-   Ticket 48537 - undefined reference to `abstraction_increment'
-   Ticket 48566 - acl.c attrFilterArray maybe uninitialised.
-   Ticket 48662 - db2index with no attribute args fail.
-   Ticket 48665 - Prevent sefault in ldbm_instance_modify_config_entry
-   Ticket 48746 - Crash when indexing an attribute with a matching rule
-   Ticket 48747 - dirsrv service fails to start when nsslapd-listenhost is configured
-   Ticket 48748 - Fix memory_leaks test suite teardown failure
-   Ticket 48757 - License tag does not match actual license of code
-   Ticket 48759 - no plugin calls in tombstone purging


389 Directory Server 1.3.5.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.3.

Fedora packages are available from the Fedora 24 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.3-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.3.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.3

-   Bug fixes and enhancements.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.1-2.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.5.1

-   Ticket 47536 - Allow usage of OpenLDAP libraries that don't use NSS for crypto
-   Ticket 47536 - CI test: added test cases for ticket 47536
-   Ticket 47840 - default instance scripts if undefined.
-   Ticket 47888 - Add CI test
-   Ticket 47888 - DES to AES password conversion fails if a backend is empty
-   Ticket 47951 - Fix startpid from altering dev/null
-   Ticket 47968 - Disable journald logs by default
-   Ticket 47982 - HR Log timers, regression fix for subsystem logging
-   Ticket 48078 - CI test - paged_results - TET part
-   Ticket 48144 - Add /usr/sbin/status-dirsrv script to get the status of the directory server instance.
-   Ticket 48269 - ns-accountstatus status message improvement
-   Ticket 48342 - DNA: deadlock during DNA_EXTEND_EXOP_REQUEST_OID
-   Ticket 48342 - DNA Deadlock test cases
-   Ticket 48342 - Prevent transaction abort if a transaction has not begun
-   Ticket 48350 - Integrate ASAN into our rpm build process
-   Ticket 48374 - entry cache locks not released in error conditions
-   Ticket 48410 - 389-ds-base - Unable to remove / unregister a DS instance from admin server
-   Ticket 48447 - with-initddir should accept no
-   Ticket 48450 - Systemd password agent support
-   Ticket 48492 - heap corruption at schema replication.
-   Ticket 48597 - Deadlock when rebuilding the group of authorized replication managers
-   Ticket 48662 - db2index with no attribute args fail.
-   Ticket 48710 - auto-dn-suffix unrecognized option
-   Ticket 48769 - Fix white space in extendedop.c
-   Ticket 48769 - RFE: Be_txn extended operation plugin type
-   Ticket 48770 - Improve extended op plugin handling
-   Ticket 48775 - If nsSSL3 is on, even if SSL v3 is not really enabled, a confusing message is logged.
-   Ticket 48779 - Remove startpidfile check in start-dirsrv
-   Ticket 48781 - Vague error message: setup_ol_tls_conn - failed: unable to create new TLS context
-   Ticket 48782 - Make sure that when LDAP_OPT_X_TLS_NEWCTX is set, the value is set to zero.
-   Ticket 48783 - Fix ns-accountstatus.pl syntax error
-   Ticket 48784 - CI test: added test cases for ticket 48784
-   Ticket 48784 - Make the SSL version set to the client library configurable.
-   Ticket 48798 - Enable DS to offer weaker DH params in NSS
-   Ticket 48799 - objectclass values could be dropped on the consumer
-   Ticket 48800 - Cleaning up error buffers
-   Ticket 48801 - ASAN errors during tests
-   Ticket 48802 - Compilation warnings from clang
-   Ticket 48808 - Add test case
-   Ticket 48808 - Paged results search returns the blank list of entries
-   Ticket 48813 - password history is not updated when an admin resets the password
-   Ticket 48815 - ns-accountstatus.sh does handle DN's with single quotes
-   Ticket 48818 - In docker, no one can hear your process hang.
-   Ticket 48822 - (389-ds-base-1.3.5) Fixing coverity issues.
-   Ticket 48824 - Cleanup rpm.mk and 389 specfile


389 Directory Server 1.3.5.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.4.

Fedora packages are available from the Fedora 24 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.4-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.5.4.tar.bz2) and [Download nunc-stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.1.8.tar.bz2).

### Highlights in 1.3.5.4

-   Bug fixes and enhancements.

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://admin.fedoraproject.org/updates/389-ds-base-1.3.5.1-2.fc24>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.3.5.3

-   Ticket 48836 - replication session fails because of permission denied
-   Ticket 48837 - Replication: total init aborted
-   Ticket 48617 - Server ram checks work in isolation
-   Ticket 48220 - The "repl-monitor" web page does not display "year" in date.
-   Ticket 48829 - Add gssapi sasl replication bind test
-   Ticket 48497 - uncomment pytest from CI test
-   Ticket 48828 - db2ldif is not taking into account multiple suffixes or backends
-   Ticket 48818 - Fix case where return code is always -1
-   Ticket 48826 - 52updateAESplugin.pl may fail on older versions of perl
-   Ticket 48825 - Configure make generate invalid makefile


389 Directory Server 1.3.6.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.10

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22895230>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-15b4a0e925>


The new packages and versions are:

-   389-ds-base-1.3.6.10-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.10.tar.bz2)

### Highlights in 1.3.6.10

- Bug fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.10
- Ticket 49439 - cleanallruv is not logging information
- Ticket 49431 - replicated MODRDN fails breaking replication
- Ticket 49402 - Adding a database entry with the same database name that was deleted hangs server at shutdown
- Ticket 48235 - remove memberof lock (cherry-pick error)
- Ticket 49401 - Fix compiler incompatible-pointer-types warnings
- Ticket 49401 - improve valueset sorted performance on delete
- Ticket 48894 - harden valueset_array_to_sorted_quick valueset access
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl line 2565, <$LOGFH> line 4
- Ticket 48235 - Remove memberOf global lock


389 Directory Server 1.3.6.11
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.11

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22974614>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-075a0277f4>

The new packages and versions are:

-   389-ds-base-1.3.6.11-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.11.tar.bz2)

### Highlights in 1.3.6.11

- Bug fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.11
- Ticket 49441 - Import crashes with large indexed binary attributes
- Ticket 49436 - double free in COS under some conditions


389 Directory Server 1.3.6.12
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.12

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=23264569>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-b3a6321ce3>

The new packages and versions are:

-   389-ds-base-1.3.6.12-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.12.tar.bz2)

### Highlights in 1.3.6.12

- Bug fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.12
- Ticket 49298 - fix complier warn
- Ticket 49298 - Correct error codes with config restore.
- Ticket 49410 - opened connection can remain no longer poll, like hanging


389 Directory Server 1.3.6.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.13

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1022740>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-7f7f7051e9>

The new packages and versions are:

-   389-ds-base-1.3.6.13-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.13.tar.bz2)

### Highlights in 1.3.6.13

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.13
- CVE-2017-15134 - Remote DoS via search filters in slapi_filter_sprintf
- Ticket 49463 - After cleanALLruv, there is a flow of keep alive DEL
- Ticket 49509 - Indexing of internationalized matching rules is failing
- Ticket 49524 - Password policy: minimum token length fails  when the token length is equal to attribute length
- Ticket 49495 - Fix memory management is vattr.
- Ticket 48118 - Changelog can be erronously rebuilt at startup
- Ticket 49474 - sasl allow mechs does not operate correctly


389 Directory Server 1.3.6.14
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.14

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=25528676>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-fde12c6385>

The new packages and versions are:

-   389-ds-base-1.3.6.14-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.14.tar.bz2)

### Highlights in 1.3.6.14

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.14
- Ticket 49545 - final substring extended filter search returns invalid result (security fix)
- Ticket 49471 - heap-buffer-overflow in ss_unescape
- Ticket 49296 - Fix race condition in connection code with anonymous limits
- Ticket 49568 - Fix integer overflow on 32bit platforms


389 Directory Server 1.3.6.15
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.15

Fedora packages are available from the Fedora 26.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26850712>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-bdfd69e662>

The new packages and versions are:

-   389-ds-base-1.3.6.15-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.15.tar.bz2)

### Highlights in 1.3.6.15

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.15
- Ticket 49661 - CVE-2018-1089 - Crash from long search filter
- Ticket 49631 - same csn generated twice
- Ticket 49652 - DENY aci's are not handled properly
- Ticket 49644 - crash in debug build
- Ticket 49619 - adjustment of csn_generator can fail so next generated csn can be equal to the most recent one received


389 Directory Server 1.3.6.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.1.

Fedora packages are available from the Fedora 26 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.6.1-2

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.1.tar.bz2)

### Highlights in 1.3.6.1

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.1
- Issue 49162 - Only check event.m4 if nunc-stans is enabled
- Issue 49156 - Add more IDs and fix docstrings
- Issue 49156 - Fix typo in the import
- Ticket 49160 - Fix sds benchmark and copyright
- Issue 47536 - Fix CI testcase
- Issue 49159 - test_schema_comparewithfiles fails with python-ldap>=2.4.26
- Issue 49156 - Clean up test suites dir structure and docstrings
- Issue 49158 - fix latest coverity issues
- Ticket 49155 - Fix db2ldif path in test
- Issue 49122 - Fix rpm build
- Issue 49044 - Fix script usage and man pages
- Ticket 48707 - Update rfc to accomodate that authid is mandatory
- Ticket 49141 - Enable tcmalloc
- Ticket 49142 - bytes vs unicode in plugin tests
- Ticket 49139 - Update makefile and rpm for import
- Ticket 49139 - Import libsds and nunc-stans for bundling
- Issue 49122 - Filtered nsrole that uses nsrole crashes the  server
- Issue 49147 - Fix tests compatibility with older versions
- Issue 49141 - Fix spec file for tcmalloc
- Issue 49141 - Use tcmalloc by default
- Ticket 49086 - SDN premangaling broken after SASL change
- Ticket 49137 - Add sasl plain test - ds
- Ticket 49138 - Increase systemd timout
- Issue 48226 - Fix CI test
- Ticket 49140 - Remove legacy inst reference in test
- Ticket 49134  Remove hardcoded elements from db lock test
- Fix compiler warning
- Ticket 47925 - Move add and delete operation aci checks to be before plugins.
- Ticket 49086 - public api compatability test for SDN changes.
- Ticket 49116 - Pblock usage analytics
- Ticket 49020 - Add CI test
- Revise README for pagure
- Ticket #49121 - ns-slapd crashes in ldif_sput due to the output buf size is less than the real size.
- Ticket 48085 - Add replica acceptance test suite
- Ticket 49008 - Fix regression in check if ruv element exists
- Ticket 49108 - ds_selinux_port_query doesn't detect ports labeled with range
- Ticket 49057 - Fix tests failures on older versions of DS
- Ticket 49111 - Integrate cmocka skeleton to Directory Server
- Ticket 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
- Ticket 48085 - Add single master replication test suite
- Ticket #49104 - Add CI test
- Ticket #49104 - dbscan-bin crashing due to a segmentation fault
- Ticket 49105 - Sig FPE when ns-slapd has 0 backends.
- Ticket 49075 - Adjust log severity levels
- Ticket 49008 - Add CI test
- Ticket 49008 v2: aborted operation can leave RUV in incorrect state
- Ticket 47973 - CI Test case (test_ticket47973_case)
- Ticket 47973 - CI Test case (test_ticket47973_case)
- Ticket 47973 - custom schema is registered in small caps after schema reload
- Ticket 49089 - List library build deps
- Ticket 49085 - Make a short topology fixture alias
- Ticket #49088 - 389-ds-base rpm postinstall script bugs
- Ticket 49028 - Autosize database cache by default.
- Ticket 49089 - Fix invalid cxxlink statement from hpux
- Ticket 49087 - ds resolve jenkins issues.
- Ticket #49082 - Adjusted the CI test case to the fix.
- Ticket #49082 - Fix password expiration related shadow attributes
- Ticket #49080 - shadowExpire should not be a calculated value
- Ticket 49027 - on secfailure do not store cleartext password content
- Ticket 49031 - Improve memberof with a cache of ancestors for groups
- Ticket 49079: deadlock on cos cache rebuild
- Ticket 48665 - Fix RHEL6 test compatibility issues
- Ticket 49055 - Fix create_test.py issues
- Ticket 48797 - Add freebsd support to ns-slapd: main
- Ticket 49055 - Refactor create_test.py
- Ticket 49060 - Increase number of masters, hubs and consumers in topology
- Ticket 49055 - Clean up test tickets and suites
- Ticket 48964 - should not free repl name after purging changelog
- Ticket 48050 - Refactor acctpolicy_plugin suite
- Ticket 48964 - cleanallruv changelog purging removes wrong  rid
- Ticket 49073: nsDS5ReplicatedAttributeListTotal fails when excluding no attribute
- Ticket 49074 - incompatible nsEncryptionConfig object definition prevents RHEL 7->6 schema replication
- Ticket 48835 - package tests into python site packages - fix rpm
- Ticket 49066 - Memory leaks in server - part 2
- Ticket 49072 - validate memberof fixup task args
- Ticket 49071 - Import with duplicate DNs throws unexpected errors
- Ticket 47858 - Add test case for nsTombstone
- Ticket 48835 - Tests with setup.py.in
- Ticket 49066 - Memory leaks in server
- Ticket 47982 - Add CI test suite ds_logs
- Ticket 49052 - Environment quoting on fedora causes ds to fail to start.
- Ticket 47662 - Better input argument validation and error messages for cli tools
- Ticket 48681 - logconv.pl lists sasl binds with no dn as anonymous
- Ticket 48861: memberof plugin tests suite
- Ticket 48861: Memberof plugins can update several times the same entry to set the same values
- Ticket 48163 - Re-space schema.c
- Ticket 48163 - Read schema from multiple locations
- Ticket 48894 - improve entrywsi delete
- Ticket 49051 - Enable SASL LOGIN/PLAIN support as a precursor to LDAPSSOTOKEN
- Ticket 49020 - do not treat missing csn as fatal
- Ticket 48133 v2 Non tombstone entry which dn starting with "nsuniqueid=...," cannot be delete
- Ticket 49055 - Clean up test suites
- Ticket 48797 - Add freebsd support to ns-slapd: Configure and makefile.
- Ticket 48797 - Add freebsd support to ns-slapd: Add freebsd support for ldaputil
- Ticket 48797 - Add freebsd support to ns-slapd: Add support for dsktune
- Ticket 48797 - Add freebsd support to ns-slapd: Add support for cpp in Fbsd
- Ticket 48797 - Add freebsd support to ns-slapd: Header files
- Ticket 48978 - Fix implicit function declaration
- Ticket 49002 - Remove memset on allocation
- Ticket 49021 - Automatic thread tuning
- Ticket 48894 - Issues with delete of entrywsi with large entries.
- Ticket 49054 - Fix sasl_map unused paramater compiler warnings.
- Ticket 48050 - Add test suite to acctpolicy_plugin
- Ticket 49048 - Fix rpm build failure
- Ticket 49042 - Test failure that expects old default
- Ticket 49042 - Increase cache defaults slightly
- Ticket 48894 - Issue with high number of entry state objects.
- Ticket 48978 - Fix more log refactoring issues
- Ticket 48707 - Draft Ldap SSO Token proposal
- Ticket 49024 - Fix the rest of the CI failures
- Ticket #48987 - Heap use after free in dblayer_close_indexes
- Ticket 48945 - Improve db2ldif error message.
- Ticket 49024 - Fix inst_dir parameter in defaults.inf
- Ticket 49024 - Fix dbdir paths and adjust test cases
- Ticket 48961 - Allow reset of configuration values to defaults.
- Ticket #47911 - Move dirsrv-snmp.service to 389-ds-base-snmp package
- Ticket bz1358565 - Fix compiler warning about unused variable
- Ticket bz1358565 -  clear and unsalted password types are vulnerable to timing attack
- Ticket 49016 - (un)register/migration/remove may fail if there is no suffix on 'userRoot' backend
- Ticket 397 - Add PBKDF2 to Directory Server password storage.
- Ticket 49024 - Fix CI test failures and defaults.inf
- Ticket 49026 - Support nunc-stans pkgconfig
- Ticket 49025 - Upgrade nunc-stans to 0.2.1
- Ticket 48978 - error log refactoring error
- Ticket 49013 - Correct signal handling with NS in DS
- Ticket 49017 - Various minor test failures
- Ticket 48947 - Update default password hash to SSHA512
- Ticket 48328 - Add missing dependency
- Ticket 49009 - args debug logging must be more restrictive
- Ticket 49011 - Remove configure artifacts
- Ticket 48272 - Fix compiler warnings for addn
- Ticket 49014 - ns-accountstatus.pl shows wrong status for accounts inactivated by Account policy plugin
- Ticket 48978 - Fine tune error logging
- Ticket 48982 - Comment about resolving failure to open plugin.
- Ticket 48272 - ADDN Sytle prebind plugin
- Ticket 49012 - Removed un-used counters
- Ticket 47703 - remove search limit for aci group evaluation
- Ticket 48978 - Fix logging format errors and replace LDAP_DEBUG
- Ticket 49006 - Nunc stans use DS stack size
- Ticket 49007 - Update configure scripts
- Ticket 48538 - Failed to delete old semaphore
- Ticket 48978 - Build fails on i686
- Ticket 48909 - Replication stops working in FIPS mode
- Ticket 49007 - Update DS basic test to better work with systemd.
- Ticket 49006 - Enable nunc-stans by default.
- Ticket 48978 - refactor LDADebug() to slapi_log_err()
- Ticket 49005 - Update lib389 to work in containers correctly.
- Ticket 48978 - refactor LDADebug() to slapi_log_err()
- Ticket 48978 - refactor LDADebug() to slapi_log_err()
- Ticket 48982 - When plugin doesn't enable, actually log the path it used
- Ticket 48996 - Fix rpm to work with ns 0.2.0
- Ticket 48996 - remove unused variable.
- Ticket 48996 - update DS for ns 0.2.0
- Ticket 48982 - One line fix, remove unused variable.
- Ticket 48982 - Enabling a plugin that has a versioned so causes overflow
- Ticket 48986 - 47808 triggers overflow in uiduniq.c
- Ticket 48978 - Convert slapi_log_error() to a variadic macro
- Ticket 48992: Total init may fail if the pushed schema is rejected
- Ticket 48978 - Fix CI test to account for new logging format
- Ticket 48978 - Update error logging with new codes
- Ticket 48832 - Fix CI test suite for password min age
- Ticket 48984 - Add lib389 paths module
- Ticket 48983 - Configure and Makefile.in from new default paths work.
- Ticket 48944 - on a read only replica invalid state info can accumulate
- Ticket 48983 - Configure and Makefile.in from new default paths work.
- Ticket 48983 -  generate install path info from autotools scripts
- use a consumer maxcsn only as anchor if supplier is more advanced
- Ticket 48921 - CI Replication stress tests have limits set too low
- Ticket 48906 Allow nsslapd-db-locks to be configurable online
- Ticket 47978 - Refactor slapi_log_error
- Ticket48978 - refactor LDAPDebug()
- Ticket 48978 - Update the logging function to accept sev level
- Ticket 48414 - cleanAllRUV should clean the agreement RUV
- Ticket 48979 - Strict Prototypes
- Ticket 48979 - Allow to compile 389ds with warning Wstrict-prototypes
- Ticket 142 - Refactor and move CI test
- Ticket 48278 - cleanAllRUV should remove keep-alive entry
- Ticket #48969 - nsslapd-auditfaillog always has an explicit path
- Ticket 48957 - Update repl-monitor to handle new status messages
- Ticket 48805 - Sign comparison checks.
- Ticket #48896 - CI test: test case for ticket 48896
- Ticket #48896 - Default Setting for passwordMinTokenLength does not work
- Ticket 48805 - Sign comparison checks.
- Ticket 48805 - Misleading indent and Uninitialised struct member
- Bump version to 1.3.6.0


389 Directory Server 1.3.6.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.3.

Fedora packages are available from the Fedora 26 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.6.3-4

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.3.tar.bz2)

### Highlights in 1.3.6.3

-   Secruity and Bug fixes and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump verson to 1.3.6.3-4
- Issue 49177 - rpm would not create valid pkgconfig files(pt2)
- Bump version to 1.3.6.3-3
- Issue 49186 - Fix NS to improve shutdown relability
- Issue 49174 - nunc-stans can not use negative timeout
- Issue 49076 - To debug DB_DEADLOCK condition, allow to reset DB_TXN_NOWAIT flag on txn_begin
- Issue 49188 - retrocl can crash server at shutdown
- Issue 47840 - Add setup_ds test suite
- Bump version to 1.3.6.3-2
- Fix srvcore version dependancy
- Bump verson to 1.3.6.3-1
- Issue 48989 - Overflow in counters and monitor
- Issue 49095 - targetattr wildcard evaluation is incorrectly case sensitive
- Issue 49177 - rpm would not create valid pkgconfig files
- Issue 49176 - Remove tcmalloc restriction from s390x
- Issue 49157 - ds-logpipe.py crashes for non-existing users
- Issue 49065 - dbmon.sh fails if you have nsslapd-require-secure-binds enabled
- Issue 49095 - Fix double-free in _cl5NewDBFile() error path
- Bump verson to 1.3.6.2-2
- Issue 49169 - Fix covscan errors(regression)
- Issue 49172 - Fix test schema files
- Issue 49171 - Nunc Stans incorrectly reports a timeout
- Issue 49169 - Fix covscan errors
- Bump version to 1.3.6.2-1
- Issue 49164 - Change NS to acq-rel semantics for atomics
- Issue 49154 - Nunc Stans stress should assert it has 95% success rate
- Issue 49165 - pw_verify did not handle external auth
- Issue 49062 - Reset agmt update staus and total init
- Issue 49151 - Remove defunct selinux policy


389 Directory Server 1.3.6.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.4

Fedora packages are available from the Fedora 26 and Rawhide repositories.

https://bodhi.fedoraproject.org/updates/FEDORA-2017-7f0a10c808

The new packages and versions are:

-   389-ds-base-1.3.6.4-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.4.tar.bz2)

### Highlights in 1.3.6.4

-   Security fix, Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump verson to 1.3.6.4-1
- Ticket 49228 - Fix SSE4.2 detection.
- Ticket 49229 - Correct issues in latest commits
- Ticket 49226 - Memory leak in ldap-agent-bin
- Ticket 49214 - Implement htree concept
- Ticket 49119 - Cleanup configure.ac options and defines
- Ticket 49097 - whitespace fixes for pblock change
- Ticket 49097 - Pblock get/set cleanup
- Ticket 49222 - Resolve various test issues on rawhide
- Issue 48978 - Fix the emergency logging functions severity levels
- Issue 49227 - ldapsearch for nsslapd-errorlog-level returns  incorrect values
- Ticket 49041 - nss won't start if sql db type set
- Ticket 49223 - Fix sds queue locking
- Issue 49204 - Fix 32bit arch build failures
- Issue 49204 - Need to update function declaration
- Ticket 49204 - Fix lower bounds on import autosize + On small VM, autotune breaks the access of the suffixes
- Issue 49221 - During an upgrade the provided localhost name is ignored
- Issue 49220 - Remote crash via crafted LDAP messages (SECURITY FIX)
- Ticket 49184 - Overflow in memberof
- Ticket 48050 - Add account policy tests to plugins test suite
- Ticket 49207 - Supply docker POC build for DS.
- Issue 47662 - CLI args get removed
- Issue 49210 - Fix regression when checking is password min  age should be checked
- Ticket 48864 - Add cgroup memory limit detection to 389-ds
- Issue 48085 - Expand the repl acceptance test suite
- Ticket 49209 - Hang due to omitted replica lock release
- Ticket 48864 - Cleanup memory detection before we add cgroup support
- Ticket 48864 - Cleanup up broken format macros and imports
- Ticket 49153 - Remove vacuum lock on transaction cleanup
- Ticket 49200 - provide minimal dse.ldif for python installer
- Issue 49205 - Fix logconv.pl man page
- Issue 49177 - Fix pkg-config file
- Issue 49035 - dbmon.sh shows pages-in-use that exceeds the cache size
- Ticket 48432 - Linux capabilities on ns-slapd
- Ticket 49196 - Autotune generates crit messages
- Ticket 49194 - Lower default ioblock timeout
- Ticket 49193 - gcc7 warning fixes
- Issue 49039 - password min age should be ignored if password needs to be reset
- Ticket 48989 - Re-implement lock counter
- Issue 49192 - Deleting suffix can hang server
- Issue 49156 - Modify token :assert: to :expectedresults:
- Ticket 48989 - missing return in counter
- Ticket 48989 - Improve counter overflow fix
- Ticket 49190 - Upgrade lfds to 7.1.1
- Ticket 49187 - Fix attribute definition
- Ticket 49185 - Fix memleak in compute init


389 Directory Server 1.3.6.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.5

Fedora packages are available from the Fedora 26 and Rawhide repositories.

https://koji.fedoraproject.org/koji/buildinfo?buildID=884231

The new packages and versions are:

-   389-ds-base-1.3.6.5-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.5.tar.bz2)

### Highlights in 1.3.6.5

-   Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.5-1
- Ticket 49231 - fix sasl mech handling
- Ticket 49233 - Fix crash in persistent search
- Ticket 49230 - slapi_register_plugin creates config entry where it should not
- Ticket 49135 - PBKDF2 should determine rounds at startup
- Ticket 49236 - Fix CI Tests
- Ticket 48310 - entry distribution should be case insensitive
- Ticket 49224 - without --prefix, $prefixdir would be NONE in defaults.


389 Directory Server 1.3.6.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.6

Fedora packages are available from the Fedora 26 and Rawhide repositories.

https://bodhi.fedoraproject.org/updates/FEDORA-2017-8ab2f264a3

The new packages and versions are:

-   389-ds-base-1.3.6.6-1  Fedora 26
-   389-ds-base-1.3.6.6-2  Rawhide(F27)

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.6.tar.bz2)

### Highlights in 1.3.6.6

-   Bug fixes, and enhancements

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** to set up your directory server. setup-ds-admin.pl

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information. setup-ds-admin.pl -u

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.6-1
- Ticket 49157 - fix error in ds-logpipe.py
- Ticket 48864 - remove config.h from spal header.
- Ticket 48681 - logconv.pl - Fix SASL Bind stats and rework report format
- Ticket 49261 - Fix script usage and man pages
- Ticket 49238 - AddressSanitizer: heap-use-after-free in libreplication
- Ticket 48864 - Fix FreeIPA build
- Ticket 49257 - Reject dbcachesize updates while auto cache sizing is enabled
- Ticket 49249 - cos_cache is erroneously logging schema checking failure
- Ticket 49258 - Allow nsslapd-cache-autosize to be modified while the server is running
- Ticket 49247 - resolve build issues on debian
- Ticket 49246 - ns-slapd crashes in role cache creation
- Ticket 49157 - ds-logpipe.py crashes for non-existing users
- Ticket 49241 - Update man page and usage for db2bak.pl
- Ticket 49075 - Adjust logging severity levels
- Ticket 47662 - db2index not properly evaluating arguments
- Ticket 48989 - fix perf counters


389 Directory Server 1.3.6.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.7

Fedora packages are available from the Fedora 26.

https://bodhi.fedoraproject.org/updates/FEDORA-2017-431f07f52a

The new packages and versions are:

-   389-ds-base-1.3.6.7-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.7.tar.bz2)

### Highlights in 1.3.6.7

- Security fix, bug fixes, and enhancements

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.7-1
- Ticket 49330 - Improve ndn cache performance
- Ticket 49298 - fix missing header
- Ticket 49298 - force sync() on shutdown
- Ticket 49336 - SECURITY: Locked account provides different return code
- Ticket 49334 - fix backup restore if changelog exists
- Ticket 49313 - Change the retrochangelog default cache size
- Fix error log format in add.c
- Ticket 49287 - fix compiler warning for patch 49287
- Ticket 49287 - v3 extend csnpl handling to multiple backends
- Ticket 49288 - RootDN Access wrong plugin path in template-dse.ldif.in
- Ticket 49291 - slapi_search_internal_callback_pb may SIGSEV if related pblock has not operation set
- Ticket 49008 - Fix MO plugin betxn test
- Ticket 49227 - ldapsearch does not return the expected Error log level
- Ticket 49028 - Add autotuning test suite
- Ticket 49273 - bak2db doesn't operate with dbversion
- Ticket 49184 - adjust logging level in MO plugin
- Ticket 49257 - only register modify callbacks
- Ticket 49257 - Update CI script
- Ticket 49008 - Adjust CI test for new memberOf behavior
- Ticket 49273 - crash when DBVERSION is corrupt.
- Ticket 49268 - master branch fails on big endian systems
- Ticket 49241 - add symblic link location to db2bak.pl output
- Ticket 49257 - Reject nsslapd-cachememsize & nsslapd-cachesize when nsslapd-cache-autosize is set
- Ticket 48538 - Failed to delete old semaphore
- Ticket 49231 - force EXTERNAL always
- Ticket 49267 - autosize split of 0 results in dbcache of 0


389 Directory Server 1.3.6.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.8

Fedora packages are available from the Fedora 26.

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-c95a212f02>


The new packages and versions are:

-   389-ds-base-1.3.6.8-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.6.8.tar.bz2)

### Highlights in 1.3.6.8

- Bug fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.8
- Ticket 49356 - mapping tree crash can occur during tot init


389 Directory Server 1.3.6.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.6.9

Fedora packages are available from the Fedora 26.

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-800c2374d3> - Fedora 26


The new packages and versions are:

-   389-ds-base-1.3.6.9-1  Fedora 26

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.6.9.tar.bz2)

### Highlights in 1.3.6.9

- Bug fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.6.9
- Ticket 49392 - memavailable not available
- Ticket 49389 - unable to retrieve specific cosAttribute when subtree password policy is configured
- Ticket 49180 - backport 1.3.6 errors log filled with attrlist\_replace - attr\_replace
- Ticket 49379 - Allowed sasl mapping requires restart
- Ticket 49327 - password expired control not sent during grace logins
- Ticket 49380 - Add CI test
- Ticket 49380 - Crash when adding invalid replication agreement
- Ticket 49370 - local password policies should use the same defaults as the global policy
- Ticket 49364 - incorrect function declaration.
- Ticket 49368 - Fix typo in log message


389 Directory Server 1.3.7.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.10

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=25527932>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-8778e84fa9>

The new packages and versions are:

-   389-ds-base-1.3.7.10-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.10.tar.bz2)

### Highlights in 1.3.7.10

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.10
- Ticket 49545 - final substring extended filter search returns invalid result
- Ticket 49161 - memberof fails if group is moved into scope
- ticket 49551 - correctly handle subordinates and tombstone numsubordinates
- Ticket 49296 - Fix race condition in connection code with  anonymous limits
- Ticket 49568 - Fix integer overflow on 32bit platforms
- Ticket 49566 - ds-replcheck needs to work with hidden conflict entries
- Ticket 49551 - fix memory leak found by coverity
- Ticket 49551 - correct handling of numsubordinates for cenotaphs and tombstone delete
- Ticket 49560 - nsslapd-extract-pemfiles should be enabled by default as openldap is moving to openssl
- Ticket 49557 - Add config option for checking CRL on outbound SSL Connections


389 Directory Server 1.3.7.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.2

Fedora packages are available on Fedora 27 and 28(Rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21401020>   - Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21401182>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.2-1 

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.2.tar.bz2)

### Highlights in 1.3.7.2

- Security fix, bug fixes, and enhancements

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.2
- Ticket 49038 - Fix regression from legacy code cleanup
- Ticket 49295 - Fix CI tests
- Ticket 48067 - Add bugzilla tests for ds_logs
- Ticket 49356 - mapping tree crash can occur during tot init
- Ticket 49275 - fix compiler warns for gcc 7
- Ticket 49248 - Add a docstring to account locking test case
- Ticket 49445 - remove dead code
- Ticket 48081 - Add regression tests for pwpolicy
- Ticket 48056 - Add docstrings to basic test suite
- Ticket 49349 - global name 'imap' is not defined
- Ticket 83 - lib389 - Fix tests and create_test.py
- Ticket 48185 - Remove referint-logchanges attr from referint's config
- Ticket 48081 - Add regression tests for pwpolicy
- Ticket 83 - lib389 - Replace topology agmt objects
- Ticket 49331 - change autoscaling defaults
- Ticket 49330 - Improve ndn cache performance.
- Ticket 49347 - reproducable build numbers
- Ticket 39344 - changelog ldif import fails
- Ticket 49337 - Add regression tests for import tests
- Ticket 49309 - syntax checking on referint's delay attr
- Ticket 49336 - SECURITY: Locked account provides different return code
- Ticket 49332 - Event queue is not working
- Ticket 49313 - Change the retrochangelog default cache size
- Ticket 49329 - Descriptive error msg for USN cleanup task
- Ticket 49328 - Cleanup source code
- Ticket 49299 - Add normalized dn cache stats to dbmon.sh
- Ticket 49290 - improve idl handling in complex searches
- Ticket 49328 - Update clang-format config file
- Ticket 49091 - remove usage of changelog semaphore
- Ticket 49275 - shadow warnings for gcc7 - pass 1
- Ticket 49316 - fix missing not condition in clock cleanu
- Ticket 49038 - Remove legacy replication
- Ticket 49287 - v3 extend csnpl handling to multiple backends
- Ticket 49310 - remove sds logging in debug builds
- Ticket 49031 - Improve memberof with a cache of group parents
- Ticket 49316 - Fix clock unsafety in DS
- Ticket 48210 - Add IP addr and connid to monitor output
- Ticket 49295 - Fix CI tests and compiler warnings
- Ticket 49295 - Fix CI tests
- Ticket 49305 - Improve atomic behaviours in 389-ds
- Ticket 49298 - fix missing header
- Ticket 49314 - Add untracked files to the .gitignore
- Ticket 49303 - Fix error in CI test
- Ticket 49302 - fix dirsrv importst due to lib389 change
- Ticket 49303 - Add option to disable TLS client-initiated renegotiation
- Ticket 49298 - force sync() on shutdown
- Ticket 49306 - make -f rpm.mk rpms produces build without tcmalloc enabled
- Ticket 49297 - improve search perf in bpt by removing a deref
- Ticket 49284 - resolve crash in memberof when deleting attrs
- Ticket 49290 - unindexed range searches don't provide notes=U
- Ticket 49301 - Add one logpipe test case


389 Directory Server 1.3.7.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.3

Fedora packages are available on Fedora 27 and 28(Rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21607186>   - Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21607237>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.3-1 

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.3.tar.bz2)

### Highlights in 1.3.7.3

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.3
- Ticket 49354 - fix regression in total init due to mistake in range fetch
- Ticket 49370 - local password policies should use the same defaults as the global policy
- Ticket 48989 - Delete slow lib389 test
- Ticket 49367 - missing braces in idsktune
- Ticket 49364 - incorrect function declaration.
- Ticket 49275 - fix tls auth regression
- Ticket 49038 - Revise creation of cn=replication,cn=config
- Ticket 49368 - Fix typo in log message
- Ticket 48059 - Add docstrings to CLU tests
- Ticket 47840 - Add docstrings to setup tests
- Ticket 49348 - support perlless and wrapperless install



389 Directory Server 1.3.7.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.4

Fedora packages are available on Fedora 27 and 28(Rawhide).

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21684703>   - Fedora 28

<https://koji.fedoraproject.org/koji/taskinfo?taskID=21684678>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.4-1 

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/389-ds-base-1.3.7.4.tar.bz2)

### Highlights in 1.3.7.4

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.4
- Ticket 49371 - Cleanup update script
- Ticket 48831 - Autotune dncache with entry cache.
- Ticket 49312 - pwdhash -D used default hash algo
- Ticket 49043 - make replication conflicts transparent to clients
- Ticket 49371 - Fix rpm build
- Ticket 49371 - Template dse.ldif did not contain all needed plugins
- Ticket 49295 - Fix CI Tests
- Ticket 49050 - make objectclass ldapsubentry effective immediately


389 Directory Server 1.3.7.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.5

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=974124>   - Fedora 27

The new packages and versions are:

-   389-ds-base-1.3.7.5-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.5.tar.bz2)

### Highlights in 1.3.7.5

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.5 
- Ticket 49327 - Add CI test for password expiration controls 
- Ticket 48085 - CI tests - replication ruvstore 
- Ticket 49381 - Refactor numerous suite docstrings 
- Ticket 48085 - CI tests - replication cl5 
- Ticket 49379 - Allowed sasl mapping requires restart 
- Ticket 49327 - password expired control not sent during grace logins 
- Ticket 49380 - Add CI test 
- Ticket 83 - Fix create_test.py imports 
- Ticket 49381 - Add docstrings to ds_logs, gssapi_repl, betxn 
- Ticket 49380 - Crash when adding invalid replication agreement 
- Ticket 48081 - CI test - password - Ticket 49295 - Fix CI tests 
- Ticket 49295 - Fix CI test for account policy 
- Ticket 49373 - remove unused header file


389 Directory Server 1.3.7.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.6

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22353280`>   - Fedora 27
<https://bodhi.fedoraproject.org/updates/FEDORA-2017-f8b8ef6e03>

The new packages and versions are:

-   389-ds-base-1.3.7.6-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.6.tar.bz2)

### Highlights in 1.3.7.6

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump verson to 1.3.7.6
- Ticket 49038 - remove legacy replication - change cleanup script precedence
- Ticket 49392 - memavailable not available
- Ticket 49320 - Activating already active role returns error 16
- Ticket 49389 - unable to retrieve specific cosAttribute when subtree password policy is configured
- Ticket 49092 - Add CI test for schema-reload
- Ticket 49388 - repl-monitor - matches null string many times in regex
- Ticket 49385 - Fix coverity warnings
- Ticket 49305 - Need to wrap atomic calls
- Ticket 49180 - errors log filled with attrlist\_replace - attr\_replace


389 Directory Server 1.3.7.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.7

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=22895176>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-e79ba6b7d5>

The new packages and versions are:

-   389-ds-base-1.3.7.7-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.7.tar.bz2)

### Highlights in 1.3.7.7

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump verson to 1.3.7.7
- Ticket 48393 - fix copy and paste error
- Ticket 49439 - cleanallruv is not logging information
- Ticket 48393 - Improve replication config validation
- Ticket 49436 - double free in COS in some conditions
- Ticket 48007 - CI test to test changelog trimming interval
- Ticket 49424 - Resolve csiphash alignment issues
- Ticket 49401 - Fix compiler incompatible-pointer-types warnings
- Ticket 49401 - improve valueset sorted performance on delete
- Ticket 48894 - harden valueset_array_to_sorted_quick valueset  access
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl
- Ticket 49374 - server fails to start because maxdisksize is recognized incorrectly
- Ticket 49408 - Server allows to set any nsds5replicaid in the existing replica entry
- Ticket 49407 - status-dirsrv shows ellipsed lines
- Ticket 48681 - Use of uninitialized value in string ne at /usr/bin/logconv.pl line 2565, <$LOGFH> line 4
- Ticket 49386 - Memberof should be ignore MODRDN when the pre/post entry are identical
- Ticket 48006 - Missing warning for invalid replica backoff  configuration
- Ticket 49378 - server init fails
- Ticket 49064 - testcase hardening
- Ticket 49064 - RFE allow to enable MemberOf plugin in dedicated consumer
- Ticket 49402 - Adding a database entry with the same database name that was deleted hangs server at shutdown
- Ticket 49394 - slapi_pblock_get may leave unchanged the provided variable
- Ticket 48235 - remove memberof lock (cherry-pick error)
- Ticket 48235 - Remove memberOf global lock
- Ticket 49363 - Merge lib389, all lib389 history in single patch


389 Directory Server 1.3.7.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.8

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=23264039>

<https://bodhi.fedoraproject.org/updates/FEDORA-2017-ab83b12bb0>

The new packages and versions are:

-   389-ds-base-1.3.7.8-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.8.tar.bz2)

### Highlights in 1.3.7.8

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.8
- Ticket 49298 - fix complier warn
- Ticket 49298 - Correct error codes with config restore.
- Ticket 49435 - Fix NS race condition on loaded test systems
- Ticket 49454 - SSL Client Authentication breaks in FIPS mode
- Ticket 49410 - opened connection can remain no longer poll, like hanging
- Ticket 48118 - fix compiler warning for incorrect return type
- Ticket 49443 - scope one searches in 1.3.7 give incorrect results
- Ticket 48118 - At startup, changelog can be erronously rebuilt after a normal shutdown
- Ticket 49377 - Incoming BER too large with TLS on plain port
- Ticket 49441 - Import crashes with large indexed binary attributes


389 Directory Server 1.3.7.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.7.9

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1022742>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-3d60a6932b>

The new packages and versions are:

-   389-ds-base-1.3.7.9-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.7.9.tar.bz2)

### Highlights in 1.3.7.9

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.7.9
- CVE-2017-15134 - Remote DoS via search filters in  slapi_filter_sprintf
- Ticket 49546 - Fix broken snmp MIB file
- Ticket 49541 - Replica ID config validation fix
- Ticket 49370 - Crash when using a global and local pw  policies
- Ticket 49540 - Indexing task is reported finished too early regarding the backend status
- Ticket 49534 - Fix coverity regression
- Ticket 49541 - repl config should not allow rid 65535 for masters
- Ticket 49370 - Add all the password policy defaults to a new local policy
- Ticket 49526 - Improve create_test.py script
- Ticket 49534 - Fix coverity issues and regression
- Ticket 49523 - memberof: schema violation error message is confusing as memberof will likely repair target entry
- Ticket 49532 - coverity issues - fix compiler warnings & clang issues
- Ticket 49463 - After cleanALLruv, there is a flow of keep alive DEL
- Ticket 48184 - close connections at shutdown cleanly.
- Ticket 49509 - Indexing of internationalized matching rules is failing
- Ticket 49531 - coverity issues - fix memory leaks
- Ticket 49529 - Fix Coverity warnings: invalid deferences
- Ticket 49413 - Changelog trimming ignores disabled replica-agreement
- Ticket 49446 - cleanallruv should ignore cleaned replica Id in processing changelog if in force mode
- Ticket 49278 - GetEffectiveRights gives false-negative
- Ticket 49524 - Password policy: minimum token length fails  when the token length is equal to attribute length
- Ticket 49493 - heap use after free in csn_as_string
- Ticket 49495 - Fix memory management is vattr.
- Ticket 49471 - heap-buffer-overflow in ss_unescape
- Ticket 49449 - Load sysctl values on rpm upgrade.
- Ticket 49470 - overflow in pblock_get
- Ticket 49474 - sasl allow mechs does not operate correctly
- Ticket 49460 - replica_write_ruv log a failure even when it succeeds


389 Directory Server 1.3.8.10
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.10

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30171199>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-a857a4758e>


The new packages and versions are:

-   389-ds-base-1.3.8.10-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.10.tar.bz2)

### Highlights in 1.3.8.10

- Bug and security fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.10
- Ticket 49969 - DOS caused by malformed search operation (part 2)



389 Directory Server 1.3.8.1
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.1

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=26850516>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-0113049e0c>

The new packages and versions are:

-   389-ds-base-1.3.8.1-1 

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.1.tar.bz2)

### Highlights in 1.3.8.1

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.1
- Ticket 49661 - CVE-2018-1089 - Crash from long search filter
- Ticket 49652 - DENY aci's are not handled properly
- Ticket 49649 - Use reentrant crypt_r()
- Ticket 49644 - crash in debug build
- Ticket 49631 - same csn generated twice
- Ticket 48184 - revert previous patch around unuc-stans shutdown crash
- Rebase to 1.3.8 from 1.3.7.10


389 Directory Server 1.3.8.2
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.2

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=27171470>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-f440642085>

The new packages and versions are:

-   389-ds-base-1.3.8.2-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.2.tar.bz2)

### Highlights in 1.3.8.2

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.2
- Ticket 48184 - clean up and delete connections at shutdown (2nd try)
- Ticket 49696 - replicated operations should be serialized
- Ticket 49671 - Readonly replicas should not write internal ops to changelog
- Ticket 49665 - Upgrade script doesn't enable CRYPT password storage plug-in
- Ticket 49665 - Upgrade script doesn't enable PBKDF2 password storage plug-in


389 Directory Server 1.3.8.3
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.3

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=27563282>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-34937d412d>

The new packages and versions are:

-   389-ds-base-1.3.8.3-2

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.3.tar.bz2)

### Highlights in 1.3.8.3

- Security and bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.3-2
- Ticket 49576 - ds-replcheck: fix certificate directory verification
- Ticket 49746 - Additional compiler errors on ARM
- Ticket 49746 - Segfault during replication startup on Arm device
- Ticket 49742 - Fine grained password policy can impact search performance
- Ticket 49768 - Under network intensive load persistent search can erronously decrease connection refcnt
- Ticket 49765 - compiler warning
- Ticket 49765 - Async operations can hang when the server is running nunc-stans
- Ticket 49748 - Passthru plugin startTLS option not working
- Ticket 49736 - Hardening of active connection list
- Ticket 48184 - clean up and delete connections at shutdown (3rd)
- Ticket 49726 - DS only accepts RSA and Fortezza cipher families
- Ticket 49722 - Errors log full of " WARN - keys2idl - recieved NULL idl from index_read_ext_allids, treating as empty set" messages
- Ticket 49576 - Add support of ";deletedattribute" in ds-replcheck
- Ticket 49576 - Update ds-replcheck for new conflict entries



389 Directory Server 1.3.8.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.4

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=27769199>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-84c640b8fa>


The new packages and versions are:

-   389-ds-base-1.3.8.4-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.4.tar.bz2)

### Highlights in 1.3.8.4

- Bug fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.4
- Ticket 49751 - passwordMustChange attribute is not honored by a RO consumer if using "Chain on Update"
- Ticket 49734 - Fix various issues with Disk Monitoring
- Ticket 49788 - Fixing 4-byte UTF-8 character validation


389 Directory Server 1.3.8.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.5

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28375593>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-997817e633>


The new packages and versions are:

-   389-ds-base-1.3.8.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.5.tar.bz2)

### Highlights in 1.3.8.5

- Bug fixes and Security fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.5
- Ticket 49789 - By default, do not manage unhashed password (Security Fix)
- Ticket 49546 - Fix issues with MIB file
- Ticket 49840 - ds-replcheck command returns traceback errors against ldif files having garbage content when run in offline mode
- Ticket 48818 - For a replica bindDNGroup, should be fetched the first time it is used not when the replica is started
- Ticket 49780 - acl_copyEval_context double free
- Ticket 49830 - Import fails if backend name is "default"
- Ticket 49432 - filter optimise crash
- Ticket 49372 - filter optimisation improvements for common queries
- Update Source0 URL in rpm/389-ds-base.spec.in


389 Directory Server 1.3.8.6
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.6

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28470951>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-3c876babb9>


The new packages and versions are:

-   389-ds-base-1.3.8.6-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.6.tar.bz2)

### Highlights in 1.3.8.6

- Bug fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.6
- Ticket 49789 - backout original security fix as it caused a regression in FreeIPA


389 Directory Server 1.3.8.7
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.7

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=28971371>

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-a45016e03f>


The new packages and versions are:

-   389-ds-base-1.3.8.7-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.7.tar.bz2)

### Highlights in 1.3.8.7

- Bug fix and security fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.7
- Ticket 49890 - SECURITY FIX - ldapsearch with server side sort crashes the ldap server
- Ticket 49893 - disable nunc-stans by default


389 Directory Server 1.3.8.8
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.8

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1139178>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-ab880c1bc5>


The new packages and versions are:

-   389-ds-base-1.3.8.8-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.8.tar.bz2)

### Highlights in 1.3.8.8

- Bug fix and security fix

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.8
- Revert "Ticket 49372 - filter optimisation improvements for common queries"
- Revert "Ticket 49432 - filter optimise crash"



389 Directory Server 1.3.8.9
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.8.9

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30150274>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-143c134572>


The new packages and versions are:

-   389-ds-base-1.3.8.9-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.8.9.tar.bz2)

### Highlights in 1.3.8.9

- Bug and security fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Bump version to 1.3.8.9
- Ticket 49969 - DOS caused by malformed search operation (security fix)
- Ticket 49954 - On s390x arch retrieved DB page size is stored as size_t rather than uint32_t
- Ticket 49937 - Log buffer exceeded emergency logging msg is not thread-safe (security fix)
- Ticket 49932 - Crash in delete_passwdPolicy when persistent search connections are terminated unexpectedly


389 Directory Server 1.3.9.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.9.0

Fedora packages are available on Fedora 27.

<https://koji.fedoraproject.org/koji/taskinfo?taskID=30581994>

Bodhi

<https://bodhi.fedoraproject.org/updates/FEDORA-2018-8adbba96b5>


The new packages and versions are:

-   389-ds-base-1.3.9.0-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.3.9.0.tar.bz2)

### Highlights in 1.3.9.0

- Bug and security fixes

### Installation and Upgrade 
See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds** yum install 389-ds After install completes, run **setup-ds-admin.pl** if you have 389-admin installed, otherwise please run **setup-ds.pl** to set up your directory server.

To upgrade, use **yum upgrade** yum upgrade After upgrade completes, run **setup-ds-admin.pl -u** if you have 389-admin installed, otherwise please run **setup-ds.pl** to update your directory server/admin server/console information.

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>

If you find a bug, or would like to see a new feature, file it in our GitHub project: <https://github.com/389ds/389-ds-base>

- Branching 1.3.8 to 1.3.9
- Ticket 49967 - entry cache corruption after failed MODRDN
- Ticket 49968 - Confusing CRITICAL message: list_candidates - NULL idl was recieved from filter_candidates_ext
- Ticket 49915 - fix compiler warnings (2nd)
- Ticket 49915 - fix compiler warnings
- Ticket 49915 - Master ns-slapd had 100% CPU usage after starting replication and replication cannot finish

