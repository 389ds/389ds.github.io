---
title: "FAQs"
---

# Frequently Asked Questions
----------------------------

{% include toc.md %}

<a name="general"></a>**General**
----------------------------------------

### What is a Directory Server?

A directory server provides a centralized directory service for your intranet, network, and extranet information. Directory Server integrates with existing systems and acts as a centralized repository for the consolidation of employee, customer, supplier, and partner information. You can extend Directory Server to manage user profiles and preferences, as well as extranet user authentication.

### How is a Directory Server different from a Relational Database?

An LDAP directory server stores information in a tree-like hierarchical structure.

The characteristics of an LDAP server are:

-   very fast read operations
-   fairly static data
-   hierarchical
-   clients use standard LDAP protocol
-   loosely coupled replication

The characteristics of an RDMBS are:

-   very fast write operations (think TPS)
-   dynamic data
-   tables with rows and columns, with key relations between tables
-   no standard on the wire protocol - vendors must provide ODBC or JDBC drivers
-   tightly coupled replication - Two Phase Commit

### What is LDAP?

[LDAP](http://en.wikipedia.org/wiki/Ldap): a protocol for accessing on-line directory services.

LDAP provides a common language that client applications and servers use to communicate with one another. LDAP is a "lightweight" version of the Directory Access Protocol (DAP) used by the ISO X.500 standard. DAP, developed at the University of Michigan, gives any application access to the directory via an extensible and robust information framework, but at an expensive administrative cost. DAP uses a communications layer (OSI stack) that is not the Internet standard TCP/IP protocol and has complicated directory-naming conventions. The current version of LDAP is 3 (LDAPv3), which is described by several RFCs [www.ietf.org/rfc](http://www.ietf.org/rfc) - 2251 through 2256 and others. There is currently an LDAPbis IETF working group which is revising these old RFCs.

LDAP preserves the best features of DAP while reducing administrative costs. LDAP uses an open directory access protocol running over TCP/IP and uses simplified encoding methods. It retains the X.500 standard data model and can support millions of entries for a modest investment in hardware and network infrastructure.

### What is LDIF?

LDIF is the LDAP Data Interchange Format. LDIF is an ASCII format that is used to exchange data between the server and the client or for export between servers. It can also be used to make changes to the LDAP server when using the command line utilities. Binary data can be referenced in an external file or included in-line in BASE-64 encoded format.

<br>

<a name="background"></a>**389 Background**
---------------------------------------

### Why 389? What happened to Fedora Directory Server?

[389 Change FAQ](389-change-faq.html)

### What do I get with 389?

You get a secure, highly scalable, robust LDAP server. This includes multi-master replication and all of the features you'd expect from an enterprise-ready LDAP server. You get a graphical management console that you can use not only for user/group/role/account management, but also for all aspects of server management, from backup/restore/import/export, replication, database/suffix creation, access control, to server monitoring, metrics gathering, and logs. You also get an Admin Server, our http engine which provides several web applications, such as a phonebook, a graphical org chart, an admin express management page, and a replication monitoring page.

### What are the main features?

See our [Features page](features.html)

### What Operating systems are supported?

389 supports:

-   Linux - Directory Server should build on:
    -   Fedora 4 and later ( x86 and x86\_64 )
    -   Red Hat Enterprise Linux 3 and later ( x86 and x86\_64 )
    -   others - debian, gentoo, ubuntu, more
-   Solaris 2.8, 2.9 (32 bit and 64 bit) ( sparc )
-   HP/UX 11 ( pa-risc and ia64 )

It may work on other platforms as well. Past versions of 389 have supported Irix, AIX, Windows, and OSF/1. See [Building](../development/building.html) for more details.

### How to install 389 in RHEL6?

EL6 support is a bit more tricky. To summarize, if you want the full 389 ds/admin/console on EL6:

-   You must use EL 6.1 or later
-   You must use 389-ds-base from the fedorapeople.org repo
-   You must use the EPEL repo for all the other package dependencies
-   See [Download](../download.html) for more information about the repos

We cannot support 6.0 - too many missing dependencies. With RHEL6.1, since the 389-ds-base package is provided by the base OS, we cannot provide them via EPEL, hence the use of the private developer repo at fedorapeople.org.

### What are the system requirements

Directory server will run on a machine with 256 MB. However, you should plan from 256 MB to 1 GB of RAM for best performance on large production systems.

You will need approximately 300 MB of disk space for a minimal installation. For production systems, you should plan at least 2 GB to support the product binaries, databases, and log files (log files require 1 GB by default); 4GB and greater may be required for very large directories.

### Is this a commercial product?

This is not a commercial product, but rather a development project.

### What is the update/bugfix/support/errata policy for 389?

In general we follow the [guidelines](http://fedoraproject.org/wiki/FAQ) of the [Fedora Project](http://fedoraproject.org). When reading The Fedora Project FAQ, you can, in general, substitute 389 for The Fedora Project and Red Hat Directory Server for Red Hat or Red Hat Enterprise Linux.

### How can I help?

You can [assist](ways-to-contribute.html) in any number of ways:

-   [Testing](../development.html)
-   [Participate in mailing lists](../mailing-lists.html)
-   [Documentation](../documentation.html)
-   [Report Bugs](bugs.html )
-   [Fix Bugs](../development.html)

### How is 389 different from OpenLDAP?

[OpenLDAP](http://www.openldap.org) and 389 were both derived from the original University of Michigan slapd project. In 1996 the original developers of slapd became Netscape employees and developed Netscape Directory Server, which is now 389. The two projects have a lot in common: support for LDAPv3 including many of the most commonly used controls and extensions; high performance (with the latest revisions of OpenLDAP 2.2.x/2.3 and BerkeleyDB 4.2.x/4.3), some form of replication, multiple back-end support, access control, and others. The [OpenLDAP](http://www.openldap.org) site has a full feature list. [Here](features.html "feature set") is a list of the features of 389.

We invite the OpenLDAP team to collaborate with 389 and insure cooperation and interoperability between our implementations.

### How is 389 different from iPlanet and Sun Directory Server?

See [History](../FAQ/history.html) for a history of Netscape, iPlanet, and Sun Directory Server.

Since the break up of iPlanet, the products have followed different development paths. However, much of the behavior and configuration are still the same: the configuration backend, schema, monitoring, management tools, etc. There are a couple of significant differences which you need to be aware of. Sun DS 5.2 changed the replication protocol, so you cannot do Sun DS 5.2 style replication with 389. However, Sun DS 5.2 has a legacy replication mode with which they are able to replicate to their 5.1 and 5.0 servers. This replication mode works with 389. You can use Sun DS 5.2 as a replication hub - it can replicate with newer versions of Sun/Oracle DS on one side, and replicate with RHDS on the other side. Also, Sun DS 5.2 has a different database format, so database files cannot be shared between the two servers. You must export your data to LDIF then import into 389. There are several other differences but they mostly don't affect interoperability. Please refer to the Sun DS documentation for more information.

### How does the 389 multi-master replication work?

389 replication uses a push model. A replication supplier is a server that pushes updates to other servers. A master is a supplier that can receive update requests from clients. A hub is a supplier that receives update requests from other replication suppliers and pushes updates to other replicas.

With multi-master replication, a master is both a replication supplier and a replication consumer. Each master can be updated at the same time and send its changes to the other masters and replicas. If conflicts occur, the conflict resolution algorithm will resolve them, and if that is not possible, the conflicts are flagged for viewing by the administrator.

Each modification is assigned a Change State Number (CSN) which uniquely identifies the modification. Part of the CSN is a timestamp, and part is the identifier of the master on which the change originated. The conflict resolution algorithm usually processes the changes such that the "last one wins" based on the timestamp, but there are many corner cases which require special handling (for example, if an entry is removed from one master and at the same time a child entry is added to that entry on another master). Deleted entries are converted to tombstones and are kept around in case some of their state information is needed for conflict resolution. Deleted values are kept around for similar reasons. These tombstone values are reaped at configurable intervals and can be kept around for as long or as short a period of time as needed.

Each entry is assigned a globally unique identifier which stays with the entry throughout its lifetime. This identifier is more reliable for uniquely identifying the entry than the Distinguished Name (DN) which may change via modrdn operations. Thus each entry can be uniquely identified throughout the entire replication topology.

Each supplier must also be configured with a changelog. This is a special database that "buffers" incoming updates and is used to send those updates to the consumers (which may be other masters). The old entries in the changelog are reaped at configurable intervals as is the old state information it is associated with, as specified above.

### Does replication inter-operate with Netscape/iPlanet/Sun Directory Server?

-   Sun/iPlanet DS 5.0, 5.1 and Netscape Directory Server 6.x, 7.0: Yes. The protocol was extended in DS7.1, but there is detection code to identify downlevel replicas and fall back to the old protocol.
-   Sun DS 5.2 and later: Yes - Sun DS 5.2 will replicate with 389 using its legacy replication mode. You can use Sun DS 5.2 as a replication hub to replicate 389 with newer versions of Sun/Oracle DS.
-   Netscape DS 4.x: There is a Legacy Replication Plug-in that must be configured and enabled. Additionally, 389 can only act as a consumer for Legacy replication, so you can't have a 4.x server as a consumer for a 389 supplier. Finally, this mode is only intended to be used for migration purposes, not long term.

### But isn't multi-master replication considered harmful?

Specifically, how do you respond to <http://www.watersprings.org/pub/id/draft-zeilenga-ldup-harmful-02.txt> ? The short answer is that 389 lets you decide what level of data integrity you require and gives you the tools to manage your data integrity. The long answer is [here](mmrconsideredharmful.html)

### How does 389 provide high-availability?

Replication (described above) gives administrators the ability to provide no single point of read failure and no single point of write failure, so the directory is always available. Most administration can be performed online, so the directory does not have to be bounced for most configuration and management, including imports, exports, backups, and restores. The database backend is transactional and automatically recovers at startup in the event of power failure or other outage. A network load balancing device can be placed in front of a group of replicas to provide even greater availability and performance.

### Does 389 work with other Red Hat products like Certificate System?

-   Certificate System
    -   Uses 389 to maintain its actual database of issued certificates.
    -   Makes use of multi-master replication to provide high availability access to the certificate store.
    -   Utilizes DS internally to manage groups of users permitted to interact with privileged features of CS.
    -   Maintains the current installed network topology of CS and all its installed subsystems on a given host with DS.
    -   Can publish issued certificates to a company wide DS directory.
    -   Although known for its data access performance, DS provides sufficient write access to support CS's sometimes heavy demands.

### What crypto engine does 389 use?

Directory server uses the Network Security Services (NSS) library available from the [Mozilla Project](http://www.mozilla.org/projects/security/). NSS supports cross-platform development of security-enabled server applications. Applications built with NSS can support PKCS \#5, PKCS \#7, PKCS \#11, PKCS \#12, S/MIME, TLS, SSL v2 and v3, X.509 v3 certificates, and other security standards. NSS provides command line tools such as certutil, modutil, and pk12util used to import/export certs/keys and perform other NSS certificate/key database management.

##### Can 389 use OpenSSL or GnuTLS?

No.

##### Can 389 use default certs from /etc/pki like SSH and other daemons use?

Not exactly. By default, 389 doesn't use the nsspem module that reads openssl/pem style cert files/directories like apache mod\_ssl and others. You can use certutil to import CA certs and other certs from pem files

    certutil -d /etc/dirsrv/slapd-hostname -A -t CT,, -i /path/to/cacertfile.pem -a

you'll have to use pk12util to import a private key with corresponding cert. First, use openssl pkcs12 to create a .p12 file:

    openssl pkcs12 -inkey /path/to/key.pem -certfile /path/to/cert.pem -export -out /path/to/keycert.p12

or if the key and cert are in the same pem file

    openssl pkcs12 -in /path/to/keycert.pem -export -out /path/to/keycert.p12

then use pk12util to import

    pk12util -d /etc/dirsrv/slapd-hostname -n Server-cert -i /path/to/keycert.p12

It may be possible to use the pem files directly. You could use modutil to load the libnsspem.so NSS PEM module, then specify the cert, key, and CA cert filenames as module parameters.

### Should I hash passwords in my LDIF files?

No! You must always submit a clear text password to the directory server in an ldap add or modify request.

"System" passwords like nsmultiplexorcredentials for example will be base64 encoded when viewed in the dse.ldif file.

Any entry in the dse.ldif file that contains a :: after the name is base64 encoded.

All "system" passwords will use the same level of encryption and this level is not changeable. User password encryption level can be changed in the 389-console or by using:

    ldapmodify -x -D "cn=directory manager" -w password
    dn: cn=config
    changetype: modify
    replace: passwordStorageScheme
    passwordStorageScheme: <encryption scheme here>

### What database does 389 use?

The database used is the Berkeley DB from Oracle [<http://www.oracle.com/technetwork/database/berkeleydb/overview/index.html>](http://www.oracle.com/technetwork/database/berkeleydb/overview/index.html), formerly SleepyCat (Oracle bought SleepyCat some years ago).

See the [Building](../development/building.html) page for the current version being used.

### What are some of the advantages of using multiple database back-ends?

The biggest advantage to having multiple database back-ends is the increased scalability available. With each database back-end being able to support as many entries as a single 389 deployment, this means that overall a much larger number of entries can be supported. Additional scalability can be realized with regards to data modifications; substantial performance improvement for writes, imports, exports, and deletes can occur by separating heavily utilized branches within a Directory Information Tree (DIT).

Administratively there are advantages to having multiple database back-ends. Each back-end can have a different set of indexes and cache settings. This can help with applications being used to the best of their capability. It will also allow for easier backup and maintenance of data, since you can take down a branch for restore or import without affecting other branches.

<br><a name="open-source"></a>

**Open Source**
---------------------------------------------

### What parts are open source?

Everything is now open source - the core directory server, the Admin Server, the console, the setup program, everything. The FDS 1.0 release is the first release to have completely open source components. We made good on our promise to the open source community to make available all of the desirable enterprise features.

In the previous release, just the main directory daemon, ns-slapd, its dependencies and plugins (shared libraries), and a number of command-line tools were open source.

### What License does Directory use?

See the [License](licensing.html) page for more details

### What are my rights to redistribute?

As long as you stick with the restrictions of the [License](licensing.html) there's no reason you can't redistribute this software. There are a few common modes of redistribution that we list here.

#### Distribution of the Directory Server

You should be able to do this as long as your changes are also made under the GPL.

#### Bundling with GPL software

This is also possible because the Directory Server is GPL. The 3 Apache modules are licensed under the Apache License version 2.0 and can be bundled with the rest of the directory server package for distribution. Even though the APL is considered generally incompatible with the GPL, it is ok in this specific case.

#### Bundling with Non-GPL software

One of the most common modes of distribution for the Directory Server is as a database backend for another application. You should be able to distribute the Directory Server along side your application as long as the Directory Server and your application are separate programs. Since the client libraries used to access the Directory Server are available under a somewhat more liberal license (MPL/LGPL/GPL) then you should be able to use them to access it from even a proprietary application.

However, if you make changes to the Directory Server before you distribute it with your application then you must make sure that you make those changes available under the GPL, as is required under the [license](licensing.html).

#### Bundling with extra Directory Server plugins

The Directory Server has a pretty powerful plugin api that can allow you to extend the server in interesting ways. It was our intention that people would be allowed to build plugins under any licensing they chose, and to distribute linked copies of the two, as long as they stayed within the limits of the [exception](annotated-gpl-exception-license.html).

### What are my rights to rebrand ?

You can certainly rebrand the software to fit your needs. The [licensing](licensing.html) allows this.

### Who maintains this project?

Along with [contributors](ways-to-contribute.html) from the community this project is maintained by Red Hat.

### What are the goals of this project in the future?

See our [Roadmap](roadmap.html).

### What about the other Netscape servers? (Mail, Certificate, others)

Yes, we have them. We're most interested in building a community around the Directory Server at this point. We're evaluating the other services to determine if and when we can open source them, but we don't have any timelines right now, and we're not about to speculate.

<br><a name="contrib"></a>

**Contributions**
-----------------------------------

### How do I contribute to the code base?

Firstly, please read [Contributing](../development/contributing.html). In order for the Project to accept any contributions into CVS, you will need to follow the instructions and fill out the form listed on that page.

### Why do I have to hand over the copyright in my work to Red Hat in order to contribute?

In short, so that the rights on the licensing, copyright, and patent fronts are clear. This gives us the ability to re-license the code (e.g. upgrade to GPLv3 when it is available) without having to contact all N copyright holders first (a big problem for some open source projects). Please refer to the "About the CLA" section on the [Contributing](../development/contributing.html) page for more information.

### But this gives you the ability to be evil!

We're not taking away any rights you currently have. You're just granting us the same rights to the code as you yourself have. In this respect, it's the same with most other open source projects. There are just some things the GPL doesn't cover. For the rest, you'll just have to trust us, but our intention is to Do The Right Thing.

<br><a name="building"></a>

**Building**
---------------------------------------

See the [Building](../development/building.html) page for detailed instructions.

### Failure building cyrus-sasl

If you are having problems building cyrus-sasl and receiving an error message like:

    ./plugins/sasldb.c:129: fatal error: opening dependency file .deps/../plugins/sasldb.Tpo: No such file or directory

Try installing the db4-devel package.

### Apache httpd for Admin Server

389 uses apache httpd for the Admin Server engine. This FAQ describes how to build apache httpd with the necessary configuration. Your system may already have apache installed. In that case, check your httpd as follows:

    ./httpd -l or ./httpd.worker -l

If the output contains "worker.c", your apache should be able to run with the Admin Server, which expects apache running in the worker mode.

To build apache httpd server from the scratch, you could download the source code from here (http://httpd.apache.org/download.cgi). Then, configure as follows:

    ./configure --prefix=/usr/local/apache2 --enable-mods-shared=all --with-mpm=worker --enable-deflate --enable-cache --enable-file-cache --enable-disk-cache --enable-mem-cache --enable-cgi

For the 64-bit build, you need to have 64-bit gcc environment on your system. Using the 64-bit gcc, you could run configure with 'CC=<your 64-bit>gcc CFLAGS="-m64"'.

Once Makefiles are ready, you could run:

    make
    make install

<br><a name="config"></a>

**Configuring Directory Server**
-------------------------------------------------

### Can I replace Sleepycat with Oracle, or Postgres, etc.?

There are two ways to do this. The first way is to write a Data Interoperability plug-in that intercepts LDAP operations and forwards them to the desired database. The second way is to write a Database plug-in. The first method is much easier, but it doesn't provide hooks for import/export/backup/restore/replication, which is fine for many applications where you just need to put an LDAP front-end on an existing data store. The second method is much more involved, but gives you full control over your data store through the directory server. The ldbm (no relation anymore) and the chaining database plug-ins are examples of Database plug-ins. See [Plugins](../design/plugins.html) for more information about plug-ins.

### How can I manage LDAP Schema ?

The schema is now stored as a collection of LDIF files and the schema definitions are in the format described in RFC 2252. This change means that it is now easier to use the same LDAP tools to search and modify the schema rather than having to manually edit config files. It also means that the schema can now be included with replication. So now schema changes only need to occur at a master and they will be replicated down to all the consumers. Under each server instance config directory is a schema directory. The files in this directory are loaded in numeric order. If you want to add new schema, just add the file (in RFC 2252 LDIF format) to this directory, and give it an appropriate number at the beginning. Since schema are loaded in order, the new file must be loaded *after* (i.e. have a higher number) than any schema files which define attributes or objectclasses used by the new file. Schema can also be added over LDAP by adding attributeTypes or objectClasses to the subSchemaSubEntry (which is usually cn=schema). These new schema are placed in the schema file 99user.ldif, and are made available for replication.

### Converting an OpenSSL certificate for use with Directory Server

Directory Server uses the NSS security library which stores keys and certificates in a set of small databases: cert8.db, key3.db and secmod.db.

The first step is to create an NSS certificate database. To do this with Console:

1.  Log in and select your directory instance
2.  Under Tasks, select Manage Certificates

If you don't already have a certificate database, you will be prompted to create one and assign a password to it.

If you are not prompted, this indicates that you already have one created.

If you don't have Console, it is still possible to do via the command line. The first step is to identify the name of your instance. It is a directory under /etc/dirsrv named "slapd-myinstance" where myinstance is the instance name. This naming is very important because this is how Directory Server knows which database to open.

To create the database at the command-line, run as a user with write permissions to /etc/dirsrv/slapd-myinstance

    # certutil -N -d /etc/dirsrv/slapd-myinstance

Now that we have a certificate database, what we need to do is transfer the OpenSSL certificate and key into a portable format, PKCS\#12. This file can then be imported into your NSS database.

This example assumes that the certificate and key are stored in separate files.

    # openssl pkcs12 -export -in /path/to/ssl-cert.pem -inkey \
     /path/to/ssl-key.pem -out /etc/dirsrv/slapd-myinstance/ssl-cert.p12 -name "Server-Cert"

Now you have a PKCS\#12 file in /etc/dirsrv/slapd-myinstance/ssl-cert.p12. Use an NSS utility that can import a PKCS\#12 file:

    # pk12util -i /etc/dirsrv/slapd-myinstance/ssl-cert.p12 -d /etc/dirsrv/slapd-myinstance 

See [How to setup SSL](../howto/howto-ssl.html) for more information.

<br><a name="Troubleshooting"></a>

### **Troubleshooting**

Start with /var/log/dirsrv/slapd-YOURINSTANCENAME - look for the file "errors" and "access".

Or if you are using 1.0.x or earlier, look for the logs in *<DS instance root>*/logs directory (e.g. /opt/fedora-ds/slapd-hostname/logs).

It is possible to get more debugging information by setting the error log level. The values can be added together to enable more than one log level at the same time e.g. use a value of 3 (1+2) for both trace and packet handling. You can turn logging levels on and off at runtime by using the console (Configuration-\>Logging-\>Error) or by using ldapmodify as follows:

    ldapmodify -x -D "cn=directory manager" -w password
    dn: cn=config
    changetype: modify
    replace: nsslapd-errorlog-level
    nsslapd-errorlog-level: 8192

You can omit the -x argument if you are using mozldap ldapsearch. This will set the replication log level which will dump a lot of information about replication to the error log.

After you are finished debugging the problem, you should reset the log level back to the default. To do this:

    ldapmodify -x -D "cn=directory manager" -w password
    dn: cn=config`
    changetype: modify`
    replace: nsslapd-errorlog-level`
    nsslapd-errorlog-level: 0`

NOTE: The more debug logging that is enabled, the worse the server performance will be. We do not recommend using debug logging on production machines except for a short period of time to diagnose problems. Please reset the log level back to 0 when finished with diagnosis. Fatal messages will always be logged, no matter what the log level is. The following is a table of log level values and a short description:

|Value|Description|
|-----|-----------|
|1|Trace function calls|
|2|Debug packet handling|
|4|Heavy trace output debugging|
|8|Connection management|
|16|Print out packets sent/received|
|32|Search filter processing|
|64|Config file processing|
|128|Access control list processing (very detailed!)|
|2048|Log entry parsing|
|4096|Housekeeping thread|
|8192|Replication debugging|
|16384|Critical messages|
|32768|Database cache debugging|
|65536|Plug-in debugging|
|262144|ACI summary information|

<br><a name="debug_crashes"></a>

### **Debugging Crashes**

If the server process goes away unexpectedly, it could be due to a crash. These are the steps to find out if it is a crash/core dump:

-   Install the debuginfo package
    -   Fedora

            debuginfo-install 389-ds-base

           or

            yum install --enablerepo=updates-debuginfo 389-ds-base-debuginfo

-   -   EPEL

            yum install --enablerepo=epel-debuginfo 389-ds-base-debuginfo

-   Enable core dumps in the kernel - the directory server is a setuid (suid) process which requires special handling

        sysctl -w fs.suid_dumpable=1

-   Set the core file size to unlimited - non systemd systems
    -   edit /etc/sysconfig/dirsrv
    -   add the following line:

            ulimit -c unlimited

-   restart the directory server(s)

        service dirsrv restart

-   Set the core file size to unlimited - systemd systems
    -   [Enable core files on systemd](../howto/howto-systemd.html#enablecore)
    -   edit /etc/sysconfig/dirsrv.systemd
    -   add the following line to the [Service] section

            LimitCORE=infinity

    -   refresh systemd

            systemctl daemon-reload

    -   restart directory server

            systemctl restart dirsrv.target

If the directory server crashes, the core file will be written to the log directory for the server (/var/log/dirsrv/slapd-INSTANCENAME). The core file will be named *core.PID* where *PID* is the process id of the crashed server. Use gdb to get information from the core file:

-   Install gdb

        yum install gdb

-   Generate a full stack trace using gdb

        gdb -ex 'set confirm off' -ex 'set pagination off' -ex 'thread apply all bt full' -ex 'quit' /usr/sbin/ns-slapd /var/log/dirsrv/slapd-INSTANCENAME/core.PID > stacktrace.`date +%s`.txt 2>&1

-   **EDIT the stacktrace.DATE.txt file TO REMOVE/OBSCURE ANY SENSITIVE DATA** before you submit to the mail list or attach to a bug

#### Printing Access Log Buffer

The access log is buffered. When the server crashes, the last many lines of the access log may still be in memory. This is how to print the buffered access log.

In gdb:

    (gdb) set print elements 0
    (gdb) set logging file access.buf
    (gdb) set logging on
    (gdb) p loginfo.log_access_buffer.top
    (gdb) set logging off
    (gdb) set print elements 200

Command line:

    gdb -ex 'set print elements 0' -ex 'set confirm off' -ex 'set pagination off' -ex 'print loginfo.log_access_buffer.top' -ex 'quit' /usr/sbin/ns-slapd /var/log/dirsrv/slapd-INSTANCENAME/core.PID > access.buf 2>&1

In order to make access.buf easier to read/parse, convert the newlines:

    sed -i -e 's/\\n/\n/g' access.buf

<br><a name="debug_hangs"></a>

### **Debugging Hangs**

Similar to the above, except you want to get a stack trace of the live running ns-slapd process. Follow the steps above for

-   installing gdb
-   installing debuginfo packages

You don't need to follow the steps to enable core files.

Then run gdb like this:

    gdb -ex 'set confirm off' -ex 'set pagination off' -ex 'thread apply all bt full' -ex 'quit' /usr/sbin/ns-slapd `pidof ns-slapd` > stacktrace.`date +%s`.txt 2>&1

This is better than pstack because the "bt full" will give much more detailed stack information.

### Find out which operation crashed the server

If you have a core file, see above for instructions about how to print the buffered access log.

The server access log contains the sequence of operations and results processed by the server. By default, the access log is buffered for performance reasons. Unfortunately, if the server crashes before the buffer is flushed, the information about the operation that caused the crash will not be written to the access log. You can disable access log buffering like this:

    ldapmodify -x -D "cn=directory manager" -w yourpassword <<EOF
    dn: cn=config
    changetype: modify
    replace: nsslapd-accesslog-logbuffering
    nsslapd-accesslog-logbuffering: off
 
    EOF

But this may cause the server to slow down considerably, which is not good in most production environments.  To re-enable buffering:

    ldapmodify -x -D "cn=directory manager" -w yourpassword <<EOF
    dn: cn=config
    changetype: modify
    replace: nsslapd-accesslog-logbuffering
    nsslapd-accesslog-logbuffering: on
 
    EOF

You can replace the access log with a [Named_Pipe](../howto/howto-use-named-pipe-log-script.html).  This will allow you to save the last few lines of the access log if the server crashes, without severely impacting the performance of the server.

### **Debugging Memory Growth/Invalid Access with Valgrind**

If the size of the daemon process ns-slapd keeps growing, there are 2 possibilities -- memory leak or fragmentation.

#### How to check if the memory growth is from memory leak or not ####
-   Download [ns-slapd.sh]({{ site.baseurl }}/binaries/ns-slapd.sh)
-   sudo mv /usr/sbin/ns-slapd /usr/sbin/ns-slapd.orig
-   sudo mv /path/to/downloaded/ns-slapd.sh /usr/sbin/ns-slapd
-   sudo chmod 755 /usr/sbin/ns-slapd
-   sudo systemctl restart dirsrv@YOUR_SERVER_ID.service
-   "ps -ef \| grep ns-slapd.orig" tells you the output log file location, e.g., "--log-file=/var/tmp/val/slapd.vg.449"
-   Run operations which could cause the memory growth.
-   sudo systemctl stop dirsrv@YOUR_SERVER_ID.service
-   Check the output log file.

Note that the Directory Server is not rigorous to release the basic memory structures which is necessary to run the server.
Various caches and configurations are in the category.  
Even if LEAK SUMMARY shows "definitely lost: 4,351 bytes in 125 blocks", it does not mean it is a real leak.

#### How to check if the memory growth is from fragmentation or not ####
Malloc library has a known issue that repeated malloc and free causes the memory growth that is induced by the memory fragmentation.  The typical case is when a search requires larger entry cache size, and the search is repeated, it could grow the server size until it fails to allocate more memory.  If the physical memory size allows, increasing the entry cache size large enough to store the search results, the memory growth could be avoided.

    dn: cn=userRoot,cn=ldbm database,cn=plugins,cn=config
    nsslapd-cachememsize: ENTRY_CACHE_SIZE_IN_BYTES
    nsslapd-dncachememsize: DN_CACHE_SIZE_IN_BYTES

Malloc library provides tuning parameters to reduce the memory fragmentation. 
Directory Server takes 2 environment variables SLAPD_MXFAST and MALLOC_TRIM_THRESHOLD_
corresponding to M_MXFAST and M_TRIM_THRESHOLD, respectively. (See also "man mallopt" for each parameter.)

The same set of the variables can be set via Directory Server config.

    dn: cn=config
	nsslapd-malloc-mxfast: [0..80*sizeof(size_t)/4]
	nsslapd-malloc-trim-threshold: [-1..]

Recommended values to reduce the fragmentation.  Note: it might slow down the ordinary memory management.

    dn: cn=config
	nsslapd-malloc-mxfast: 0               # [*]
	nsslapd-malloc-trim-threshold: 16384   # 16K [**]
 
    [*]   If 0, the use of fastbins is disabled.
    [**]  System default value is 128K; If low, good for memory, bad for performance; If high, good for perf, bad for memory.

### Troubleshooting Admin Server

#### Admin Server fails to start on Solaris/HP-UX

During setup or while running start-admin, you see this either from the command line or in the admin-serv/logs/error:

    [07/Jun/2005:08:33:50] info ( 2400): successful server startup
    [07/Jun/2005:08:33:50] info ( 2400): Netscape-Enterprise/6.2 B04/18/2005 12:20
    [07/Jun/2005:08:33:51] info ( 2400): Access Host filter is: *.oft-dom.nyenet
    [07/Jun/2005:08:33:51] info ( 2400): Access Address filter is: *
    [07/Jun/2005:08:33:51] failure ( 2400): Configuration initialization failed: 
      Error running init function load-modules: dlopen 
      of /ns/fedora/servers/bin/https/lib/libNSServletPlugin.so failed (ld.so.1: ns-
      httpd: fatal: libjvm.so: open failed: No such file or directory)

When you ran setup, it asked you for the location of the JRE.  Make sure you used the correct version of the JRE that setup requested, and make sure that you used a "real" directory path to the JRE and not any symlinks.  Make sure you specify the path to the JRE and not the JDK.

#### Admin Server fails to start on MP Linux kernel or on x86_64

When starting the admin server using start-admin the server seems to start but it doesn't really.

You'll see something like:

    Netscape-Enterprise/6.2 B04/18/2005 13:41
    [LS ls1] http://host.example.com, port 15000 ready to accept requests

(normally you would also get "startup: server started successfully")

The problem is in the IBM JRE. It doesn't seem to like some multi-process kernels. It has also been reported to not work on x86_64 (on FC4).

You can either switch to a uni-processor kernel or:

-   Install the Sun JDK 1.4.2_0x where x is 5 or higher. (JDK 1.5 is not tested)
-   Modify <server-root>/bin/https/bin/start-jvm and replace NSES_JRE with the location you installed the JRE (e.g. /usr/j2sdk1.4.2_06/jre/) and set NSES_JRE_RUNTIME_LIBPATH to the following:

        NSES_JRE=/usr/j2sdk1.4.2_06/jre
        NSES_JRE_RUNTIME_LIBPATH=${NSES_JRE}/lib/i386/server:${NSES_JRE}/lib/i386:${NSES_JRE}/lib/i386/classic:${NSES_JRE}/lib/i386/ native_threads; export NSES_JRE_RUNTIME_LIBPATH

-   Modify admin-serv/config/jvm12.conf to look like this:

        [JVMConfig]
        jvm.option=-Xrs -server

Now your admin server should start.

### Troubleshooting Admin Console

#### Exception in thread "main" java.lang.ExceptionInInitializerError

If you get an error like this:

    # ./startconsole 
    Exception in thread "main" java.lang.ExceptionInInitializerError
            at
    com.sun.java.swing.plaf.windows.WindowsLookAndFeel.initialize(WindowsLookAndFeel.java:154
            at com.netscape.management.nmclf.SuiLookAndFeel.initialize(Unknown Source)
            at javax.swing.UIManager.setLookAndFeel(UIManager.java:424)
            at com.netscape.management.client.console.Console.common_init(Unknown Source)
            at com.netscape.management.client.console.Console.<init>(Unknown Source)
            at com.netscape.management.client.console.Console.main(Unknown Source)
    Caused by: java.lang.NullPointerException
            at java.lang.ClassLoader.loadLibrary0(ClassLoader.java:2159)
            at java.lang.ClassLoader.loadLibrary(ClassLoader.java:1994)
            at java.lang.Runtime.loadLibrary0(Runtime.java:824)
            at java.lang.System.loadLibrary(System.java:908)
            at sun.security.action.LoadLibraryAction.run(LoadLibraryAction.java:76)
            at java.security.AccessController.doPrivileged1(Native Method)
            at java.security.AccessController.doPrivileged(AccessController.java:287)
            at java.awt.Toolkit.loadLibraries(Toolkit.java:1488)
            at java.awt.Toolkit.<clinit>(Toolkit.java:1511)
            ... 6 more

Make sure that you have the `xorg-x11-deprecated-libs` [RHEL4] or libXp [RHEL5] package installed. For more info, see [the bug](https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=159384).

#### Exception in thread "main" java.lang.NoClassDefFoundError: com/netscape/management/client/console/Console

If you get this java exception while trying to start the console, it is very likely that either: - You do not have the correct expected java version for the console, like for example, jre 1.5 for fds 1.0.4 on FC6 (see the software requirements) - or you do not start properly the console, make sure you do not use an absolute path to the startconsole script:

    cd /opt/fedora-ds/
    ./startconsole

Do not do this:

    /opt/fedora-ds/startconsole

#### Syntax error near unexpected token \`('

This means your DNS/NSS host/domain lookup is not configured correctly, or you did not use the correct Fully Qualified Domain Name (FQDN) during setup. In the meantime, until you can figure out what happened, you can use the -a switch to startconsole e.g. if 7101 is the port number of your Admin Server, use this:

    ./startconsole -a http://localhost:7101/

<br>

<a name="operation"></a>**Operating Directory Server**
----------------------------------------------------------

### I have the server, now what?

Here's what you can do with the Directory Server...

-   Authenticate users in your Apache, Sun or Netscape Web servers (and likely others as well).
-   Store employee information centrally for phonebook and organization chart lookups.
-   Sync passwords with your NT domain controller.
-   Sync passwords with Active Directory.

### How do I use the Administration Server/Console with this?

After installing the full 389-ds package, including 389-ds-base, 389-admin, etc., run the **setup-ds-admin.pl** command (if upgrading from a previous release, run **setup-ds-admin.pl -u**). This will set up your initial directory server instance, admin server, and configure them both to use the console. Then run the **389-console** command.

For running console on Windows, see [How to run console on Windows](../howto/howto-windowsconsole.html)

For accepted console command line arguments, read the console sources (search for "void main("):

[<http://git.fedorahosted.org/git/?p=idm-console-framework.git;a=blob;f=src/com/netscape/management/client/console/Console.java;hb=HEAD>](http://git.fedorahosted.org/git/?p=idm-console-framework.git;a=blob;f=src/com/netscape/management/client/console/Console.java;hb=HEAD)

#### Useful undocumented (yet) arguments:

Supply initial username:

    -u user

Supply user's password (warning: will show up in process table!):

    -w password

Read password from stdin:

    -w -

Read password from file:

    -y pwfile

### Write a lib389 test script

Check out [How to Write Upstream Test](../howto/howto-write-lib389.html)
Y
