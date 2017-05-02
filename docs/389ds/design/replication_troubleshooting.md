---
title: "Replication Troubleshooting"
---


{% include toc.md %}

# Overview

TBD

# Use Case

TBD



# Design

## Replication basics

Replication contains two parts

The first part (named *Replica*) is responsible to process received update and record them into a changelog. The second part (*replicat agreement*) is responsible to send updates from one server, acting as supplier, to another server acting as a consumer.

*Replica* and *replica agreement* are sharing few structures:

- changelog: this is a dedicated database when updates are stored in chronological way
- **Local** RUV (aka replication update vector) it contains the state of local replica. The state being the **CSN** of the latest update it **directly** received, and the **CSNs** of the lastest updates the remote replicas received and sent to the server.

## CSN

A csn is basically a timestamp concatenated with the identifier of the replica where the timestamp was generated.

A csn can look like: 590891180001001a0000. 590891180001 is the timestamp and 001a the identifier of the replica

## RUV


# Major Configuration options

None

# Replication


# updates and Upgrades


# Dependencies

None
