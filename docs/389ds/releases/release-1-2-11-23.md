---
title: "Releases/1.2.11.23"
---
389 Directory Server 1.2.11.23
------------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.2.11.23.

This release is only available in binary form for EL6 - see [Download](download.html) for more details.

The new packages and versions are:

-   389-ds-base-1.2.11.23-3

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.2.11.23.tar.bz2)

### Highlights in 1.2.11.23

-   several logconv improvements
-   [Design/Fine\_Grained\_ID\_List\_Size](../design/fine-grained-id-list-size.html) - ability to set idlistscanlimit based on index, index type, flags, and values
-   Many, many bug fixes - see below

### Installation and Upgrade

See [Download](../download.html) for information about setting up your yum repositories.

To install, use **yum install 389-ds**

`yum install 389-ds`

After install completes, run **setup-ds-admin.pl** to set up your directory server.

`setup-ds-admin.pl`

To upgrade, use **yum upgrade**

`yum upgrade`

After upgrade completes, run **setup-ds-admin.pl -u** to update your directory server/admin server/console information.

`setup-ds-admin.pl -u`

See [Install\_Guide](../legacy/install-guide.html) for more information about the initial installation, setup, and upgrade

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/389>

### Detailed Changelog since 1.2.11.22

Mark Reynolds (11):

-   [Ticket \#356](https://fedorahosted.org/389/ticket/356) - RFE - Track bind info
-   [Ticket 539](https://fedorahosted.org/389/ticket/539) - logconv.pl should handle microsecond timing
-   [Ticket 471](https://fedorahosted.org/389/ticket/471) - logconv.pl tool removes the access logs contents if "-M" is not correctly used
-   [TIcket 419](https://fedorahosted.org/389/ticket/419) - logconv.pl - improve memory management
-   [Ticket 611](https://fedorahosted.org/389/ticket/611) - logconv.pl missing stats for StartTLS, LDAPI, and AUTOBIND
-   [Ticket 47447](https://fedorahosted.org/389/ticket/47447) - logconv.pl man page missing -m,-M,-B,-D
-   [Ticket 47461](https://fedorahosted.org/389/ticket/47461) - logconv.pl - Use of comma-less variable list is deprecated
-   [Ticket 47520](https://fedorahosted.org/389/ticket/47520) - Fix various issues with logconv.pl
-   [Ticket 47509](https://fedorahosted.org/389/ticket/47509) - CLEANALLRUV doesnt run across all replicas

Noriko Hosoi (5):

-   [Ticket \#47492](https://fedorahosted.org/389/ticket/47492) - PassSync removes User must change password flag on the Windows side
-   [Ticket \#47523](https://fedorahosted.org/389/ticket/47523) - Set up replcation/agreement before initializing the sub suffix, the sub suffix is not found by ldapsearch
-   [Ticket \#47534](https://fedorahosted.org/389/ticket/47534) - RUV tombstone search with scope "one" doesn\`t work
-   [Coverity fixes](https://fedorahosted.org/389/ticket/47540) - Coverity fixes 12023, 12024, and 12025
-   [Ticket \#422](https://fedorahosted.org/389/ticket/422) - 389-ds-base - Can't call method "getText"

Rich Megginson (13):

-   [Bug 999634](https://bugzilla.redhat.com/show_bug.cgi?id=999634) - ns-slapd crash due to bogus DN
-   [Ticket \#47516](https://fedorahosted.org/389/ticket/47516) replication stops with excessive clock skew
-   [Ticket \#47504](https://fedorahosted.org/389/ticket/47504) idlistscanlimit per index/type/value
-   [Ticket \#47336](https://fedorahosted.org/389/ticket/47336) - logconv.pl -m not working for all stats
-   [Ticket \#47341](https://fedorahosted.org/389/ticket/47341) - logconv.pl -m time calculation is wrong
-   [Ticket \#47348](https://fedorahosted.org/389/ticket/47341) - add etimes to per second/minute stats
-   [Ticket \#47387](https://fedorahosted.org/389/ticket/47387) - improve logconv.pl performance with large access logs
-   [Ticket \#47501](https://fedorahosted.org/389/ticket/47501) logconv.pl uses /var/tmp for BDB temp files
-   [Ticket 47533](https://fedorahosted.org/389/ticket/47533) logconv: some stats do not work across server restarts

Thierry bordaz (tbordaz) (2):

-   [Ticket 47489](https://fedorahosted.org/389/ticket/47489) - Under specific values of nsDS5ReplicaName, replication may get broken or updates missing
-   [Ticket 47354](https://fedorahosted.org/389/ticket/47354) - Indexed search are logged with 'notes=U' in the access logs

