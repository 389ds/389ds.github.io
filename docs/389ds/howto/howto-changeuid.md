---
title: "Howto: ChangeUid"
---

# How to change the uid starting and running the directory server
---------------------------------------------------------------

Stop the server:

    <server-root>/slapd-<instance-name>/stop-slapd    
      or
    stop-dirsrv   --> this only works if there is only one instance on the system
      or
    stop-dirsrv <server name>
    stop-dirsrv localhost

Change your key and cert file ownerships:

    chown <some-uid>:<some-group> /<server-root>/alias/slapd-<instance-name>-*

    ls -l <server-root>/alias/slapd-<instance-name>-*
    -rw------- 1 <some-uid> <some-gid> 65536 Jul 20 08:35 <server-root>/alias/slapd-<instance-name>-cert8.db
    -rw------- 1 <some-uid> <some-gid> 16384 Jul 20 08:35 <server-root>/alias/slapd-<instance-name>-key3.db

Save or backup your <server-root>/slapd-<instance-name> and alias directories

Change all file permissions both for data and for configuration files:

    ls -laR bak changelogdb confbak config db dsml ldif locks logs | less

    chown -R <some-uid>:<some-gid> bak changelogdb confbak config db dsml ldif locks logs

Edit dse.ldif and update nssldap-localuser to the user you want to run as:

    vi config/dse.ldif
    # nsslapd-localuser: nobody
    nsslapd-localuser: <some-uid>

Restart the server:

    tail -f  <server-root>/slapd-<instance-name>/logs/errors &

    <server-root>/slapd-<instance-name>/start-slapd
    389-Directory/1.3.3 B2014.197.21481.0.4
    <some-fqdm-hostname>:389 (<server-root>/slapd-<instance-name>)

    [17/Jul/2014:12:12:00 -0400] - 389-Directory/1.3.3.a2.git84477da B2014.197.2148 starting up
    [17/Jul/2014:12:12:00 -0400] - I'm resizing my cache now...cache was 5120000 and is now 4096000
    [17/Jul/2014:12:12:00 -0400] - slapd started.  Listening on All Interfaces port 389 for LDAP requests


Verification:

    lsof -i :389    
    COMMAND   PID    USER   FD   TYPE DEVICE SIZE NODE NAME    
    ns-slapd 5926     <some-uid>     6u  IPv4  19962       TCP *:ldap (LISTEN)    

    export LD_LIBRARY_PATH=/opt/389-ds/shared/lib/    
    /opt/389-ds/shared/bin/ldapsearch -b    

