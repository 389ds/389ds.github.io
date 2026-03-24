---
title: "Replication Log Analyzer Tool"
---

# Directory Server Replication Lag Analyzer Tool

## Document Version

1.1

## Revision History

| Version | Date       | Description of Change |
|---------|------------|-----------------------|
| 1.0     | 2025-10-26 | Initial design document |
| 1.1     | 2026-03-23 | Added precision controls, sampling strategy, CSN drill-down, improved output format details, updated WebUI and CLI sections |

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

3. Analysis Options:
   - `anonymous`: Hide server names in reports
   - `only_fully_replicated`: Show only changes reaching all servers
   - `only_not_replicated`: Show only incomplete replication
   - `utc_offset`: Timezone handling

4. Performance Options:
   - `analysis_precision`: Controls sampling aggressiveness (`fast`, `balanced`, `full`)
   - `max_chart_points`: Maximum data points across all chart series (overrides precision preset)
   - `sampling_mode`: `auto` (default) or `none` — controls whether downsampling is applied

### Output Parameters
1. Reports:
   - CSV: Detailed event log with global and hop lags
   - HTML: Interactive visualization with Plotly (3 subplots: global lag, duration, per-hop lags)
   - PNG: Static visualization with matplotlib (2 subplots: lags and durations)
   - JSON: PatternFly chart data with interactive drill-down support
   - Summary JSON: Always generated alongside other formats — contains aggregate statistics

2. Metrics:
   - Global lag statistics (min/max/avg)
   - Hop lag statistics (min/max/avg)
   - Per-suffix update counts
   - Total updates processed
   - Server participation statistics (active, processed, skipped log dirs)

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

## Performance & Precision Controls

The analyzer supports configurable precision modes that balance analysis speed against data fidelity. This is critical for large deployments where access logs can contain millions of entries.

### Precision Presets

| Preset | Max Chart Points | Description |
|--------|-----------------|-------------|
| `fast` | 2,000 | Quick preview with aggressive sampling. Suitable for initial investigation of large datasets |
| `balanced` | 6,000 | Default. Good trade-off between speed and detail for most deployments |
| `full` | None (unlimited) | No sampling cap. Processes all data points. Very large datasets may still trigger auto-sampling if they exceed the auto-sampling threshold |

### Sampling Strategy

When datasets exceed the configured limits, the analyzer applies uniform sampling to reduce data volume while preserving the statistical shape of the data:

- **Auto-sampling threshold**: 4,000 CSN points. Below this, sampling is skipped even in `fast`/`balanced` modes
- **Hop series budget**: 25% of total chart points are allocated to hop-lag series, with the remaining 75% for global lag series
- **Minimum points per series**: 2 points are always preserved per series to maintain visual continuity
- **Uniform distribution**: Sampled points are evenly distributed across the original dataset using index-based selection, ensuring no time periods are disproportionately represented

The `--max-chart-points` CLI parameter allows direct override of the preset limit for fine-tuned control.

### CSN Details Limiting

For the JSON output drill-down feature, the analyzer stores detailed per-CSN propagation data. To prevent excessive memory usage:
- Maximum of 10,000 CSN details are retained
- When exceeded, CSNs are ranked by global lag (descending) and the top 10,000 highest-lag CSNs are kept — these are the most diagnostically valuable entries

### Sampling Metadata

Reports include sampling metadata so consumers know whether data was reduced:
```json
{
    "applied": false,
    "mode": "auto",
    "samplingMode": "auto",
    "precision": "balanced",
    "maxChartPoints": 6000,
    "originalTotalPoints": 15000,
    "reducedTotalPoints": 6000
}
```

## Data Flow

1. Log Collection:
   ```
   Server Logs → DSLogParser → Parsed Events
   ```

2. Analysis:
   ```
   Parsed Events → ReplicationLogAnalyzer → Lag Calculations
   ```

3. Sampling (if needed):
   ```
   Lag Calculations → Precision Controls → Sampled Data
   ```

4. Reporting:
   ```
   Sampled Data → VisualizationHelper → Reports (JSON/CSV/HTML/PNG)
   ```

## Output Format Details

### Summary JSON (`replication_analysis_summary.json`)

Always generated alongside other formats. Contains aggregate statistics:
```json
{
    "analysis_summary": {
        "total_servers": 3,
        "configured_log_dirs": ["/var/log/dirsrv/slapd-supplier1", "..."],
        "processed_log_dirs": ["/var/log/dirsrv/slapd-supplier1", "..."],
        "skipped_log_dirs": [],
        "analyzed_logs": 4521,
        "total_updates": 12843,
        "minimum_lag": 0.001,
        "maximum_lag": 45.230,
        "average_lag": 2.150,
        "minimum_hop_lag": 0.001,
        "maximum_hop_lag": 12.450,
        "average_hop_lag": 1.030,
        "total_hops": 8922,
        "updates_by_suffix": {"dc=example,dc=com": 12843},
        "time_range": {"start": "2025-01-01 00:00:00", "end": "2025-01-31 23:59:59"}
    }
}
```

### PatternFly JSON (`replication_analysis.json`)

Designed for the Cockpit WebUI's PatternFly chart components. Top-level structure:

```json
{
    "replicationLags": {
        "title": "Global Replication Lag Over Time",
        "yAxisLabel": "Lag Time (seconds)",
        "xAxisLabel": "Time",
        "series": [
            {
                "datapoints": [
                    {
                        "name": "supplier1",
                        "x": "2025-01-15T10:30:00+00:00",
                        "y": 2.150,
                        "duration": 0.003,
                        "hoverInfo": "Timestamp: ...<br>CSN: ...<br>...",
                        "csnId": "5a5b6c7d000000010000"
                    }
                ],
                "legendItem": {"name": "supplier1 (dc=example,dc=com)"},
                "color": "#0066cc"
            }
        ]
    },
    "hopLags": {
        "title": "Per-Hop Replication Lags",
        "yAxisLabel": "Hop Lag Time (seconds)",
        "xAxisLabel": "Time",
        "series": [
            {
                "datapoints": [
                    {
                        "name": "supplier1 → consumer1",
                        "x": "2025-01-15T10:30:00+00:00",
                        "y": 1.050,
                        "hoverInfo": "...",
                        "csnId": "5a5b6c7d000000010000"
                    }
                ],
                "legendItem": {"name": "supplier1 → consumer1"},
                "color": "#ff6600"
            }
        ]
    },
    "csnDetails": {
        "5a5b6c7d000000010000": {
            "csn": "5a5b6c7d000000010000",
            "targetDn": "uid=user1,ou=people,dc=example,dc=com",
            "suffix": "dc=example,dc=com",
            "globalLag": 2.150,
            "originServer": "supplier1",
            "originTime": "2025-01-15T10:30:00+00:00",
            "arrivals": [
                {
                    "server": "supplier1",
                    "timestamp": "2025-01-15T10:30:00+00:00",
                    "relativeDelay": 0.0,
                    "duration": 0.003
                },
                {
                    "server": "consumer1",
                    "timestamp": "2025-01-15T10:30:01.05+00:00",
                    "relativeDelay": 1.050,
                    "duration": 0.002,
                    "hopFrom": "supplier1",
                    "hopLag": 1.050
                }
            ],
            "hops": [
                {"from": "supplier1", "to": "consumer1", "lag": 1.050}
            ],
            "totalHops": 1,
            "serverCount": 2,
            "replicatedToAll": true
        }
    },
    "metadata": {
        "totalServers": 3,
        "configuredLogDirs": ["..."],
        "processedLogDirs": ["..."],
        "skippedLogDirs": [],
        "analyzedLogs": 4521,
        "totalUpdates": 12843,
        "timeRange": {"start": "...", "end": "..."},
        "timezone": "UTC",
        "sampling": { "...sampling metadata..." }
    }
}
```

The `csnDetails` map enables click-through drill-down in the WebUI — clicking any chart point reveals the full propagation path for that CSN across all servers.

### CSV (`replication_analysis.csv`)

Tabular format with columns: timestamp, CSN, server, lag_time, duration, target_dn, suffix, and hop lag information. Suitable for spreadsheet analysis and external tooling.

### HTML (`replication_analysis.html`)

Standalone interactive Plotly visualization with 3 subplots:
1. Global Replication Lag Over Time
2. Operation Duration Over Time
3. Per-Hop Replication Lags

Supports hover info, range selection, and zoom controls. Requires `python3-lib389-repl-reports` package (Plotly dependency).

### PNG (`replication_analysis.png`)

Static matplotlib export with 2 subplots (global lags and operation durations). Requires `python3-lib389-repl-reports` package (matplotlib dependency). No per-hop subplot due to matplotlib's limitations with many series.

## Challenges and Mitigations

1. Large Log Files:
   - Challenge: Memory consumption
   - Mitigation: Batch processing, generators

2. Time Zone Handling:
   - Challenge: Accurate timestamp comparison
   - Mitigation: Consistent UTC conversion

3. Visualization Performance:
   - Challenge: Large datasets overwhelming chart rendering
   - Mitigation: Configurable precision presets with automatic sampling, client-side downsampling in the WebUI (2,000 points for global lags, 600 for hop lags), CSN details capped at 10,000 entries

4. Memory Safety:
   - Challenge: Very large JSON payloads in the WebUI
   - Mitigation: 64 MiB read limits, blob-based PNG handling with cleanup, lazy tab loading

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
- NumberInput components for lag time and etime thresholds
- Increment/decrement controls with validation for positive numbers

### Report Output Configuration

**Analysis Precision**: Radio button selector controlling backend sampling strategy:
- **Fast (preview, sampled)**: Quick preview using aggressive sampling for large datasets
- **Balanced (default)**: Good balance between speed and detail
- **Full Precision (slower)**: Process all points without sampling. Note: very large datasets may still be auto-sampled for performance; use time range or suffix filters to reduce data volume

The selected precision value is passed to the backend via the `--precision` CLI parameter.

**Format Options**:
- JSON: PatternFly chart data with drill-down support (always available)
- CSV: Tabular data export (always available)
- HTML/PNG: Requires `python3-lib389-repl-reports` package

**Package Detection**: On mount, the interface runs `rpm -q python3-lib389-repl-reports` to check package availability. If missing, HTML and PNG checkboxes are disabled with explanatory tooltips.

**Output Directory**: Defaults to `/tmp` with optional custom directory selection via the file browser. Each report run creates a subdirectory — either using a custom report name or an auto-generated name with ISO 8601 timestamp and random suffix (e.g., `repl_report_2025-01-15T14-23-45_a3f2b1`).

**Report Naming**: Optional custom report names; defaults to timestamp-based naming.

### Report Generation

**Process Flow**:
1. Form validation before submission
2. Background command execution via Cockpit spawn
3. Loading state with progress indicators
4. JSON response parsing for report file locations

**Command Construction**: Builds `dsconf replication lag-report` command with all configured parameters, including log directories, suffixes, time ranges, and output formats.

### Report Viewing Modal

**Tabbed Interface**: `LagReportModal` dialog with tabs dynamically adapting to available report formats. Each tab loads its data independently and asynchronously, with load tokens preventing race conditions.

- **Summary Tab** (always present): Displays aggregate statistics in a card-based layout:
  - Analysis Overview card: total servers, analyzed log events, total updates
  - Replication Lag Statistics card: minimum, maximum, and average lag
  - Skipped Log Directories card: warning alert if any directories couldn't be read
  - Updates by Suffix card: per-suffix update counts
  - Time Range card: analysis start and end times

- **Charts Tab** (when JSON available): Interactive PatternFly scatter-line charts rendering two chart types:
  - **Global Replication Lag Over Time**: Shows lag values for each server/suffix combination
  - **Per-Hop Replication Lags**: Shows hop-by-hop delays between server pairs (format: "supplier → consumer")
  - **CSN Drill-Down**: Clicking any chart point opens a `CSNDetailModal` showing the full propagation path for that CSN — origin server, arrival timeline with arrows showing hop-by-hop propagation, and detailed timing information for each server
  - **Client-Side Sampling**: For very large JSON datasets, the WebUI applies additional client-side downsampling (2,000 points for global lags, 600 for hop lags) with a warning alert when sampling is active

- **PNG Tab** (when PNG available): Static image display. PNG is read as binary data (up to 64 MiB), converted to a data URL via Blob/FileReader, and rendered as an `<img>` element

- **CSV Tab** (when CSV available): Shows a text preview of the first 20 lines of CSV data in a `<pre>` code block

- **Report Files Tab** (always present): Lists all generated files (summary JSON, chart JSON, CSV, PNG, HTML) with download buttons. Downloads use Cockpit's channel API with hidden iframe injection for browser-native file saving

### Existing Report Management

**Report Discovery**: "Choose Existing Report" button opens `ChooseLagReportModal` that scans the configured output directory for existing reports. Discovery logic:
1. Lists subdirectories in the output directory
2. Checks each for the presence of known report files (`replication_analysis.json`, `_summary.json`, `.html`, `.csv`, `.png`)
3. Rejects directories containing unexpected files (strict validation)
4. Retrieves creation time via `stat` or by parsing the directory name timestamp

**Report Table**: Displays report metadata sorted by creation time (newest first) with format availability indicators (checkmarks/X marks) and "View Report" actions that open the same `LagReportModal` used for new reports.

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

### Time Range Options

**--start-time**: Start time for analysis in YYYY-MM-DD HH:MM:SS format. Default: 1970-01-01 00:00:00

**--end-time**: End time for analysis in YYYY-MM-DD HH:MM:SS format. Default: 9999-12-31 23:59:59

### Additional Options

**--utc-offset**: UTC offset in ±HHMM format for timezone handling (e.g., -0400, +0530)

**--anonymous**: Anonymize server names in reports (replaces with generic identifiers)

### Performance Options

**--precision**: Analysis precision vs speed. Choices: `fast`, `balanced` (default), `full`. Controls the sampling aggressiveness when generating chart data. See [Performance & Precision Controls](#performance--precision-controls) for details.

**--max-chart-points**: Maximum total data points to include across all chart series. Sampling is applied if exceeded. Default depends on `--precision` setting. Overrides the precision preset when specified explicitly.

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
  --only-fully-replicated \
  --start-time "2025-01-01 00:00:00" \
  --end-time "2025-01-31 23:59:59" \
  --utc-offset "-0500"
```

Fast preview of a large dataset:
```
dsconf supplier1 replication lag-report \
  --log-dirs /var/log/dirsrv/slapd-supplier1 /var/log/dirsrv/slapd-consumer1 /var/log/dirsrv/slapd-consumer2 \
  --suffixes "dc=example,dc=com" \
  --output-dir /tmp/repl_report \
  --output-format json \
  --precision fast
```

Full precision with custom chart point limit:
```
dsconf supplier1 replication lag-report \
  --log-dirs /var/log/dirsrv/slapd-supplier1 /var/log/dirsrv/slapd-consumer1 \
  --suffixes "dc=example,dc=com" \
  --output-dir /tmp/repl_report \
  --output-format json csv \
  --precision full \
  --max-chart-points 15000
```

## Authors

Simon Pichugin (@droideck)
