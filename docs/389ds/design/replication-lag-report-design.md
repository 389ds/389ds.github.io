---
title: "Replication Lag Report Design"
---

# Replication Lag Report Design

{% include toc.md %}

## Document Version

0.1

## Revision History

| Version | Date       | Description of Change |
|---------|------------|-----------------------|
| 1.0     | 10-15-2024 | First version         |

## Executive Summary

The `ReplicationLagReport` class will consolidate the functionality of the existing `LogParser`, `ReplLag`, and `LagInfo` classes into a single, efficient, and reusable component. This design will allow for easy integration with both Ansible modules and standalone CLI tools, providing a comprehensive solution for analyzing and visualizing replication lag in the 389 Directory Server.

## Architecture Overview

The `ReplicationLagReport` class will be the central component, handling log parsing, data processing, and report generation. It will encapsulate all necessary functionality without relying on additional helper classes or modules.

## Component Details

### ReplicationLagReport (Main Class)

- **Responsibilities**:
  - Log file parsing and data extraction
  - Data processing and analysis
  - Report generation (CSV, PNG, HTML)
- **Key Methods**:
  - `__init__(self, config: Dict)`
  - `parse_logs(self)`
  - `process_data(self)`
  - `generate_report(self, report_type: str)`

## Data Flow

1. `ReplicationLagReport` is initialized with configuration parameters.
2. `parse_logs()` reads and processes input log files.
3. `process_data()` analyzes the collected data.
4. `generate_report()` creates the requested output (CSV, PNG, or HTML).

## API Definitions

### ReplicationLagReport

- `__init__(self, config: Dict)`
  - **Parameters**:
    - `input_files`: `List[str]`
    - `filters`: `Dict`
    - `timezone`: `str`
- `parse_logs(self) -> None`
- `process_data(self) -> None`
- `generate_report(self, report_type: str) -> None`

## Database Changes

No database changes are required for this implementation.

## Performance Considerations

- Implement lazy loading for log files to reduce memory usage.
- Use generators for processing large log files.

## Security Measures

- Implement input validation for all user-provided data.
- Sanitize data before generating reports to prevent XSS attacks in HTML output.

## Challenges and Mitigations

- **Challenge**: Processing large log files  
  **Mitigation**: Implement streaming processing and use generators.
- **Challenge**: Maintaining compatibility with existing systems  
  **Mitigation**: Design the API to be easily adaptable for Ansible modules and CLI tools.
- **Challenge**: Ensuring accuracy of time-based calculations across different timezones  
  **Mitigation**: Implement robust timezone handling using the `datetime` library.

## Implementation Roadmap

### Phase 1: Port Existing Code to lib389

1. Port existing Python code to use the `lib389` library.
2. Implement tests for `lib389` code.

### Phase 2: Develop Command-Line Interface (CLI) in dsconf Tool

3. Design and develop the CLI.
4. Implement tests for CLI features.
5. Enhance dsconf CLI to consume logs and generate the report.
5a. Add support for `.dsrc` files.

### Phase 3: Develop Web User Interface (WebUI) in Replication Monitoring Tab

6. Develop WebUI using CLI code.
7. Add special reports in WebUI using Cockpit functionality.
8. Implement tests for WebUI features (?)

### Phase 4: Finalization and Deployment

9. Documentation.
10. Feedback and iteration.


Authors
=======

Simon Pichugin (@droideck)