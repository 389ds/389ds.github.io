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

    authconfig=`/usr/bin/which authconfig`
    $authconfig --enableldap --enableldapauth --disablenis --enablecache \
              --ldapserver=host.example.com --ldapbasedn=dc=example,dc=com \
              --updateall

The last parameter will update /etc/ldap.conf, /etc/nsswitch.conf and /etc/pam.d/system-auth configuration files. There is also /usr/bin/authconfig-tui, which provides a very simple ncurses interface for configuring your LDAP client and /usr/bin/authconfig-gtk which displays an even nicer gtk interface.

Authconfig will alter your PAM files for you (among other things), specifically the file /etc/pam.d/system-auth. A typical system-auth file on a Red Hat system configured to authenticate using LDAP looks like this:

    #%PAM-1.0
    # This file is auto-generated.    
    # User changes will be destroyed the next time authconfig is run.    
    auth        required      /lib/security/$ISA/pam_env.so    
    auth        sufficient    /lib/security/$ISA/pam_unix.so likeauth nullok    
    auth        sufficient    /lib/security/$ISA/pam_ldap.so use_first_pass    
    auth        required      /lib/security/$ISA/pam_deny.so    
    account     required      /lib/security/$ISA/pam_unix.so broken_shadow    
    account     sufficient    /lib/security/$ISA/pam_succeed_if.so uid < 100 quiet    
    #account                sufficient /lib/security/$ISA/pam_ldap.so    
    account     [default=bad success=ok user_unknown=ignore] /lib/security/$ISA/pam_ldap.so    
    account     required      /lib/security/$ISA/pam_permit.so    
    password    requisite     /lib/security/$ISA/pam_cracklib.so retry=3    
    password    sufficient    /lib/security/$ISA/pam_unix.so nullok use_authtok md5 shadow    
    password    sufficient    /lib/security/$ISA/pam_ldap.so use_authtok    
    password    required      /lib/security/$ISA/pam_deny.so    
    session     required      /lib/security/$ISA/pam_limits.so    
    session     required      /lib/security/$ISA/pam_unix.so    
    session     optional      /lib/security/$ISA/pam_ldap.so    

It is important to understand why this file works. For now, let's concentrate on the lines beginning with the "auth" keyword. In the second field of each line is a keyword telling the PAM subsystem what to do depending on whether the module in question succeeds or fails. In the case of the "auth" management realm, we can see that there are four modules being referenced. These will be called in the order listed, starting with pam\_env in this case. The pam\_env module is listed as "required". Here are the possible values for the "control" field, and what they mean:

-   **required** - If a 'required' module returns a status that is not 'success', the operation will ultimately fail, but only after the modules below it are invoked. This might seem senseless at first glance, but it serves the purpose of always acting the same way from the point of view of the user trying to utilize the service. The net effect is that it becomes impossible for a potential cracker to determine which module caused the failure - and the less information a malicious user has about your system, the better. Important to note is that even if all of the modules in the stack succeed, failure of one 'required' module means the operation will ultimately fail. Of course, if a required module succeeds, the operation can still fail if a 'required' module later in the stack fails.
-   **requisite** - If a 'requisite' module fails, the operation not only fails, but the operation is immediately terminated with a failure without invoking any other modules: 'do not pass go, do not collect \$200', so to speak.
-   **sufficient** - If a sufficient module succeeds, it is enough to satisfy the requirements of sufficient modules in that realm for use of the service, and modules below it that are also listed as 'sufficient' are not invoked. If it fails, the operation fails unless a module invoked after it succeeds. Important to note is that if a 'required' module fails before a 'sufficient' one succeeds, the operation will fail anyway, ignoring the status of any 'sufficient' modules.
-   **optional** - An 'optional' module, according to the pam(8) manpage, will only cause an operation to fail if it's the only module in the stack for that facility.

So given this information, let's walk through our auth management realm to see what's happening:

1.  The 'pam\_env' module will set environment variables based on what the administrator has set up in /etc/security/pam\_env.conf. In default configurations of Red Hat and Fedora, no default variables are set, so let's move on.
2.  The 'pam\_unix' module is invoked next, and will do the work of prompting the user for a password. The arguments "nullok" and "likeauth" mean that empty passwords are not treated as locked accounts, and that the module will return the same value (the value that is "like" the "auth" value), even if it is called as a credential setting module. Note that this module is "sufficient" and not "required".
3.  The 'pam\_ldap' module is invoked, and is told to "use\_first\_pass", in other words, use the password that was collected by the pam\_unix module instead of prompting the user for another password. Note that the fact that this module is marked "sufficient", and it's positioned after pam\_unix means that if pam\_unix succeeds in checking a password locally, pam\_ldap won't be invoked at all.
4.  Finally, pam\_deny is invoked. This module ignores all options, and always fails, making it a good "clean up rule".


### Red Hat clients with UID's less than 500

In RHEL5U2 there is a catch especially if you are using an LDAP server with uids which are less than 500. Linux assumes that uids and gids start at 500. Here is a typical /etc/pam.d/system-auth file (linked to /etc/pam.d/system-auth-ac):

     #%PAM-1.0
     # This file is auto-generated.
     # User changes will be destroyed the next time authconfig is run.
     auth        required      pam_env.so
     auth        sufficient    pam_unix.so nullok try_first_pass
     auth        requisite     pam_succeed_if.so uid >= 500 quiet
     auth        sufficient    pam_ldap.so use_first_pass
     auth        required      pam_deny.so

     account     required      pam_unix.so broken_shadow
     account     sufficient    pam_succeed_if.so uid < 500 quiet
     account     [default=bad success=ok user_unknown=ignore] pam_ldap.so
     account     required      pam_permit.so

     password    requisite     pam_cracklib.so try_first_pass retry=3
     password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok
     password    sufficient    pam_ldap.so use_authtok
     password    required      pam_deny.so

     session     optional      pam_keyinit.so revoke
     session     required      pam_limits.so
     session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
     session     required      pam_unix.so
     session     optional      pam_ldap.so

You will notice that in the 3rd auth line:

     auth        requisite     pam_succeed_if.so uid >= 500 quiet

That the uid is set to greater than or equal to 500. Not helpful if your uid in LDAP is 101 for instance. So change this to something like:

     auth        requisite     pam_succeed_if.so uid > 100 quiet_success

Please please make sure that you don't have someone with uid 100 first. In that case and expression such as uid \>= 100 would work. Now you may ask what does quiet\_success do, consult your man page for this lib, in short, don't log the successes, do be kind enough to log the errors thought :)

Next we need to fix the account section. This is what you have by default:

     account     sufficient    pam_succeed_if.so uid < 500 quiet

Lets change it to:

     account     sufficient    pam_succeed_if.so uid > 100 quiet_success

Again please make sure that you are in uid compliance with your ldap server. The directive quiet\_success will allow you to log the errors to the log /var/log/secure. That should get you on your way. You may encounter bug\# 4480418 <https://bugzilla.redhat.com/show_bug.cgi?id=448014> for which I recommend that you turn on nscd, its useful to have it on anyways. You should not expect to have this problem with RHEL4U4/U6.

I also found that there are some optimization tweaks for /etc/ldap.conf such as:

     bind_policy soft

This is useful comparatively to the exponential backoff strategy that the client uses. An immediate fail is useful to know about rather than you ssh prompt hanging waiting for the LDAP system to come back with an answer.

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

This section will define how to enable a password policy and have clients react appropriately to those policies. For this example we are going to use OpenSSH and password expiration.

-   Search and modify the following in /etc/ldap.conf on the client machines

     # Search the root DSE for the password policy (works    
     # with Netscape Directory Server)    
     pam_lookup_policy yes
     
     # Use the OpenLDAP password change    
     # extended operation to update the password.    
     pam_password exop

-   Configure OpenSSH to enable PAM authentication. Modify /etc/ssh/sshd\_config

     # Set this to 'yes' to enable PAM authentication, account processing,    
     # and session processing. If this is enabled, PAM authentication will    
     # be allowed through the ChallengeResponseAuthentication mechanism.    
     # Depending on your PAM configuration, this may bypass the setting of    
     # PasswordAuthentication, PermitEmptyPasswords, and    
     # "PermitRootLogin without-password". If you just want the PAM account and    
     # session checks to run without PAM authentication, then enable this but set    
     # ChallengeResponseAuthentication=no    
     #UsePAM no    
     UsePAM yes

**OpenSSH 3.6** or below change the following

     # Set this to 'yes' to enable PAM keyboard-interactive authentication    
     # Warning: enabling this may bypass the setting of 'PasswordAuthentication'    
     PAMAuthenticationViaKbdInt yes    

-   Restart the sshd daemon

        # service sshd restart    

-   Create the following entry in the Directory Server to enable password expiration. You can put copy/paste this to /tmp/passwordExpire.ldif

        dn: cn=config
        changetype: modify
        add: passwordExp
        passwordExp: on
        -
        add: passwordMaxAge
        passwordMaxAge: 8640000

    then run

        ldapmodify -D "cn=directory manager" -w password -f /tmp/passwordExpire.ldif

*Note* passwordMaxAge is done in seconds. A good number to use is 8640000 which is 100 days - passwords will expire in 100 days.

