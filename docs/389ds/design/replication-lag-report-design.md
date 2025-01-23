---
title: "Replication Log Analyzer Tool"
---

# Directory Server Replication Lag Analyzer Tool

## Document Version

1.0

## Revision History

| Version | Date       | Description of Change |
|---------|------------|-----------------------|
| 1.0     | 2025-01-22 | Initial design document |

## Executive Summary

The Directory Server Replication Lag Analyzer Tool (name is subject to change) is designed to analyze replication performance in 389 Directory Server deployments. It processes access logs from multiple directory servers, calculates replication lag times, and generates comprehensive reports in various formats (CSV, HTML, PNG). The system focuses on three metrics:
1. Global Replication Lag: Time difference between the earliest and latest appearance of a CSN across all servers
2. Operation Duration: Time between operation start and completion
3. Hop-by-Hop Replication Lag: Time delays between individual server pairs in the replication topology

## Architecture Overview

The tool consists of three main parts: DSLogParser (handles log file reading and parsing), ReplicationLogAnalyzer (coordinates the analysis and generates reports), and VisualizationHelper (creates graphs and visualizations). These components work together to process logs and create useful reports about replication performance.

## Implementation Details

The tool works by tracking CSNs (Change Sequence Numbers) across different servers. For each CSN, we calculate:

#### Global Replication Lag
- For each CSN (Change Sequence Number):
  1. Gather timestamps of CSN appearances on all servers
  2. Global lag = latest_timestamp - earliest_timestamp

#### Operation Duration
- For each operation:
  1. Start timestamp = operation start time
  2. Completion timestamp = operation end time (the record with RESULT/ABANDON/DISCONNECT)
  3. Duration = completion_timestamp - start_timestamp

#### Hop Replication Lag
- For each CSN:
  1. Sort server appearances by timestamp
  2. Create consecutive server pairs (supplier → consumer):
    - Hop lag = consumer_timestamp - supplier_timestamp

### Input Parameters
- Administrators can control the analysis through several parameters in both 389 Directory server CLI and Replication monitoring Ansible playbook:
  1. Log Directories:
  List of paths to server log directories. Each directory represents one server in topology.

  2. Filtering Parameters:
  - `suffixes`: List of DN suffixes to analyze (required)
  - `time_range`: Optional start/end datetime range
  - `lag_time_lowest`: Minimum lag threshold
  - `etime_lowest`: Minimum operation execution time
  - `repl_lag_threshold`: Alert threshold for lag times

  3. Analysis Options:
  - `anonymous`: Hide server names (and entry/suffix details?)
  - `only_fully_replicated`: Show only changes reaching all servers
  - `only_not_replicated`: Show only incomplete replication
  - `utc_offset`: Timezone handling

### Output Parameters
- Reports:
  - CSV: Detailed event log with global and hop lags
  - HTML: Interactive visualization with Plotly
  - PNG: Static visualization with matplotlib
  - JSON: Summary statistics and analysis

1. HTML and CSV data:
    - Global Replication Lag Over Time
    - Operation Duration Over Time
    - Per-Hop Replication Lags

2. PNG Report:
    - Global Replication Lag
    - Operation Durations

3. Summary Statistics:
   - Global lag statistics (min/max/avg)
   - Hop lag statistics (min/max/avg)
   - Per-suffix update counts
   - Total updates processed
   - Server participation statistics

## Component Details

DSLogParser parses directory server access logs and extracts relevant replication events. The parser supports filtering by suffix and time range. The VisualizationHelper creates clear, informative graphs showing lag patterns over time. The ReplicationLogAnalyzer ties everything together, managing the analysis process from start to finish. 

## Data Flow

The process is straightforward: First, we read and parse the log files. Then we analyze the parsed data to calculate various lag metrics. Finally, we generate reports showing the results in different formats.

## Challenges and Mitigations

DSLogParser does batch processing of large log files to avoid memory issues (it's not too much but it allows to reduce memory complexity to O(n))
Also, it uses generators to handle large datasets efficiently.

We also make sure that all timestamps are consistently converted to UTC to ensure accurate comparison (and output is adjusted with utc_offset value which is the same format as in access logs).

And for visualization performance, we allow PNG reports to skip the hop-lag data to reduce complexity and improve rendering speed. Also, in PNG report, the administrator can see a static visualization of the global replication lag and operation durations. And if the amount of data is too large, we can sample only a part of it to improve performance of the HTML report.

## Authors

Simon Pichugin (@droideck)
