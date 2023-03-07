---
title: "ANSIBLE ds389_module Design"
---

## <span style="color: red;">UNSTABLE - WORK IN PROGRESS</span>

# ansible ds389_module Design

-------------------

{% include toc.md %}

# General considerations

------------------------

This module goals are:

- [1] Manage 389ds instances configuration. Including:
  - Manage state: present/absent/started/stopped
  - Manage the dse.ldif parameters
- [2] Gather fact about 389ds instances configuration:
  - Getting the existing instance
  - Getting the state started/stopped
  - Getting the dse.ldif parameters

# Parameters

------------

## Upper level parameters

| Name        | Optional | Kind                                       | Description                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| ----------- | -------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| State       | True     | Enum present/absent/update/started/stopped | Determine the state of the instances.<br/>- *present* may add instances/backends/index/agreements but does not remove them<br/>- *absent* remove any 389ds related resources listed in the *ds389*  parameter<br/>- *update* synchronize the parameter. It does remove configured resources that are not specified in the parameters<br/>- *started* Ensure that all instances are started<br/>- *stopped* Ensure that all parameters are stopped |
| ds389       | True     | Dict                                       | The instances parameters for [1]                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ds389info   | True     | Dict                                       | The prefix parameters                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ansiblevars | False    | Dict                                       | Some variable got from the ansible framework                                                                                                                                                                                                                                                                                                                                                                                                      |

# ## Nested level parameters

The details of the options should be fully documented in the ansible_collections/ds389/ansible_ds/playbooks/roles/ds389_server/README.md file that is delivered with the ds389.ansible collection (The list is quite long
 To ensure that the document is accurate, 
  this file will be generated dynamically from the module options table)

# ## ds389 parameters

# Plugins

## ds389_server action plugin

The role of this plugin is to gather the data from inventory and the plugin parameters and  

# Potential future developments

------------------------

- Getting the monitoring fact  
