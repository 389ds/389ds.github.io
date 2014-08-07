---
title: "Performance Tuning"
---

# Performance Tuning
--------------------

{% include toc.md %}

Operating System Tuning Parameters
----------------------------------

### Solaris

The system-wide maximum file descriptor table size setting will limit the number of concurrent connections that can be established to Directory Server. The governing parameter, `rlim_fd_max`, is set in the /etc/system file. By default, if this parameter is not present, the maximum is 1024. It can be raised to 4096 by adding to /etc/system a line

    set rlim_fd_max=4096

and rebooting the system.

By default, the TCP/IP implementation in a Solaris kernel is not correctly tuned for Internet or Intranet services. The following /dev/tcp tuning parameters should be inspected and, if necessary, changed to fit the network topology of the installation environment.

The `tcp_time_wait_interval` in Solaris 8 specifies the number of milliseconds that a TCP connection will be held in the kernel's table after it has been closed. If its value is above 30000 (30 seconds) and the directory is being used in a LAN, MAN or under a single network administration, it should be reduced by adding a line similar to the following to the /etc/init.d/inetinit file:

    ndd -set /dev/tcp tcp_time_wait_interval 30000

The `tcp_conn_req_max_q0` and `tcp_conn_req_max_q` parameters control the maximum backlog of connections that the kernel will accept on behalf of the Directory Server process. If the directory is expected to be used by a large number of client hosts simultaneously, these values should be raised to at least 1024 by adding a line similar to the following to the /etc/init.d/inetinit file:

    ndd -set /dev/tcp tcp_conn_req_max_q0 1024
    ndd -set /dev/tcp tcp_conn_req_max_q 1024

The `tcp_keepalive_interval` specifies the interval in seconds between keepalive packets sent by Solaris for each open TCP connection. This can be used to remove connections to clients that have become disconnected from the network.

The `tcp_rexmit_interval_initial` value should be inspected when performing server performance testing on a LAN or high speed MAN or WAN. For operations on the wide area Internet, its value need not be changed.

The `tcp_smallest_anon_port` controls the number of simultaneous connections that can be made to the server. When `rlim_fd_max` has been increased to above 4096, this value should be decreased, by adding a line similar to the following to the /etc/init.d/inetinit file:

    ndd -set /dev/tcp tcp_smallest_anon_port 8192

The `tcp_slow_start_initial` parameter should be inspected if clients will predominately be using the Windows TCP/IP stack.

### HP/ux

Set your kernel parameters as follows:

-   Set maxfiles to 100 (the old value was 60).
-   Set nkthread to 1328 (the old value was 499); nkthread is a computed value: (((NPROC*7)/4+16).
-   Set max\_thread\_proc to 512 (the old value was 64).
-   Set maxusers to 64 (the old value was 32).
-   Set maxuprc to 512 (the old value was 75).
-   Set nproc to 750, a new value which is not based on a formula (the old formula was 20+8*MAXUSERS, which evaluated to 276).

Typically, client applications that do not properly shut down the socket cause it to linger in a TIME\_WAIT state. To prevent this, you should consider changing the TIME\_WAIT setting to a reasonable value. For example, setting

    ndd -set /dev/tcp tcp_time_wait_interval 60000

will limit the TIME\_WAIT state of sockets to 60 seconds.

You also need to turn on large file support in order for Directory Server to work properly. To change an existing file system (from one that has no large files to one that accepts large files):

1.  Unmount the system using the umount command. For example:
     umount /export
2.  Create the large file system. For example:
     fsadm -F vxfs -o largefiles /dev/vg01/rexport
3.  Remount the file system. For example:
    /usr/sbin/mount -F vxfs -o largefiles /dev/vg01/export

### Linux

-   TCP Tuning - You can increase number of local system ports available by running this command:

        echo "1024 65000" > /proc/sys/net/ipv4/ip_local_port_range

You can also achieve the same by editing this parameter in the /etc/sysctl.conf file:

        echo "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
   

-   File Tuning-You can increase the file descriptors by running these commands:

        echo "64000" > /proc/sys/fs/file-max

or edit this parameter in the /etc/sysctl.conf file:

        echo "fs.file-max = 64000" >> /etc/sysctl.conf

        echo "* soft nofile 8192" >> /etc/security/limits.conf

        echo "* hard nofile 8192" >> /etc/security/limits.conf

        echo "ulimit -n 8192" >> /etc/profile

If using systemd - see [How do I increase the file descriptor limit](../howto/howto-systemd.html#increase-fd)

If not using systemd, edit /etc/sysconfig/dirsrv (or on Fedora DS 1.0.4 and earlier, /opt/fedora-ds/slapd-instance/start-slapd) and put the following line somewhere near the top:

    ulimit -n 8192

You also have to add the following to **cn=config (dse.ldif)**.

    nsslapd-maxdescriptors: 8192

Database Tuning Considerations
------------------------------

The filesystem cache doesn't really perform better than the database cache. (Pages that are in the db cache are used directly from process memory. Any page that is not resident in the db cache must be fetched from the filesystem, incurring a user/kernel transition and a memory copy of the payload.) Someone way back ran some tests and convinced themselves that it did, and then wrote that doc ;) Actually there was some basis in reality until recently we didn't have a 64-bit Solaris version, however the filesystem cache was able to use 64-bit address space. So for VLDB deployments it was true that the filesystem cache delivered better overall use of system memory beyond 2-ishGbytes.

But, the filesystem cache does ok (as is the case on all modern OS'es) so if you aren't looking for tip-top performance it's fine to configure a smallish db cache and rely mostly on the filesystem.

One thing to note is that the db cache is mmap'ed, and Solaris does some very strange and evil things with mmap'ed files that are not in tmpfs filesystems (it will decide all of a sudden to write back dirty pages to disk at an amazing rate, to the exclusion of performing all other useful work on the box). The solution to this problem is documented : put the db home dir in tmpfs (or use sysv memory, but that's not officially supported I don't think).

