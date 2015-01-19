---
title: "AES Reversible Password Based Encryption"
---

# AES Reversible Password Based Encryption
----------------

Overview
--------

Directory Server was previously using the DES cipher for its password based encryption, this cipher is no longer considered safe to use.  The server will now use AES for its reversible password based encryption.


Use Cases
---------

Deployments using replication where "simple" authentication is being used by the replication agreements.  The chaining plugin uses reversible passwords for its remote authentication.  The DNA plugin uses the replication agreement credentials when trying to connect to remote replica servers.


Design
------

AES Password Based Encryption.  AES requires that the same algorithm ID used to generate the encrypted password must be used to decode the password.  This algorithm ID must be stored for future decodings.  To resolve this dependency, the algorithm ID(SECItem) is first converted to its ASCII equivalent, then it is base64 encoded and stored in the cipher prefix so it can be extracted for future decodings:

    {AES-\<BASE64_ENCODED_ALGORITHM_ID\>}ENCRYPTED_PASSWORD

    nsDS5ReplicaCredentials: {AES-TUhNR0NTcUdTSWIzRFFFRkRUQm1NRVVHQ1NxR1NJYjNEUUVG
     RERBNEJDUmxObUk0WXpjM1l5MHdaVE5rTXpZNA0KTnkxaE9XSmhORGRoT0MwMk1ESmpNV014TUFBQ
     0FRSUNBU0F3Q2dZSUtvWklodmNOQWdjd0hRWUpZSVpJQVdVRA0KQkFFcUJCQk5KbUFDUWFOMHlITW
     dsUVp3QjBJOQ==}bBR3On6cBmw0DdhcRx826g==

Just like with the DES password syntax plugin, use the **nsslapd-pluginargN** attributes to specify which attributes should be AES encoded:

    dn: cn=AES,cn=Password Storage Schemes,cn=plugins,cn=config
    ...
    ...
    nsslapd-pluginarg0: nsmultiplexorcredentials
    nsslapd-pluginarg1: nsds5ReplicaCredentials


Implementation
--------------

The configuration entry "**cn=AES,cn=Password Storage Schemes,cn=plugins,cn=config**" should be used in place of "**cn=DES,cn=Password Storage Schemes,cn=plugins,cn=config**".  The **libdes-plugin** library has also been replaced by a more appropriate name:  **libpbe-plugin**  The new plugin still handles DES, but it also includes AES, or any potential future algorithms.


Major configuration options and enablement
------------------------------------------

There is new configuration plugin entry:

    dn: cn=AES,cn=Password Storage Schemes,cn=plugins,cn=config
    objectClass: top
    objectClass: nsSlapdPlugin
    objectClass: extensibleObject
    cn: AES
    nsslapd-pluginPath: libpbe-plugin
    nsslapd-pluginInitfunc: aes_init
    nsslapd-pluginType: reverpwdstoragescheme
    nsslapd-pluginEnabled: on
    nsslapd-pluginarg0: nsmultiplexorcredentials
    nsslapd-pluginarg1: nsds5ReplicaCredentials
    nsslapd-pluginId: aes-storage-scheme
    nsslapd-pluginprecedence: 1
    nsslapd-pluginVersion: 1.3.4
    nsslapd-pluginVendor: 389 Project
    nsslapd-pluginDescription: AES storage scheme plugin


Replication
-----------

Impacts replication agreements that use simple authentication(aka username and password) where the password is encoded using the DES plugin.


Updates and Upgrades
--------------------

During an upgrade (*setup-ds.pl --update*) there are several processes that need to be performed

   - Add the new AES plugin to the config
   - Make sure that the AES plugin is configured to use the same attributes that were configured in the DES plugin(including the default attributes)
   - Change the DES plugin path to point to the new libary: **libpbe-plugin**
   - Change the replication plugin to depend on AES instead of DES

After the upgrade, the server must be restarted.  When the server is restarted it will internally check for any DES encoded passwords by searching on all the attributes configured in both the DES & AES plugins.  Then all the backends, including "cn=config", are checked for DES encoded passwords.  If any "*DES passwords*" are found the server will decode these passwords and re-encode them using the AES Reversible Password Based Encryption.


Dependencies
------------

None.

External Impact
---------------

None.

Author
------

<mreynolds@redhat.com>

