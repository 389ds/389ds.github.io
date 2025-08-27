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
| 0.1     | 03-11-2024 | First MVP version     |

## Introduction

The ds389_repl_monitoring role is designed to monitor replication lag in 389 Directory Server instances. It gathers replication data from access log files, analyzes the data to identify replication lags, and generates visual representations of the replication lag over time.

## Design Considerations

- The role should be able to handle multiple 389 Directory Server instances.
- It should provide flexibility in specifying the log directory and result directory paths.
- The role should allow filtering the replication data based on various criteria, such as fully replicated changes, not replicated changes, lag time, and execution time.
- It should generate both CSV and PNG files for easy analysis and visualization of replication lag data.
- The role should be idempotent and handle cases where the replication lag files already exist.

## System Architecture

### Role Walkthrough

The ds389_repl_monitoring role consists of the following main task files:

1. setup.yml: Performs initial setup tasks such as ensuring connectivity to the hosts, installing necessary packages on the Ansible controller, and creating the log directory.

2. gather_data.yml: Finds all access log files in the specified directory on each 389 Directory Server instance, analyzes the logs using the ds389_log_parser module to extract replication data, and merges the data from all instances using the ds389_merge_logs module.

3. log_replication_lag.yml: Generates CSV and PNG files visualizing the replication lag data using the ds389_logs_plot module. The files are saved in a directory named with the current date and hour.

4. cleanup.yml: Removes temporary files created during the monitoring process on both the remote hosts and the Ansible controller.

### Custom Modules

The ds389_repl_monitoring role utilizes three custom Ansible modules:

1. ds389_log_parser: Parses 389 Directory Server access logs and calculates replication lags.
   - logfiles: List of paths to 389ds access log files (required).
   - anonymous: Replace log file names with generic identifiers (default: false).
   - output_file: Path to the output file where the results will be written (required).

2. ds389_logs_plot: Plots 389 Directory Server log data from a JSON file.
   - input: Path to the input JSON file containing the log data (required).
   - csv_output_path: Path where the CSV file should be generated (required).
   - png_output_path: Path where the plot image should be saved.
   - only_fully_replicated: Filter to show only changes replicated on all replicas (default: false).
   - only_not_replicated: Filter to show only changes not replicated on all replicas (default: false).
   - lag_time_lowest: Filter to show only changes with lag time greater than or equal to the specified value.
   - etime_lowest: Filter to show only changes with execution time (etime) greater than or equal to the specified value.
   - utc_offset: UTC offset in seconds for timezone adjustment.
   - repl_lag_threshold: Replication monitoring threshold value. A horizontal line will be drawn in the plot to represent this threshold.

3. ds389_merge_logs: Merges multiple JSON log files into a single file.
   - files: A list of paths to the JSON files to be merged (required).
   - output: The path to the output file where the merged JSON will be saved (required).


### Parameters

The role accepts the following parameters:

| Variable | Default | Description |
|----------|---------|-------------|
| ds389_repl_monitoring_lag_threshold | 10 | Threshold for replication lag monitoring (in seconds). A line will be drawn in the plot to indicate the threshold value. |
| ds389_repl_monitoring_result_dir | '/tmp' | Directory to store replication monitoring results. The generated CSV and PNG files will be saved in this directory. |
| ds389_repl_monitoring_only_fully_replicated | false | Filter to show only changes replicated on all replicas. If set to true, only changes that have been replicated to all replicas will be considered. |
| ds389_repl_monitoring_only_not_replicated | false | Filter to show only changes not replicated on all replicas. If set to true, only changes that have not been replicated to all replicas will be considered. |
| ds389_repl_monitoring_lag_time_lowest | 0 | Filter to show only changes with lag time greater than or equal to the specified value (in seconds). Changes with a lag time lower than this value will be excluded from the monitoring results. |
| ds389_repl_monitoring_etime_lowest | 0 | Filter to show only changes with execution time (etime) greater than or equal to the specified value (in seconds). Changes with an execution time lower than this value will be excluded from the monitoring results. |
| ds389_repl_monitoring_utc_offset | 0 | UTC offset in seconds for timezone adjustment. This value will be used to adjust the log timestamps to the desired timezone. |
| ds389_repl_monitoring_tmp_path | "/tmp" | Temporary directory path for storing intermediate files. This directory will be used to store temporary files generated during the monitoring process. |
| ds389_repl_monitoring_tmp_analysis_output_file_path | "{{ ds389_repl_monitoring_tmp_path }}/{{ inventory_hostname }}_analysis_output.json" | Path to the temporary analysis output file for each host. This file will contain the parsed replication data for each individual host. |
| ds389_repl_monitoring_tmp_merged_output_file_path | "{{ ds389_repl_monitoring_tmp_path }}/merged_output.json" | Path to the temporary merged output file. This file will contain the merged replication data from all hosts. |


## Inventory Example

```yaml
all:
  children:
    production:
      vars:
        ds389_repl_monitoring_lag_threshold: 20
        ds389_repl_monitoring_result_dir: '/var/log/ds389_repl_monitoring'
      hosts:
        ds389_instance_1:
          ansible_host: 192.168.2.101
          ds389_repl_monitoring_log_dir: '/var/log/dirsrv/slapd-supplier1'
        ds389_instance_2:  
          ansible_host: 192.168.2.102
          ds389_repl_monitoring_log_dir: '/var/log/dirsrv/slapd-supplier2'
```

## Playbook Examples

These examples demonstrate how ds389_repl_monitoring role can be customized using different variable settings to suit specific monitoring requirements. The role can be applied to different host groups, and the variables can be adjusted to filter the monitoring results based on various criteria such as fully replicated changes, minimum lag time, timezone offset, and minimum etime.

### Example 1: Monitoring with custom lag threshold and result directory

```yaml
- name: Monitor 389ds Replication with custom settings
  hosts: ds389_replicas
  roles:
    - role: ds389_repl_monitoring
      vars:
        ds389_repl_monitoring_lag_threshold: 30
        ds389_repl_monitoring_result_dir: '/var/log/ds389_monitoring'
```

In this example, the role is applied to the `ds389_replicas` host group. The `ds389_repl_monitoring_lag_threshold` is set to 30 seconds, meaning that replication lag line will be drawn across the PNG graph. The `ds389_repl_monitoring_result_dir` is set to `/var/log/ds389_monitoring`, specifying the directory where the CSV and PNG files will be stored.

### Example 2: Monitoring with filters for fully replicated and minimum lag time

```yaml
- name: Monitor 389ds Replication with filters
  hosts: ds389_servers
  roles:
    - role: ds389_repl_monitoring
      vars:
        ds389_repl_monitoring_only_fully_replicated: true
        ds389_repl_monitoring_lag_time_lowest: 5
```

This playbook applies the role to the `ds389_servers` host group. The `ds389_repl_monitoring_only_fully_replicated` variable is set to `true`, which means that only changes that have been fully replicated across all replicas will be considered. The `ds389_repl_monitoring_lag_time_lowest` is set to 5 seconds, so only changes with a lag time greater than or equal to 5 seconds will be included in the monitoring results. The results will be put in `/tmp` directory, which is default for `ds389_repl_monitoring_result_dir`.

### Example 3: Monitoring with timezone offset and minimum etime

```yaml
- name: Monitor 389ds Replication with timezone and etime filters
  hosts: directory_servers
  roles:
    - role: ds389_repl_monitoring
      vars:
        ds389_repl_monitoring_utc_offset: -21600
        ds389_repl_monitoring_etime_lowest: 1.5
```

In this example, the role is used to monitor the hosts in the `directory_servers` group. The `ds389_repl_monitoring_utc_offset` is set to -21600 seconds, which adjusts the log timestamps by -6 hours to match the desired timezone. The `ds389_repl_monitoring_etime_lowest` variable is set to 1.5 seconds, meaning that only changes with an etime greater than or equal to 1.5 seconds will be included in the monitoring output. The results will be put in `/tmp` directory, which is default for `ds389_repl_monitoring_result_dir`.

## Molecule Testing

The role includes a Molecule configuration for testing with Docker containers simulating 389ds replicas. The test sequence:

1. Builds multiple containers 
2. Copies mock access log files into each container
3. Runs the role against the containers
4. Verifies the role's functionality by:
    - Checking CSV and PNG files are generated correctly
    - Validating the content of the generated files
    - Ensuring proper packages are installed
    - Checking permissions on key directories

## Future Improvements

- Support for additional log formats and directory server versions.
- Support for sending metrics to monitoring systems
- Notifications on critical replication lag events
- Dashboard visualization of replication status


Authors
=======

Simon Pichugin (@droideck)