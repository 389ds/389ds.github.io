---
title: "DB Locks Monitoring"
---

# DB Locks Monitoring
-----------------------

{% include toc.md %}

Purpose
-------

DB lock gets exhausted because of unindexed internal searches (under a transaction). Indexing those searches is the way to prevent exhaustion.
If db lock gets exhausted during a txn, it leads to db panic and the later recovery can possibly fail. That leads to a full reinit of the instance where the db locks got exhausted.

New Config Options (cn=bdb,cn=config,cn=ldbm database,cn=plugins,cn=config)
------------------------------

-   nsslapd-db-locks-monitoring-enable: on\|off (on by default)
-   nsslapd-db-locks-monitoring-threshold: uint32_t (default is 90, value is a percentage between 70 and 95)
-   nsslapd-db-locks-monitoring-pause: uint32_t (default is 500, value is in milliseconds)

Details
-------

At startup, we create a new thread that will monitor the database lock. It will wake up every 0.5 seconds (it's a default value that can be adjusted by nsslapd-db-locks-monitoring-pause) to check if we running out of locks. The thread gets the current consumed locks and the allocated locks (configured), and then it calculates the percentage.

Next thing, it gets nsslapd-db-locks-monitoring-threshold value (90% is the default) and compares it with the calculated result. If the result is not 0 and equal or greater than the configured threshold, the thread sets an internal flag indicating that the threshold is reached (li->li_dblock_threshold_reached = 1).

When the flag is not 0, every search will fail while going through the next candidate (ldbm_back_next_search_entry) so no more locks are consumed until the maximum of locks won't be increased or current locks are released.

Restart is required for the attributes to take into effect - nsslapd-db-locks-monitoring and nsslapd-db-locks-monitoring-threshold.
And nsslapd-db-locks-monitoring-pause can be adjusted online.

It is important to understand that the tunning of these settings are very sensitive.
If you set too long a pause, the server may run out of locks even before the monitoring check will happen, which will result in DB error, and effectively the thread won't make its job.
And if you set too short a pause, it may slow down the server.

Hence, the administrator should be careful with adjusting these settings.

BDB Config Details
--------------

-   nsslapd-db-locks-monitoring-enabled - Enables DB locks monitoring thread;
-   nsslapd-db-locks-monitoring-threshold - Sets a threshold at which the server aborts the search to avoid DB locks exhaustion;

Note: If you set the config using ldapmodify, you must restart the server for the changes to take effect. It's true for both above settings but the setting below can be adjusted without a restart:

-   nsslapd-db-locks-monitoring-pause - Sets an interval time that the thread sleeps between its checks.

