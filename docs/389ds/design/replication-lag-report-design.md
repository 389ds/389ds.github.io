---
title: "Replication Log Analyzer Tool"
---

# Directory Server Replication Lag Analyzer Tool

## Document Version

1.0

## Revision History

| Version | Date       | Description of Change |
|---------|------------|-----------------------|
| 1.0     | 2025-10-26 | Initial design document |

## Executive Summary

The Directory Server Replication Lag Analyzer Tool is designed to analyze replication performance in 389 Directory Server deployments. It processes access logs from multiple directory servers, calculates replication lag times, and generates comprehensive reports in various formats (Charts, CSV, and only for Fedora - HTML, PNG). The system is available both as a command-line tool and through an web-based interface in the 389 DS Cockpit WebUI.

The tool focuses on two key metrics:
1. Global Replication Lag: Time difference between the earliest and latest appearance of a CSN across all servers
2. Hop-by-Hop Replication Lag: Time delays between individual server pairs in the replication topology


## Architecture Overview

The system consists of three main components:
1. `DSLogParser`: Parses directory server access logs
2. `ReplicationLogAnalyzer`: Coordinates log analysis and report generation
3. `VisualizationHelper`: Handles data visualization and report formatting

## Replication Lag Calculation Technical Details

### Global Replication Lag
- For each CSN (Change Sequence Number):
  1. Track timestamp of first appearance across all servers
  2. Track timestamp of last appearance across all servers
  3. Global lag = latest_timestamp - earliest_timestamp

### Hop Replication Lag
- For each CSN:
  1. Sort server appearances by timestamp
  2. For consecutive server pairs (supplier → consumer):
    - Hop lag = consumer_timestamp - supplier_timestamp
  3. Track individual hop lags to identify bottlenecks

### Input Parameters
1. Log Directories:
   List of paths to server log directories. Each directory represents one server in topology.

2. Filtering Parameters:
   - `suffixes`: List of DN suffixes to analyze
   - `time_range`: Optional start/end datetime range
   - `lag_time_lowest`: Minimum lag threshold
   - `etime_lowest`: Minimum operation execution time
   - `repl_lag_threshold`: Alert threshold for lag times

3. Analysis Options:
   - `anonymous`: Hide server names in reports
   - `only_fully_replicated`: Show only changes reaching all servers
   - `only_not_replicated`: Show only incomplete replication
   - `utc_offset`: Timezone handling

### Output Parameters
1. Reports:
   - CSV: Detailed event log with global and hop lags
   - HTML: Interactive visualization with Plotly
   - PNG: Static visualization with matplotlib
   - JSON: Summary statistics and analysis

2. Metrics:
   - Global lag statistics (min/max/avg)
   - Hop lag statistics (min/max/avg)
   - Per-suffix update counts
   - Total updates processed
   - Server participation statistics

## Component Details

### DSLogParser
- Purpose: Efficient log file parsing
- Key Features:
  - Batch processing for memory efficiency
  - Timezone-aware timestamp handling
  - Regular expression-based log parsing

### ReplicationLogAnalyzer
- Purpose: Analysis coordination and report generation
- Key Features:
  - Multi-server log correlation
  - Flexible filtering options
  - Multiple report format support

### VisualizationHelper
- Purpose: Data visualization
- Key Features:
  - Interactive Plotly charts
  - Static matplotlib exports
  - Consistent color schemes

## Data Flow

1. Log Collection:
   ```
   Server Logs → DSLogParser → Parsed Events
   ```

2. Analysis:
   ```
   Parsed Events → ReplicationLogAnalyzer → Lag Calculations
   ```

3. Reporting:
   ```
   Lag Calculations → VisualizationHelper → Reports (CSV/HTML/PNG)
   ```

## Challenges and Mitigations

1. Large Log Files:
   - Challenge: Memory consumption
   - Mitigation: Batch processing, generators

2. Time Zone Handling:
   - Challenge: Accurate timestamp comparison
   - Mitigation: Consistent UTC conversion

3. Visualization Performance:
   - Challenge: Large datasets
   - Mitigation: Data sampling, efficient plotting

## Web User Interface (WebUI)

The Replication Log Analyzer is accessible via **Monitor** → **Log Analyser** in the 389 DS Cockpit WebUI. The interface provides a form-based configuration system with real-time validation and integrated file browsing capabilities.

### Interface Structure

The UI is organized into card-based sections with an expandable help section explaining the analysis process. Form validation occurs in real-time with error highlighting and helper text for invalid inputs.

The tool starts with an expandable "About Replication Log Analysis" section that provides a clear overview of the analysis process. This isn't just documentation - it's an interactive guide that walks you through the five essential steps: selecting server log directories, specifying suffixes, adjusting filters, choosing report formats, and generating the report.

### Log Directory Selection

**File Browser Integration**: Modal dialog for directory selection opens to `/var/log/dirsrv` by default. Supports navigation via path input or folder browsing with checkbox-based multi-selection.

**Directory Management**: Selected directories display in a DataList component with folder icons and remove buttons. The interface validates directory accessibility before allowing selection.

### Suffix Configuration

**Input Field**: Text input with real-time DN validation using the `valid_dn()` function. Invalid DNs trigger immediate error display.

**Chip Display**: Selected suffixes appear as removable PatternFly chips. Interface pre-populates with existing replicated suffixes from server configuration.

### Configuration Options

**Display Options**:
- Server anonymization toggle (replaces hostnames with generic identifiers)
- Replication filter: all entries, fully replicated only, or failed replication only

**Time Range Controls**:
- DatePicker and TimePicker components for start/end times
- UTC offset field with increment/decrement buttons (30-minute intervals)
- Linked controls prevent invalid date ranges

**Threshold Configuration**:
- NumberInput components for lag time, etime, and replication lag thresholds
- Increment/decrement controls with validation for positive numbers

### Report Format Selection

**Format Options**:
- JSON: Interactive charts (always available)
- CSV: Data export (always available)
- HTML/PNG: Requires `python3-lib389-repl-reports` package

**Package Detection**: Interface checks for required package on mount and disables unavailable formats with explanatory tooltips.

### Output Configuration

**Directory Selection**: Default to `/tmp` with optional custom directory selection via file browser. These directories create subdirectories for individual reports.

**Report Naming**: Optional custom report names; defaults to timestamp-based naming.

### Report Generation

**Process Flow**:
1. Form validation before submission
2. Background command execution via Cockpit spawn
3. Loading state with progress indicators
4. JSON response parsing for report file locations

**Command Construction**: Builds `dsconf replication lag-report` command with all configured parameters, including log directories, suffixes, time ranges, and output formats.

### Report Viewing Modal

**Tabbed Interface**: Modal dialog with tabs adapting to available report formats:

- **Summary Tab**: Statistics display using PatternFly cards and description lists
- **Charts Tab**: Interactive PatternFly charts for JSON data visualization
- **PNG Tab**: Static image display (when available)
- **CSV Tab**: Data preview with download options
- **Files Tab**: Complete file listing with download links - Standalone HTML is here.

### Existing Report Management

**Report Discovery**: "Choose Existing Report" button opens modal that scans configured directory for existing reports. Identifies reports by file contents and naming patterns.

**Report Table**: Displays report metadata with format availability indicators (checkmarks/X marks) and "View Report" actions that open the same viewing modal used for new reports.

## Command Line Interface

The replication lag analyzer is also available as a CLI tool through dsconf:

```
dsconf INSTANCE replication lag-report [options]
```

### Required Parameters

**--log-dirs**: List of log directories to analyze. Each directory represents one server in the replication topology.
```
--log-dirs /var/log/dirsrv/slapd-supplier1 /var/log/dirsrv/slapd-consumer1
```

**--suffixes**: List of suffixes (naming contexts) to analyze.
```
--suffixes "dc=example,dc=com" "dc=test,dc=com"
```

**--output-dir**: Directory where analysis reports will be written.
```
--output-dir /tmp/repl_analysis
```

### Output Options

**--output-format**: Specify one or more output formats. Options: html, json, png, csv. Default: html.
```
--output-format json csv png
```

**--json**: Output results as JSON for programmatic use or UI integration.

### Filtering Options

**Replication Status Filters** (mutually exclusive):
- **--only-fully-replicated**: Show only entries that successfully replicated to all servers
- **--only-not-replicated**: Show only entries that failed to replicate to all servers

**Threshold Filters**:
- **--lag-time-lowest SECONDS**: Filter entries with lag time above this threshold
- **--etime-lowest SECONDS**: Filter entries with execution time above this threshold
- **--repl-lag-threshold SECONDS**: Lag threshold for highlighting in reports

### Time Range Options

**--start-time**: Start time for analysis in YYYY-MM-DD HH:MM:SS format. Default: 1970-01-01 00:00:00

**--end-time**: End time for analysis in YYYY-MM-DD HH:MM:SS format. Default: 9999-12-31 23:59:59

### Additional Options

**--utc-offset**: UTC offset in ±HHMM format for timezone handling (e.g., -0400, +0530)

**--anonymous**: Anonymize server names in reports (replaces with generic identifiers)

### Usage Examples

Basic analysis:
```
dsconf supplier1 replication lag-report \
  --log-dirs /var/log/dirsrv/slapd-supplier1 /var/log/dirsrv/slapd-consumer1 \
  --suffixes "dc=example,dc=com" \
  --output-dir /tmp/repl_report
```

Advanced analysis with filtering:
```
dsconf supplier1 replication lag-report \
  --log-dirs /var/log/dirsrv/slapd-supplier1 /var/log/dirsrv/slapd-consumer1 \
  --suffixes "dc=example,dc=com" \
  --output-dir /tmp/repl_report \
  --output-format json csv png \
  --lag-time-lowest 1.0 \
  --repl-lag-threshold 5.0 \
  --only-fully-replicated \
  --start-time "2025-01-01 00:00:00" \
  --end-time "2025-01-31 23:59:59" \
  --utc-offset "-0500"
```

## Authors

Simon Pichugin (@droideck)
