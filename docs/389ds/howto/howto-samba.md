---
title: "Howto:Samba"
---

# Samba & 389 Directory Server Integration
-------------------------------------------

{% include toc.md %}

### Purpose?

This document is a rough draft intended on integrating Samba 3 with 389 Directory Server.

NOTE: These instructions only apply to basic user and group management. If you use or plan to use Samba for computer management, you will be better off using the migration scripts from IDEALX - <http://www.idealx.org/prj/samba/index.en.html>

### FDS Toolkit Project Announcement

(August 4,2007) A new project has been started to mitigate some of the shortcomings of IDEALX smbldap-tools with regards to FDS. This project allows you to manage posix, samba, aix, and computer accounts with command line tools very similar to IDEALX smbldap-tools, only better, with support for logging, password policies, etc. Development is currently in alpha however the command line portion is feature complete so testers and developers for the GUI portion are welcome. See the project page for more information. <http://fdstools.sourceforge.net>

### What will you gain from this document?

By the end of this document you will have a fully working Samba PDC using FDS as its backend for storing Domain Administrators, Users, Guests, Computers.

**At this time this document does not cover authentication, encryption implementations, or indexing (yet).**

### Requirements

From the requirements below this article will assume you have installed and are familiar with FDS (starting/stopping server/navigating/adding/deleting entries), Samba, and basic knowledge of Linux)

-   Fedora - instructions were written with Fedora Core 4 in mind but should apply to all versions
-   Packages needed :
    -   openldap-servers (contains migration utilities used in this document)
    -   fedora-ds (the directory server via yum install fedora-ds)
    -   samba, samba-client, samba-common (samba server, also provides schema needed for storing samba information)
-   schema to ldif migration script (provided in this document used to convert provided schemas to an ldif format FDS understands)

### FDS Setup

First off we need to provide FDS with a samba schema that it understands. Now lets break down how FDS implements extending schemas :

-   All schema files are in ldif format and loaded during server start
-   All schema€™s are located in /opt/fedora-ds/slapd-<server>/config/schema
-   Filenames are sequential and loaded in order and 99user.ldif is always the last schema to be loaded.

For this document we are going to name our schema file 61samba.ldif. As stated above we need to provide FDS with a schema it understands which involves converting the provided /usr/share/doc/samba/LDAP/samba.schema to ldif format. Luckily, there is a utility provided 3rd party that will assist in doing this which can be found at <http://directory.fedoraproject.org/download/ol-schema-migrate.pl>

Use of this script is straight forward :

    # perl ol-schema-migrate.pl -b /usr/share/doc/samba-*/LDAP/samba.schema > /etc/dirsrv/slapd-<server>/schema/61samba.ldif     

Once the ldif is in place restart the slapd service :

    # service dirsrv restart    

If you are still using Fedora DS 1.0.4 or earlier:

    # perl ol-schema-migrate.pl -b /usr/share/doc/samba-*/LDAP/samba.schema > /opt/fedora-ds/slapd-<server>/config/schema/61samba.ldif     
    # /opt/fedora-ds/slapd-<server>/restart-slapd    

### PAM Configuration

Check if nss\_ldap is installed with:

    rpm -qa|grep nss_ldap    

otherwise:

    yum install nss_ldap    

It is necessary to configure the server as somewhat of a client when doing some of the Samba operations below. Please refer to the following documentation in configuring your server to do ldap lookups through PAM. [How to PAM](howto-pam.html)

After configuring PAM, as explained here [1](http://wiki.zimbra.com/index.php?title=UNIX_and_Windows_Accounts_in_Zimbra_LDAP_and_Zimbra_Admin_UI) you should have into /etc/ldap.conf:

    uri ldap://hostname.example.com
    host hostname.example.com
    base dc=example,dc=com
    binddn cn=Directory Manager
    bindpw test123
    port 389

without configuring ldap.conf, samba will not search posix accounts into ldap. Also, keep care to your dns settings, otherwise use

    host 127.0.0.1

### Samba Setup

Modify /etc/samba/smb.conf to have the following values (remember that YOURWORKGROUP string length \< 14)

    [global]
    workgroup = YOURWORKGROUP
    security = user
    passdb backend = ldapsam:ldap://example.com
    ldap admin dn = cn=Directory Manager
    ldap suffix = dc=example,dc=com
    ldap user suffix = ou=People
    ldap machine suffix = ou=Computers
    ldap group suffix = ou=Groups
    log file = /var/log/%m.log
    socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
    os level = 33
    domain logons = yes
    domain master = yes
    local master = yes
    preferred master = yes
    wins support = yes
    logon home = \\%L\%u\profiles
    logon path = \\%L\profiles\%u
    logon drive = H:
    template shell = /bin/false
    winbind use default domain = no
    [netlogon]
    path = /var/lib/samba/netlogon
    read only = yes
    browsable = no
    [profiles]
    path = /var/lib/samba/profile
    read only = no
    create mask = 0600
    directory mask = 0700
    [homes]
    browsable = no
    writable = yes

Test your Samba configuration for any problems :

    # testparm
    Load smb config files from /etc/samba/smb.conf
    Processing section "[netlogon]"
    Processing section "[profiles]"
    Processing section "[homes]"
    Loaded services file OK.
    Server role: ROLE_DOMAIN_PDC

Create appropriate directories/permissions for the Samba shares defined in your configuration :

    # mkdir -p /var/lib/samba
    # mkdir /var/lib/samba/{netlogon,profiles}
    # chown root:root -R /var/lib/samba
    # chmod 0755 /var/lib/samba/netlogon
    # chmod 1755 /var/lib/samba/profiles

Create a password for the ldap admin dn (the [Directory Manager's Password](Setup#Directory_Manager_Password "wikilink")) in Sambaâ€™s secret file:

    # smbpasswd -w <ldap-admin-password>
    Setting stored password for "cn=Directory Manager" in secrets.tdb

### Populating FDS with PDC Entry

At this point you should have a Samba PDC and a properly configured FDS ready to take the appropriate Samba entries. Now we are going to provide an entry into FDS for your PDC.

First get the Samba SID for your PDC :

    # net getlocalsid    
    SID for domain YOURWORKGROUP is: S-1-5-21-1803520230-1543781662-649387223    
    (your SID will vary)    

Note that until now samba has never been started and it not should be running to get local SID.

Next create your Samba Domain ldif(/tmp/sambaDomainName.ldif) for entry, substituting your domain name and SID :

    dn: sambaDomainName=<YOURWORKGROUP>,dc=example,dc=com
    objectclass: sambaDomain
    objectclass: sambaUnixIdPool
    objectclass: top
    sambaDomainName: <YOURWORKGROUP>
    sambaSID: S-1-5-21-1803520230-1543781662-649387223
    uidNumber: 550
    gidNumber: 550

Populate your FDS with the above entry :

    # /usr/lib/dirsrv/slapd-<server>/ldif2ldap "cn=Directory manager" password /tmp/sambaDomainName.ldif    

Use /usr/lib64 instead of /usr/lib on x86\_64 systems.

Or if you are still using Fedora DS 1.0.4 or earlier:

    # /opt/fedora-ds/slapd-<server>/ldif2ldap "cn=Directory manager" password /tmp/sambaDomainName.ldif    

Migrating Samba groups and populating FDS with Samba Users:
-----------------------------------------------------------

This is where the openldap migration scripts are going to come in handy. Lets modify the file /usr/share/openldap/migration/migrate\_common.ph to apply our default domain and base.

Search for the following OrganizationalUnit :

    $NAMINGCONTEXT{'group'}             = "ou=Group";    

Default install of FDS will require this to be 'Groups', please change as follows :

    $NAMINGCONTEXT{'group'}             = "ou=Groups";    

The rest can be modified as seen below :

    # Default DNS domain    
    $DEFAULT_MAIL_DOMAIN = "example.com";    
    # Default base    
    $DEFAULT_BASE = "dc=example,dc=com";     
    # turn this on to support more general object classes    
    # such as person. (not needed for our exercise but generally good idea    
    # to set to 1 â€“ adam)    
    $EXTENDED_SCHEMA = 1;    

Once complete we are now going to create our Samba Domain Groups. Open up a new file /tmp/sambaGroups and add the following :

    Domain Admins:x:2512:    
    Domain Users:x:2513:    
    Domain Guests:x:2514:    
    Domain Computers:x:2515:    

-   Note: These are your UNIX groups! They must exist on the Directory Server group list first! (if you do not have PAM setup)

Next convert /tmp/sambaGroups into an ldif to be imported into FDS :

    # /usr/share/openldap/migration/migrate_group.pl /tmp/sambaGroups > /tmp/sambaGroups.ldif    
    # cat /tmp/sambaGroups.ldif    
    dn: cn=Domain Admins,ou=Groups,dc=example,dc=com    
    objectClass: posixGroup    
    objectClass: top    
    cn: Domain Admins    
    userPassword: {crypt}x    
    gidNumber: 2512    

    dn: cn=Domain Users,ou=Groups,dc=example,dc=com    
    objectClass: posixGroup    
    objectClass: top    
    cn: Domain Users    
    userPassword: {crypt}x    
    gidNumber: 2513    

    dn: cn=Domain Guests,ou=Groups,dc=example,dc=com    
    objectClass: posixGroup    
    objectClass: top    
    cn: Domain Guests    
    userPassword: {crypt}x    
    gidNumber: 2514    

    dn: cn=Domain Computers,ou=Groups,dc=example,dc=com    
    objectClass: posixGroup    
    objectClass: top    
    cn: Domain Computers    
    userPassword: {crypt}x    
    gidNumber: 2515    

Now import /tmp/sambaGroups.ldif into FDS :

    # /usr/lib/dirsrv/slapd-<server>/ldif2ldap "cn=Directory manager" password /tmp/sambaGroups.ldif    

Use /usr/lib64 instead of /usr/lib on x86\_64 systems.

If you are still using Fedora DS 1.0.4, do this instead:

    # /opt/fedora-ds/slapd-<server>/ldif2ldap "cn=Directory manager" password /tmp/sambaGroups.ldif    

Map the Samba groups to the Linux groups :

    # net groupmap add rid=2512 ntgroup='Domain Admins'  unixgroup='Domain Admins'    
    # net groupmap add rid=2513 ntgroup='Domain Users' unixgroup='Domain Users'    
    # net groupmap add rid=2514 ntgroup='Domain Guests' unixgroup='Domain Guests'    
    # net groupmap add rid=2515 ntgroup='Domain Computers' unixgroup='Domain Computers'    

Verify :

    # net groupmap list

Lets create a Samba Administrator account with an RID of 500. Create a file /tmp/sambaAdmin with the following :

    Administrator:x:0:0:Samba Admin:/root:/bin/bash

Migrate /tmp/sambaAdmin to the formatted ldif and import into FDS :

    # /usr/share/openldap/migration/migrate_passwd.pl /tmp/sambaAdmin > /tmp/sambaAdmin.ldif    
    # /usr/lib/dirsrv/slapd-<server>/ldif2ldap "cn=Directory manager" password /tmp/sambaAdmin.ldif    

Use /usr/lib64 instead of /usr/lib on x86\_64 systems.

If you are still using Fedora DS 1.0.4, do this instead:

    # /opt/fedora-ds/slapd-<server>/ldif2ldap "cn=Directory manager" password /tmp/sambaAdmin.ldif    

Create a Samba Administrator account and modify the account to use the correct Samba SID :

    # smbpasswd -a Administrator -w <ldap-admin-password>
    # pdbedit -U $( net getlocalsid | sed 's/SID for domain YOURWORKGROUP is: //' )-500 -u Administrator -r

Finally start the Samba service and map an existing user entry to a Samba user :

    # service smb start; chkconfig smb on    
    # smbpasswd -a testuser    

Compare accounts :

    # ldapsearch -x -Z '(uid=testuser)'    
    dn: uid=testuser,ou=People,dc=example,dc=com    
    uid: testuser    
    cn: Test User SMB    
    objectClass: account    
    objectClass: posixAccount    
    objectClass: top    
    objectClass: shadowAccount    
    objectClass: sambaSamAccount    
    shadowLastChange: 12971    
    shadowMax: 99999    
    shadowWarning: 7    
    loginShell: /bin/bash    
    uidNumber: 500    
    gidNumber: 500    
    homeDirectory: /home/testuser    
    gecos: Test User SMB    
    sambaSID: S-1-5-21-1803520230-1543781662-649387223-2000    
    sambaPrimaryGroupSID: S-1-5-21-1803520230-1543781662-649387223-2001    
    displayName: Test User SMB    
    sambaPwdCanChange: 1120754404    
    sambaPwdMustChange: 2147483647    
    sambaLMPassword: CFA95C51F11AB11DC2265B23734E0DAC    
    sambaNTPassword: B2D88A4A9B0DAEE170E75F67D54918F6    
    sambaPasswordHistory: 00000000000000000000000000000000000000000000000000000000    
    00000000    
    sambaPwdLastSet: 1120754404    
    sambaAcctFlags: [U          ]    
    # pdbedit -v -u testuser    
    Unix username:        testuser    
    NT username:          testuser    
    Account Flags:        [U          ]    
    User SID:             S-1-5-21-1803520230-1543781662-649387223-2000    
    Primary Group SID:    S-1-5-21-1803520230-1543781662-649387223-2001    
    Full Name:            Test User SMB    
    Home Directory:       \\directory\%u\profiles    
    HomeDir Drive:        H:    
    Logon Script:    
    Profile Path:         \\directory\profiles\%u    
    Domain:               YOURWORKGROUP    
    Account desc:    
    Workstations:    
    Munged dial:    
    Logon time:           0    
    Logoff time:          Mon, 18 Jan 2038 22:14:07 GMT    
    Kickoff time:         Mon, 18 Jan 2038 22:14:07 GMT    
    Password last set:    Thu, 07 Jul 2005 12:40:04 GMT    
    Password can change:  Thu, 07 Jul 2005 12:40:04 GMT    
    Password must change: Mon, 18 Jan 2038 22:14:07 GMT    
    Last bad password   : 0    
    Bad password count  : 0    
    Logon hours         : FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF\    

In the above output, two Samba password hashes are shown. However, as password-cracking programs can be run on these hashes, you would not to give any access to them, except by the samba service. Therefore, you can limit access to these or any other attributes using Access Control Instructions (ACIs). One way to do this is to open the FDS Console, navigate to the directory, right click on the parent which is providing the access, choose "Set Access Permissions", select the ACI to be edited, press the Edit button, click the Targets tab, scroll to find the attribute(s), check/uncheck as desired, and press OK when done. In the above example, the access is anonymous. So the likely ACI for this situation is "Enable anonymous access". Ideally, you would not allow any anonymous access, and instead would only allow access to authenticated users for which you have precisely defined the ACIs for the attributes that user needs to read and write.

Links
-----

Fedora Directory Server Toolkit - <http://fdstools.sourceforge.net>
Samba - <http://www.samba.org>
Samba3 LDAP HowTo - <http://samba.idealx.org/dist/samba3-ldap-howto.pdf>
Another Samba/LDAP How To - <http://web.vcs.u52.k12.me.us/linux/smbldap/>


