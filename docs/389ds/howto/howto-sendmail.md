---
title: "Howto:Sendmail"
---

# Sendmail with FDS EASY
--------------------------

-   In Fedora Linux:

`Edit the system authentication with system-config-authentication as root.`
`Enable the ldap Support for Information User and Authentication.`
`Configure the LDAP opcion with your ldap adress and DN base.`

**IMPORTANT**
-------------

-   Create the user home directory for your user, example: Your home directory path is: /home

`Add new home for new user: mkdir /home/newuser`
`Change the user owner with: chown 600.600 /home/newuser`

-   Create the new account int FDS console.

Enable the Posix User

`Complete the required data (UID number, GID numer, Home Directory)`
`In this case:`
` UID Value = 600`
` GID Value = 600`
` Home Directory Value = /home/newuser`

Is everything, is very easy!!!

**CAUTION**
-----------

-   If you need restart the server, first do rollback the authentication config (Dismark on system-config-authentication as root the User Information and Authentication in the LDAP options.)

`When server is up, execute /opt/fedora-ds/start-admin.`
`After enable the config for LDAP with system-config-authentication.`

If you don't make this, Fedora Admin fail the user authenticate. I don't know why?
