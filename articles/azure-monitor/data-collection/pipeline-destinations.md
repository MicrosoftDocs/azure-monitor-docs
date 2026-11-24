---
title: Destinations supported by Azure Monitor pipeline
description: Review the Azure Monitor destinations supported for Syslog, CEF, and OpenTelemetry data.
ai-usage: ai-assisted
ms.topic: reference
ms.date: 11/23/2026
---

# Destinations supported by Azure Monitor pipeline

Azure Monitor pipeline currently sends telemetry only to Azure Monitor destinations. A dataflow DCR connects each source stream to its destination.

## Supported destinations

| Destination | Supported data | Result |
|:---|:---|:---|
| Log Analytics workspace | Syslog | Data is written to the `Syslog` table or a compatible custom table. |
| Log Analytics workspace with Microsoft Sentinel enabled | CEF | Data is written to the `CommonSecurityLog` table. |
| Log Analytics workspace | OpenTelemetry logs | Data is written to the `OTelLogs` table or a compatible custom table. |
| Log Analytics workspace | OpenTelemetry traces | Data is written to the `OTelSpans`, `OTelEvents`, and `OTelResources` tables. |
| Azure Monitor workspace | OpenTelemetry metrics | Metrics are stored in the Azure Monitor workspace. |

Microsoft Sentinel isn't a separate pipeline destination. CEF data is sent to the `CommonSecurityLog` table in a Log Analytics workspace where Microsoft Sentinel is enabled.

External destinations and non-Azure Monitor storage targets aren't currently supported.

## Route data to destinations

Define destinations and routing in a dataflow DCR:

- `destinations.logAnalytics` identifies a Log Analytics workspace.
- `destinations.monitoringAccounts` identifies an Azure Monitor workspace.
- `dataFlows` connects source streams to named destinations.

For a complete configuration, see [Configure Azure Monitor pipeline with DCRs](./pipeline-configure-cli.md). For supported inputs and their availability, see [Sources](./pipeline-sources.md).
