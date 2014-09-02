---
title: Console Login and Anonymous Access Disabled
---

# Console Login and Anonymous Access Disabled
----------------------------------------------

{% include toc.md %}

### Overview of 389 Console Authentication

When logging into the 389-console, and only the user ID/RDN is given for *User ID*, the console will search the configuration suffix and the *Users & Groups* suffix for the actual user to retrieve its DN(distinguished name).  For example, if you log in as **scarter**, the console will search **o=netscaperoot** and the *Users & Groups* suffix for **uid=scarter**.  If a single matching entry is found, its DN is returned to the console:  **uid=scarter,ou=people,dc=example,dc=com**.

Here are some access log snippets from a configuration Directory Server showing this process

#### Log snippet checking o=netscaperoot

    [02/Sep/2014:11:05:56 -0400] conn=34 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:11:05:56 -0400] conn=34 op=0 BIND dn="" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=34 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn=""
    [02/Sep/2014:11:05:56 -0400] conn=34 op=1 SRCH base="o=NetscapeRoot" scope=2 filter="(uid=scarter)" attrs="c"
    [02/Sep/2014:11:05:56 -0400] conn=34 op=1 RESULT err=0 tag=101 nentries=0 etime=0
    [02/Sep/2014:11:05:56 -0400] conn=34 op=2 UNBIND
    [02/Sep/2014:11:05:56 -0400] conn=34 op=2 fd=64 closed - U1
    
#### Log snippet checking the "Users & Groups" suffix

    [02/Sep/2014:11:05:56 -0400] conn=35 op=1 fd=64 closed - U1
    [02/Sep/2014:11:05:56 -0400] conn=36 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 BIND dn="" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn=""
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(uid=scarter)" attrs="c"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 RESULT err=0 tag=101 nentries=1 etime=0
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 BIND dn="uid=scarter,ou=people,dc=example,dc=com" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=scarter,ou=people,dc=example,dc=com"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 UNBIND
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 fd=64 closed - U1
 
Here we found an entry, then performed the authentication/BIND as that user.

Note - If the full DN for *scarter* (uid=scarter,ou=people,dc=example,dc=com) is entered into the Console login dialog, then it directly does the BIND operation without doing any anonymous bind/user ID lookup searches.

<br>

### Disabling Anonymous Access Can Break Logins

If you disable anonymous access to the configuration Directory Server by setting **[nsslapd-allow-anonymous-access](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Identity_Management_Guide/disabling-anon-binds.html)**, then logging in with just a user ID (e.g. "scarter") will now fail.  You will see error 48's in the configuration Directory Server access log

    [02/Sep/2014:10:59:47 -0400] conn=15 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:10:59:47 -0400] conn=15 op=0 UNPROCESSED OPERATION - Anonymous access not allowed
    [02/Sep/2014:10:59:47 -0400] conn=15 op=0 RESULT err=48 tag=101 nentries=0 etime=0
    [02/Sep/2014:10:59:47 -0400] conn=15 op=1 UNBIND
    [02/Sep/2014:10:59:47 -0400] conn=15 op=1 fd=64 closed - U1


Note - If the full DN for *scarter* is used, then it directly does the BIND operation, and the anonymous access setting is irrelevant.

<br>

### Using the New Administration Server Authentication Settings

Note - this feature is new to 389-admin version 1.1.36

To resolve this problem, two new configuration attributes were added to the Admin Server's **adm.conf** file (/etc/dirsrv/admin-serv/adm.conf)

    authdn: <DN>
    authpw: <password>

When just a user ID is used in the console authentication dialog, the entry specified in **authdn**, will perform the initial search to find the full DN of the user ID.  This works around the problem of having anonymous access disabled, however, this now requires some additional configuration steps.

#### Additional Configuration Steps

-    A special user should be created under **o=netscaperoot** to perform these console user ID lookup searches.  This way you can control that account's exact access to the database(s).  For example create a user:

         dn: cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot
         objectclass: top
         objectclass: person
         cn: 389-console
         sn: Console
         userpassword: tHePaSSwOrD

-    If necessary, add ACL's to **o=netscaperoot**, and to any suffix where the console will try to find the user IDs.

         dn: o=netscaperoot
         aci: (target="ldap:///o=netscaperoot")(targetattr="uid")(version 3.0; 
          acl "allow console to find users"; allow(read,search,compare) userdn =
          "ldap:///cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot";)

         dn: dc=example,dc=com
         aci: (target="ldap:///dc=example,dc=com")(targetattr="uid")(version 3.0; 
          acl "allow console to find users"; allow(read,search,compare) userdn =
          "ldap:///cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot";)

-    Edit the **adm.conf** file (/etc/dirsrv/admin-serv/adm.conf), and add the following

         authdn: cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot
         authpw: tHePaSSwOrD

-    Restart the Administration Server.

#### The Results...

Now, you can login to the console with just a user ID, and still have anonymous access disabled.  The logs now show the new behavior:

    [02/Sep/2014:11:05:56 -0400] conn=35 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:11:05:56 -0400] conn=35 op=0 BIND dn="cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=35 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot"
    [02/Sep/2014:11:05:56 -0400] conn=35 op=1 SRCH base="o=NetscapeRoot" scope=2 filter="(uid=scarter)" attrs="c"
    [02/Sep/2014:11:05:56 -0400] conn=35 op=1 RESULT err=0 tag=101 nentries=0 etime=0
    [02/Sep/2014:11:05:56 -0400] conn=35 op=2 UNBIND
    [02/Sep/2014:11:05:56 -0400] conn=35 op=2 fd=64 closed - U1

    [02/Sep/2014:11:05:56 -0400] conn=36 fd=64 slot=64 connection from 127.0.0.1 to 127.0.0.1
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 BIND dn="cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=0 RESULT err=0 tag=97 nentries=0 etime=0 dn="cn=389-console,ou=Administrators,ou=TopologyManagement,o=NetscapeRoot"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(uid=scarter)" attrs="c"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=1 RESULT err=0 tag=101 nentries=1 etime=0
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 BIND dn="uid=scarter,ou=people,dc=example,dc=com" method=128 version=3
    [02/Sep/2014:11:05:56 -0400] conn=36 op=2 RESULT err=0 tag=97 nentries=0 etime=0 dn="uid=scarter,ou=people,dc=example,dc=com"
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 UNBIND
    [02/Sep/2014:11:05:56 -0400] conn=36 op=3 fd=64 closed - U1

We found our user, and we successfully authenticated using the **scarter** user ID



