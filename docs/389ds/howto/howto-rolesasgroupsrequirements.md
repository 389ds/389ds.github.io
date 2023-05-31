---
title: "RolesAsGroupsRequirements"
---

# Roles as Groups
-----------------

{% include toc.md %}

### Introduction

It would be great if we can use roles as posix groups.

Of course, you can code your application to use roles, but there are really a lot of good applications, which where coded already (like padl nss\_ldap and pam\_ldap, or samba) which where coded using RFC2307/RFC2307bis as a reference and which are really not trivial to modify. Not to mention few applications that are close source and you cannot modify it at all...

Why using roles as groups would be useful? Because you can model complex permissions and even whole administration of you system using almost exclusively fds roles. For example:

Let's assume you have samba share, which should be accessed by many different people/groups in your enterprise. You are told to let all accountants access this share with read permission, allow finance manager read-write permission, but additionally - allow audit people read permission as well. You can attack problem in many ways, but let's try to do this using some kind of role-based management:

-   first you create roles like Accountants, Finance managers, and Auditors - and assign users to them
-   then you create so called capability roles, ie.: X\_ACL\_DataShare\_Read, and X\_ACL\_DataShare\_Write.
-   you nest Accountants, Finance managers and Auditors in to X\_ACL\_DataShare\_Read, and Finance managers into X\_ACL\_DataShare\_Write
-   you login to samba server, create directory datashare, and... well, you should be able to setup permissions based on group membership. It would be ideal if you have groups X\_ACL\_DataShare\_Read and X\_ACL\_DataShare\_Write available in linux system, and that you would be able to assign proper permissions to those groups (either using posix acl, or samba share definition, or with subdirectories and traditional unix permissions - as you like).

This design is very useful. It allows you very easily:

-   tell, who has read permission to datashare (just search ldap for nsRole=cn=X\_ACL\_DataShare\_Read...)
-   exactly tell, what Joe Doe is capable of doing in your system (just get his entry with nsRoles and look what's there; as long as you use consistent role naming - ie. using X\_ to mark capabilities roles in whole, and X\_ACL for acl roles - you rule :)
-   easily add exceptions - ie. when you are told to let CEO into datashare with read permissions immediately, you just create another role (I call it X\_ACL\_DataShare\_Read\_Singles) as managed role, assign CEO to it and nest it inside X\_ACL\_DataShare\_Read - voila!

Ok, I agree - this seems like a lot of work to just give somebody access to one samba share :) But what if you have 500 shares? On 100 servers? Or maybe you have dozens of datashare resources, but each consist of 4-5 different directories on different servers, but you need to manage it consistently, as whole?

To do this we need two elements:

-   some kind of link between roles and groups. I should work on server and return to client just plain group object with members - AFTER "unnesting" them.
-   tools to mange those roles... Without tools it could very easily slip out of control :)

Unnesting roles into groups? Possibilities
------------------------------------------

### really dynamic groups?

One idea is to use dynamic group. So for each role which should be available as flat, posix group, you define dynamic group. Ie.: X\_ACL\_DataShare\_Read\_Posix - or whatever :). Then you define memberurl as something like:

    <ldap:///dc=yourtree>??sub?(&(objectclass=person)(nsRole=cn=x\_acl\_datashare\_read,dc=yourtree))

The whole idea would be to write plugin, which would do this search in behalf of client and return results as nice collection of member attributes (uniq members of course :).

Pros:

-   I'm not very good programmer, but it seems this would be relatively easily done using slapi plugin
-   this kind of plugin could have it's uses in other situations - ie.: generating mailing list members in mailing list entry (this is example from openldap.org dynlist plugin)

Cons:

-   probably performance. Each time nss\_ldap try go ten group members server needs to perform query on behalf of client. This could kill server - it strongly depends on hardware configuration, and load of the server

### extend roles?

Another idea is to modify roles plugin so it allows you to query for role members using member attribute of role itself.

Pros:

-   probably performance - roles keeps some kind of cache of its members (that's what I think they do :)

Cons:

-   many changes to the code? Possible schema clashes (posixGroup is structural - and you need to add more info about group than just its members - ie.: gid)?

### do it in application?

You can write your own gui (ie.: web app), which will do the changes as they occur. You could then just use posix groups. Idea itself is quite simple:

-   you use some two additional attributes for group membership - let's call them myMember, and myNestedGroupMember, both multivalued (you could use one, but... :)
-   when you assign members to the group via your app, it's add them to myMember
-   when you assign (nest) a group into other group, your app adds this group to myNestedGroupMember
-   and then it just traverse all entries which where modified and updates member attributed based on myMember and myNestedGroupMemeber - and of course it do that recursively

After that you have just flat, static groups, but updated to reflect changes and nesting you did.

Pros:

-   well, all apps working :)
-   speed! You change groups rather rarely, and even when you have a lot of groups - you have to wait just once, during your work with gui. And even that could be improved - you don't update groups always, but once per 5 minutes, or on demand

Cons:

-   software to write - but you have to do that this or that way. No free tools for role-based management, even on m\$ platform, sorry! :)
-   integrity - what if your application crashes in the middle of it's work? At best - you have inconsistent db for few minutes which it takes to run tool to rebuild groups (you have written that tool, right? :). At worse - you are in the middle of chaos ;)
-   what if somebody changes directory passing your application? This could be either user using ldapmod tool, or daemon, like samba, writing it's own group membership information. And again - you have some race conditions in this situation
-   acls in directory! You either code your application to use Directory Manager-like credential - and add yourself a LOT of work, because your app needs now do all access control - or you use directory acl, but then you have to add permission for everybody to modify any group membership out there! It could easily lead to complicated security issues... Alternatively - you code some kind of proxy, so users are using their own credentials and are subject of thight acls, but when they change group membership you launch some kind of background process to update groups.

### use nss\_ldap nested groups? or generally - client side processing

Yes, nss\_ldap should support nested groups. But at least where I tested it (Ubuntu 8.04) this function was disabled - or I just don't know how to use it :(

Pros:

-   just works

Cons:

-   you cannot use nested groups in acls in directory
-   you are completely out of tools to manage it! When you use roles then at least there is console - at least for me it's quite important. Using only ldaptools (ldapsearch, ldapadd) and ldif files - well yes, you can do your job, but it takes forever...
-   what about other applications? Ie.: Samba, or Request-tracker (ldap auth), or Apache (I think here, especially in 2.2 problem is non-existent), or Proftpd, or - well, you name it!
-   what about your scripts? Ie.: using roles it's trivial to prepare your own scripts for particular user - just check his nsRole attribute. But with nested groups and without support on server side you have write a lot more than that!

### something else?

well? :)

isn't that idea evil? ;)
------------------------

Well yes :) I've got it from one of the windows administration books. Why? Well, what I'm trying to do is to develop kind of Active Directory system without Active Directory :) I know it seems to be crazy, but when you have money issues, it's where creativity starts to count :)

But idea itself - role-based management - seems very appealing, not only for Microsoft based networks, but for linux management too. There are just few tools missing :)

other uses of roles, or acl?
----------------------------

Of course there are other uses :)

### installing applications

Ie.:I write scripts for now is software management on windows machines. Just use great tool for this, [wpkg](wpkg.org "wikilink"), few scripts, and directory. For example let's assume you are going to install openoffice.org on all computers in Accounting department, so:

-   define capability role: X\_APP\_Openoffice.org\_Win32
-   create role Accounting
-   for each computer create USER account - just add \$ at the end, ie.: pc01\$ (samba will do that for you for each computer which joined domain; if you have unix machines - you can use the same trick, just remember about disabling account - /bin/false etc. - this way you have consistent enumeration of you computers; other trick is to add L or D in as first letter of username - L is for laptop, and D for desktop, so you can easily create filtered role and distinguish between those to types)
-   add created pc01\$ do Accounting group
-   nest Accounting group into X\_APP\_Openoffice.org\_Win32
-   write script, which will find all computers in you directory (or only subset - it's up to you) and then extract nsRole attribute from it. And for each role, whose RDN attribute value has X\_APP in the front, and \_Win32 at the end, extract middle part, and generate proper profiles.xml and hosts.xml.
-   next time system will boot it will install/uninstall application according to your role membership changes in directory!

What is cool about this is that you can with ease delegate permissions to manage applications on computers - proper acl and directory manage this for you!

IF we would be able to get all member of particular role (including all nesting) as posix group - we could take this further. Ie.: because in Accounting group you have not only computers, but normal users as well, and it's nested in X\_APP\_Openoffice.org\_Win32, then if you assign permissions to X\_APP\_Openoffice.org\_Win32 group to read openoffice.org installs (possible with another nesting), then all accountants read have access to openoffice installs, and could do it themselves. Why to do that? Openoffice isn't good example, but if you have some accounting application, which need a lot customization during install, who only accountant now how to do - then it have more sense. You could also create another roles for people, who prepare packages for wpkg - and give then rw access to directories with those packages only... Well - possibilities are countless :)

### monitoring

Ok, next script could generate nagios configuration for you based on directory and roles configuration. You have computers as user accounts in directory, so:

-   create group HOSTS\_WindowsXp and HOSTS\_Linux
-   add proper hosts to those groups
-   create capability groups: X\_MON\_Cpu use\_Win32, X\_MON\_Cpu use\_Linux etc.
-   nest HOST\_\* groups in proper X\_MON groups. Now all hosts have nsRole defined.
-   get all hosts from your directory, and check nsRole. Get only roles whose name starts with X\_MON, extract middle part and use it as key in your script - ie.: Cpu use would be signal to copy proper service definition from you config repository and setting up proper host declaration

### unix management

Well - use [puppet](http://reductivelabs.com/trac/puppet) to manage your unix boxes :) And then the same idea again - capability role is X\_PUPPET\_SomePuppetClass and then you nest roles with hosts into it. Ie.: X\_PUPPET\_MonitoringServer. And use external\_nodes in puppet to extract classes directly form host entry in ldap, using nsRole.

conclusion
----------

Well, conclusion is: in my opinion roles (esp. nested roles) are really great feature, and would be even greater, if could be used as posixGroup.
