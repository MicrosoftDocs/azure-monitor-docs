---
title: Collect OpenTelemetry with Azure Monitor pipeline
description: Learn how Azure Monitor pipeline receives and routes OpenTelemetry logs, metrics, and traces.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Collect OpenTelemetry with Azure Monitor pipeline

Azure Monitor pipeline receives OpenTelemetry (OTel) logs, metrics, and traces over OTLP/gRPC. Native OTel collection through the DCR-based pipeline on Arc-enabled Kubernetes is in preview.

| Signal | Data source | Azure Monitor destination |
|:---|:---|:---|
| Logs | `otelLogs` with `Microsoft-OTel-Logs` | `OTelLogs` or a compatible custom table in a Log Analytics workspace |
| Metrics | `otelMetrics` with a stream named `Custom-Metrics-*` | An Azure Monitor workspace |
| Traces | `otelTraces` with the OTel trace streams | `OTelSpans`, `OTelEvents`, and `OTelResources` in a Log Analytics workspace |

Azure Monitor supports OTel sources on Arc-enabled Kubernetes. The Linux VM and Arc-enabled Linux server deployment don't currently support OTel sources.

## Configure collection

Use the [OTel DCR and ARM template example](./pipeline-configure-cli.md#collect-otel-logs-metrics-and-traces) to configure one OTLP/gRPC listener and route each signal to its destination.

The documented listener requires mutual TLS (mTLS) by default. Clients must trust the server CA and present a trusted client certificate. See [Gateway and TLS](./pipeline-security.md).

## Process and verify data

- Set `enrichWithResourceAttributes` to an array of resource-attribute names on native `otelLogs` and `otelTraces` data sources to populate `OTelLogs.ResourceAttributes` and `OTelSpans.ResourceAttributes`. Use `["*"]` to select all resource attributes.
- KQL transformations can filter or reshape OTel logs. They don't apply to OTel metrics or traces. See [Filter OpenTelemetry logs](./pipeline-transformations.md#filter-opentelemetry-logs).
- You can configure persistent buffering independently for OTel logs, metrics, and traces. See [Persistence](./pipeline-persistent-storage.md).
- Use the [OTel verification guidance](./pipeline-configure-cli.md#verify-otel-routing) to verify both log workspaces, trace tables, resource attributes, span events, and metrics.
