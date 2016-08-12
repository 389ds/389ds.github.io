---
title: "Releases/1.3.5.13"
---
389 Directory Server 1.3.5.13
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.5.13.

Fedora packages are available from the Fedora 24, 25 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.5.13-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.5.13.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.8.tar.bz2).

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
