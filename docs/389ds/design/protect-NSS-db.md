---
title: "Directory Server protection of NSS DB content"
---
    
# protection of NSS DB content
----------------

This document describes how Directory Server will protect NSS database access. Using Keyring or Clevis/Tang we can prevent NSS sensitive files (passwords, extracted keys and certificates) to be compromised.

Overview
--------

Directory servers installation contains some sensitive files. Relying on the rights of the files looks as a weak protection in case of an attack. The idea is either to remove those files or to make the content of those files useless if compromised. This document details two different approaches '<b>Keyring</b> and <b>Clevis/Tang</b>.

Use Cases
---------

DS is configured with secure port. The administrator wants DS to be start without being prompted for NSS password.
To do So he creates a pin file (pin.txt) that is used to initialize the NSS database and extract key/certs.
Someone connected on the Directory server host, with the appropriate rights, can use the pin.txt file to read/write NSS database.

Design
------

    The proposed solution. This may include but is not limited to:

    -   new schema
    -   syntax of commands
    -   logic flow
    -   access control considerations

    Implementation
    --------------

    Any additional requirements or changes discovered during the implementation phase.

    Major configuration options and enablement
    ------------------------------------------

    Any configuration options? Any commands to enable/disable the feature or turn on/off its parts?

    Replication
    -----------

    Any impact on replication?

    Updates and Upgrades
    --------------------

    Any impact on updates and upgrades?

    Dependencies
    ------------

    Any new package and library dependencies.

    External Impact
    ---------------

    Impact on other development teams and components

    Origin
    -------------

    A link to the trac ticket or bugzilla

    Author
    ------

    <you@redhat.com>

