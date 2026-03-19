---
title: "Fine Grain Operation Timing"
---

# Fine Grain Operation Timing

----------------

Overview
--------

This feature is about to control which timing information are logged in the RESULT line (or json record)
Allowing to configure any not empty set of the following measures:

- wqtime
- wtime
- writetime
- optime
- etime

Use Cases
---------

A typical use is when troubleshooting performance issue
and wondering whether the reason is within the directory server or within the application or the network

- high wtime but small wqtime means that
  - the application does not send the operation in timely way
- high wtime and high wqtime means (depending of the CPU load) that 
  - the number of working threads should be increased 
  - not enough CPU power to handle the load
- high optime related to high writetime means that either the application does not read the data in timely way or that there is lots of data returned
- high optime related to small writetime means that there is a problem realated to:
  - acl evaluation
  - filter evaluation
  - plugins
- high response delay at application level compared to the etime means that
  - the nsslapd-maxthreadsperconn threshold has been reached
  - there are some network issue

Major configuration options and enablement
------------------------------------------

ds-fine-grain-operation-timing attribute in cn=config accept a 
set of supported keywords separated by any of: space, tab, newline, comma, plus, or vertical bar

| Keyword   | Starting Point                             | Ending Point                             | Summary         | Cumuled |
| --------- | ------------------------------------------ | ---------------------------------------- | --------------- | ------- |
| wqtime    | Operation is pushed in worker thread queue | Operation is unqueued by a worker thread | Work Queue Time | Yes     |
| writetime | Starting to write data to the network      | Finished to write data to the network    | Write I/O time  | Yes     |
| optime    | Operation processing is started            | Operation result is sent                 | Operation time  | No      |
| etime     | First byte of operation is received        | Operation result is sent                 | Elapsed time    | No      |
| wtime     | First byte of operation is received        | Operation processing is started          | Wait time       | No      |

Cumuled means that there may be several measures when handling the operation and that all the times are cumuled.

By default ds-fine-grain-operation-timing is: wqtime+wtime+optime+etime

Design
------

Struct array added in operation struct: o_fgots
 contains the following fields per element:
    - enabled: A boolean telling if the element is meaningfull
    - s: measure starting time
    - c: measure cumuled time

An fgot_id_t enum identify the different measures
While logging the operation result the o_fgots array is walked and for any enabled slot keyword=value is added to the RESULT line/record

Important functions to compute the measure:
    - fgot\_start(op, fgot_id): set the current time in s if the slot is enabled
    - fgot\_end(op, fgot_id): if the slot is enabled subtract s from current time and add the result in c
    - fgot\_compute(op, fgot_id, t1, t2): if the slot is enabled subtract t2 from t1 and add the result in c

How to add new timing
---------------------

* Add new enum value in fgot\_id\_t in slapi-private.h  
* Add new keywords in fgot\_allowed\_values\_table in libglobs.c  
  Note that the first keyword for a given id will be the one that is logged in access log  
* If the configuration parameter default must be changed then update SLAPD\_DEFAULT\_FGOT and SLAPD\_DEFAULT\_FGOT\_FLAGS in slap.h  
* Finally implement the timing code using the  
  * fgot\_start \+ fgot\_end functions  
  * or the fgot\_compute function

Future work
-----------

Should probably add more timing for

* acl evaluation  
* filter evaluation  
* plugin evaluation  
  maybe a global one and a few other for some specific plugin:  
  * memberof plugin  
  * referential integrity  
  * uid uniqueness  

Origin
------

- https://redhat.atlassian.net/browse/RHEL-58681
- https://github.com/389ds/389-ds-base/issues/6326
- https://github.com/389ds/389-ds-base/issues/6724

Author
------

<progier@redhat.com>
