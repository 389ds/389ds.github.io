---
title: "Replication Monitoring With Ansible"
---

# Replication Monitoring With Ansible Design

{% include toc.md %}

## Document Version

0.2

## Revision History

| Version | Date       | Description of Change |
|---------|------------|-----------------------|
| 0.1     | 03-11-2024 | First MVP version     |
| 0.2     | 2026-03-23 | Aligned terminology with Replication Log Analyzer design, added hop lag details, clarified output formats |

## Related Documents

- [Replication Log Analyzer Tool](replication-lag-report-design.md): Detailed design for the underlying analysis engine (`ReplicationLogAnalyzer`), CLI interface (`dsconf replication lag-report`), and Cockpit WebUI integration. The Ansible role and the CLI/WebUI tool share the same core analysis concepts (CSN-based lag calculation, global and hop-by-hop metrics) but use different delivery mechanisms.

## Introduction

The ds389_repl_monitoring role is designed to monitor replication lag in 389 Directory Server instances. It gathers replication data from access log files, analyzes the data to identify replication lags, and generates visual representations of the replication lag over time.

The role computes two types of replication lag metrics:
1. **Global Replication Lag**: Time difference between the earliest and latest appearance of a CSN (Change Sequence Number) across all servers — measures end-to-end replication delay
2. **Hop-by-Hop Replication Lag**: Time delays between individual consecutive server pairs in the replication topology — identifies specific bottleneck links

## Design Considerations

- The role should be able to handle multiple 389 Directory Server instances.
- It should provide flexibility in specifying the log directory and result directory paths.
- The role should allow filtering the replication data based on various criteria, such as fully replicated changes, not replicated changes, lag time, and execution time.
- It should generate CSV and PNG files for easy analysis and visualization of replication lag data. JSON intermediate data is used internally for cross-host merging.
- The role should be idempotent and handle cases where the replication lag files already exist.

## System Architecture

### Role Walkthrough

The ds389_repl_monitoring role consists of the following main task files:

1. setup.yml: Performs initial setup tasks such as ensuring connectivity to the hosts, installing necessary packages on the Ansible controller, and creating the log directory.

2. gather_data.yml: Finds all access log files in the specified directory on each 389 Directory Server instance, parses the logs using the ds389_log_parser module to extract CSN-based replication events, and merges the per-host JSON data from all instances using the ds389_merge_logs module into a single dataset for cross-server lag analysis.

3. log_replication_lag.yml: Processes the merged JSON data through the ds389_logs_plot module to calculate global and hop-by-hop replication lag metrics, then generates CSV and PNG output files. The CSV contains detailed per-CSN lag data; the PNG contains time-series visualizations of replication lag with optional threshold lines. The files are saved in a directory named with the current date and hour.

4. cleanup.yml: Removes temporary files created during the monitoring process on both the remote hosts and the Ansible controller.

### Custom Modules

The ds389_repl_monitoring role utilizes three custom Ansible modules:

1. ds389_log_parser: Parses 389 Directory Server access logs and extracts CSN-based replication data. For each CSN found in the logs, the module records timestamps, server names, target DNs, suffixes, and operation execution times. The output is a JSON file containing per-CSN data keyed by server index.
   - logfiles: List of paths to 389ds access log files (required).
   - anonymous: Replace log file names with generic identifiers (default: false).
   - output_file: Path to the output JSON file where the results will be written (required).

2. ds389_logs_plot: Processes merged JSON log data to calculate global and hop-by-hop replication lag metrics, then generates visualizations. The module computes global lag (latest - earliest CSN appearance across all servers) and hop lag (delay between consecutive server pairs sorted by arrival time) for each CSN.
   - input: Path to the input JSON file containing the merged log data (required).
   - csv_output_path: Path where the CSV file should be generated (required).
   - png_output_path: Path where the plot image should be saved.
   - only_fully_replicated: Filter to show only changes replicated on all replicas (default: false).
   - only_not_replicated: Filter to show only changes not replicated on all replicas (default: false).
   - lag_time_lowest: Filter to show only changes with global lag time greater than or equal to the specified value (in seconds).
   - etime_lowest: Filter to show only changes with execution time (etime) greater than or equal to the specified value (in seconds).
   - utc_offset: UTC offset in seconds for timezone adjustment.
   - repl_lag_threshold: Replication monitoring threshold value (in seconds). A horizontal line will be drawn in the plot to represent this threshold.

3. ds389_merge_logs: Merges multiple per-host JSON log files into a single file. This step is necessary because each host produces its own JSON output from ds389_log_parser — merging combines CSN data from all hosts so that cross-server lag can be calculated.
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

## Relationship to CLI/WebUI Tool

The Ansible role and the `dsconf replication lag-report` CLI tool (with its Cockpit WebUI) solve the same core problem — replication lag analysis — but for different operational contexts:

| Aspect | Ansible Role | CLI/WebUI Tool |
|--------|-------------|----------------|
| **Use case** | Automated, scheduled monitoring across fleets | Ad-hoc investigation or WebUI-driven analysis |
| **Log collection** | Ansible gathers logs from remote hosts | User provides local log directories |
| **Data merging** | Explicit merge step across hosts | Analyzer processes all directories in one pass |
| **Output formats** | CSV, PNG | CSV, PNG, HTML (Plotly), JSON (PatternFly charts) |
| **Precision controls** | Not applicable (processes all data) | Configurable sampling (`fast`/`balanced`/`full`) |
| **Drill-down** | Not available | CSN detail drill-down in WebUI charts |

Both approaches calculate the same metrics (global lag, hop-by-hop lag) using the same underlying algorithms. See [Replication Log Analyzer Tool](replication-lag-report-design.md) for the full technical specification.

## Future Improvements

- Support for additional log formats and directory server versions
- Support for sending metrics to monitoring systems (Prometheus, Grafana)
- Notifications on critical replication lag events (email, webhook)
- HTML report generation (leveraging Plotly, consistent with the CLI tool's HTML output)
- JSON summary output with aggregate statistics (min/max/avg lag, per-suffix breakdowns)
- Configurable sampling/precision for large-scale deployments
- Integration with the `dsconf replication lag-report` CLI for unified report format


Authors
=======

Simon Pichugin (@droideck)