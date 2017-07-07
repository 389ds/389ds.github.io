---
title: "How To Setup SLAMD"
---

# How To Setup SLAMD
----------------

This document gives a general overview of setting SLAMD, and creating a modrate slamd job

## Get SLAMD
------------

Download slamd 2.0.1 [here]({{ site.baseurl }}/binaries/slamd-2.0.1.zip)

## Setup SLAMD
--------

- Get slamd-2.0.1.zip  ( I can provide this if you would like)
- unzip **slamd-2.0.1.zip**
- cd slamd
- unzip **slamd_client-2.0.1.zip**
- unzip **slamd_monitor_client-2.0.1.zip**
- Set the proper hostname in these files

    - slamd_client/slamd_client.conf
        - SLAMD_ADDRESS

    - conf/server.xml
        - **defaultHost="localhost"**
        - **ldapHost="localhost"**

- bin/startup.sh
- slamd_client/start_client.sh


## Configure a Job
---------------------

This is just an example for setting u pa simple modrate job

- Goto http://localhost:8080 - and create a modrate job
- Set threads to 50, duration to 60 seconds, set the entry dn's, etc. 
- Click "Schedule Job", andwait for the results
- To run the job again, just "*Clone*" it, and schedule the job again
