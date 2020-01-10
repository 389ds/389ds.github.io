---
title: "Monitor Replication Design Page"
---

# Monitor Replication with CLI and Web Console
----------------------------------------------

{% include toc.md %}

Overview
========

We should be able to monitor multi-master replication topologies, its lag times and other agreement parameters. It should include even complex situations with chains of different instances where M1 -> M2 -> M3 but M1 is not replicated directly to M3.

This document is concentrated on describing the logic behind the replication report generation.

Use Cases
=========

This feature can be used through CLI and Web UI. The monitoring feature is specifically very useful when you have a topology with more than 2 replicas.

Design
======

Initialize the report generation
--------------------------------

To generate replication report we should run the CLI command:

    dsconf ldap://server1.example.com:38901 -D "cn=Directory Manager" -w password replication monitor

You can also supply credentials (`-c`) and/or aliases (`-a`).

Also, we can run the report from Web Console - Monitoring tab -> Replication -> Sync Report -> Generate Report button.

It will initiate the process during which the program will go through the replication topology and print agreement and replica details.

Command Line Function
---------------------

The replication monitor structure is constructed out of three elements:

### Get Credentials Function

This function is called when we need to determine credentials for 'host:port' pair. It checks if the credentials were already supplied and if not, it requests user to provide it.

### Main Generate Report Function

The function can be called as this:

    repl_monitor = ReplicationMonitor(inst)
    report_dict = repl_monitor.generate_report(get_credentials)

`get credentials` function should be supplied as a parameter here.
And then, the method returns a dictionary with the report data. 

`ReplicationMonitor` object can be used in any other scripts when we need to get a full topology report.

### Format The Report Data

Next and final thing, we should format the data so the user can easily view it.
It has two options here:

1. Make a JSON output out of the data and print it directly. We need the JSON for Web Console processing.

2. Print the data in a formatted maner to STDOUT.

Logic Flow
----------

The main logic happens in `generate_report()` function:

1. First, we get the replication data for the initial instance (the one we run CLI or UI from). It incudes agreements and relpica.

2. We store the data in a dictionary as our_dict["host:port:protocol"] = data

3. As we discover new agreements, we set the host information as a key but we set the value to `None`

4. Then, run though the items that don't have the values and trying to get the credentials for them using our supplied `get_credentials` function

5. Is the credentials are valid, we connect to the instance and get the replication data which we assign as the repication report dictionary value. The new list of agreements is assigns the same was as in `Step 3`

6. When we finish running through the list and eveything is processed, we remove `:protocol` from the repoication report dictionary keys.

7. And finally, we return the dictionary.

Web Console Implementation Details
----------------------------------

The Sync Report tab is dony with ReactJS. It copies CLI tool functionality with a small differences:

- Credentials and Aliases CLI parameters are supplied trough tables;

- The report is printed in tro variants: one table report (so it's easier to see and sort all of the lag times and other values;

- The report can be automatically refreshed by checking `Refresh` checkbox and setting Timeout in seconds.

Origin
======

- https://pagure.io/389-ds-base/issue/50545

- https://pagure.io/389-ds-base/pull-request/50614

- https://pagure.io/389-ds-base/pull-request/50733

Author
=====

<spichugi@redhat.com>
