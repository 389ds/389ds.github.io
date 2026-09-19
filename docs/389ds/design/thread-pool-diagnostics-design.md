---
title: "Offline Thread Pool Diagnostics"
---

# Offline Thread Pool Diagnostics
----------------

{% include toc.md %}

Overview
--------

When the worker thread pool is saturated, the server cannot answer a cn=monitor search because the search itself needs a worker thread. So the usual monitoring is unavailable at the moment the administrator needs to see what the pool is doing. The access log does not help much either, because a hung operation only gets its RESULT line after it completes.

This feature lets the administrator inspect the thread pool without an LDAP connection. The server continuously publishes the pool state into a memory mapped file, and a new dsctl action reads that file directly from disk:

```
dsctl localhost thread-pool status
```

The command works while the pool is saturated. It also works when the server is hung or was killed, in which case it reports that the data is a stale snapshot. For the normal case where the server is healthy, cn=monitor gets a new threadpoolworker attribute with a summary of the same data.

Design
------

### The status file

At startup, ns-slapd creates the slapd-INSTANCE.monitor directory in the server run directory, with the status file threadpool inside it (for example /run/dirsrv/slapd-localhost.monitor/threadpool). The file starts with a 4KB header followed by one 64 byte slot per worker thread. The layout is defined in ldap/servers/slapd/threadpool_stats.h, and the lib389 reader mirrors the same field list.

The header is one 4KB page:

```
typedef struct tp_stats_header {
    uint64_t magic;
    uint16_t ver_major;
    uint16_t ver_minor;
    uint32_t header_size;
    uint32_t worker_slot_size;
    uint32_t max_workers;
    uint64_t server_pid;
    uint64_t start_wall_sec;
    uint64_t heartbeat_mono_ns;
    uint64_t heartbeat_wall_sec;
    uint32_t shutdown_clean;
    uint32_t pad0;
    uint64_t cur_work_queue;
    uint64_t max_work_queue;
    uint64_t cur_busy_workers;
    uint64_t max_busy_workers;
    uint64_t ops_initiated;
    uint64_t ops_completed;
    uint64_t cur_connections;
    uint8_t reserved[3976];
} tp_stats_header_t;
```

- magic - "TPOOLST1", written last during initialization
- ver_major, ver_minor - format version, see Format versioning below
- header_size, worker_slot_size - the reader validates these and uses them for all offsets, instead of its own compiled-in constants
- max_workers - number of worker slots that follow the header
- server_pid, start_wall_sec - identity of the writing server
- heartbeat_mono_ns, heartbeat_wall_sec - liveness signal, updated every second
- shutdown_clean - set during clean shutdown before the unlink; a leftover file with this flag unset came from a crash
- cur_work_queue ... cur_connections - the pool gauges: current and maximum work queue size, current and maximum busy workers, operations initiated and completed, and current connections
- reserved - pads the header to one page

Each worker slot is one cache line:

```
typedef struct __attribute__((aligned(64))) tp_worker_slot {
    uint32_t state;
    uint32_t op_tag;
    uint64_t conn_id;
    uint64_t op_id;
    uint64_t start_ns;
} tp_worker_slot_t;
```

- state - unused, idle, busy or exited
- op_tag - the LDAP request tag of the operation being processed (bind, search, modify, ...)
- conn_id, op_id - the connection and operation the worker is serving
- start_ns - CLOCK_MONOTONIC start time of the current operation; nonzero means an operation is in flight (op_id cannot serve as that flag, because 0 is a valid operation id)

The alignment pads the slot to 64 bytes, so each worker writes into its own cache line. Both sizes are locked with _Static_assert in threadpool_stats.h.

The file is only meant to be read on the machine it was written on. All values are fixed width host-endian integers. It contains no DNs, filters, IP addresses or any other request content, only operation metadata.

### Format versioning

The header starts with the magic value and a major and minor format version, followed by the header size and the slot size. dsctl validates all of them before parsing anything, so a file it does not fully understand is refused with an unsupported-version error rather than misread. The major version governs compatibility; the minor version identifies the revision.

The file itself never needs migration, because it is created at startup and removed on clean shutdown. Version skew is still possible: the package can be upgraded while the old server keeps running, and a preserved crash file from an older server can be read later with --file. When the format changes, the major version is bumped. An older dsctl then refuses the newer file with a clear error, and a newer dsctl keeps the parser for the earlier major versions, so live files and crash archives written by older servers stay readable.

### Writing the data

The pool gauges already exist as internal counters. Once per second, a callback on the event queue thread copies them into the header and updates the heartbeat timestamp. The event queue thread is not a worker thread, so the heartbeat keeps running when all the workers are busy. When the whole process stops making progress, the heartbeat stops updating, and the reader uses that to warn that the server may be stalled.

The worker slots are updated by the workers themselves, with atomic stores, at the same places in connection.c where the busy worker counters are maintained. The start time field also serves as the "operation in flight" flag, because operation id 0 is a valid value (the first operation on a connection).

The magic value is written last during initialization, so the reader never sees a half initialized file. On clean shutdown the file is removed; the monitor directory stays. After a crash or kill the file stays behind, and the next startup preserves it instead of overwriting it: the leftover is renamed to threadpool.YYYYMMDD-HHMMSS in the same directory (the same naming the log rotation uses) and the five newest archives are kept. Only a leftover from an unclean shutdown is preserved, and there is no configuration option for this. If the file cannot be preserved, it is removed as before.

The run directory is writable by the service user, so both the directory and the file are created carefully. The monitor directory is created with mode 0750 and, when it already exists, it must be a real directory owned by the server. Any stale file at the file path is removed first, the file is opened with O_EXCL and O_NOFOLLOW and mode 0640, and the result is verified to be a regular file owned by the server. If any of this fails (for example SELinux denies removing a symlink someone planted at the path), the feature is disabled with a warning in the errors log and the server starts normally without it. The disk space for the file is reserved up front, so a full filesystem cannot crash the server later when a worker writes into an unbacked page.

No selinux-policy change is needed for the new directory. The run directory is labeled dirsrv\_var\_run\_t, the monitor directory and status file created inside it inherit that label, and the existing policy already allows ns-slapd to manage directories and files of that type. The dirsrv file context pattern also covers the new path, so a relabel keeps the label correct. If a policy denial does occur anyway, it lands in one of the failure paths above: the feature is disabled with a warning and the server starts normally.

### Reading the data

dsctl finds the file through nsslapd-rundir in the instance dse.ldif, maps it read only, and validates the magic, version, header size, slot size and worker count before parsing anything. A file that fails validation is refused. The file mode is 0640, so the command must run as root or as a member of the server's group.

The reader also checks whether the data can be trusted. The pid in the header must belong to a running ns-slapd process, otherwise the data is reported as a stale snapshot from a crashed or killed server. If the heartbeat is older than 30 seconds while the process is alive, dsctl warns that the server may be stalled. And nsslapd-threadnumber from dse.ldif is compared with the worker count in the file, to catch a changed thread number that was not restarted into effect. All of these produce warnings, not errors, and the data is still printed.

When the file does not exist, dsctl explains why: the instance is not running (the file is removed on clean shutdown), or the feature is disabled by nsslapd-thread-pool-stats.

A preserved crash file can be read with the --file option, and the same pid and heartbeat warnings apply to it. When crash archives exist, the normal status output points at the newest one:

```
dsctl localhost thread-pool status --file /run/dirsrv/slapd-localhost.monitor/threadpool.20260707-153042
```

### cn=monitor

cn=monitor returns one threadpoolworker value per active worker, read from the same mapped region:

```
threadpoolworker: worker=1 state=busy op=search duration_ns=8824373
threadpoolworker: worker=2 state=busy op=search duration_ns=1721985
threadpoolworker: worker=3 state=idle op= duration_ns=0
threadpoolworker: worker=4 state=busy op=add duration_ns=16733782
```

cn=monitor is readable by anonymous users in default deployments, so these values only contain the state, the operation type and the duration. The connection and operation ids are only available through dsctl.

The values are space separated key=value tokens, and later versions may append new tokens, so consumers should parse them by name rather than by position or count.

Usage
-----

```
Instance: standalone1
Path: /run/dirsrv/slapd-standalone1.monitor/threadpool
PID: 64442
Uptime: 57.000s
Heartbeat age: 0.737s
Workers: 4/4 busy (max 4)
Queue: 7 current (max 12)
Operations: 5299 initiated, 5288 completed
Current connections: 10

IDX STATE    OP                 CONN        OP-ID     DURATION
    1 BUSY     UNBIND             1157            1       14.6ms
    2 BUSY     SEARCH             1161            0        8.9ms
    3 BUSY     SEARCH                5          388       12.8ms
    4 BUSY     SEARCH                6          387       10.6ms
```

Configuration
-------------

The feature is enabled by default. One new cn=config attribute controls it:

```
nsslapd-thread-pool-stats: on\|off (on by default)
```

A restart is required for a change to take effect, because the value is read once when the file is created at startup. An online change is accepted, and the server notes in the operation result and the errors log that a restart is required. dsctl thread-pool status also warns when the running state does not match the configured value.

There is no sizing option. The file size follows nsslapd-threadnumber: a 4KB header plus 64 bytes per worker, which is around 6KB for a 32 thread server.

External Impact
---------------

cn=monitor gets the new threadpoolworker attribute. There is no other impact to other components.

Origin
------

https://github.com/389ds/389-ds-base/issues/7633

Author
------

<spichugi@redhat.com>
