---
title: "Replication Monitoring With Ansible"
---

# Replication Monitoring With Ansible Design

{% include toc.md %}

## Document Version

0.1

## Revision History

| Version | Date       | Description of Change |
|---------|------------|-----------------------|
| 0.1     | 02-15-2024 | First MVP version     |

## Introduction

This document outlines the design and implementation of an Ansible-based solution for monitoring replication lag within a 389 Directory Server (DS) topology. It aims to automate the setup, data collection, analysis, and reporting of replication performance metrics.

## System Overview

The system is designed around Ansible's automation capabilities, utilizing roles, playbooks, and Molecule for testing. It targets environments with multiple 389 DS instances, gathers CSN, time, and event time from the specified access logs in the specified topology and generates plot data in CSV and PNG formats which is then placed on the controller node.

## Design Considerations

### Component Overview

Key components include:

- **Ansible Inventory (`inventory/inventory.yml`):** Specifies hosts and variables for the staging and production environment.
- **Roles (`Replication-Monitoring`):** Encapsulates tasks for data gathering, analysis, and reporting.
- **Playbooks (`monitor-replication.yml`, `cleanup-environment.yml`, etc.):** Provide role examples with different combinations of parameters and states.

## System Architecture

### Requirements

- Ansible, Python 3, and its matplotlib are installed on the control node.
- The 389 DS instances are accessible over the network, and the Ansible controller can connect to that securely.
- The specified log directories and their log files are readable.
- Docker is available for Molecule testing.

### Parameters

Parameter | Choices/Defaults | Comments
-------- | ----------- | --------
replication_monitoring_lag_threshold| Default: 10 | Value to determine the threshold for replication monitoring. A line will be drawn in the result plot using this value.
replication_monitoring_result_dir| Default: "/tmp" | Directory path where the results of replication monitoring will be stored.
replication_monitoring_log_dir| | Directory path on the host where log files for replication monitoring are stored.
replication_monitoring_tmp_path| Default: "/tmp" | Directory for temporary files required for the replication monitoring output generation.

### Inventory Example

```yaml
all:
  children:
    production:
      vars:
        replication_monitoring_lag_threshold: 20
        replication_monitoring_result_dir: '/tmp'
      hosts:
        ds389_instance_1:
          ansible_host: 192.168.2.101
          ansible_user: root
          replication_monitoring_log_dir: '/var/log/dirsrv/slapd-supplier1'
        ds389_instance_2:
          ansible_host: 192.168.2.102
          ansible_user: root
          replication_monitoring_log_dir: '/var/log/dirsrv/slapd-supplier2'

    staging:
      vars:
        replication_monitoring_lag_threshold: 20
        replication_monitoring_result_dir: '/tmp'
      hosts:
        ds389_instance_1:
          ansible_host: 192.168.3.101
          ansible_user: root
          replication_monitoring_log_dir: '/var/log/dirsrv/slapd-supplier1'
        ds389_instance_2:
          ansible_host: 192.168.3.102
          ansible_user: root
          replication_monitoring_log_dir: '/var/log/dirsrv/slapd-supplier2'
```

You need to configure SSH authentication to avoid plaintext usage.

### Playbooks Examples

A simple playbook example that gathers data from 389 DS servers and generates a report:

```yaml
- name: Create Replication Monitoring CSV and PNG graph
  hosts: staging

  vars:
    replication_monitoring_lag_threshold: 20
    replication_monitoring_result_dir: '/tmp'

  roles:
  - role: Replication-Monitoring
    state: present
```

Example playbook to run create a Replication monitoring report and clean up all temporary data afterwards:

```yaml
- name: Create Replication Monitoring CSV and PNG graph
  hosts: staging

  vars:
    replication_monitoring_lag_threshold: 20
    replication_monitoring_result_dir: '/tmp'
    replication_monitoring_cleanup: yes

  roles:
  - role: Replication-Monitoring
    state: present
```

Example playbook to clean up all temporary data:

```yaml
- name: Create Replication Monitoring CSV and PNG graph
  hosts: staging

  roles:
  - role: Replication-Monitoring
    state: absent
```

Example playbook to clean up all temporary data and the results from the results_dir:

```yaml
- name: Create Replication Monitoring CSV and PNG graph
  hosts: staging

  vars:
    replication_monitoring_result_dir: '/tmp'

  roles:
  - role: Replication-Monitoring
    state: absent
```

## Molecule Testing

The project is configured with Ansible Molecule for testing using Docker. To run tests:

1. Make sure you have Docker installed and configured.
1. Navigate to the root of the project.
2. Execute Molecule tests:
   ```molecule test```

The tests simulate a multi-instance DS environment, validating the role syntax, execution, and that output is present and not empty.


Authors
=======

Simon Pichugin (@droideck)