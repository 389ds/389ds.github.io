---
title: "Plugin Track Bind DN"
---

# Bind DN Tracking
----------------

Purpose
-------

To record/track the original bind DN that triggered the update. By default the server will record the DN that directly makes the update, but if the update comes from a plugin, we do not know what "user" triggered the plugin to make the update. Enabling this feature will write new operational attributes to the modified entry: internalModifiersname & internalCreatorsname. These new attributes contain the plugin DN, while modifiersname will be the original binding entry that triggered the update. The internalModifiersname & internalCreatorsname will always be a plugin DN. So if a DS plugin did not modify the entry, the value for internalModifersname & internalCreatorsname will the internal database plugin: "cn=ldbm database,cn=plugins,cn=config".

New Config Option (cn=config)

    nsslapd-plugin-binddn-tracking: on (default: off)

Example
-------

Delete a user as uid=group\_admin, and the RI plugin deletes that user from cn=my\_group

Feature not enabled:

    dn: cn=my_group,ou=groups,dc=example,dc=com    
    modifiersname: cn=referential integrity plugin,cn=plugins,cn=config    
    creatorsname: cn=directory manager    

Feature enabled:

    dn: cn=my_group,ou=groups,dc=example,dc=com    
    modifiersname: uid=group_admin,ou=people,dc=example,dc=com    
    creatorsname: cn=directory manager    
    internalModifiersname: cn=referential integrity plugin,cn=plugins,cn=config    
    internalCreatorsName: cn=ldbm database,cn=plugins,cn=config    

Example Two
-----------

Modify an entry (which is not updated by a plugin)

Feature not enabled:

    dn: cn=my_other_group,ou=groups,dc=example,dc=com    
    modifiersname: cn=directory manager    
    creatorsname: cn=directory manager    

Feature enabled:

    dn: cn=my_other_group,ou=groups,dc=example,dc=com    
    modifiersname: cn=directory manager    
    creatorsname: cn=directory manager    
    internalCreatorsname: cn=ldbm database,cn=plugins,cn=config    
    internalModfiersname: cn=ldbm database,cn=plugins,cn=config    


