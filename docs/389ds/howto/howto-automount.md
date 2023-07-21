---
title: "Howto: Automount"
---

# Automount Issues
----------------

{% include toc.md %}

### Additional schema required for some systems

If you are supporting Solaris clients, you WILL need the 2307bis style automount schema, although Sun's version is NOT identical to the one at <http://people.redhat.com/nalin/schema/autofs.schema>.

The following schema is from the HP's [site](http://docs.hp.com/en/J4269-90051/ch02s09.html)

    dn: cn=schema
    objectClasses: ( 1.3.6.1.1.1.2.16 NAME 'automountMap' DESC 'Automount Map information' SUP top
     STRUCTURAL MUST automountMapName MAY description X-ORIGIN 'user defined' )
    objectClasses: ( 1.3.6.1.1.1.2.17 NAME 'automount' DESC 'Automount information' SUP top STRUCTURAL
     MUST ( automountKey $ automountInformation ) MAY description X-ORIGIN 'user defined' )
    attributeTypes: ( 1.3.6.1.1.1.1.31 NAME 'automountMapName' DESC 'automount Map Name' EQUALITY
     caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE X-ORIGIN 'user defined' )
    attributeTypes: ( 1.3.6.1.1.1.1.32 NAME 'automountKey' DESC 'Automount Key value' EQUALITY
     caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE X-ORIGIN 'user defined' )
    attributeTypes: ( 1.3.6.1.1.1.1.33 NAME 'automountInformation' DESC 'Automount information'
     EQUALITY caseExactIA5Match SYNTAX 1.3.6.1.4.1.1466.115.121.1.26 SINGLE-VALUE X-ORIGIN 'user
     defined' )

### How to get Linux autofs to work with SunDS

Should also apply to Fedora DS
<http://www.ldapguru.com/modules/newbb/viewtopic.php?topic_id=1478&forum=24#forumpost5016>

The above link cannot be reached. I think the link is now:

<http://blogs.sun.com/rohanpinto/entry/nis_to_ldap_migration_guide>

Detail Steps
------------

Instructions on how to create autofs mount entries for ldap and linux. First part deals with exporting /home for our user tux.

### Prerequisites

You should have your ldap server up and running. Root access to the server you want autofs to work on. Also that server should already be able to communicate with the ldap server for users/groups. You will need the perl script found here [ol-schema-migrate.pl ](http://directory.fedoraproject.org/download/ol-schema-migrate.pl). And download the schema [schema](http://people.redhat.com/nalin/schema/autofs.schema) file mentioned above. You will also need to have nfs service on the server you want to export directories from. configuring nfs is beyond the scope of this document but an entry in the /etc/exports looks something like this

    /home 192.168.1.0/16(rw,fsid=0,insecure,no_subtree_check,sync,anonuid=65534,anongid=65534)

Test from the command line that you can mount the /home directory. This helps eliminate suspects when things don't work. You should also change our test user tux to a user in your ldap server.

### Convert/pretty up the schema

The schema is now shipped with Directory Server Core as 60autofs.ldif

### Creating auto.supplier

Now that we have our schema loaded we can now create our auto.supplier ou (Organizational Unit).

    dn: ou=auto.supplier,dc=example,dc=com
    ou: auto.supplier
    objectClass: top
    objectClass: automountMap

Now create a automount entry under auto.supplier for /home

    dn: cn=/home,ou=auto.supplier,dc=example,dc=com
    objectClass: automount
    cn: /home
    automountInformation: ldap:ds.example.com:ou=auto.home,dc=example,dc=com

What these entry is doing is it will inform autofs where to get the mount information for /home

### Creating auto.home

For the auto.home we need to create another ou.

    dn: ou=auto.home,dc=example,dc=com
    ou: auto.home
    objectClass: top
    objectClass: organizationalUnit
    objectClass: automountmap

Under this ou we will have our entries for each user. Our user should look like the following

    dn: cn=tux,ou=auto.home,dc=example,dc=com
    cn: tux
    objectClass: automount
    automountInformation: -rsize=8192,wsize=8192,intr NfsServer.example.com:/home/tux

The automountInformation is telling the autofs the options to use when it mounts the directory, and what server to get the directory from.

### autofs

The last thing you will need to do is edit the /etc/sysconfig/autofs file and enable the following lines.

    #
    # Other common LDAP nameing
    #
    DEFAULT_MAP_OBJECT_CLASS="automountMap"
    DEFAULT_ENTRY_OBJECT_CLASS="automount"
    DEFAULT_MAP_ATTRIBUTE="ou"
    DEFAULT_ENTRY_ATTRIBUTE="cn"
    DEFAULT_VALUE_ATTRIBUTE="automountInformation"

Once you have made the changes and saved the file restart autofs

    [root@remote_system ~]# service autofs restart

You should now be able to su - tux and see that his home directory has been mounted. If not check the /var/log/messages. You can also turn up the debug in the /etc/sysconfig/autofs file.

### All User Entry

If you want all users to be able to mount their home directory, but don't want to add an entry for each user, you will take the following.

    dn: cn=tux,ou=auto.home,dc=example,dc=com
    cn: tux
    objectClass: automount
    automountInformation: -rsize=8192,wsize=8192,intr NfsServer.example.com:/home/tux

and make it look like

    dn: cn=/,ou=auto.home,dc=example,dc=com
    cn: /
    objectClass: automount
    automountInformation: -rsize=8192,wsize=8192,intr NfsServer.example.com:/home/&

Then anyone that has a home directory the server on your NfsServer the autofs will mount it.

### Additions

Watch for info on how to make auto.misc, and others.

### Links

I used the following sites for information on how to do this.
<http://efod.se/blog/archive/2006/06/27/autofs-and-ldap>
<http://www.linuxjournal.com/article/6266>
<http://forums.fedoraforum.org/showthread.php?t=138992>
<http://forums.fedoraforum.org/forum/showthread.php?t=135635&highlight=autofs+ldap>
