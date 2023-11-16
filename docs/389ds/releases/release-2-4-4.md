---
title: "Releases/2.4.4"
---

389 Directory Server 2.4.4
-----------------------------

The 389 Directory Server team is proud to announce 389-ds-base version 2.4.4

Fedora packages are available on Rawhide (f39)

Rawhide:

<https://koji.fedoraproject.org/koji/taskinfo?taskID=109071568>

The new packages and versions are:

- 389-ds-base-2.4.4

Source tarballs are available for download at [Download 389-ds-base Source](https://github.com/389ds/389-ds-base/archive/389-ds-base-2.4.4.tar.gz)


### Highlights in 2.4.4

- Enhancements, and Bug fixes


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

- Bump version to 2.4.4
- Issue 5971 - CLI - Fix password prompt for repl status (#5972)
- Issue 5973 - Fix fedora cop RawHide builds (#5974)
- Revert "Issue 5761 - Worker thread dynamic management (#5796)" (#5970)
- Issue 5966 - CLI - Custom schema object is removed on a failed edit (#5967)
- Issue 5786 - Update permissions for Release workflow
- Issue 5960 - Subpackages should have more strict interdependencies
- Issue 3555 - UI - Fix audit issue with npm - babel/traverse (#5959)
- Issue 4843 - Fix dscreate create-template issue (#5950)
- bugfix for --passwd-file not working on latest version (#5934)
- Issue 5843 - dsconf / dscreate should be able to handle lmdb parameters (#5943)
- Bump postcss from 8.4.24 to 8.4.31 in /src/cockpit/389-console (#5945)
- Issue 5938 - Attribute Names changed to lowercase after adding the Attributes (#5940)
- issue 5924 - ASAN server build crash when looping opening/closing connections (#5926)
- Issue 1925 - Add a CI test (#5936)
- Issue 5732 - Localizing Cockpit's 389ds Plugin using CockpitPoPlugin (#5764)
- Issue 1870 - Add a CI test (#5929)
- Issue 843 - Add a warning to slapi_valueset_add_value_ext (#5925)
- Issue 5761 - Worker thread dynamic management (#5796)
- Issue 1802 - Improve ldclt man page (#5928)
- Issue 1456 - Add a CI test that verifies there is no issue (#5927)
- Issue 1317 - Add a CI test (#5923)
- Issue 1081 - CI - Add more tests for overwriting x-origin issue (#5815)
- Issue 1115 - Add a CI test (#5913)
- Issue 5848 - Fix condition and add a CI test (#5916)
- Issue 5848 - Fix condition and add a CI test (#5916)
- Issue 5914 - UI - server settings page validation improvements and db index fixes
- Issue 5909 - Multi listener hang with 20k connections (#5917)
- Issue 5902 - Fix previous commit regression (#5919)
- Issue 5909 - Multi listener hang with 20k connections (#5910)
- Issue 5722 - improve testcase (#5904)
- Issue 5203 - outdated version in provided metadata for lib389
- issue 5890 part 2 - Need a tester for testing multiple listening thread feature (#5897)
- Issue i5846 - Crash when lmdb import is aborted (#5881)
- Issue 5894 - lmdb import error fails with Could not store the entry (#5895)
- Issue 5890 - Need a tester for testing multiple listening thread feature (#5891)
- Issue 5082 - slugify: ModuleNotFoundError when running test cases
- Issue 4551 - Part 2 - Fix build warning of previous PR (#5888)
- Issue 5834 - AccountPolicyPlugin erroring for some users (#5866)
- Issue 5872 - part 2 - fix is_dbi regression (#5887)
- Issue 4758 - Add tests for WebUI
- Issue 5848 - dsconf should prevent setting the replicaID for hub and consumer roles (#5849)
- Issue 5883 - Remove connection mutex contention risk on autobind (#5886)
- Issue 5872 - `dbscan()` in lib389 can return bytes

- Bump version to 2.4.3-1
- Issue 5729 - Memory leak in factory_create_extension (#5814)
- Issue 5870 - ns-slapd crashes at startup if a backend has no suffix (#5871)
- Issue 5876 - CI Test random failure - Import (#5879)
- Issue 5877 - test_basic_ldapagent breaks test_setup_ds_as_non_root* tests
- Issue 5867 - lib389 should use filter for tarfile as recommended by PEP 706 (#5868)
- Issue 5853 - Update Cargo.lock and fix minor warning (#5854)
- Issue 5785 - CLI - arg completion is broken
- Issue 5864 - Server fails to start after reboot because it's unable to access nsslapd-rundir
- Issue 5856 - SyntaxWarning: invalid escape sequence
- Issue 5859 - dbscan fails with AttributeError: 'list' object has no attribute 'extends'
- Issue 3527 - UI - Add nsslapd-haproxy-trusted-ip to server setting (#5839)
- Issue 4551 - Paged search impacts performance (#5838)
- Issue 4758 - Add tests for WebUI
- Issue 4169 - UI - Fix retrochangelog and schema Typeaheads (#5837)
- issue 5833 - dsconf monitor backend fails on lmdb (#5835)
- Issue 3555 - UI - Fix audit issue with npm - stylelint (#5836)

