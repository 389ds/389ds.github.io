---
title: "Releases/1.3.3.5"
---
389 Directory Server 1.3.3.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.3.5.

Fedora packages are available from the Fedora 21 and Rawhide repositories.

The new packages and versions are:

-   389-ds-base-1.3.3.5-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.3.5.tar.bz2)

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

Please provide feedback and comments to the 389-users mailing list: <https://admin.fedoraproject.org/mailman/listinfo/389-users>

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
