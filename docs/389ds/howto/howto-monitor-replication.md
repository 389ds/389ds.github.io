---
title: "Howto: Monitor Replication"
---


# How to Monitor Replication Using CLI
----------------------

### Basic Usage

CLI tool dsconf has the option for monitoring replication in the topology of the specified instance. It walks through the initial instance agreements and generates the in-progress status of replication.
The main command for creating a report is:

    dsconf ldap://server1.example.com:38901 -D "cn=Directory Manager" -w password replication monitor

    Additional arguments:
      -c or --connections [CONNECTION [CONNECTION ...]]
            The connection values for monitoring other not
            connected topologies. The format:
            'host:port:binddn:bindpwd'. You can use regex for host
            and port. You can set bindpwd to * and it will be
            requested at the runtime or you can include the path
            to the password file in square brackets - [~/pwd.txt]
      -a or --aliases [ALIAS [ALIAS ...]]
            If a host:port is assigned an alias, then the alias
            instead of host:port will be displayed in the output.
            The format: alias=host:port


### Dealing With Credentials

While walking through the topology, we can encounter other instances and the tool needs the binding credentials.

The replication monitor will look into different sources while trying to get them. It is done in this order:

1. First, we look at the CLI arguments (--connections and --aliases). We prioritize this if specified.
2. We check `~/.dsrc` file.
3. And only if moth previous sources didn't give the result - we ask the user for the input interactively.


### Config file format

The config file `~/.dsrc` is already used for CLI tools. Replication monitor adds two more sections:

        [repl-monitor-connections]
        connection1 = server1.example.com:38901:cn=Directory manager:*
        connection2 = server2.example.com:38902:cn=Directory manager:[~/pwd.txt]
        connection3 = hub1.example.com:.*:cn=Directory manager:password

        [repl-monitor-aliases]
        M1 = server1.example.com:38901
        M2 = server2.example.com:38902

For the `[repl-monitor-connections]` section, only the values matter. You can name the keys as you want.

The * password will request the caller to type it manually.

The password file should have one line with a clear-text password and it should be accessible by the `dsconf` caller.

The aliases are used in the report and they name the specified instances.


### Report Example

    Supplier: M1 (server1.example.com:38901)
    ------------------------------
    Replica Root: dc=example,dc=com
    Replica ID: 2
    Max CSN: 5d820f99000000020000

    Status For Agreement: "to2" (server2.example.com:38902)
    Replica Enabled: on
    Update In Progress: FALSE
    Last Update Start: 20190923231259Z
    Last Update End: 20190923231259Z
    Number Of Changes Sent: 0
    Number Of Changes Skipped: None
    Last Update Status: Error (0) Replica acquired successfully: Incremental update succeeded
    Last Init Start: 19700101000000Z
    Last Init End: 19700101000000Z
    Last Init Status: unavailable
    Reap Active: 0
    Replication Status: In Synchronization
    Replication Lag Time: 00:00:00

    Status For Agreement: "to3" (hub1.example.com:38903)
    Replica Enabled: on
    Update In Progress: FALSE
    Last Update Start: 19700101000000Z
    Last Update End: 19700101000000Z
    Number Of Changes Sent: 0
    Number Of Changes Skipped: None
    Last Update Status: Error (0) No replication sessions started since server startup
    Last Init Start: 19700101000000Z
    Last Init End: 19700101000000Z
    Last Init Status: unavailable
    Reap Active: 0
    Replication Status: In Synchronization
    Replication Lag Time: 00:00:00

    Supplier: M2 (server2.example.com:38902)
    ------------------------------
    Replica Root: dc=example,dc=com
    Replica ID: 3
    Max CSN: 5d81ffc0000000030000

    Status For Agreement: "to1" (server1.example.com:38901)
    Replica Enabled: on
    Update In Progress: FALSE
    Last Update Start: 20190923231301Z
    Last Update End: 20190923231301Z
    Number Of Changes Sent: 3:11/0
    Number Of Changes Skipped: None
    Last Update Status: Error (0) Replica acquired successfully: Incremental update succeeded
    Last Init Start: 19700101000000Z
    Last Init End: 19700101000000Z
    Last Init Status: unavailable
    Reap Active: 0
    Replication Status: Not in Synchronization: supplier (5d81ffc0000000030000) consumer (Unavailable) Reason(Unknown)
    Replication Lag Time: Unavailable

    Status For Agreement: "to3" (hub1.example.com:38903)
    Replica Enabled: on
    Update In Progress: FALSE
    Last Update Start: 19700101000000Z
    Last Update End: 19700101000000Z
    Number Of Changes Sent: 0
    Number Of Changes Skipped: None
    Last Update Status: Error (0) No replication sessions started since server startup
    Last Init Start: 19700101000000Z
    Last Init End: 19700101000000Z
    Last Init Status: unavailable
    Reap Active: 0
    Replication Status: Not in Synchronization: supplier (5d820f99000000020000) consumer (5d81ffc0000000030000) Reason(Unknown)
    Replication Lag Time: 01:07:37

    Supplier: hub1.example.com:38903
    -----------------------
    Status: Unavailable
    Reason: Invalid credentials

