---
title: Sources supported by Azure Monitor pipeline
description: Review the Syslog, CEF, and OpenTelemetry sources supported by Azure Monitor pipeline, including protocols, destinations, and availability.
ai-usage: ai-assisted
ms.topic: reference
ms.date: 11/23/2026
---

# Sources supported by Azure Monitor pipeline

Azure Monitor pipeline receives telemetry over the network from many producers. It doesn't collect guest operating system events, performance counters, or files directly from each monitored machine. Use [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) for those scenarios.

## Supported sources

| Source | Protocol and format | Deployment platform | Azure Monitor destination | Status |
|:---|:---|:---|:---|:---|
| Syslog | RFC 3164 and RFC 5424 over TCP or UDP | Arc-enabled Kubernetes, Linux VM in Azure, or Arc-enabled Linux server | The `Syslog` table or a custom table in a Log Analytics workspace | Generally available |
| Common Event Format (CEF) | CEF messages received through the Syslog input | Arc-enabled Kubernetes, Linux VM in Azure, or Arc-enabled Linux server | The `CommonSecurityLog` table in a Microsoft Sentinel-enabled Log Analytics workspace | Generally available |
| OpenTelemetry logs | OTLP over gRPC | Arc-enabled Kubernetes | The `OTelLogs` table or a custom table in a Log Analytics workspace | Preview |
| OpenTelemetry metrics | OTLP over gRPC | Arc-enabled Kubernetes | An Azure Monitor workspace | Preview |
| OpenTelemetry traces | OTLP over gRPC | Arc-enabled Kubernetes | The `OTelSpans`, `OTelEvents`, and `OTelResources` tables in a Log Analytics workspace | Preview |

For supported deployment platforms and configuration methods, see [Support and availability](./pipeline-support.md).

## Configure Syslog and CEF

Use the DCR-based examples to:

- [Collect Syslog over UDP](./pipeline-configure-cli.md#deploy-the-arm-template).
- [Collect Syslog over TLS](./pipeline-configure-cli.md#example-collect-syslog-over-tls).
- [Collect CEF into Microsoft Sentinel](./pipeline-configure-cli.md#collect-cef-into-microsoft-sentinel).

## Configure OpenTelemetry

Use one OTLP/gRPC listener to receive OTel logs, metrics, and traces. The dataflow DCR routes each signal to its Azure Monitor destination. See [Collect OTel logs, metrics, and traces](./pipeline-configure-cli.md#collect-otel-logs-metrics-and-traces).

You can also:

- [Enable persistent storage](./pipeline-persistent-storage.md) for OTel logs, metrics, and traces.
- [Filter OTel logs with KQL](./pipeline-transformations.md#filter-opentelemetry-logs) before they're sent to Azure Monitor.

## Related content

- Review outputs in [Azure Monitor pipeline destinations](./pipeline-destinations.md).
- Filter, reshape, or aggregate logs in [Azure Monitor pipeline transformations](./pipeline-transformations.md).
