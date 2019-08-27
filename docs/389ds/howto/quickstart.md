---
title: "Quick Start"
---

{% include toc.md %}

This quick start is designed to cover a variety of topics of the Directory Server from setup,
configuration, administration, and more. It should help you have a reliable and simple
setup configured very quickly.

If you want to learn more about what ldap is, you should read our ["ldap concepts"](/docs/389ds/ldap-concepts.html)
guide.

For this quickstart you'll need two virtual machines, and they should be able to contact each other
by their hostnames. I'll be using "ldap.example.com" and "client.example.com".

This document is for Directory Server 1.4.x - for 1.3.x (IE CentOS 7) you should follow the corresponding [Red Hat documentation](https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/installation_guide/index) instead of this page.

# Installing the software
-------------------------

You'll need to install a copy of the server. On OpenSUSE leap 15 or tumbleweed this is:

    zypper install 389-ds

On fedora or CentOS 8:

    dnf install 389-ds-base

If your platform isn't listed, check our download page for more details on how to install - on contact us!

Finally check you have the correct package version installed - it should be in the 1.4.x series.

    # rpm -qa | grep 389-ds
    389-ds-1.4.x.x.x86_64

reference: [downloads](/docs/389ds/download.html)

# Our commands
--------------

389 Directory Server is controlled by 3 primary commands.

* dsctl: This manages a local instance, requiring root permissions. This starts, stops, backs-up and more.
* dsconf: Manage a remote or local instance configuration. This requires cn=Directory Manager. It changes settings of the server and is the primary tool you will use for administration of config.
* dsidm: Manage content inside of a backend, with an identity management focus. The permissions of
this tool are granted by access controls, and can even be used for some limited self service actions.

# Setup the instance
--------------------

We want to setup your server now. A basic configuration is:

    # /root/instance.inf
    [general]
    config_version = 2

    [slapd]
    root_password = YOUR_ADMIN_PASSWORD_HERE

    [backend-userroot]
    sample_entries = yes
    suffix = dc=example,dc=com

Now you can install your 389 DS instance with:

    dscreate from-file /root/instance.inf

Hint: if you are running in docker, you'll need to use the -c flag in your install.

That's it! You have a working LDAP server. You can show this with:

    dsctl localhost status

If you have any issues, re-run the installer with verbose to help identify the cause:

    dscreate -v from-file /root/instance.inf

reference: [install guide](/docs/389ds/howto/howto-install-389.html)

# Setup Admin credentials
-------------------------

To make administration easier, we can indicate through a config how to connect to the directory
server. This is a file called ~/.dsrc

For remote administration a configuration is:

    # cat ~/.dsrc
    [localhost]
    uri = ldaps://localhost
    basedn = dc=example,dc=com
    binddn = cn=Directory Manager
    # You need to copy /etc/dirsrv/slapd-localhost/ca.crt to your host for this to work.
    # Then run /usr/bin/c_rehash /etc/openldap/certs
    tls_cacertdir = /etc/openldap/certs/

For local instance administration (on the server), you want to use settings like:

    # cat ~/.dsrc
    [localhost]
    # Note that '/' is replaced to '%%2f'.
    uri = ldapi://%%2fvar%%2frun%%2fslapd-localhost.socket
    basedn = dc=example,dc=com
    binddn = cn=Directory Manager

For now, we recommend you use the local version with ldapi

Question: "When I use ldapi on the server that has the DS instance, why don't I need to provide my
password?"

With LDAP, we are able to detect your client-processes UID/GID, and if that's 0/0 (ie root), we map
you to the cn=Directory Manager user of the instance. With this, you could actually set the hash
to garbage on the instance, and use local-root as the only admin of the instance. Nice and secure!

reference: [install guide](/docs/389ds/howto/howto-install-389.html)

# Add users and groups
----------------------

Now we want to store some users and groups in your directory. Let's make two users, Alice and Eve
with the dsidm command. You can give answers as arguments to the command line, or it will
interactively prompt for them.

    # dsidm localhost user create
    Enter password for cn=Directory Manager on ldaps://localhost:
    Enter value for uid : alice
    Enter value for cn : Alice
    Enter value for displayName : Alice User
    Enter value for uidNumber : 1000
    Enter value for gidNumber : 1000
    Enter value for homeDirectory : /home/alice
    Sucessfully created alice

    # dsidm localhost user create --uid eve --cn Eve --displayName 'Eve User' --uidNumber 1001 --gidNumber 1001 --homeDirectory /home/eve
    Enter password for cn=Directory Manager on ldaps://localhost:
    Sucessfully created eve

While our commands do our best to use "short names" like alice, eve, etc, many parts of LDAP require
a "distinguished name". This is a fully qualified name to the directory object, which is guaranteed
unique. We can look at the dn for any type with the "get" command. This shows us the objects we
query for.

    # dsidm localhost user get alice
    Enter password for cn=Directory Manager on ldaps://localhost:
    dn: uid=alice,ou=people,dc=example,dc=com
    ...

Now knowing the dn, we can reset (overwrite) or change (self change) passwords for these accounts. Note we use the "account"
subcommand here, which deals with authentication to the directory, account locking, unlocking
and more.

    # dsidm localhost account reset_password uid=alice,ou=people,dc=example,dc=com
    Enter password for cn=Directory Manager on ldaps://localhost:
    Enter new password for uid=alice,ou=people,dc=example,dc=com :
    CONFIRM - Enter new password for uid=alice,ou=people,dc=example,dc=com :
    reset password for uid=alice,ou=people,dc=example,dc=com

Try the same for eve now.

Next, let's create a group; we'll call it server_admins, and we'll add Alice as a member. We have to
look up Alice's distinguished name, or dn in LDAP terms, to add them correctly to the
group.

    # dsidm localhost group create
    Enter password for cn=Directory Manager on ldaps://localhost:
    Enter value for cn : server_admins
    Sucessfully created server_admins

    # dsidm localhost group add_member server_admins uid=alice,ou=people,dc=example,dc=com
    Enter password for cn=Directory Manager on ldaps://localhost:
    added member: uid=alice,ou=people,dc=example,dc=com

That's it! We have users and groups that can authenticate and have information assigned to them.

We can show the authentication works with the "ldapwhoami" command.

    # ldapwhoami -H ldaps://localhost -D uid=alice,ou=people,dc=example,dc=com -W -x
    Enter LDAP Password: <Password of alice, not the Directory Manager admin>
    dn: uid=alice,ou=people,dc=example,dc=com

NOTE: If you get an error like:

    ldap_sasl_bind(SIMPLE): Can't contact LDAP server (-1)

This can occur because the openldap client tools don't trust our certificate (the error message is misleading). You can fix this by putting the ca cert path in the environment.

    LDAPTLS_CACERT=/etc/dirsrv/slapd-localhost/ca.crt ldapwhoami -H ldaps://localhost -D uid=alice,ou=people,dc=example,dc=com -W -x

To make this permanent, put 'TLS_CACERT /etc/dirsrv/slapd-localhost/ca.crt' into /etc/openldap/ldap.conf.

We can also make some simple changes to our users if we want with the "modify" command. Add will
append an attribute into the current set, replace will remove the existing attributes values, and
delete will remove the attribute as listed.

For example we can now add a description to our users.

    # dsidm localhost user modify alice "add:description:Alice Test User"

Now you can check your changes on the object with:

    # dsidm localhost user get alice

This would add "description: Alice Test User" to uid=alice. If we wanted to replace this with a new
value, we would run:

    # dsidm localhost user modify alice "replace:description:New Description"

If we wanted to remove a single value:

    # dsidm localhost user modify alice "delete:description:New Description"

This will let you make minor changes to your users are required, if we don't supply a wrapper
to help out.

reference: [users and groups](/docs/389ds/howto/howto-users-and-groups.html)

# Add plugins
-------------

We ship lots of useful plugins ... let's setup memberof, which adds a reverse link between a user
and who they are a member. This makes security lookups much faster.

Administration of plugins is a dsconf tool action, as it's server administration. We can show the
current status of the plugin with:

    # dsconf localhost plugin memberof status
    Enter password for cn=Directory Manager on ldaps://localhost:
    Plugin 'MemberOf Plugin' is disabled

So it's currently disabled! Let's turn it on, and restart our server to enable it.

    # dsconf localhost plugin memberof enable
    Enter password for cn=Directory Manager on ldaps://localhost:3636:
    Enabled plugin 'MemberOf Plugin'

    # dsctl localhost restart
    Instance "localhost" has been restarted

Now, lets configure the plugin to be useful. We want memberof to search for all entries,

    # dsconf localhost plugin memberof set --scope dc=example,dc=com
    Enter password for cn=Directory Manager on ldaps://localhost:
    successfully added memberOfEntryScope value "dc=example,dc=com"

We need to mark alice as being a valid memberOf target: This is only because it was
created *before* memberOf was enabled. All new groups and users after this point will work as
expected - so this is a once off task:

    # dsidm localhost user modify alice add:objectclass:nsmemberof

Finally, we can run a "fixup" which will regenerate memberof for everyone in the directory.

    # dsconf localhost plugin memberof fixup dc=example,dc=com
    Enter password for cn=Directory Manager on ldaps://localhost:
    Attempting to add task entry... This will fail if MemberOf plug-in is not enabled.
    Successfully added task entry cn=memberOf_fixup_2019-01-14T13:05:04.011865,cn=memberOf task,cn=tasks,cn=config

The fixup won't take long: We can see that it has worked by checking on Alice again and seeing
the memberOf attribute:

    # dsidm localhost user get alice
    dn: uid=alice,ou=people,dc=example,dc=com
    ...
    memberOf: cn=server_admins,ou=groups,dc=example,dc=com

Now anytime you add a member to a group it will update the reverse memberOf pointer. This is really
great as it allows a fast caching of "what groups someone is a member of" which helps make your
server faster and simpler to administer.

reference: [Setup MemberOf](/docs/389ds/howto/howto-memberof.html)

# Setup SSSD
------------

First install sssd on your machine:

    zypper in sssd
    dnf install sssd

On OpenSUSE and SUSE LEAP you need to stop nscd which conflicts with sssd.

    systemctl disable nscd && systemctl stop nscd

Now generate the config. See how we specific "server_admins"? That means only members of this
group can login to this system:

    dsidm localhost client_config sssd.conf server_admins

If you are happy, copy paste (or redirect) the content to /etc/sssd/sssd.conf

On fedora, sssd is already part of pam and nsswitch, so you don't need to do anything!
For SUSE, you need to configure these files yourself, so now is the time to check the full
[sssd how to](/docs/389ds/howto/howto-sssd.html) for examples.

Next setup the certificates. To do this, copy ca.crt from the ldap server host to your client.

    mkdir -p /etc/openldap/certs
    cp <...>/ca.crt /etc/openldap/certs/
    /usr/bin/c_rehash /etc/openldap/certs

Finally, we can now start sssd:

    systemctl enable sssd
    systemctl start sssd

And we can resolve our users:

    id alice
    id eve

If everything is done properly, you should be able to ssh in as alice, but not eve.

reference: [Setup SSSD](/docs/389ds/howto/howto-sssd.html)

# Configuration for other services
----------------------------------

Having users and groups stored here is well and good, but it only matters when other applications
can connect to and consume this information. Most client applications request a small number of
configuration paramaters: some of them use LDAP specific terms that seem a bit intimidating at first.
However all of the information needed is in our server, so we can display a guide of how to use
this with:

    dsidm localhost client_config display

You will need to adapt and change this as required, but it should help you to identify and understand
ldap client integration.

# Backup and Restore
--------------------

Backups and Restores are a vital part of Directory Server administration. As the source of identity
truth on a network, it's critical the data is correct and preserved in case of disaster.

To create a backup, run:

    dsctl localhost stop
    dsctl localhost db2bak
    # OR, for ldif
    dsctl localhost db2ldif --replication userRoot
    dsctl localhost start

To restore:

    dsctl localhost stop
    dsctl localhost bak2db 
    dsctl localhost bak2db /var/lib/dirsrv/slapd-localhost/bak/<archive name>
    # OR, for ldif
    dsctl localhost ldif2db userRoot /var/lib/dirsrv/slapd-localhost/ldif/<ldif name>
    dsctl localhost start

These backups contain vital and important user data, so protect and secure these properly!

reference: [Backup and Restore Strategies](/docs/389ds/howto/howto-backup-restore.html)

# What's next?
--------------

389 Directory Server ships with many other features and plugins. Some you may want to explore:

* TLS: [Setup TLS](/docs/389ds/howto/howto-ssl.html)
* Replication: [Setup Replication]()
* Cockpit Web Console: [Setup Cockpit](/docs/389ds/howto/howto-install-389.html)
* Access Controls: [Setup ACI](/docs/389ds/howto/howto-accesscontrol.html)
* Distributed Numeric Assignment: [Setup DNA](/docs/389ds/howto/howto-dna.html)
* RADIUS: [Setup RADIUS]()
* Monitoring: [Setup Monitoring]()
* Attribute Uniquness: [Setup Attribute Uniqueness]()

We want to hear from you to about your setup and configurations, so please contact the team to extend
this section!

# Author
--------

William Brown (SUSE Labs)
wbrown at suse.de

