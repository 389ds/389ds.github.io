---
title: "Attribute Encryption Design"
---

# Attribute Encryption Design
-----------------------------

{% include toc.md %}

Background
----------

The Directory Server stores data relating to users and other entities. That data might contain some 'sensitive' information that should not be available to anyone beyond those authorized to access it. Typically this is achieved by means of **access control**. However, for certain very sensitive information (for example credit card numbers, private encryption keys or cleartext passwords), access control alone is not considered sufficient to prevent unauthorized access. This is because it may be possible for an attacker to gain access to the server's persistent storage files, either directly from the filesystem or from discarded disk drives or from an archive tape. Given access to those files, all the information stored in the Directory Server to which they belong can be read. This is because that information is stored 'in the clear' within the database.

This feature seeks to guard against this particular attack by encrypting sensitive information while it is stored in the database. Encryption will be configurable on a per-attribute basis. The encryption cipher can be configured on a per-attribute basis. Attribute Encryption leverages the server's existing SSL key management and PIN infrastructure, and uses the same proven [NSS crypto library](http://www.mozilla.org/projects/security/pki/nss/) to perform symmetric encryption.

Note that this feature does not aim to protect against attacks based on recovering sensitive information from system page or swap files.

Attribute Encryption Functionality
---------------------------------

When configured, every instance of a particular attribute will be encrypted prior to storage in the database. This means that all on-disk data for that attribute will be encrypted, including index data. When requested to return an entry with an encrypted attribute to an LDAP client, the server will first decrypt the attribute data, provided certain conditions are met regarding the client using a secure connection.

Supported Ciphers
------------------

The following ciphers will be supported:

1.  DES3 Block Cipher
2.  DES Block Cipher
3.  RC2 Block Cipher
4.  RC4 Stream Cipher

Cipher Configuration
--------------------

Cipher is configurable on a per-attribute basis and must be selected by the administrator at the time encryption is enabled for an attribute. Configuration is done via LDAP with UI support in the Java Console.

Accessing Cleartext via LDAP
----------------------

The server will decrypt encrypted attribute data prior to returning to an LDAP client, but only when that client has connected via a secure channel (SSL/TLS). Therefore, provided a secure connection is use, encryption is transparent to the client. Similarly, the LDAP compare operation compares client-supplied plain text with the decrypted plain text attribute data, but only if the client uses a secure connection. Clients using plain text connections will see the same results as if access control measures were in place to deny their reading or searching on the encrypted attributes.

Key Management
----------------------

Attribute encryption relies upon symmetric block or stream ciphers. These require a single secret key. The key is derived from the private key from a PKI private/public key pair stored in the server's NSS key database. The default key used is that from the server's SSL certificate.

## Affected Server Features
----------------------

Replication
----------------------

When encrypted attribute data is replicated, it is first decrypted into the clear. Re-encryption will be done at the consumer server (provided it's configured appropriately). When encrypted attributes are enabled, replication should be configured to use SSL, in order to protect the cleartext data on-the-wire.

Export and Import from LDIF
---------------------------

Upon export to LDIF, encrypted attributes will be optionally either decrypted and written as cleartext to the ldif file or written as ciphertext. This option is selected with a command line switch. The default is to export the encrypted data. Export of plain text requires that the server's SSL key database PIN be entered by the user.

Existing Data and Encryption Enable/Disable
-------------------------------------------

When encryption is enabled or disabled for a particular attribute, or when the cipher is changed for an attribute that is already configured for encryption, care must be taken to keep the existing database contents consistent with the change. Consistency can be achieved by exporting the database contents to ldif (as plaintext) prior to modifying the attribute encryption configuration, then importing the previously exported ldif after the configuration has been changed. In the case that old, unencrypted data ends up being stored in the database (because the export/import was required but wasn't done), the server will report an error in the error log whenever it sees such an entry. It will also act as if there were no value stored for that particular entry's attribute. In the case that old encrypted data ends up retained in the database with the old cipher, the server will continue to handle that data, but will record an error in the error log. Whenever an effected entry is re-written to the database, the new cipher will be used. If there is known to be no data stored in the database for the affected attributes, this step can be skipped.

Indexing
--------

Because index data is also encrypted (if it were not, then an attacker could potentially recover plain text from the index keys), some related server functionality is affected. Specifically, substring indexing is not supported for encrypted attributes. When either the indexing or attribute encryption configuration is changed, the server enforces referential integrity between the two: that is, it is not possible to put the indexing attribute encryption features in to an inconsistent state.
