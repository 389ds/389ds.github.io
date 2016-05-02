---
title: "Enhanced Account Tools Design"
---

# Enhanced Account Tools Design
----------------------------

{% include toc.md %} 

## Overview


The following entry account tools need to work with the *Account Policy Plugin*

-   **ns-accountstatus.pl**
-   **ns-activate.pl**

The *Account Policy Plugin* uses a state attribute(typically *lastLoginTime*), and an inactivity limit to determine if an account is "inactive".  The account tools can now correctly identify these accounts as being "inactive/active", as well as correctly activate them when using *ns-activate.pl*.

Several new features have been added to **ns-accountstatus.pl** 

-   You can now specify a *Suffix*, *Filter*, and *Scope* to see the status of many entries instead of just one.
-   A new option to see only "inactivated" entries.
-   A new option to see entries that will become inactive(due to inactivity) within a certain time frame
-   A new option to display "verbose" information on each account.

--------

## Use Cases

These enhancements make account management easier and more robust for Directory Server administrators.


--------

## Design

#### Account Policy Plugin Interaction

The Account Policy Plugin uses Class Of Service (COS) to apply inactivity limits for user entries.  In order to obtain the actual limit for a user you must find and query the COS template for that particular user.  Then the script will perform the same calculations that the plugin uses in order to properly identify if a user is "inactive" or not.  When the account is inactivated because of inactivity a more detailed message is returned:

    uid=mark,ou=People,dc=example,dc=com - inactivated (inactivity limit exceeded)

Possible entry state messages:

- **activated** - The user is "active", and it is not restricted from authenticating.
- **inactivated** - The user has been "inactivated", and can not authenticate to the server.
- **inactivated through ROLE_DN** - The user is inactivated because it is assigned to the **ROLE_DN**
- **inactivated (probably directly)** - This is typically seen for role DN's
- **inactivated (inactivity limit exceeded)** - The user is inactgive becuase it had no activity for too long.  It exceeded the inactivity limit of the Acct Policy Plugin

Another enhancement to "ns-accountstatus.pl" is that *verbose information* about an account can be displayed using the option (**-V**).  Here are some examples when the Account Policy Plugin is enabled:

Here is an entry that is "*inactivated*" because it has exceeded the inactivity limit

    Entry:                   uid=mark,ou=People,dc=example,dc=com
    Entry Creation Date:     20160204153140Z (02/04/2016 10:31:40)
    Entry Modification Date: 20160204160545Z (02/04/2016 11:05:45)
    Last Login Date:         20160204160546Z (01/04/2016 11:05:46)
    Inactivity Limit:        2592000 seconds (30 days)
    Time Until Inactive:     -
    Time Since Inactivated:  85877 seconds (23 hours, 51 minutes, 17 seconds)
    Entry State:             inactivated (inactivity limit exceeded)

Here is an example when the entry is "*active*"

    Entry:                   uid=mark,ou=People,dc=example,dc=com
    Entry Creation Date:     20160204153140Z (02/04/2016 10:31:40)
    Entry Modification Date: 20160205163904Z (02/05/2016 11:39:04)
    Last Login Date:         20160205163905Z (02/05/2016 11:39:05)
    Inactivity Limit:        2592000 seconds (30 days)
    Time Until Inactive:     2591688 seconds (29 days, 23 hours, 54 minutes, 48 seconds)
    Time Since Inactive:     -
    Entry State:             activated


This is a description of each "attribute":

- **Entry** - This is the DN of the user entry.
- **Entry Creation Date** - This is the date when the user was created.
- **Entry Modification Date** - This is the last time the entry was updated.
- **Last Login Date** - This is the date when the last successful BIND was performed.
- **Inactivity Limit** - This is the "*inactivity limit*" that is defined in the COS template for that particular entry.
- **Time Until Inactive** - The time left until the user will become "inactive" unless another BIND is performed.  This is only displayed if the account is currently "*active*".
- **Time Since Inactive** - This is the time since the account was "*inactivated*".  This is only displayed if the account is already "*inactived*"
- **Entry State** - This is the current state of the entry.  In some cases more details are provided as to why the account is "*inactivated*".

If the Account Policy Plugin is not enabled, the verbose output will look like this:

    Entry:                   uid=mark,ou=People,dc=example,dc=com
    Entry Creation Date:     20160204153140Z (02/04/2016 10:31:40)
    Entry Modification Date: 20160205161606Z (02/05/2016 11:16:06)
    Entry State:             activated

<br>

#### Getting The Status of Many Users

A new feature is that you can now specify a search base (**-b**), filter (**-f**), and scope (**-s base, one, sub** Default is "sub") for retrieving the status of many users.  Using these options ignores the "**-I**" parameter.

    ns-accountstatus.pl -D "cn=directory manager" -w password -b "ou=people,dc=example,dc=com" -s sub -f "(&(objectclass=PosixAccount)(uid=*))"

<br> 

#### Finding Only Inactivated Users

A new option (**-i**) can be specified to signify that only "inactivated" users should be displayed.

    ns-accountstatus.pl -D "cn=directory manager" -w password -b "ou=people,dc=example,dc=com" -f "(&(objectclass=PosixAccount)(uid=*))" -V -i

    Entry:                   uid=mark,ou=People,dc=example,dc=com
    Entry Creation Date:     20160204153140Z (02/04/2016 10:31:40)
    Entry Modification Date: 20160204160545Z (02/04/2016 11:05:45)
    Last Login Date:         20160204160546Z (01/04/2016 11:05:46)
    Inactivity Limit:        2592000 seconds (30 days)
    Time Until Inactive:     -
    Time Since Inactivated:  85877 seconds (23 hours, 51 minutes, 17 seconds)
    Entry State:             inactivated (inactivity limit exceeded)

<br>

#### Finding Users That Will Become Inactivated

There is an option (**-g TIME**) to return only the users that will become inactive(by inactivity) within a specified amount of time.  So lets say you want to find users that are going to become inactivated within the next 24 hours, you would do the following:

    ns-accountstatus.pl -D "cn=directory manager" -w password -b "ou=people,dc=example,dc=com" -f "(uid=*)" -V -g 86400

    Entry:                   uid=mark,ou=People,dc=example,dc=com
    Entry Creation Date:     20160204153140Z (02/04/2016 10:31:40)
    Entry Modification Date: 20160205163904Z (02/05/2016 11:39:04)
    Last Login Date:         20160205163905Z (01/05/2016 11:39:05)
    Inactivity Limit:        2592000 seconds (30 days)
    Time Until Inactive:     979 seconds (16 minutes, 19 seconds)
    Time Since Inactive:     -
    Entry State:             activated

Common Times

- 24 hours = 86400
- 1 week = 604800
- 30 days = 2592000

<br>

### Updates to ns-activate.pl

The only change to this tool is that it can now detect when an account is inactive due to the Account Policy Plugin's inactivity limit, and it can properly activate that entry by reseting the "lastLoginTime" to the current time.

--------    

## Implementation

Here are the *new* command line tool parameters for the new features for ns-accountstatus.pl:

    Searching Parameters (ignores "-I DN")
    --------------------
    -b SUFFIX     - The database suffix to query
    -s SCOPE      - The search scope: base, one, sub.  The default is "sub"
    -f FILTER     - The search filter

    Other Parameters
    ------------------
    -V          - Verbose output
    -i          - Only display users that are already inactivated
    -g TIME     - Only display users that will become inactive within the specified time(in seconds) 


## Feature Management

CLI tools.

## Major configuration options and enablement

None

## Replication

No Impact

## Updates and Upgrades

No impact on upgrades/updates.

## Dependencies

None

## External Impact

No external impact.

## RFE Author

Mark Reynolds <mreynolds@redhat.com>

