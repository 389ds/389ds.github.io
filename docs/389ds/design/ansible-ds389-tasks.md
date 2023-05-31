---
title: "Ansible 389 DS Tasks"
---

# Ansible 389 DS Tasks Design
-----------------------

{% include toc.md %}

Description
-----------

These playbooks will allow us to use action plugins **ds389_XXX** for running different 389 DS tasks within the topology controlled by ds389_module.
For this cause, we'll use separate plugins for each tasks (i.e. ds389_memberof_fixup, ds389_cleanallruv, etc.).

Additionally, the tasks will help to manage ds389_module internals.
For example, it can help with the cases when the tasks are needed because the configuration has changed and we should keep the data in the correct state (i.e. running cleanallruv task after replication topology change).

**Note**: The ansible playbooks and role require a configured ansible environment where the ansible nodes are reachable and are properly set up to have an IP address and a working package manager.


Features
--------
- Run tasks in standalone playbooks or parts of the bigger roles;
- Run tasks internally within ds389_module when needed.


Arguments
---------
Each plugin will allow to specify 1+ arguments required by the task.

For example, ds389_fixup_memberof may include the next list of arguments:

### ds389_memberof_fixup_basedn
This attribute gives the base DN to use to search for the user entries to update the memberOf attribute.
```ds389_memberof_fixup_basedn``` argument is a required value.

### ds389_memberof_fixup_filter
This attribute gives an optional LDAP filter to use to select which user entries to update the memberOf attribute. Each member of a group has a corresponding user entry in the directory.
The ```ds389_memberof_fixup_filter``` argument is an optional value. If not specified, the default will be used: `(objectclass=*)`

The details of the options for each task's usage should be fully documented in the README.md in ansible_collections/ds389/ansible_ds/playbooks/roles/* that is delivered with the ds389.ansible collection.


Implementation Details
---------------------
The ActionModule code should be added to this directory in separate plugin files (i.e. ds389_cleanallruv):
https://github.com/389ds/ansible-ds/blob/main/ansible_collections/ds389/ansible_ds/plugins/action/

Each task should be a simple one-to-one implementation of 389 DS task entries. Because of this, it can be reused in ds389_module for performing different actions in a time of need.
Then, if needed, it can be expanded with a separate role or module (should we create **ds389_tasks** module that will include all of the plugins in a simple manner?)



Supported 389 DS Versions
--------------------------

389 DS versions 2.1 and up are supported by the backup role.


Supported Distributions
-----------------------

* RHEL/CentOS 9+
* Fedora 36+


Requirements
------------

**Controller**
* Ansible version: 2.9+

**Node**
* Supported 389 DS version (see above)
* Supported distribution (needed for package installation only, see above)


Usage
=====

Example playbook to run a cleanallruv on the 389 DS server:

```yaml
---
- name: Playbook to backup 389 DS server
  hosts: ldapservers

  tasks:
  - name: Run cleanallruv task
    ds389_cleanallruv:
      ds389_cleanallruv_replica_id: 55
      ds389_cleanallruv_replica_base_dn: dc=example,dc=com
      ds389_cleanallruv_replica_force_cleaning: no
```


Authors
=======

Simon Pichugin (@droideck)
