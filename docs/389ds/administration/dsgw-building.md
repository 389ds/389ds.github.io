---
title: "DSGW Building"
---

# Building the Directory Server Gateway Web Apps
-----------------------------------------------

Get the source
--------------

You can obtain the latest source code from CVS:

    git clone https://pagure.io/389-dsgw.git

The latest [tarballs]({{ site.baseurl }}/binaries/)

Requirements for building
-------------------------

You will need the following packages: nspr, nss, svrcore, mozldap, cyrus-sasl, adminutil - and their corresponding devel packages.

Building
--------

The build uses standard autotools files.

    mkdir dsgw.build ; cd dsgw.build
    [CFLAGS=-g] /path/to/dsgw/configure [--with-fhs|--with-fhs-opt|--prefix=[/opt/fedora-ds]] [--enable-debug]]
    make
    make install

Use CFLAGS=-g and --enable-debug if you plan on doing some debugging with a debugger.

Testing/Debugging
-----------------

The directory dsgw/tests contains lots of tests. The first thing you will need to do is to edit setup.sh to fit your environment - tell it which admin server and directory server to use.

    vi setup.sh
    cd dsgw.build
    /path/to/dsgw/tests/setup.sh /path/to/dsgw/tests

This will create two subdirs - testtmp containing config files and other files used for testing, and a results directory containing the results of running your tests - the html output and the valgrind output if you are using valgrind. You can edit setup.sh to use gdb instead of valgrind, and you can change the list of programs to run if you just want to run a single program. If you want to run a select number of tests, just go to the dsgw/tests/PROGNAME directory and move/remove the tests you do not want to run.

If you want to debug the CGI programs in place, use CFLAGS=-g and --enable-debug above with configure and make. This will create wrapper shell scripts for all of the CGI programs in /usr/lib[64]/dirsrv/dsgw-cgi-bin. To debug a program e.g. dosearch:

    cd /usr/lib[64]/dirsrv/dsgw-cgi-bin
    cp dosearch dosearch.orig
    cp dosearch.sh dosearch

Then if you run the web app through the web browser, and the dosearch CGI is run, an xterm window should pop up running the web app with gdb. You can also configure the wrapper script to run valgrind instead.

