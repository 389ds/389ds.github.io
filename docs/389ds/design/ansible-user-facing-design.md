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
**389ds.ansible_ds**

Instance Topology Configuration
-------

The whole configuration will be done in Ansible Inventory. It's the core and the main source of truth for the whole topology.
The inventory will be managed by a single role - **389ds_server**. Only top-level variables will have the 'dsserver' prefix. The inventory will have a nested structure. The example can be found at the end of the document.
The detailed description will be posted on a separate page for **389ds_server** design.

Role Structure
------------------------------

- **389ds_server** - the role that will manage the Ansible Inventory. The whole configuration is presented in the Ansible Inventory Structure chapter;
- **389ds_info** - the role for collecting 389 DS instances;
- **[389ds_backup](ansible-backup-role.html)** - the role that allows to backup 389 DS instance, to copy a backup from the server to the controller, to copy all backups from the server to the controller, to remove a backup from the server, to remove all backups from the server, to restore a 389 DS server locally and from the controller and also to copy a backup from the controller to the server.

More task roles will be added later when they'll be developed (i.e. 389ds_memberof_fixup can be used for the MemberOf plugin Fixup task).

Please note that Monitoring and Logging should be managed via external tools. It's a general Ansible design approach which is already respected by other projects.
Additionally, in the future, we can work with Logging System Role to provide an integrated environment for the logging.

Ansible Inventory Structure Example
---------------------------

    all:
      children:
        dsconsumers:
          hosts:
            dsconsumer.test.local
          vars:
            dsserver_instances:
              - 
                instance: "myconsumer"
                rootpw: !vault |
                     $ANSIBLE_VAULT;1.1;AES256
                     ...
                port: 389
                secure_port: 636
                state: present
                # ... many other cn=config parameters
                backends:
                  -
                    backend_name: "userRoot"
                    state: present
                    # ... backend configuration parameters
                    agmts:
                      -
                        replicahost: "dssuppliers.test.local"
                        replicaport: "389"
                        state: present
                        # ... replication configuration
                    indexes:
                      -
                        indextype: "eq"
                        state: present
                        # ... index configuration
                      -
                        indextype: "pres"
                        state: present
                        # ... index configuration
                  -
                    backend_name: "redHat"
                    state: present
                    # ... backend configuration parameters
                    indexes:
                      indextype: "eq"
                      state: present
                      # ... index configuration
              - 
                instance: "localhost"
                rootpw: !vault |
                     $ANSIBLE_VAULT;1.1;AES256
                     ...
                port: 389
                state: present
                # ... many other cn=config parameters
                backends:
                  backend_name: "userRoot"
                  state: present
        dssuppliers:
          hosts:
            dssupplier.test.local
          vars:
            dsserver_instances:
              instance: "mysupplier"
              rootpw: !vault |
                   $ANSIBLE_VAULT;1.1;AES256
                   ...
              port: 389
              secure_port: 636
              state: present
              # ... many other cn=config parameters
              backends:
                backend_name: "userRoot"
                state: present
                # ... backend configuration parameters
                agmts:
                  -
                    replicahost: "dsconsumer.test.local"
                    replicaport: "389"
                    state: present
                    # ... replication configuration
                indexes:
                  -
                    indextype: "eq"
                    state: present
                    # ... index configuration
                  -
                    indextype: "pres"
                    state: present
                    # ... index configuration

