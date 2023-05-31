---
title: "Howto: OpenldapIntegration"
---

# openLdap Integration
----------------------

Replication/Sync
----------------

There are ways to sync data between OpenLDAP and Fedora DS. You can either sync from OpenLDAP to Fedora DS, or you can sync from Fedora DS to OpenLDAP, in one direction at a time only. There is currently no way to do bi-directional sync between OpenLDAP and Fedora DS and maintain data consistency.

Replication from OpenLDAP to Fedora DS
--------------------------------------

You can use the (now deprecated in OL 2.4) slurpd mechanism to send changes from OpenLDAP to Fedora DS. Just be sure to add these lines to your slurpd configuration in your slapd.conf:

           attr!=structuralObjectClass,entryUUID,entryCSN    

Something like

    replica uri=    <uri>
           attr!=structuralObjectClass,entryUUID,entryCSN    
               <other parameters>

Replication from Fedora DS to OpenLDAP
--------------------------------------

This is possible, but not currently documented.
