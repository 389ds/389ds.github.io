---
title: "Releases/1.4.4.5"
---

389 Directory Server 1.4.4.5
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 1.4.4.5

Fedora packages are available on Rawhide (Fedora 33).

<https://koji.fedoraproject.org/koji/buildinfo?buildID=1620743>

The new packages and versions are:

- 389-ds-base-1.4.4.5-1

Source tarballs are available for download at [Download 389-ds-base Source](https://releases.pagure.org/389-ds-base/389-ds-base-1.4.4.5.tar.bz2)

### Highlights in 1.4.4.5

- Bug fixes

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

- Bump version to 1.4.4.5
- Issue 4347 - log when server requires a restart for a plugin to become active (#4352)
- Issue 4297 - On ADD replication URP issue internal searches with filter containing unescaped chars (#4355)
- Issue 4350 - dsrc should warn when tls_cacertdir is invalid (#4353)
- Issue 4351 - improve generated sssd.conf output (#4354)
- Issue 4345 - import self sign cert doc comment (#4346)
- Issue 4342 - UI - additional fixes for creation instance modal
- Issue 3996 - Add dsidm rename option (#4338)
- Issue 4258 - Add server version information to UI
- Issue 4326 - entryuuid fixup did not work correctly (#4328)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (upgrade update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (UI update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4322 - Fix a source link (#4332)
- Issue 4319 - Performance search rate: listener may be erroneously waken up (#4323)
- Issue 4322 - Updates old reference to pagure issue (#4321)
- Issue 4327 - Update issue templates and README.md
- Ticket 51190 - SyncRepl plugin provides a wrong cookie
- Ticket 51121 - Remove hardcoded changelog file name
- Ticket 51253 - dscreate should LDAPI to bootstrap the config
- Ticket 51177 - fix warnings
- Ticket 51228 - Fix lock/unlock wording and lib389 use of methods
- Ticket 51247 - Container Healthcheck failure
- Ticket 51177 - on upgrade configuration handlers
- Ticket 51229 - Server Settings page gets into an unresponsive state
- Ticket 51189 - integrate changelog in main database - update CLI
- Ticket 49562 - integrate changelog database to main database
- Ticket 51165 - Set the operation start time for extended ops
- Ticket 50933 - Fix OID change between 10rfc2307 and 10rfc2307compat
- Ticket 51228 - Clean up dsidm user status command
- Ticket 51233 - ds-replcheck crashes in offline mode
- Ticket 50260 - Fix test according to #51222 fix
- Ticket 50952 - SSCA lacks basicConstraint:CA
- Ticket 50933 - enable 2307compat.ldif by default
- Ticket 50933 - Update 2307compat.ldif
- Ticket 51102 - RFE - ds-replcheck - make online timeout configurable
- Ticket 51222 - It should not be allowed to delete Managed Entry manually
- Ticket 51129 - SSL alert: The value of sslVersionMax "TLS1.3" is higher than the supported version
- Ticket 49487 - Restore function that incorrectly removed by last patch
- Ticket 49481 - remove unused or unnecessary database plugin functions
- Ticket 50746 - Add option to healthcheck to list all the lint reports
- Ticket 49487 - Cleanup unused code
- Ticket 51086 - Fix instance name length for interactive install
- Ticket 51136 - JSON Error output has redundant messages
- Ticket 51059 - If dbhome directory is set online backup fails
- Ticket 51000 - Separate the BDB backend monitors
- Ticket 49300 - entryUSN is duplicated after memberOf operation
- Ticket 50984 - Fix disk_mon_check_diskspace types
- Ticket 50791 - Healthcheck to find notes=F- Bump version to 1.4.4.5
- Issue 4347 - log when server requires a restart for a plugin to become active (#4352)
- Issue 4297 - On ADD replication URP issue internal searches with filter containing unescaped chars (#4355)
- Issue 4350 - dsrc should warn when tls_cacertdir is invalid (#4353)
- Issue 4351 - improve generated sssd.conf output (#4354)
- Issue 4345 - import self sign cert doc comment (#4346)
- Issue 4342 - UI - additional fixes for creation instance modal
- Issue 3996 - Add dsidm rename option (#4338)
- Issue 4258 - Add server version information to UI
- Issue 4326 - entryuuid fixup did not work correctly (#4328)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (upgrade update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement (UI update)
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4209 - RFE - add bootstrap credentials to repl agreement
- Issue 4322 - Fix a source link (#4332)
- Issue 4319 - Performance search rate: listener may be erroneously waken up (#4323)
- Issue 4322 - Updates old reference to pagure issue (#4321)
- Issue 4327 - Update issue templates and README.md
- Ticket 51190 - SyncRepl plugin provides a wrong cookie
- Ticket 51121 - Remove hardcoded changelog file name
- Ticket 51253 - dscreate should LDAPI to bootstrap the config
- Ticket 51177 - fix warnings
- Ticket 51228 - Fix lock/unlock wording and lib389 use of methods
- Ticket 51247 - Container Healthcheck failure
- Ticket 51177 - on upgrade configuration handlers
- Ticket 51229 - Server Settings page gets into an unresponsive state
- Ticket 51189 - integrate changelog in main database - update CLI
- Ticket 49562 - integrate changelog database to main database
- Ticket 51165 - Set the operation start time for extended ops
- Ticket 50933 - Fix OID change between 10rfc2307 and 10rfc2307compat
- Ticket 51228 - Clean up dsidm user status command
- Ticket 51233 - ds-replcheck crashes in offline mode
- Ticket 50260 - Fix test according to #51222 fix
- Ticket 50952 - SSCA lacks basicConstraint:CA
- Ticket 50933 - enable 2307compat.ldif by default
- Ticket 50933 - Update 2307compat.ldif
- Ticket 51102 - RFE - ds-replcheck - make online timeout configurable
- Ticket 51222 - It should not be allowed to delete Managed Entry manually
- Ticket 51129 - SSL alert: The value of sslVersionMax "TLS1.3" is higher than the supported version
- Ticket 49487 - Restore function that incorrectly removed by last patch
- Ticket 49481 - remove unused or unnecessary database plugin functions
- Ticket 50746 - Add option to healthcheck to list all the lint reports
- Ticket 49487 - Cleanup unused code
- Ticket 51086 - Fix instance name length for interactive install
- Ticket 51136 - JSON Error output has redundant messages
- Ticket 51059 - If dbhome directory is set online backup fails
- Ticket 51000 - Separate the BDB backend monitors
- Ticket 49300 - entryUSN is duplicated after memberOf operation
- Ticket 50984 - Fix disk_mon_check_diskspace types
- Ticket 50791 - Healthcheck to find notes=F
