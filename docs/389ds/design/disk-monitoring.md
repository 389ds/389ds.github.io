---
title: "Disk Monitoring"
---

# Disk Space Monitoring
-----------------------

{% include toc.md %}

Purpose
-------

If available disk space gets critical this feature will shutdown the slapd process. This is to prevent the slapd process from crashing, and possibly corrupting the db.

New Config Options (cn=config)
------------------------------

-   nsslapd-disk-monitoring: on\|off (off by default)
-   nsslapd-disk-monitoring-threshold: long (default is 2mb, value is in bytes)
-   nsslapd-disk-monitoring-grace-period: int (60 minutes by default)
-   nsslapd-disk-monitoring-logging-critical: on\|off (off by default)

Details
-------

At startup we create a new thread that will wake up every 10 seconds to check the available disk space on the disks/mount points that the DS is using. By default we only check the config, txn log directory, and db directories. If logging is critical to the deployment, and "nsslapd-disk-monitoring-logging-critical" is set, then we will also check the disks used for logging. Meaning, that if a log directory gets full, we will also shutdown the slapd process.

Once the available disk space on any of the disks gets below the threshold we start taking action. If "nsslapd-disk-monitoring-readonly-on-threshold" is set, then we put all of the main data backends to read-only mode. If verbose error logging is enabled we turn it off. If logging is not critical, then we disable access & audit logging. On the next pass, if we continue to lose disk space, then we will delete all the rotated logs.

We will keep logging messages if the disk space continues to drop. If we get to the halfway point of the threshold, we go into shutdown mode.

Once in shutdown mode, we log another message warning that we will shutdown the process if disk space is not freed up within the grace period. If disk is freed up above the threshold, then we abort the shutdown, and enable any logging that we disabled. If it is not, then we shut slapd down.

And if we try to start up the server while the disk space is still below the halfway point of the threshold, it won't be allowed to start.

Note - if at any point we get below 4k, we immediately shutdown.

Config Details
--------------

-   nsslapd-disk-monitoring: - Enables disk space monitoring
-   nsslapd-disk-monitoring-threshold - The available disk space, in bytes, that will trigger the process. Default is 2mb. If we get below half of the threshold, 1 mb in this case, then we enter the shutdown mode.
-   nsslapd-disk-monitoring-readonly-on-threshold - If this is set, put all of the main data backends to read-only mode once threshold is reached.
-   nsslapd-disk-monitoring-grace-period - How many minutes to wait to allow an admin to clean up disk space before shutting slapd down. The default is 60 minutes.
-   nsslapd-disk-monitoring-logging-critical - If this is set, we can go into shutdown mode if any of the log disks pass the halfway point of the threshold. We will also not disable logging or delete rotated logs when this is set.

Note: If you set the config using ldapmodify, you must restart the server for the changes to take effect.

