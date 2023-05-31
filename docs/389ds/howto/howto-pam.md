---
title: "Howto: PAM"
---

# PAM Configuration for LDAP Client Systems
-----------------------------------------

{% include toc.md %}

PAM stands for Pluggable Authentication Modules. It is a system that allows administrators the flexibility to "stack" modules that are functionally useful in their given environment. In addition, application developers no longer need to write their own code to talk to an LDAP server - they can offload this responsibility to PAM by linking against the PAM system libraries. This HOWTO is designed to make it easy to understand and configure the pam\_ldap module for client systems that need to authenticate against an LDAP server.

### Red Hat Clients

As root run:

    authconfig --test    

It will display current settings for both nss\_ldap and pam\_ldap.

On Red Hat systems, it is quite likely that PAM is configured for you during installation, during a kickstart, or by running the /usr/bin/authconfig utility. In the event that you're in the position of having to set things up manually, in most cases the following command will do the job (although some manual editing will still be needed):

    /usr/sbin/authconfig --enablesssd --enablesssdauth --ldapserver=ldap.ipa.example.com --ldapbasedn=cn=accounts,dc=ipa,dc=example,dc=com --enablerfc2307bis --updateall

Or if you want to do an "anonymous" auth to freeipa:

    /usr/sbin/authconfig --enablesssd --enablesssdauth --ldapserver=ldap.ipa.example.com --ldapbasedn=cn=accounts,dc=ipa,dc=example,dc=com --enablerfc2307bis --krb5kdc=kdc.ipa.example.com --krb5realm=IPA.EXAMPLE.COM --updateall

The last parameter will update /etc/sssd/sssd.conf, /etc/nsswitch.conf, /etc/pam.d/system-auth-ac and /etc/pam.d/password-auth-ac configuration files. There is also /usr/bin/authconfig-tui, which provides a very simple ncurses interface for configuring your LDAP client and /usr/bin/authconfig-gtk which displays an even nicer gtk interface.

Authconfig will alter your PAM files for you (among other things), specifically the file /etc/pam.d/system-auth. A typical system-auth file on a Red Hat system configured to authenticate using LDAP looks like this:

    #%PAM-1.0
    # This file is auto-generated.
    # User changes will be destroyed the next time authconfig is run.
    auth        required      pam_env.so
    auth        sufficient    pam_unix.so try_first_pass
    auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
    auth        sufficient    pam_sss.so use_first_pass
    auth        required      pam_deny.so

    account     required      pam_unix.so
    account     sufficient    pam_localuser.so
    account     sufficient    pam_succeed_if.so uid < 1000 quiet
    account     [default=bad success=ok user_unknown=ignore] pam_sss.so
    account     required      pam_permit.so

    password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
    password    sufficient    pam_unix.so sha512 shadow try_first_pass use_authtok
    password    sufficient    pam_sss.so use_authtok
    password    required      pam_deny.so

    session     optional      pam_keyinit.so revoke
    session     required      pam_limits.so
    -session    optional      pam_systemd.so
    session     required      pam_tty_audit.so enable=*
    session     optional      pam_oddjob_mkhomedir.so umask=0077
    session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
    #disable= enable=root
    session     required      pam_unix.so
    session     optional      pam_sss.so


It is important to understand why this file works. For now, let's concentrate on the lines beginning with the "auth" keyword. In the second field of each line is a keyword telling the PAM subsystem what to do depending on whether the module in question succeeds or fails. In the case of the "auth" management realm, we can see that there are five modules being referenced. These will be called in the order listed, starting with pam\_env in this case. The pam\_env module is listed as "required". Here are the possible values for the "control" field, and what they mean:

-   **required** - If a 'required' module returns a status that is not 'success', the operation will ultimately fail, but only after the modules below it are invoked. This might seem senseless at first glance, but it serves the purpose of always acting the same way from the point of view of the user trying to utilize the service. The net effect is that it becomes impossible for a potential cracker to determine which module caused the failure - and the less information a malicious user has about your system, the better. Important to note is that even if all of the modules in the stack succeed, failure of one 'required' module means the operation will ultimately fail. Of course, if a required module succeeds, the operation can still fail if a 'required' module later in the stack fails.
-   **requisite** - If a 'requisite' module fails, the operation not only fails, but the operation is immediately terminated with a failure without invoking any other modules: 'do not pass go, do not collect \$200', so to speak.

-   **sufficient** - If a sufficient module succeeds, it is enough to satisfy the requirements of sufficient modules in that realm for use of the service, and modules below it that are also listed as 'sufficient' are not invoked. If it fails, the operation fails unless a module invoked after it succeeds. Important to note is that if a 'required' module fails before a 'sufficient' one succeeds, the operation will fail anyway, ignoring the status of any 'sufficient' modules.
-   **optional** - An 'optional' module, according to the pam(8) manpage, will only cause an operation to fail if it's the only module in the stack for that facility.

So given this information, let's walk through our auth management realm to see what's happening:

1.  The 'pam\_env' module will set environment variables based on what the administrator has set up in /etc/security/pam\_env.conf. In default configurations of Red Hat and Fedora, no default variables are set, so let's move on.
2.  The 'pam\_unix' module is invoked next, and will do the work of prompting the user for a password. Note that this module is "sufficient" and not "required". This means if you succeed to authenticate, a tentative allow is set for you to proceed.
3.  path 'pam\_succeed\_if' is invoked. This checks if the account you are attempting to login as has a uid >= 1000. If you have a high uid, this module passes, and control continues. If this fails, control is returned with a failure.
4.  The 'pam\_sssd' module is invoked, and is told to "use\_first\_pass", in other words, use the password that was collected by the pam\_unix module instead of prompting the user for another password. Note that the fact that this module is marked "sufficient", and it's positioned after pam\_unix means that if pam\_unix succeeds in checking a password locally, pam\_sssd won't be invoked at all.
5.  Finally, pam\_deny is invoked. This module ignores all options, and always fails, making it a good "clean up rule". If this was not in place, there are cases by which pam can implicitly allow a user authentication *even with no password*.


### Solaris Clients

Solaris uses a completely different model for PAM configuration. The entire configuration is located in a single file, called /etc/pam.conf. Instead of having a separate file for each service's PAM config, the /etc/pam.conf file just has an extra field on each line specifying the service in question. The net effect is the same. Here's a pam.conf file from a Solaris 9 client which successfully uses LDAP for user authentication:

    # PAM configuration     
    #    
    # Authentication management     
    #    
    # login service (explicit because of pam_dial_auth)    
    #    
    login  auth     requisite pam_authtok_get.so.1    
    login  auth     required  pam_dhkeys.so.1    
    login  auth     required  pam_dial_auth.so.1    
    login  auth     binding   pam_unix_auth.so.1 server_policy    
    login  auth     required  pam_ldap.so.1    
    #    
    sshd   auth requisite          pam_authtok_get.so.1    
    sshd   auth required           pam_dhkeys.so.1    
    sshd   auth sufficient         pam_unix_auth.so.1    
    sshd   auth required           pam_ldap.so.1 try_first_pass    
    sshd   account required        pam_unix_account.so.1    
    # rlogin service (explicit because of pam_rhost_auth)     
    #    
    rlogin  auth     sufficient pam_rhosts_auth.so.1    
    rlogin  auth     requisite  pam_authtok_get.so.1    
    rlogin  auth     required   pam_dhkeys.so.1    
    rlogin  auth     binding    pam_unix_auth.so.1 server_policy    
    rlogin  auth     required   pam_ldap.so.1    
    #    
    # rsh service (explicit because of pam_rhost_auth,    
    # and pam_unix_auth for meaningful pam_setcred)    
    #    
    rsh     auth sufficient         pam_rhosts_auth.so.1    
    rsh     auth required           pam_unix_auth.so.1    
    #    
    # PPP service (explicit because of pam_dial_auth)    
    #    
    ppp     auth requisite          pam_authtok_get.so.1    
    ppp     auth required           pam_dhkeys.so.1    
    ppp     auth required           pam_dial_auth.so.1    
    ppp     auth binding            pam_unix_auth.so.1 server_policy    
    ppp     auth required           pam_ldap.so.1    
    #    
    # Default definitions for Authentication management    
    # Used when service name is not explicitly mentioned for authentication    
    #    
    other   auth requisite          pam_authtok_get.so.1    
    other   auth required           pam_dhkeys.so.1    
    other   auth binding            pam_unix_auth.so.1 server_policy    
    other   auth required           pam_ldap.so.1    
    #    
    # passwd command (explicit because of a different authentication module)    
    #    
    passwd auth     binding   pam_passwd_auth.so.1 server_policy    
    passwd auth     required  pam_ldap.so.1    
    #    
    # cron service (explicit because of non-usage of pam_roles.so.1)    
    #    
    cron    account required        pam_projects.so.1    
    cron    account required        pam_unix_account.so.1    
    #    
    # Default definition for Account management    
    # Used when service name is not explicitly mentioned for account management     
    #    
    other  account  requisite pam_roles.so.1    
    other  account  required  pam_projects.so.1    
    other  account  binding   pam_unix_account.so.1 server_policy    
    other  account  required  pam_ldap.so.1    
    #    
    # Default definition for Session management    
    # Used when service name is not explicitly mentioned for session management     
    #    
    other   session required        pam_unix_session.so.1     
    #    
    # Default definition for Password management    
    # Used when service name is not explicitly mentioned for password management    
    #    
    other  password required  pam_dhkeys.so.1    
    other  password requisite pam_authtok_get.so.1    
    other  password requisite pam_authtok_check.so.1    
    other  password required  pam_authtok_store.so.1 server_policy    
    #    
    # Support for Kerberos V5 authentication (uncomment to use Kerberos)    
    #    
    #rlogin         auth optional           pam_krb5.so.1 try_first_pass    
    #login          auth optional           pam_krb5.so.1 try_first_pass    
    #other          auth optional           pam_krb5.so.1 try_first_pass    
    #cron           account optional        pam_krb5.so.1    
    #other          account optional        pam_krb5.so.1    
    #other          session optional        pam_krb5.so.1    
    #other          password optional       pam_krb5.so.1 try_first_pass    

Enforcing password policy
-------------------------

In sssd.conf set:

    ldap_account_expire_policy=rhds

This will cause the RHDS shadow and other policy components to be respected. When an account is approaching expiry, it will prompt for a password change etc.

