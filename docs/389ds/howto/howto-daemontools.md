---
title: "Howto:Daemontools"
---

# Daemon Tools
--------------

{% include toc.md %}

Purpose
-------

The [daemontools](http://cr.yp.to/daemontools.html) package from Dan Bernstein provides UNIX style process supervision (watchdog) and logging functionality. This document explains how to run directory server and administration server with daemontools on linux. Other UNIX style operating systems which are able to run FDS should be able to use this howto as well.

**NOTE: Daemontools does not work with win32. It is for UNIX style operating systems only.**

What you will gain from this Howto
----------------------------------

After you have followed the steps in this howto, directory server and administration server will be automatically started at system startup and will be automatically restarted during runtime in the event that it should die for some reason. As well, daemontools will take over the logging functionality for directory server.

Requirements
------------

This document assumes that you already have Fedora Directory Server or Redhat Directory Server installed and running on some variant of UNIX or linux.

-   Root Access - you must be root throughout this entire howto
-   Internet Access
-   C compiler

Daemontools Installation
------------------------

Save the following script to your disk, set the executable bit, and execute it.

    #!/bin/sh
    #
    # install daemontools on fedora/redhat linux
    #
    # Mike Jackson <mj@sci.fi> 5 NOV 2005
    #
    #
    mkdir /package
    chmod 1755 /package
    cd /package
    wget http://cr.yp.to/daemontools/daemontools-0.76.tar.gz
    tar xzvf daemontools-0.76.tar.gz
    rm -f daemontools-0.76.tar.gz
    cd admin/daemontools-0.76/src
    wget http://www.qmailrocks.org/downloads/patches/daemontools-0.76.errno.patch
    patch < daemontools-0.76.errno.patch
    cd ..
    package/install

The daemontools installation adds a line to /etc/inittab to start and restart svscan. Svscan is the process which supervises all processes which are configured to run under daemontools. The svscan process should now be running. Check it with the following command:

    ps -ef | grep svscan

You should see output similar to this:

    root     17695     1  0 Nov05 ?        00:00:00 /bin/sh /command/svscanboot
    root     17697 17695  0 Nov05 ?        00:00:00 svscan /service

Runit Installation
------------------

Runit is a replacement package for init(8). The runit package includes a tool called svwaitup, which checks if another service which is supervised by svscan is up or not. This is required by the admininstration server start script, since the administration server has a runtime dependency to the directory server.

Save the following script to your disk, set the executable bit, and execute it.

    #!/bin/sh
    #
    # install runit on fedora/redhat linux
    #
    # Mike Jackson <mj@sci.fi> 19 Feb 2005
    #
    #
    mkdir /package
    chmod 1755 /package
    cd /package
    wget http://smarden.org/runit/runit-1.3.3.tar.gz
    tar xzvf runit-1.3.3.tar.gz
    rm -f runit-1.3.3.tar.gz
    cd admin/runit-1.3.3
    package/install

Directory Server
----------------

### Configuration Changes

Directory Server only requires one small configuration change: changing the access logfile location to /dev/stdout. This is required so that the daemontools logger, multilog, can take over the logging. Save the following to disk, set the executable bit, and execute it.

    #!/bin/sh
    #
    # modify directory server to log to stdout
    #
    # Mike Jackson <mj@sci.fi> 5 NOV 2005
    #
    #
    cd /opt/fedora-ds/slapd-*
    ./stop-slapd
    cd config
    perl -i -pe 's/^nsslapd-accesslog:.+$/nsslapd-accesslog: \/dev\/stdout/' dse.ldif

### Creating Daemontools Run Scripts

In order to have svscan start and supervise a process, a small directory structure with two run scripts and some logging variables must be created. Save the following to disk, set the executable bit, and execute it.

**NOTE: Change the PRODUCT and INSTANCE variables at the top to match your setup before executing the script.**

    #!/bin/sh
    #
    # run fedora/redhat DS under daemontools
    #    
    # Mike Jackson <michael.jackson@netauth.com> 5 NOV 2005
    #    
    # http://www.netauth.com/ldap
    # --------------------------------------------------------    
    #
    #PRODUCT=redhat-ds
    PRODUCT=fedora-ds
    BASEDIR=/opt/$PRODUCT
    INSTANCE=slapd-foo
    #
    cd $BASEDIR
    mkdir -p supervise/log
    cd supervise
    #
    cat > run <<EOM
    #!/bin/sh
    exec 2>&1
    echo "Starting Directory Server..."
    unset LD_LIBRARY_PATH
    cd $BASEDIR/bin/slapd/server
    exec \
       ./ns-slapd \
       -D $BASEDIR/$INSTANCE \
       -d 0
    EOM
    #
    chmod +x run
    cd log
    #
    cat > run <<EOM
    #!/bin/sh
    exec \
    setuidgid multilog \
    envdir ./env \
    sh -c '
       exec \
       multilog \
           t \
           ${MAXFILESIZE+"s$MAXFILESIZE"} \
           ${MAXLOGFILES+"n$MAXLOGFILES"} \
           ${PROCESSOR+"!$PROCESSOR"} \
           /var/multilog/fedora-ds
    '
    EOM
    #
    chmod +x run
    mkdir env
    chmod +s env
    cd env
    echo 1000000 > MAXFILESIZE
    echo 10 > MAXLOGFILES
    touch PROCESSOR
    useradd -g nobody -M multilog
    mkdir -p /var/multilog/fedora-ds
    chown -R multilog:nobody /var/multilog/fedora-ds

### Stop Directory Server

    /opt/389-ds/slapd-hostname/stop-slapd

NOTE: substitute \    hostname\     with the instance name, if the instance name is not the hostname.

### Start Directory Server with svscan

For Fedora Directory Server:

    ln -s /opt/fedora-ds/supervise /service/fedora-ds    

Check the status of the new service:

    svstat /service/fedora-ds    

Output should look similar to:

    /service/fedora-ds: up (pid 20578) 12 seconds    

If the output looks similar to this, then there is a problem:

    /service/fedora-ds: up (pid 20578) 0 seconds    

### Using the Daemontools Logging System

Logfiles are stored in /var/multilog/fedora-ds or /var/multilog/redhat-ds, depending on the installed product. The current logging information is stored in the file named "current". Rotated logs will be stored in the same directory.

Multilog uses the tai64n high-resolution time system for logfile timestamps, which are not human readable. To convert the timestamps to human readable format, the daemontools tool "tai64nlocal" must be used.

To tail a logfile:

    tail -f current | tai64nlocal    

To browse a logfile with less:

    tai64nlocal < current | less    

To change the max logfile size and max number of logfiles which are kept, change the environment files and restart multilog. The MAXFILESIZE variable is specified in bytes. The following steps would change the logfile size to 50MB:

    cd /opt/fedora-ds/supervise/log/env    
    echo 50000000 > MAXFILESIZE    

Now you need to find the process id of multilog so that you can kill it:

    ps -ef | grep multilog    

You can see multilog for fedora-ds running as process 17717:

    multilog 17717 17716  0 Nov05 ?        00:00:00 multilog t s1000000 n10 /var/multilog/fedora-ds    

Kill the process 17717, and svscan will automatically restart multilog with the new environment variables:

    kill 17717    

To check that multilog has been restarted, as well as inspect it's command line:

    ps -ef | grep multilog    

Now you can see that the size of the logfile has been increased:

    multilog  9138 17716  0 14:37 ?        00:00:00 multilog t s50000000 n10 /var/multilog/fedora-ds    

Administration Server
---------------------

### Configuration Changes
------------------------

None required until runtime logging for Administration Server is added to this section of the howto.

#### Installing fedora-ds-admin as a service

Copy this into /etc/init.d/fedora-ds-admin

    <pre>
    #! /bin/bash
    #
    # fedora-ds-admin          Start/Stop the fedora-ds-admin.
    #
    # chkconfig: - 99 1
    # description: Fedora Directory Server Admin service \
    #              Script version 0.1 contributed by Sorin Sbarnea \
    #          Tested with fedora-ds-admin 1.0.x
    # processname: fedora-ds-admin
    # config: /etc/crontab
    # pidfile: /opt/fedora-ds/admin-serv/logs/pid

    # Source function library.
    . /etc/init.d/functions
    #. /etc/sysconfig/fedora-ds-admin
    t=${CRON_VALIDATE_MAILRCPTS:-UNSET}
    [ "$t" != "UNSET" ] && export CRON_VALIDATE_MAILRCPTS="$t"
 
    # See how we were called.
    # Source our configuration file for these variables.
    FLAGS=
    RETVAL=0

    # Set up some common variables before we launch into what might be
    # considered boilerplate by now.
    path_start=/opt/fedora-ds/start-admin
    path_restart=/opt/fedora-ds/restart-admin
    path_stop=/opt/fedora-ds/stop-admin
    path=./ns-httpd
    prog="Fedora-DS Admin"
    pidfile=/opt/fedora-ds/admin-serv/logs/pid
    start() {
        echo -n $"Starting $prog: " 
            if [ -e /var/lock/subsys/fedora-ds-admin ]; then
            if [ -e $pidfile ] && [ -e /proc/`cat $pidfile`]; then
            echo -n $"cannot start fedora-ds-admin: fedora-ds-admin is already running.";
            failure $"cannot start fedora-ds-admin: fedora-ds-admin already running.";
            echo
            return 1
            fi
        fi
        daemon $path_start
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && touch /var/lock/subsys/fedora-ds-admin;
        return $RETVAL
    }

    stop() {
        echo -n $"Stopping $prog: "
            if [ ! -e /var/lock/subsys/fedora-ds-admin ]; then
            echo -n $"cannot stop fedora-ds-admin: fedora-ds-admin is not running."
            failure $"cannot stop fedora-ds-admin: fedora-ds-admin is not running."
            echo
            rm -f $pidfile
            return 1;
        fi
    #   killproc fedora-ds-admin
            $path_stop
        RETVAL=$?

            if [ -e /var/run/fedora-ds-admin.pid ] && [ -e /proc/`cat /var/run/fedora-ds-admin.pid`]; then
            echo -n $"not stoped? we'll kill it!";
            kill     cat $pidfile    ;
            rm -f $pidfile
        fi
        echo
            [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/fedora-ds-admin;
        return $RETVAL
    }

    rhstatus() {
        status fedora-ds-admin
    }

    restart() {
        stop
        start
    }

    reload() {
        echo -n $"Reloading cron daemon configuration: "
        killproc fedora-ds-admin -HUP
        RETVAL=$?
        echo
        return $RETVAL
    }

    case "$1" in
      start)
        start
        ;;
      stop)
        stop
        ;;
      restart)
        restart
        ;;
      reload)
        reload
        ;;
      status)
        rhstatus
        ;;
      condrestart)
        [ -f /var/lock/subsys/fedora-ds-admin ] && restart || :
        ;;
      *)
        echo $"Usage: $0 {start|stop|status|reload|restart|condrestart}"
        exit 1
    esac
    </pre>

Now execute:

    <pre>
    chkconfig --add fedora-ds-admin
    chkconfig fedora-ds-admin on
    service fedora-ds-admin start
    </pre>

### Monitoring script for monit (optional)

If you want to monitor the fedora-ds-service install [http://www.tildeslash.com/monit/ monit] and put the following content in <tt>/etc/monit.d/fedora-ds-admin

    check process fedora-ds-admin with pidfile /opt/fedora-ds/admin-serv/logs/pid
    group ldap
    start program = "/etc/init.d/fedora-ds-admin start"
    stop program = "/etc/init.d/fedora-ds-admin stop"
    if failed host localhost port 14791
    protocol http then restart
    if 5 restarts within 5 cycles then timeout

#### Creating Daemontools Run Scripts

In order to have svscan start and supervise a process, a small directory structure with two run scripts and some logging variables must be created. Save the following to disk, set the executable bit, and execute it.

**NOTE: Change the PRODUCT and INSTANCE variables at the top to match your setup before executing the script.**

    #!/bin/sh
    #
    # run fedora/redhat DS admin server under daemontools
    #
    # Mike Jackson <michael.jackson@netauth.com> 19 Feb 2006
    #
    # http://www.netauth.com
    # -----------------------------------
    #
    # change to match product
    #PRODUCT=redhat-ds
    PRODUCT=fedora-ds
    #
    BASEDIR=/opt/$PRODUCT
    #
    # env variables
    ADMSERV_ROOT=${BASEDIR}/admin-serv
    HTTPD=/usr/sbin/httpd.worker
    LD_LIBRARY_PATH="${BASEDIR}/bin/admin/lib:${BASEDIR}/lib:${LD_LIBRARY_PATH}"
    LD_PRELOAD="${BASEDIR}/bin/admin/lib/libssl3.so ${BASEDIR}/bin/admin/lib/libldap50.so"
    NETSITE_ROOT=${BASEDIR}
    NS_SERVER_HOME=${BASEDIR}
    PATH=${BASEDIR}/bin/admin/bin:${PATH}
    SERVER_ROOT=${BASEDIR}
    #
    cd $BASEDIR
    mkdir -p supervise/${PRODUCT}-admin/env
    mkdir -p supervise/${PRODUCT}-admin/log
    cd supervise/${PRODUCT}-admin
    chmod +s env
    #
    cat > run <<EOM
    #!/bin/sh
    #
    # run the fedora/redhat DS administration server
    #
    exec 2>&1
    echo "*** Checking service dependency for $PRODUCT ..."
    svwaitup -s 3 /service/$PRODUCT || exit 1
    echo "***Starting $PRODUCT Administration Server ..."
    exec \
    envdir ./env \
    sh -c '
        NS_SERVER_HOME="$NS_SERVER_HOME" \
        PATH="$PATH" \
        SERVER_ROOT="$SERVER_ROOT" \
        NETSITE_ROOT="$NETSITE_ROOT" \
        ADMSERV_ROOT="$ADMSERV_ROOT" \
        LD_LIBRARY_PATH="$LD_LIBRARY_PATH" \
        LD_PRELOAD="$LD_PRELOAD" \
        exec \
        "$HTTPD" \
        -d "$ADMSERV_ROOT" \
        -f "$ADMSERV_ROOT/config/httpd.conf" \
        -D FOREGROUND
    '
    EOM
    #
    chmod +x run
    #
    cd env
    echo ${ADMSERV_ROOT} > ADMSERV_ROOT
    echo ${HTTPD} > HTTPD
    echo ${LD_LIBRARY_PATH} > LD_LIBRARY_PATH
    echo ${LD_PRELOAD} > LD_PRELOAD
    echo ${NETSITE_ROOT} > NETSITE_ROOT
    echo ${NS_SERVER_HOME} > NS_SERVER_HOME
    echo ${PATH} > PATH
    echo ${SERVER_ROOT} > SERVER_ROOT
    #
    cd ../log
    #
    cat > run <<EOM
    #!/bin/sh
    exec \
    setuidgid multilog \
    envdir ./env \
    sh -c '
       exec \
       multilog \
           t \
           ${MAXFILESIZE+"s$MAXFILESIZE"} \
           ${MAXLOGFILES+"n$MAXLOGFILES"} \
           ${PROCESSOR+"!$PROCESSOR"} \
           /var/multilog/fedora-ds-admin
    '
    EOM
    #
    chmod +x run
    mkdir env
    chmod +s env
    cd env
    echo 1000000 >     MAXFILESIZE
    echo 10 > MAXLOGFILES
    touch PROCESSOR
    useradd -g nobody -M multilog
    mkdir -p /var/multilog/fedora-ds-admin
    chown -R multilog:nobody /var/multilog/fedora-ds-admin

### Stop Administration Server

    /opt/fedora-ds/stop-admin

### Start Administration Server with svscan

For Fedora DS:

    ln -s /opt/fedora-ds/supervise/fedora-ds-admin /service/fedora-ds-admin

Check the status of the new service:

    svstat /service/fedora-ds-admin    

Output should look similar to:

    /service/fedora-ds-admin: up (pid 20578) 12 seconds    

If the output looks similar to this, then there is a problem:

    /service/fedora-ds-admin: up (pid 20578) 0 seconds    

### Using the Daemontools Logging System

Logfiles are stored in /var/multilog/fedora-ds-admin or /var/multilog/redhat-ds-admin, depending on the installed product. The current logging information is stored in the file named "current". Rotated logs will be stored in the same directory.

Multilog uses the tai64n high-resolution time system for logfile timestamps, which are not human readable. To convert the timestamps to human readable format, the daemontools tool "tai64nlocal" must be used.

To tail a logfile:

    tail -f current | tai64nlocal    

To browse a logfile with less:

    tai64nlocal < current | less    

To change the max logfile size and max number of logfiles which are kept, change the environment files and restart multilog. The MAXFILESIZE variable is specified in bytes. The following steps would change the logfile size to 50MB:

    cd /opt/fedora-ds-admin/supervise/log/env    
    echo 50000000 > MAXFILESIZE    

Now you need to find the process id of multilog so that you can kill it:

    ps -ef | grep multilog    

You can see multilog for fedora-ds-admin running as process 17718:

    multilog 17718 17716  0 Nov05 ?        00:00:00 multilog t s1000000 n10 /var/multilog/fedora-ds-admin    

Kill the process 17718, and svscan will automatically restart multilog with the new environment variables:

    kill 17718    

To check that multilog has been restarted, as well as inspect it's command line:

    ps -ef | grep multilog    

Now you can see that the size of the logfile has been increased:

    multilog  9138 17716  0 14:37 ?        00:00:00 multilog t s50000000 n10 /var/multilog/fedora-ds-admin

