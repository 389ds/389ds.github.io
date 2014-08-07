---
title: "Syntax Validation Design"
---

# Syntax Validation Design
--------------------------

{% include toc.md %}

Background
----------

The current version of Directory Server does not perform any sort of syntax validation. We should provide the capability to enforce that the syntax of a particular attribute is obeyed.

### Types of validation

There are two basic types of validation to be performed. The first type is validating that new values being added to the database meet the syntax requirements of the attribute in question. The second type is validating that the assertion values used in a search filter meet the syntax requirements of the matching rule that is being used for the comparison in question.

#### Attribute value validation

Any operation that adds a new value to an attribute needs to have syntax validation performed. The LDAP operations that we need to perform validation on are:

-   ADD
-   MOD (add value)
-   MOD (replace value)
-   MODRDN

In addition to the above LDAP operations, we also need to perform validation for:

-   Import

#### Assertion value validation

The assertion values used in a search filter should be validated against the syntax of the matching rule that applies to the comparison. Each matching rule can have it's own syntax, which is not necessarily the same as the syntax of the attribute.

For a normal search filter (as opposed to an extensible match search filter), the matching rule that applies is taken from the attribute definition in the schema. A separate matching rule can be specified for EQUALITY, SUBSTRING, and ORDERING comparisons for each attribute.

Implementation
--------------

### Attribute value validation

Each syntax that the Directory Server supports is implemented in the form of a SLAPI plug-in. The approach to add attribute value validation is to allow a syntax plug-in to optionally register a validation callback function. When the Directory Server needs to validate a value for an attribute, it will call the validate function for the syntax used in that attributes definition. If a validation function is not registered for that syntax, then the server will just assume that the value is valid.

Attribute value validation should be skipped for replicated operations. It is expected that the master receiving the original operation validated the syntax, so there is no need to perform the validation on any of the other replicas. This assumes that syntax validation is configured the same way on all replicas.

#### Validation callback

A syntax validation callback function prototype would look like this:

    static int boolean_validate( struct berval *val );    

The value to validate will be passed in the form of a *struct berval*. The Directory Server already has the values in this form in memory everywhere that we need to validate the syntax of an attribute value, so this will perform better than converting the value to something like a Slapi\_Value. The validation function should not modify the value in any way.

The validation function should return 0 if the value meets the syntax requirements, and non-zero otherwise.

The validation function should deal with a NULL *val* parameter as well as an empty berval (*val-\>bv\_len == 0*) by returning non-zero.

##### Example

Here is an example of a validation function for the Boolean syntax:

    static int boolean_validate(    
        struct berval *val    
    )    
    {    
        int     rc = 0;    /* assume the value is valid */    
        /* Per RFC4517:    
         *    
         * Boolean =  "TRUE" / "FALSE"    
         */    
        if (val != NULL) {    
            if (val->bv_len == 4) {    
                if (strncmp(val->bv_val, "TRUE", 4) != 0) {    
                    rc = 1;    
                    goto exit;    
                }    
            } else if (val->bv_len == 5) {    
                if (strncmp(val->bv_val, "FALSE", 5) != 0) {    
                    rc = 1;    
                    goto exit;    
                }    
            } else {    
                rc = 1;    
                goto exit;    
            }    
        } else {    
            rc = 1;    
        }    
    exit:    
        return(rc);    
    }    

A syntax validation callback must be registered in the init function of the syntax plug-in. A new parameter will be added to Slapi\_PBlock named *SLAPI\_PLUGIN\_SYNTAX\_VALIDATE*. Registration of the callback would look something like this:

    slapi_pblock_set( pb, SLAPI_PLUGIN_SYNTAX_VALIDATE, (void *) boolean_validate );    

#### New public SLAPI functions

For add and import operations, it would be handy to have a function that checks an entire entry to see if it has any values are syntax violations. For modify and modrdn operations, it would be inefficient to check the syntax of the entire entry. A separate function that only checks the syntax of new values form a list of modifications would be ideal. Both of these functions would be useful for plug-in writers, so it makes sense to make them public via the SLAPI interface.

The following two functions would server the needs listed above:

    int slapi_entry_syntax_check( Slapi_PBlock *pb, Slapi_Entry *e, int override );    
    int slapi_mods_syntax_check( Slapi_PBlock *pb, LDAPMod **mods, int override );    

Both of the above function would return 0 if no syntax violations are found, and non-zero otherwise.

The *pb* parameter would be optional in both functions. A *Slapi\_PBlock* would be passed into into either of the functions when the check is being performed for an actual incoming operation. The parameter block would be used to check if the operation is a replicated operation, which would cause the syntax check to be skipped (essentially a no-op). The other thing that the parameter block would be used for is to have an error message set in the *SLAPI\_PB\_RESULT\_TEXT* parameter when an invalid syntax is detected. This message will say which attribute (and the index of the particular value) violated the syntax. This message would typically be sent back to the client so they know what needs to be corrected for the operation to succeed.

The *override* parameter allows the caller to force syntax checking to be performed regardless of how syntax checking is configured in *cn=config*. Setting this parameter to *1* will force syntax checking, while *0* will only check the syntax if *nsslapd-syntaxcheck* is enabled.

### Assertion value validation

Validation of assertion values will be much more difficult to implement than attribute syntax validation. The main reason for this difficulty is due to the way matching rule support is currently implemented in the Directory Server.

The plan is to NOT add assertion value validation at this time. We will add assertion value validation when we improve the matching rule support.

#### Schema issues

The current schema code does parse EQUALITY, SUBSTRING, and ORDERING matching rules in attribute definitions. Here is an example of an attribute definition with an EQUALITY and SUBSTRING matching rule specified:

    attributeTypes: (    
      1.3.6.1.4.1.15953.9.1.2    
      NAME 'sudoHost'    
      DESC 'Host(s) who may run sudo'    
      EQUALITY caseExactIA5Match    
      SUBSTR caseExactIA5SubstringsMatch    
      SYNTAX 1.3.6.1.4.1.1466.115.121.1.26    
      X-ORIGIN 'SUDO' )    

The matching rule strings that are listed in an attribute definition are parsed and stored in memory in a *struct asyntaxinfo* for each attribute:

    typedef struct asyntaxinfo {    
      ...    
      char                            *asi_mr_equality;       /* equality matching rule */    
      char                            *asi_mr_ordering;       /* ordering matching rule */    
      char                            *asi_mr_substring;      /* substring matching rule */    
      ...    
    } asyntaxinfo;    

The problems in this area are:

-   No validation is performed to see if a valid matching rule was specified.
-   The matching rules in *struct asyntaxinfo* are only used to print the schema out in LDIF format when searching *cn=schema*.

#### Plug-in issues

The Directory Server currently has support for matching rule plug-ins. Unfortunately, matching rule plug-ins are only used for extensible match search filters. This needs to be enhanced so that a plug-in can implement a matching rule that is used when an attribute is defined to use it in the schema.

### Supported Syntaxes

We only need to add validation for a portion of the syntaxes supported by Directory Server. There are some syntaxes that allow any 8-bit byte, which are the syntaxes we can skip validation for.

#### Validation Needed

Validation is needed for the following supported syntaxes:

-   Bit String
-   Boolean
-   Country String
-   Delivery Method
-   Directory String
-   DN
-   Enhanced Guide
-   Facsimile Telephone Number
-   Generalized Time
-   Guide
-   IA5 String
-   Integer
-   Name And Optional UID
-   Numeric String (support for this syntax to be added)
-   OID
-   Postal Address
-   Printable String
-   Telephone Number
-   Teletex Terminal Identifier
-   Telex Number

All of the above syntaxes should strictly adhere to the rules set in RFC 4517, with the exception of the *DN* syntax.

The *DN* syntax has become more restrictive over time, and the current rules are quite strict. Strict adherence to the rules defined in RFC 4514, section 3, would likely cause some pain to client applications. Things such as spaces between the RDN components are not allowed, yet many people use them still since they were allowed in the previous specification outlined in RFC 1779.

To deal with clients that do not follow the current standard, some configurability should be provided with regards to verification of the *DN* syntax. We should provide the ability for an administrator to allow clients to use the rules from RFC 1779. If the value meets the requirements of RFC 1779 or RFC 4517, we let the operation succeed and store the client provided value in the backend.

#### Validation Not Needed

Validation can be skipped for the following supported syntaxes since the contents are binary:

-   Fax
-   OctetString
-   JPEG

#### Non-Standard Syntaxes

The following are non-standard syntaxes that Directory Server has support for. Since there is not a standard for these syntaxes, there is no official description of what rules the value should follow. We should deprecate these syntaxes where possible.

-   Binary (still used by 20 or so attributes in our standard schema)
-   SpaceInsensitiveString (only used by presence plug-in attributes)
-   URI (not used in any of our standard schema)

The Binary syntax is still used by 20 or so attributes, including most of those related to x.509 digital certificates. We could use the OctetString syntax instead of Binary for these attributes, but we should be switching the certificate related attributes over to those defined in RFC 4523.

The SpaceInsensitiveString syntax is only used by the presence plug-in in our default schema. This plug-in does not get loaded by default, and should likely not be compiled unless asked for at configure time. We should disable this syntax by default in the plug-in config entry and remove it completely in a later version. We will need to make sure that the presence schema is not installed by default since it references this syntax.

The URI syntax is not used in any of our standard schema. We should disable this syntax by default in the plug-in config entry.

### Administration

#### Configuration

An administrator should have the capability to enable or disable syntax checking. It would be ideal for newly created instances to have syntax checking enabled by default, as it will prevent data that violates the standards from being added to the database. We do not want to have syntax checking automatically enabled after upgrading existing instances.

A new configuration attribute named *nsslapd-syntaxcheck* will be added to the *cn=config* entry. Valid values are *on* and *off*. If this attribute is missing, the server will default to a value of *off*. This will ensure that upgraded instances leave syntax checking off after the upgrade is complete. The *dse.ldif* template will need to be updated so this attribute is set to *on* for newly created instances.

An additional request has been made to have a warning mode, similar to the way that the SELinux permissive mode works. In warning mode, we would check the syntax, but we would never reject an operation with an invalid syntax error. When an invalid syntax issue occurs, we would log a message in the errors log stating the entry DN, attribute type, and index of the value that triggered the violation. It would be nice to be able to send a warning to the client, but this does not work well in practice. The server can send a message in the LDAPResult, but it looks as if most client applications will not output this message when a modify operation is successful.

To set the warning mode, an attribute named *nsslapd-syntaxlogging* would be added to the *cn-config* entry with a value of *on*. This setting would be off by default. This could be set in addition to *nsslapd-syntaxcheck*, which would result in the warning being logged as well as the operation being rejected.

To deal with the special circumstances around validation of the *DN* syntax, a configuration attribute should be provided named *nsslapd-dn-validate-strict*. This configuration attribute would ensure that the value strictly adheres to the rules defined in RFC 4514, section 3 if it is set to *on*. If it is set to *off*, the server will normalize the value before checking it for syntax violations. Our current normalization function was designed to handle DN values adhering to RFC 1779 or RFC 2253. The default value for this attribute should be *off*.

#### Auditing of Existing Data

Another useful thing would be to have a way to check your existing database to see if there are any syntax violations in there prior to turning syntax checking on. This could be accomplished by a task.

The task would have arguments for a search base and filter. Each matching entry would be checked to see if it's attribute values meet the syntax requirements. Any syntax violations would be output to the server errors log. The entry, attribute, and index of the value would be reported for each violation. This information could also be returned in the *nsTaskLog* attribute in the task entry as well as the errors log if it doesn't have any memory usage issues with large databases with lots of syntax violations.

A script should be added to help invoke the task from the command line without forcing the administrator to use ldapmodify directly. This script should be named *syntax-validate.pl* and the usage should be similar to the other task scripts, such as *fixup-memberof.pl*.

