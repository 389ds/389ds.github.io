---
title: "Logconv Improvements 1.3.1"
---

# Access Log Analyzer Improvements
----------------------------------

Overview
--------

The memory management of the script has been redesigned, new stats have been added to the report, and minor bug fixes.

Use Cases
---------

Situations where massive amounts of logs need to be analyzed.

Design
------

The memory usage has been redesigned to store all the "verbose" processed data on disk, and when the report is generated, we read in and process each area. While this does dramatically reduce the memory footprint, it does consume disk space while generating the report. The data files are removed after the report is generated. Here are some details of the memory size, and disk space consumption:

      Logconv.pl 6.1 (previous version):    
          
        1 million lines: 2843256 k    
        5 million lines: 5118708 k    
          
      Logconv.pl 7.0 (new version):    
          
        1 million lines: 2026828 k    
        5 million lines: 2029848 k     
          
           
      Access log size: 126724k    
      Data files size: 582764k (~4 times larger than log size)    

The new stats that have been added are "LDAPI binds", "AUTOBIND's", and improved connection stats (StartTLS, LDAPS, LDAPI, etc).

Implementation
--------------

No additional requirements.

Feature Management
-----------------

CLI only.

Major configuration options and enablement
------------------------------------------

New logconv.pl switch to set where the temporary data files should be written to:

    -D, --data         <Location for temporary data files>  default is "/tmp"

Replication
-----------

No impact.

Updates and Upgrades
--------------------

No impact.

Dependencies
------------

No dependencies.

External Impact
---------------

No external impact.

RFE Author
----------

Mark Reynolds <mreynolds@redhat.com>

