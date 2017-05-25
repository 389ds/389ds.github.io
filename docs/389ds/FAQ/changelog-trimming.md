---
title:  "Maintaining Replication Changelog Size"
---

# Maintaining Replication Changelog Size
------------


{% include toc.md %}

## Overview

By default the Replication Changelog does not use any trimming by default.  This means the Replication Changelog will always continue to grow in size.  There are several way to help keep the changelog from growing too large.  We will discuss the various settings to control the changelog size, and how to use them under certain circumstances.

## Changelog Trimming Configuration Settings
------------------------------

There are several configuration settings under **cn=changelog5,cn=config** that control change trimming and compaction

- nsslapd-changelogmaxentries
- nsslapd-changelogmaxage
- nsslapd-changelogcompactdb-interval
- nsslapd-changelogtrim-interval


### nsslapd-changelogmaxage

This setting controls what entries, or "changes", to trim based on the age of the "change".  This ideally should match the replication purge delay under normal circumstances.

### nsslapd-changelogmaxentries

This setting controls how many entries, or "changes", that are stored in the replication changelog.  It is better to use "max age", than "max entries" as we want to match our "max age" with the replication purge delay.  The purpose of the replication purge delay is for resolving replication conflicts as part of the server's "Update Resolution Protocol", or URP.  If the changelog trims entries that URP needs to use to resolve a conflict then replication will break.  So you really want to keep these settings in sync.

For more information on the Replication Purge Delay please see this doc:

<https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/configuration_command_and_file_reference/core_server_configuration_reference#Replication_Attributes_under_cnreplica_cnsuffixName_cnmapping_tree_cnconfig-nsDS5ReplicaPurgeDelay>


### nsslapd-changelogcompactdb-interval

This controls how often the server will "compact" the changelog.  Currently with libdb when records are removed from the database, like from changelog trimming, it does not actually free up disk space.  Only when the database is "compacted" will it free up the unused slots.  By default we compact the replication changelog database every 30 days.  This is can be adjusted used this setting, and it takes the value in seconds.  This does require a server restart to take effect.

### nsslapd-changelogtrim-interval

This controls how often we look for entries to be trimmed from the replication changelog database.  The default is 5 minutes(300 seconds), but for one time cleanups it can be reduced.  This settings does not require a server restart to take effect.

<br>

## Configuring The Changelog
------------------------
So lets bring all these settings into perspective.  There are two scenarios to consider...

### Changelog is huge, fix it now!

In this case we need to temporarily set aggressive values to get the changelog to a reasonable size.  So in this case we would want to use the following settings:

```
dn: cn=changelog5,cn=config
nsslapd-changelogmaxage: 3d
nsslapd-changelogcompactdb-interval: 300
nsslapd-changelogtrim-interval: 30
```

These settings will remove any "changes" that are older than 3 days, and it should trim the entries, and then compact db within 5 minutes.  Remember to restart the server after making these config changes.  Once the changelog size has been reduced, then you should set the values as described in the next section.

### Suggested Changelog Trimming Settings

These are the settings you should use under normal circumstances.  The most important setting here is the *nsslapd-changelogmaxage*, the other settings listed below use the default values.  By default the replication purge delay is 7 days, so we will use that value for our "max age" in this example.  However, if your replication purge delay is different then your *nsslapd-changelogmaxage* then it should match it.

```
dn: cn=changelog5,cn=config
nsslapd-changelogmaxage: 7d
nsslapd-changelogcompactdb-interval: 2592000
nsslapd-changelogtrim-interval: 300
```

For more on the Replication Purge Delay please see this document:

<https://access.redhat.com/documentation/en-us/red_hat_directory_server/10/html/configuration_command_and_file_reference/core_server_configuration_reference#Replication_Attributes_under_cnreplica_cnsuffixName_cnmapping_tree_cnconfig-nsDS5ReplicaPurgeDelay>




