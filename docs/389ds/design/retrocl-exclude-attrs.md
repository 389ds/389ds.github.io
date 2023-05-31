---
title: "Exclude retro changelog attributes"
---

# Exclude attributes from retro changelog database
----------------

{% include toc.md %}

Overview
--------

The retro changelog (retrocl) plugin is used to track changes made to entries in the Directory Server DB. For ADD and MODIFY operations
the attribute value is stored under the "cn=changelog" suffix. In some cases an entries attribute could contain sensitive information so 
we should provide an option to exclude these attributes from the retrocl DB.
 
Use cases
---------

A 389-ds instance contains the details of multiple employees, the system administrator has decided that the employees home phone 
number is classed as sensitive and should be excluded from the retrocl DB. 

dsconf -D "cn=Directory Manager" instance001 plugin retro-changelog add --exclude-attrs homePhone:phone

When an employees homePhone is modified, the modified attribute will be excluded from the retrocl DB.

### Retrocl entry before this change
    dn: changenumber=1,cn=changelog                                                               
    objectClass: top                                                                               
    objectClass: changelogentry                                                                    
    changeNumber: 1                                                                               
    targetDn: uid=Employee01,ou=product development,dc=employees,dc=com                                
    changeTime: 20210409090234Z                                                                    
    changeType: modify                                                                             
    changes:: cmVwbGFjZTogaG9tZVBob25lCmhvbWVQaG9uZTogMDg3MTIzNDU2NwotCnJlcGxhY2U6IG1vZGlm
    aWVyc25hbWUKbW9kaWZpZXJzbmFtZTogY249RGlyZWN0b3J5IE1hbmFnZXIKLQpyZXBsYWNlOiBt
    b2RpZnl0aW1lc3RhbXAKbW9kaWZ5dGltZXN0YW1wOiAyMDIxMDQwOTA5MDIzNFoK

### The base64 decoded change string displays the modified home phone number:
    replace: homePhone
    homePhone: 0871234567
    -
    replace: modifiersname
    modifiersname: cn=Directory Manager
    -
    replace: modifytimestamp
    modifytimestamp: 20210409090234Z


### Retrocl entry after this change:
    dn: changenumber=2,cn=changelog                                                               
    objectClass: top                                                                               
    objectClass: changelogentry                                                                    
    changeNumber: 2                                                                               
    targetDn: uid=Employee01,ou=product development,dc=employees,dc=com                                
    changeTime: 20210409090234Z                                                                    
    changeType: modify                                                                             
    changes:: cmVwbGFjZTogbW9kaWZpZXJzbmFtZQptb2RpZmllcnNuYW1lOiBjbj1EaXJlY3RvcnkgTWFuYWdl
    cgotCnJlcGxhY2U6IG1vZGlmeXRpbWVzdGFtcAptb2RpZnl0aW1lc3RhbXA6IDIwMjEwNDA5MDkw
    MjM0Wgo=

### The base64 decoded change string excludes the homePhone attribute updates.
    replace: modifiersname
    modifiersname: cn=Directory Manager
    -
    replace: modifytimestamp
    modifytimestamp: 20210409090234Z

The same principal applies for an add entry operation where all attributes are displayed in the retrocl entry.

Design
------

Modify the CLI to allow an administrator define attributes that will be excluded from the retrocl DB. These attributes will be added to the 
retrocl config suffix "cn=Retro Changelog Plugin,cn=plugins,cn=config" as generic attribute objects that can be accessed at a later stage.

On startup the retrocl plugin will query the retrocl config suffix for attributes to exclude, populating a global exclude_attrs array.

During construction of a retro changelog entry, the exclude_attrs list is queried to determine if a attribute should be excluded.

Implementation
--------------

### Retro changelog front end - retrochangelog.py
Add a new optional argument that will allow for the specification of an attribute to exclude.

### Retro changelog plugin - retrocl.c
On startup the retrocl plugin will query the retrocl suffix for excluded attributes.
Excluded attributes will be added to an array where they can be queried during changelog entry construction.

### Retro changelog plugin post operation - retrocl_po.c
entry2reple() - Following an add operation each entry attribute is checked for exclusion before it is written to the retrocl. 

mods2reple() -  Following a modify operation the LDAPmod struct contains details of the modify, as we iterate through its values we
                check for attributes that need to be excluded.

A delete/modrdn operation entry in the retro changelog doesnt contain any attribute values so it remains untouched.

Major configuration options and enablement
------------------------------------------

Enable the retrocl plugin
    dsconf -D "cn=Directory Manager" instance001 plugin retro-changelog enable

Plugin dynamic loading enabled (Otherwise the server must be restarted for the exclude_attrs to get populated!) 
    dsconf -D "cn=Directory Manager" instance001 config replace nsslapd-dynamic-plugins=on

Exclude an attribute from the retrocl
    dsconf -D "cn=Directory Manager" instance001 plugin retro-changelog add --exclude-attrs homePhone:phone

Replication
-----------

This change will not be compatible with content synchronisation (syncrepl), docuentation will be updated to reflect this.

External Impact
---------------

There will be no impact to other components.

Origin
-------------

https://bugzilla.redhat.com/show_bug.cgi?id=1850664
https://github.com/389ds/389-ds-base/issues/4701

Author
------

<jachapma@redhat.com>

