---
title: "Howto:DumpRestoreChangelog"
---

# Dump and Restore Change Log using CLI
------------------------

{% include toc.md %}

### Introduction

Previously, we had a tool called `cl-dump` that allowed us to dump change log to a separate file and decrypt it.
The new tool supports the same functionality and even more.

Dump Change Log
===============

The simpliest way to dump the change log to STDOUT can be achieved as follows:

    dsconf ldap://server1.example.com:38901 -D "cn=Directory Manager" -w password replication dump-changelog

It will print the decrypted change log to STDOUT and it will remove the original dumped file (which appears after we run the task on replica entry).

Additionally, we can save the output to a file, preserve the generated LDIF file, get CSN only, decrypt an existing LDIF file and specify a set of replica roots so only them are dumped.

    usage: dsconf instance replication dump-changelog [-h] [-c] [-l]
                                                      [-i CHANGELOG_LDIF]
                                                      [-o OUTPUT_FILE]
                                                      [-r REPLICA_ROOTS [REPLICA_ROOTS ...]]

    optional arguments:
      -h, --help            show this help message and exit
      -c, --csn-only        Dump and interpret CSN only. This option can be used
                            with or without -i option.
      -l, --preserve-ldif-done
                            Preserve generated ldif.done files from changelogdir.
      -i CHANGELOG_LDIF, --changelog-ldif CHANGELOG_LDIF
                            If you already have a ldif-like changelog, but the
                            changes in that file are encoded, you may use this
                            option to decode that ldif-like changelog. It should
                            be base64 encoded.
      -o OUTPUT_FILE, --output-file OUTPUT_FILE
                            Path name for the final result. Default to STDOUT if
                            omitted.
      -r REPLICA_ROOTS [REPLICA_ROOTS ...], --replica-roots REPLICA_ROOTS [REPLICA_ROOTS ...]
                            Specify replica roots whose changelog you want to
                            dump. The replica roots may be seperated by comma. All
                            the replica roots would be dumped if the option is
                            omitted.


Restore Change log
==================

As a new feature, now we can retore the dumped change log back to the instance.

There are two options available:

1. We can restore already dumped change log LDIF files that are in change log directory and they begin with a replica name in the filename.
   It can be done like this:

       dsconf localhost replication restore-changelog from-changelogdir dc=example,dc=com dc=example2,dc=com

2. Also, we can restore the change log LDIF file directly. We have to specify the replica root or replica name (basically, the name we get after 'dump change log operation') should be in the beginning of the filename.

       dsconf localhost replication restore-changelog from-ldif ./d3de3e8d-446611e7-a89886da-6a37442d.ldif

