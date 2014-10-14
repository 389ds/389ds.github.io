---
title: "Security Modules, Console, and SELinux"
---

# Add Security Modules using the Console, and SELinux
----------------

This is only working correctly in 1.1.36 version of the 389-admin package.  The previous recommended way of adding modules is to use the "*modutil*" tool.

### Add the Security Module

-   Open the DS Instance console
-   Click on **Console** in the top menu
-   Then goto **Security**, then **Configure Security Modules**
    -   Due to CGI security issues with the Admin Server, all new security module libraries must exist, or have a symbolic link, in the DS instance security directory.  Typically this is **/etc/dirsrv/slapd-INSTANCE**
    -   The "*modutil*" tool does NOT have this restriction, only the Console
-   Choose "Install"
-   Enter just the libary name:  **libcknfast.so**
    -    The console will reject relative or absolute paths.
-   Enter a name of your choosing for the security module name/identifier.
-   Click OK

### SELinux Issues

Copying a security module library into the Directory Server instance security directory can conflict with existing SELinux policies.  An easy way to workaround this is use a symbolic link instead:

    /etc/dirsrv/slapd-INSTANCE/libcknfast.so -->  /opt/nfast/toolkit/pkcs11/libcknfast.so

Otherwise you will need to update the SELinux to account for the new file in its new location.



