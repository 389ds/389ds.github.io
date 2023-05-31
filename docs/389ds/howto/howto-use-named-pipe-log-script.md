---
title: "Named Pipe Log Script"
---

# Named Pipe Log Script
---------------------

{% include toc.md %}

The Named Pipe Log Script allows you to replace a log file with a named pipe attached to a script. The server can then send the log output to a script instead of to a log file. This allows you to do many different things such as:

-   log only certain events e.g. failed binds, connections from certain ip addresses, etc.
-   log only lines that match a certain pattern
-   log only the last N lines - useful for enabling full error log debug levels in production environments
-   send an email or other notification when a certain event is detected

The script is written in python, and allows plugins. By default, the script will log the last N lines (default 1000). There are two plugins provided - one to log only failed bind attempts, and one that will log only lines that match given regular expressions.

Usage
-----

    ds-logpipe.py     <name of pipe file to create or use>     [options]    

You must supply the filename of the named pipe. If it does not exist, the script will create it. If it exists and is a pipe, the script will use it. If it exists and is not a pipe, the script will abort.

    -u|--user - userid to chown() the named pipe to - will affect files created by plugins too    
    -m|--maxlines - number of lines to keep in the circular buffer - default 1000    

You can have the pipe script "monitor" another process, such as the directory server. You tell the pipe script the pid of the process, either directly, or by specifying the name of the file containing the pid. The pid file does not have to exist right away - the script will keep trying to read the file and check the pid until the timeout period is reached.

    -s|--serverpidfile - name of file containing the server pid    
    -t|--servertimeout - number of seconds to wait for the pid file to exist and the pid to be running (default 60)    
    --serverpid - specify the pid of the server directly - the server must already be running    

You can specify a plugin. The plugin must define a function that will be called with each line read from the pipe. You can optionally specify a pre function to be called when the plugin is loaded. Plugin command line arguments are passed to the pre function. You can optionally specify a post function to be called when the script exits.

    --plugin=/path/to/pluginfile.py - the file must end in .py    
    pluginfile.arg1 ... pluginfile.argN    

Each plugin may have arguments specified on the command line. If the plugin file is called pluginfile.py, the arguments are specified on the command line by **pluginfile.argname**. The argument names are whatever the plugin wants to use. The script will parse these and pass them to the plugin via the pre function, so the plugin must define a pre function in order to get the command line arguments. Multiple arguments with the same argname are passed as a list of values.

Example
-------

    ds-logpipe.py /var/log/dirsrv/slapd-instance/errors.pipe -m 10000    

Will create a named pipe which will keep the last 10000 lines read. You must configure the directory server to use errors.pipe as the error log instead of the default /var/log/dirsrv/slapd-instance/errors.

    ds-logpipe.py /var/log/dirsrv/slapd-instance/errors.pipe \
     --plugin=/usr/share/dirsrv/data/logregex.py logregex.regex="a bad error" > baderrors

Log only lines containing the string "a bad error" to the file baderrors.

Directory Server Configuration
------------------------------

There are a couple of ways to configure the directory server to use the pipe:

### Replace the default log file with the pipe

In this case, you will just replace the log file with the named pipe.

-   Advantage - no server configuration required - however, if the server is running, you will have to tell it to reopen the log file
-   Disadvantage - cannot use the log viewers (console, admin express) - other tools that expect the log to be a real file will fail (e.g. logconv.pl for the access log)

NOTE: You must move or delete the existing file. If you attempt to run the log pipe script and specify the name of an existing file, the script will abort if the file is not a named pipe. You may want to save the current file for safekeeping.

### Create a new log pipe file

In this case, you will tell the script to create a new file (e.g. errors.pipe). You must configure the directory server to use the new log.

-   Advantage - can use all of the log viewer and analysis tools
-   Disadvantage - requires server configuration

### Directory Server Log Configuration

Each of the 3 logs (access, error, audit) has several different configuration parameters. In order to enable the use of the named pipe for the log, you may want to modify them. For example, suppose you want to tell the server to use a pipe for the access log. You could use ldapmodify with the following LDIF:

    dn: cn=config
    changetype: modify
    replace: nsslapd-accesslog-maxlogsperdir
    nsslapd-accesslog-maxlogsperdir: 1
    -
    replace: nsslapd-accesslog-logexpirationtime
    nsslapd-accesslog-logexpirationtime: -1
    -
    replace: nsslapd-accesslog-logrotationtime
    nsslapd-accesslog-logrotationtime: -1
    -
    replace: nsslapd-accesslog
    nsslapd-accesslog: /var/log/dirsrv/slapd-localhost/access.pipe
    -
    replace: nsslapd-accesslog-logbuffering
    nsslapd-accesslog-logbuffering: off

-   nsslapd-accesslog - specify the full path and filename of the named pipe - this case assumes the use of a new file and not the replacement of the existing file with the pipe
-   nsslapd-accesslog-logbuffering - the script can do the buffering, so you usually want to turn this off
-   nsslapd-accesslog-maxlogsperdir, nsslapd-accesslog-logexpirationtime, nsslapd-accesslog-logrotationtime - these control log rotation - if using a pipe, you do not want the server to rotate the log pipe
-   nsslapd-accesslog-logging-enabled - by default the access log and error logs are enabled - the audit log is not - set this attribute to "on" or "off" to enable and disable logging

NOTE: Before doing this, you should save your current configuration so you can restore it later.

    ldapsearch ... -s base -b "cn=config" nsslapd-accesslog-maxlogsperdir nsslapd-accesslog-logexpirationtime \
     nsslapd-accesslog-logrotationtime nsslapd-accesslog nsslapd-accesslog > savedaccesslog.ldif

If the server is running, and the log pipe is active, if you use this LDIF with ldapmodify -f, the server will immediately close the current log and begin using the new one. This is a great way to debug a live running server.

The error log and audit log have similarly named configuration attributes e.g. nsslapd-errorlog, nsslapd-auditlog. Note that the audit log is disabled by default - use nsslapd-auditlog-logging-enabled: on to enable it.

Starting pipe at server startup
-------------------------------

You may want to start the pipe when the server starts up and stop the pipe when the server shuts down. That is, start using the pipe when the init script starts up the server, either at boot time or via the "service" command.

You must first configure the server to use the pipe (see above).

Next, modify the initconfig script for the server. This script is used by the init script to set parameters for each instance.

    /etc/sysconfig/dirsrv-instancename    

NOTE: DO NOT MODIFY /etc/sysconfig/dirsrv

The script will usually look something like this:

    # These settings are used by the start-dirsrv and    
    # start-slapd scripts (as well as their associates stop    
    # and restart scripts).  Do not edit them unless you know    
    # what you are doing.    
    SERVER_DIR=/usr/lib/dirsrv ; export SERVER_DIR    
    SERVERBIN_DIR=/usr/sbin ; export SERVERBIN_DIR    
    CONFIG_DIR=/etc/dirsrv/slapd-srv ; export CONFIG_DIR    
    INST_DIR=/usr/lib/dirsrv/slapd-srv ; export INST_DIR    
    RUN_DIR=/var/run/dirsrv ; export RUN_DIR    
    DS_ROOT= ; export DS_ROOT    
    PRODUCT_NAME=slapd ; export PRODUCT_NAME    
    # Put custom instance specific settings below here.    

Do not change anything before that last line. After that last line, add something like the following:

    errpidfile=$RUN_DIR/dslogpipe-srv-errs.pid    
    # see if there is already a logpipe running - doing a stop or    
    # restart (which first calls stop) should have made the old    
    # one exit, but let's make sure we kill it first    
    if [ -f $errpidfile ] ; then    
           errpid=`cat $errpidfile`           
      if [ -n "$errpid" ] ; then    
        kill "$errpid" > /dev/null 2>&1    
      fi    
    fi    
    # only keep the last 1000 lines of the error log    
    python /usr/bin/ds-logpipe.py /var/log/dirsrv/slapd-srv/errors.pipe -m 1000 -u nobody \    
     -s $RUN_DIR/slapd-srv.pid \    
     -i $errpidfile >> /var/log/dirsrv/slapd-srv/errors 2>&1 &    
    # sleep gives the script a chance to create the pipe, if necessary    
    sleep 1    
    accpidfile=$RUN_DIR/dslogpipe-srv-acc.pid    
    # see if there is already a logpipe running - doing a stop or    
    # restart (which first calls stop) should have made the old    
    # one exit, but let's make sure we kill it first    
    if [ -f $accpidfile ] ; then    
           accpid=`cat $accpidfile`           
      if [ -n "$accpid" ] ; then    
        kill "$accpid" > /dev/null 2>&1    
      fi    
    fi    
    # only log failed binds    
    python /usr/bin/ds-logpipe.py /var/log/dirsrv/slapd-srv/access.pipe -u nobody \    
     -s $RUN_DIR/slapd-srv.pid \    
     -i $accpidfile --plugin=/usr/share/dirsrv/data/failedbinds.py \    
     failedbinds.logfile=/var/log/dirsrv/slapd-srv/access.failedbinds &    
    # sleep gives the script a chance to create the pipe, if necessary    
    sleep 1    

Using the -s \$RUN\_DIR/slapd-srv.pid argument tells the scripts to exit when the server exits, and that the server will write its pid to the file \$RUN\_DIR/slapd-srv.pid when it starts up. If the server fails to start, the scripts will by default exit in 60 seconds. Use the -t parameter to specify a timeout other than 60 seconds. The script itself has a pid file, specified with the -i argument. This prevents two scripts from running at the same time (e.g. if you call service dirsrv restart, for example).

Writing Plugins
---------------

You can write your own plugin. Two plugins are provided with the directory server. Your plugin must define a function called **plugin**, and may optionally define functions called **pre** and **post**.

### plugin function

The plugin function is called with each line of the log.

    def plugin(line):    
        retval = True    
        # do something with line    
        if something_is_bogus:    
            retval = False    
        return retval    

line is the line from the log. It is a single line and will have the newline (\\n) character at the end of the line. The plugin should normally return the value True. If the plugin detects some bad condition and wants to abort the pipe script, it should return the value False.

### pre function

The pre function is called when the plugin is loaded and is passed the command line arguments for the plugin as a dict.

    def pre(myargs):    
        retval = True    
        myarg = myargs['argname']    
        if isinstance(myarg, list): # handle list of values    
        else: # handle single value    
        if bad_problem:    
            retval = False    
        return retval    

The command line arguments specified by **pluginname.arg** are passed into the pre function in the dict argument. The argument name with the *pluginname.* is the dict key, and the dict value for that key is the command line argument value. If there is more than one argument with the same name, they are converted to a list of values.

    --plugin=/path/to/pluginname.py pluginname.arg1=foo pluginname.arg1=bar pluginname.arg2=baz    

is converted to a dict like this:

    {'arg1': ['foo', 'bar'],    
     'arg2': 'baz'}    

### post function

The post function is called when the log script is exiting.

    def post(): # no arguments    
        # do something    
        # no return value    

Troubleshooting
---------------

### My Server Is Hung

Q: My server is hung - it won't do anything - I can't kill it - what is it doing?

-   Check the ds-logpipe.py process - if the logpipe is dead, the server is hung writing to the log file, waiting for something to read it
-   Restart the logpipe script as you normally do, or if you have used /etc/sysconfig/dirsrv-NAME, try this (as root)

        # (. /etc/sysconfig/dirsrv-NAME)    

-   If you don't care about the output to the pipe, and you just want to clear the pipe, try this:

        cat /var/log/dirsrv/slapd-NAME/file.pipe > /dev/null    

