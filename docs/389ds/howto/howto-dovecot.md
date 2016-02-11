---
title: "Howto: Dovecot"
---

# integrating Dovecot with DS+Postfix
--------------------------------------

This application is used so that the postfix MTA could connect to DS via both IMAP. You will need another file which is /etc/dovecot-ldap.conf as part of /etc/dovecot.conf. The detail are shown below:

Dovecot main config
-----------------------

This is spread over many files:

    # dovecot.conf
    protocols = imap pop3
    listen = [::]

    # 10-auth.conf
    auth_mechanisms = plain
    !include auth-ldap.conf.ext

    # 10-master.conf
    service auth {
        unix_listener auth-userdb {
        }

        # Postfix smtp-auth
        unix_listener /var/spool/postfix/private/auth {
            mode = 0666
            user = postfix
            group = postfix
        }

    }

    # conf.d/auth-ldap.conf.ext
      passdb ldap {
        # Path for LDAP configuration file, see doc/dovecot-ldap.conf for example
        args = /etc/dovecot-ldap.conf
      }
      userdb ldap {
        # Path for LDAP configuration file, see doc/dovecot-ldap.conf for example
        args = /etc/dovecot-ldap.conf
      }

Using DS as backend
------------------------

This config means that every account's mail= is respected. If you have:

    uid: alice
    mail: alice@example.com
    mail: alice@corp.example.com
    mail: hostmaster@example.com.
    mail to "alice" will be sent to the same mailbox for all of these addresses

You login to the imap with: *any* of the mail addresses, and the userPassword of alice.
This can confuse doveadm sometimes

    $ doveadm user '*' 
    ...
    alice

But to refer to her mailbox, you use:

    $ doveadm mailbox list -u 'alice'
    doveadm(alice): Fatal: User doesn't exist
    $ doveadm mailbox list -u 'alice@example.com'
    ...
    INBOX

    # /etc/dovecot-ldap.conf
    uris = ldap://ldap.example.com
    tls = yes
    tls_ca_cert_file = /etc/ipa/ca.crt
    tls_require_cert = demand
    auth_bind = yes
    base = cn=users,cn=accounts,dc=ipa,dc=example,dc=com
    scope = onelevel
    user_attrs = uid=user
    user_filter = (&(objectClass=posixAccount)(mail=%u))
    pass_attrs = %u=user
    pass_filter = (&(objectClass=posixAccount)(mail=%u))
    iterate_attrs = uid=user
    iterate_filter = (objectClass=posixAccount)

Attaching postfix
-----------------

You can easily attach postfix to this via the auth socket you expose. This means postfix has the same view of users as dovecot.

    # master.cf
    dovecot   unix  -       n       n       -       -       pipe
      flags=DRhu user=vmail:vmail argv=/usr/libexec/dovecot/dovecot-lda -f ${sender} -d ${recipient}

    # main.cf
    dovecot_destination_recipient_limit = 1
    smtpd_sasl_type = dovecot
    smtpd_sasl_path = private/auth
    smtpd_sasl_auth_enable = yes
    smtpd_tls_auth_only = yes

Advanced: Many mailboxes for each account
-----------------------------------------

This is an advanced variation of the above. Instead of having one mailbox per user with many email addresses attached, this allows many mailboxes to each user.

The user would identify "which" mail box they want to over imap by using the email address of the mailbox, but the password of the object. IE

    uid: alice
    mail: alice@example.com
    mail: alice@corp.example.com
    mail: hostmaster@example.com.

Logging into imap with 'alice@example.com' and the userPassword for uid=alice, would give you access to the alice mailbox.
Logging into imap with 'hostmaster@example.com' and the userPassword for uid=alice, would give you access to the hostmaster mailbox.

This requires postfix to use dovecot sasl auth as postfix cannot do the ldap logic required for this setup.

The dovecot configuration is:

    # /etc/dovecot-ldap.conf
    uris = ldap://ldap.example.com
    tls = yes
    tls_ca_cert_file = /etc/ipa/ca.crt
    tls_require_cert = demand
    auth_bind = yes
    base = cn=users,cn=accounts,dc=ipa,dc=example,dc=com
    scope = onelevel
    user_attrs = mail=user
    user_filter = (&(objectClass=posixAccount)(mail=%u))
    pass_attrs = uid=user
    pass_filter = (&(objectClass=posixAccount)(mail=%u))
    iterate_attrs = mail=user
    iterate_filter = (objectClass=posixAccount)

