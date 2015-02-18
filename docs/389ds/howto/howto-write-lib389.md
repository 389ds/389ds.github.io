---
title: "How to Write lib389 Test"
---

# How to Write a lib389 Test
-------------------

{% include toc.md %}

## Introduction

Lib389 is a python base library for managing Directory servers. It was initially created to help writing tests of DS. It can also used to create new administration CLIs.  This document is focusing on writing tests for the Directory Server.  Lib389 can be used to generate individual testcases(*tickets*), and *suites* that test a range of functionality/feature.  When working on a new bug/ticket that is reproducible, a testcase should be written that can reproduce the problem.  Then that same testcase can be used to verify the fix.  The entire collection of testcases(tickets) can then be used to check for regressions in future releases/builds.

When a new feature is added, a testing *suite* should be created.  This *suite* is in its own dedicated directory, and can contain multiple scripts, or whatever is required to effectively test a feature.

## Directory Server's Testing Layout

After you checkout the source code, you can find the testing framework as follows:

    mkdir /home/<USER>/ds-source
    cd /home/<USER>/ds-source
    git clone ssh://git.fedorahosted.org/git/389/ds.git
    cd ds/dirsrvtests

Under *ds/dirsrvtests/* we see the following directories

    suites/  --> location for functional/feature tests

    tickets/ --> location for individual ticket/bug tests

    data/    --> location to store static files needed by tickets/suites.
                 This is accessed by calling: "tmp_dir = topology.standalone.getDir(__file__, TMP_DIR)"

    tmp/     --> location where the lib389 tests can use to write temporary files to
                 This is accessed by calling: "data_dir = topology.standalone.getDir(__file__, DATA_DIR)"

<br>

## Get the Lib389 Framework

To start working with lib389, we need to get the lib389 framework:

    mkdir /home/<USER>/lib389
    cd /home/<USER>/lib389
    git clone ssh://git.fedorahosted.org/git/389/lib389.git

External users will use "**git clone git://**" instead of "**git clone ssh://**"

Next, we add the location of the framework to our PYTHONPATH environment variable (**/home/mreynolds/lib389**):

    PYTHONPATH=/usr/lib64/python2.7:/usr/lib64/python2.7/plat-linux2:/usr/lib64/python2.7/lib-dynload:/usr/lib64/python2.7/site-packages:/usr/lib/python2.7/site-packages:/usr/lib/python2.7/site-packages/setuptools-0.6c11-py2.7.egg-info:/home/mreynolds/lib389/

<br>

## Deploying the Directory Server

There are two options for testing the Directory Server:

-    Using an RPM installation
-    Using a private build of Directory Server

### RPM Installation

To run the lib389 tests against an RPM installation, you must be logged in as 'root'.  

### Private Build of the Directory Server

There are actually two options here as well.  You can build, and install the server into the RPM location.  

Or you can build and install the Directory Server into a "prefixed/specific" location.  In this case you would set PREFIX to the Directory Server installation directory:

    PREFIX='/home/<USER>/install'

For more information on how to make/install the Directory Server into a prefixed/specific location see:

[Upstream Setup Script](http://www.port389.org/docs/389ds/FAQ/upstream-test-framework.html#deploy-389-directory-server-under-specific-directory)

or

[Directory Server Build Page](http://www.port389.org/docs/389ds/development/building.html)

There are also helper scripts listed on the upstream testing reference page: <http://www.port389.org/docs/389ds/FAQ/upstream-test-framework.html>

<br>

## Create a Test

To write a lib389 test script we to mention the default layout of a ticket.  Each test needs these basic functions, but there could be more depending on your needs:

-   The "**topology**" function.  This function creates/configures the Directory Server instances we want to use in our test.  If using replication, the replication setup/initialization should happen in this function.  There is also a "topology class" that needs to be created.  It is basically just a simple object that lists all the instances so they can be referenced later in the script

-   The "**test**" function(s).  This the function that actually performs the tests we want to perform on our newly created instance(s)

-   The "**final**" function.  This function should "delete" all the instances that were created.  Also, any other clean up should be done in this function as well.  It should also log a "PASSED" message

-  The "**run**" function.  This function calls the topology, test(s), and final functions

Example using a single standalone instance:

    class TopologyStandalone(object):
        def __init__(self, standalone):
            standalone.open()
            self.standalone = standalone


    @pytest.fixture(scope="module")
    def topology(request):
        #
        # Topology function
        # 
        # Create our instances, configure replication
        #
        standalone.allocate(args)
        standalone.create()
        standalone.open()

        return TopologyStandalone(standalone)

    def test_ticket#####_run(topology):
        #
        # Test function
        #
        # You can create as many of these mfunctions as you like
        #

    def test_ticket#####_final(topology):
        #
        # Final function
        #
        topology.standalone.delete()
        log.info('Testcase PASSED')


    def run_isolated():
        #
        # Run function
        #
        topo = topology(True)
        test_ticket#####_run(topo)
        test_ticket#####_final(topo)


    if __name__ == '__main__':
        run_isolated()

Fortunately, we have a helper script(*create_test.py*) to create this template for us, so we can focus on writing the *actual* test

### create_test.py

Using this script we can setup complex replication instances(that are fully configured and initialized), or multiple standalone instances.  The script is located in the Directory Server source code:

    ds/dirsrvtests/create_test.py

    ./create_test.py -t|--ticket <ticket number> | -s|--suite <suite name> [ i|--instances <number of standalone instances> [ -m|--masters <number of masters> -h|--hubs <number of hubs> -c|--consumers <number of consumers> ] -o|--outputfile ]

Currently the script will create a "replication" setup, or a standalone setup (no replication).  When using the "**-o\|--outputfile**" option be sure to use _Here is an example of both:

    ./create_test.py --ticket 33333

        --> Creates a script named:  ticket33333_test.py
            This script create a single standalone instance

    ./create_test.py --ticket 33333 --outputfile my_test.py

        --> Creates a script named:  my_test.py
            This script create a single standalone instance

    ./create_test.py --ticket 33333 --instances 4

        --> Creates a script named:  ticket33333_test.py
            This script creates four standalone instances

    ./create_test.py --ticket 33333 --master 2

        --> Creates a script named:  ticket33333_test.py
            This script creates two replication master instances, and initializes them

    ./create_test.py --ticket 33333 --master 2 --hubs 2 --consumers 10

        --> Creates a script named:  ticket33333_test.py
            This script creates two replication master instances, two replication hubs, and ten consumers.  Replication is fully initialized across all the servers

    ./create_test.py --suite memberOf_plugin
        --> Creates a "suite" test named:  memberOf_plugin_test.py
    
**Note** - "suite" tests are for testing functional areas or features, while "ticket" tests are for testing individual bugs.


If setting up a complex replication test, the script structures the deployment in a cascading fashion:

                 master1  <=>  master2
                    
                       hub1  hub2

         consumer  consumer  consumer consumer
    

### The Defaults

lib389 uses many predefined variables to ease test writing.  These are just a few, the complete list is in "**_constants.py**"  in the lib389 framework

- **SUFFIX** or **DEFAULT_SUFFIX**: is set to "**dc=example,dc=com**"
- **DN_DM**: is the Root DN entry: "**cn=directory manager**"
- **PASSWORD**: this is to "**password**" and it is the default for "Directory Manager" and the "Replication Manager"
- **DN_CONFIG** = "**cn=config**"
- **DN_LDBM** = "**cn=ldbm database,cn=plugins,cn=config**"
- **DN_SCHEMA** = "**cn=schema**"
- **LOCALHOST** = "**localhost.localdomain**"
- **HOST_STANDALONE** = "**localhost.localdomain**"
- **PORT_STANDALONE** = **33389**
- **SERVERID_STANDALONE**: this is the server instance identifier "**standalone**"  -> *slapd-standalone*

<br>

## Common Operation Examples:

Here are some examples of common operations that are performed in a test script

### Creating/Deleting Instances

Creating instances takes a few steps listed below

- First, create a new "instance" of a "**DirSrv**" object

      standalone = DirSrv(verbose=False)

- Set up the instance arguments (note - args_instance is a global dictionary in lib389, it contains other default values)

      args_instance[SER_HOST] = HOST_STANDALONE
      args_instance[SER_PORT] = PORT_STANDALONE
      args_instance[SER_SERVERID_PROP] = SERVERID_STANDALONE
      args_instance[SER_CREATION_SUFFIX] = DEFAULT_SUFFIX
      args_standalone = args_instance.copy()

- Allocate the instance - initialize the "**DirSrv**" object with our arguments 

      standalone.allocate(args_standalone)

- Create the instance - this runs setup-ds.pl and starts the server

      standalone.create()

- Open the instance - create a connection to the instance, and authenticates as the Root DN (cn=directory manager)
    
      standalone.open()

- Done, you can start using the new instance

- To remove an instance, simply use:

      standalone.delete()

### Start, Stop, and Restart the Server

    standalone.start(timeout=10)
    standalone.stop(timeout=10)
    standalone.restart(timeout=10)

### Add, Modify, and Delete Operations

    # 
    # Add an entry
    #
    USER_DN = 'cn=mreynolds,%s' % DEFAULT_SUFFIX
    try:
        topology.standalone.add_s(Entry((USER_DN, {
                                  'objectclass': 'top person'.split(),
                                  'cn': 'mreynolds',
                                  'sn': 'reynolds',
                                  'userpassword': 'password'
                                  })))
    except ldap.LDAPError, e:
        log.error('Failed to add user (%s): error (%s)' % (USER_DN, e.message['desc']))
        assert False
    
    #
    # Modify an entry
    #
    try:
        topology.standalone.modify_s(USER_DN, [(ldap.MOD_REPLACE, 'cn', 'Mark Reynolds')])
    except ldap.LDAPError, e:
        log.error('Failed to modify user (%s): error (%s)' % (USER_DN, e.message['desc']))
        assert False

    # 
    # Delete an entry
    #
    try:
        topology.standalone.delete_s(USER_DN)
    except ldap.LDAPError, e:
        log.error('Failed to delete user (%s): error (%s)' % (USER_DN, e.message['desc']))
        assert False

### Search and Bind Operations

By default when an instance is create and opened(standalone.open()), it is already authenticated as the Root DN(Directory Manager).  So you can just start searching without having to "bind"

    #
    # Search - By default we are already authenticated as "cn=directory manager".
    #          We are also only requesting the 'cn' attribute
    try:
        entries = topology.standalone.search_s(DEFAULT_SUFFIX, ldap.SCOPE_SUBTREE, '(cn=*)', ['cn'])
        for entry in entries:
            entry.hasValue('cn', 'Mark Reynolds'):
                log.info('Search found "Mark"')
    except ldap.LDAPError, e:
        log.fatal('Search failed, error: ' + e.message['desc'])
        assert False

    # 
    # Bind - bind as our test entry
    #
    try:
        topology.standalone.simple_bind_s(USER_DN, "password")
    except ldap.LDAPError, e:
        log.error('Bind failed for (%s), error (%s)' % (USER_DN, e.message['desc']))
        assert False

    #
    # Rebind as the Root DN
    #
    try:
        topology.standalone.simple_bind_s(DN_DM, PASSWORD)
    except ldap.LDAPError, e:
        log.error('Bind failed for (%s), error (%s)' % (DN_DM, e.message['desc']))
        assert False


### Plugin Enabling/Disabling

Enable/Disable a plugin.  See **_constants.py** for all the plugin name variables(like PLUGIN_MEMBER_OF)

    topology.standalone.plugins.disable(name=PLUGIN_MEMBER_OF)
    topology.standalone.plugins.enable(name=PLUGIN_MEMBER_OF)


### Adding Tasks

There are some built task functions, that add the task and wait for it to finish.  See tasks.py for all the available Slapi Tasks.

**args{TASK_WAIT: True}** tells the function to wait for the task to complete

    try:
        topology.standalone.tasks.fixupMemberOf(suffix=SUFFIX, args={TASK_WAIT: True})
    except ValueError:
        log.error('Some problem occured with a value that was provided')
        assert False

Here is another way to run a task

    importTask = Tasks(topology.standalone)
    args = {TASK_WAIT: True}
    try:
        importTask.importLDIF(DEFAULT_SUFFIX, None, ldif_file, args)
    except ValueError:
        assert False

### Configuring Replication

After the instance is created, you can enable it for replication and set up a replication agreement.

- Enable replication

      standalone.enableReplication(suffix=DEFAULT_SUFFIX, role=REPLICAROLE_MASTER, replicaId=REPLICAID_MASTER_1)

- Set up replication agreement properties

      properties = {RA_NAME:      r'meTo_$host:$port',
                    RA_BINDDN:    defaultProperties[REPLICATION_BIND_DN],
                    RA_BINDPW:    defaultProperties[REPLICATION_BIND_PW],
                    RA_METHOD:    defaultProperties[REPLICATION_BIND_METHOD],
                    RA_TRANSPORT_PROT: defaultProperties[REPLICATION_TRANSPORT]}

- Create the agreement

      repl_agreement = standalone.agreement.create(suffix=DEFAULT_SUFFIX, host=master2.host, port=master2.port, properties=properties)

    - "**master2**" refers to another, already created, DirSrv instance(like "*standalone*")
    - "**repl_agreement**" is the "DN" of the newly created agreement - this DN is needed later to do certain tasks

- Initialize the agreement, wait for it complete, and test that replication is really working

      standalone.agreement.init(DEFAULT_SUFFIX, HOST_MASTER_2, PORT_MASTER_2)
      standalone.waitForReplInit(repl_agreement)
      if not standalone.testReplication(DEFAULT_SUFFIX, master2):
          # Error
          assert False
    

<br>

## Running Tests

There are two ways to runs the test, run a single test, or test with "**py.test**" which can run all the tests it can find, etc.  See "py.test --help" for more details.

### Running a Single Test

If running the test on an RPM, you need to be root. It will deploy the instance under '/' and run them as user/group 'dirsrv'.
If testing against a specific installation(non-RPM) you need to set the PREFIX to its location: 

Running as a local user against a specific installation location

    PREFIX=/home/mreynolds/install python ./ticket33333_test.py

Running as 'root' against the RPM installation

    python ./ticket33333_test.py


### Running All The Tests

We use "**py.test**" to run multiple tests.  "**py.test**" will select all the files/testcases containing a 'test' string.  Here are few examples

    # This runs all the tests in ds/dirsrvtests/tickets/
    cd ds/dirsrvtests/tickets
    PREFIX=/home/mreynolds/install py.test -v

    # This runs all the tests for debugging: -x -s
    PREFIX=/home/mreynolds/install py.test -v -x -s

    # Run the 'suites' and 'tickets' tests
    cd ds/dirsrvtests/
    PREFIX=/home/mreynolds/install py.test -v

For debugging the tests use "**-x**" and "**-s**"

    py.test -v -x -s

    -x Stops the run when an error occurs
    -s Writes the script output to stdout, instead of suppressing it

<br>

## The Developer Expectation

Run *all* the tests before committing a patch.  Write your own test - the more tests the better.  Let's build quality software with no regressions!

## References

Run "**pydoc lib389**" to see the entire modules documentation

Also checkout the *Upstream Testing Framework* page:

<http://www.port389.org/docs/389ds/FAQ/upstream-test-framework.html

