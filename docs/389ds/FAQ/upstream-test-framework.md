---
title: "Upstream Testing Framework"
---

# 389 Upstream Testing Framework
--------------------------------

{% include toc.md %}

#### **Overview**

Currently Red Hat Directory Server is tested using TET framework and tests. This framework and its tests have been enhanced for years and offers a high level of QE.  For example, the *acceptance* suite runs thousands of tests, and is convenient to detect regressions. A drawback is the complexity of the tests and the TET framework.  It is some what difficult to setup and run.  Also, diagnosis of a failure is difficult, and requires expertise to conclude if a failure is due to a Directory Server bug, a invalid test case, a bug in the framework, or an environment issue.

Part of a Continuous Integration project, *389 upstream testing* is an effort to push and maintain the testing capability in the upstream 389 repository.

This document will describe the following components

-   **lib389 framework**  used to do Directory Server administrative tasks (Create servers, setup replication, import LDIF files, etc)
-   **Upstream tests (layout, methods...)**  uses the lib389 framework to create individual test cases
-   **py.test test framework**  used to run the 389 upstream tests
-   **Integration into jenkins**

#### **Use case**

-   A community developer who introduces a new feature in 389 Directory Server, will be able to enhance the administrative part of this feature in lib389.
-   A community developer who wants to test a bug fix or an enhancement, will deploy Directory Server, and launch test(s) to verify the enhancement does not cause any regressions.
-   A community developer who wants better test coverage, will develop/enhance a new test of test suite.
-   *389 Dev Team* writes test cases for each new enhancement and fixed tickets.  Community members are encouraged to do the same.

<br>

<a name="prereq"></a>

Prerequisites
----------------------------------

### minimal version

-   **Fedora 19** and up is highly recommended so that the version of python and py.test are correct.
-   Python version should be **2.6.6** or later.
-   If you launch tests with **py.test**, the minimal version is **2.3** or later. 
    
        yum install pytest

### Environment

You need to

-   Run the tests as *NON* root user and use the same userID that the one who deployed the directory server (see below)
-   Before launching the tests you need to check that **localhost.localdomain** is the first hostname in */etc/hosts*. The scripts checks that **localhost.localdomain** \<--\> IPaddress. A limitation in **setup-ds.pl** and **setup-ds-admin.pl** require the following setting:

        # cat /etc/hosts
        127.0.0.1   localhost.localdomain localhost localhost4 localhost4.localdomain4
        ::1         localhost.localdomain localhost localhost6 localhost6.localdomain6
        ...

-   You need to install python-ldap and pytest

        yum install python-ldap pytest

<br>

<a name="setup"></a>

Basic Setup and Testing
===========================================

The following describes how to setup a testing environment, and run a specific test

-   Deploy DS under a specific root
-   Run a specific test using python
-   Run a specific test using Eclipse IDE

### <a name="specific-dir"></a>Deploy 389 Directory Server under specific directory

The following setup script allows you to checkout/compile and deploy the current version of 389 Directory Server under a specific directory.  The path used for *DIR\_INSTALL* will be used throughout the rest of the setup and testing process (*installation_prefix*, etc)/

**Setup Script**

    #!/bin/bash
    PREFIX=${1:-}
    DIR_SRC=$HOME/workspaces
    DIR_DS_GIT=389-ds-base
    DIR_SPEC_GIT=389-ds-base-spec
    DIR_RPM=$HOME/rpmbuild
    DIR_INSTALL=$HOME/install   # a.k.a /directory/where/389-ds/is/installed
    DIR_SRC_DIR=$DIR_SRC/$DIR_DS_GIT
    DIR_SRC_PKG=$DIR_SRC/$DIR_SPEC_GIT
    TMP=/tmp/tempo$$
    SED_SCRIPT=/tmp/script$$
    
    #
    # Checkout the source/spec
    #
    initialize()
    {
       for i in $DIR_DS_GIT $DIR_SPEC_GIT
       do
           rm -rf $DIR_SRC/$i
           mkdir $DIR_SRC/$i
       done
       cd $DIR_SRC_DIR
       git clone git://git.fedorahosted.org/git/389/ds.git
       cd $DIR_SRC_PKG
       git clone git://pkgs.fedoraproject.org/389-ds-base
    }
    #
    # Compile 389-DS
    #
    compile()
    {
       cd $DIR_SRC_PKG
       cp $DIR_SRC_PKG/389-ds-base.spec     $DIR_RPM/SPECS
       cp $DIR_SRC_PKG/389-ds-base-git.sh   $DIR_RPM/SOURCES
       cp $DIR_SRC_PKG/389-ds-base-devel.README $DIR_RPM/SOURCES
       cd $DIR_SRC_DIR
       rm -f /tmp/*bz2
       TAG=HEAD sh $DIR_SRC_PKG/389-ds-base-git-local.sh /tmp
       SRC_BZ2=`ls -rt /tmp/*bz2 | tail -1`
       echo "Copy $SRC_BZ2"
       cp $SRC_BZ2 $DIR_RPM/SOURCES
       if [ -n "$PREFIX" -a -d $PREFIX ]
       then
           TARGET="--prefix=$PREFIX"
       else
           TARGET=""
       fi
       echo "Active the debug compilation"
       echo "Compilation start"
           CFLAGS='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -grecord-gcc-switches -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -m64 -mtune=generic'
           CXXFLAGS=$CFLAGS
       sed -e 's/^\%configure/CFLAGS="$CFLAGS" CXXFLAGS="$CXXFLAGS" \%configure/' $DIR_RPM/SPECS/389-ds-base.spec > $DIR_RPM/SPECS/389-ds-base.spec.new
       cp $DIR_RPM/SPECS/389-ds-base.spec.new $DIR_RPM/SPECS/389-ds-base.spec
       sleep 3
       rpmbuild -ba $DIR_RPM/SPECS/389-ds-base.spec 2>&1 | tee $DIR_RPM/build.output
    }
    #
    # Install it on a private directory $HOME/install
    #
    install()
    {
       cd $DIR_SRC_DIR
       CFLAGS="-g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic -Wextra -Wno-unused-parameter -Wno-missing-field-initializers -Wno-sign-compare"
       CXXFLAGS="$CFLAGS" $DIR_SRC_DIR/ds/configure --prefix=$DIR_INSTALL --enable-debug --with-openldap 2>&1 > $DIR_RPM/BUILD/build_install.output
       echo "Now install dirsrv"   >> $DIR_RPM/BUILD/build_install.output
       make install 2>&1           >> $DIR_RPM/BUILD/build_install.output
    }
    if [ ! -d $HOME/.dirsrv ]
    then
         mkdir ~/.dirsrv # this is where the instance specific sysconfig files go - dirsrv-instancename
    fi
    # note: compile is not necessary to deploy
    initialize
    install

For information with that kind of deployment you can run usual administrative Directory Server commands. For example:

    cd $DIR_INSTALL
    sbin/setup-ds.pl
    sbin/restart-dirsrv
    sbin/ldif2db
    bin/logconv.pl var/log/dirsrv/slapd-inst/access
    bin/dbscan -f var/lib/dirsrv/slapd-inst/db/userRoot/id2entry.db4
    etc.

The [Lib389 Library](#lib389) provides interfaces to do all administrative tasks .

<br><a name="test"></a>

### Run a specific test using python

Open the tests you want to run (e.g. ticketxyz\_test.py)

-   Comment out the pytest fixture in the test script. Search the string 'pytest.fixture(scope="module")' and comment it.
-   At the end of the file in 'run\_isolated()' replace 'installation\_prefix = None' with 'installation\_prefix = */directory/where/389-ds/is/installed*', aka DIR_INSTALL value.
-   Save and run the following script

     **Test Script**

        #!/bin/bash    
        DIR=$HOME/test    
        TEST=ticketxyz_test.py    
        mkdir $DIR    
        # checkout tests and lib389    
        cd $DIR    
        git clone git://git.fedorahosted.org/git/389/ds.git
        git clone git://git.fedorahosted.org/git/389/lib389.git
        # define PYTHONPATH    
        export PYTHONPATH=/usr/lib64/python2.7:/usr/lib64/python2.7/plat-linux2:/usr/lib64/python2.7/lib-dynload:/usr/lib64/python2.7/site-packages:/usr/lib/python2.7/site-packages:/usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info    
        LIB389=$DIR/lib389    
        PROJECT=$DIR/ds/dirsrvtests    
        DIR_PREFIX=/directory/where/389-ds/is/installed    --> this would be DIR_INSTALL($HOME/install) from the setup script    
        export PYTHONPATH=$PYTHONPATH:$PROJECT:$LIB389    
        PREFIX=$DIR_PREFIX python -v $PROJECT/tickets/$TEST    

-   For example if you already cloned Directory Server and lib389 you may want to give a try running an existing testcase like the one for ticket 47560

        #!/bin/ksh    
        export PYTHONPATH=/home/<your_login>/workspaces/tests-389/framework/lib389:/home/<your_login>/workspaces/389-master-branch/ds/dirsrvtests/tickets    
        echo "diff /tmp/ticket47560_test.py /home/<your_login>/workspaces/389-master-branch/ds/dirsrvtests/tickets/ticket47560_test.py"    
        diff /tmp/ticket47560_test.py /home/<your_login>/workspaces/389-master-branch/ds/dirsrvtests/tickets/ticket47560_test.py    
        python /tmp/ticket47560_test.py    

    You can see that the launched test case is under /tmp/ticket47560\_test.py, this is because you need to modify it slightly for *fixture* and *prefix*. The output of the diff is

        diff /tmp/ticket47560_test.py /home/<your_login>/workspaces/389-master-branch/ds/dirsrvtests/tickets/ticket47560_test.py    
        26c26    
        < #@pytest.fixture(scope="module")    
        ---    
        > @pytest.fixture(scope="module")    
        296c296    
        <     installation_prefix =  '/home/<your_login>/install'    
        ---    
        >     installation_prefix =  None


So **/home/\<your_login\>/install**, aka "installation prefix", aka DIR_INSTALL, is a target directory where we deployed a build [see](#specific-dir), you may define this directory with **\$PREFIX** environment variable, or like in this example force it directly into the test case.

Both method are valid, but it has some interest to set it directly into the test case if you want to run a multi-version test-case. Like in test ticket47788 where two variables *installation1\_prefix* and *installation2\_prefix* allow you to create the instance in different versions

### Run a specific test using eclipse IDE

#### Prerequisite

-   Install eclipse <http://www.eclipse.org>

        yum install eclipse-platform
        yum search eclipse --> will show many useful plugins

-   Install **pydev** <http://pydev.org/index.html> . In eclipse in Menu *help*, *Install New Software...*. In *work with* enter *<http://pydev.org/updates>* then click on *Add*.
-   select interpreter, *windows*, *Preferences*, *PyDev*, *Interpreter python*, *New*, choose ''/bin/pythonx.y' (e.g. /bin/python2.7)
-   Then do the following steps

    cd $HOME/test
    mkdir 389-ds
    mkdir lib389
    cd $HOME/test/389-ds
    git clone ssh://git.fedorahosted.org/git/389/ds.git
    cd $HOME/test/lib389
    git clone ssh://git.fedorahosted.org/git/389/lib389.git
    launch eclipse... 
    -> in 'select workspace' entry $HOME/test
    -> File->New->Project selects PyDev Project
    -> Project name 'lib389' (Directory will be $HOME/test/lib389/lib389)
    -> File->New->Project selects PyDev Project
    -> Project name 'dirsrvtest' (Directory will be $HOME/test/389-ds/ds/dirsrvtests
      'Referenced projects' selects lib389

#### Run a dedicated test

Open the tests you want to run 'dirsrvtest-\>tickets-\>ticket47490\_test.py'

-   add/check that the pytest fixture is commented. Search the string 'pytest.fixture(scope="module")' and comment it. Running under eclipse, it does not use py.test framework, so this fixture is not recognized.
-   At the end of the file in 'run\_isolated()' replace 'installation\_prefix = None' with 'installation\_prefix = */directory/where/389-ds/is/installed*'
-   save and run ('Python Run')

### Run a specific test under py.test

Run the following script. If you need more detail on tests processing, uncomment 'DEBUG=-s'

    #!/bin/bash
    DIR=$HOME/test
    TEST=ticketxyz_test.py
    mkdir $DIR
    # checkout tests and lib389
    cd $DIR
    git clone git://git.fedorahosted.org/git/389/ds.git
    git clone git://git.fedorahosted.org/git/389/lib389.git
    # define PYTHONPATH
    export PYTHONPATH=/usr/lib64/python2.7:/usr/lib64/python2.7/plat-linux2:/usr/lib64/python2.7/lib-dynload:/usr/lib64/python2.7/site-packages:/usr/lib/python2.7/site-packages:/usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info
    LIB389=$DIR/lib389
    PROJECT=$DIR/ds/dirsrvtests
    DIR_PREFIX=/directory/where/389-ds/is/installed    --> DIR_INSTALL($HOME/install) from the setup script
    export PYTHONPATH=$PYTHONPATH:$PROJECT:$LIB389
    #DEBUG=-s
    PREFIX=$DIR_PREFIX py.test -v $DEBUG $PROJECT/tickets/$TEST

### Directory Server deployed with RPM

For the moment, it is not recommended to run the test with this type of deployment because:

-   It has not been fully tested with this type of deployment
-   It requires to be logged in as **root**

<br><a name="lib389"></a>

lib389 Library 
===================================

### Overview

lib389 is a python based library, that offers services to do administrative tasks for Directory Server. This library is intended to be used to develop 389 upstream tests and to develop 389 administrative CLI.

The library is based on early version of <https://github.com/richm/dsadmin>

<a name="design"></a>

lib389 Design
-------------

### Repos

This library is opened source and is available under <https://git.fedorahosted.org/cgit/389/lib389.git/>

### Methodology

The development methodology for the lib389 will follow the same development methodology as 389 Directory Server. The main aspects are described [here](../development/git-rules.html).

### Layout

    lib389/

      __init__.py       # implements routines to do online administrative tasks      
      _replication.py   # implements replication related class (CSN/RUV) 
      _constants.py     # main definitions (Directory manager, replica type, DNs for config...) 
      _entry.py         # implements LDAP 'Entry' and methods  
      _ldif_conn.py     # subclass of LDIFParser. Used to translate a ldif entry (from dse.ldif for example) into an 'Entry'
      agent.py          # implements routines to do remote offline administrative tasks
      agreement.py      # implements replica agreement services
      backend.py        # implements backend services
      brooker.py        # Brooker classes to organize ldap methods
      chaining.py       # implements chaining backend services 
      changelog.py      # implements the replication changelog
      index.py          # implements index services 
      logs.py           # implements logging services 
      mappingTree.py    # implements mapping tree services
      plugins.py        # implements plugin operations(enable/disable)
      properties.py     # Various property helper short cut names 
      replica.py        # implements replica services
      schema.py         # implements schema operations
      suffix.py         # implements suffix services (a wrapper around mapping tree)
      tasks.py          # implements task services 
      tools.py          # implements routines to do local offline administrative tasks  
      utils.py          # implements miscellaneous routines 

    test/
        config_test.py
            It contains tests for:
              - replica
              - backend
              - suffix
        dsadmin_basic_test.py
            It contains tests for:
              - changelog
              - log level
              - mapping tree
              - misc (bind)
        dsadmin_create_remove_test.py
            - instance creation
            - instance deletion
        dsadmin_test
            - replica
            - backend
            - start/stop instance
            - ssl
            - replica agreement
        replica_test
            - test various replication objects (changelog, replica, replica agreement, ruv)
        backend_test
            - backend

<br>
<a name="modules"></a>

Modules
-----------------------------

<a name="dirsrv"></a>

### DirSrv (\_\_init\_\_.py)
----------------------------

#### **DirSrv state**

A DirSrv Object can have the following states: ALLOCATED/OFFLINE/ONLINE.

The graphic below describes the transitions after the various operations.

                                 __ (create)__           ___(open)___      __
                                /             \         /  (start)   \    /  \
                               /               V       /              V  /    \
      --(allocate)--> ALLOCATED                 OFFLINE             ONLINE   (all lib389 ops + LDAP(S) ops)
                              ^               /       ^              /  ^    /
                               \___(delete)__/         \___(close)__/    \__/
                                                        (stop/restart)
                                                       (backup/restore)

The online administrative tasks (ldap operations) require that DirSrv is ONLINE. The offline administrative tasks can be issued whether DirSrv is ONLINE or OFFLINE

#### **allocate(args)**

Initialize a DirSrv object according to the provided args dictionary. The state change from DIRSRV\_STATE\_INIT -\> DIRSRV\_STATE\_ALLOCATED. This step is mandatory before calling the others methods of this class.

args contains the following properties of the server. (mandatory properties are in **bold**)

-   **SER_SERVERID_PROP**: server id of the instance -> slapd-<serverid>
-   SER_HOST: hostname [LOCALHOST]
-   SER_PORT: normal ldap port [DEFAULT_PORT]
-   SER_SECURE_PORT: secure ldap port
-   SER_ROOT_DN: root DN [DN_DM]
-   SER_ROOT_PW: password of root DN [PW_DM]
-   SER_USER_ID: user id of the create instance [DEFAULT_USER]
-   SER_GROUP_ID: group id of the create instance [SER_USER_ID]
-   SER_DEPLOYED_DIR: directory where 389-ds is deployed [None]
-   SER_BACKUP_INST_DIR: directory where instances will be backup [/tmp]

The instance will be localized under **SER\_DEPLOYED\_DIR**.. If **SER\_DEPLOYED\_DIR** is not specified, the instance will be stored under **/**.

If **SER_USER_ID** is not specified, the instance will run with the caller user id. If caller is 'root', it will run as 'DEFAULT\_USER' user

If **SER_GROUP_ID** is not specified, the instance will run with the caller group id. If caller is 'root', it will run as 'DEFAULT\_USER' group

-   **@param** args - dictionary that contains the DirSrv properties
-   **@return** None
-   **@raise** ValueError - if missing mandatory properties or invalid state of DirSrv

<br>

#### **exists()**

If the instance exists it returns True else it returns False

-   **@param** None
-   **@return** True or False
-   **@raise** None

<br>

#### **list([all])**

Returns a list dictionary. For a created instance that is on the local file system (e.g. <prefix>/etc/dirsrv/slapd-\*), it exists a file describing its properties (environment)

    <prefix>/etc/sysconfig/dirsrv-<serverid>
    or
    $HOME/.dirsrv/dirsrv-<serverid>

A dictionary is created with the following properties:

-   CONF\_SERVER\_DIR
-   CONF\_SERVERBIN\_DIR
-   CONF\_CONFIG\_DIR
-   CONF\_INST\_DIR
-   CONF\_RUN\_DIR
-   CONF\_DS\_ROOT
-   CONF\_PRODUCT\_NAME

If all=True it builds a list of dictionary for all created instances. Else (default), the list will only contain the dictionary of the calling instance

-   **@param** all - True or False . default is [False]
-   **@return** list of dictionaries, each of them containing instance properties
-   **@raise** IOError - if the file containing the properties is not searchable or readable

<br>

#### **create()**

Creates an instance with the parameters sets in **dirsrv** (see *allocate*). DirSrv state must be DIRSRV\_STATE\_ALLOCATED before calling this function. Its final state will be DIRSRV\_STATE\_OFFLINE

-   **@param** None
-   **@return** None
-   **@raise** ValueError - if it exist an instance with the same 'serverid'

<br>

#### **delete()**

Deletes the instance with the parameters sets in **dirsrv** (see *allocate*). If the instance does not exist it raise TBD.

-   **@param** None
-   **@return** a DirSrv object state=ALLOCATED
-   **@raise** TBD

<br>

#### **open()**

It opens a ldap connection to **dirsrv** so that online administrative tasks are possible

-   **@param** None 
-   **@return** a DirSrv object state=ONLINE
-   **@raise** TBD

<br>

#### **close(None)**

It closes the ldap connection to **dirsrv**. Online administrative tasks are no longer possible upon completion.

-   **@param** None
-   **@return** a DirSrv object state=OFFLINE
-   **@raise** TBD

<br>

#### **start([timeout])**

It starts the instance **dirsrv**. If the instance is already running, it does nothing.

-   **@param** timeout - delay (in sec) it waits for *slapd started* string in error logs
-   **@return** a DirSrv object. If start completed, state=ONLINE
-   **@raise** TBD

<br>

#### **stop([timeout])**

It stops the instance **dirsrv**. If the instance is already stopped, it does nothing.

-   **@param** timeout - delay (in sec) it waits for *slapd stopped* string in error logs
-   **@return** a DirSrv object. state=OFFLINE
-   **@raise** TBD

<br>

#### **restart([timeout])**

It restarts the instance **dirsrv**. If the instance is already stopped, it just starts it.

-   **@param** timeout - delay (in sec) it waits for *slapd stopped* then *slapd started* strings in error logs
-   **@return** a DirSrv object. If start completed, state=ONLINE
-   **@raise** TBD

<br>

#### **getDir()**

Get the full system path to the local *data* directory(ds/dirsrvtests/data)
-   **@param** None
-   **@return** Full path to the testing *data* directory
-   **@raise** ValueError

#### **clearTmpDir(\_\_file\_\_)**

Removes all the files from the */tmp* dir (ds/dirsrvtest/tmp/).  This should be in the setup phase of the test script.

-   **@param** "__file" is the only valid value
-   **@return** nothing

<br>

#### **getEntry(base, scope, filter, [attrlist])**

Wrapper around SimpleLDAPObject.search. It is common to just get one entry.

-   **@param** base - entry dn
-   **@param** scope - search scope, in ldap.SCOPE_BASE (default), ldap.SCOPE_SUB, ldap.SCOPE_ONE
-   **@param** filterstr - filterstr, default '(objectClass=*)' from SimpleLDAPObject
-   **@param** attrlist - list of attributes to retrieve. eg ['cn', 'uid']
-   **@param** attrsonly - default None from SimpleLDAPObject
-   **@return** entry that is result of SimpleLDAPObject.search
-   **@raise** NoSuchEntryError if 'base' is not a valid entry

<br>

#### **getProperties([properties])**

Returns a dictionary of properties of the server. If no property are specified, it returns all the properties

-   **@param** properties - list of properties

Supported properties are:

|**Property name** | **server attribute name**|
|------------------|--------------------------|
|pid|N/A|
|port|nsslapd-port|
|sport|nsslapd-secureport|
|version|TBD|
|owner|user/group id|
|db-*|DB related properties (cache, checkpoint, txn batch...) TBD|
|db-stats|statistics from: <br>cn=database,cn=monitor,cn=ldbm database,cn=plugins,cn=config<br>cn=monitor,cn=ldbm database,cn=plugins,cn=config|
|conn-*|Connection related properties (idle, ioblock, thread/conn, max bersize) TBD|
|pwd-*|Password policy properties (retry, lock,...)|
|security-*|Security properties (ciphers, client/server auth., )|

<br>

#### **setProperties(properties)**

TBD

<br>

#### **checkBackupFS()**

Return the file name of the backup file. If it does not exist it returns None

-   **@param** None
-   **@return** file name of the first backup. None if there is no backup
-   **@raise** None

<br>

#### **backupFS()**

It creates a full instance backup file under /tmp/slapd-<instance_name>.bck/backup\_HHMMSS.tar.gz and return the archive file name.

The backups are stored under **BACKUPDIR** environment variable (by default **/tmp**).

If it already exists a such file, it assumes it is a valid backup and returns its name. Instance 'dirsrv' must be stopped prior the call, else backup file may be corrupted

-   self.sroot : root of the instance  (e.g. /usr/lib64/dirsrv)
-   self.inst  : instance name (e.g. standalone for /etc/dirsrv/slapd-standalone)
-   self.confdir : root of the instance config (e.g. /etc/dirsrv)
-   self.dbdir: directory where is stored the database (e.g. /var/lib/dirsrv/slapd-standalone/db)
-   self.changelogdir: directory where is stored the changelog (e.g. /var/lib/dirsrv/slapd-master/changelogdb)

-   **@param** None
-   **@return** file name of the backup
-   **@raise** none

<br>

#### **restoreFS()**

Restore a directory from a backup file

-   **@param** backup_file - file name of the backup
-   **@return** None
-   **@raise** ValueError - if backup_file invalid file name

<br>

#### **clearBackupFS(backup_file)**

Remove a backup\_file or all backup up of a given instance

-   **@param backup_file** - optional
-   **@return** None
-   **@raise** None

<br>
<a name="replica"></a>

### Replica
---------------------------------

#### **create\_repl\_manager([repl\_manager\_dn], [repl\_manager\_pw])**

Create an entry that will be used to bind as replica manager. The entry properties will be no idletime (nsIdletimeout=0) and long time for password expiration (passwordExpirationTime).

-   **@param** repl_manager_dn - DN of the bind entry. Default is REPLICATION_BIND_DN in _constants.py
-   **@param** repl_manager_pw - Password of the entry. Default is REPLICATION_BIND_PWD in _constants.py
-   **@raise** KeyError - if can not find valid values of Bind DN and/or Pwd
-   **@raise** MissingEntryError - if fail to retrieve the entry after creation

Example:

    create_repl_manager()

    dn: cn=replrepl,cn=config
    cn: bind dn pseudo user
    cn: replrepl
    objectClass: top
    objectClass: person
    passwordExpirationTime: 20381010000000Z
    sn: bind dn pseudo user
    nsIdleTimeout: 0
    userPassword:: e1NTSEF9aGxLRFptSVY2cXlvRmV0S0ZCOS84cFBNY1RaeXFkV
     DZzNXRFQlE9PQ==
    creatorsName: cn=directory manager
    modifiersName: cn=directory manager
    modifyTimestamp: 20131121131644Z

<br>

#### **changelog([dbname])**

Adds the replication changelog entry (**cn=changelog5,cn=config**), if it does not already exist. Then it returns the entry. This entry specifies the directory where the changelog's database file will be stored. The directory name is in the attribute **nsslapd-changelogdir**.

If 'changelog()' was called when configuring the first supplier replica. It is not necessary to call it again when configuring the others (if any) supplier replicas, unless we want their changelog to go to an other directory.

-   **@param dbname** - This the basename of the directory where to store the changelog's database file. Default is 'changelogdb'
-   **@return changelog entry** (**cn=changelog5,cn=config**)

Example:

    self.master.replica.changelog()

    dn: cn=changelog5,cn=config
    objectClass: top
    objectClass: extensibleobject
    cn: changelog5
    nsslapd-changelogdir: \<install\>/var/lib/dirsrv/slapd-master/changelogdb

<br>

#### **list([suffix], [replica\_dn])**

Lists and returns the replicas under the mapping tree (*cn=mapping tree,cn=config*). If 'suffix' is provided, it returns the replica (in a list of entry) that is configured for that 'suffix'. If 'replica\_dn' is specified it returns the replica with that DN.

If 'suffix' and 'replica\_dn' are specified, it uses 'replica\_dn'.

-   **@param** suffix - if suffix is None, return all replicas
-   **@param** replica_dn - if suffix is None, return all replicas
-   **@returns** a list of replica entries

Example:

    self.replica.list()

    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    cn: replica
    nsDS5Flags: 1
    objectClass: top
    objectClass: nsds5replica
    objectClass: extensibleobject
    nsDS5ReplicaType: 3
    nsDS5ReplicaRoot: dc=example,dc=com
    nsds5ReplicaLegacyConsumer: off
    nsDS5ReplicaId: 1
    nsDS5ReplicaBindDN: cn=replrepl,cn=config
    nsState:: AQAAAAAAAABcCo5SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    nsDS5ReplicaName: 284aec0a-52af11e3-91fd8ff3-240cb6d3
    nsds5ReplicaChangeCount: 11
    nsds5replicareapactive: 0
    dn: cn=replica,cn=dc\3Dredhat\2Cdc\3Dcom,cn=mapping tree,cn=config
    cn: replica
    nsDS5Flags: 1
    objectClass: top
    objectClass: nsds5replica
    objectClass: extensibleobject
    nsDS5ReplicaType: 3
    nsDS5ReplicaRoot: dc=redhat,dc=com
    nsds5ReplicaLegacyConsumer: off
    nsDS5ReplicaId: 1
    nsDS5ReplicaBindDN: cn=replrepl,cn=config
    nsState:: AQAAAAAAAABcCo5SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    nsDS5ReplicaName: 284aec0a-52af11e3-91fd8ff3-3d6bc042
    nsds5ReplicaChangeCount: 11
    nsds5replicareapactive: 0

or

    self.replica.list('dc=example,dc=com')

    dn: cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config
    cn: replica
    nsDS5Flags: 1
    objectClass: top
    objectClass: nsds5replica
    objectClass: extensibleobject
    nsDS5ReplicaType: 3
    nsDS5ReplicaRoot: dc=example,dc=com
    nsds5ReplicaLegacyConsumer: off
    nsDS5ReplicaId: 1
    nsDS5ReplicaBindDN: cn=replrepl,cn=config
    nsState:: AQAAAAAAAABcCo5SAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==
    nsDS5ReplicaName: 284aec0a-52af11e3-91fd8ff3-240cb6d3
    nsds5ReplicaChangeCount: 11
    nsds5replicareapactive: 0

<br>

#### **create(suffix, role, [rid], [args])**

Create a replica entry on an existing suffix.

-   **@param** suffix - dn of suffix
-   **@param** role - role of the replica REPLICAROLE_MASTER, REPLICAROLE_HUB or REPLICAROLE_CONSUMER
-   **@param** rid - number that identify the supplier replica (role=REPLICAROLE_MASTER) in the topology. For hub/consumer (role=REPLICAROLE_HUB or REPLICAROLE_CONSUMER), rid value is not used. This parameter is mandatory for supplier.
-   **@param** args      - further args dict optional values. Allowed keys:
    -   legacy
    -   binddn
    -   referral
    -   purge-delay
    -   purge-interval

-   **@return** None
-   **@raise** ValueError - if role in invalid

<br>

#### **delete(suffix)**

Delete a replica related to the provided suffix. If this replica role was REPLICAROLE\_HUB or REPLICAROLE\_CONSUMER, it also deletes the changelog associated to that replica. If it exists some replication agreement below that replica, they are deleted.

-   **@param** suffix - dn of suffix
-   **@return** None
-   **@raise** ValueError - if the suffix has no replica

<br>

#### **enableReplication(suffix, role, [replicaId], [binddn])**

Enable replication for a given suffix. If the role is REPLICAROLE\_MASTER or REPLICAROLE\_HUB, it also creates the changelog. If the entry "cn=replrepl,cn=config" (default replication manager) does not exist, it creates it.

-   **@param** suffix - dn of suffix
-   **@param** role - role of the replica REPLICAROLE_MASTER, REPLICAROLE_HUB or REPLICAROLE_CONSUMER
-   **@param** rid - number that identify the supplier replica (role=REPLICAROLE_MASTER) in the topology. For hub/consumer (role=REPLICAROLE_HUB or REPLICAROLE_CONSUMER), rid value is not used. This parameter is mandatory for supplier.
-   **@param** binddn - A replication session needs to bind with this DN to send replication updates
-   **@return** None
-   **@raise** ValueError - if role in invalid

<br>

#### **disableReplication(suffix)**

This is a wrapper of the 'delete' function. See delete function.

-   **@param** suffix - dn of suffix
-   **@return** None
-   **@raise** ValueError - if suffix is not a replica

<br>

#### **getProperties([suffix], [replica\_dn], [replica\_entry], [properties])**

Returns a dictionary containing the requested properties value of the replica. If 'properties' is missing it returns all the supported properties

At least one parameter suffix/replica\_dn/replica\_entry needs to be specified It uses first (if specified) 'replica\_entry', then 'replica\_dn', then 'suffix'

-   **@param** - suffix - suffix of the replica
-   **@param** - replica_dn - DN of the replica entry
-   **@param** - replica_entry - LDAP entry of the replica
-   **@param** - properties - dictionary of \<prop\>:\<value\> with the following supported values
-   **@return** - dictionary of the properties
-   **@raise** - InvalidParameter

Supported properties are:

|**Property name** |**Replica attribute name** |
|------------------|---------------------------|
|legacy|nsds5replicalegacyconsumer [ *off* ]|
|binddn|nsds5replicabinddn' [ *REPLICATION_BIND_DN in constants.py* ]|
|referral|nsds5ReplicaReferral|
|purge-delay|nsds5ReplicaPurgeDelay|
|purge-interval|nsds5replicatombstonepurgeinterval|

<br>

#### **setProperties([suffix], [replica\_dn], [replica\_entry], properties)**

set properties defined in 'properties' in the the replica entry with the corresponding RHDS attribute name.

Some properties have default value, described in italic below

The property name, may be prefixed in order to specify the operation:

-   **+**\<*propname*\>: \<*value*\> =\> MOD/ADD \<value\>
-   **-**\<*propname*\>: \<*value*\> =\> MOD/DEL \<value\>
-   \<*propname*\>: \<*value*\> =\> MOD/REPLACE \<value\>. If \<*value*\> = **""**, then the related attribute is deleted (MOD/DEL).

-   **@param** - suffix - suffix of the replica
-   **@param** - replica_dn - DN of the replica entry
-   **@param** - replica_entry - LDAP entry of the replica
-   **@param** - properties - dictionary of \<prop\>:\<value\> with the following supported values
-   **@return** - None
-   **@raise** - KeyError - if some properties values are invalid

Supported properties are:

|**Property name** |**Replica attribute name** |
|------------------|---------------------------|
|legacy|nsds5replicalegacyconsumer [ *off* ]|
|binddn|nsds5replicabinddn' [ *REPLICATION_BIND_DN in constants.py* ]|
|referral|nsds5ReplicaReferral|
|purge-delay|nsds5ReplicaPurgeDelay|
|purge-interval|nsds5replicatombstonepurgeinterval|

<br>

#### **ruv(suffix, [tryrepl])**

Return a replica update vector for the given suffix. It tries first to retrieve the RUV tombstone entry stored in the replica database. If it can not retrieve it and if 'tryrepl' is True, it tries to retrieve the in memory RUV stored in the replica (e.g. cn=replica,cn=<suffix>,cn=mapping tree, cn=config).

-   **@param** suffix - eg. 'o=netscapeRoot'
-   **@param** tryrepl - True or False. If True and the tombstone RUV is not retrieved, try to read the in memory RUV
-   **@return** a RUV object (see RUV class)
-   **@raises** NoSuchEntryError if can not find the Replica Update Vector

<br>
<a name="agmt"></a>

### Replication Agreements
---------------------------------------------

#### **status(agreement\_dn)**

Return a formatted string with the replica agreement status

-   **@param** agreement_dn - DN of the replication agreement
-   **@returns** string containing the status of the replica agreement
-   **@raise** NoSuchEntryError - if agreement_dn is an unknown entry

Example:

    print topo.master.agreement.status(replica_agreement_dn)

    Status for meTo_localhost.localdomain:50389 agmt localhost.localdomain:50389
    Update in progress: TRUE
    Last Update Start: 20131121132756Z
    Last Update End: 0
    Num. Changes Sent: 1:10/0
    Num. changes Skipped: None
    Last update Status: 0 Replica acquired successfully: Incremental update started
    Init in progress: None
    Last Init Start: 0
    Last Init End: 0
    Last Init Status: None
    Reap Active: 0

<br>

#### **status\_total\_update(agreement\_dn)**

Returns tuple with done/errors status:

-   done=True/False. It shows the status of the total update. A total update is completed if
    -   no nsds5BeginReplicaRefresh
        -   nsds5ReplicaLastInitStatus = 'replica busy'\|'Total update succeeded'
        -   nsds5replicaUpdateInProgress != 'true'

-   error=True/False. True if the agreement does not exist or nsds5replicaUpdateInProgress="Update failed: status"
-   **@param** agmtdn - the agreement dn
-   **@returns**- tuple
-   **@raise** none

<br>

#### **schedule(agreement\_dn, [interval])**

Schedule the replication agreement

-   **@param** agreement_dn - DN of the replication agreement
-   **@param** interval [optional] - Interval in the format 'start'\|'stop'\|'HHMM-HHMM D+'. Default value is 'start'.
    -   HH being hours (0-23)
    -   MM being minutes (0-59)
    -   D being [0-6] where 0 stands for Monday... 6 for Sunday
-   **@return** - None
-   **@raise** ValueError if invalid interval
-   **@raise** ldap.NO_SUCH_OBJECT if agreement_dn is an unknown entry

Example:

    topo.master.agreement.schedule(agreement_dn)          # to start the replication agreement
    topo.master.agreement.schedule(agreement_dn, 'stop')  # to stop the replication agreement
    topo.master.agreement.schedule(agreement_dn, '1800-1900 01234')  # to schedule the replication agreement all week days from 6PM-7PM

<br>

#### **resume(agmtdn, [interval])**

Resume a paused replication agreement, paused with the "pause" method. It tries to enabled the replica agreement. If it fails (not implemented in all version), it uses the **schedule()** with interval '0000-2359 0123456'

-   **@param** agmtdn  - agreement dn
-   **@param** interval - replication schedule to use [ *ALWAYS* ]
-   **@return** None
-   **@raise** ValueError - if interval is not valid
        - ldap.NO_SUCH_OBJECT - if agmtdn does not exist    

<br>

#### **pause(agmtdn, [interval])**

Pause this replication agreement. This replication agreement will send no more changes. Use the resume() method to "unpause". It tries to disable the replica agreement. If it fails (not implemented in all version), it uses the **schedule()** with interval '2358-2359 0'

-   **@param** agmtdn  - agreement dn
-   **@param** interval - replication schedule to use [ *NEVER* ]
-   **@return** None
-   **@raise** ValueError - if interval is not valid

<br>

#### **getProperties(agreement\_dn, [properties])**

returns a dictionary of the requested properties. If properties is missing, it returns all the properties.

-   **@param** - agreement_dn - is the replica agreement DN
-   **@param** - properties - is the list of properties name
-   **@return** - returns a dictionary of the properties
-   **@raise** - None

Supported properties are:

|**Property name** |**Replication Agreement attribute name** |
|------------------|-----------------------------------------|
|schedule|nsds5replicaupdateschedule|
|fractional-exclude-attrs-inc|nsDS5ReplicatedAttributeList|
|fractional-exclude-attrs-total|nsDS5ReplicatedAttributeListTotal|
|fractional-strip-attrs|nsds5ReplicaStripAttrs|
|transport-prot|nsds5replicatransportinfo|
|consumer-port|nsds5replicaport|
|consumer-total-init|nsds5BeginReplicaRefresh|

<br>

#### **setProperties(agreement\_dn, properties)**

Checks that properties defined in 'properties' are valid and set the replica agreement entry with the corresponding RHDS attribute name.

The property name,may be prefixed in order to specify the operation:

-   **+**\<*propname*\>: \<*value*\> =\> MOD/ADD \<value\>
-   **-**\<*propname*\>: \<*value*\> =\> MOD/DEL \<value\>
-   \<*propname*\>: \<*value*\> =\> MOD/REPLACE \<value\>. If \<*value*\> = **""**, then the related attribute is deleted (MOD/DEL).

Some properties have default value, described in italic below

-   **@param** - agreement_dn - is the replica agreement DN
-   **@param** properties - is the dict of \<prop_name\>:\<value\>
-   **@return** - None
-   **@raise** ValueError - if some properties are not valid

Supported properties are:

|**Property name** |**Replication Agreement attribute name** |
|------------------|-----------------------------------------|
|schedule|nsds5replicaupdateschedule|
|fractional-exclude-attrs-inc|nsDS5ReplicatedAttributeList|
|fractional-exclude-attrs-total|nsDS5ReplicatedAttributeListTotal|
|fractional-strip-attrs|nsds5ReplicaStripAttrs|
|transport-prot|nsds5replicatransportinfo|
|consumer-port|nsds5replicaport|
|consumer-total-init|nsds5BeginReplicaRefresh|

Example:

    entry = Entry(dn_agreement)
    args = {'transport-prot': 'LDAP',
            'consumer-port' : 10389}
    try:
      setProperties(entry, args)
    except:
      pass

<br>

#### **list([suffix], [consumer\_host], [consumer\_port], [agmtdn])**

Returns the search result of the replica agreement(s) under the replica (replicaRoot is 'suffix').

Either 'suffix' or 'agmtdn' need to be specified. 'consumer\_host' and 'consumer\_port' are either not specified or specified both.

If 'agmtdn' is specified, it returns the search result entry of that replication agreement. else if consumer host/port are specified it returns the replica agreements toward that consumer host:port. Finally if neither 'agmtdn' nor 'consumer host/port' are specifies it returns all the replica agreements under the replica (replicaRoot is 'suffix').

-   **@param** - suffix is the suffix targeted by the total update 
-   **@param** - consumer_host hostname of the consumer
-   **@param** - consumer_port port of the consumer
-   **@param** - agmtdn DN of the replica agreement
-   **@return** - search result of the replica agreements
-   **@raise** InvalidArgument: if missing mandatory argument (agmtdn or suffix, then host and port)

<br>

#### **create(consumer, suffix, [binddn], [bindpw], [cn\_format], [description\_format], [timeout], [auto\_init], [bindmethod], [starttls], [args])**

Create a replication agreement from self to consumer and returns its DN

-   **@param** consumer: one of the following (consumer can be a master)
    -   a DirSrv object if chaining
    -   an object with attributes: host, port, sslport, \_\_str\_\_

-   **@param** suffix - suffix used to retrieve the replica (mandatory)
-   **@param** binddn - DN used to bind to consumer. Default is REPLICATION_BIND_DN in constants.py
-   **@param** bindpw - Password used to bind on consumer. Default is REPLICATION_BIND_PWD in constants.py
-   **@param** cn_format - string.Template to format the agreement name. Default is 'meTo_$host:$port'
-   **@param** description_format - string.Template to format the agreement description. Default is 'me to $host:$port'
-   **@param** timeout   - replica timeout in seconds. Default is 120seconds
-   **@param** auto_init - Value is True of False. Once created the replica agreement will run a consumer total update.  Default is 'False'
-   **@param** bindmethod-  bind method. Default is 'simple'
-   **@param** starttls  - Value is True or False. If True, connection to the consumer will be over the non secure port using a start-tls. Default is 'False'
-   **@param** args      - further args dict optional values. Allowed keys:
        - schedule
        - fractional-exclude-attrs-inc
        - fractional-exclude-attrs-total
         -fractional-strip-attrs
         -winsync

-   **@return** dn_agreement - DN of the created agreement
-   **@raise** InvalidArgumentError - If the suffix is missing
-   **@raise** NosuchEntryError     - If a replica doesn't exist for that suffix
-   **@raise** UNWILLING_TO_PERFORM - If the database was previously in read-only state. To create new agreements you need to **restart** the directory server

Example:

    repl_agreement = master.agreement.create(consumer, SUFFIX, binddn=defaultProperties[REPLICATION_BIND_DN], bindpw=defaultProperties[REPLICATION_BIND_PW])

<br>

#### **init([suffix], [consumer\_host], [consumer\_port], [agmtdn])**

Trigger a total update of the consumer replica. If 'agmtdn' is specified it triggers the total update of this replica.

If 'agmtdn' is not specified, then 'suffix', 'consumer\_host' and 'consumer\_port' are mandatory. It triggers total update of replica agreement under replica 'suffix' toward consumer 'host':'port'

-   **@param** - suffix is the suffix targeted by the total update
-   **@param** - consumer_host hostname of the consumer
-   **@param** - consumer_port port of the consumer
-   **@param** - agmtdn DN of the replica agreement
-   **@return** - None
-   **@raise** InvalidArgument: if missing mandatory argument (suffix/host/port)

<br>

#### **wait\_total\_update([suffix], [consumer\_host], [consumer\_port], [agmtdn])**

Wait for the completion of the total update or an error condition of the selected replica agreement.

If 'agmtdn' is specified it triggers the total update of this replica.

If 'agmtdn' is not specified, then 'suffix', 'consumer\_host' and 'consumer\_port' are mandatory. It triggers total update of replica agreement under replica 'suffix' toward consumer 'host':'port'

-   **@param** - suffix is the suffix targeted by the total update 
-   **@param** - consumer_host hostname of the consumer
-   **@param** - consumer_port port of the consumer
-   **@param** - agmtdn - agreement dn
-   **@return** - True if total update complete or False for an error condition
-   **@raise** - None

<br>

#### **changes([suffix], [consumer\_host], [consumer\_port], [agmtdn])**

Send a tuple with

-   number of changes send since startup (nsds5replicaChangesSentSinceStartup)
-   number of changes skipped since startup (nsds5replicaChangesSkippedSinceStartup)

If 'agmtdn' is specified it reads the info from this entry.

If 'agmtdn' is not specified, then 'suffix', 'consumer\_host' and 'consumer\_port' are mandatory. It retrieves the replica agreement under replica 'suffix' toward consumer 'host':'port', and reads the info from it

-   **@param** - suffix is the suffix targeted by the total update 
-   **@param** - consumer_host hostname of the consumer
-   **@param** - consumer_port port of the consumer
-   **@param** - agmtdn - agreement dn
-   **@return** - (changes_sent, changes_skipped)
-   **@raise** - None

<br>

### Logs
---------------------------

#### **setProperties(type, args)**

set the properties (if valid) for logging type.

-   **@param** - type is 'access'\|'errors'\|'audit'
-   **@param** - args is a dictionary of \<prop\>:\<value\> with the following supported values
-   **@return** - None
-   **@raise** - KeyError in case of invalid property value

Supported properties are

|Property name |type (type = access\|error\|audit)
|------------------|----------------------------------------------------------|
|max-logs|nsslapd-**type**log-maxlogsperdir|
|max-size|nsslapd-**type**log-maxlogsize|
|max-diskspace|nsslapd-**type**log-logmaxdiskspace|
|min-freespace|nsslapd-**type**log-logminfreediskspace|
|rotation-time|nsslapd-**type**log-logrotationtime|
|TBC||

<br>

#### **getProperties(type, [args])**

Returns in a dictionary (*prop*:*value*) the requested set of properties for the logging type. If 'args' is missing, it returns all the properties for the logging type.

-   **@param** - type is 'access'\|'errors'\|'audit'
-   **@param** - args is a dictionary of \<prop\>:\<value\> with the following supported values
-   **@return** - a dictionary of the logging type properties
-   **@raise** - KeyError in case of invalid property value

Supported properties are

|Property name |type (type = access\|error\|audit)|
|------------------|----------------------------------------------------------|
|max-logs|nsslapd-**type**log-maxlogsperdir|
|max-size|nsslapd-**type**log-maxlogsize|
|max-diskspace|nsslapd-**type**log-logmaxdiskspace|
|min-freespace|nsslapd-**type**log-logminfreediskspace|
|rotation-time|nsslapd-**type**log-logrotationtime|
|TBC||

<br>

### Suffix
----------

#### **list()**

It returns the list of suffixes DN for which it exists a mapping tree entry

-   **@param** None
-   **@return** list of suffix DN
-   **@raise** None

<br>

#### **toBackend(suffix)**

It returns the backend entry that stores the provided suffix

-   **@param** suffix - suffix DN of the backend
-   **@return** backend - LDAP entry of the backend
-   **@return** ValueError - if suffix is not provided

<br>

#### **getParent(suffix)**

It returns the DN of a suffix that is the parent of the provided 'suffix'. If 'suffix' has no parent, it returns None

-   **@param** suffix - suffix DN of the backend
-   **@return** parent suffix DN
-   **@return** ValueError - if suffix is not provided(InvalidArgumentError - if suffix is not implemented on the server)

<br>

### MappingTree
-----------------

#### **list([suffix], [benamebase])**

Returns a search result of the mapping tree entries with all their attributes

If 'suffix'/'benamebase' are specified. It uses 'benamebase' first, then 'suffix'.

If neither 'suffix' and 'benamebase' are specified, it returns all the mapping tree entries

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - backend common name (e.g. 'userRoot')
-   **@return** mapping tree entries
-   **@raise** None

<br>

#### **create(suffix, benamebase,[parent])**

Create a mapping tree entry (under "cn=mapping tree,cn=config"), for the 'suffix' and that is stored in 'benamebase' backend. 'benamebase' backend must exists before creating the mapping tree entry. If a 'parent' is provided that means that we are creating a sub-suffix mapping tree.

-   **@param** suffix - suffix mapped by this mapping tree entry. It will be the common name ('cn') of the entry
-   **@param** benamebase - backend common name (e.g. 'userRoot')
-   **@param** parent - if provided is a parent suffix of 'suffix'
-   **@return** DN of the mapping tree entry
-   **@raise** ldap.NO_SUCH_OBJECT - if the backend entry or parent mapping tree does not exist

<br>

#### **delete([suffix], [benamebase],[name])**

Delete a mapping tree entry (under "cn=mapping tree,cn=config"), for the 'suffix' and that is stored in 'benamebase' backend. 'benamebase' backend is not changed by the mapping tree deletion.

If 'name' is specified. It uses it to retrieve the mapping tree to delete Else if 'suffix'/'benamebase' are specified. It uses both to retrieve the mapping tree to delete

-   **@param** suffix - suffix mapped by this mapping tree entry. It is the common name ('cn') of the entry
-   **@param** benamebase - backend common name (e.g. 'userRoot')
-   **@param** name - DN of the mapping tree entry
-   **@return** None
-   **@raise** ldap.NO_SUCH_OBJECT - the entry is not found (KeyError if 'name', 'suffix' and 'benamebase' are missing)

<br>

#### **getProperties([suffix], [benamebase],[name], [properties])**

returns a dictionary of the requested properties. If properties is missing, it returns all the properties.

The returned properties are those of the 'suffix' and that is stored in 'benamebase' backend.

If 'name' is specified. It uses it to retrieve the mapping tree to delete Else if 'suffix'/'benamebase' are specified. It uses both to retrieve the mapping tree to

If 'name', 'benamebase' and 'suffix' are missing it raise an exception

-   **@param** suffix - suffix mapped by this mapping tree entry. It is the common name ('cn') of the entry
-   **@param** benamebase - backend common name (e.g. 'userRoot')
-   **@param** name - DN of the mapping tree entry
-   **@param** - properties - list of properties
-   **@return** - returns a dictionary of the properties
-   **@raise** ValueError - if some name of properties are not valid

Supported properties are:

|**Property name** |**Mapping Tree attribute name**|
|------------------|-------------------------------|
|state|nsslapd-state|
|backend|nsslapd-backend|
|referral|nsslapd-referral|
|chain-plugin-path|nsslapd-distribution-plugin|
|chain-plugin-fct|nsslapd-distribution-funct|
|chain-update-policy|nsslapd-distribution-root-update|

<br>

#### **setProperties([suffix], [benamebase],[name], properties)**

Set the requested properties if they are valid. The property name (see getProperties for the supported properties), may be prefixed in order to specify the operation:

-   **+**\<propname\>: \<value\> =\> MOD/ADD \<value\>
-   **-**\<propname\>: \<value\> =\> MOD/DEL \<value\>
-   \<propname\>: \<value\> =\> MOD/REPLACE \<value\>. If *value* = **""**, then the related attribute is deleted (MOD/DEL).

The properties are those of the 'suffix' and that is stored in 'benamebase' backend.

If 'name' is specified. It uses it to retrieve the mapping tree to delete Else if 'suffix'/'benamebase' are specified. It uses both to retrieve the mapping tree to

If 'name', 'benamebase' and 'suffix' are missing it raise an exception

-   **@param** suffix - suffix mapped by this mapping tree entry. It is the common name ('cn') of the entry
-   **@param** benamebase - backend common name (e.g. 'userRoot')
-   **@param** name - DN of the mapping tree entry
-   **@param** - properties - list of properties
-   **@return** - returns a dictionary of the properties
-   **@raise** ValueError - if some name of properties are not valid

<br>

#### **toSuffix([entry], [name])**

Return, for a given mapping tree entry, the suffix values. Suffix values are identical from a LDAP point of views. Suffix values may be surrounded by ", or containing '\\' escape characters.

-   **@param entry** - LDAP entry of the mapping tree
-   **@param name**  - mapping tree DN
-   **@result** list of values of suffix attribute (aka 'cn')
-   **@raise** ldap.NO_SUCH_OBJECT - in name is invalid DN
    -   ValueError - entry does not contains the suffix attribute
    -   InvalidArgumentError - if both entry/name are missing

<br>

### Backend
---------------------------------

#### **list([suffix], [backend\_dn],[benamebase])**

Returns a search result of the backend(s) entries with all their attributes

If 'suffix'/'backend\_dn'/'benamebase' are specified. It uses 'backend\_dn' first, then 'suffix', then 'benamebase'.

If neither 'suffix', 'backend\_dn' and 'benamebase' are specified, it returns all the backend entries

-   **@param** suffix - suffix of the backend
-   **@param** backend_dn - DN of the backend entry
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@return** backend entries
-   **@raise** None

<br>

#### **create(suffix, [properties])**

Creates backend entry and returns its dn. If the properties 'chain-bind-pwd' and 'chain-bind-dn' and 'chain-urls' are specified the backend is a chained backend. A chaining backend is created under 'cn=chaining database,cn=plugins,cn=config'. A local backend is created under 'cn=ldbm database,cn=plugins,cn=config'

-   **@param** suffix - suffix stored in that backend
-   **@param** properties - a dict with some properties of the backend (see getProperties for the set of properties)
-   **@return** DN of the created backend
-   **@raise** ValueError - if some properties are not valid

<br>

#### **delete([suffix], [backend\_dn],[benamebase])**

Deletes the backend entry with the following steps:

-   Delete the indexes entries under this backend
-   Delete the encrypted attributes entries under this backend
-   Delete the encrypted attributes keys entries under this backend

If a mapping tree entry uses this backend (nsslapd-backend), it raises UnwillingToPerformError

If 'suffix'/'backend\_dn'/'benamebase' are specified. It uses 'backend\_dn' first, then 'suffix', then 'benamebase'.

If neither 'suffix', 'backend\_dn' and 'benamebase' are specified, it raise InvalidArgumentError

-   **@param** suffix - suffix of the backend
-   **@param** backend_dn - DN of the backend entry
-   **@param** name - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@return** None
-   **@raise** InvalidArgumentError - if missing arguments or invalid
        - UnwillingToPerformError - if several backends match the argument provided suffix does not match backend suffix.  It exists a mapping tree that use that backend    

<br>

#### **getProperties([suffix], [backend\_dn],[benamebase], [properties])**

returns a dictionary of the requested properties. If properties is missing, it returns all the properties.

If 'suffix'/'backend\_dn'/'benamebase' are specified. It uses 'backend\_dn' first, then 'suffix', then 'benamebase'. At least one of 'suffix'/'backend\_dn'/'benamebase' must be specified.

-   **@param** suffix - suffix of the backend
-   **@param** backend_dn - DN of the backend entry
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** properties - list of properties 
-   **@return** backend properties in a dictionary
-   **@raise** None

Supported properties are:

|**Property name** |**Backend attribute name**|
|------------------|--------------------------|
|entry-cache-size|nsslapd-cachememsize|
|entry-cache-number|nsslapd-cachesize|
|dn-cache-size|nsslapd-dncachememsize|
|read-only|nsslapd-readonly|
|require-index|nsslapd-require-index|
|suffix|nsslapd-suffix (read only)|
|directory|nsslapd-directory (once set it is read only)|
|db-deadlock|nsslapd-db-deadlock-policy|
|chain-bind-dn|nsmultiplexorbinddn|
|chain-bind-pwd|nsmultiplexorcredentials|
|chain-urls|nsfarmserverurl|
|stats|*<see below>* (read only)|

**stats** return the stats related to this backend that are available under "cn=monitor,cn=*benamebase*,cn=ldbm database,cn=plugins,cn=config"

<br>

#### **setProperties([suffix], [backend\_dn],[benamebase], properties)**

set backend entry properties as defined in 'properties'. If all the properties are valid it updates the backend entry, else it raises an exception. The supported properties are described in getProperties().

The property name, may be prefixed in order to specify the operation:

-   **+**\<*propname*\>: \<*value*\> =\> MOD/ADD \<value\>
-   **-**\<*propname*\>: \<*value*\> =\> MOD/DEL \<value\>
-   \<*propname*\>: \<*value*\> =\> MOD/REPLACE \<value\>. If \<*value*\> = **""**, then the related attribute is deleted (MOD/DEL).

If 'suffix'/'backend\_dn'/'benamebase' are specified. It uses 'backend\_dn' first, then 'suffix', then 'benamebase'. At least one of 'suffix'/'backend\_dn'/'benamebase' must be specified.

-   **@param** suffix - suffix of the backend
-   **@param** backend_dn - DN of the backend entry
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** properties - dictionary of \<prop_name\>:\<value\>
-   **@return** None
-   **@raise** ValueError - if some properties are not valid

<br>

#### **toSuffix(backend\_dn)**

return the mapping tree entry of the suffix that is stored in 'backend\_dn'.

-   **@param** backend_dn - DN of the backend entry
-   **@return** mapping tree LDAP entry that is store in backend_dn
-   **@raise** ldap.NO_SUCH_OBJECT - in name is invalid DN
-   **@raise** ValueError - entry does not contains the suffix attribute
-   **@raise** InvalidArgumentError - if both entry/name are missing

<br>

### Index
-----------------------------

#### **list([suffix],[benamebase], [system])**

Returns a search result of the indexes for a given 'suffix' (or 'benamebase' that stores that suffix).

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

If 'system' is specified and is True, it returns index entries under "cn=default indexes,cn=config,cn=ldbm database,cn=plugins,cn=config". Else it returns index entries under 'cn=index,cn=*<backend_common_name>*,cn=ldbm database,cn=plugins,cn=config'.

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** attrname - name of an attribute
-   **@param** system: True or False, - specifies if the searched indexes are default (system) indexes or not
-   **@return** returns index entries
-   **@raise** TBD

<br>

#### **create([suffix],[benamebase],attrname, properties )**

Create a new index entry for a given 'suffix' (or 'benamebase' that stores that suffix).

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

If the 'attrname' index already exists (system or not), it raises TBD

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** attrname - name of an attribute
-   **@param** properties - dictionary with the supported properties (see getProperties)
-   **@return** returns index DN
-   **@raise** TBD

<br>

#### **delete([suffix],[benamebase],[attrname])**

Delete an index entry for a given 'suffix' (or 'benamebase' that stores that suffix).

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

If the 'attrname' is provided and index does not exist (system or not), it raises TBD. If 'attrname' is not provided, it deletes all the indexes (system or not) under the suffix

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** attrname - name of an attribute
-   **@return** None
-   **@raise** TBD

<br>

#### **getProperties([suffix],[benamebase],attrname, [properties])**

returns a dictionary containing the index properties. The index is for a given 'suffix' (or 'benamebase' that stores that suffix). If 'properties' is missing it returns all the properties.

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. I both 'suffix' and 'benamebase' are missing it raise TBD

If the 'attrname' index does not exist (system or not), it raises TBD

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** attrname - name of an attribute
-   **@param** properties - list of requested properties
-   **@return** A dictionary with the properties:value
-   **@raise** TBD

Supported properties are:

|**Property name** |**Index attribute name/value**|
|------------------|------------------------------|
|equality-indexed|nsIndexType: eq|
|presence-indexed|nsIndexType: pres|
|approx-indexed|nsIndexType: approx|
|subtree-indexed|nsIndexType: subtree|
|substring-indexed|nsIndexType: sub|
|system|nsSystemIndex (read only)|
|matching-rules|nsMatchingRule|

<br>

#### **setProperties([suffix],[benamebase],attrname, properties)**

Set the properties defined in 'properties'. If all the properties are valid it updates the index entry, else it raises an exception. The supported properties are described in getProperties().

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. I both 'suffix' and 'benamebase' are missing it raise TBD

If the 'attrname' index does not exist (system or not), it raises TBD

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** attrname - name of an attribute
-   **@param** properties - dictionary of \<prop_name\>:\<value\>
-   **@return** None
-   **@raise** ValueError - if some properties are not valid

Supported properties are:

|**Property name** |**Index attribute name/value**|
|------------------|------------------------------|
|equality-indexed|nsIndexType: eq|
|presence-indexed|nsIndexType: pres|
|approx-indexed|nsIndexType: approx|
|subtree-indexed|nsIndexType: subtree|
|substring-indexed|nsIndexType: sub|
|system|nsSystemIndex (read only)|

<br>

### Tasks
-----------------------------

#### **export ([suffix], [benamebase], ldif\_output, [args])**

Export in a LDIF format a given 'suffix' (or 'benamebase' that stores that suffix). It uses an internal task to achieve this request.

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

'ldif\_output' is the output file of the export

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** ldif_output - file that will contain the exported suffix in LDIF format
-   **@param** args - is a dictionary that contains modifier of the export task
    -   wait: True/[False] - If True, 'export' waits for the completion of the task before to return
    -   replication: True/[False] - If True, it adds the replication meta data (state information, tombstones and RUV) in the exported file
-   **@return** None
-   **@raise** TBD

<br>

#### **import ([suffix], [benamebase], ldif\_input, [args])**

Import from a LDIF format a given 'suffix' (or 'benamebase' that stores that suffix). It uses an internal task to achieve this request.

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

'ldif\_input' is the input file

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** ldif_input - file that will contain the entries in LDIF format, to import
-   **@param** args - is a dictionary that contains modifier of the import task
    -   wait: True/[False] - If True, 'export' waits for the completion of the task before to return
-   **@return** None
-   **@raise** TBD

<br>

#### **reindex ([suffix], [benamebase], attrname, [args])**

Reindex a 'suffix' (or 'benamebase' that stores that suffix) for a given 'attrname'. It uses an internal task to achieve this request.

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** attrname - attribute name
-   **@param** args - is a dictionary that contains modifier of the reindex task
    -   wait: True/[False] - If True, 'export' waits for the completion of the task before to return
-   **@return** None
-   **@raise** TBD

<br>

#### **db2bak(backup_dir, args)**

Perform a backup by creating a db2bak task

-   **@param** backup_dir - backup directory
-   **@param** args - is a dictionary that contains modifier of the task
        - wait: True/[False] - If True,  waits for the completion of the task before to return
-   **@return** Result code, 0 for success
-   **@raise** ValueError

<br>

#### **bak2db(bename, backup_dir, args)**

Restore a backup by creating a bak2db task

-   **@param** bename - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** backup_dir - backup directory
-   **@param** args - is a dictionary that contains modifier of the task
        - wait: True/[False] - If True,  waits for the completion of the task before to return
-   **@return** exit code
-   **@raise** ValueError

<br>

#### **fixupMemberOf ([suffix], [benamebase], [filt], [args])**

Trigger a fixup task on 'suffix' (or 'benamebase' that stores that suffix) related to the entries 'memberof' of groups. It uses an internal task to achieve this request.

If 'suffix' and 'benamebase' are specified, it uses 'benamebase' first else 'suffix'. If both 'suffix' and 'benamebase' are missing it raise TBD

'filt' is a filter that will select all the entries (under 'suffix') that we need to evaluate/fix. If missing, the default value is **"(\|(objectclass=inetuser)(objectclass=inetadmin))"**

-   **@param** suffix - suffix of the backend
-   **@param** benamebase - 'commonname'/'cn' of the backend (e.g. 'userRoot')
-   **@param** args - is a dictionary that contains modifier of the fixupMemberOf task
    -   wait: True/[False] - If True, 'export' waits for the completion of the task before to return
-   **@return** None
-   **@raise** TBD

<br>

#### **fixupTombstones(be_name, args)**

Trigger a tombstone fixup task on the specified backend

-   **@param** be_name - 'common name'/'cn' of the backend (e.g. 'userRoot').  Optional.
-   **@param** args - is a dictionary that contains modifier of the task
        - wait: True/[False] - If True,  waits for the completion of the task before to return
-   **@return** exit code
-   **@raise** ValueError

<br>

### Schema
-------------------------------

#### **list([args])**

returns the search result on suffix 'cn=schema'. The returned attributes are specified in 'args' list. By default it returns SCHEMA\_OBJECTCLASSES, SCHEMA\_ATTRIBUTES and SCHEMA\_CSN.

-   **@param** args: it is a list of schema properties. Supported properties are:

|**property name** |**schema attribute name**|
|------------------|-------------------------|
|SCHEMA_OBJECTCLASSES|objectclasses|
|SCHEMA_ATTRIBUTES|attributes|
|SCHEMA_CSN|nsSchemaCSN|

-   **@return** schema entry with the requested attributes
-   **@raise** ValueError if invalid requested properties

<br>

#### **create(propname, value)**

Update the schema doing a MODIFY/ADD of the attribute specified by 'propname' with 'value'.

-   **@param** propname - name of the property to MOD/ADD.  Supported properties are:

|**property name** |**schema attribute name**|
|------------------|-------------------------|
|SCHEMA_OBJECTCLASSES|objectclasses|
|SCHEMA_ATTRIBUTES|attributes|

-   **@param** value - Value to be added
-   **@return** None
-   **@raise** IOError if the modify fails
       - ValueError if 'propname'/'value' is invalid

<br>

#### **delete(propname, value)**

Update the schema doing a MODIFY/DEL of the attribute specified by 'propname' with 'value'.

-   **@param** propname - name of the property to MOD/ADD.  Supported properties are:

|**property name** |**schema attribute name**|
|------------------|-------------------------|
|SCHEMA_OBJECTCLASSES|objectclasses|
|SCHEMA_ATTRIBUTES|attributes|

-   **@param** value - Value to be deleted
-   **@return** None
-   **@raise** IOError if the modify fails
-   **@raise** ValueError if 'propname'/'value' is invalid

<br>

### Chaining
-------------

#### **list([suffix], [type])**

Returns a search result of the local or chained backend(s) entries with all their attributes.

If **suffix** is specified, only that suffix backend is returned. Else, it returns all the backend (according to the **type**).

If **type** is missing, by default its value is **CHAINING\_FARM**. If **type** is **CHAINING\_FARM**, it is equivalent to backend.list(suffix). If type is **CHAINING\_MUX**, it returns all the backend entries under '' cn=chaining database,cn=plugins,cn=config''

-   **@param** suffix - DN of the suffix
-   **@param** type - type of backend **CHAINING_FARM** or **CHAINING_MUX**
-   **@return** None
-   **@raise** ValueError if mandatory parameters are missing

<br>

#### **create(suffix, [type], binddn, [bindpw], [urls])**

Create a local or chained backend for the **suffix**. If **type** is missing, by default its value is **CHAINING\_FARM**. If **type** is **CHAINING\_FARM**, it creates a local backend (under *cn=ldbm database,cn=plugins,cn=config*), else (**CHAINING\_MUX**) it creates a chained backend (under *cn=chaining database,cn=plugins,cn=config*).

If this is a local backend (**CHAINING\_FARM**) it adds an 'proxy' allowed ACI at the suffix level:

    (targetattr = "*")(version 3.0; acl "Proxied authorization for database links"; allow (proxy) userdn = "ldap:///<binddn>";)

If this is a local backend (**CHAINING\_FARM**) and **bindpw** is specified, it creates the proxy entry: *binddn*/*bindpw*

If this is a chained backend (**CHAINING\_MUX**), then *bindpw* and *urls* are mandatory

-   **@param** suffix - DN of the suffix
-   **@param** type - type of backend **CHAINING_FARM** or **CHAINING_MUX**
-   **@param** binddn - DN of the proxy user
-   **@param** bindpw - password of the bind DN
-   **@param** urls - urls of the real backend server
-   **@return** None
-   **@raise** ValueError if mandatory parameters are missing

<br>

#### **delete(suffix, [type])**

Delete a local or chained backend(s) entry, implementing **suffix**.

If **type** is missing, by default its value is **CHAINING\_FARM**. If **type** is **CHAINING\_FARM**, it is equivalent to backend.delete(suffix). If type is **CHAINING\_MUX**, it deletes the entry *cn=\<bebasename\>,cn=chaining database,cn=plugins,cn=config* where *\<bebasename\>* is the backend common name.

If a mapping tree entry uses this backend (nsslapd-backend), it raise TBD

-   **@param** suffix - DN of the suffix
-   **@param** type - type of backend **CHAINING_FARM** or **CHAINING_MUX**
-   **@return** None
-   **@raise** ValueError if mandatory parameters are missing

<br>

#### **getProperties([properties])**

Returns a dictionary with the requested chaining plugin properties. If the **properties** is not specified, it returns all the properties. If the properties are not set at the server level, the default returned value is **off**

-   **@param** properties - list of requested properties
-   **@return**  dictionary containing \<properties\>:\<value\>
-   **@raise** None

Supported properties are

|**property name** |**chaining plugin attribute**|
|------------------|-----------------------------|
|proxy-authorization|nsTransmittedControl|
|loop-detection|nsTransmittedControl|

<br>

#### **setProperties(properties)**

Set (if they are valid) the properties in the 'chaining plugin'.

-   **@param** properties - dictionary containing \<properties\>:\<value\>
-   **@return** None
-   **@raise** ValueError if invalid properties/value

Supported properties are

|**property name**|**chaining plugin attribute**|
|------------------|-----------------------------|
|proxy-authorization|nsTransmittedControl|
|loop-detection|nsTransmittedControl|

<br>

### Server
-----------

#### **getProperties([properties])**

Returns a dictionary of properties of the server. If no property are specified, it returns all the properties

-   **@param** properties - list of properties

Supported properties are:

|**Property name**|**server attribute name**|
|-----------------|-------------------------|
|pid|N/A|
|port|nsslapd-port|
|sport|nsslapd-secureport|
|version|TBD|
|owner|user/group id|
|dbstats|statistics from<br>cn=database,cn=monitor,cn=ldbm database,cn=plugins,cn=config<br>cn=monitor,cn=ldbm database,cn=plugins,cn=config|

<br>
<a name="upstream"></a>

389 Upstream Tests Suites
================================================

Overview
--------

389 upstream test suites are tests located inside the 389 Directory Server source code. In a continuous integration effort, those tests will be used in a non regression test phase of the continuous integration. The tests are written in python and are based on lib389. The tests are organized in individual bug test cases (tickets) and in functional test suites. In a first phase, only ticket test cases will be described.

Design
------

### Repos

The 389 upstream tests will be pushed to the 389 Directory Server repository <http://git.fedorahosted.org/git/389/ds.git>

### Layout

The tests layout is

    ds/dirsrvtests
        data/
           # location to store static files used by individual tests, things LDIF files, etc
        tickets/
           # Contains the test cases for ticket xxx
           ticketxxx_test.py  
           ticketyyy_test.py
           ...
           ticketzzz_test.py
           finalizer.py       # this module contains the cleanup function to remove the created instances
        suites/               
           # functional tests
           aci.py
           replication.py
           ...
           index.py
        tmp/
           # location used to exported ldif files, backups, etc
         

### Ticket Test Suites

Test suite for a given ticket are stored in a single python module named *ticketxxx\_test.py*. The name contains *\_test* so that the ticket will be selected by test scheduler (nose, py.test...). The test suite creates/reinit the instances they need for their test purpose and stop the instances at the end of the test suite. A test suite is a series of test functions named *test\_ticketxxx\_\<no\>*. The string *test* in the function name is required so that the test scheduler will select them. They will select them in the order they appear in the module.

A ticket test suites looks like:

    installation_prefix = None
    <local helper functions>*
    @pytest.fixture(scope=module)
    def *topology*(request):
         if installation_prefix:
              <add 'PREFIX' to the creation of all instances>
          <creation of the test topology>
    def test_ticketxxx_one(*topology*):
         <test case one>
    ...
    def test_ticketxxx_NNN(*topology*):
         <test case NNN>
    def test_ticketxxx_final(*topology*):
          <stop the instance in the topology>
    def run_isolated():
         installation_prefix = /directory/where/389-ds/is/deployed (DIR_INSTALL)
         topo = topology(True)
         test_ticketxxx_one(topo)
         ...
         test_ticketxxx_NNN(topo)
         test_ticketxxx_final(topo)
    if __name__ == '__main__':
       run_isolated()

#### Topology Fixture

see 'Fixture' in Test framework chapter

#### Test case

A test case would contain assert. This test case will be reported **PASSED** or **FAILED** if assert succeeds or not.

#### Run\_isolated

It is a method to run the test under a python script rather that under a test scheduler.

How to run a single test
----------

### How to deploy Directory Server on a specific directory

- [Setup Script](#specific-dir) - Set up a lib389 testing environment

- [Test Script](#test) - Run a specific test

### How to run under eclipse

#### Prerequisite

-   Install eclipse <http://www.eclipse.org>
    -   yum install eclipse-platform
    -   yum search eclipse will show many useful plugins
-   Install **pydev** <http://pydev.org/index.html> . In eclipse in Menu *help*, *Install New Software...*. In *work with* enter *<http://pydev.org/updates>* then click on *Add*.
-   select interpreter, *windows*, *Preferences*, *PyDev*, *Interpreter python*, *New*, choose ''/bin/pythonx.y' (e.g. /bin/python2.7)
-   Then do the following steps

    cd $HOME/test
    mkdir 389-ds
    mkdir lib389
    cd $HOME/test/389-ds
    git clone ssh://git.fedorahosted.org/git/389/ds.git
    cd $HOME/test/lib389
    git clone ssh://git.fedorahosted.org/git/389/lib389.git
    launch eclipse
    -> in 'select workspace' entry $HOME/test
    -> File->New->Project selects PyDev Project
    -> Project name 'lib389' (Directory will be $HOME/test/lib389/lib389)
    -> File->New->Project selects PyDev Project
    -> Project name 'dirsrvtest' (Directory will be $HOME/test/389-ds/ds/dirsrvtests
      'Referenced projects' selects lib389

#### Run a dedicated test

Open the tests you want to run 'dirsrvtest-\>tickets-\>ticket47490\_test.py'

-   add/check that the pytest fixture is commented. Search the string 'pytest.fixture(scope="module")' and comment it. Running under eclipse, it does not use py.test framework, so this fixture is not recognized.
-   At the end of the file in 'run\_isolated()' replace 'installation\_prefix = None' with 'installation\_prefix = */directory/where/389-ds/is/installed*'
-   save and run ('Python Run')

<br>

<a name="framework"></a>

Test framework
==========================================

Overview
--------

To run 389 upstream tests we are using py.test (http://pytest.org/). This framework offers an two features that we are using:

-   auto discovery of the tests (based on module and function names)
-   fixture. We will use fixture functions to create/reinit the 389 instances we need to run a test
-   silent mode. By default all output are hidden.

Selection of the tests
----------------------

### Auto discovery

This is achieved running the following command: *PREFIX=/directory/where/389-ds/is/deployed py.test -v*

The test modules will be named like *ticketxxx\_test.py* or *fractional\_replication\_test.py*. The name containing the **test** pattern, py.test will select the module as a test module.

The test module will contain test suites implemented as functions named like *test\_ticketxxx\_<no>* or *test\_fractional\_replication\_\<no\>*. Each functions will be called by py.test in the order they appear in the module. They will be called independently of the test result of the previous function.

### Specified test

This is achieve running the following command: *PREFIX=/directory/where/389-ds/is/deployed py.test -v \$SPECIFIED\_TEST*

The test module will be executed even if its name does not contain *test* pattern.

We will use this ability to run a finalizer module. This module will be executed after the auto discovery mode, so after all tests completed. Its job will be to cleanup the environment (remove instances/backup...)

### Fixture

Each test suite will contain a **topology** fixture (scope module), that will create or reinitialize the topology to support the tests (standalone, MMR...)

Each test in the suite will have **topology** argument.

The algorithm is :

           At the beginning, It may exists already some instances
           It may also exists a backup for the instances

           Principle:
               If instances exists:
                   restart them
               If it exists backup for all instances:
                   restore them from backup
               else:
                   remove instances and backups
                   Create instances
                   Initialize topology
                   Create backups

### Silent mode vs debug mode

By default *py.test* run silently returning **PASSED** or **FAILED** whether or not an *assert* fails in the test.

It is possible to have more detail on the execution of the test with the following command: *PREFIX=/directory/where/389-ds/is/deployed py.test -v **-s***


