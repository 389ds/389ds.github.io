---
title: "MemberOf Multiple Grouping Enhancements"
---

# MemberOf Multiple Grouping Enhancements
-----------------------------------------

{% include toc.md %}

Overview
--------

The idea is to allow multiple grouping attributes to be configured to automatically maintain a single memberOf attribute. In the following example, the **member** and **uniqueMember** attributes are configured as grouping attributes, both of which will trigger the **memberOf** attribute to be maintained:

    dn: cn=usergroup,dc=example
    member: cn=user1,dc=example

    dn: cn=othergroup,dc=example
    uniqueMember: cn=user2,dc=example

    dn: cn=user1,dc=example
    memberOf: cn=usergroup,dc=example

    dn: cn=user2,dc=example
    memberOf: cn=othergroup,dc=example

Corner Cases
------------

The previous example is very straightforward, but there are some other cases that may seem a bit odd, so client applications will need to expect them. One of these odd cases is where a group entry refers to the same member entry by more than one grouping attribute. Consider the following example:

    dn: cn=group,dc=example
    member: cn=user,dc=example
    memberPerson: cn=user,dc=example

    dn: cn=user,dc=example
    memberOf: cn=group,dc=example

In the above example, the client needs to understand that it can't tell what type of grouping attribute was used to cause an entry to belong to a group by simply looking at the member entry. The member entry also provides no indication of being a member of a group entry in multiple ways (by the use of multiple grouping attributes). This example may not be a common or useful case, but it is something that could happen if the objectClasses on a group entry allow more than one of the configured group attributes.

Plug-In Configuration
---------------------

It is preferred to keep the plug-in configuration backwards compatible to prevent breaking existing deployments during upgrade. This is easily done by simply allowing the **memberOfGroupAttr** attribute to have multiple values. Here is an example:

    dn: cn=MemberOf Plugin,cn=plugins,cn=config
    ...
    memberofgroupattr: member
    memberofgroupattr: uniqueMember
    memberofattr: memberOf

It is important to note that an attribute used as a **memberOfGroupAttr** must be defined with either the **Distinguished Name** or **Name and Optional UID** syntaxes. An attempt to use an attribute defined with any other syntax will be rejected.

Plug-In Changes
---------------

The memberOf plug-in needs to have a number of changes to support multiple grouping attributes. These changes are listed below:

-   Change the config struct to hold a list of grouping attributes instead of a single attribute.
-   Make the config parsing/validation code load multiple grouping attributes.
-   Make the config copy and free functions handle duplicating and freeing the list of grouping attributes.
-   Build a group check filter that uses all configured grouping attributes, such as **(|(member=\*)(uniqueMember=\*))**.
-   Detect duplicate member values when a group entry is added or modified to add new members. The duplicates can be ignored to prevent attempting to add the memberOf value to the same member entry twice.
-   Detect duplicate member values when a group entry is renamed. The duplicates can be ignored to prevent attempting to replace the memberOf value with the new group name in the same member entry twice.
-   When a member is removed from a group, check if they are listed as a member in another configured grouping attribute in the same group entry. We don't want to delete the memberOf attribute unless none of the grouping attributes are present.

Some of these cases may be dealt with by the current logic since we already handle cases such as an entry being a member of a group through multiple paths (this can occur from nested membership). We should check if the existing logic is sufficient before writing new code for these cases.

