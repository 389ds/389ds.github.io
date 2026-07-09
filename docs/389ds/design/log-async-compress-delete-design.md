---
title: "Asynchronous log rotation and compression design"
---

# Asynchronous log rotation and compression
----------------

Overview
--------

389 Directory Server rotates log files when size or time thresholds are reached.
When log compression is enabled (`nsslapd-*log-compress: on`), each rotated file
is gzip-compressed before the server resumes writing to the new active log.

Today, compression runs inside `log__open_*logfile()` in `ldap/servers/slapd/log.c`
while the per-stream **write lock** is held (`LOG_*_LOCK_WRITE()`). On large
installations, compressing a multi-gigabyte access or audit log can take minutes.
During that interval every thread that needs to write to that log stream blocks,
which degrades LDAP throughput and can look like a server hang.

This design moves **compression** and **post-rotation retention cleanup** off the
write-lock path onto a single background worker thread (`log_maint`). The **file
swap** portion of rotation (close, rename, open new active file) remains synchronous
so new entries never land in a file that is being archived.

The change is internal to `ns-slapd`. No new configuration attributes, log formats,
or operator workflows are introduced.

Related reading:

- `ldap/servers/slapd/log.c`, `log.h` — logging and rotation implementation
- `specs/391-async-log-rotation/` — feature spec, plan, and lock contracts
- [Log compression](https://www.port389.org/docs/389ds/howto/howto-log-compression.html) (operator how-to)

Use Cases
---------

### Production server under load with a large access log

An instance has `nsslapd-accesslog-compress: on` and a 2 GB access log. Rotation
fires because `nsslapd-accesslog-maxlogsize` was exceeded.

**Before:** All access-log writes (and anything that flushes the access buffer)
block until gzip finishes. LDAP clients see elevated latency across the board.

**After:** The server closes `access`, renames it to `access.YYYYMMDD-HHMMSS`,
opens a new `access`, and releases the write lock in milliseconds. LDAP traffic
continues logging to the new file while the `log_maint` worker compresses the
archived file in the background. Operators eventually see `access.YYYYMMDD-HHMMSS.gz`
appear in the log directory.

### Multiple log types rotating at the same time

During a busy period, access, audit, and error logs all rotate within the same
minute, each with compression enabled.

All streams share one maintenance worker (`log_maint`) and a single global FIFO
queue. Jobs from every stream are processed in enqueue order, one at a time.
A large access-log compress therefore delays audit or error compress jobs behind
it, but LDAP write paths are unaffected because rotation swap remains synchronous.

### Compression failure (disk full)

A rotated security log cannot be gzip-compressed because the filesystem is full.

The worker leaves the uncompressed `security.YYYYMMDD-HHMMSS` file on disk, writes
an error-log entry naming the stream, path, and errno, and does not affect the
active `security` log. Operators can free space and rely on the uncompressed
archive for troubleshooting.

### Server shutdown during background compression

An administrator runs `systemctl stop dirsrv@instance` while a 4 GB audit log is
mid-compress.

Shutdown calls `logs_maintenance_shutdown()` before the final `logs_flush()`. The
process blocks until all queued and in-progress maintenance jobs finish, then
flushes buffers and exits. No partial `.gz` file is left without a corresponding
error message.

Design
------

### Scope of synchronous vs asynchronous work

| Phase | Where it runs | Lock held |
|-------|---------------|-----------|
| Pre-swap delete when at `maxnumlogs` | Rotation path (sync) | Write lock |
| Close active fd, `PR_Rename`, update `LogFileInfo` chain | Rotation path (sync) | Write lock |
| Open new active fd, write `*.rotationinfo` | Rotation path (sync) | Write lock |
| gzip archived file | Maintenance worker (async) | None (runs outside write lock) |
| Update `l_compressed`, rewrite `*.rotationinfo` | Maintenance worker (async) | Brief write lock |
| Retention sweep (expiration / disk policy) | Maintenance worker (async) | Brief write lock |


### Maintenance subsystem

One `PR_USER_THREAD` worker (`log_maint`) is created at logging init
(`logs_maintenance_init()` from `g_log_init()`). It serves all five log streams.

| Component | Scope |
|-----------|-------|
| `log_maint` thread | Global — one compress/retention job at a time |
| Pending list | Per stream — staged during rotation while write lock is held |
| FIFO queue | Global — protected by one `PRLock` + `PRCondVar` |

Each stream still owns a **pending list** for jobs staged during rotation. On
`LOG_*_UNLOCK_WRITE()`, `log_maint_submit_pending()` moves that stream's pending
jobs onto the global queue and wakes the worker.

The worker dequeues jobs (briefly holding the global queue lock), runs
`compress_log_file()` without any log write lock held, then calls
`log_maint_after_compress()` for the job's stream.

### Key helpers

| Function / symbol | Role |
|-------------------|------|
| `log_maint_schedule_compress()` | Stage a compress job on the stream pending list during rotation |
| `log_maint_submit_pending()` | Move pending jobs to the global queue; called from `LOG_*_UNLOCK_WRITE()` |
| `log__write_rotationinfo(logtype)` | Rewrite `*.rotationinfo` for any stream (unified; replaces per-stream writers) |
| `log__update_logentry_compressed_size()` | Refresh chain entry size from the `.gz` file on disk |
| `log__delete_*_logfile(bool at_rotation)` | Delete oldest rotated log when policy requires it |
| `LOG_DELETE_AT_ROTATION` | `true` — rotation preamble; enforce `maxlogsperdir` via `++numoflogs` |
| `LOG_DELETE_RETENTION` | `false` — post-compress sweep; expiration and disk policies only |

`LogFileInfo.l_compressed` is a `bool`. Delete paths use `l_compressed` to select
the uncompressed or `.gz` filename when calling `PR_Delete()`.

### Rotation and enqueue flow

```text
Worker / flush thread                    Maintenance worker
─────────────────────                    ────────────────────
LOG_*_LOCK_WRITE()
  while (log__delete_*(LOG_DELETE_AT_ROTATION))  [maxnumlogs + policies]
  PR_Close(active)
  PR_Rename → access.TIMESTAMP
  append LogFileInfo (l_compressed=false)
  log_maint_schedule_compress()  → pending list
  PR_Open(new active)
  write access.rotationinfo  [chain may include pending compress]
LOG_*_UNLOCK_WRITE()
  log_maint_submit_pending()     → move pending → queue, wake worker

                                         compress_log_file(path)   [no write lock]
                                         LOG_*_LOCK_WRITE()
                                           entry->l_compressed = true
                                           update .gz size in chain
                                           log__write_rotationinfo(logtype)
                                           while (log__delete_*(LOG_DELETE_RETENTION))
                                         LOG_*_UNLOCK_WRITE()
```

`log__delete_*_logfile()` takes a `bool at_rotation` argument using the constants
defined in `log.h`:

- **`LOG_DELETE_AT_ROTATION`** (rotation preamble): applies the `++numoflogs` check against
  `maxlogsperdir` because a new rotated file is about to be added to the chain.
- **`LOG_DELETE_RETENTION`** (post-compress retention): skips the max-log count check;
  only expiration, `maxdiskspace`, and `logminfreediskspace` can trigger deletion.
  This matches pre-async behavior where max-log enforcement happened only at rotation
  time, not again after inline compression finished.

Each successful delete (either context) rewrites `*.rotationinfo` so the metadata
file stays aligned with files on disk. Without this, async compression left stale
entries (including `.gz` suffix and compressed size) and listed logs that had
already been removed.

`LOG_*_UNLOCK_WRITE()` macros in `log.h` call `log_maint_submit_pending()` after
releasing the write lock so pending jobs are handed off without holding both lock
tiers at once.

`compress_log_file()` is only invoked from the maintenance worker, never from the
rotation path.

### Lock discipline

Two lock tiers:

1. **Write lock** — existing `LOG_*_LOCK_WRITE()` / error `Slapi_RWLock`; protects
   active fd, buffer, and synchronous rotation.
2. **Maintenance lock** — single global `PRLock` on the job queue; protects queue
   state and worker coordination.

Rules:

- Never call `compress_log_file()` while holding a write lock.
- Never hold write lock and the maintenance lock at the same time.
- Archived `LogFileInfo` updates (`l_compressed`, compressed size) and
  `*.rotationinfo` rewrites happen in `log_maint_after_compress()` while the
  write lock is held, after compress succeeds on disk.

### `*.rotationinfo` consistency

Rotation writes `*.rotationinfo` synchronously when opening the new active log.
That snapshot may list rotated files as uncompressed (`l_compressed=false`) until
the maintenance worker finishes gzip.

After compress completes, `log__write_rotationinfo()` rewrites the file under
the write lock: entries gain a `.gz` suffix when `l_compressed` is set, sizes
reflect the compressed file (via `log__update_logentry_compressed_size()`), and
the active-log header is unchanged.

If retention deletes a rotated file, the same helper runs again so removed logs
disappear from `*.rotationinfo` immediately — not only on the next rotation.

### Overlapping rotations

If a second rotation occurs before the first archived file finishes compressing,
a second compress job is appended to the global FIFO. Jobs run in order;
duplicate paths in a stream's pending list are ignored.

### Failure handling

On compress failure the worker:

1. Retains the uncompressed rotated file.
2. Logs to the error log: `Log maintenance failed: stream=<name> file=<path> reason=...`
3. Does not disable or block the active log stream.

### Shutdown

In `daemon.c`, before the final `logs_flush()`:

1. `logs_maintenance_shutdown()` — flush pending jobs to the global queue, set
   shutdown flag, `PR_JoinThread` on the worker after the queue drains.
2. `logs_flush()` — existing buffer flush to active logs.
3. Continue plugin/backend teardown.

### Files touched

| File | Change |
|------|--------|
| `ldap/servers/slapd/log.c` | Single maintenance worker; global job queue; per-stream pending lists; `log__write_rotationinfo()` and `LOG_DELETE_*` retention semantics |
| `ldap/servers/slapd/log.h` | `LOG_*_UNLOCK_WRITE` submits pending jobs; `LogFileInfo.l_compressed` is `bool`; `LOG_DELETE_AT_ROTATION` / `LOG_DELETE_RETENTION` |
| `ldap/servers/slapd/daemon.c` | `logs_maintenance_shutdown()` on stop |
| `ldap/servers/slapd/proto-slap.h` | `logs_maintenance_init` / `logs_maintenance_shutdown` prototypes |


### Testing

| Test | Purpose |
|------|---------|
| `dirsrvtests/.../logging_compression_test.py` | End-to-end rotation, compress, deletion (polls for async `.gz`) |
| `dirsrvtests/.../log_flush_rotation_test.py` | No write pileup under compression |

Major configuration options and enablement
------------------------------------------

No new configuration attributes.

Origin
-------------

RFE: move server log compression off the write-lock path (branch `391-async-log-rotation`).

Author
------

Mark Reynolds <mreynolds@redhat.com>

