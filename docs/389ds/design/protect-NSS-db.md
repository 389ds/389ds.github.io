---
title: "Directory Server protection of NSS DB content"
---
    
# protection of NSS DB content
----------------

This document describes how Directory Server will protect NSS database access. Using Keyring or Clevis/Tang we can prevent NSS sensitive files (passwords, extracted keys and certificates) to be compromised.

Overview
--------

Directory servers installation contains some sensitive files. Relying on the rights of the files looks as a weak protection in case of an attack. The idea is either to remove those files or to make the content of those files useless if compromised. This document details two different approaches <b>Keyring</b> and <b>Clevis/Tang</b>.

Use Cases
---------

DS is configured with secure port. The administrator wants DS to be start without being prompted for NSS password.
To do So he creates a pin file (pin.txt) that is used to initialize the NSS database and extract key/certs.
Someone connected on the Directory server host, with the appropriate rights, can use the pin.txt file to read/write NSS database.

# Design
------

Directory server is a service of systemd, so if it terminates abrutly (a crash) systemd may restart it automatically. In such case the administrator does not want to be prompted for a NSS password and so registers the NSS password in <b>pin.txt</b> file. In order to protect the file we have two options:

- moving its content into a in memory repository where it can be retrieved, this is the purpose of <b>Keyring</b>.
- encrypting its content into a <b>encrypted_pin.txt</b> so that its content is useless, this is the purpose of <b>Clevis/Tang</b>

Directory servers retrieves NSS password using <i>svrcore</i> framework. This framework call a retrieving method and if the method fails then it calls a fallback. The fallback also registers a method/fallback etc.. Svrcore basically contains a <u>ordered list of retrieval method and fallback</u>. Each method/fallback is registered in a so called <i>plugin</i>. Each DS instance has its own <i>svrcore list method/fallback</i>. The ordered list of retrieval method is:

- retrieval from <b>svcore cache</b> using the NNS default slot token (see below) as a key for cache lookup.
- retrieval from <b>pin.txt</b>
- retrieval from systemd <b>'/run/systemd/ask-password'</b> framework
- retrieval from terminal

## Svrcore

### Plugin

DS retrieves NSS password using <i>svrcore</i>. In order to take into account a new retrieval method (<b>keyring</b> or <b>Clevis/Tang</b>) we need to create a new svrcore plugin (keyring or clevisTang). The plugin defines the retrieval method (using standard callback <b>getPin</b>) and insert it at the appropriate place in the retrieval method/fallback ordered list.
With <b>keyring</b> the plugin method is in <b>keyring-ask-password.c</b> and the insertion in <b>std-keyring.c</b>.
With <b>ClevisTang</b> the plugin method is in <b>clevistang-ask-password.c</b> and the insertion in <b>std-clevistang.c</b>.

Using <b>keyring</b> or alternatively <b>ClevisTang</b> the resulting ordered list is

- retrieval from <b>svcore cache</b> using the NNS default slot token (see below) as a key for cache lookup.
- retrieval from <b>keyring</b> or alternatively <b>ClevisTang</b>
- retrieval from <b>pin.txt</b>
- retrieval from systemd <b>'/run/systemd/ask-password'</b> framework
- retrieval from terminal

### setup / getPin

Because the password is stored while being <b>root</b> and needed while being <b>&lt;nsslapd-localuser&gt;</b> (aka as <b>dirsrv</b>) it requires an intermediate step.
The password is stored once prompted by <b>systemd</b>. Before the DS deamon calls setuid (<b>detach</b>), DS running as root retrieves the password using <b>keyctl_search/keyctl_read</b> and stores it in a <i>local variable</i>. Then DS starts running as <b>dirsrv</b> and copy the password from the <b>local variable</b> to <b>svrcore keyring plugin</b> during <b>svrcore_setup</b>.
Finally when DS needs the password, for NSS/SSL initialization, it calls <b>svrcore getPin</b> (during <b>slapd_ssl_init/slapd_pk11_authenticate</b>.

## Keyring


After a <i>reboot</i> of a box hosting the directory server, the <u>keyring does not contain any data</u>. To be provisioned, the first time the directory instance is started (via <i>systemd</i>), the system administrator is prompted (<b>systemd-ask-password</b>) for the NSS password. Then the password is stored (in <u>clear text</u>) in <i>keyring</i>.

At this time the administrator is logged as <i>root</i> and stores the password in <b>'@u'</b> <i>keyring</i> with <b>'user'</b> <i>keytype</i>.

Later the password is retrieved by directory server (using svrcore and <b>keyring</b> plugin). 

An important point is that <b>keyring provisioning</b> is done by <b>systemd</b> so by <b>root</b> user. The retrieval is done by <b>directory server</b>, that is launched as <b>root</b> but later setuid to <b>&lt;nsslapd-localuser&gt;</b> (aka as <b>dirsrv</b>).

### key name
Keyring is a shared repository, so it will contains <u>all</u> the NSS passwords of all instances running on the box.
The <i>keyname</i> must differentiate each individual instance. So the <i>keyname</i> has the format: &lt;<i>fixed name</i>&gt;&lt;<i>instance_serverid</i>&gt;&lt;<i>info_type</i>&gt;, where 

- <i>fixed name</i> is <u>Internal (Software) Token</u> that is the <b>token_name</b> of the NSS default slot. The <b>token_name</b>(dbTokenDescription) used during <b>slapd_nss_init/slapd_pk11_configurePKCS11</b>.
- <i>instance_serverid</i> is <u>serverID</u>  (e.g. 'master1')
- <i>info_type</i> is <u>password</u> meaning this key retrieves a password related to instance_serverid


## Core server

If the core server (<b>main.c</b>) for <b>keyring</b> then it requires the link option <b>-lkeyutils</b> and define build option <b>-DWITH_KEYRING</b>.

## systemd

With keyring a script must fetch (<b>keyctl search @u user &lt;key_name&gt;</b>) the NSS instance password. If it does not exist, it must prompt (<b>systemd-ask-password</b>) the administrator and store it (<b>keyctl padd user &lt;key_name&gt; @u</b>).

To allow DS to read the keyring password (<b>keyctl_read</b>), the systemd template must define <b>KeyringMode=shared</b> 

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

