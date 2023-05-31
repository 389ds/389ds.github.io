---
title: "Using SystemTap"
---

# Using SystemTap
-----------------

{% include toc.md %}

Introduction
------------

SystemTap <http://sourceware.org/systemtap> provides a way to trace, profile, and monitor programs without interfering too much with performance/timing of the program. It provides a scripting interface that allows you to monitor and collect a wide variety of data. This is an example of how to use systemtap to look at thread contention in the directory server.

Pre-requisites
--------------

This work was done using RHEL 6.3 x86\_64. It should work on recent versions of RHEL and Fedora. I used the latest directory server available on RHEL 6.3 - 389-ds-base-1.2.10.2-20.

In order to get the userspace stack data, you will need to install many devel and debuginfo packages. If you are using RHEL6, this means you must have access to the following yum repos:

-   rhel-ARCH-TYPE-6-debuginfo
-   rhel-ARCH-TYPE-optional-6
-   rhel-ARCH-TYPE-optional-6-debuginfo
-   rhel-ARCH-TYPE-supplementary-6
-   rhel-ARCH-TYPE-supplementary-6-debuginfo

Where ARCH is your architecture (i386, x86\_64) and TYPE is client, workstation, or server.

Install the systemtap packages:

    yum install systemtap systemtap-runtime systemtap-devel systemtap-client    

Running stap is a bit of trial and error. When you first run the stap script, stap may complain about missing packages. If you have ABRT enabled and running, you can modify the shell script to invoke stap with the --download-debuginfo=yes option so that stap will automatically install the required packages.

At the very least, you will need to do

    debuginfo-install 389-ds-base    

to get the 389 and dependent packages. You may also have to manually install the following: nss-debuginfo, nspr-debuginfo, openldap-debuginfo, glibc-debuginfo, nss-softokn-debuginfo, nss-util-debuginfo, kernel-debuginfo-common, svrcore-debuginfo, glibc-debuginfo-common, db4-debuginfo. Note that for the glibc and kernel packages, they must exactly match your system - debuginfo-install may grab the latest one which may not be exactly what you're running.

You will also need to install the 389-ds-base package:

    yum install 389-ds-base    

and configure an instance of directory server using setup-ds.pl - see [Install\_Guide](../legacy/install-guide.html)

Before running the stap script, make sure the directory server is not running (e.g. service dirsrv stop) - systemtap will start the directory server under it's control.

Scripts
-------

There is a shell script used to invoke the directory server under systemtap (stap-dirsrv.sh), a systemtap (.stp) script (stap-dirsrv.stp), and a stap-report.py python script to parse the output of running with keep\_stats = 0 (see below). The latest versions of these scripts can be found at <https://github.com/richm/scripts>.

### stap-dirsrv.sh shell script

The shell script looks like this:

    #!/bin/sh
    inst=${INST:-localhost}
    if [ -f $HOME/.dirsrv/dirsrv ] ; then
    . $HOME/.dirsrv/dirsrv
    else
    . $PREFIX/etc/sysconfig/dirsrv
    fi

    if [ -f $HOME/.dirsrv/dirsrv-$inst ] ; then
    . $HOME/.dirsrv/dirsrv-$inst
    else
    . $PREFIX/etc/sysconfig/dirsrv-$inst
    fi

    pidfile=$RUN_DIR/slapd-$inst.pid
    startpidfile=$RUN_DIR/slapd-$inst.startpid
    rm -f $pidfile $startpidfile
    SLAPD=${PREFIX:-/usr}/sbin/ns-slapd
    SLAPD_COMMAND="$SLAPD -D $CONFIG_DIR -i $pidfile -w $startpidfile -d 0"

    modules="-d $SLAPD"
    for m in /usr/lib64/dirsrv/plugins/libpwdstorage-plugin.so \
        /usr/lib64/dirsrv/plugins/libdes-plugin.so \
        /usr/lib64/sasl2/libgssapiv2.so.2.0.23 \
        /usr/lib64/dirsrv/plugins/libback-ldbm.so \
        /usr/lib64/dirsrv/plugins/libschemareload-plugin.so \
        /usr/lib64/libnssdbm3.so \
        /usr/lib64/libsoftokn3.so \
        /lib64/libdb-4.7.so \
        /usr/lib64/dirsrv/plugins/libsyntax-plugin.so \
        /usr/lib64/dirsrv/plugins/libautomember-plugin.so \
        /usr/lib64/dirsrv/plugins/libchainingdb-plugin.so \
        /usr/lib64/dirsrv/plugins/liblinkedattrs-plugin.so \
        /usr/lib64/dirsrv/plugins/libmanagedentries-plugin.so \
        /usr/lib64/dirsrv/plugins/libstatechange-plugin.so \
        /usr/lib64/dirsrv/libns-dshttpd.so.0.0.0 \
        /usr/lib64/dirsrv/plugins/libacl-plugin.so \
        /usr/lib64/dirsrv/plugins/libcos-plugin.so \
        /usr/lib64/dirsrv/plugins/libreplication-plugin.so \
        /usr/lib64/dirsrv/plugins/libroles-plugin.so \
        /usr/lib64/dirsrv/plugins/libhttp-client-plugin.so \
        /usr/lib64/dirsrv/plugins/libviews-plugin.so ;
    do
        modules="$modules -d $m"
    done

    STAP_ARRAY_SIZE=${STAP_ARRAY_SIZE:-65536}
    STAP_STRING_LEN=${STAP_STRING_LEN:-4096}

    STAP_OPTS="-DMAXACTION=$STAP_ARRAY_SIZE -DMAXSTRINGLEN=$STAP_STRING_LEN -DKRETACTIVE=1000 -DSTP_NO_OVERLOAD -t --ldd -v"

    sudo stap $STAP_OPTS -c "$SLAPD_COMMAND" $modules stap-dirsrv.stp $STAP_ARRAY_SIZE

You run it like this:

    ./stap-dirsrv.sh > /path/to/stap.log 2>&1 &    

This assumes you have the stap-dirsrv.stp script in your current directory. For best results, run as root, or if you feel up to it, configure sudo to allow you to run stap and directory server. You can run in the foreground, but you will have to kill the slapd pid to stop the run. Make sure you have plenty of disk space for the stap log, especially if you use keep\_stats = 0 (see below).

On a 32-bit system, you will have to edit the script to change the "lib64" to just "lib". If you get errors about array sizes from stap, you may have to change STAP\_ARRAY\_SIZE:

    STAP_ARRAY_SIZE=131072 ./stap-dirsrv.sh > /path/to/stap.log 2>&1 &    

The large string size is needed to hold the userspace stacktraces.

### stap-dirsrv.stp systemtap script

The stap script looks like this:

    // NOTE: a popup mutex is one that is seen in contention but the init of it was not detected    
    // not sure why there are popups - static mutex init?    
    global mutex_init_stack[$1] // stack trace where mutex was initialized, if known    
    global mutex_uninit[$1] // stack trace where mutex was first referenced, if init stack not known    
    global mutex_contention[$1] // stats about the contention on this mutex    
    global mutex_names[$1] // usymdata for this mutex    
    global mutex_last_cont_stack[$1] // stack trace of last contention for this mutex    
    // NOTE: the way 389 works is that many common mutexes are initialized in the same place    
    // for example - each connection object has its own mutex - there may be thousands of these    
    // they are all initialized in the same place - same with entry objects, where there may be    
    // millions    
    // so if we want to get aggregate contention statistics for _all_ connection objects, not just    
    // each individual one, we have to keep track of each unique call stack    
    // this is what mutex_cont_stack is used for    
    global mutex_cont_stack[$1] // stats about unique stacks    
    global cont_count_threshold = 1 // report mutexes that had more than this many contentions    
    global cont_max_threshold = 100000 // usec - report mutexes that had a max time more than this    
    global verbose = 0    
    global keep_stats = 1    
    /* ... and a variant of the futexes.stp script: */    
    global FUTEX_WAIT = 0 /*, FUTEX_WAKE = 1 */    
    global FUTEX_PRIVATE_FLAG = 128 /* linux 2.6.22+ */    
    global FUTEX_CLOCK_REALTIME = 256 /* linux 2.6.29+ */    
    function process_mutex_init(mutex, probefunc) {    
      if (verbose && (mutex in mutex_init_stack)) {    
        printf("error: %s: mutex %p is already initialized at\n%s\n",    
          probefunc, mutex, mutex_init_stack[mutex])    
      }    
      if (keep_stats) {    
        mutex_init_stack[mutex] = sprint_ubacktrace()    
        mutex_names[mutex] = usymdata (mutex)    
      } else {    
        printf("init %p at\n%s\n", mutex, sprint_ubacktrace())    
      }    
      if (verbose) {    
        printf("%s: mutex %p %s\n", probefunc, mutex, mutex_names[mutex])    
      }    
    }    
    function show_contention(mutex, stack, type) {    
      count = @count(mutex_contention[mutex])    
      max = @max(mutex_contention[mutex])    
      if ((count > cont_count_threshold) || (max > cont_max_threshold)) {    
        printf("=======================================\nmutex %p (%s) contended %d times, %d avg usec, %d max usec, %d total usec, %s at\n%s\n",    
          mutex, mutex_names[mutex], count, @avg(mutex_contention[mutex]),    
          max, @sum(mutex_contention[mutex]), type, stack)    
        if (mutex in mutex_last_cont_stack) {    
          printf("\nmutex was last contended at\n%s\n", mutex_last_cont_stack[mutex])    
        }    
      }    
    }    
    probe process("/lib*/libc*.so*").function("pthread_mutex_init") { process_mutex_init($mutex, probefunc()) }    
    probe process("/lib*/libpthread*.so").function("__pthread_mutex_init") { process_mutex_init($mutex, probefunc()) }    
    probe process("/lib*/libpthread*.so").function("__pthread_rwlock_init") { process_mutex_init($rwlock, probefunc()) }    
    probe syscall.futex.return {      
      if (($op & ~(FUTEX_PRIVATE_FLAG|FUTEX_CLOCK_REALTIME)) != FUTEX_WAIT) next    
      if (pid() != target()) next // skip irrelevant processes    
      elapsed = gettimeofday_us() - @entry(gettimeofday_us())    
      if (keep_stats) {    
        mutex_contention[$uaddr] <<< elapsed    
        stack = sprint_ubacktrace()    
        mutex_last_cont_stack[$uaddr] = stack    
        if ($uaddr in mutex_init_stack) {    
          if (verbose) {    
            printf("contention time %d on mutex %p initialized at\n%s\n", elapsed, $uaddr, mutex_init_stack[$uaddr])    
          }    
          stack = mutex_init_stack[$uaddr]    
          mutex_cont_stack[stack] <<< elapsed    
        } else if ($uaddr in mutex_uninit) {    
          if (verbose) {    
            printf("contention time %d on popup mutex %p at\n%s\n", elapsed, $uaddr, stack)    
          }    
          stack = mutex_uninit[$uaddr]    
          mutex_cont_stack[stack] <<< elapsed    
        } else {    
          if (verbose) {    
            printf("contention time %d on popup mutex %p at\n%s\n", elapsed, $uaddr, stack)    
          }    
          mutex_uninit[$uaddr] = stack    
          mutex_names[$uaddr] = usymdata ($uaddr)    
          mutex_cont_stack[stack] <<< elapsed    
        }    
      } else {    
        printf("contention %p elapsed %d at\n%s\n", $uaddr, elapsed, sprint_ubacktrace())    
      }    
    }    
    probe end {    
      if (!keep_stats) {    
        printf("======== END\n")    
        next    
      }    
      printf("<<<<<<<< aggregate stats\n")    
      foreach (stack in mutex_cont_stack-) {    
        count = @count(mutex_cont_stack[stack])    
        max = @max(mutex_cont_stack[stack])    
        if ((count > cont_count_threshold) || (max > cont_max_threshold)) {    
          printf("=======================================\nstack contended %d times, %d avg usec, %d max usec, %d total usec, at\n%s\n",    
            @count(mutex_cont_stack[stack]), @avg(mutex_cont_stack[stack]), @max(mutex_cont_stack[stack]), @sum(mutex_cont_stack[stack]), stack)    
        }    
      }    
      printf(">>>>>>>> aggregate stats\n")    
      foreach (mutex in mutex_contention-) {     
        if (mutex in mutex_init_stack) {    
          stack = mutex_init_stack[mutex]    
          type = "init"    
        } else if (mutex in mutex_uninit) {    
          stack = mutex_uninit[mutex]    
          type = "popup"    
        }    
        show_contention(mutex, stack, type)    
      }    
    }    

There are 3 tweaks you can make:

-   stack size - this is the command line argument to the script, set in stap-dirsrv.sh with the environment variable STAP\_ARRAY\_SIZE. If you have keep\_stats = 1, you will need large arrays to keep all of the init and contention data in memory.
-   keep\_stats - if this is set to 1, the stap script will use the arrays to keep track of per-mutex and aggregate statistics. The output will be a list, in descending order of the number of contentions, of the unique locations in the code where the mutex was either initialized or first contended (don't know why we can't see all mutex inits), as well as a list of contended mutexes in descending order of the number of contentions.
-   keep\_stats - if this is set to 0, the stap script will print out every mutex init and contention (which may be a large amount of output). You will need to use the stap-report.py script to parse the log file and produce a human readable report. The advantage is that you can see all of the stack traces for all of the contentions instead of just aggregates, but it takes a lot of disk space for the log and a lot of processing afterwards.
-   verbose - set verbose = 1 to see a trace of the stap probe activity (which will be a \_lot\_ of output)

You can also change

    global cont_count_threshold = 1 // report mutexes that had more than this many contentions    
    global cont_max_threshold = 100000 // usec - report mutexes that had a max time more than this    

if you want to change the contention reporting threshold when using keep\_stats = 1.

The goal of the script is to identify each unique location (userspace stacktrace) where a mutex is initialized. Why each unique location and not each mutex? Because the directory server in a couple of places allocates per-object mutexes. Each Connection object has its own mutex, and so does each entry object. All Connection objects are created in the same place, along with their mutexes. Same with entry objects. We usually want to see the contention on \_all\_ Connections and on \_all\_ entries, rather than the contention on each individual object. We can aggregate all of these together under the same stacktrace.

Reporting
---------

With keep\_stats = 1, the output looks something like this:

    <<<<<<<< aggregate stats    
    =======================================    
    mutex 0xdeadbeef (0xdeadbeef) contended 13141 times, 5500 avg usec, 131071 max usec, 16777216 total usec, init at    
    __lll_lock_wait+0x24 [libpthread-2.12.so]    
    pthread_cond_timedwait@@GLIBC_2.3.2+0x262 [libpthread-2.12.so]    
    pt_TimedWait+0xa9 [libnspr4.so]    
    PR_WaitCondVar+0x6c [libnspr4.so]    
    connection_wait_for_new_pb+0x36 [ns-slapd]    
    connection_threadmain+0x67e [ns-slapd]    
    _pt_root+0xa3 [libnspr4.so]    
    start_thread+0xd1 [libpthread-2.12.so]    
    __clone+0x6d [libc-2.12.so]    
    ...    
    >>>>>>>> aggregate stats    
    # then the per-mutex stats for each contended individual mutex that meets the thresholds    

With keep\_stats = 0, the output is similar. The script by default will output the top 10 contended stacks by contention count, and the top 10 contended stacks by the total contention time, as well as a report of all contentions reported by the libdb layer (all contentions originated by \_\_db\_tas\_mutex\_lock+0x11d). I recommend using the script like this:

    python -i stap-report.py stap.log    

This will run the script, crunch the numbers, and give you an interactive python prompt which you can use to get detailed information e.g. let's say you want to look at some of the places where a particular lock was contended.

    >>> ii = 0    
    >>> print msobj_by_count[0]    
    MutexStack 213232 contentions 11237648 usec total time 23384 usec max - 1 unique mutexes - 25 unique contentions - stack    
    pthread_rwlock_init+0x0 [libpthread-2.12.so]    
    slapi_new_rwlock+0x1d [libslapd.so.0.0.0]    
    vattr_init+0x69 [libslapd.so.0.0.0]    
    main+0xfd [ns-slapd]    
    __libc_start_main+0xfd [libc-2.12.so]    
    _start+0x29 [ns-slapd]    

This mutex stack has 25 unique contentions. Let's look at them by contention count:

    >>> ary = msobj_by_count[0].get_conts_by_count()    
    >>> len(ary)    
    25    

That is, 25 unique contentions. Let's look at the first one:

    >>> print ary[0]    
    <__main__.Contention instance at 0x19685a8>    
    >>> print ary[0].stack    
    __lll_lock_wait+0x24 [libpthread-2.12.so]    
    pthread_rwlock_unlock+0x80 [libpthread-2.12.so]    
    vattr_map_lookup+0x81 [libslapd.so.0.0.0]    
    vattr_map_namespace_sp_getlist+0x99 [libslapd.so.0.0.0]    
    vattr_test_filter+0x61 [libslapd.so.0.0.0]    
    slapi_vattr_filter_test_ext_internal+0x18e [libslapd.so.0.0.0]    
    slapi_vattr_filter_test_ext+0x46 [libslapd.so.0.0.0]    
    ldbm_back_next_search_entry_ext+0x6a3 [libback-ldbm.so]    
    iterate.clone.2+0xd1 [libslapd.so.0.0.0]    
    send_results_ext.clone.0+0x57 [libslapd.so.0.0.0]    
    op_shared_search+0xb1c [libslapd.so.0.0.0]    
    do_search+0xa13 [ns-slapd]    
    connection_threadmain+0xa6a [ns-slapd]    
    _pt_root+0xa3 [libnspr4.so]    
    start_thread+0xd1 [libpthread-2.12.so]    
    __clone+0x6d [libc-2.12.so]    
    >>> print ary[0].count    
    41988    

We can see that the lock created at vattr\_init() was contended a total of 213232 times, with the most (41988) being at vattr\_map\_lookup().

