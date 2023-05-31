---
title: "Systemd Ask Password Integration"
---

# Dirsrv and Svrcore Integration for Systemd Ask Password
---------------------------------------------------------

{% include toc.md %}

Overview
========

In EL6 and before, the system was started with upstart and rc.d scripts. During this process, when the user called:

    service start dirsrv

In the abscence of a pin.txt in /etc/dirsrv/slapd-instance/, the administrator could be propmted on the tty for a pin.

However, as systemd has taken over, this is no longer the case. Services are started in a way that has the detached from the TTY, meaning pins could not be requested. For Directory Server, the only option was a pin.txt, or to start with the scripts such as /usr/sbin/start-dirsrv.

This design will detail the changes made in Directory Server, SVRCore and the Systemd Ask Password Api.

Directory Server
----------------

The changes to Directory Server are minimal. In the case that we have --with-systemd we use the SVRCOREStdSystemdPinObj Rather than the SVRCOREStdPinObj.

Systemd Ask Password Api
------------------------

The systemd ask password api is intended to allow service so ask system for a password. This allows an admin to provide the pin material in a variety of ways: Either a plymouth screen during start up, via the systemctl command, or with a systemd-tty-ask-password tool.

However, the documentation of how to request these passwords as an application is undocumented. (until now).

The process to request an pin from system is quite involved. If possible you should link to SVRCore and use our implementation. Alternatively you can shell to the systemd command line tool. Systemd do not provide a library you can link to to provide this support.

### Api documentation for systemd ask password.

Follow these steps in order.

#### File paths

All files will be placed into the directory: /run/systemd/ask-password/

You must create an AF_UNIX socket named sck.random. I used PID instead of random.

The socket should be created with with SOCK_DGRAM and SOCK_CLOEXEC options. Additionally, the socket once bound to the sck.XXXX file should be set with SO_PASSCRED. This is to verify that the response only comes from root:root.

You must create a temporary INF file. It must NOT start with the key word "ask". It should be created with the umask S_IWGRP and S_IWOTH. Like sck, it should be named tmp.XXXX.

#### INF contents

The contents of this are partially documented at: <https://www.freedesktop.org/wiki/Software/systemd/PasswordAgents/>

To note, 0 implies false in this file.

Key is the NotAfter is from CLOCK_MONOTONIC and usecs.

You should use the full path to the AF_UNIX socket.

This file is then moved to ask.XXXX

#### Sockets

A loop is established to watch the socket.

Messages are recieved with authenticated packets via ucred and cmsghdr.

When a packet is recieved the headers should be checked for correctness. It must contain SCM_CREDENTIALS as the control.cmsghdr.cmsg_type. If the message authentication cannot be validated, this should delay, and check for new messages.

The control cmsghdr should be checked that the sender was from root of the same system. If this fails, this should delay and wait check for new messages.

The value of the message buffer is a null terminated char array. The first char has meaning.

#### Message contents

If the first char is +, this indicates a success.

If the first char is -, this indicates the client canceled the input.

If the first char is neither + or -, this should delay and check for new messages.

All chars following the + is a success are the password.

"" is a valid password, so a check for a string containing only +, should be made to determine if the password is empty.

#### Clean up

Finally, the socket should be closed and deleted. The ask. file should be unlinked.


SVRCore
-------

### Systemd ask pass.

Svrcore has implement the pin requestor component of the systemd-ask-pass api. This is done in systemd-ask-pass.c.

### SVRCOREStdPinObj

The SVRCOREStdPinObj type would check for a pin.txt first. In that file it will iterate over the lines attempting to find a line that matches token name, split with a :. all chars after the : are considered to be the pin.

Ie the file pin.txt may contain:

    internal (software):hello

If there is no pin.txt, or there is no line with a token name matching the request, the user is prompted on the TTY for a pin for the token. This will appear as:

    # start-dirsrv
    Enter PIN for internal (software):

### SVRCOREStdSystemdPinObj

A new pin handler was added to prevent disruption to users of the SVRCOREStdPinObj pin type. This is because SVRCOREStdSystemdPinObj has a number of behaviours that are systemd specific and may not exist on other platforms or systems.

The workflow is the same as SVRCOREStdPinObj, except that a check is added to the tty prompt. If no TTY is connected, the request is dispatched to systemd-ask-password via the api as documented above.

Ie:

    pin.txt
    if found:
        return pin
    else:
        is tty?:
             tty prompt
             return response
        else: #no tty
             systemd-ask-pass
             return response

Demo code for this can be found in svrcore/examples.



