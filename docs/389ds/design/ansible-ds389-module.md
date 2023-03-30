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
  - Getting the dse.ldif parameters |

# Parameters

------------

## Upper level parameters

| Name      | Optional | Kind | Description                                         |
| --------- | -------- | ---- | --------------------------------------------------- |
| ds389     | True     | Dict | The instances parameters for [1] (Manage instances) |
| ds389info | True     | Dict | The prefix parameters for [2] (Gather facts)        |

## Parameters in ds389

They are the first level parameters of the ds389_server action plugin :  

| Plugin Name        | Optional | Kind              | Description                                                                                                                                         |
| ------------------ | -------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| State              | True     | String<br/>(Enum) | Determine the state of the instances                                                                                                                |
| ds389_instances    | False    | List of dict      | The instance configuration                                                                                                                          |
| ds389_agmts        | True     | List of dict      | Data about replication agreement targets                                                                                                            |
| ds389_option_*     | True     | List of dict      | Data used to merge/append value in parameters (Because Ansible overide dicts and lists instead of merging them)                                     |
| ds389_prefix       | True     | String            | Path of ds389 install prefix                                                                                                                        |
| ansible_host       | False    | String            | The remote host currently handled by the playbook. Used locally by the plugin to generate the ds389 parameters sent to the module from the host map |
| ansible_verbosity  | False    | Integer           | number of v when running ansible-playbook -vvv playbook.yml. Used  locally by the plugin and also sent to the module                                |
| ansible_check_mode | False    | Boolean           | When true the action plugin should not change the state but only reports what it would change.                                                      |

### ansible_verbosity

| verbosity | logs                                                                     |
| --------- | ------------------------------------------------------------------------ |
| 0         | None                                                                     |
| 1         | module_args, plugin_args, WARNING python logs                            |
| 2         |                                                                          |
| 3         | action plugin hosts data, INFO python logs                               |
| 4         | action plugin backends, DEBUG python logs                                |
| 5         | Inventory,"variable" (i.e names that can be used as ds389_option_* name) |

### state

| State   | Action                                                                               |
| ------- | ------------------------------------------------------------------------------------ |
| present | Update 389ds configuration without deleting resources that are not listed.           |
| absent  | Delete all specified instances                                                       |
| updated | Synchronize 389ds configuration. Beware:  Resources that are not listed are deleted. |
| started | Ensure that all listed instances are started                                         |
| stopped | Ensure that all listed instances are stopped                                         |

### ds389_instances

The details of the options should be fully documented in the ansible_collections/ds389/ansible_ds/playbooks/roles/ds389_server/README.md file that is delivered with the ds389.ansible collection (The list is quite long
 To ensure that the document is accurate, 
this file will be generated dynamically from the module options table)

#### ds389_agmts

Each dict in the list have the following format:

| Field  | Optional | Description                                                                             | Action                                                                                                                                                      |
| ------ | -------- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name   | True     | Mostly used when the dict needs to be a target for a ds389_option_* merge               | ignored                                                                                                                                                     |
| target | False    | a string used to determine what are the target replicas <br/>or a list of such strings. | target are resolved and for each replicas a ds389.agmts dict is added containing this dict attributes (except the target) and the target backend attributes |
| *      | True     | Other standard 389ds agreement values. (Typically those related to the supplier side)   | kept as is                                                                                                                                                  |

Note: it is still possible to describe agreements as children of the backend. 
That can be useful to target a replica that is not managed by ansible

### ds389_option_*

Each dict in the list have one of the following formats:

| Field | Optional | Type   | Description                                                       | Action                            |
| ----- | -------- | ------ | ----------------------------------------------------------------- | --------------------------------- |
| name  | False    | String | A space separated list used to determine the targetted dict(s)    | Handled locally within the plugin |
| merge | False    | Dict   | Contains the dict of attribute to mege with the targetted dict(s) |                                   |

or 

| Field  | Optional | Type   | Description                                                    | Action                            |
| ------ | -------- | ------ | -------------------------------------------------------------- | --------------------------------- |
| name   | False    | String | A space separated list used to determine the targetted list(s) | Handled locally within the plugin |
| append | False    | List   | Append the list items to  the targetted list(s)                |                                   |

 Nested dict are referred by using a dot notation:
   The first item is either an instance name or a agmt name
   The second item is the backend name
   The third item is either an index name or agmt (the backend children one) name 
    In the append case, the last item is a parameter name which expect a list

 and * may be used to match all items (i.e) localhost.*.myattr will refers to myattr index of all backends of localhost instance

## Result

The module result in stdout is a dict in json format. Its keys are:

### Standard keys

List of implemented [Standard ansible return keys](https://docs.ansible.com/ansible/latest/reference_appendices/common_return_values.html):

| Key           | Notes                                                                                           |
| ------------- | ----------------------------------------------------------------------------------------------- |
| ansible_facts | Result for [2] (Gather fact)                                                                    |
| changed       |                                                                                                 |
| exception     | only in case of failure                                                                         |
| failed        | only in case of failure                                                                         |
| invocation    | Parameters as the module received them                                                          |
| msg           | Some additionnal messages like the changes that have been or should be done or an error message |
| stderr        | only in error cases                                                                             |

### Specific keys

| Key              | Value       | Description                                  | Origin       |
| ---------------- | ----------- | -------------------------------------------- | ------------ |
| cooked_message   | dict        | Parameters once the module processed them    | The module   |
| original_message | dict        | Parameters as the module received them       | The module   |
| debug            | list of str | Python log output (depends on the verbosity) | The module   |
| module_args      | dict        | Parameters sent by the plugin to the module  | Both plugins |

---

# Plugins

## ds389_server action plugin

The role of this plugin is to gather the data from inventory and generate the module parameters.

### Collected data from the plugin args

| args name              | Description                                                          | Handling                          |
| ---------------------- | -------------------------------------------------------------------- | --------------------------------- |
| state                  | The optional state                                                   | Sent to the module as ds389.state |
| Common data processing | Any ds389_* variable provided as argument overide the inventory ones | Common data processing            |

### Collected data from task_vars

| task_vars name     | Description                                                  | Handling                                                                                                                                          |
| ------------------ | ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| ansible_host       | The remote host currently handled by the playbook.           | Used locally by the plugin to generate the ds389 parameters sent to the module from the host map                                                  |
| ansible_verbosity  | number of v when running ansible-playbook -vvv playbook.yml. | Used  locally by the plugin and also sent to the module as ds389.ansible_vars.ansible_verbosity                                                   |
| ansible_version    | ansible version                                              | Not used (may be usefull later on to clear some cached data)                                                                                      |
| ansible_user_uid   | The remote user uid                                          | Not used (may be usefull later on to check it is 0 if there is no prefix)                                                                         |
| ansible_check_mode | Tells when the action can change                             | Sent to the module in ds389.ansible_vars.ansible_check_mode                                                                                       |
| hostvars           | dict of hosts dict                                           | Common data processing is applied on every hosts to collect the backends data from the hosts because  are needed to compute the agreements data.) |

ansible_verbosity levels: 

| Verbosity | Debug data returned                                                                                                                                |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0         | None except the error messages                                                                                                                     |
| 1         | Plugin calling parameters<br/>Module calling parameters.<br/>Note: only "safe" values that does not contains data extracted from vault are logged. |
| 2         | Module "INFO" traces                                                                                                                               |
| 3         | Module "DEBUG" traces                                                                                                                              |

### Common data processing

The following data are collected from each hosts in task_vars.hostsvars to generate a map of host --> backend list that will be used for agmts target resolution 

| task_vars name | Description                                                  | Handling                                                                 |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------ |
| :              | 389ds instances list for current remote host                 | Stored  in ds389.instances                                               |
| ds389_agmts    | 389ds agreements list for current remote host                | Stored in ds389.agmts after the target resolution                        |
| ds389_prefix   | 389ds install prefix for current remote host                 | Stored in ds389.prefix                                                   |
| ds389_option_* | Option modifier to append item in list or merge item in dict | Processed locally to update the matching variable for the processed host |

The processing for a given host extracted from the hostsvars list

- walk the variables and check if they matches the wanted variable. i

- if that is the case:

- store the variable in the: per name map, per entity+parentname 

- Detect if it is an unsafe value (that include jinja2 expression with vault_ variable)

- Evaluate jinja2 expr 

### Topology global validation

As the module only reveives the data related the current host, validation tests about the global topology must be done at the plugin level. And while doing these tests some other consistency test are also done at the plugin level.
Typically:

- Checking that for a given suffix, supplier's Replica ID are uniques among all hosts
- Checking that supplier and only suppliers have a replica ID
- Checking that only supplier and hub have agreements

--------------

# ds389_info action plugin

The role of this plugin is to call the modules to generate facts from the the hosts dse.ldif configurations files

## Parameters in ds389info

They are the first level parameters of the ds389_server action plugin :

| Plugin Name        | Optional | Kind    | Description                                                                                                          |
| ------------------ | -------- | ------- | -------------------------------------------------------------------------------------------------------------------- |
| ds389_prefix       | True     | String  | Path of ds389 install prefix                                                                                         |
| ansible_verbosity  | False    | Integer | number of v when running ansible-playbook -vvv playbook.yml. Used  locally by the plugin and also sent to the module |
| ansible_check_mode | False    | Boolean | When true the action plugin should not change the state but only reports what it would change.                       |

# Potential future developments

------------------------

- Getting the monitoring facts (unsure as using dsconf may be easier)
- Handling tasks (unsure as using dsctl/dsconf may be easier) 
