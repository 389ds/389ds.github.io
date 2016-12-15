---
title: "Web Console Feature Roadmap"
---


# 389 Web-Based Administration Server - Feature Roadmap
--------------------------------

The goal of the new UI is making managing a very large number of Directory Servers easy.  We change our perspective from the old console, where everything was central to a single instance, to a global view of the "Directory Service". 

## Overview of Major UI Features
--------------------------------

- Configuration Synchronization
    - Define a list/groups of config attributes that are synched between all(or some) registered servers (indexing, security, password policy, plugins, tuning, etc)
    - Different configuration profiles can be defined and globally/individually applied as needed.

- Replication Management:
    - Manage all the registered Replicas.
    - Simplified replication tasks:  Drag and drop servers into and out of "replication" or promote/demote replicas, setup/initialization, and synchronize configurations(replication & changelog).
    - Improved replication monitoring
    - Replication farm "drawing/image"

- Monitoring
    - Be able to monitor all instances from a central view point.  Add filtering (performance, server online status, replication status, etc) to find "troubled" servers.

- Configuration Server Suffix:  o=dmc  ->  Directory Management Configuration
    - Replicates, and can be used from any Admin Server - not restricted to a particular HTTP host like o=netcaperoot is.
    - http://www.port389.org/docs/389ds/design/dmc-design.html

- Dynamic UI - Configuration form layout definitions are stored in the configuration database(o=dmc).  Updates to o=dmc are reflected in the UI.  As the configuration changes, we don't need to release a new admin server, we just need an update to o=dmc.  This also allows for easy customization of the UI.

- New UI management design
    - We look at things in terms of Suffix/Domain, Replication, Configuration, Instances/Hosts, and Monitoring.  This focuses on using "configuration synchronization" to manage all the servers in a "one-click" type solution

- "One command deploy" servers
    - With Containers and other automation systems, joining a server to the "domain" should be as simple as pointing it to any already existing member of the DMC cluster. From there it can be completely administered in a "hands off" and reliable fashion.


