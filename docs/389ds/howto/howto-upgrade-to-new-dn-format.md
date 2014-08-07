---
title: "Upgrade to New DN Format"
---

# Upgrade to New DN Format
--------------------------

{% include toc.md %}

Background
==========

Old DN format including DN in the double quotes (e.g., dn: cn="a=b,c=d,e=f",dc=example,dc=com) are currently rejected. We want to support it to keep the backward compatibility. See also [RFC 4514](http://www.ietf.org/rfc/rfc4514.txt) "Lightweight Directory Access Protocol (LDAP): String Representation of Distinguished Names".

Rules to handle DN
==================

1.  DNs sent from LDAP clients are normalized when the server receives it. The normalized DNs are stored in the backend.
2.  DN syntax attributes are also normalized. It happens when creating an entry (Slapi\_Entry). The normalized DN syntax attributes are stored in the backend.
3.  If defining a custom schema, attribute type which stores DN format value must have "Directory String syntax" OID -- 1.3.6.1.4.1.1466.115.121.1.15. Otherwise, the server may not work as expected.
4.  Plugins which generates DN string are supposed to call slapi\_create\_dn\_string instead of slapi\_ch\_smprintf, snprintf, etc. It guarantees the generated DN is valid. Here is an example.

        char \*dn = slapi\_create\_dn\_string("cn=%s,%s", name, PLUGIN\_BASE\_DN);

Newly added APIs
================

    /**    
     * Checks if the attribute uses a DN syntax or not.    
     *    
     * parameters    
     *   attr The attribute to be checked.    
     * return values    
     *   non 0 if the attribute uses a DN syntax.    
     *   0 if the attribute does not use a DN syntax.    
     */    
    int slapi_attr_is_dn_syntax_attr(Slapi_Attr *attr);    

    /**    
     * Normalizes a DN.    
     *    
     * parameters     
     *   src The DN to normalize.    
     *   src_len The length of src DN to normalize. If 0 is given, strlen(src) is used.    
     *   dest The normalized DN.    
     *   dest_len The length of the normalized DN dest.    
     * return values    
     *   0 if successful. The dest DN is normalized in line. Caller must not free dest.    
     *   1 if successful. The dest DN is allocated.  Caller must free dest.    
     *   -1 if an error occurs (for example, if the src DN cannot be normalized)    
     */    
    int slapi_dn_normalize_ext(char *src, size_t src_len, char **dest, size_t *dest_len);    

    /**    
     * Normalizes a DN (in lower-case characters).    
     */    
    int slapi_dn_normalize_case_ext(char *src, size_t src_len, char **dest, size_t *dest_len);    

    /**    
     * Generate a valid DN string.    
     *    
     * parameters    
     *   fmt The format used to generate a DN string.    
     *   ... The arguments to generate a DN string.    
     * return values    
     *   A pointer to the generated DN.  The     
     *   NULL if failed.    
     * note: When a DN needs to be internally created, this function is supposed to be called.      
     * This function allocates the enough memory for the normalized DN and returns it filled     
     * with the normalized DN.    
     */    
    char *slapi_create_dn_string(const char *fmt, ...);    

    /**    
     * Generates a valid DN string (in lower-case characters).    
     */    
    char *slapi_create_dn_string_case(const char *fmt, ...);    

Steps to implement
==================

Initial unescape/escape for DN
------------------------------

    . escaped NEEDSESCAPE chars (e.g., ',', '<', '=', etc.) are converted to ESC HEX HEX (e.g., \2C, \3C, \3D, etc.)    
      input could be a string in double quotes (= old DN format: dn: cn="x=x,y=y",... --> dn: cn=x\3Dx\2Cy\3Dy,...)    
      or an escaped string (= new DN format dn: cn=x\=x\,y\=y,... -> dn: cn=x\3Dx\2Cy\3Dy,...)    
    . all the other ESC HEX HEX are converted to the real characters.    
    . eliminate unnecessary unescaped spaces around ','    

Note: this is done at the first place in the front end. Thus, the rest of the server does not have to expect to see the longer DN.

Normalize when necessary for database keys/comparison/matching
--------------------------------------------------------------

    . when the DN value is used as an attribute value, any ESC HEX HEX characters need to be replaced     
      with the corresponding real character.    

Migration/Upgrade
=================

Double quotes in the old format are included in the appended attribute value. (e.g., dn: cn="a=b,c=d,e=f",dc=... generates "cn: "a=b,c=d,e=f" not "cn: a=b,c=d", which is the key in the index "cn" on DS8.1 and older)

    $ ldapsearch -b "dc=example,dc=com" '(cn="a=b,c=d")'    
    dn: cn="a=b,c=d", dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    sn: a=b,c=d    
    cn: "a=b,c=d"    
    $ ldapsearch -b "dc=example,dc=com" '(cn=a=b,c=d)'    
    $    

In-place-upgrade upgrades DN syntax attribute values which contains an escape character '\\\\' or the value is double quoted. In-place-upgrade internally calls the DN upgrade tool upgradednformat. The tool is provided for checking the necessity of the upgrade as well as for executing the DN upgrade. To run the tool, the Directory Server should have been shutdown.

    Usage: upgradednformat [-N] -n backend_instance -a db_instance_directory    
            -N: dryrun    
                exit code: 0 -- needs upgrade; 1 -- no need to upgrade; -1 -- error    
            -n backend_instance -- instance name to be examined or upgraded    
            -a db_instance_directory -- full path to the db instance dir    
                                        e.g., /var/lib/dirsrv/slapd-ID/db/userRoot    

Sample usage 1 (DB contains DN upgrade candidates)

    # upgradednformat -N -n userRoot -a /var/lib/dirsrv/slapd-ID/work/db/userRoot    
      [...]    
    [...] - upgradedn userRoot: Upgrade Dn Dryrun complete.  userRoot needs upgradednformat.    
    # echo $?    
    0    
    # upgradednformat -n userRoot -a /var/lib/dirsrv/slapd-ID/work/db/userRoot    
      [...]    
    [...] - upgradedn userRoot: Upgrade Dn complete.  Processed 12 entries in 0 seconds. (0.00 entries/sec)    

Sample usage 2 (DB does not contain DN upgrade candidates)

    # upgradednformat -N -n userRoot -a /var/lib/dirsrv/slapd-ID/work/db/userRoot    
      [...]    
    [...] - upgradedn userRoot: Upgrade Dn Dryrun complete.  userRoot is up-to-date.    
    # echo $?    
    1    

Sample usage 3 (rerun upgradednformat against the DB which is already upgraded)

    # upgradednformat -n userRoot -a /var/lib/dirsrv/slapd-ID/db/userRoot    
    [...] Upgrade DN Format - userRoot: Start upgrade dn format.    
    [...] Upgrade DN Format - Instance userRoot in /var/lib/dirsrv/slapd-ID/db/userRoot is up-to-date    
    # echo $?    
    1    

Sample usage 4 (run upgradednformat with the Directory Server up and running)

    # upgradednformat -n userRoot -a /var/lib/dirsrv/slapd-ID/db/userRoot    
    [...] - Unable to upgrade dn format because the database is being used by another slapd process.    
    [...] - Shutting down due to possible conflicts with other slapd processes    
    # echo $?    
    255    

DBVERSION file
--------------

The db directory as well as each db instance directory holds DBVERSION file.

    # cat db/DBVERSION db/userRoot/DBVERSION     
    bdb/4.7/libback-ldbm    
    bdb/4.7/libback-ldbm    

To specify the instance directory is upgraded or up-to-date another DBVERSION ID "dn-4514" has been added. Once the instance directory is upgraded or the dryrun mode finds out the db instance is no need to be upgraded, the DBVERSION file in the instance directory is modified as follows.

    # cat db/userRoot/DBVERSION     
    bdb/4.7/libback-ldbm/dn-4514    

If you create a backend instance using the latest version of the Directory Server, the DBVERSION ID is added from the beginning.

Upgrade Scenario
----------------

0. Older version of directory server is installed and being used

        Assume DB dir has 2 db backend instances abcRoot and userRoot:    
        $ cd /var/lib/dirsrv/slapd-ID
        $ ls -R db    
        db:    
        abcRoot  __db.002  __db.004  __db.006   guardian        userRoot    
        __db.001   __db.003  __db.005  DBVERSION  log.0000000001    
        db/abcRoot:    
        aci.db4         DBVERSION     nsuniqueid.db4       parentid.db4    
        ancestorid.db4  entrydn.db4   numsubordinates.db4  seeAlso.db4    
        cn.db4          id2entry.db4  objectclass.db4      sn.db4    
        db/userRoot:    
        aci.db4         entrydn.db4    nsuniqueid.db4       sn.db4    
        ancestorid.db4  givenName.db4  numsubordinates.db4  telephoneNumber.db4    
        cn.db4          id2entry.db4   objectclass.db4      uid.db4    
        DBVERSION       mail.db4       parentid.db4    

    DBVERSION files look like this:

        $ find . -name DBVERSION | xargs head    
        ==> ./db/abcRoot/DBVERSION <==    
        bdb/4.7/libback-ldbm    
        ==> ./db/DBVERSION <==    
        bdb/4.7/libback-ldbm    
        ==> ./db/userRoot/DBVERSION <==    
        bdb/4.7/libback-ldbm    

1. Upgrade to newer version of directory server

        yum update ...packages..    

    OR

        rpm [-ivh|-Uvh] /path/to/<dirsrv-package-version>.rpm + setup-ds.pl -u (Offline mode)   
 
2. Check the errors log:
    
        # grep "Upgrade Dn.*complete" /var/log/dirsrv/slapd-ID/errors    
        [...] - upgradedn abcRoot: Upgrade Dn Dryrun complete.  abcRoot needs upgradednformat.    
        [...] - upgradedn abcRoot: Upgrade Dn complete.  Processed 2 entries in 1 seconds. (2.00 entries/sec)    
        [...] - upgradedn userRoot: Upgrade Dn Dryrun complete.  Processed 0 entries in 3 seconds. (0.00 entries/sec)    
        [...] - upgradedn userRoot: Upgrade Dn Dryrun complete.  userRoot is up-to-date.    

    These lines tell us that the db backend instance abcRoot contains values that need to be upgraded and the upgrade was executed, while userRoot does not.

3. Check the upgraded DB directories and DBVERSION files

        $ ls -R db    
        db:    
        abcRoot  abcRoot.orig  DBVERSION  guardian  log.0000000001  userRoot    
        db/abcRoot:    
        aci.db4         DBVERSION     nsuniqueid.db4       parentid.db4    
        ancestorid.db4  entrydn.db4   numsubordinates.db4  seeAlso.db4    
        cn.db4          id2entry.db4  objectclass.db4      sn.db4    
        db/abcRoot.orig:    
        aci.db4         DBVERSION    id2entry.db4         objectclass.db4  sn.db4    
        ancestorid.db4  dnupgrade    nsuniqueid.db4       parentid.db4    
        cn.db4          entrydn.db4  numsubordinates.db4  seeAlso.db4    
        db/abcRoot.orig/dnupgrade:    
        DBVERSION  guardian    
        db/userRoot:    
        aci.db4         entrydn.db4    nsuniqueid.db4       sn.db4    
        ancestorid.db4  givenName.db4  numsubordinates.db4  telephoneNumber.db4    
        cn.db4          id2entry.db4   objectclass.db4      uid.db4    
        DBVERSION       mail.db4       parentid.db4    

        # find . -name DBVERSION | xargs head    
        ==> ./db/abcRoot/DBVERSION <==    
        bdb/4.7/libback-ldbm/dn-4514    
        ==> ./db/DBVERSION <==    
        bdb/4.7/libback-ldbm    
        ==> ./db/abcRoot.orig/DBVERSION <==    
        bdb/4.7/libback-ldbm    
        ==> ./db/abcRoot.orig/dnupgrade/DBVERSION <==    
        bdb/4.7/libback-ldbm    
        => ./db/userRoot/DBVERSION <==    
        bdb/4.7/libback-ldbm/dn-4514    

    Under the db directory, there are 2 abcRoot db backend instance directories: abcRoot and abcRoot.orig. abcRoot.orig is an original db backend instance and abcRoot is the upgraded one.

4. Verify the upgraded DB
    
    5-1. Start the server

            # service dirsrv start    

    5-2. Search an entry which could contain escaped characters. 

    A good candidate is an attribute value that could be surrounded by double quotes.
    Assume "dc=test,dc=com" is the suffix of the upgraded db backend instance (abcRoot):

            $ ldapsearch -b "dc=test,dc=com" '(cn=\"*\")' entrydn    
            dn: cn=a\3Dabc\2Cx\3Dxyz,dc=test,dc=com    
            entrydn: cn=a\3dabc\2cx\3dxyz,dc=test,dc=com    
            [...]    

            $ ldapsearch -b "dc=test,dc=com" '(cn=*\"*\"*)' entrydn cn    
            dn: CN=James \22Jim\22 Smith\2CIII,dc=test,dc=com    
            entrydn: cn=james \22jim\22 smith\2ciii,dc=test,dc=com    
            cn: James "Jim" Smith, III    
            cn: James "Jim" Smith,III    
            [...]    

    If the search results are correctly escaped, the original db backend instance directory (abcRoot.orig) could be safely removed.
    If you are using the console, the o=NetscapeRoot suffix has some examples of DNs with escaped DNs in them:

            $ ldapsearch -s one -b "ou=UserPreferences,ou=testdomain.com,o=netscaperoot"    
            dn: ou=uid\3Dadmin\2Cou\3DAdministrators\2Cou\3DTopologyManagement\2Co\3DNetsc    
             apeRoot,ou=UserPreferences,ou=example.com,o=NetscapeRoot    
            objectClass: top    
            objectClass: organizationalUnit    
            ou: uid=admin,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot    

            dn: ou=cn\3Dslapd-example\2Ccn\3D389 Directory Server\2Ccn\3DServer Group\2Ccn\    
             3Dhost.example.com\2Cou\3Dexample.com\2Co\3DNetscapeRoot,ou=UserPrefe    
             rences,ou=example.com,o=NetscapeRoot    
            objectClass: top    
            objectClass: organizationalUnit    
            ou: cn=slapd-example,cn=389 Directory Server,cn=Server Group,cn=host.example    
             .com,ou=example.com,o=NetscapeRoot    

            dn: ou=cn\3DDirectory Manager,ou=UserPreferences,ou=example.com,o=NetscapeR    
             oot    
            objectClass: top    
            objectClass: organizationalUnit    
            ou: cn=Directory Manager    

            dn: ou=cn\3Dadmin-serv-example\2Ccn\3D389 Administration Server\2Ccn\3DServer G    
             roup\2Ccn\3Dhost.example.com\2Cou\3Dexample.com\2Co\3DNetscapeRoot,ou    
             =UserPreferences,ou=example.com,o=NetscapeRoot    
            objectClass: top    
            objectClass: organizationalUnit    
            ou: cn=admin-serv-example,cn=389 Administration Server,cn=Server Group,cn=hos    
             t.example.com,ou=example.com,o=netscaperoot    

    You can see that in the DN, the values are escaped (ou=cn\\3Dadmin-serv.....) but in the entry, the ou value is just the unescaped DN.

    5-3. Login as a user who installed the Directory Server.

        $ rm -rf /var/log/dirsrv/slapd-ID/db/abcRoot.orig    

5. If you could not verify the upgraded db backend instance, replace the upgraded db with the original one.
 make sure the server is down

        # service dirsrv stop    
        # rm -rf /var/log/dirsrv/slapd-ID/db/abcRoot    
        # mv /var/log/dirsrv/slapd-ID/db/abcRoot.orig /var/log/dirsrv/slapd-ID/db/abcRoot    

    6-1. To upgrade the failed db instance, execute export and import.
        Assuming the failed backend instance name is abcRoot.

            # /usr/lib[64]/dirsrv/slapd-ID/db2ldif -n abcRoot    
            Exported ldif file: /var/lib/dirsrv/slapd-ID/ldif/ID-abcRoot.ldif    
            # /usr/lib[64]/dirsrv/slapd-ID/ldif2db -n abcRoot -i /var/lib/dirsrv/slapd-ID/ldif/ID-abcRoot.ldif    


Another Upgrade Scenario
------------------------

RHDS8.1/389 v1.2.5 has a bug, where the server accepts duplicated DNs. (see also [bug 612771](https://bugzilla.redhat.com/show_bug.cgi?id=612771))

Sample ldif containing duplicated DNs:

    dn: cn="uid=tuser1,ou=OU0,o=O0",ou=People, dc=example,dc=com    
    uid: tuser1    
    givenName: test    
    objectClass: top    
    objectClass: person    
    objectClass: organizationalPerson    
    objectClass: inetorgperson    
    sn: user1    
    cn: uid=tuser1,ou=OU0,o=O0    
    userPassword: tuser1    

    dn: cn=uid\=tuser1\,ou\=OU0\,o\=O0,ou=People, dc=example,dc=com    
    uid: tuser1    
    givenName: test    
    objectClass: top    
    objectClass: person    
    objectClass: organizationalPerson    
    objectClass: inetorgperson    
    sn: user1    
    cn: uid=tuser1,ou=OU0,o=O0    
    userPassword: tuser1    

    dn: cn=uid\=tuser2\,ou\=OU0\,o\=O0,ou=People, dc=example,dc=com    
    uid: tuser2    
    givenName: test    
    objectClass: top    
    objectClass: person    
    objectClass: organizationalPerson    
    objectClass: inetorgperson    
    sn: user2    
    cn: uid=tuser2,ou=OU0,o=O0    
    userPassword: tuser2    

    dn: cn="uid=tuser2,ou=OU0,o=O0",ou=People, dc=example,dc=com    
    uid: tuser2    
    givenName: test    
    objectClass: top    
    objectClass: person    
    objectClass: organizationalPerson    
    objectClass: inetorgperson    
    sn: user2    
    cn: uid=tuser2,ou=OU0,o=O0    
    userPassword: tuser2    

    dn: ou="cn=A,ou=B,o=C",ou=people, dc=example,dc=com    
    objectClass: top    
    objectClass: organizationalUnit    
    ou: cn=A,ou=B,o=C    

    dn: ou=cn\=A\,ou\=B\,o\=C,ou=people, dc=example,dc=com    
    objectClass: top    
    objectClass: organizationalUnit    
    ou: cn=A,ou=B,o=C    

    dn: cn=X,ou="cn=A,ou=B,o=C",ou=people, dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    cn: X    
    sn: X    

    dn: cn=X,ou=cn\=A\,ou\=B\,o\=C,ou=people, dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    cn: X    
    sn: X    

    dn: cn=Y,ou=cn\=A\,ou\=B\,o\=C,ou=people, dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    cn: Y    
    sn: Y    

    dn: cn=Y,ou="cn=A,ou=B,o=C",ou=people, dc=example,dc=com    
    objectClass: top    
    objectClass: person    
    cn: Y    
    sn: Y    

On RHDS 8.1 / 389 v1.2.5, entries in the above sample ldif file are added without any problem. And the duplicated entries could be retrieved as follows:

    $ ldapsearch -b "ou=people,dc=example,dc=com" "(|(cn=*)(ou=*))" entrydn entryid parentid    
    dn: ou=People, dc=example,dc=com    
    entrydn: ou=people,dc=example,dc=com    
    entryid: 4    
    parentid: 1    

    dn: cn="uid=tuser1,ou=OU0,o=O0",ou=People, dc=example,dc=com    
    entrydn: cn="uid=tuser1,ou=ou0,o=o0",ou=people,dc=example,dc=com    
    entryid: 10    
    parentid: 4    

    dn: cn=uid\=tuser1\,ou\=OU0\,o\=O0,ou=People, dc=example,dc=com    
    entrydn: cn=uid=tuser1\,ou=ou0\,o=o0,ou=people,dc=example,dc=com    
    entryid: 11    
    parentid: 4    

    dn: cn=uid\=tuser2\,ou\=OU0\,o\=O0,ou=People, dc=example,dc=com    
    entrydn: cn=uid=tuser2\,ou=ou0\,o=o0,ou=people,dc=example,dc=com    
    entryid: 12    
    parentid: 4    

    dn: cn="uid=tuser2,ou=OU0,o=O0",ou=People, dc=example,dc=com    
    entrydn: cn="uid=tuser2,ou=ou0,o=o0",ou=people,dc=example,dc=com    
    entryid: 13    
    parentid: 4    

    dn: ou="cn=A,ou=B,o=C",ou=people, dc=example,dc=com    
    entrydn: ou="cn=a,ou=b,o=c",ou=people,dc=example,dc=com    
    entryid: 14    
    parentid: 4    

    dn: ou=cn\=A\,ou\=B\,o\=C,ou=people, dc=example,dc=com    
    entrydn: ou=cn=a\,ou=b\,o=c,ou=people,dc=example,dc=com    
    entryid: 15    
    parentid: 4    

    dn: cn=X,ou="cn=A,ou=B,o=C",ou=people, dc=example,dc=com    
    entrydn: cn=x,ou="cn=a,ou=b,o=c",ou=people,dc=example,dc=com    
    entryid: 16    
    parentid: 14    

    dn: cn=X,ou=cn\=A\,ou\=B\,o\=C,ou=people, dc=example,dc=com    
    entrydn: cn=x,ou=cn=a\,ou=b\,o=c,ou=people,dc=example,dc=com    
    entryid: 17    
    parentid: 15    

    dn: cn=Y,ou=cn\=A\,ou\=B\,o\=C,ou=people, dc=example,dc=com    
    entrydn: cn=y,ou=cn=a\,ou=b\,o=c,ou=people,dc=example,dc=com    
    entryid: 18    
    parentid: 15    

    dn: cn=Y,ou="cn=A,ou=B,o=C",ou=people, dc=example,dc=com    
    entrydn: cn=y,ou="cn=a,ou=b,o=c",ou=people,dc=example,dc=com    
    entryid: 19    
    parentid: 14    

yum upgrade / rpm -U calls setup-ds.pl utility with '-u' option, from which upgradednformat utility is invoked.

    [spec file snippet]    
    -- do the upgrade    
       print("upgrading instances . . .")    
       os.execute('%{_sbindir}/setup-ds.pl -l /dev/null -u ...    

Once the utility detects the duplicated DNs, it logs an error and renames the second DN as follows.

    [..] - upgradedn userRoot: Duplicated entrydn detected: "cn=uid\3dtuser1\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com": Entry ID: (10, 11)    
    [..] - upgradedn userRoot: WARNING: Duplicated entry cn=uid\=tuser1\,ou\=OU0\,o\=O0,ou=People,dc=example,dc=com is renamed to cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0+nsuniqueid=ae8c95af-8fac11df-80000000-00000000,ou=People,dc=example,dc=com; Entry ID: 11    
    [..] - upgradedn userRoot: Duplicated entrydn detected: "cn=uid\3dtuser2\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com": Entry ID: (12, 13)    
    [..] - upgradedn userRoot: WARNING: Duplicated entry cn="uid=tuser2,ou=OU0,o=O0",ou=People,dc=example,dc=com is renamed to cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0+nsuniqueid=ae8c95b0-8fac11df-80000000-00000000,ou=People,dc=example,dc=com; Entry ID: 13    

Customers are supposed to do the followings when in-place upgrade is done.
. Check the error log /var/log/dirsrv/slapd-ID/error to see if "Duplicated entry" strings are in the file or not.
. If they are found, clean up the duplicated entries.
Here's the steps how to clean up the duplicated entries using the above example. After upgrading to RHDS8.2/389 v1.2.6, the contents of the db looks like this:

    $ ldapsearch -b "ou=people,dc=example,dc=com" "(|(cn=*)(ou=*))" entrydn entryid parentid    
    dn: ou=People,dc=example,dc=com    
    entrydn: ou=people,dc=example,dc=com    
    entryid: 4    
    parentid: 1    

    dn: cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0,ou=People,dc=example,dc=com    
    entrydn: cn=uid\3dtuser1\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com    
    entryid: 10    
    parentid: 4    

    dn: cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32af-8fb011df-80000000-    
     00000000,ou=People,dc=example,dc=com    
    entrydn: cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32af-8fb011df-8000    
     0000-00000000,ou=People,dc=example,dc=com    
    entryid: 11    
    parentid: 4    

    dn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0,ou=People,dc=example,dc=com    
    entrydn: cn=uid\3dtuser2\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com    
    entryid: 12    
    parentid: 4    
    cn: uid=tuser2,ou=OU0,o=O0    

    dn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32b0-8fb011df-80000000-    
     00000000,ou=People,dc=example,dc=com    
    entrydn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32b0-8fb011df-8000    
     0000-00000000,ou=People,dc=example,dc=com    
    entryid: 13    
    parentid: 4    

    dn: ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    entrydn: ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com    
    entryid: 14    
    parentid: 4    

    dn: nsuniqueid=7c7d32b1-8fb011df-80000000-00000000+ou=cn\3DA\2Cou\3DB\2Co\3DC,    
     ou=people,dc=example,dc=com    
    entrydn: nsuniqueid=7c7d32b1-8fb011df-80000000-00000000+ou=cn\3DA\2Cou\3DB\2Co    
     \3DC,ou=people,dc=example,dc=com    
    entryid: 15    
    parentid: 4    

    dn: cn=X,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    entrydn: cn=x,ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com    
    entryid: 16    
    parentid: 14    

    dn: cn=X+nsuniqueid=7c7d32b2-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3DB\2Co    
     \3DC,ou=people,dc=example,dc=com    
    entrydn: cn=X+nsuniqueid=7c7d32b2-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3D    
     B\2Co\3DC,ou=people,dc=example,dc=com    
    entryid: 17    
    parentid: 14    

    dn: cn=Y,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    entrydn: cn=y,ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com    
    entryid: 18    
    parentid: 14    

    dn: cn=Y+nsuniqueid=7c7d32b3-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3DB\2Co    
     \3DC,ou=people,dc=example,dc=com    
    entrydn: cn=Y+nsuniqueid=7c7d32b3-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3D    
     B\2Co\3DC,ou=people,dc=example,dc=com    
    entryid: 19    
    parentid: 14    

Please note that the leaf RDN of the duplicated DNs are renamed to nsuniqueid=<uuid>,<DN>

To do the clean up task, 1) determine which entry is kept and which entry is removed. Let's assume this is the decision (to represent the entry, entryid is used.)

    Keep    
    1 - 4 - 10    
    1 - 4 - 13    
    1 - 4 - 14    
    1 - 4 - 14 - 16    
    1 - 4 - 14 - 19    
    Remove    
    1 - 4 - 11    
    1 - 4 - 12    
    1 - 4 - 15    
    1 - 4 - 14 - 17    
    1 - 4 - 14 - 18    

2) Start from the leaves.
2.1) Remove entry id 11 and 12; 11 can be just deleted; for 12, delete 12 then need to rename 13 to the DN of 12.

    dn: cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32af-8fb011df-80000000-
     00000000,ou=People,dc=example,dc=com
    entrydn: cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32af-8fb011df-8000
     0000-00000000,ou=People,dc=example,dc=com
    entryid: 11
    parentid: 4

    dn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0,ou=People,dc=example,dc=com
    entrydn: cn=uid\3dtuser2\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com
    entryid: 12
    parentid: 4

    dn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32b0-8fb011df-80000000-
     00000000,ou=People,dc=example,dc=com
    entrydn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0+nsuniqueid=7c7d32b0-8fb011df-8000
     0000-00000000,ou=People,dc=example,dc=com
    entryid: 13
    parentid: 4

2.1.1) Remove 11 and 12

    $ ldapdelete -D 'cn=directory manager' -w password
    cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0+nsuniqueid=ae8c95af-8fac11df-80000000-00000000,ou=People,dc=example,dc=com
    cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0,ou=People,dc=example,dc=com

2.1.2) Rename 13

    $ ldapmodify -D 'cn=directory manager' -w password
    dn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0+nsuniqueid=ae8c95b0-8fac11df-80000000-00000000,ou=People,dc=example,dc=com
    changetype: modrdn
    newrdn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0
    deleteoldrdn: 0

Note: deleteoldrdn value should be 0 since nsuniqueid is an operational attribute which is not allowed to manipulate.

2.2) Remove entry id 17 and 18; rename 19 to the DN of 18

    dn: cn=X+nsuniqueid=7c7d32b2-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3DB\2Co
     \3DC,ou=people,dc=example,dc=com
    entrydn: cn=X+nsuniqueid=7c7d32b2-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3D
     B\2Co\3DC,ou=people,dc=example,dc=com
    entryid: 17
    parentid: 14

    dn: cn=Y,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com
    entrydn: cn=y,ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com
    entryid: 18
    parentid: 14

    dn: cn=Y+nsuniqueid=7c7d32b3-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3DB\2Co
     \3DC,ou=people,dc=example,dc=com
    entrydn: cn=Y+nsuniqueid=7c7d32b3-8fb011df-80000000-00000000,ou=cn\3DA\2Cou\3D
     B\2Co\3DC,ou=people,dc=example,dc=com
    entryid: 19
    parentid: 14

2.2.1) Remove 17 and 18

    $ ldapdelete -D 'cn=directory manager' -w password    
    cn=X+nsuniqueid=ae8c95b2-8fac11df-80000000-00000000,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    cn=Y,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    

2.2.2) Rename 19

    $ ldapmodify -D 'cn=directory manager' -w password    
    dn: cn=Y+nsuniqueid=ae8c95b3-8fac11df-80000000-00000000,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    changetype: modrdn    
    newrdn: cn=Y    
    deleteoldrdn: 0    

2.3) Remove 15

    dn: nsuniqueid=7c7d32b1-8fb011df-80000000-00000000+ou=cn\3DA\2Cou\3DB\2Co\3DC,    
     ou=people,dc=example,dc=com    
    entrydn: nsuniqueid=7c7d32b1-8fb011df-80000000-00000000+ou=cn\3DA\2Cou\3DB\2Co    
     \3DC,ou=people,dc=example,dc=com    
    entryid: 15    
    parentid: 4    

    $ ldapdelete -D 'cn=directory manager' -w password    
    nsuniqueid=ae8c95b1-8fac11df-80000000-00000000+ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    

3) Cleaned up result; there is no duplicated entries.

    dn: ou=People,dc=example,dc=com    
    entrydn: ou=people,dc=example,dc=com    
    entryid: 4    
    parentid: 1    

    dn: cn=uid\3Dtuser1\2Cou\3DOU0\2Co\3DO0,ou=People,dc=example,dc=com    
    entrydn: cn=uid\3dtuser1\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com    
    entryid: 10    
    parentid: 4    
    cn: uid=tuser1,ou=OU0,o=O0    
    cn: "uid=tuser1,ou=OU0,o=O0"    

    dn: cn=uid\3Dtuser2\2Cou\3DOU0\2Co\3DO0,ou=People,dc=example,dc=com    
    entrydn: cn=uid\3dtuser2\2cou\3dou0\2co\3do0,ou=people,dc=example,dc=com    
    entryid: 13    
    parentid: 4    
    cn: uid=tuser2,ou=OU0,o=O0    
    cn: "uid=tuser2,ou=OU0,o=O0"    

    dn: ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    entrydn: ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com    
    entryid: 14    
    parentid: 4    

    dn: cn=X,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    entrydn: cn=x,ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com    
    entryid: 16    
    parentid: 14    
    cn: X    

    dn: cn=Y,ou=cn\3DA\2Cou\3DB\2Co\3DC,ou=people,dc=example,dc=com    
    entrydn: cn=y,ou=cn\3da\2cou\3db\2co\3dc,ou=people,dc=example,dc=com    
    entryid: 19    
    parentid: 14    
    cn: Y    

### Examples

    Add    
      dn: cn=ATELIER DE M\C3\89CANIQUE,dc=example,dc=com    
    Search result (Base64 decoded)    
      dn: cn=ATELIER DE MÃ‰CANIQUE,dc=example,dc=com    
      cn: ATELIER DE MÃ‰CANIQUE    

    Add    
      dn: cn="a=b,c=d",dc=example,dc=com    
    Search/Export result    
      dn: cn=a\3Db\2Cc\3Dd,dc=example,dc=com    
      cn: a=b,c=d    

    Add    
      dn: cn=x\=y\,z\=w,dc=example,dc=com    
    Search/Export result    
      dn: cn=x\3Dy\2Cz\3Dw,dc=example,dc=com    
      cn: x=y,z=w    

    Add    
      dn: cn=l\3Dm\2Cn\3Do, dc=example,dc=com    
    Search/Export result    
      dn: cn=l\3Dm\2Cn\3Do,dc=example,dc=com    
      cn: l=m,n=o    

### Related Bugs

[Bug 199923](https://bugzilla.redhat.com/show_bug.cgi?id=199923) - subtree search fails to find items under a db containing special characters

[Bug 567968](https://bugzilla.redhat.com/show_bug.cgi?id=567968) - subtree/user level password policy created using 389-ds-console doesn't work.

[Bug 570107](https://bugzilla.redhat.com/show_bug.cgi?id=570107) - The import of LDIFs with base-64 encoded DNs fails, modrdn with non-ASCII new rdn incorrect

[Bug 570962](https://bugzilla.redhat.com/show_bug.cgi?id=570962) - ns-inactivate.pl does not work

[Bug 572785](https://bugzilla.redhat.com/show_bug.cgi?id=572785) - DN syntax: old style of DN <type>="<DN>",<the_rest> is not correctly normalized

[Bug 573060](https://bugzilla.redhat.com/show_bug.cgi?id=573060) - DN normalizer: ESC HEX HEX is not normalized

[Bug 574167](https://bugzilla.redhat.com/show_bug.cgi?id=574167) - An escaped space at the end of the RDN value is not handled correctly

[Bug 612771](https://bugzilla.redhat.com/show_bug.cgi?id=612771) - RHDS 8.1/389 v1.2.5 accepts 2 identical entries with different DN formats


