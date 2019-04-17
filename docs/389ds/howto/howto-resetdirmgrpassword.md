---
title: "Howto: Reset Directory Manager Password"
---

# How to Reset the Directory Manager Password
-------------------------------------------

{% include toc.md %}

If you forget the directory manager password or you want to change it, it's pretty easy to reset it. Here are several ways to reset the Directory Manager password.

### Manually Update dse.ldif (forgot the password)

You can edit the main server configuration file (dse.ldif) to reset the password if you have forgotten it.  But before you do that, you must shutdown the server.  If the server is running and you edit dse.ldif, your changes will be lost!

#### Stop The Server

    stop-dirsrv [yourinstance]

For *389-ds-base-1.4.x* use:

    dsctl YOUR_INSTANCE stop

#### Generate The New Password

    /usr/bin/pwdhash your_new_password

This will print out the hashed password string using the default directory manager password hashing scheme for your instance.  Save the hahsed password forthe next step

#### Edit The Config File

Goto the your instance's configuration directory

    cd /etc/dirsrv/slapd-yourinstance


Edit dse.ldif (you should have already shutdown the server - see above), then search for nsslapd-rootpw and you will see a line like this:

    nsslapd-rootpw: {SSHA}92ls0doP1i0VgQMm8jMjGw27AzVEzyLJS9sj02==

Replace the value with the value printed out by pwdhash and save the file. 

### Start The Server

    start-dirsrv [yourinstance]

For *389-ds-base-1.4.x* use

    dsctl YOUR_INSTANCE start

#### Verify the change worked

Then test your new password

    ldapsearch -x -D "cn=directory manager" -w newpassword -s base -b "" "objectclass=*"

<br>

### Use CLI Tools (must know current password)

You can use ldapmodify to change the Directory Manager's password, and if you are *389-ds-base-1.4.x* you can use the new CLI tool **dsconf**.

#### Use ldapmodify

Since you're updating the password over the network in clear text you should be using LDAPS/StartTLS.

    # ldapmodify -x -H "ldaps://server.example.com:636" -D "cn=directory manager" -w YOUR_CURRENT_PASSWORD
    dn: cn=config
    changetype: modify
    replace: nsslapd-rootpw
    nsslapd-rootpw: YOUR_NEW_PASSWORD
    <press enter twice>

#### Use dsconf

dsconf has a nice interactive interface and it will automatically use the most secure protocol available on the server.  This is only available on *389-ds-base-1.4.x*

    dsconf -D "cn=Directory Manager" YOUR_INSTANCE directory_manager password_change

Example

    # dsconf -D "cn=Directory Manager" slapd-localhost directory_manager password_change
    Enter password for cn=Directory Manager on localhost:  <type something>
    Enter new directory manager password :  <type something new>
    CONFIRM - Enter new directory manager password : <confirm something new>

