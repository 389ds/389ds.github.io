---
title: "Howto: Netgroups"
---

# System Access Control using LDAP backed NIS Netgroups
-----------------------------------------------------

by Dan Cox

There are many ways to control both login and service level authentication with Fedora Directory Server. Here, I will discuss a specific implementation using LDAP backed NIS Netgroups and detail what exactly makes them so powerful.

{% include toc.md %}

### Prerequisites

-   Some knowledge of NIS and the netgroup triple syntax is in order. For those that do not have a netgroup man page available, you may see the [Sun NIS FAQ](http://www.sunhelp.org/faq/nis.html), Section 3.15 specifically.
-   An understanding of PAM and the PAM module stack <Howto:PAM>
-   A working implementation of nss\_ldap, which acts as the NSS-\>NIS-\>LDAP gateway is required.

### What are NIS netgroups good for?

First, it's important to understand what a NIS netgroup gains the average system administrator. NIS Netgroups provide the ability to perform such tasks as:

-   Control both user and group login access to individual or groups of machines.
-   Manage NFS access control lists.
-   Control user and group sudo command access.
-   Execute remote commands or interactive logins on groups of machines with dsh (distributed shell).
-   Manage the configuration of your entire network on a role basis with CFEngine.

These are just a few of the excellent uses for NIS netgroups. If we take this functionality and implement an LDAP based backend, we can not only take advantage of these tools but gain the security, manageability and fault tolerance of Fedora Directory Server.

### How does it work?

NIS netgroup entries are stored as an objectClass of type nisNetgroup in the directory server. The relative distinguished name attribute is typically cn (common name). There are two important attributes in creating the netgroup. Note that they are not mutually exclusive. Also, neither are required (sometimes having an empty netgroup is as valuable as one populated with values).

-   **nisNetgroupTriple**: This can be used to describe a user (,bobby,example.com) or a machine name (shellserver1,,example.com). This attribute can have multiple values.
-   **memberNisNetgroup**: This is a very powerful attribute. It is used to merge the attribute values of another netgroup into the current one by simply listing the name (cn) of the merging netgroup. This attribute can have multiple values as well.

You also want to attach a description attribute and value to your object. You were planning on describing that netgroup, weren't you?

Let's look at an example LDIF:

    dn: cn=QAUsers,ou=Netgroup,dc=example,dc=com    
    objectClass: nisNetgroup    
    objectClass: top    
    cn: QAUsers    
    nisNetgroupTriple: (,bobby,example.com)    
    nisNetgroupTriple: (,joey,example.com)    
    description: All QA users in my organization    

We can see here that the users 'bobby' and 'joey' belong to the QAUsers netgroup. Now, any tool that will query for the QAUsers netgroup will get back these values and can act upon them.

With nss\_ldap appropriately configured and /etc/nsswitch.conf conveniently pointing netgroup queries to ldap, we can test this entry on the command line like so:

    # getent netgroup QAUsers    
    QAUsers (,bobby,example.com) (,joey,example.com)    

The getent command is part of the glibc-common package on Fedora. It can be used to query any of the available NSS databases.

Now, let's look at an LDIF defining which machines are QA systems on our network:

    dn: cn=QASystems,ou=Netgroup,dc=example,dc=com    
    objectClass: nisNetgroup    
    objectClass: top    
    cn: QASystems    
    nisNetgroupTriple: (qa01,,example.com)    
    nisNetgroupTriple: (qa02,,example.com)    
    description: All QA systems on our network    

OK, so we have our users and systems in place, now how do we give QAUsers login access to QASystems? Enter PAM's access.conf.

PAM has an often overlooked access control feature, the configuration of which is typically located in /etc/security/access.conf. It has the ability to use UNIX users and groups as well as NIS netgroups to control remote and local console access to the system. The documentation of the syntax should be contained within the configuration file itself.

PAM's access control module is invoked with pam\_access.so. Fedora includes a reference to pam\_access.so in /etc/pam.d/crond, which in turn references /etc/security/access.conf. To prevent issues with crond, it is best to create separate access control file for netgroups with this line in /etc/pam.d/system-auth:

    account required pam_access.so accessfile=/etc/security/access.netgroup.conf    

We can give our users remote login access from our 10.x.x.x network with this line:

    + : @QAUsers@@QASystems : 10.

Finally to enable the netgroup query, NISDOMAIN must be defined (in /etc/sysconfig/network) even though it is not used. This is required because the innetgr() call is used and it requires a nisdomainname as a parameter. Once the functions resolves to LDAP via nsswitch.conf, the nisdomainname in no longer required.

-   NOTE\*: PAM operates on a first match basis for granting access. This means you want to end your ACL list by denying all unmatched entries, but before you do that make sure root and/or your admin users have been matched! For example, adding root for console only, users in the Admins netgroup remote access and denying all other unmatched entries:

        + : root : LOCAL    
        + : @Admins : 10.    
        - : ALL : ALL    

An advantage to using machine groups in the access.conf is the ability to push out this access.conf configuration file to all systems in your network, regardless if they are related to QA. This gives an admin the ability to maintain a central access control list of general user and group pairs, which can be deployed via tools like CFEngine. If a QA user attempts to login to a non-QA system, PAM will first check for the user's name in the users portion of the ACL. If a match is found, it will then check if the current machine's hostname exists in the netgroup or machine name section. If the current machine does not belong to the netgroup, the ACL fails and the next one will be tried.

Since we have created our own framework of system and user group ACLs inside the LDAP server, we have decoupled access control from the actual posixAccount and posixGroup entries. This means that the user no longer requires an account in the LDAP server itself. A simple entry in /etc/passwd is good enough to apply access control in this manner.

With this infrastructure in place, we can now start up Fedora's Admin Console or our favorite LDAP editor and quickly add or remove login access to users and machines!

### Advanced Usage & Tips

#### Using sub scope

Use sub scope for your netgroup queries as configured in /etc/ldap.conf. This will give you the ability to create new netgroups inside organizationalUnit and other containers, which will help categorize your ACLs. nss\_ldap is smart enough to only match objects of type nisNetgroup when performing its searches.

#### Cascading access control and system groupings

With the memberNisNetgroup attribute, we can join together our netgroups to achieve cascading access control and system groupings. What if the QAUsers bobby and joey were also members of a larger team called LinuxTeam, which contains individuals who aren't in QA? An example LDIF defining the LinuxTeam:

    dn: cn=LinuxTeam,ou=Netgroup,dc=example,dc=com    
    objectClass: nisNetgroup    
    objectClass: top    
    cn: LinuxTeam    
    nisNetgroupTriple: (,frank,example.com)    
    nisNetgroupTriple: (,jill,example.com)    
    memberNisNetgroup: QA    
    memberNisNetgroup: Development    
    memberNisNetgroup: Operations    
    description: The Linux Team    

Here we have defined some new users frank and jill as being part of the LinuxTeam. We have also automatically imported bobby and joey from the QA team as well as any additional users defined in our hypothetical Development and Operations groups. Any ACL for the LinuxTeam deployed on our network will not only apply to frank and jill, but to all imported users!

You may have noticed the nisNetgroupTriple's example.com entry. This is an indicator to NIS netgroup clients that the result of the netgroup query should only apply to servers in the example.com domain. If you have multiple domains, this can be a useful feature to further separate your ACLs. It's also completely optional. Leaving this portion of the triple empty will remove the domain restriction.

#### Subdomains

If anybody is curious how to get subdomains working, you can 'trick' this to work by defining the triple this way:

    (ldap02.inside, , exampledomain.com)

instead of this:

    (ldap02, , inside.exampledomain.com)

The first example appears to allow this to work.

#### Hostnames

If the system returns a FQDN for 'hostname', then the first part of the triple must be defined using the FQDN. This is important if you are using @user@@hostname in pam\_access.so.

    (webserver.loc.example.com, , exampledomain.com)    

Notes
-----

It's worth noting that the LDAP backend implementation discussed here can be implemented in other directory servers such as Active Directory. Also, client functionality can be applied to most modern PAM-enabled UNIX systems such as Linux and Solaris.

I hope this information will be useful for systems administrators out there trying to implement centralized and maintainable access control in their Linux/UNIX network. It can be done!
