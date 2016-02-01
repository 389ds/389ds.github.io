---
title: "Howto: Operational Attributes"
---

# How to access operational attributes
------------------------------------

Some attributes such as the operational attributes are automatically maintained by the server, not modifiable, not returned by default, and read only for clients, although some operational attributes can be set by the administrator. They are called operational attributes because they are calculated by the server.

Those are defined in RFC 2251.

      Entries MAY contain, among others, the following operational    
      attributes, defined in [5]. These attributes are maintained    
      automatically by the server and are not modifiable by clients:    
      - creatorsName: the Distinguished Name of the user who added this    
        entry to the directory.    
      - createTimestamp: the time this entry was added to the directory.    
      - modifiersName: the Distinguished Name of the user who last modified    
        this entry.    
      - modifyTimestamp: the time this entry was last modified.    
      - subschemaSubentry:  the Distinguished Name of the subschema entry    
        (or subentry) which controls the schema for this entry.    

Other attributes not returned by default are:

-   structuralObjectClass
-   subordinateCount
-   subschemaSubentry

The filter in an ldapsearch has to explicitly ask for them, for example, like this:

    ldapsearch -h some-hostname uid=some-uid modifiersname    

You may request all operational attributes using the special char '+'

    ldapsearch -h some-hostname uid=some-uid '+'

The list of attributes may be limited by your current bind dn's acis.

The modifiersname attribute can be updated by the directory manager:

    ldapmodify -h some-host -D "cn=directory manager" -w some-password
    dn: uid=some-uid, dc=sometest
    changetype: modify
    replace: modifiersname
    modifiersname: cn=some-other-cn
