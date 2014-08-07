---
title: "Howto: Dovecot"
---

# integrating Dovecot with FDS+Postfix
--------------------------------------

This application is used so that the postfix MTA could connect to FDS via both IMAP or POP3. You will need another file which is /etc/dovecot-ldap.conf as part of /etc/dovecot.conf. The detail are shown below:

Dovecot main config
-----------------------

    protocols = imap pop3
    listen = [::]
    default_mail_env = maildir:~/Maildir
    auth default {
    mechanisms = plain
      passdb ldap {
        # Path for LDAP configuration file, see doc/dovecot-ldap.conf for example
        args = /etc/dovecot-ldap.conf
      }
      userdb ldap {
        # Path for LDAP configuration file, see doc/dovecot-ldap.conf for example
        args = /etc/dovecot-ldap.conf
      }

Using FDS as backend
------------------------

As I don't find any best matched schema for postfix to able to integrate with FDS, so the built-in schema with mailgroup object may the best choice ever...:-) I only use two attribute of mailgroup to get this done, which is "mail" and "mgrpDeliverTo".

    hosts = fdsvr.fds.co.id
    dn = "cn=Directory Manager"
    dnpass = "fdsmanager"
    ldap_version = 3
    base = dc=fds, dc=co, dc=id
    deref = never
    scope = subtree
    user_filter = (&(objectClass=mailgroup)(mgrpDeliverTo=%u))
    pass_filter = (&(objectClass=posixAccount)(uid=%u))
    default_pass_scheme = CRYPT
