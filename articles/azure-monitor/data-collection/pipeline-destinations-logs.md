---
title: Send Azure Monitor pipeline data to Azure Monitor Logs
description: Learn which Azure Monitor pipeline signals can be sent to Log Analytics workspaces and destination tables.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Send Azure Monitor pipeline data to Azure Monitor Logs

Azure Monitor pipeline sends supported log and trace signals to tables in a Log Analytics workspace.

| Source | Destination table |
|:---|:---|
| Syslog | `Syslog` or a compatible custom table |
| CEF | `CommonSecurityLog` in a Microsoft Sentinel-enabled workspace |
| OTel logs | `OTelLogs` or a compatible custom table |
| OTel traces | `OTelSpans`, `OTelEvents`, and `OTelResources` |

Define the workspace in `destinations.logAnalytics` in the dataflow DCR. A `dataFlows` entry connects the source stream to the named destination.

A stream can target only one Log Analytics workspace in a DCR. To send the same OTel log stream to two workspaces, create a second dataflow DCR and associate both dataflow DCRs with the same pipeline extension.

Create every DCR in the same region as its destination workspace. The [OTel deployment example](./pipeline-configure-cli.md#collect-otel-logs-metrics-and-traces) demonstrates two-workspace log fan-out and verification.

For all currently supported outputs, see [Destinations supported by Azure Monitor pipeline](./pipeline-destinations.md).
