---
title: "Howto: Fix and Reset Time Skew"
---

# Fix and Reset Time Skew
-------------------------

{% include toc.md %}

Thanks to JR Aquino <JR.Aquino at citrix dot com> for these instructions.

**WARNING: Following these steps will require having to perform a replica initialization of all of your servers!**

If you are seeing clock skew errors in

    /var/log/dirsrv/slapd-EXAMPLE-COM/errors

that look like this, then you will need to verify the time/date of the server to make sure NTP isn't freaked out. If the system date is correct, it is possible that the change number generator has skewed.

    [01/Feb/2014:14:42:06 -0800] NSMMReplicationPlugin - conn=12949 op=7 repl="dc=example,dc=com": Excessive clock skew from supplier RUV    
    [01/Feb/2014:14:42:06 -0800] - csngen_adjust_time: adjustment limit exceeded; value - 1448518, limit - 86400    
    [01/Feb/2014:14:42:06 -0800] - CSN generator's state:    
    [01/Feb/2014:14:42:06 -0800] -  replica id: 115    
    [01/Feb/2014:14:42:06 -0800] -  sampled time: 1391294526    
    [01/Feb/2014:14:42:06 -0800] -  local offset: 0    
    [01/Feb/2014:14:42:06 -0800] -  remote offset: 0    
    [01/Feb/2014:14:42:06 -0800] -  sequence number: 55067    

The following NsState\_Script should be used to determine whether the change number generator has jumped significantly from the real time/date. <https://github.com/richm/scripts/blob/master/readNsState.py>

The usage for the script works like this (as root):

    # ./readNsState.py /etc/dirsrv/slapd-EXAMPLE-COM/dse.ldif    
    nsState is cwAAAAAAAABGPfBSAAAAAAAAAAAAAAAAAQAAAAAAAAACAAAAAAAAAA==    
    Little Endian    
    For replica cn=replica,cn=dc\3Dexample\2Cdc\3Dcom,cn=mapping tree,cn=config    
      fmtstr=[H6x3QH6x]    
      size=40    
      len of nsstate is 40    
      CSN generator state:    
        Replica ID    : 115    
        Sampled Time  : 1391476038    
        Gen as csn    : 52f03d46000201150000    
        Time as str   : Mon Feb  3 17:07:18 2014    
        Local Offset  : 0    
        Remote Offset : 1    
        Seq. num      : 2    
        System time   : Mon Feb  3 17:09:11 2014    
        Diff in sec.  : 113    
        Day:sec diff  : 0:113    

If the output from the above command is over a day or more out of sync, then the reason is because the CSN generator has become grossly skewed. It will be necessary to perform the following steps to recover. If the report contains more than one replica, you will need to clean all of the replicas reported (see below).

How to resolve this issue
-------------------------

-   Select a directory server to be authoritative and write the contents of its database to an ldif file
    -   On the master supplier:

            # /usr/bin/db2ldif.pl -Z EXAMPLE-COM -D 'cn=Directory Manager' -w - -n userRoot -a /tmp/master-389.ldif    

Note that without the -r option it is deliberately omitting the tainted replication data which contains the bad CSNs

If you have more than one suffix/db, you will have to do this for each one that the readNsState.py script reports.

-   On the master supplier, shutdown dirsrv so that you can reset the attribute responsible for the serial generation, and so that you can re-initialize its db from the known good ldif
    -   depends on the platform

            # service dirsrv stop    

        OR

            # systemctl stop dirsrv.target    

        OR - if using IPA

            # ipactl stop    

**WARNING: Once you do the following step, replication will be broken until you complete all steps!!!!**

-   Sanitize the dse.ldif Configuration File
    -   edit the /etc/dirsrv/slapd-EXAMPLE-COM/dse.ldif file and remove the nsState attribute from the replica config entry
    -   if readNsState reports large skew from more than one cn=replica (e.g. you are replicating more than one suffix) you must remove from all of the ones with large skew
    -   You DO NOT want to remove the nsState from: dn: cn=uniqueid generator,cn=config
    -   The stanza you want to remove the value from is: dn: cn=replica,cn=dc\\3Dexample\\2Cdc\\3Dcom,cn=mapping tree,cn=config
    -   The attribute will look like this: nsState:: cwAAAAAAAAA3QPBSAAAAAAAAAAAAAAAAAQAAAAAAAAABAAAAAAAAAA==
    -   Delete the entire line

**WARNING: There is no going back now!!!!**

-   Remove traces of stale CSN tracking in the Replica Agreements themselves
    -   File location: /etc/dirsrv/slapd-EXAMPLE-COM/dse.ldif

            # cat dse.ldif | sed -n '1 {h; $ !d}; $ {x; s/\n //g; p}; /^ / {H; d}; /^ /! {x; s/\n //g; p}' | grep -v nsds50ruv > new.dse.ldif    

-   
    -   backup the old dse.ldif and replace it with the new one:

            # mv dse.ldif dse.saved.ldif    
            # mv new.dse.ldif dse.ldif    

-   Import the data from the known good ldif. This will mark all the changes with CSNs that match the current time/date stamps

        # chmod 644 /tmp/master-389.ldif    
        # /usr/bin/ldif2db -Z EXAMPLE-COM -n userRoot -a /tmp/master-389.ldif    

    If you have more than one suffix/db, you will have to do this for each one that the readNsState.py script reports.

-   Restart dirsrv on the master supplier
    -   depends on the platform

            # service dirsrv start    

        OR

            # systemctl start dirsrv.target    

        OR - if using IPA

            # ipactl start    

-   When the daemon starts, it will see that it does not have an nsState and will write new CSN's to -all- of the newly imported good data with today's timestamp, we need to take that data and write -it- out to an ldif file, for use in initializing all of the other servers.

        # /usr/bin/db2ldif.pl -Z EXAMPLE-COM -D 'cn=Directory Manager' -w - -n userRoot -r -a /tmp/replication-master-389.ldif    

    the -r tells it to include all replica data which includes the newly blessed CSN data

-   Now we must re-initialize \_every other\_ replica with the new good data.

**BEGIN - REPEAT THESE STEPS ON EVERY REPLICA**

-   scp root@replication.master.fqdn:/tmp/replication-master-389.ldif /tmp/replication-master-389.ldif
-   shutdown dirsrv

        # service dirsrv stop    

    OR

        # systemctl stop dirsrv.target    

    OR - if using IPA

        # ipactl stop    

-   Sanitize the dse.ldif Configuration File
    -   edit the /etc/dirsrv/slapd-EXAMPLE-COM/dse.ldif file and remove the nsState attribute from the replica config entry
    -   if readNsState reports large skew from more than one cn=replica (e.g. you are replicating more than one suffix) you must remove from all of the ones with large skew
    -   You DO NOT want to remove the nsState from: dn: cn=uniqueid generator,cn=config
    -   The stanza you want to remove the value from is: dn: cn=replica,cn=dc\\3Dexample\\2Cdc\\3Dcom,cn=mapping tree,cn=config
    -   The attribute will look like this: nsState:: cwAAAAAAAAA3QPBSAAAAAAAAAAAAAAAAAQAAAAAAAAABAAAAAAAAAA==
    -   Delete the entire line

-   Remove traces of stale CSN tracking in the Replica Agreements themselves
    -   File location: /etc/dirsrv/slapd-EXAMPLE-COM/dse.ldif

            # cat dse.ldif | sed -n '1 {h; $ !d}; $ {x; s/\n //g; p}; /^ / {H; d}; /^ /! {x; s/\n //g; p}' | grep -v nsds50ruv > new.dse.ldif    

-   
    -   backup the old dse.ldif and replace it with the new one:

            # mv dse.ldif dse.saved.ldif    
            # mv new.dse.ldif dse.ldif    

-   Import the data from the known good ldif. This will mark all the changes with CSNs that match the current time/date stamps

        # chmod 644 /tmp/replication-master-389.ldif    
        # /usr/bin/ldif2db -Z EXAMPLE-COM -n userRoot -i /tmp/replication-master-389.ldif    

-   Restart dirsrv

        # service dirsrv start    

    OR

        # systemctl start dirsrv.target    

    OR - if using IPA

        # ipactl start    

**END - REPEAT THESE STEPS ON EVERY REPLICA**

Why is this necessary?
----------------------

Further reading for those interested in the particulars of CSN tracking or the MultiMaster Replication algorithm:

It all starts with the Leslie Lamport paper: <http://www.stanford.edu/class/cs240/readings/lamport.pdf> "Time, Clocks, and the Ordering of Events in a Distributed System"

The next big impact on MMR protocols was the work done at Xerox PARC on the Bayou project.

These and other sources formed the basis of the IETF LDUP working group. Much of the MMR protocol is based on the LDUP work.

The tl;dr version is this:

The MMR protocol is based on ordering operations by time so that when you have two updates to the same attribute, the "last one wins".

So how do you guarantee some sort of consistent ordering throughout many systems that do not have clocks in sync down to the millisecond? If you say "ntp" then you lose...

The protocol itself has to have some notion of time differences among servers.

The ordering is done by CSN (Change Sequence Number).

The first part of the CSN is the timestamp of the operation in unix time\_t (number of seconds since the epoch).

In order to guarantee ordering, the MMR protocol has a major constraint - you must never, never, issue a CSN that is the same or less than another CSN.

In order to guarantee that, the MMR protocol keeps track of the time differences among \_all\_ of the servers that it knows about.

When it generates CSNs, it uses the largest time difference among all servers that it knows about.

So how does the time skew grow at all?
--------------------------------------

Due to timing differences, network latency, etc. the directory server cannot always generate the absolute exact system time. There will always be 1 or 2 second differences in some replication sessions. These 1 to 2 second differences accumulate over time.

However, there are things which can introduce really large differences

-   buggy ntp implementations
-   bad sysadmin screws up the system clock
-   virtual machines which are notorious for having laggy system clocks, etc.

How can you monitor for this in the future?
-------------------------------------------

The readnsState.py script mentioned above can be used to output the effective skew of the system date vs the CSN generator. You can set a crontab to run this script and monitor its output to catch any future severe drifts.

Ticket information for some of the fixes that have been implemented because of this work so far: <https://fedorahosted.org/389/ticket/47516>

