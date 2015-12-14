---
title: "Releases/1.3.4.0"
---
389 Directory Server 1.3.4.0
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.4.0.

Fedora packages are available from the Fedora 22 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.4.0-1

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.4.0.tar.bz2) and [Download nunc-stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.1.4.tar.bz2).

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
