---
title: "Howto: ResetDirMgrPassword"
---

# How to Reset the Directory Manager Password
-------------------------------------------

If you forget the directory manager password, it's pretty easy to reset it. You will have to edit the main server config file (dse.ldif). Before you do that, you must shutdown the server. If the server is running and you edit dse.ldif, your changes will be lost.

    service dirsrv stop [yourinstance]    

or on Fedora DS 1.0.x and earlier

    /opt/fedora-ds/slapd-yourinstance/stop-slapd    

Next, generate the new password using the pwdhash command.

    /usr/bin/pwdhash newpassword    

or on Fedora DS 1.0.x and earlier

    cd /opt/fedora-ds/bin/slapd/server ; ./pwdhash -D /opt/fedora-ds/slapd-yourinstance newpassword    

This will print out the hashed password string using the default directory manager password hashing scheme for your instance (SSHA by default). Then

    cd /etc/dirsrv/slapd-yourinstance    

or on Fedora DS 1.0.4 and earlier

    cd /opt/fedora-ds/slapd-yourinstance/config    

Edit dse.ldif (you should have already shutdown the server - see above) - search for nsslapd-rootpw - you will see a line like this:

    nsslapd-rootpw: {SSHA}92ls0doP1i0VgQMm8jMjGw27AzVEzyLJS9sj02==    

Replace the value with the value printed out by pwdhash and save the file. Then restart the server

    service dirsrv start [yourinstance]    

or on Fedora DS 1.0.x and earlier

    /opt/fedora-ds/slapd-yourinstance/start-slapd    
    ldapsearch -x -D "cn=directory manager" -w newpassword -s base -b "" "objectclass=*"    

to test your new password.

