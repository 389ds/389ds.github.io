---
title:  Automember Plugin Design
---

# Auto Membership Plugin Design
------------------------------
{% include toc.md %}


## Overview
-----------

When users or hosts are added to the Directory Server, the administrator then needs to put him into a particular groups. There are several options how this can be done. It can be left for every deployment to implement their own logic using CLI, however it is not viewed as the best approach.

Dealing with this use case calls for creation of a plug-in to automatically place users into user groups and hosts into hosts groups. It seems logical to make a generic auto membership plug-in that can work for all sorts of entries. This plug-in will inspect the entry being created and would automatically place it into some other objects as a member (or whatever attribute is needed).


## Configuration
----------------

The configuration of the Auto Membership plug-in allows one to configure multiple plug-in definitions to handle different grouping needs. Each definition will be expressed as a child entry beneath the **cn=Auto Membership Plugin,cn=plugins,cn=config** container. A plug-in definition entry needs to identify which member entries it needs to update membership for as well as targeting the group entries that it needs to update. It also needs to define how the group entries should be updated. A definition entry can point to multiple regex rule entries if one wants to use regular expressions to identify member entries.

### Definition Entry

#### Identifying Member Entries

To identify a member entry, a combination of a LDAP search criteria and regular expressions can be used.

**LDAP Search Criteria**

The LDAP search criteria will be specified by a combination of a scope suffix and a search filter. Both a scope and a filter must be specified, and the Auto Membership plug-in will not perform any operations if the entry being added does not meet the criteria (entry is within the scope suffix and matches the filter).

The scope is specified by the **autoMemberScope** attribute. This attribute contains a suffix that the member entry must exist within. This attribute must be present in a definition entry. The **autoMemberScope** attribute is single valued.

The filter is specified in the **autoMemberFilter** attribute. This attribute contains a LDAP search filter that the member entry must match. This attribute must be present in a definition entry. The **autoMemberFilter** attribute is single valued.

**Regular Expressions**

To deal with more complex use cases, one can additionally use regular expressions to identify member entries. The regular expressions are contained in regex rule configuration entries. These regex rule entries must be child entries of the definition entry to be loaded. These regex rule entries are described in detail below.

#### Targeting a default group

The group entries that should be updated when a member entry is added are specified by the regular expression rules. If a candidate entry meets the LDAP search criteria, but no inclusive regular expression rules are a match, one can specify default groups that the candidate entry should be added to. A default target group is specified in the **autoMemberDefaultGroup** attribute with the value being the DN of the target group. This attribute is multi-valued, so a candidate entry that does not match any of the inclusive regular expression rules will be added to all of the specified default groups. This attribute is optional, so no default groups need to be specified.

#### Defining group updates

The plug-in definition entry must specify how the target group entries should be updated. In particular, the grouping attribute and the value must be specified. Both of these are specified by the **autoMemberGroupingAttr** attribute. The value of this attribute is in the form **\<groupattr\>:\<memberattr\>**, where **\<groupattr\>** is the attribute that needs a new value added in the target group entry and **\<memberattr\>** is the attribute in the member entry whose value will be used as the value of **\<groupattr\>** in the target group. The **autoMemberGroupingAttr** attribute must be present and is single-valued. The grouping attribute and value specified by the **autoMemberGroupingAttr** attribute, which will be used for all defined target group entries.

<br>

### Regex Rule Entry

If regular expressions need to be used to identify member entries, one can create regex rule entries as child entries of the definition entry that they apply to. A regular expression will target a specified attribute. The regular expression will be evaluated for the values for the specified attribute. Multiple regular expressions can be specified for a single Auto Membership plug-in definition. Each regular expression will also target a particular group that a member entry should be added to if a match is found. Additionally, these regular expressions fall into two categories: exclusive and inclusive.

An exclusive regular expression rule tells the Auto Membership plug-in to not add a candidate entry to a specific target group if it matches. If an exclusive regular expression is a match, the Auto Membership plug-in will not add the candidate entry to the target group specified in the rule, even if an inclusive regular expression rule for the same group were to match. Exclusive regular expressions are evaluated before inclusive regular expressions. An exclusive regular expression rule is specified in the regex rule entry as the **autoMemberExclusiveRegex** attribute. The value is specified in the form **\<attr\>=\<regex\>**, where **\<attr\>** is the attribute whose values should be evaluated for a match, and **\<regex\>** is the regular expression that should be evaluated. The **autoMemberExclusiveRegex** attribute is multi-valued.

An inclusive regular expression will consider a match to indicate that a member entry was found and that Auto Membership operations needs to add the member entry to a specific target group. Inclusive regular expressions are evaluated after exclusive regular expressions. A candidate entry will not be added to a target group if an exclusive regular expression has already determined that the candidate should be excluded from that group, even if an inclusive regular expression for that same target group is a match. An inclusive regular expression is specified in the regex rule entry as the **autoMemberInclusiveRegex** attribute. The value is specified in the form **\<attr\>=\<regex\>**, where **\<attr\>** is the attribute whose values should be evaluated for a match, and **\<regex\>** is the regular expression that should be evaluated. The **autoMemberInclusiveRegex** attribute is multi-valued.

A regex rule entry also needs to define the target group that a matching entry should be added to. This target group is specified in the regex rule entry as the **autoMemberTargetGroup** attribute. The value is the DN of the target group. This attribute is single-valued, and must be specified in a regex rule entry.

<br>

### Example Configuration Entries

Here are some sample Auto Membership configuration entries to demonstrate how the plug-in can be configured.

#### Basic User Group

This example shows a basic configuration that adds newly created users to a catch-all group.

    dn: cn=All Users,cn=Auto Membership Plugin,cn=plugins,cn=config
    cn: All Users
    objectclass: top
    objectclass: autoMemberDefinition
    autoMemberScope: dc=example,dc=com
    autoMemberFilter: objectclass=posixAccount
    autoMemberDefaultGroup: cn=all,cn=groups,dc=example,dc=com
    autoMemberGroupingAttr: member:dn

#### Hostgroups

This example shows a complex configuration that adds newly created host entries to hostgroups based off of the hostname. Candidate entries that do not match any of the inclusive regular expression rules are added to a default group.

    dn: cn=Hostgroups,cn=Auto Membership Plugin,cn=plugins,cn=config
    objectclass: top
    objectclass: autoMemberDefinition
    cn: Hostgroups
    autoMemberScope: dc=example,dc=com
    autoMemberFilter: objectclass=ipaHost
    autoMemberDefaultGroup: cn=orphans,cn=hostgroups,dc=example,dc=com
    autoMemberGroupingAttr: member:dn

    dn: cn=webservers,cn=Hostgroups,cn=Auto Membership Plugin,cn=plugins,cn=config
    objectclass: top
    objectclass: autoMemberRegexRule
    description: Group placement for webservers
    cn: webservers
    autoMemberTargetGroup: cn=webservers,cn=hostgroups,dc=example,dc=com
    autoMemberInclusiveRegex: fqdn=^www[0-9]+\.example\.com
    autoMemberInclusiveRegex: fqdn=^web[0-9]+\.example\.com
    autoMemberExclusiveRegex: fqdn=^www13\.example\.com
    autoMemberExclusiveRegex: fqdn=^web13\.example\.com

    dn: cn=mailservers,cn=Hostgroups,cn=Auto Membership Plugin,cn=plugins,cn=config
    objectclass: top
    objectclass: autoMemberRegexRule
    description: Group placement for mailservers
    cn: mailservers
    autoMemberTargetGroup: cn=mailservers,cn=hostgroups,dc=example,dc=com
    autoMemberInclusiveRegex: fqdn=^mail[0-9]+\.example\.com
    autoMemberInclusiveRegex: fqdn=^smtp[0-9]+\.example\.com
    autoMemberExclusiveRegex: fqdn=^mail13\.example\.com
    autoMemberExclusiveRegex: fqdn=^smtp13\.example\.com

<br>

## Behavior
-----------

The plug-in will have to behave differently for each operation type. A description of what the plug-in does for each operation type is listed below.

### Add Operation

#### Pre-Op Callback

The plug-in will check if the new entry being added is a config entry. If so, the entry will be validated. If the config entry is invalid, an error will be logged and the add will be rejected.

#### Post-Op Callback

If the entry being added is a config entry, it will be activated.

When a new entry is successfully added that meets the scope and filter criteria of a config entry, the plug-in will determine what groups the new entry should be added to and attempt to update the groups appropriately.

If the modification to any of the group entries fails for any reason (value already exists, group doesn't exist, etc.), an error will be logged. The initial ADD operation will still go through since we are catching it at the post-op stage.

<br>

### Delete Operation

#### Post-Op Callback

The plug-in will check if the entry being deleted is an active config entry. If so, the auto membership feature will be deactivated for that config entry.

<br>

### Modify Operation

#### Pre-Op Callback

The plug-in will check if the entry being modified is a config entry. If so, it will be validated. If the config entry is invalid, an error will be logged and the change will be rejected.

#### Post-Op Callback

If the entry being modified is a config entry, the old config will be deactivated and the newly modified config will be activated. If the config entry is being disabled, the old config will simply be deactivated.

<br>

### Rename Operation

#### Post-Op Callback

The plug-in will check if the entry being renamed is an active config entry. If it is, and it is being moved outside of the auto membership config area, the config will be inactivated. If an entry is being moved into the managed entry config area, it will be validated and loaded as a config entry. 

