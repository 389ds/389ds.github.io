---
title: "ldifgen design doc"
---

# ldifgen
----------------

{% include toc.md %}

Overview
--------

**dsctl ldifgen** is a utility to create a variety of LDIF files for doing testing with the Directory Server.  Previously we had a tool called **dbgen.pl** that created a variety user LDIF files, but it was limited to just user entries.  There is more that can be done to make testing easier.  The new **ldifgen** tool creates a variety of user entry LDIF's, as well as static groups and members, COS, Roles, Modification LDIF's, and heavily nested database structure LDIF's.


Design
------

The tool can do everything via command line arguments, and there is also an interactive mode for most of the LDIF types.  Since the LDIF file created for "users" or "nested user" will typically be imported, these files are written to the servers LDIF directory by default, all other LDIFs default to /tmp/ldifgen.ldif

```
# dsctl slapd-localhost ldifgen --help 
usage: dsctl [instance] ldifgen [-h]
                              {users,groups,cos-def,cos-template,roles,mod-load,nested}
                              ...

positional arguments:
  {users,groups,cos-def,cos-template,roles,mod-load,nested}
                        action
    users               Generate a LDIF containing user entries
    groups              Generate a LDIF containing groups and members
    cos-def             Generate a LDIF containing a COS definition (classic,
                        pointer, or indirect)
    cos-template        Generate a LDIF containing a COS template
    roles               Generate a LDIF containing a role entry (managed,
                        filtered, or indirect)
    mod-load            Generate a LDIF containing modify operations. This is
                        intended to be consumed by ldapmodify.
    nested              Generate a heavily nested database LDIF in a
                        cascading/fractal tree design
```


To use the "Interactive mode" you simply don't provide any of the optional arguments.  For example:

```
# dsctl slapd-localhost ldifgen users

# dsctl slapd-localhost ldifgen groups

# dsctl slapd-localhost ldifgen cos-def

```

Only the "**nested**" feature does not have a *interactive mode* because there are only a few options to set, and they are all required.


Example: Creating users
-----------------------

### First, the usage:

```
# dsctl slapd-localhost ldifgen users --help 
usage: dsctl [instance] ldifgen users [-h] [--number NUMBER] [--suffix SUFFIX]
                                      [--parent PARENT] [--generic]
                                      [--start-idx START_IDX] [--rdn-cn]
                                      [--localize] [--ldif-file LDIF_FILE]

optional arguments:
  -h, --help            show this help message and exit
  --number NUMBER       The number of users to create.
  --suffix SUFFIX       The database suffix where the entries will be created.
  --parent PARENT       The parent entry that the user entries should be
                        created under. If not specified, the entries are
                        stored under random Organizational Units.
  --generic             Create generic entries in the format of
                        "uid=user####". These entries are also compatible with
                        ldclt.
  --start-idx START_IDX
                        For generic LDIF's you can choose the starting index
                        for the user entries. The default is "0".
  --rdn-cn              Use the attribute "cn" as the RDN attribute in the DN
                        instead of "uid"
  --localize            Localize the LDIF data
  --ldif-file LDIF_FILE
                        The LDIF file name.  Default location is the server's LDIF directory using the name 'users.ldif'
```

<br>

### Create a LDIF using Real Names

This command will create an ldif file **/tmp/ldifgen.ldif** containing 100000 entries.  Each entry is randomly added to one of these predefined Organizational Units:

- "accounting"
- "product development"
- "product testing"
- "human resources"
- "payroll"
- "people"
- "groups"

```
# dsctl slapd-localhost ldifgen users --suffix dc=example,dc=com --number 100000
```

You can also force where the user entries are created by using the **\-\-parent** argument

```
# dsctl slapd-localhost ldifgen users --suffix dc=example,dc=com --parent ou=people,dc=example,dc=com --number 100000
```

The **\-\-localize** argument will localize the LDIF data, and **\-\-rdn-cn** will create user entries using **cn** instead of **uid**

Here is example of a user entry:

```
dn: uid=MKalyani1,ou=payroll,dc=example,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectclass: inetUser
cn: Mouna Kalyani
sn: Kalyani
uid: MKalyani1
givenName: Mouna
description: 2;7613;CN=Red Hat CS 71GA Demo,O=Red Hat CS 71GA Demo,C=US;CN=RHCS Agent - admin01,UID=admin01,O=redhat,C=US [1] This is Mouna Kalyani's description.
userPassword: MKalyani1
departmentNumber: 1230
employeeType: Manager
homePhone: +1 303 937-6482
initials: M. K
telephoneNumber: +1 303 573-9570
facsimileTelephoneNumber: +1 415 408-8176
mobile: +1 818 618-1671
pager: +1 804 339-6298
roomNumber: 5164
carLicense: 21SJJAG
l: Hartford
ou: payroll
mail: MKalyani1@example.com
mail: 1@example.com
postalAddress: 518, Dept #851, Room#payroll
title: Junior Visionary
usercertificate;binary:: MIIBvjCCASegAwI ...
```

<br>

### Create a LDIF using Generic Names

There are cases where having a structured DN is beneficial.  The first one is that the generic entry are compatible with the **ldclt** load testing tool that ships with Directory Server.  Using a structured DN also makes it easier to perform other tasks, or create other LDIF's that can interact with those entries.  We'll discuss this more in the "Modify Load" LDIF section.

```
# dsctl slapd-localhost ldifgen users --generic --suffix dc=example,dc=com --number 1000
```

This create an entry like this, take note of the DN.  It always uses the format **uid=user####**:

```
dn: uid=user0001,ou=people,dc=example,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectclass: inetUser
cn: user0001
sn: Handley
uid: user0001
givenName: Blithe
description: 2;7613;CN=Red Hat CS 71GA Demo,O=Red Hat CS 71GA Demo,C=US;CN=RHCS Agent - admin01,UID=admin01,O=redhat,C=US [1] This is Blithe Handley's description.
userPassword: user0001
departmentNumber: 1230
employeeType: Manager
homePhone: +1 303 937-6482
initials: B. H
telephoneNumber: +1 303 573-9570
facsimileTelephoneNumber: +1 415 408-8176
mobile: +1 818 618-1671
pager: +1 804 339-6298
roomNumber: 5164
carLicense: 21SJJAG
l: Redwood Shores
ou: people
mail: user0001@example.com
mail: 1@example.com
postalAddress: 518, Dept #851, Room#people
title: Senior Engineer
usercertificate;binary:: MIIBvjCCASegAwIBAgIBAjANBgk ...
```

You can also set the starting index number for the entry's DN

```
# dsctl  localhost ldifgen users --generic --suffix dc=example,dc=com --number 1000 --start-idx=50
```

Then the DN of the entries start off at **dn: uid=user0051, ...**

<br>

Example: Create groups
----------------------

### Usage

```
# dsctl slapd-localhost ldifgen groups --help
usage: dsctl [instance] ldifgen groups [-h] [--number NUMBER] [--suffix SUFFIX]
                                     [--parent PARENT]
                                     [--num-members NUM_MEMBERS]
                                     [--create-members]
                                     [--member-parent MEMBER_PARENT]
                                     [--member-attr MEMBER_ATTR]
                                     [--ldif-file LDIF_FILE]
                                     NAME

positional arguments:
  NAME                  The group name.

optional arguments:
  -h, --help            show this help message and exit
  --number NUMBER       The number of groups to create.
  --suffix SUFFIX       The database suffix where the groups will be created.
  --parent PARENT       The parent entry that the group entries should be 
                        created under.  If not specified the groups are stored 
                        under the suffix.
  --num-members NUM_MEMBERS
                        The number of members in the group. Default is 10000
  --create-members      Create the member user entries.
  --member-parent MEMBER_PARENT
                        The entry DN that the members should be created under.
                        The default is the suffix entry.
  --member-attr MEMBER_ATTR
                        The membership attribute to use in the group. Default
                        is "uniquemember".
  --ldif-file LDIF_FILE
                        The LDIF file name. Default is "/tmp/ldifgen.ldif"

```

<br>

### Create a Static Group with Members

```
# dsctl slapd-localhost ldifgen groups myGroup --number 1 --suffix dc=example,dc=com --num-members 10000 --create-members
```

This creates an LDIF that has all the user entries, and they are all added as members of the group

```
dn: dc=example,dc=com
objectClass: top
objectClass: domain
dc: example
...

dn: uid=group_entry1-00002,dc=example,dc=com
objectClass: top
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
objectclass: inetUser
cn: group_entry1-00002 20000-1yrtne_puorg
sn: 20000-1yrtne_puorg
uid: group_entry1-00002
...

dn: cn=myGroup-1,dc=example,dc=com
objectclass: top
objectclass: groupOfUniqueNames
objectclass: groupOfNames
objectclass: inetAdmin
cn: cn=myGroup-1,dc=example,dc=com
uniquemember: uid=group_entry1-00001,dc=example,dc=com
uniquemember: uid=group_entry1-00002,dc=example,dc=com
uniquemember: uid=group_entry1-00003,dc=example,dc=com
...
```

You can also set where the group is created by setting the **\-\-parent** DN, and you can control where the user entries are created by specifying the **\-\-member-parent** DN.  You can also choose what membership attribute you want to use by set **\-\-member-attr** to "*member*", etc.  By default it uses "*uniquemember*"

You can also create many group at once by increasing the value in **\-\-number**  So it's easy to create a lot of large static groups.

Note - when creating really large groups you can exceed the Maximum Ber Size limit in DS if you try and add the group using ldapmodify.  Importing this LDIF should be fine, but if you need to do it online then keep in mind you might need to increase the servers "nsslapd-maxbersize" configuration attribute.

<br>

Creating COS Entries
---------------------

Personally I find it easier to use the interactive mode for these entries, as it dynamically only asks you for the settings you need for that type of COS entry that you are trying to create

### Usage

```
# dsctl slapd-localhost ldifgen cos-def --help
usage: dsctl [instance] ldifgen cos-def [-h] [--type TYPE] [--parent PARENT]
                                      [--create-parent]
                                      [--cos-specifier COS_SPECIFIER]
                                      [--cos-template COS_TEMPLATE]
                                      [--cos-attr [COS_ATTR [COS_ATTR ...]]]
                                      [--ldif-file LDIF_FILE]
                                      NAME

positional arguments:
  NAME                  The COS definition name.

optional arguments:
  -h, --help            show this help message and exit
  --type TYPE           The COS definition type: "classic", "pointer", or
                        "indirect".
  --parent PARENT       The parent entry that the COS definition should be
                        created under.
  --create-parent       Create the parent entry
  --cos-specifier COS_SPECIFIER
                        Used in a classic COS definition, this attribute located 
                        in the user entry is used to select which COS template to use.
  --cos-template COS_TEMPLATE
                        The DN of the COS template entry, only used for
                        "classic" and "pointer" COS definitions.
  --cos-attr [COS_ATTR [COS_ATTR ...]]
                        A list of attributes which defines which attribute the
                        COS generates values for.
  --ldif-file LDIF_FILE
                        The LDIF file name. Default is "/tmp/ldifgen.ldif"
```
<br>

### Example: Create COS Definitions

<br>

#### Example of **classic** definition

```
# dsctl slapd-localhost ldifgen cos-def My_Postal_Def --type classic --parent "ou=cos definitions,dc=example,dc=com" --cos-specifier businessCatagory --cos-template "cn=sales,cn=classicCoS,dc=example,dc=com" --cos-attr postalcode telephonenumber 
```

And this creates a Classic COS definition

```
dn: cn=My_Postal_Def,ou=cos definitions,dc=example,dc=com
objectclass: top
objectclass: cosSuperDefinition
objectclass: cosClassicDefinition
cn: My_Postal_Def
cosTemplateDN: cn=sales,cn=classicCoS,dc=example,dc=com
cosSpecifier: businessCatagory
cosAttribute: postalcode
cosAttribute: telephonenumber
```

<br>

#### Example of **pointer** definition


```
# dsctl localhost ldifgen cos-def My_Postal_Def --type pointer --parent "ou=cos definitions,dc=example,dc=com" --cos-template "cn=sales,cn=classicCoS,dc=example,dc=com" --cos-attr postalcode telephonenumber
```

And this creates a Pointer COS definition

```
dn: cn=My_Postal_Def,ou=cos definitions,dc=example,dc=com
objectclass: top
objectclass: cosSuperDefinition
objectclass: cosPointerDefinition
cn: My_Postal_Def
cosTemplateDN: cn=sales,cn=classicCoS,dc=example,dc=com
cosAttribute: postalcode
cosAttribute: telephonenumber
```

<br>

#### Example of **indirect** definition

```
# dsctl slapd-localhost ldifgen cos-def My_Postal_Def --type indirect --parent "ou=cos definitions,dc=example,dc=com" --cos-specifier businessCatagory --cos-attr postalcode telephonenumber
```

And this creates a Indirect COS definition

```
dn: cn=My_Postal_Def,ou=cos definitions,dc=example,dc=com
objectclass: top
objectclass: cosSuperDefinition
objectclass: cosIndirectDefinition
cn: My_Postal_Def
cosIndirectSpecifier: businessCatagory
cosAttribute: postalcode
cosAttribute: telephonenumber
```

<br>

Creating Roles
---------------------

### Usage

```
# dsctl slapd-localhost ldifgen roles --help
usage: dsctl [instance] ldifgen roles [-h] [--type TYPE] [--parent PARENT]
                                    [--create-parent] [--filter FILTER]
                                    [--role-dn [ROLE_DN [ROLE_DN ...]]]
                                    [--ldif-file LDIF_FILE]
                                    NAME

positional arguments:
  NAME                  The Role name.

optional arguments:
  -h, --help            show this help message and exit
  --type TYPE           The Role type: "managed", "filtered", or "nested".
  --parent PARENT       The DN of the entry to store the Role entry under
  --create-parent       Create the parent entry
  --filter FILTER       A search filter for gathering Role members. Required
                        for a "filtered" role.
  --role-dn [ROLE_DN [ROLE_DN ...]]
                        A DN of a role entry that should be included in this
                        role. Used for "nested" roles only.
  --ldif-file LDIF_FILE
                        The LDIF file name. Default is "/tmp/ldifgen.ldif"

```

<br>


### Example: Create A Role

<br>

#### Example of **managed** role

```
# dsctl slapd-localhost ldifgen roles My_Managed_Role --type managed --parent ou=roles,dc=example,dc=com 

```

And this creates a Indirect COS definition

```
dn: cn=My_Managed_Role,ou=roles,dc=example,dc=com
objectclass: top
objectclass: LdapSubEntry
objectclass: nsRoleDefinition
objectclass: nsSimpleRoleDefinition
objectclass: nsManagedRoleDefinition
cn: My_Managed_Role
```
<br>

#### Example of **filtered** role

```
# dsctl localhost ldifgen roles My_Filtered_Role --type filtered --parent ou=roles,dc=example,dc=com --filter "objectclass=posixAccount"

```

And this creates a Indirect COS definition

```
dn: cn=My_Filtered_Role,ou=roles,dc=example,dc=com
objectclass: top
objectclass: LdapSubEntry
objectclass: nsRoleDefinition
objectclass: nsComplexRoleDefinition
objectclass: nsFilteredRoleDefinition
cn: My_Filtered_Role
nsRoleFilter: objectclass=posixAccount
```

<br>

#### Example of **nested** role

```
# dsctl slapd-localhost ldifgen roles My_Nested_Role --type filtered --parent ou=roles,dc=example,dc=com --role-dn cn=some_role,ou=roles,dc=example,dc=com

```

And this creates a Indirect COS definition

```
dn: cn=My_Nested_Role,ou=roles,dc=example,dc=com
objectclass: top
objectclass: LdapSubEntry
objectclass: nsRoleDefinition
objectclass: nsComplexRoleDefinition
objectclass: nsNestedRoleDefinition
cn: My_Nested_Role
nsRoleDN: cn=some_role,ou=roles,dc=example,dc=com

```

<br>

Creating a Modification LDIF
---------------------

Create an LDIF containing LDAP update operations that can be consumed by ldapmodify

### Usage


```
# dsctl slapd-localhost ldifgen mod-load --help
usage: dsctl [instance] ldifgen mod-load [-h] [--create-users] [--delete-users]
                                       [--num-users NUM_USERS]
                                       [--parent PARENT] [--create-parent]
                                       [--add-users ADD_USERS]
                                       [--del-users DEL_USERS]
                                       [--modrdn-users MODRDN_USERS]
                                       [--mod-users MOD_USERS]
                                       [--mod-attrs [MOD_ATTRS [MOD_ATTRS ...]]]
                                       [--randomize] [--ldif-file LDIF_FILE]

optional arguments:
  -h, --help            show this help message and exit
  --create-users        Create the entries that will be modified or deleted.
                        By default the script assumes the user entries already
                        exist.
  --delete-users        Delete all the user entries at the end of the LDIF.
  --num-users NUM_USERS
                        The number of user entries that will be modified or
                        deleted
  --parent PARENT       The DN of the parent entry where the user entries are
                        located.
  --create-parent       Create the parent entry
  --add-users ADD_USERS
                        The number of additional entries to add during the
                        load.
  --del-users DEL_USERS
                        The number of entries to delete during the load.
  --modrdn-users MODRDN_USERS
                        The number of entries to perform a modrdn operation
                        on.
  --mod-users MOD_USERS
                        The number of entries to modify.
  --mod-attrs [MOD_ATTRS [MOD_ATTRS ...]]
                        List of attributes the script will randomly choose
                        from when modifying an entry. The default is
                        "description".
  --randomize           Randomly perform the specified add, mod, delete, and
                        modrdn operations
  --ldif-file LDIF_FILE
                        The LDIF file name. Default is "/tmp/ldifgen.ldif"
```

<br>

### Example: Create Users and Modify Them

```
# dsctl slapd-localhost ldifgen mod-load --parent dc=example,dc=com --num-users 1000 --create-users --mod-users 1000 --mod-attrs cn uid sn --delete-users
```

This creates an LDIF with 1000 ADD operations to create the user entries, followed by modifying all 1000 entries by changing either **cn**, **uid**, or **sn**.  After the modifies all done then all the entries are deleted


<br>

### Example: Create Users and do mixed operations

```
# dsctl slapd-localhost ldifgen mod-load --parent dc=example,dc=com --num-users 1000 --create-users --mod-users 1000 --add-users 10 --del-users 100 --mod-users 1000 --modrdn-users 100 --mod-attrs cn uid sn --delete-users
```

This creates an LDIF with 1000 ADD operations to create the user entries, followed by modifying all 1000 entries by changing either **cn**, **uid**, or **sn**, then it adds an additional 10 users, performs 100 modrdn operations, and deletes 100 entries.  After all that then all the entries are deleted.

<br>

### Example: Create Users and do mixed operations randomly

```
# dsctl slapd-localhost ldifgen mod-load --parent dc=example,dc=com --num-users 1000 --create-users --mod-users 1000 --add-users 10 --del-users 100 --mod-users 1000 --modrdn-users 100 --mod-attrs cn uid sn --delete-users --randomize
```

This creates an LDIF with 1000 ADD operations to create the user entries, then it randomly does the ADD, MODIFY, MODRDN, and DELETE operations.  After all that then all the entries are deleted.  Since the operations are randomized, and you can do deletes, it possible a delete might happen before a modify operation is performed.  So it is expected that some of these operations will fail simply due to the random timing.  So best to run ldapmodify with the **\-c** option to "continue on error".

<br>

Creating a Nest LDIF
---------------------

This LDIF is a heavily nested cascading fractal structure.  There is no interactive mode for this LDIF because all you need need to do is set the suffix, the number of entries, and the number of entries to add to each node.

### Usage

```
# dsctl slapd-localhost ldifgen nested --help
usage: dsctl [instance] ldifgen nested [-h] --num-users NUM_USERS --node-limit
                                     NODE_LIMIT --suffix SUFFIX
                                     [--ldif-file LDIF_FILE]

optional arguments:
  -h, --help            show this help message and exit
  --num-users NUM_USERS
                        The total number of user entries to create in the
                        entire LDIF (does not include the container entries).
  --node-limit NODE_LIMIT
                        The total number of user entries to create under each
                        node/subtree
  --suffix SUFFIX       The suffix DN for the LDIF
  --ldif-file LDIF_FILE
                        The LDIF file name.  Default location is the server's LDIF directory using the name 'users.ldif'

```

<br>

### Example

So if you have 600 entries, and you add 100 entries per node, the LDIF file structure would look something like


```
# dsctl slapd-localhost ldifgen nested  --num-users 600 --node-limit 100  --suffix o=suffix



                                               o=suffix
                                                  |
                     --------------------------------------------------------------
                ou=1,o=suffix                                                ou=2,o=suffix
                (100 users)                                                   (100 users)
                    |                                                              |
         -----------------------------                               -------------------------------
  ou=1,ou=1,o=suffix           ou=2,ou=1,o=suffix               ou=1,ou=2,o=suffix           ou=2,ou=2,o=suffix
     (100 users)                  (100 users)                      (100 users)                   (100 users)

```

<br>

Author
------

<mreynolds@redhat.com>

