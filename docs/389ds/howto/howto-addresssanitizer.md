---
title: Address Sanitization
---

# Introduction
--------------

Address Sanitization is a gcc extension which can be used to detect overflows and other memory errors in applications. It was introduced to 389 in [ticket 48350](https://fedorahosted.org/389/ticket/48350)

# Dependencies
--------------

This assumes you are using Fedora, Centos or Red Hat Enterprise Linux.

You will need to checkout the source as per [the development page](development.html)

Install the required libraries

    sudo yum install libasan llvm

LLVM is used to print the trace in a more readable format. It's not used for compilation.

# Configuration
---------------

You should configure ds with the following:

    cd ds
    ./configure --enable-debug --enable-asan
    make
    sudo make install

If you wish to build and test with rpms:

    cd ds
    ./configure --enable-debug --enable-asan
    make rpms
    yum localinstall ....

This will work correctly with both start-dirsrv and systemctl start dirsrv@.service

# Testing
---------

You can now test ns-slapd. You may find that setup-ds.pl hangs. You should try running with --debug in this case.

    setup-ds.pl --debug

If setup-ds.pl hangs, it's (likely) that ASAN caused ns-slapd to terminate before startup could complete. ctrl - c the setup-ds.pl process and proceed as normal.

To test, run ns-slapd in the foreground:

    ns-slapd -D /prefix/etc/dirsrv/slapd-<instance>/ -d 0

Or you can run as normal:

    start-dirsrv
    OR
    systemctl start dirsrv@.service

If you encounter an issue you will find a trace dumped into /var/run/dirsrv/*.asan

The contents of such an error will be as such:

    =================================================================
    ==30761== ERROR: AddressSanitizer: global-buffer-overflow on address 0x7f5ecba8c2bf at pc 0x7f5ed5604517 bp 0x7fff1bb938f0 sp 0x7fff1bb938e0
    READ of size 1 at 0x7f5ecba8c2bf thread T0
        #0 0x7f5ed5604516 in slapi_ldap_url_parse /home/wibrown/development/389ds/ds/ldap/servers/slapd/ldaputil.c:342
        #1 0x7f5ecba73dcc in cb_instance_hosturl_set /home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c:692
        #2 0x7f5ecba78950 in cb_instance_config_set /home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c:1506
        #3 0x7f5ecba7058a in cb_instance_config_set_default /home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c:145
        #4 0x7f5ecba7ae4c in cb_create_default_backend_instance_config /home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c:1911
        #5 0x7f5ecba651ec in cb_config_load_dse_info /home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_config.c:143
        #6 0x7f5ecba8429c in chainingdb_start /home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_start.c:36
        #7 0x7f5ed568c59d in plugin_call_func /home/wibrown/development/389ds/ds/ldap/servers/slapd/plugin.c:1920
        #8 0x7f5ed568c2b8 in plugin_call_one /home/wibrown/development/389ds/ds/ldap/servers/slapd/plugin.c:1870
        #9 0x7f5ed568b6bf in plugin_dependency_startall /home/wibrown/development/389ds/ds/ldap/servers/slapd/plugin.c:1679
        #10 0x7f5ed568c149 in plugin_startall /home/wibrown/development/389ds/ds/ldap/servers/slapd/plugin.c:1832
        #11 0x43de5b in main /home/wibrown/development/389ds/ds/ldap/servers/slapd/main.c:1054
        #12 0x7f5ed2728af4 in __libc_start_main /usr/src/debug/glibc-2.17-c758a686/csu/libc-start.c:274
        #13 0x40ee98 in _start (/opt/dirsrv/sbin/ns-slapd+0x40ee98)
    0x7f5ecba8c2bf is located 1 bytes to the left of global variable '*.LC1 (/home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c)' (0x7f5ecba8c2c0) of size 1
      '*.LC1 (/home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c)' is ascii string ''
    0x7f5ecba8c2bf is located 47 bytes to the right of global variable '*.LC0 (/home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c)' (0x7f5ecba8c280) of size 16
      '*.LC0 (/home/wibrown/development/389ds/ds/ldap/servers/plugins/chainingdb/cb_instance.c)' is ascii string 'nsFarmServerURL'
    SUMMARY: AddressSanitizer: global-buffer-overflow /home/wibrown/development/389ds/ds/ldap/servers/slapd/ldaputil.c:342 slapi_ldap_url_parse
    Shadow bytes around the buggy address:
      0x0fec59749800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      0x0fec59749810: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      0x0fec59749820: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      0x0fec59749830: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
      0x0fec59749840: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    =>0x0fec59749850: 00 00 f9 f9 f9 f9 f9[f9]01 f9 f9 f9 f9 f9 f9 f9
      0x0fec59749860: 00 00 04 f9 f9 f9 f9 f9 00 00 00 01 f9 f9 f9 f9
      0x0fec59749870: 00 00 07 f9 f9 f9 f9 f9 02 f9 f9 f9 f9 f9 f9 f9
      0x0fec59749880: 00 00 00 04 f9 f9 f9 f9 03 f9 f9 f9 f9 f9 f9 f9
      0x0fec59749890: 00 00 00 00 f9 f9 f9 f9 02 f9 f9 f9 f9 f9 f9 f9
      0x0fec597498a0: 00 00 06 f9 f9 f9 f9 f9 03 f9 f9 f9 f9 f9 f9 f9
    Shadow byte legend (one shadow byte represents 8 application bytes):
      Addressable:           00
      Partially addressable: 01 02 03 04 05 06 07
      Heap left redzone:     fa
      Heap righ redzone:     fb
      Freed Heap region:     fd
      Stack left redzone:    f1
      Stack mid redzone:     f2
      Stack right redzone:   f3
      Stack partial redzone: f4
      Stack after return:    f5
      Stack use after scope: f8
      Global redzone:        f9
      Global init order:     f6
      Poisoned by user:      f7
      ASan internal:         fe
    ==30761== ABORTING

From here you can then determine the fault in ns-slapd. This fault has already been isolated in [ticket 48351](https://fedorahosted.org/389/ticket/48351)

# Extra
-------

If you are running on Fedora 24 or rawhide, and NO address issues occur, you may still find a trace. This is the memory leak detector, similar to valgrind.

# References
------------

- [Address Sanitizer Github](https://github.com/google/sanitizers/tree/master/address-sanitizer)

# Author
--------

William Brown (wibrown at redhat.com)


