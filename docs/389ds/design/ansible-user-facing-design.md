---
title: "Ansible DS User Facing Design"
---

# Ansible DS User Facing Design

-----------------------

{% include toc.md %}

Collection naming
-------

We should carefully name the collection so it's well-aligned with other products and it's well discoverable in the Ansible world.

Suggested upstream names for the collection (up for discussion):
**ds389.ansible_ds**

Instance Topology Configuration
-------

The whole configuration will be done in Ansible Inventory. It's the core and the main source of truth for the whole topology.
An action plugin (with a module behind it) will consume the inventory and change/create the topology defined by it. The plugin name will be **ds389_server**. Only top-level variables will have the **ds389_server_** prefix. The inventory will have a nested structure. The example can be found at the end of the document.


Role Structure
------------------------------

- **[ds389_backup](ansible-backup-role.html)** - the role that allows to backup 389 DS instance, to copy a backup from the server to the controller, to copy all backups from the server to the controller, to remove a backup from the server, to remove all backups from the server, to restore a 389 DS server locally and from the controller and also to copy a backup from the controller to the server.

More task roles will be added later when they'll be developed (i.e. **ds389_memberof_fixup** can be used for the MemberOf plugin Fixup task). Its variable will be called with the role name prefix (i.e. **ds389_memberof_fixup_filter**).

Please note that Monitoring and Logging should be managed via external tools. It's a general Ansible design approach which is already respected by other projects.
Additionally, in the future, we can work with Logging System Role to provide an integrated environment for the logging.

## Plugin Structure

The detailed description for theses plugins and the design will be posted on a separate page: [ds389_module design](ansible-ds389-module.md).

- **ds389_server** - the action plugin that synchronize the Ansible Inventory with the 389ds instances.
- **ds389_info** - the fact plugin for collecting data about 389 DS instances;

Ansible Inventory Structure Example
---------------------------

```YAML
---
all:
  children:
    ldapservers:
      vars:
        ds389_server_instances:
          - name: localhost
            rootpw: "{{ vault_ds389_rootpw }}"
            backends:
              - name: userroot
                suffix: dc=example,dc=com
                # ancestors
                indexes:
                  - name: myattr
                    indextype:
                      - eq

      children:
        suppliers:
          vars:
            ds389_option_01:
              - name: localhost.userroot
                merge:
                  ReplicaRole: supplier
                  ReplicaPort: 636
                  ReplicaTransportInfo: SSL
                  ReplicaBindDN: cn=replication manager, cn=config
                  ReplicaCredentials: "{{ vault_ds389_replmanpw }}"
            ds389_agmts:
              - target: "{{ groups['consumers'] }}"
          hosts:
            ds389vm1:
              ds389_option_02:
                - name: localhost.userroot
                  merge:
                    ReplicaId: 1
                - name: ds389_agmts
                  append:
                    - target: ds389vm2

            ds389vm2:
              ds389_option_02:
                - name: localhost.userroot
                  merge:
                    ReplicaId: 2
                - name: ds389_agmts
                  append:
                    - target: ds389vm1
                      ReplicaIgnoreMissingChange: once

        consumers:
          vars:
            ds389_option_01:
              - name: localhost.userroot
                merge:
                  ReplicaRole: consumer
                  ReplicaPort: 636
                  ReplicaTransportInfo: SSL
                  ReplicationManagerDN: cn=replication manager, cn=config
                  ReplicationManagerPassword: "{{ vault_ds389_replmanpw }}"
          hosts:
            ds389vm3:
            ds389vm4:
```

Decrypted Vault inventory is:

```YAML
---
# This is the clear version of the vault file which should be
# - copied to inventory/testds389_vault.yaml
# - then encrypted by using:
#     ansible-vault encrypt --ask-vault-password --vault-id testds389_vault testds389_vault.yaml
all:
  children:
    ldapservers:
      vars:
        vault_ds389_rootpw: !unsafe rootdnpw00
        vault_ds389_replmanpw: !unsafe replmanpw00
```

Notes about this example:

- ds389_option_* are used to:
  - append a new item in a list (specified by its name)
  - merge a set of key/value in a hash (specified by its name)
    (Hash in ansible terminology is a dict in python)
    The merge/append operation are applied according to the lexicographic order of the
    ds389_option_*
    This mechanism solve the problem that ansible overwrite the dict/list when merging
    variables and it is more user friendly than the anchor/reference mechanism which
    is a bit cumbersome when used with hash as nested as it is in 389ds case.
  - ds389_agmts target refers either to hosts, instances or backend
