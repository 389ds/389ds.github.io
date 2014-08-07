---
title: "Howto: Posix"
---

# How to set up host based access control(POSIX entries)
---------------------------------------

### New Method

There is already an AUXILIARY objectclass provided with the pam/nss ldap distribution on Linux systems: hostObject. This schema is included with the directory server software - /etc/dirsrv/schema/60nss-ldap.ldif. If this file is not in the schema directory for your directory server instance - /etc/dirsrv/slapd-yourname/schema - just copy the file in there, and restart the server. If for some reason the file is not there, you can always grab the latest from our CVS version control system - <http://cvs.fedoraproject.org/viewvc/ldapserver/ldap/schema/60nss-ldap.ldif?revision=1.1&root=dirsec&view=markup>

### Old Method

In the console, open the Directory containing your users. Then, go to the Directory tab. Using the directory browser, find and select the user you want to work with. Edit the user (Right click -\> menu -\> Edit...) or just double click on the user.

You'll want to first enable the Posix attributes for the user. Then Save. Then, edit the user again. Go to the Advanced... editor. Select the Objectclass row, and click on the Add Value button. From the list, select shadowAccount - you may have to scroll down to see it. The shadowAccount value should appear in the objectclass list of values. Next, click on Objectclass again, then click Add Values again. From the list, select "account". The "account" value (without quotes) should appear in the objectclass list of values. Finally, click on Add Attributes. Select "host" from the list of attributes. Host should appear as an empty attribute in the window. Finally, click on host, and click on Add Value. This will add an empty text field next to host - fill this in with the fully qualified hostname of the host you want to grant that user access to. Repeat for as many hosts as you want. You should make sure that your ldap.conf file on your machines has "pam\_check\_host\_attr" set to "yes" if you want pam\_ldap to enforce host-based access control for logins.

NOTE: This is not LDAP standard behavior. The "account" objectclass is a structural object class and it is not standard to be allowed to add that objectclass to an object with an existing structural object class. The proper way to do this would be to create a subclass of shadowAccount or posixAccount with the "host" attribute. Or create an AUXILIARY objectclass containing host that could be used to "mix-in" with existing objects.

If this method seems too cumbersome, it is also completely scriptable with ldapmodify or any other ldap command line tool.

How to extract LDAP based user posixGroup memberships information
-----------------------------------------------------------------

This script was contributed by Gary Tay. "Assuming you are using posixGroup objectclass and memberUid attribute to store your membership information, you may find my shell script useful and handy. It works on Solaris LDAP Client with "ldapaddent" and "ldaplist" commands, and works against FDS, SUN DS or OpenLDAP."

    #! /bin/sh
    #
    # get_ldap_memberUids.sh
    #
    # Gary Tay, 08-Sep-2005, written
    #
    if [ $# -le 0 ]
    then
       echo ""
       echo "Usage:"
       echo "$0 [SHOW_UID_ONLY||SHOW_DN|SHOW_UIDNUMBER|SHOW__NAME"
       echo ""
       echo "Purpose: get a list of memberships for LDAP posixGroups"
       echo "Examples: "
       echo "1) $0 SHOW_UID_ONLY"
       echo "2) $0 SHOW_DN"
       echo "3) $0 SHOW_UIDNUMBER"
       echo "4) $0 SHOW_NAME"
       echo ""
       exit
    fi
    OPTION=$1
    ldapaddent -d group | cut -d: -f1,3 >groups.txt
    for i in `cat groups.txt | cut -d: -f2 | sort -n`
    do
       GIDN=$i; GNAME=`grep $GIDN groups.txt | cut -d: -f1`
       echo memberUids for Group $GNAME, gidNumber=$GIDN
       ldapaddent -d passwd | sort -n -t: +3 -4 | cut -d: -f1,3,4 >users.txt
       cat users.txt | grep $GIDN | cut -d: -f1 >uids.txt
       case "$OPTION" in
          "SHOW_UID_ONLY") cat uids.txt;;
          "SHOW_DN") for j in `cat uids.txt`
             do
                ldaplist passwd $j
             done;;
           "SHOW_UIDNUMBER") for j in `cat uids.txt`
             do
                 UIDN=`ldaplist -l passwd $j | grep -i 'uidNumber:' | cut -d: -f2`
                echo $j,$UIDN
             done;;
           "SHOW_NAME") for j in `cat uids.txt`
             do
                 NAME=`ldaplist -l passwd $j | grep -i 'cn:' | cut -d: -f2`
                echo $j,$NAME
             done;;
          *) echo "$1 is an invalid option."; exit 1
       esac
       echo ""
    done


