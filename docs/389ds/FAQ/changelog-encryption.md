---
title: "Changelog Encryption"
---

# Changelog Encryption
----------------------

{% include toc.md %}

Background
==========

When a userPassword is changed in a server with changelog, the hashed password is logged and also a cleartext pseudo-attribute version. It looks like this:

    change::
    replace: userPassword
    userPassword: {SSHA}...
    -
    replace: unhashed#user#password
    unhashed#user#password: password

And this is an example of changing password operation in changelog:

    dbid: 4cfd939f000200010000`
      replgen: 1291686814 Mon Dec  6 17:53:34 2010`
      csn: 4cfd939f000200010000`
      uniqueid: a7a53091-1dd111b2-81f5a953-939e0000`
      dn: uid=testuser,ou=people,o=test.com`
      operation: modify`
        userpassword: {SSHA}...`
        modifiersname: cn=server,cn=plugins,cn=config`
        modifytimestamp: 20101207015334Z`
        unhashed#user#password: password

The current directory server (389 1.2.7-2, RHDS 8.2 and older) does not replicate unhashed password unhashed#user#password. The unhashed password is needed to sync the password with Active Directory. This requirement restricts the usage of the replication topology which is in sync with the Active Directory. That is, passwords need to be replaced on the Directory Server on which the Windows Sync/Password Sync is configured against the Active Directory.

Changes
=======

To ease the restriction, 2 changes are proposed:

1.  replicating unhashed password unhashed\#user\#password to replica,
2.  introducing changelog encryption.

1.  Replicating unhashed password could be a potential security issue. To prevent it, recommend to use secure replication -- SSL, TLS, or SASL.
2.  Storing clear text passwords in change log is a potential vulnerability, as well. Please note that the change (1) does not create the risk. The unhashed password is logged on the server in which the password is updated even before the change (1) is made. This patch replicates it to the other servers and log it on the other masters' changelog. That's said, the password is now logged in multiple changelogs instead of one. But, regardless of the number of servers, it would be safer to have a method to keep any clear passwords hidden. To implement it, changelog encryption is introduced. It works in the same way as the attribute encryption does. That is, the server certificate is required to be installed on the server. Then, configure the changelog. Stop the server, and add "nsslapd-encryptionalgorithm: AES" or "nsslapd-encryptionalgorithm: 3DES" to the changelog entry. The current supported encryption algorithms are AES and 3DES.

        dn: cn=changelog5,cn=config
        objectClass: top
        objectClass: extensibleobject
        cn: changelog5
        nsslapd-changelogdir: /var/lib/dirsrv/slapd-ID/db/changelog
        nsslapd-encryptionalgorithm: AES

At the first time the changelog encryption is initialized, the nsSymmetricKey is added to cn=changelog5 entry.

    nsSymmetricKey:: BASE64_STRING

The encryption/description code is shared with the attribute encryption code in the backend. An API slapi_back_ctrl_info is introduced to implement it.

Warnings
--------

The changelog attributes are not able to change dynamically. To set the encryption algorithm, the server needs to be stopped and restarted. Also, if changelog already contains logs in the clear text, they remain untouched. Another point to make is if encryption algorithm is modified (e.g., from AES to 3DES) while encrypted logs are already in the changelog, the server would replicate garbage. Thus, the algorithm should never be changed if logs are already encrypted with the algorithm.

Steps for Certificate Renewal
=============================

Before renewing the server certificate, export the changelog(s) to ldif file(s). Renew the certificate, then import the ldif file(s) to the changelog(s). "Section 1 Preparation" is for setting up the test environment of the certificate renewal. "Section 2 Update changelog encryption along with the Certificate renewal" describes how to export the changelogs and import them back to the changelog.

    1. Preparation
    1-1. Install 3 servers with at least 2 backend databases to replicate.
       e.g., suffix "dc=example,dc=com", "dc=test,dc=com"
    1-2. Setup SSL on Master servers.
    1-3. Setup Master 1 <--> Master 2
                   |
                   v
               Read only replica
    1-4. Stop Master servers and set nsslapd-encryptionalgorithm.  The allowed value is AES or 3DES.
       dn: cn=changelog5,cn=config
       [...]`
       nsslapd-encryptionalgorithm: AES
    1-5. Restart Master servers, and initialize replicas on each agreement on Master 1.
    1-6. Verify the replication topology is correctly set up by adding at least one entry to each backend on Master servers.
    1-7. Dump Master servers' changelog to confirm the changelogs are encrypted.
         One changelog per replica; 
         If you set up replicas on 2 backends, e.g., dc=example,dc=com and dc=test,dc=com, there are 2 changelog db files.
         # dbscan -f /var/lib/dirsrv/slapd-master[12]/changelogdb/[...].db4
    1-8. Run some modification ops.  E.g.,
       $ infadd -p `<Master 1 port>` -s "dc=example,dc=com" -u "cn=directory manager" -w <password>
       $ infadd -p `<Master 2 port>` -s "dc=test,dc=com" -u "cn=directory manager" -w <password>

    2. Update changelog encryption along with the Certificate renewal
    2-1. Export changelog db on Master servers.
       $ ldapmodify [...]
       dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
       changetype: modify
       add: nsds5Task
       nsds5Task: CL2LDIF

       $ ldapmodify [...]  
       dn: cn=replica,cn=dc\3Dtest\2Cdc\3Dcom,cn=mapping tree,cn=config
       changetype: modify
       add: nsds5Task
       nsds5Task: CL2LDIF

       Monitor the error log /var/log/dirsrv/slapd-master[12]/errors to check the export is successfully finished.
       [...] NSMMReplicationPlugin - Beginning changelog export of replica "5af4cd84-1dd211b2-b4b8f8dd-b6310000"
       [...] NSMMReplicationPlugin - Finished changelog export of replica "5af4cd84-1dd211b2-b4b8f8dd-b6310000"
    2-2. Check the exported changelog file on Master servers (one ldif file per changelog db).
       # ls /var/lib/dirsrv/slapd-master[12]/changelogdb/*.ldif
       /var/lib/dirsrv/slapd-master[12]/changelogdb/[...].ldif
       Changes in each changelog is base64 encoded.  E.g.,
       changetype: add
       replgen: 4d2b599c000000010000
       csn: 4d2b5a9c000000020000
       nsuniqueid: c63f9f01-1dd111b2-ad4a8494-47bd0000
       parentuniqueid: 40bbef65-1dd211b2-b4baf8dd-b6310000
       dn: uid=j0user0,ou=People,dc=test,dc=com
       change:: YWRkOiB1aWQKdWlkOiBqMHVzZXIwCi0KYWRkOiBnaXZlbk5hbWUKZ2l2ZW5OYW1lOiBq
        aWppMAotCmFkZDogb2JqZWN0Q2xhc3MKb2JqZWN0Q2xhc3M6IHRvcApvYmplY3RDbGFzczogcGVy
        c29uCm9iamVjdENsYXNzOiBvcmdhbml6YXRpb25hbFBlcnNvbgpvYmplY3RDbGFzczogaW5ldG9y
        Z3BlcnNvbgotCmFkZDogc24Kc246IHVzZXIwCi0KYWRkOiBjbgpjbjogamlqaTAgdXNlcjAKLQph
        ZGQ6IHVzZXJQYXNzd29yZAp1c2VyUGFzc3dvcmQ6IHtTU0hBfUI5K25pWTkzdE9XYzlhTHF5djdv
        b1MwVUJrdktlaUgzZndxNGFBPT0KLQphZGQ6IGNyZWF0b3JzTmFtZQpjcmVhdG9yc05hbWU6IGNu
        PWRpcmVjdG9yeSBtYW5hZ2VyCi0KYWRkOiBtb2RpZmllcnNOYW1lCm1vZGlmaWVyc05hbWU6IGNu
        PWRpcmVjdG9yeSBtYW5hZ2VyCi0KYWRkOiBjcmVhdGVUaW1lc3RhbXAKY3JlYXRlVGltZXN0YW1w
        OiAyMDExMDExMDE5MTQzNloKLQphZGQ6IG1vZGlmeVRpbWVzdGFtcAptb2RpZnlUaW1lc3RhbXA6
        IDIwMTEwMTEwMTkxNDM2WgotCmFkZDogbnNVbmlxdWVJZApuc1VuaXF1ZUlkOiBjNjNmOWYwMS0x
        ZGQxMTFiMi1hZDRhODQ5NC00N2JkMDAwMAotCmFkZDogdW5oYXNoZWQjdXNlciNwYXNzd29yZAp1
        bmhhc2hlZCN1c2VyI3Bhc3N3b3JkOiBqMHVzZXIwCi0K
       Decode the change and make sure it is not encrypted:
       add: uid
       uid: juser0
       -
       add: givenName
       givenName: jiji
       -
       add: objectClass
       [...]
       -
       add: nsUniqueId
       nsUniqueId: af00b181-1dd111b2-b4bbf8dd-b6310000
       -
       add: unhashed#user#password
       unhashed#user#password: juser0
    2-3. Recommend to back up DBs on each server
       # Stop the servers
       # /usr/lib[64]/dirsrv/slapd-ID/db2bak
    2-4. Stop the server and disable changelog encryption.
       Remove these config entries from dse.ldif (2 entries per backend -- suffix):
         dn: cn=3DES,cn=encrypted attribute keys,cn=`<backend>`,cn=ldbm database,cn=plugins,cn=config
         dn: cn=AES,cn=encrypted attribute keys,cn=`<backend>`,cn=ldbm database,cn=plugins,cn=config
       Remove these config attr values from cn=changelog5,cn=config
         nsslapd-encryptionalgorithm: AES
         nsSymmetricKey:: LrKrvjtihBJA8G5aBohkABd2pUyM7iwn2EO1Y7QpU7iJhHDsfV+j12prQBp3
          [...]
    2-5. Renew the server certificate
    2-6. Stop Master servers and set nsslapd-encryptionalgorithm.  The allowed value is AES or 3DES.
       dn: cn=changelog5,cn=config
       [...]
       nsslapd-encryptionalgorithm: AES
    2-7. Restart the servers and import the changelog
       $ ldapmodify [...]
       dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
       changetype: modify
       add: nsds5Task
       nsds5Task: LDIF2CL

       $ ldapmodify [...]
       dn: cn=replica,cn=dc\3Dtest\2Cdc\3Dcom,cn=mapping tree,cn=config
       changetype: modify
       add: nsds5Task
       nsds5Task: LDIF2CL

       Monitor the error log /var/log/dirsrv/slapd-master[12]/errors to check the import is successfully finished.
       [...] NSMMReplicationPlugin - Beginning changelog import of replica "5af4cd82-1dd211b2-b4b8f8dd-b6310000"
       [...] NSMMReplicationPlugin - Finished changelog import of replica "5af4cd82-1dd211b2-b4b8f8dd-b6310000"
    2-8. For testing, modify something on the both masters and check the change is replicated to the replicas.

Related Bug
===========

[Bug 182507](https://bugzilla.redhat.com/show_bug.cgi?id=182507) - clear-password mod from replica is discarded before changelogged
[Bug 663752](https://bugzilla.redhat.com/show_bug.cgi?id=663752) - Cert renewal for attrcrypt and encchangelog

