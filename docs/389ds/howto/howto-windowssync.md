---
title: "Howto:WindowsSync"
---

# Sync With Active Directory
--------------------------

{% include toc.md %}

These are steps which you should follow to sync Windows Active Directory and 389 Directory Server .

### Enabling SSL with Active Directory

#### With Microsoft Certificate Authority

Active Directory gets its server certificate automatically created/enrolled when a Microsoft Certificate Server is configured/installed for that domain in Enterprise Root CA mode.

-   Cite: [How To Enable Secure Socket Layer (SSL) Communication over LDAP for Windows 2000 Domain Controllers](http://support.microsoft.com/default.aspx?scid=kb;en-us;247078)
-   Cite: [Windows Server 2003 & 2008: How to enable LDAP over SSL with a third-party certification authority](http://support.microsoft.com/kb/321051)
-   Cite: [Setting up AD ldap\_over\_ssl for php](http://adldap.sourceforge.net/wiki/doku.php?id=ldap_over_ssl)

#### (Optional) Use Microsoft ldap diagnostics gui Ldp from the AD Windows Server 2003 or AD Windows Server 2008 to test the ssl port 636

-   Cite: [Windows 2003 ldp Windows Server 2003 toolkit](http://www.computerperformance.co.uk/w2k3/utilities/ldp.htm)
-   Cite: [How to enable LDAP over SSL with a third-party certification authority: Verifying an LDAPS connection](http://support.microsoft.com/kb/321051)]
-   Cite: [Windows Server 200{0,3} How to troubleshoot LDAP over SSL connection problems](http://support.microsoft.com/kb/938703)

-   [Download Windows Server 2003 toolkit: To get ldp](http://www.microsoft.com/en-us/download/details.aspx?id=17657)
-   [Ldp is Bundled in Windows Server 2008](http://technet.microsoft.com/en-us/library/cc771022(v=ws.10).aspx)

-   Start the Active Directory Administration Tool (Ldp.exe).
    -   Note This program is installed in the Windows 2000 Support Tools, or Windows 2003 Support tools , see above links, Windows 2008 should have this installed by default
-   On the Connection menu, click Connect.
-   Type the name of the domain controller to which you want to connect.
-   Type 636 as the port number.
-   Click OK.

##### Note:

-   This is an way to debug ssl for a windows administration as some time the windows team is a different set of people then the Linux/Fedora directory team.

#### WORK IN PROGRESS: Exporting the ssl ca from the windows

-   NOTE This major section is being worked on , and is not ready for production.

-   Cite: <http://support.microsoft.com/kb/555252>
-   Cite: <http://www.richardhyland.com/diary/2009/05/12/installing-a-ssl-certificate-on-your-domain-controller/>

#### Use the [Microsoft Root Certification Authority Certificate from the Web Enrollment Site](http://support.microsoft.com/kb/555252)

-   Here we have an example of an Active Directory 2003 with Microsoft Root Certification Authority Certificate with the Web Enrollment Site
    -   <http://ad2003.example.com/certsrv>

#### On the active directory host command line option of ms certutil.exe

-   Option (Command line On Windows Active Directory Host)

      certutil -ca.cert ad2003.pem > ad2003.pem    

-   Copy the exported certificate from the Active Directory Server to the Linux machine (e.g. scp, ftp, samba mount, etc.)

        CA cert[0]:
        -----BEGIN CERTIFICATE-----
        MIIEbTCCA1WgAwIBAgIQWY5vERlj14ZHZbdBb27daTANBgkqhkiG9w0BAQUFADBF
        MRMwEQYKCZImiZPyLGQBGRYDY29tMRcwFQYKCZImiZPyLGQBGRYHZXhhbXBsZTEV
        MBMGA1UEAxMMQ2FGb3JXaW4yMDAzMB4XDTEyMDgyMjAyNDE1OFoXDTE3MDgyMjAy
        NDkyMVowRTETMBEGCgmSJomT8ixkARkWA2NvbTEXMBUGCgmSJomT8ixkARkWB2V4
        YW1wbGUxFTATBgNVBAMTDENhRm9yV2luMjAwMzCCASIwDQYJKoZIhvcNAQEBBQAD
        ggEPADCCAQoCggEBAIjb5rgmg4xL3IgiocX0TmQrWFff8JdkMiQJ7KfGnxH7dLjC
        st8LrYxSOCQtV9Z5+phv2WEF1EfWyM4211Ha7Mupai4Jc6oWRCW/TSr0QwjSuR/8
        3yI1GCX2/mZnhY1xRGfEKkzIadoNROkFQJsNXomBrmf6bSqWqFn/Uy7QlcPwv0/4
        wwgMiaVXd1FcEJhfdrFSkEfh8jXnJm4pVb2kWfZMiJGFVaQLsbT33zesBkVnV8T5
        qV7AvYcPxqAtW+iVKU4z83BQJiM9r6tgKGOJ2ukd9tzF87nLP+8qmJUiqq8S7akD
        yoOFb10OTKJMdxWVO3VqACC9pwEPdimzSR3UuHMCAwEAAaOCAVcwggFTMAsGA1Ud
        DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQGetEhuOzmK8DmepF/
        tMNYIcPToTCCAQAGA1UdHwSB+DCB9TCB8qCB76CB7IaBsmxkYXA6Ly8vQ049Q2FG
        b3JXaW4yMDAzLENOPWFkMjAwMyxDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2Vy
        dmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1leGFtcGxlLERD
        PWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9
        Y1JMRGlzdHJpYnV0aW9uUG9pbnSGNWh0dHA6Ly9hZDIwMDMuZXhhbXBsZS5jb20v
        Q2VydEVucm9sbC9DYUZvcldpbjIwMDMuY3JsMBAGCSsGAQQBgjcVAQQDAgEAMA0G
        CSqGSIb3DQEBBQUAA4IBAQBL5rd9e5G7bhx7MN0ViKYmd9WPeWIJX5zSsXFVHbaR
        W09KllrOsAumWdq9myzcQUwn4h1oCREVxMu5wIXvfTImapUD0nbSeKd+Cn6NTEXA
        qGWC8xXSHbuHc2gUil48tsrrf73ycvzaGAKe88qIwWJIhzoa1o1v95lOYt4Ivq+H
        3yI1GCX2/mZnhY1xRGfEKkzIadoNROkFQJsNXomBrmf6bSqWqFn/Uy7QlcPwv0/4
        wwgMiaVXd1FcEJhfdrFSkEfh8jXnJm4pVb2kWfZMiJGFVaQLsbT33zesBkVnV8T5
        qV7AvYcPxqAtW+iVKU4z83BQJiM9r6tgKGOJ2ukd9tzF87nLP+8qmJUiqq8S7akD
        yoOFb10OTKJMdxWVO3VqACC9pwEPdimzSR3UuHMCAwEAAaOCAVcwggFTMAsGA1Ud
        DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQGetEhuOzmK8DmepF/
        tMNYIcPToTCCAQAGA1UdHwSB+DCB9TCB8qCB76CB7IaBsmxkYXA6Ly8vQ049Q2FG
        b3JXaW4yMDAzLENOPWFkMjAwMyxDTj1DRFAsQ049UHVibGljJTIwS2V5JTIwU2Vy
        dmljZXMsQ049U2VydmljZXMsQ049Q29uZmlndXJhdGlvbixEQz1leGFtcGxlLERD
        PWNvbT9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0P2Jhc2U/b2JqZWN0Q2xhc3M9
        Y1JMRGlzdHJpYnV0aW9uUG9pbnSGNWh0dHA6Ly9hZDIwMDMuZXhhbXBsZS5jb20v
        Q2VydEVucm9sbC9DYUZvcldpbjIwMDMuY3JsMBAGCSsGAQQBgjcVAQQDAgEAMA0G
        CSqGSIb3DQEBBQUAA4IBAQBL5rd9e5G7bhx7MN0ViKYmd9WPeWIJX5zSsXFVHbaR
        W09KllrOsAumWdq9myzcQUwn4h1oCREVxMu5wIXvfTImapUD0nbSeKd+Cn6NTEXA
        qGWC8xXSHbuHc2gUil48tsrrf73ycvzaGAKe88qIwWJIhzoa1o1v95lOYt4Ivq+H
        mfZvsp690FGyAaLYxupKcPIBkLKcfl6CH9ze8ylpN2wC0gP+rZU/fPu7owsjLxNL
        tXeOELbCMqka+zjkuEEwbXEbnlgWNRvfCh25EfxKDXxwiNQLMRAGF7inDqmk+x7p
        S7jFlm2DyoDkzcKia/Dq1ZywwUfpo++H/xEsZI8KAbJ4
        -----END CERTIFICATE-----

        EncodeToFile returned The file exists. 0x80070050 (WIN32: 80)
        CertUtil: -ca.cert command FAILED: 0x80070050 (WIN32: 80)
        CertUtil: The file exists.

-   Now Edit the \*.pem file from windows Remove all before

        REMOVE _> CA cert[0]:
        -----BEGIN CERTIFICATE-----
        KEEP THIS DATA 
        -----END CERTIFICATE-----
        REMOVE AFTER HERE 
        EncodeToFile returned The file exists. 0x80070050 (WIN32: 80)    
        CertUtil: -ca.cert command FAILED: 0x80070050 (WIN32: 80)    
        CertUtil: The file exists.    

#### Test the yourhostname.pem file

      #!/bin/bash    
      # checkX509.sh     
      # the 1st arg is the cert file we shall test     
      # this expects a file format such as this 
      # -----BEGIN CERTIFICATE-----
      #UvNNuJz0GeQQxfAerIUv1hzGxvNsETnq5cF4TwTc+45QHh/k0defzMU2uRgkrhqZ
      #MORE RANDOM DATA encoded in a base64 
      #Rmd7Glb2AREcNjajLf+BHJDHWQmxLAyVdRGtJLYy0V2YCxv6AB86+cDobVn4Xpel
      #so1hPKxtCs2or0PUjYM=
      #-----END CERTIFICATE-----
      openssl base64 -d -in $1  | openssl x509 -text -noout -inform der    

#### On our Linux/Unix based 389 ldap server back up the database

    cd /etc/dirsrv/slapd-hostname -s
    mkdir nss.bak
    cp *.db nss.bak
    cd nss.bak

#### On our Linux/Unix based 389 ldap server: Import the Ad Ca into Fedora 389 key ring

    certutil -d . -A -n "Windows Server AD CA cert" -t CT,, -a -i /path/to/ADca.pem

#### On our Linux/Unix based 389 ldap server: Verify the CA certificate

    certutil -d . -L -n "Windows Server AD CA cert"

if this is good we can 1st make a backup of the db file , before the windows ca was added , and we can over write these files.

Now rerun the ldapsearch commands , see if they are successful, if so then the issues with ssl should be resolved.

#### With OpenSSL CA

    <add openssl ca notes here>

#### With Red Hat Certificate Authority

These are some notes that describe how you should go about enabling SSL for an Active Directory Installation Using Red Hat Certificate System (CA).

 Steps to follow for Windows 2000 Advanced Server:

-   Make sure your windows host has a proper hostname set and is using a static IP address. ( for eg. optimusvm4.sfbay.redhat.com )
-   Keep the Windows 2000 Advanced Server Install CD handy.

-   Goto Start-\>Programs-\>Administrative Tools-\>Configure your Server-\>Active Directory-\>Start the Active Directory installation.
    -   Create a domain controller with the domain name <b>sfbay.redhat.com</b>. Most of the settings could be defaults.
    -   Restart after Active Directory install is completed.

-   Goto Start-\>Settings-\>Control Panel-\>Add/Remove Programs-\>Add/Remove Windows Components.
    -   Select "Certificate Services and IIS". Install those services.
        -   When installing the microsoft CA, make sure you select "Stand-Alone Root CA". if you select, "Enterprise Root CA", this has the capability to issue a certificate to the Active Directory server automatically.

-   Goto a Red Hat Certificate System install (where you have a CA, up and running )
    -   use certutil and create a temporary database.
    -   generate a server certificate request.
    -   submit this certificate request to the Red Hat CA and get it approved. Make sure the certificate has the right extension to be used for servers.
    -   export the server certificate and its private key to a .p12 file using the pk12util utility.
    -   copy this .p12 file to the Windows Server System.

-   Use the mmc(Start-\>Run-\>mmc) application in the windows server system and add the snap-in for Certificates.
    -   Goto Personal-\>Certificates and click import. Import the .p12 file. Also import the RedHat CA certificate to the "Trusted Root Certificates" list.
    -   restart the domain controller ( aka reboot ).
    -   Active directory will now be listening for requests after reboot on port 636.

#### With TinyCA2

([[http://tinyca.sm-zone.net/]http://tinyca.sm-zone.net/](http://tinyca.sm-zone.net/]http://tinyca.sm-zone.net/))

These notes should help you go about enabling SSL for Active Directory Installation using certificates generated with the TinyCA2 Certificate Authority.

FYI...

-   TinyCA2 uses OpenSSL for it's backend.
-   Server Certificate Settings MUST allow for the use of "Subject alternative name (subjectAltName)" of type IP Address. This is an AD requirement. (To get this option, you may need to go to Preferences-\>OpenSSLConfiguration, click on the Server Certificate Settings, and change Subject alternative name from Copy Email to ask)

<u>Steps to follow for Windows 2000 Advanced Server:</u>

-   Make sure your windows host has a proper hostname set and is using a static IP address. ( for eg. optimusvm4.sfbay.redhat.com )
-   Keep the Windows 2000 Advanced Server Install CD handy.

-   Goto Start-\>Programs-\>Administrative Tools-\>Configure your Server-\>Active Directory-\>Start the Active Directory installation.
    -   Create a domain controller with the domain name <b>sfbay.redhat.com</b>. Most of the settings could be defaults.
    -   Restart after Active Directory install is completed.
    -   The installation of the "Certificate Services" Windows Component as specified in the RedHat CA section is NOT necessary.

-   Goto your TinyCA Installation (where you have a CA up and running).
    -   Goto the Certificates Tab-\> Click New -\> Select "Create Key and Certificate (Server)".
        -   Commone Name must be the FQDN of your AD server.
        -   During the Sign Request/Create Certificate supply the IP Address of the AD server for the subjectAltName and do not add the email address to the subject dn.
    -   Under Certificates select the certificate created for the AD server and click Export.
        -   Select PKCS\#12 (Certificate and Key) and click save.
        -   Set the Key Password
        -   Set the Eeport Password
        -   Set the Friendly Name to the FQDN of the AD server
        -   Set without passphrase to NO
        -   Set Add CA Certificate to PKCS\#12 to YES and clieck OK
    -   Copy this .p12 file to you AD server.

-   Install the certificate and key for the AD server using the MMC Certificate snap-in
    -   Click Start -\> run -\> mmc (enter)
        -   In MMC click Console -\> Add snap-in -\> Add -\> Certificates -\> Add -\> Computer Account -\> Next -\> Finish
        -   Expand Certificates (Local Computer) -\> Right Click Personal -\> All Tasks -\> Import
        -   In the Import Wizard -\> Click next -\> Browse to the AD servers .p12 file -\> Next -\> Supply the Export Password -\> Next -\> Select Automatically select the store -\> Next -\> Finish
        -   Click the Refresh button
        -   Verify that the AD server certificate has been installed under Personal -\> Certificates
        -   Verify that you CA certificate has been installed under Trusted Root CA's -\> Certificates
-   Restart the AD server

-   Verify that you can connect via LDAPS on the AD server.
-   Click Start -\> run -\> ldp (enter)
    -   In Active Directory Administration Tool (ldp) click Connection -\> Connect
        -   Server: FQDN of the AD server
        -   Port: 636
        -   Click OK and you should see a bunch of stuff scroll across the screen

-   Verify that you can connect via LDAPS with OpenSSL
-   Open a terminal

    openssl s_client -connect optimusvm4.sfbay.redhat.com:636 -showcerts -CAfile /path/to/cacert.pem    

enjoy

#### Active Directory with any Other 3rd-Party Certificate Authority

-   Cite: [Windows Server 2003 & 2008: How to enable LDAP over SSL with a third-party certification authority](http://support.microsoft.com/kb/321051)

### Configuring PassSync

PassSync 1.1.4 supports 32-bit and 64-bit Windows Server 2003, 2008, and 2012.

#### Windows Server 2012 Notes

-   run powershell as administrator
-   set execution policy to run script on powershell (Set-ExecutionPolicy RemoteSigned), you can check your policy with Get-ExecutionPolicy
-   There is a problem with the certutil command:

        .\certutil.exe –d . –A –n "DS CA cert" -t CT,, -a –i C:\dsca.crt    

    The CT,, needs to be quoted for powershell:

        .\certutil.exe –d . –A –n "DS CA cert" -t "CT,," -a –i C:\dsca.crt    

#### Installing PassSync

NOTE: If you are upgrading from Fedora PassSync to 389 PassSync, the installer will create a 389 branded folder under your program files folder and copy the files you need from there. The installer will \_not\_ remove the old Fedora Password Sync folder. You can remove this manually after install if the 389 one is working correctly.

NOTE: After installing, either new or upgrade, you will have to reboot the machine in order for the changes to take effect (unless you can figure out a way to make Active Directory/lsass use the passhook plugin without rebooting . . .)

PassSync should be installed on the Windows box where you have installed/configured Active Directory. Follow these steps:

-   Double Click on the PassSync .msi for your platform - see [Download](../download.html)
    -   You will be asked to provide the following details:
        -   389 Directory Server Hostname
        -   389 Directory Server TLS/SSL Port number
        -   389 Directory Server Bind DN [ It is recommended that you create a special user and provide them appropriate access ]
        -   389 Directory Server Bind DN password
        -   (Optional) PassSync Cert DB password (CertToken)

#### Enabling SSL for PassSync

**NOTE: PassSync will not work until TLS/SSL is configured.** The passsync.log will contain errors about SSL initialization until SSL is properly configured, and the service will not start.

The following method assumes that you have some knowledge about using NSS based certificate and key management utilities like certutil/pk12util.

For detailed docs on these tools see [ <http://www.mozilla.org/projects/security/pki/nss/tools/> here ].

More information about PassSync can be found [here](https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Windows_Sync-Configuring_Windows_Sync.html).

Follow these steps to set up certificates that Password Sync Service will use SSL to access the Directory Server:

##### On the 389 Directory Server, export the CA certificate.

    cd /etc/dirsrv/slapd-instance_name    
    certutil -d . -L -n "CA certificate" -a > dsca.crt    
    # NOTE - it might not be called CA certificate - use certutil -d . -L to list your certs    
    certutil -d . -L    
    Certificate Nickname                                        Trust Attributes    
                                                                SSL,S/MIME,JAR/XPI    
    CA certificate                                              CTu,u,u    
    Server-Cert                                                 u,u,u    
    ...etc...    

-   Copy the exported certificate from the Directory Server to the Windows machine (e.g. scp, ftp, samba mount, etc.)

##### On the Windows Active Directory Machine

-   open a CMD window and cd to the Password Sync installation directory.

        cd "C:\Program Files\389 Directory Password Synchronization"    

-   Import the CA certificate from the Directory Server into the new certificate database.

        certutil.exe -d . -A -n "DS CA cert" -t "CT,," -a -i \path\to\dsca.crt    
        # note - if the above fails with Bad Database, you will have to do this first:    
        certutil.exe -d . -N # just press Enter/Return when prompted for a password    

-   Verify the CA certificate

        certutil.exe -d . -L -n "DS CA cert"    

-   Reboot the Windows machine - PassSync will not begin working until after a reboot due to the way the AD passhook.dll plug-in works

##### NOTE:

###### password protect the database

If you want to password protect your key/cert db, you will need to use certutil.exe -d . -N to create a key/cert db with a password \_before\_ importing the CA cert.

###### starting over with ssl

If you want to start over, just simply remove the \*.db files. You will need to provide the Cert Token password above. If you need to set the password, you can run the .msi again and use Modify mode, or use regedit and edit the registry - see below for the registry key.

#### Reboot Windows

PassSync will not work until Windows is rebooted. This is due to the way the passhook.dll Active Directory plug-in works.

#### PassSync Logging

The PassSync log file is in the file passsync.log in the C:\\Program Files\\389 Directory Server Synchronization folder.

The passhook log and data file are in your \\windows\\system32 folder - passhook.dat and passhook.log

The following registry settings are available to enable PassSync service logging.

Under HKLM-\>Software-\>PasswordSync, add string value "Log Level" and set it to "1".

-   level - 0 - Only Errors are logged.
-   level - 1 - All transactions are logged.

### Enabling SSL With 389 Directory Server

Read [this](howto-ssl.html) to get 389 Directory Server enabled in SSL mode.

#### Note: Use same CA to cut the ssl certs for windows active directory host and fedora 389 / rhds servers

-   Its always better to use the same Certificate Authority to issue certificates to both 389 Directory Server and Active Directory to minimize any trust issues that might occur.

### Creating AD User with Replication Rights

You do not have to use Administrator or other system account for Windows Sync. You can instead create a regular user and assign specific rights to that user.

The page [How to grant the "Replicating Directory Changes" permission for the Microsoft Metadirectory Services ADMA service account](http://support.microsoft.com/kb/303972) gives more information. The steps apply to any user, not just the Microsoft Metadirectory Services ADMA service account.

These instructions assume you are using the Server Manager application, or the Active Directory Domain Services and/or Active Directory Users and Groups snap-in to MMC.

-   Select the top level domain node (e.g. example.com) under the Active Directory Users and Groups node in the tree in the left hand pane
-   In the 'View' menu, select 'Advanced Features'
-   Create a user account using the Windows AD GUI
    -   you probably want to set the password to never expire, or at least have a very long expiration time
-   Select the top level domain node (e.g. example.com) under the Active Directory Users and Groups node in the tree in the left hand pane
-   Open 'Properties'
-   In the 'Properties' dialog box, select the Security tab
-   Click on the Add... button
-   Search for your windows sync user - Check Names - then hit the OK button
-   In the 'Group or User Names:' list, select your windows sync user
-   In the 'Permissions for Windows Sync' list, make sure Read is checked under the Allow column
    -   If you will want to write changes from 389 to AD, make sure Write/Create all child objects/Delete all child objects/Add GUID are all checked under the Allow column
-   Scroll down to Replicating Directory Changes - check this on under the Allow column
-   Press 'Apply' or 'OK'

That user should now be able to use the DirSync control. There is a python script that can be used to test to see if the user can use DirSync - see [<https://github.com/richm/scripts>](https://github.com/richm/scripts) for the file dirsyncctrl.py. You will have to edit this file in the main() section to set your ad host, dn, etc.

For more information, see [Polling for Changes Using the DirSync Control](http://msdn.microsoft.com/en-us/library/ms677626%28VS.85%29.aspx)

### Creating Sync Agreements WinSync

-   See
    -   RHDS 9.0
        -   [<http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Windows_Sync.html>](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Windows_Sync.html) for information.
    -   RHDS 8.2
        -   [<https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Windows_Sync.html>](https://access.redhat.com/knowledge/docs/en-US/Red_Hat_Directory_Server/8.2/html/Administration_Guide/Windows_Sync.html)

#### Note

-   WinSync is done from rhds/389 ldap server to the active directory server
    -   RHDS -\> AD
-   So it may be a good idea to use this nomenclature to express the user in the active directory,
    -   s\_f389\_winsync or s\_rhds\_winsync as this is the user that the the linux directory server will bind as to the active directory so this user must exist on the AD side.
    -   The s\_ simple mean that this is a service account so when and inventory of users is done the directory admin knows that this is a daemon user required for rhds/fedora 389 sync process.
        -   Each Enterprise or Organization has a different way to keep track of service accounts such as e\_ could mean elevated user, d\_ could mean daemon user etc.

#### If you want One Way Sync

[One\_Way\_Active\_Directory\_Sync](howto-one-way-active-directory-sync.html)

### Testing your Configuration

#### Test to make sure you can talk SSL from 389 Directory to AD

cite: [qa script that will build an adWs2008r2 host vm with a windows ca and ca web services turned on](https://github.com/richm/auto-win-vm-ad)

This is how you test to verify that the Windows side SSL is enabled properly:

     /usr/lib[64]/mozldap/ldapsearch -Z -P /path/to/dirsrv/cert8.db -h <AD/NT Hostname> -p <AD SSL port> 
     -D "<sync manager user>" -w < sync manager password> -s <scope>
     -b "<AD base>" "<filter>"

or, with openldap on RHEL6 or later, or on Fedora

     LDAPTLS_CACERTDIR=/path/to/slapd-INST ldapsearch -xLLL -ZZ -h <AD/NT Hostname>
      -D "<sync manager user>" -w <sync manager password> -s <scope>
     -b "<AD base>" "<filter>"

for example

     /usr/lib/mozldap/ldapsearch -Z -P /etc/dirsrv/slapd-myhostname/cert8.db -h ad.example.com 
     -p 636 -D "cn=sync manager,cn=users,dc=example,dc=com" 
     -w password -s base -b "cn=users,dc=example,dc=com" "objectclass=*"

openldap

     LDAPTLS_CACERTDIR=/path/to/slapd-myhostname ldapsearch -xLLL -ZZ -h ad.example.com
     -D "cn=sync manager,cn=users,dc=example,dc=com"
     -w password -s base -b "cn=users,dc=example,dc=com" "objectclass=*"

for example

     #!/bin/bash
          /usr/lib/mozldap/ldapsearch -Z -P /etc/dirsrv/slapd-hostname -s /cert8.db -h ad2003.example.com -p 636 -D "cn=sync manager,cn=users,dc=example,dc=com" -w password -s base -b "cn=users,dc=example,dc=com" "objectclass=*"         

openldap

     #!/bin/bash
     LDAPTLS_CACERTDIR=/etc/dirsrv/slapd-hostname -s ldapsearch -xLLL -ZZ -h ad2003.example.com -D "cn=sync manager,cn=users,dc=example,dc=com" -w password -s base -b "cn=users,dc=example,dc=com" "objectclass=*"

If you did not create a sync manager (you should have!) you can use cn=administrator,cn=users,dc=example,dc=com.

If you begin to see errors when doing this search, you could optionally use the [ssltap](http://www.mozilla.org/projects/security/pki/nss/tools/ssltap.html) tool , which basically proxies requests - to troubleshoot.

##### testing ssl from the ldap server to the ad host

-   On your rhds/389 server

          openssl s_client -connect ad2003.example.com:636    

-   On the ad box / or a machine on the active Directory Domain.

          openssl.exe s_client -connect ad2003.example.com:636    

-   Compare the output, as it could be the ad domain already has a MS ca installed, and any host in the domain will have the Active Directory Ca already installed in the key ring. Also check the ssl cert that is download with checkX509.sh tool to see the ssl Certification Chain and who cut this x509 ssl cert.

### Troubleshooting

-   Enable the replication logging level in the directory server [FAQ\#Troubleshooting](../FAQ/faq.html#Troubleshooting)
-   It could be that there was a mis-step in the AD section and your AD windows domain already has a micro-soft certificate authority in place and your ssl cert from windows active directory is not yet in your (fedora 389 / rhds) ldaps ring of trust.
    -   So test the following
    -   [testing ssl from the ldap server to the ad host](http://directory.fedoraproject.org/wiki/Howto:WindowsSync#testing_ssl_from_the_ldap_server_to_the_ad_host)
    -   Grab the out put find the cert for the ad box , then run [to see which certificate authority cut that cert](http://directory.fedoraproject.org/wiki/Howto:WindowsSync#Test_the_yourhostname.pem_file)

      ./checkX509.sh ad2003.example.com.pem.txt | grep -v :ca: | grep -i CA    

Windows Sync Plugin API
=======================

[Windows\_Sync\_Plugin\_API](../design/windows-sync-plugin-api.html)

POSIX Attributes
================

[WinSync\_Posix](../design/winsync-posix.html)

