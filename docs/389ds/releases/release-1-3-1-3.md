---
title: "Releases/1.3.1.3"
---
389 Directory Server 1.3.1.3
----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.3.1.3.

Fedora packages are available from the Fedora 19 Testing repositories. It will move to the Fedora 19 Stable repositories once it has received enough karma in Bodhi. We encourage you to test and provide feedback [here](https://admin.fedoraproject.org/updates/389-ds-base-1.3.1.3-1.fc19) in order to speed up the push to the Stable repositories.

The new packages and versions are:

-   389-ds-base-1.3.1.3-1

A source tarball is available for download at [Download Source]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.3.tar.bz2)

### Highlights in 1.3.1.3

-   A feature that allows setting db deadlock rejection policy was added.
-   Bugs in updating userpassword were fixed.
-   A bug in account policy was fixed.
-   A bug in the initializing replica from encrypted database was fixed.
-   A deadlock in MMR with DNA enabled was fixed.
-   A crash bug was fixed in renaming tombstone.

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

### Detailed Changelog since 1.3.1.2

-   Ticket 47374 - flush.pl is not included in perl5
-   Ticket 47391 - deleting and adding userpassword fails to update the password (additional fix)
-   Ticket 47393 - Attribute are not encrypted on a consumer after a full initialization
-   Ticket 47395 47397 - v2 correct behaviour of account policy if only stateattr is configured or no alternate attr is configured
-   Ticket 47396 - crash on modrdn of tombstone
-   Ticket 47400 - MMR stress test with dna enabled causes a deadlock
-   Ticket 47409 - allow setting db deadlock rejection policy
-   Ticket 47419 - Unhashed userpassword can accidentally get removed from mods
-   Ticket 47420 - An upgrade script 80upgradednformat.pl fails to handle a server instance name incuding '-'

