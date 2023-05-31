---
title: "Get Effective Rights for non-present attributes"
---

# Get Effective Rights for non-present attributes
-------------------------------------------------

{% include toc.md %}

Overview
========

Get Effective Rights is enhanced to support these requirements:

1. a requester should be able to see the effective rights of each entry returned from the search request if the subject user is identical to the requester. This functionality can be used, e.g., for an address card to determine which fields to be writable and to be grayed out depending upon the user who opens the card.

2. the attribute list to be retrieved accepts '\*' for the all the available attributes belonging to the returned entry as well as '+' for the operational attributes to allow the requester get the effective rights of all the non-existing attributes.

3. the attribute list to be retrieved accepts "<attr>@<objectclassname>", where <attr> is an attribute type (e.g., cn) or '\*' for all attributes and <objectclassname> is a type of objectclass (e.g., inetorgperson).

Implementation
==============

1. Applying the patch with some minor changes from Andrey Ivanov. <https://bugzilla.redhat.com/show_bug.cgi?id=437525#c2> (Thank you, Andrey!)

Description: acl\_get\_effective\_rights (acl/acleffectiverights.c) passes an additional argument "subjectndn" to \_ger\_g\_permission\_granted. If the requester is identical to the subject user dn, "g" permission is granted and the requester is able to see the effective rights of the entries that the requester has a read permission on.

2. The supportive function \_ger\_get\_attrs\_rights (acl/acleffectiverights.c) retrieves the effective rights of attribute list. The attribute list could be either existing attributes in the entry or the user given attribute list. The user given attribute list can include '\*' as well as '+', which is newly added. The function \_ger\_get\_attrs\_rights first obtain all the attributes available for the object class and its superiors (allattrs) and operational attributes (opattrs). If both '\*' and '+' are found in the given attribute list, it gathers all the effective rights of attributes in the allattrs list and the opattrs list. If '\*' is included but not '+' with an attribute list, it makes a union of allattrs and the attribute list, then it gathers the effective rights of the union. If '+' is included but not '\*" with an attribute list, it makes a union of opattrs and the attribute list, then it gathers the effective rights of the union. If '\*' nor '+' are included, it simply gathers the effective rights of the given attribute list. There is another minor change that it used to accept any bogus attribute type, but now the bogus types are ignored.

3. When the front-end search function do\_search finds the attribute list includes '@' [ note: the attribute type is defined as ldap-oid or (ALPHA (ALPHA \| DIGIT \| "-")\*) That is, '@' is not a part of the allowed characters], it stores the string before '@' (<attr> part of <attr>@<objectclass>) to the attribute type array and the entire string to the GER specific string array. Both are set to the pblock to make them available in the context. At the end of the search operation, it sends the results back to the client. In the iteration, it checks the control if the Get Effective Rights is requested. If yes, it additionally checks the GER string array. If the array is not empty, it calls the acl plugin to invoke the get effective rights (acl\_get\_effective\_rights). In the module, if no search entry is found, it generates a template entry based upon the GER string (\_ger\_generate\_template\_entry) and use it for getting effective rights. The template entry is located at the search base dn. By changing the search base dn, the requester can get the effective rights of the various levels.

Usage Samples
=============

1. Cases already supported
--------------------------

1-1. requester: Directory Manager, subject user: Directory User, Directory Manager shows the Directory Manager's effective rights of all the existing attributes in the returned entries.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: cn=Directory Manager" "(uid=*)"
    dn: uid=tuser0, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    mail: tuser0@example.com
    userPassword: {SSHA}mDQuOmyKsWiQR13f3ZSSBz+/b1L5RQbleZHXwA==
    entryLevelRights: vadn
    attributeLevelRights: objectClass:rscwo, cn:rscwo, sn:rscwo, uid:rscwo, givenN
     ame:rscwo, mail:rscwo, userPassword:rscwo

    dn: uid=tuser1, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    mail: tuser1@example.com
    userPassword: {SSHA}0jqaoiErqwExQD1bl3z4fFuMYPb8Vowlh+jA8A==
    entryLevelRights: vadn
    attributeLevelRights: objectClass:rscwo, cn:rscwo, sn:rscwo, uid:rscwo, givenN
     ame:rscwo, mail:rscwo, userPassword:rscwo

    dn: uid=tuser2, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user2
    sn: user2
    uid: tuser2
    givenName: test
    mail: tuser2@example.com
    userPassword: {SSHA}IMynrihg3vhGtBJJhspeZ4l3Ux1A2qjkRHxg6Q==
    entryLevelRights: vadn
    attributeLevelRights: objectClass:rscwo, cn:rscwo, sn:rscwo, uid:rscwo, givenN
     ame:rscwo, mail:rscwo, userPassword:rscwo

1-2. requester: Directory Manager, subject user: Directory User, Directory Manager shows the Directory Manager's effective rights of the user given attribute list, which do not exist in the entries.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: cn=Directory Manager" "(uid=*)" \
     l ou st
    dn: uid=tuser0, dc=example,dc=com
    entryLevelRights: vadn
    attributeLevelRights: l:rscwo, ou:rscwo, st:rscwo

    dn: uid=tuser1, dc=example,dc=com
    entryLevelRights: vadn
    attributeLevelRights: l:rscwo, ou:rscwo, st:rscwo

    dn: uid=tuser2, dc=example,dc=com
    entryLevelRights: vadn
    attributeLevelRights: l:rscwo, ou:rscwo, st:rscwo

1-3. requester: Directory Manager, subject user: tuser0: Directory Manager shows the tuser0's the effective rights of all the existing attributes in the returned entries.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,dc=example,dc=com" \
     "(uid=*)"
    dn: uid=tuser0, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    mail: tuser0@example.com
    userPassword: {SSHA}mDQuOmyKsWiQR13f3ZSSBz+/b1L5RQbleZHXwA==
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rscwo, userPassword:wo

    dn: uid=tuser1, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    mail: tuser1@example.com
    userPassword: {SSHA}0jqaoiErqwExQD1bl3z4fFuMYPb8Vowlh+jA8A==
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rsc, userPassword:none

    dn: uid=tuser2, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user2
    sn: user2
    uid: tuser2
    givenName: test
    mail: tuser2@example.com
    userPassword: {SSHA}IMynrihg3vhGtBJJhspeZ4l3Ux1A2qjkRHxg6Q==
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rsc, userPassword:none

1-4. requester: Directory Manager, subject user: tuser0, Directory Manager shows the tuser0's the effective rights of the user given attribute list, which do not exist in the entries.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,dc=example,dc=com" \
     "(uid=*)" l ou st
    dn: uid=tuser0, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: l:rsc, ou:rsc, st:rscwo

    dn: uid=tuser1, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: l:rsc, ou:rsc, st:rsc

    dn: uid=tuser2, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: l:rsc, ou:rsc, st:rsc

1-5. requester: tuser0, subject user: tuser1: tuser0 shows the tuser1's the effective rights of all the existing attributes in the returned entries. [ 50 is LDAP\_INSUFFICIENT\_ACCESS; that is, tuser0 is not allowed to give "g" permission to tuser1. ]

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,dc=example,dc=com" \
     "(uid=*)"
    dn: uid=tuser0, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    mail: tuser0@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rsc, userPassword:none

    dn: uid=tuser1, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    mail: tuser1@example.com
    entryLevelRights: 50
    attributeLevelRights: *:50
    dn: uid=tuser2, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user2
    sn: user2
    uid: tuser2
    givenName: test
    mail: tuser2@example.com
    entryLevelRights: 50
    attributeLevelRights: *:50

1-6. requester: tuser0, subject user: tuser1: tuser0 shows the tuser1's the effective rights of the user given attribute list, which do not exist in the entries. [ 50 is LDAP\_INSUFFICIENT\_ACCESS; that is, tuser0 is not allowed to give "g" permission to tuser1. ]

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,dc=example,dc=com" \
     "(uid=*)" l ou st
    dn: uid=tuser0, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: l:rsc, ou:rsc, st:rsc
    dn: uid=tuser1, dc=example,dc=com
    entryLevelRights: 50
    attributeLevelRights: *:50
    dn: uid=tuser2, dc=example,dc=com
    entryLevelRights: 50
    attributeLevelRights: *:50

2. Cases newly supported
------------------------

2-1. requester: tuser0, subject user: tuser0: tuser0 shows tuser0's effective rights of all the existing attributes in the returned entries. tuser0 is allowed to see the effective rights of the entries that tuser0 can read/search.

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,dc=example,dc=com" \
     "(uid=*)"
    dn: uid=tuser0, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    mail: tuser0@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rscwo, userPassword:wo

    dn: uid=tuser1, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    mail: tuser1@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rsc, userPassword:none

    dn: uid=tuser2, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user2
    sn: user2
    uid: tuser2
    givenName: test
    mail: tuser2@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, cn:rsc, sn:rsc, uid:rsc, givenName:rsc,
      mail:rsc, userPassword:none

2-2. requester: tuser0, subject user: tuser0: tuser0 shows tuser0's effective rights of the user given attribute list, which do not exist in the entries. tuser0 is allowed to see the effective rights of the entries that tuser0 can read/search.

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,dc=example,dc=com" \
     "(uid=*)" l ou st
    dn: uid=tuser0, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: l:rsc, ou:rsc, st:rscwo

    dn: uid=tuser1, dc=example,dc=com
    entryLevelRights: 
    attributeLevelRights: l:rsc, ou:rsc, st:rsc

    dn: uid=tuser2, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: l:rsc, ou:rsc, st:rsc

2-3. requester: tuser0, subject user: tuser0: tuser0 shows tuser0's effective rights of all the available attributes associated with the entry's objectclasses, which values may or may not exist. tuser0 is allowed to see the effective rights of the entries that tuser0 can read/search.

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,dc=example,dc=com" \
     "(uid=*)" "*"
    dn: uid=tuser0, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    mail: tuser0@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, aci:rsc, sn:rsc, cn:rsc, description:rs
     cwo, seeAlso:rscwo, telephoneNumber:rscwo, userPassword:wo, destinationIndic
     ator:rsc, facsimileTelephoneNumber:rscwo, internationaliSDNNumber:rsc, l:rsc
     , ou:rsc, physicalDeliveryOfficeName:rsc, postOfficeBox:rscwo, postalAddress
     :rscwo, postalCode:rscwo, preferredDeliveryMethod:rscwo, registeredAddress:r
     scwo, st:rscwo, street:rscwo, teletexTerminalIdentifier:rsc, telexNumber:rsc
     wo, title:rscwo, x121Address:rsc, audio:rsc, businessCategory:rsc, carLicens
     e:rscwo, departmentNumber:rsc, displayName:rscwo, employeeType:rsc, employee
     Number:rsc, givenName:rsc, homePhone:rscwo, homePostalAddress:rscwo, initial
     s:rscwo, jpegPhoto:rscwo, labeledUri:rsc, manager:rsc, mobile:rscwo, pager:r
     scwo, photo:rscwo, preferredLanguage:rscwo, mail:rscwo, o:rsc, roomNumber:rs
     cwo, secretary:rscwo, uid:rsc, x500UniqueIdentifier:rscwo, userCertificate:r
     scwo, userSMIMECertificate:rscwo, userPKCS12:rsc

    dn: uid=tuser1, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    mail: tuser1@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, aci:rsc, sn:rsc, cn:rsc, description:rs
     c, seeAlso:rsc, telephoneNumber:rsc, userPassword:none, destinationIndicator
     :rsc, facsimileTelephoneNumber:rsc, internationaliSDNNumber:rsc, l:rsc, ou:r
     sc, physicalDeliveryOfficeName:rsc, postOfficeBox:rsc, postalAddress:rsc, po
     stalCode:rsc, preferredDeliveryMethod:rsc, registeredAddress:rsc, st:rsc, st
     reet:rsc, teletexTerminalIdentifier:rsc, telexNumber:rsc, title:rsc, x121Add
     ress:rsc, audio:rsc, businessCategory:rsc, carLicense:rsc, departmentNumber:
     rsc, displayName:rsc, employeeType:rsc, employeeNumber:rsc, givenName:rsc, h
     omePhone:rsc, homePostalAddress:rsc, initials:rsc, jpegPhoto:rsc, labeledUri
     :rsc, manager:rsc, mobile:rsc, pager:rsc, photo:rsc, preferredLanguage:rsc,
     mail:rsc, o:rsc, roomNumber:rsc, secretary:rsc, uid:rsc, x500UniqueIdentifie
     r:rsc, userCertificate:rsc, userSMIMECertificate:rsc, userPKCS12:rsc

    dn: uid=tuser2, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user2
    sn: user2
    uid: tuser2
    givenName: test
    mail: tuser2@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, aci:rsc, sn:rsc, cn:rsc, description:rs
     c, seeAlso:rsc, telephoneNumber:rsc, userPassword:none, destinationIndicator
     :rsc, facsimileTelephoneNumber:rsc, internationaliSDNNumber:rsc, l:rsc, ou:r
     sc, physicalDeliveryOfficeName:rsc, postOfficeBox:rsc, postalAddress:rsc, po
     stalCode:rsc, preferredDeliveryMethod:rsc, registeredAddress:rsc, st:rsc, st
     reet:rsc, teletexTerminalIdentifier:rsc, telexNumber:rsc, title:rsc, x121Add
     ress:rsc, audio:rsc, businessCategory:rsc, carLicense:rsc, departmentNumber:
     rsc, displayName:rsc, employeeType:rsc, employeeNumber:rsc, givenName:rsc, h
     omePhone:rsc, homePostalAddress:rsc, initials:rsc, jpegPhoto:rsc, labeledUri
     :rsc, manager:rsc, mobile:rsc, pager:rsc, photo:rsc, preferredLanguage:rsc,
     mail:rsc, o:rsc, roomNumber:rsc, secretary:rsc, uid:rsc, x500UniqueIdentifie
     r:rsc, userCertificate:rsc, userSMIMECertificate:rsc, userPKCS12:rsc

2-4. requester: tuser0, subject user: tuser0: tuser0 shows tuser0's effective rights of the all the available operational attributes. tuser0 is allowed to see the effective rights of the entries that tuser0 can read/search.

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,dc=example,dc=com" \
     "(uid=*)" "+"
    dn: uid=tuser0, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: nsICQStatusText:rsc, passwordGraceUserTime:rsc, pwdGrace
     UserTime:rsc, nsYIMStatusText:rsc, modifyTimestamp:rsc, passwordExpWarned:rs
     c, pwdExpirationWarned:rsc, entrydn:rsc, aci:rsc, nsSizeLimit:rsc, nsAccount
     Lock:rsc, passwordExpirationTime:rsc, entryid:rsc, nsSchemaCSN:rsc, nsRole:r
     sc, retryCountResetTime:rsc, ldapSchemas:rsc, nsAIMStatusText:rsc, copiedFro
     m:rsc, nsICQStatusGraphic:rsc, nsUniqueId:rsc, creatorsName:rsc, passwordRet
     ryCount:rsc, dncomp:rsc, nsTimeLimit:rsc, passwordHistory:rsc, pwdHistory:rs
     c, nscpEntryDN:rsc, subschemaSubentry:rsc, nsYIMStatusGraphic:rsc, hasSubord
     inates:rsc, pwdpolicysubentry:rsc, nsAIMStatusGraphic:rsc, nsRoleDN:rsc, cre
     ateTimestamp:rsc, accountUnlockTime:rsc, copyingFrom:rsc, nsLookThroughLimit
     :rsc, nsds5ReplConflict:rsc, modifiersName:rsc, parentid:rsc, passwordAllowC
     hangeTime:rsc, nsBackendSuffix:rsc, nsIdleTimeout:rsc, ldapSyntaxes:rsc, num
     Subordinates:rsc

    dn: uid=tuser1, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: nsICQStatusText:rsc, passwordGraceUserTime:rsc, pwdGrace
     UserTime:rsc, nsYIMStatusText:rsc, modifyTimestamp:rsc, passwordExpWarned:rs
     c, pwdExpirationWarned:rsc, entrydn:rsc, aci:rsc, nsSizeLimit:rsc, nsAccount
     Lock:rsc, passwordExpirationTime:rsc, entryid:rsc, nsSchemaCSN:rsc, nsRole:r
     sc, retryCountResetTime:rsc, ldapSchemas:rsc, nsAIMStatusText:rsc, copiedFro
     m:rsc, nsICQStatusGraphic:rsc, nsUniqueId:rsc, creatorsName:rsc, passwordRet
     ryCount:rsc, dncomp:rsc, nsTimeLimit:rsc, passwordHistory:rsc, pwdHistory:rs
     c, nscpEntryDN:rsc, subschemaSubentry:rsc, nsYIMStatusGraphic:rsc, hasSubord
     inates:rsc, pwdpolicysubentry:rsc, nsAIMStatusGraphic:rsc, nsRoleDN:rsc, cre
     ateTimestamp:rsc, accountUnlockTime:rsc, copyingFrom:rsc, nsLookThroughLimit
     :rsc, nsds5ReplConflict:rsc, modifiersName:rsc, parentid:rsc, passwordAllowC
     hangeTime:rsc, nsBackendSuffix:rsc, nsIdleTimeout:rsc, ldapSyntaxes:rsc, num
     Subordinates:rsc

    dn: uid=tuser2, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: nsICQStatusText:rsc, passwordGraceUserTime:rsc, pwdGrace
     UserTime:rsc, nsYIMStatusText:rsc, modifyTimestamp:rsc, passwordExpWarned:rs
     c, pwdExpirationWarned:rsc, entrydn:rsc, aci:rsc, nsSizeLimit:rsc, nsAccount
     Lock:rsc, passwordExpirationTime:rsc, entryid:rsc, nsSchemaCSN:rsc, nsRole:r
     sc, retryCountResetTime:rsc, ldapSchemas:rsc, nsAIMStatusText:rsc, copiedFro
     m:rsc, nsICQStatusGraphic:rsc, nsUniqueId:rsc, creatorsName:rsc, passwordRet
     ryCount:rsc, dncomp:rsc, nsTimeLimit:rsc, passwordHistory:rsc, pwdHistory:rs
     c, nscpEntryDN:rsc, subschemaSubentry:rsc, nsYIMStatusGraphic:rsc, hasSubord
     inates:rsc, pwdpolicysubentry:rsc, nsAIMStatusGraphic:rsc, nsRoleDN:rsc, cre
     ateTimestamp:rsc, accountUnlockTime:rsc, copyingFrom:rsc, nsLookThroughLimit
     :rsc, nsds5ReplConflict:rsc, modifiersName:rsc, parentid:rsc, passwordAllowC
     hangeTime:rsc, nsBackendSuffix:rsc, nsIdleTimeout:rsc, ldapSyntaxes:rsc, num
     Subordinates:rsc

2-5. requester: tuser0, subject user: tuser1: tuser0 attempts to show tuser1's effective rights of all the available attributes associated with the objectclasses of the requester(tuser0)'s entry, which values may or may not exist. tuser0 is not allow to grant "g" permission on the other entries.

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,dc=example,dc=com" \
     "(uid=*)" "*"
    dn: uid=tuser0, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    mail: tuser0@example.com
    entryLevelRights: v
    attributeLevelRights: objectClass:rsc, aci:rsc, sn:rsc, cn:rsc, description:rs
     c, seeAlso:rsc, telephoneNumber:rsc, userPassword:none, destinationIndicator
     :rsc, facsimileTelephoneNumber:rsc, internationaliSDNNumber:rsc, l:rsc, ou:r
     sc, physicalDeliveryOfficeName:rsc, postOfficeBox:rsc, postalAddress:rsc, po
     stalCode:rsc, preferredDeliveryMethod:rsc, registeredAddress:rsc, st:rsc, st
     reet:rsc, teletexTerminalIdentifier:rsc, telexNumber:rsc, title:rsc, x121Add
     ress:rsc, audio:rsc, businessCategory:rsc, carLicense:rsc, departmentNumber:
     rsc, displayName:rsc, employeeType:rsc, employeeNumber:rsc, givenName:rsc, h
     omePhone:rsc, homePostalAddress:rsc, initials:rsc, jpegPhoto:rsc, labeledUri
     :rsc, manager:rsc, mobile:rsc, pager:rsc, photo:rsc, preferredLanguage:rsc,
     mail:rsc, o:rsc, roomNumber:rsc, secretary:rsc, uid:rsc, x500UniqueIdentifie
     r:rsc, userCertificate:rsc, userSMIMECertificate:rsc, userPKCS12:rsc

    dn: uid=tuser1, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    mail: tuser1@example.com
    entryLevelRights: 50
    attributeLevelRights: *:50

    dn: uid=tuser2, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user2
    sn: user2
    uid: tuser2
    givenName: test
    mail: tuser2@example.com
    entryLevelRights: 50
    attributeLevelRights: *:50

2-6. requester: tuser0, subject user: tuser1: tuser0 attempts to show tuser1's effective rights of all the available operational attributes of the requester(tuser0)'s entry. tuser0 is not allow to grant "g" permission on the other entries.

    ldapsearch -D "uid=tuser0,dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,dc=example,dc=com" \
     "(uid=*)" "+"
    dn: uid=tuser0, dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: nsICQStatusText:rsc, passwordGraceUserTime:rsc, pwdGrace
     UserTime:rsc, nsYIMStatusText:rsc, modifyTimestamp:rsc, passwordExpWarned:rs
     c, pwdExpirationWarned:rsc, entrydn:rsc, aci:rsc, nsSizeLimit:rsc, nsAccount
     Lock:rsc, passwordExpirationTime:rsc, entryid:rsc, nsSchemaCSN:rsc, nsRole:r
     sc, retryCountResetTime:rsc, ldapSchemas:rsc, nsAIMStatusText:rsc, copiedFro
     m:rsc, nsICQStatusGraphic:rsc, nsUniqueId:rsc, creatorsName:rsc, passwordRet
     ryCount:rsc, dncomp:rsc, nsTimeLimit:rsc, passwordHistory:rsc, pwdHistory:rs
     c, nscpEntryDN:rsc, subschemaSubentry:rsc, nsYIMStatusGraphic:rsc, hasSubord
     inates:rsc, pwdpolicysubentry:rsc, nsAIMStatusGraphic:rsc, nsRoleDN:rsc, cre
     ateTimestamp:rsc, accountUnlockTime:rsc, copyingFrom:rsc, nsLookThroughLimit
     :rsc, nsds5ReplConflict:rsc, modifiersName:rsc, parentid:rsc, passwordAllowC
     hangeTime:rsc, nsBackendSuffix:rsc, nsIdleTimeout:rsc, ldapSyntaxes:rsc, num
     Subordinates:rsc

    dn: uid=tuser1, dc=example,dc=com
    entryLevelRights: 50
    attributeLevelRights: *:50

    dn: uid=tuser2, dc=example,dc=com
    entryLevelRights: 50
    attributeLevelRights: *:50

2-7. requester: Directory Manager, subject user: Directory Maanger, Directory Manager shows the Directory Manager's the effective rights of the template entries inetorgperson and posixaccount, which do not exist.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "dc=example,dc=com" -J \
     "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: cn=Directory Manager" "(uid=bogus)" \
     "*@inetorgperson" "*@posixaccount"
    version: 1
    dn: cn=template_inetorgperson_objectclass
    objectClass: inetorgperson
    objectClass: organizationalPerson
    objectClass: person
    objectClass: top
    cn: dummy
    sn: dummy
    entryLevelRights: vadn
    attributeLevelRights: sn:rscwo, cn:rscwo, objectClass:rscwo, audio:rscwo, busi
     nessCategory:rscwo, carLicense:rscwo, departmentNumber:rscwo, displayName:rs
     cwo, employeeType:rscwo, employeeNumber:rscwo, givenName:rscwo, homePhone:rs
     cwo, homePostalAddress:rscwo, initials:rscwo, jpegPhoto:rscwo, labeledUri:rs
     cwo, manager:rscwo, mobile:rscwo, pager:rscwo, photo:rscwo, preferredLanguag
     e:rscwo, mail:rscwo, o:rscwo, roomNumber:rscwo, secretary:rscwo, uid:rscwo,
     x500UniqueIdentifier:rscwo, userCertificate:rscwo, userSMIMECertificate:rscw
     o, userPKCS12:rscwo, destinationIndicator:rscwo, facsimileTelephoneNumber:rs
     cwo, internationaliSDNNumber:rscwo, l:rscwo, ou:rscwo, physicalDeliveryOffic
     eName:rscwo, postOfficeBox:rscwo, postalAddress:rscwo, postalCode:rscwo, pre
     ferredDeliveryMethod:rscwo, registeredAddress:rscwo, st:rscwo, street:rscwo,
      teletexTerminalIdentifier:rscwo, telexNumber:rscwo, title:rscwo, x121Addres
     s:rscwo, description:rscwo, seeAlso:rscwo, telephoneNumber:rscwo, userPasswo
     rd:rscwo, aci:rscwo

    dn: cn=template_posixaccount_objectclass
    objectClass: posixaccount
    objectClass: top
    homeDirectory: dummy
    gidNumber: dummy
    uidNumber: dummy
    uid: dummy
    cn: dummy
    entryLevelRights: vadn
    attributeLevelRights: cn:rscwo, uid:rscwo, uidNumber:rscwo, gidNumber:rscwo, h
     omeDirectory:rscwo, objectClass:rscwo, userPassword:rscwo, loginShell:rscwo,
      gecos:rscwo, description:rscwo, aci:rscwo

Sample ACL

    dn: dc=example,dc=com
    objectClass: top
    objectClass: domain
    dc: example
    aci: (target="ldap:///ou=Accounting,dc=example,dc=com")(targetattr="*")(version
     3.0; acl "test acl"; allow (read,search,compare) (userdn = "ldap:///anyone");)

    dn: ou=Accounting, dc=example,dc=com
    objectClass: top
    objectClass: organizationalUnit
    ou: Accounting
    dn: ou=Payroll, dc=example,dc=com
    objectClass: top
    objectClass: organizationalUnit
    ou: Payroll

    dn: uid=tuser0, ou=accounting, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user0
    sn: user0
    uid: tuser0
    givenName: test
    description: test user 0
    mail: tuser0@example.com
    userPassword: tuser0

    dn: uid=tuser1, ou=payroll, dc=example,dc=com
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    cn: test user1
    sn: user1
    uid: tuser1
    givenName: test
    description: test user 1
    mail: tuser1@example.com
    userPassword: tuser1

2-8. Using the above Sample ACL: requester: Directory Manager, subject user: tuser0, Directory Manager shows tuser0's effective rights of a template entry posixaccount at "dc=example,dc=com", where the template entry does not really exist. Since there is no ACL set at the level dc=example,dc=com, tuser0 has no rights on the entry.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,ou=accounting,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    dn: cn=template_posixaccount_objectclass,dc=example,dc=com
    objectClass: posixaccount
    objectClass: top
    homeDirectory: (template_attribute)
    gidNumber: (template_attribute)
    uidNumber: (template_attribute)
    uid: (template_attribute)
    cn: (template_attribute)
    entryLevelRights: none
    attributeLevelRights: cn:none, uid:none, uidNumber:none, gidNumber:none, homeD
     irectory:none, objectClass:none, userPassword:none, loginShell:none, gecos:n
     one, description:none, aci:none

2-9. Using the above Sample ACL: requester: Directory Manager, subject user: tuser0, Directory Manager shows tuser0's effective rights of a template entry posixaccount at "dc=accounting, dc=example,dc=com", where the template entry does not really exist. Since there is a read, search, compare ACL set for anyone at the level dc=accounting,dc=example,dc=com, tuser0 has the v right on the entry.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "ou=accounting, dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,ou=accounting,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    dn: cn=template_posixaccount_objectclass,ou=accounting,dc=example,dc=com
    objectClass: posixaccount
    objectClass: top
    homeDirectory: (template_attribute)
    gidNumber: (template_attribute)
    uidNumber: (template_attribute)
    uid: (template_attribute)
    cn: (template_attribute)
    entryLevelRights: v
    attributeLevelRights: cn:rsc, uid:rsc, uidNumber:rsc, gidNumber:rsc, homeDirec
     tory:rsc, objectClass:rsc, userPassword:rsc, loginShell:rsc, gecos:rsc, desc
     ription:rsc, aci:rsc

2-10. Using the above Sample ACL: requester: Directory Manager, subject user: tuser0, Directory Manager shows tuser0's effective rights of a template entry posixaccount at "dc=payroll, dc=example,dc=com", where the template entry does not really exist. Since there is no ACL set for anyone at the level dc=payroll,dc=example,dc=com, tuser0 has no rights on the entry.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "ou=payroll, dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,ou=accounting,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    dn: cn=template_posixaccount_objectclass,ou=payroll,dc=example,dc=com
    objectClass: posixaccount
    objectClass: top
    homeDirectory: (template_attribute)
    gidNumber: (template_attribute)
    uidNumber: (template_attribute)
    uid: (template_attribute)
    cn: (template_attribute)
    entryLevelRights: none
    attributeLevelRights: cn:none, uid:none, uidNumber:none, gidNumber:none, homeD
     irectory:none, objectClass:none, userPassword:none, loginShell:none, gecos:n
     one, description:none, aci:none

2-11. Using the above Sample ACL: requester: uid=tuser0, subject user: tuser0, tuser0 attempts to show tuser0's effective rights of a template entry posixaccount at "dc=example,dc=com", where the template entry does not really exist. Since there is no ACL set for anyone at the level dc=example,dc=com, tuser0 cannot get any result.

    $ ldapsearch -D "uid=tuser0, ou=Accounting, dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,ou=accounting,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    $    

2-12. Using the above Sample ACL: requester: uid=tuser0, subject user: tuser0, tuser0 shows tuser0's effective rights of a template entry posixaccount at "ou=accounting,dc=example,dc=com", where the template entry does not really exist. Since there is read, search, compare ACL set for anyone at the level ou=accounting,dc=example,dc=com, tuser0 has the v right on the entry.

    ldapsearch -D "uid=tuser0, ou=Accounting, dc=example,dc=com" -w tuser0 -b "ou=accounting,dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,ou=accounting,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    dn: cn=template_posixaccount_objectclass,ou=accounting,dc=example,dc=com
    objectClass: posixaccount
    objectClass: top
    homeDirectory: (template_attribute)
    gidNumber: (template_attribute)
    uidNumber: (template_attribute)
    uid: (template_attribute)
    cn: (template_attribute)
    entryLevelRights: v
    attributeLevelRights: cn:rsc, uid:rsc, uidNumber:rsc, gidNumber:rsc, homeDirec
     tory:rsc, objectClass:rsc, userPassword:rsc, loginShell:rsc, gecos:rsc, desc
     ription:rsc, aci:rsc

2-13. Using the above Sample ACL: requester: uid=tuser0, subject user: tuser0, tuser0 attempts to show tuser0's effective rights of a template entry posixaccount at "ou=payroll,dc=example,dc=com", where the template entry does not really exist. Since there is no ACL set for anyone at the level ou=payroll,dc=example,dc=com, tuser0 cannot show any result.

    $ ldapsearch -D "uid=tuser0, ou=Accounting, dc=example,dc=com" -w tuser0 -b "ou=payroll,dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0,ou=accounting,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    $    

2-14. Using the above Sample ACL: requester: uid=tuser0, subject user: tuser1, tuser0 attempts ot show tuser1's effective rights of a template entry posixaccount at "dc=example,dc=com", where the template entry does not really exist. Since there is no ACL set for anyone at the level dc=example,dc=com, tuser0 cannot get any result.

    $ ldapsearch -D "uid=tuser0, ou=Accounting, dc=example,dc=com" -w tuser0 -b "dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,ou=payroll,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    $

2-15. Using the above Sample ACL: requester: uid=tuser0, subject user: tuser1, tuser0 attempts to show tuser1's effective rights of a template entry posixaccount at "ou=accounting,dc=example,dc=com", where the template entry does not really exist. Since g permission is not granted, tuser0 has no rights to show tuser1's rights.

    ldapsearch -D "uid=tuser0, ou=Accounting, dc=example,dc=com" -w tuser0 -b "ou=accounting,dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,ou=payroll,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    dn: cn=template_posixaccount_objectclass,ou=accounting,dc=example,dc=com
    objectClass: posixaccount
    objectClass: top
    homeDirectory: (template_attribute)
    gidNumber: (template_attribute)
    uidNumber: (template_attribute)
    uid: (template_attribute)
    cn: (template_attribute)
    entryLevelRights: 50
    attributeLevelRights: *:50

2-16. Using the above Sample ACL: requester: uid=tuser0, subject user: tuser1, tuser0 attempts to show tuser1's effective rights of a template entry posixaccount at "ou=payroll,dc=example,dc=com", where the template entry does not really exist. Since there is no ACL set for anyone at the level ou=payroll,dc=example,dc=com, tuser0 cannot show any result.

    $ ldapsearch -D "uid=tuser0, ou=Accounting, dc=example,dc=com" -w tuser0 -b "ou=payroll,dc=example,dc=com" \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser1,ou=payroll,dc=example,dc=com" \
     "(uidnumber=*)" "*@posixaccount"
    $

2-17. Using the above Sample ACL: requester: Directory Manager, subject user: tuser0, Directory Manager attempts to show tuser0's effective rights of a template entry posixaccount at "" (RootDSE), where the template entry does not really exist. Since there is no ACL set for anyone at the level "", it shows tuser0 has no rights.

    ldapsearch -D "cn=Directory Manager" -w <pw> -b "" -s base \
     -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: uid=tuser0, ou=Accounting, dc=example,dc=com" \
      "(uidnumber=*)" "*@posixaccount"
    dn: cn=template_posixaccount_objectclass
    objectClass: posixaccount
    objectClass: top
    homeDirectory: (template_attribute)
    gidNumber: (template_attribute)
    uidNumber: (template_attribute)
    uid: (template_attribute)
    cn: (template_attribute)
    entryLevelRights: none
    attributeLevelRights: cn:none, uid:none, uidNumber:none, gidNumber:none, homeD
     irectory:none, objectClass:none, userPassword:none, loginShell:none, gecos:n
     one, description:none, aci:none

### NOTE

When "@*objectclass*" is passed to the attribute list in the ldap search, the first MUST attribute type of the *objectclass* is used to generate the DN in the temporary entry. When MUST attribute type does not exist, the first MAY attribute type is used. To specify other attribute type "*dntype*", the format "@*objectclass*:*dntype*" can be used.

This example shows the access rights of the anonymous user for the entry with leaf RDN "uidNumber=*value*" under the suffix "dc=example,dc=com".

    ldapsearch -D 'cn=Directory Manager' -w password -b "dc=example,dc=com" -J "1.3.6.1.4.1.42.2.27.9.5.2:false:dn: " \
     "(objectclass=*)" "@posixaccount:uidNumber"
    dn: uidNumber=template_posixaccount_objectclass,dc=example,dc=com
    entryLevelRights: v
    attributeLevelRights: description:rsc, gecos:rsc, loginShell:rsc, userPassword
     :rsc, objectClass:rsc, homeDirectory:rsc, gidNumber:rsc, uidNumber:rsc, uid:
     rsc, cn:rsc


