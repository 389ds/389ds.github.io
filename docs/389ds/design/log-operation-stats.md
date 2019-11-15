---
title: "Directory Server operation metrics"
---
    
# Operation metrics
----------------

{% include toc.md %}

This document describes how Directory Server will log metrics related to each individual operation. The metrics are counters (count, duration, timestamp, threshold, flags...) specific for a given operation. The counters are related to internal mechanism used by Directory Server core / plugins to process an operation. The counters are intended to be used for analyzing performance of separated operation but are not intended to measure load performance.

Overview
--------

When applying a given workload on a Directory Server we can see the operation <i>response time</i> (<b>etime</b>) in the access log. If we want to know the layout of the response time (i.e. database or index access, evaluation of aci, filter evaluation/check, values matching...) we can use <b>debug logging</b> or <b>external tools (pstack, stap, strace...)</b>. The drawbacks of those approaches are that they interfere with the server (slowdown). Also analyzing the logs/traces is time consuming (all operations logs/traces are mixed) and finally requires a good knowledge of DS internals to do  a diagnostic.

The purpose of this design is to present the layout of the response time with a mechanism with minimal impact on the server, because of the use of access logs that are buffered. Providing metrics per operation allow to isolate metrics from the others operations. If an operation has a large response time, many times it is due to very few expensive components. There is a hope that metrics from those expensive components will be significantly high to help diagnose without the need of good knowledge of DS internals.

Use Cases
---------

When monitoring performance we can see logs like

    [25/Oct/2019:16:23:28.620364576 +0200] conn=1 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(sn=user*)" attrs=ALL
    [25/Oct/2019:16:23:28.623701596 +0200] conn=1 op=1 RESULT err=0 tag=101 nentries=20 etime=0.003488420

This RFE will extend access logs with per operation statistics like

    [25/Oct/2019:16:23:28.620364576 +0200] conn=1 op=1 SRCH base="dc=example,dc=com" scope=2 filter="(sn=user*)" attrs=ALL
    [25/Oct/2019:16:23:28.623678548 +0200] conn=1 op=1 STAT filter index lookup: attribute=objectclass key(eq)=referral --> count 0
    [25/Oct/2019:16:23:28.623697194 +0200] conn=1 op=1 STAT filter index lookup: attribute=sn key(sub)=ser --> count 21
    [25/Oct/2019:16:23:28.623698763 +0200] conn=1 op=1 STAT filter index lookup: attribute=sn key(sub)=use --> count 24
    [25/Oct/2019:16:23:28.623700176 +0200] conn=1 op=1 STAT filter index lookup: attribute=sn key(sub)=^us --> count 20
    [25/Oct/2019:16:23:28.623701596 +0200] conn=1 op=1 RESULT err=0 tag=101 nentries=20 etime=0.003488420

For this operation we can see, for example, that the index lookups (db read) during filter evaluation were

   - (objectclass=referral)  -> 0 lookup (this value did not exist)
   - (sn=user*) -> 21+24+20= 65 lookup 

In such case 65 is not optimal but acceptable. For a long lasting operation, a value of let's say 100.000 lookup would have ring a bell as a possible responsible of the bad response time.

# Design
------

The principle is to collect metrics, during the processing of an operation, and to log them along with the operation result. The collect of metrics is done during specific <b>probes</b> of the operation processing, so collect could impact operation performance. The logging of the operation result is done <b>after</b> the operation result is sent back (for direct operation) or stored in the pblock (internal operations). So the <b>logging has no performance impact</b> for direct operations. For the logging for internal operations <b>impacts the performance</b> of the parent operation but considering logging is buffered, this impact is <b>limited</b>.

In order to limit the performance impact of the <b>probes</b>, we can turn <b>on/off</b> the collect in probes with a set of new config parameters <b>nsslapd-stat-&lt;operation&gt;-level</b>

## Configuration

Each probe belong to a given operation and level



## collect/logging selection

It introduces two ne
## Probes

### principle

Directory servers retrieves NSS password using <i>svrcore</i> framework. This framework call a retrieving method and if the method fails then it calls a fallback. The fallback also registers a method/fallback etc.. Svrcore basically contains a <u>ordered list of retrieval method and fallback</u>. Each method/fallback is registered in a so called <i>plugin</i>. Each DS instance has its own <i>svrcore list method/fallback</i>. The ordered list of retrieval method is:

- retrieval from <b>svcore cache</b> using the NNS default slot token (see below) as a key for cache lookup.
- retrieval from <b>pin.txt</b>
- retrieval from systemd <b>'/run/systemd/ask-password'</b> framework
- retrieval from terminal

### New plugin

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

### provisioning

After a <i>reboot</i> of a box hosting the directory server, the <u>keyring does not contain any data</u>. To be provisioned, the first time the directory instance is started (via <i>systemd</i>), the system administrator is prompted (<b>systemd-ask-password</b>) for the NSS password. Then the password is stored (in <u>clear text</u>) in <i>keyring</i>.

At this time the administrator is logged as <i>root</i> and stores the password in <b>'@u'</b> <i>keyring</i> with <b>'user'</b> <i>keytype</i>.

### retrieval

Later the password is retrieved by directory server (using svrcore and <b>keyring</b> plugin). 

An important point is that <b>keyring provisioning</b> is done by <b>systemd</b> so by <b>root</b> user. The retrieval is done by <b>directory server</b>, that is launched as <b>root</b> but later setuid to <b>&lt;nsslapd-localuser&gt;</b> (aka as <b>dirsrv</b>).

### key name
Keyring is a shared repository, so it will contains <u>all</u> the NSS passwords of all instances running on the box.
The <i>keyname</i> must differentiate each individual instance. So the <i>keyname</i> has the format: &lt;<i>fixed name</i>&gt;&lt;<i>instance_serverid</i>&gt;&lt;<i>info_type</i>&gt;, where 

- <i>fixed name</i> is <u>Internal (Software) Token</u> that is the <b>token_name</b> of the NSS default slot. The <b>token_name</b>(dbTokenDescription) used during <b>slapd_nss_init/slapd_pk11_configurePKCS11</b>.
- <i>instance_serverid</i> is <u>serverID</u>  (e.g. 'master1')
- <i>info_type</i> is <u>password</u> meaning this key retrieves a password related to instance_serverid


## Core server

### using keyring

It exists <u>two</u> phases that register and later retrieve the password:

- <i>systemd</i>: <i>systemd</i> (in systemd template <b>ExecStartPre</b>) prompts the password and registers it into <i>keyring</i>. Later <i>core server</i> retrieves the password from <i>keyring</i> to be used for NSS/SSL initialization. Note, before prompting the password <i>systemd</i> check if it is already registered. If it is already registered it does nothing. That means the if the registered password is invalid, the administrator needs to <b>clear</b> the all <i>keyring</i> <b>@u</b> or simply <b>purge</b> the specific <i>keyname</i>.
- <i>svrcore</i>: <i>core server</i> registers the password in the <b>svrcore keyring plugin</b> (<b>svrcore_setup</b>), later <i>core server</i> retrieves the password from <b>svrcore keyring plugin</b> (<b>getPin</b>) and uses it for NSS/SSL initialization.

If the core server (<b>main.c</b>) uses <b>keyring</b> then it requires the link option <b>-lkeyutils</b> and define build option <b>-DWITH_KEYRING</b>. Indeed core server calls <b>keyctl_search/keyctl_read</b> to retrieve the password from <b>keyring</b>. It does this while the DS deamon is running as root (before <b>detach</b>).
When retrieved, it provides the password to NSS/SSL setup rountine (<b>slapd_do_all_nss_ssl_init</b>). This routine first registers (<b>svrcore_setup</b>) the password into the svrcore plugin that handle <i>keyring</i> (<b>std-keyring.c</b>) then later retrieved from <i>svrcore</i> (<b>getPin</b>) during <b>slapd_ssl_init/slapd_pk11_authenticate</b>.

In the first phase, when DS started by <i>systemd</i> retrieves password from <i>keyring</i>, it calls keyctl_read that triggers a <i>Selinux AVC</i>. A new policy is required TBD.

### using Clevis/Tang

The idea would be to let a <i>systemd</i> script (in systemd template <b>ExecStartPre</b>) to test if it exists <b>encrypted_pin.txt</b> JSON file. If it does not exist either prompt or read the <b>pin.txt</b> file, encode the password, store it into <b>encrypted_pin.txt</b> and remove <b>pin.txt</b> file.

#### Tang server

We need a tang server to encrypt and decrypt. If each host has its local own <i>Tang server</i> it is a bit generous. The advantage is it simplifes the process of key rotation and only local instance are impacted in case of problem on the <i>Tang server</i>.
If we have a centralized <i>Tang server</i>, it becomes a SPOF and its key rotation will impact all instance using it.
It requires to 

- install the <b>tang</b> rpm
- generate signature (<b>jose jwk gen -i '{"alg":"ES512"}' -o /var/db/tang/new_sig.jwk</b>) and exchange (<b>jose jwk gen -i '{"alg":"ECMR"}' -o /var/db/tang/new_exc.jwk</b>)
- start the <b>tangd.socket</b> server (<b>systemctl enable tangd.socket --now</b>)
- a change of <b>ListenStream</b> (in <i>/usr/lib/systemd/system/tangd.socket</i>) require firewall+selinux setup to allow the port.

#### Clevis client

The <i>Clevis</i> client is used to translate a clear text password file <b>pin.txt</b> into an encrypted one: <b>clevis encrypt tang '{"url", "http://&lt;tang_server_hostname&gt;[:&lt;tang_server_ListenStream&gt;]"}' &lt; pin.txt &gt; encrypted_pin.txt</b>.


## systemd

With keyring a script must fetch (<b>keyctl search @u user &lt;key_name&gt;</b>) the NSS instance password. If it does not exist, it must prompt (<b>systemd-ask-password</b>) the administrator and store it (<b>keyctl padd user &lt;key_name&gt; @u</b>).

To allow DS to read the keyring password (<b>keyctl_read</b>), the systemd template must define <b>KeyringMode=shared</b> 


## Selinux

When the core server, running as root, reads keyring (<b>keyctl_read</b>) it triggers an <i>Selinux AVC</i>. Need to define a policy to allow that TBD

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

