---
title: Configure Option To Disable Instance Specific Scripts
---

# Configure Option To Disable Instance Specific Scripts
----------------

Overview
--------

Now that https://fedorahosted.org/389/ticket/528 is fixed, the next step is to allow installing the server with the instance specific scripts disabled.

Please see https://fedorahosted.org/389/ticket/47840

Use Cases
---------

389ds will be built with template scripts and will not install them to instances by default.

389ds will be built with template scripts and if requested with setup-ds.pl, will install the scripts along with a deprecation warning.

389ds will be built with templates scripts and upon a setup-ds.pl --upgrade, will prompt the user to delete or preserve the instance directory.

Implementation
--------------

All documentation for 389ds should be updated to reflect the usage of the /usr/sbin/<script> over the per-instance script directory.

The template scripts should be checked to ensure that they are merely templates to the /usr/sbin scripts, rather than still full scripts. This should already have been covered by https://fedorahosted.org/389/ticket/528

setup-ds.pl will gain a new option to enable the installation of the instance directory and script. This should have an option in the .inf setup file. Only when this option is specified will inst_dir become a necessary option to fill in. Otherwise inst_dir is ignored. By default, the installation of these scripts is disabled.

setup-ds.pl in upgrade mode will gain an option to delete the inst_dir. If this is not taken, the scripts will be upgraded as usual. However, a warning should be presented due to deprecation.

At some time in the future, there support for the per-instance script directory should be removed.

Once this is complete, the per-instance script templates will be removed from git.

Replication
-----------

No impact.

Updates and Upgrades
--------------------

See implementation.

Dependencies
------------

No dependencies.

External Impact
---------------

No external impact.


Author
------

nhosoi@redhat.com
wibrown@redhat.com


