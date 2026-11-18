---
title: OpenTelemetry with Azure Monitor agent
description: Understand the Azure Monitor agent options for collecting OpenTelemetry guest operating system metrics and application OTLP signals.
ms.topic: concept-article
ms.date: 11/18/2026
ms.reviewer: shseth, nmangum
ai-usage: ai-assisted
---

# OpenTelemetry with Azure Monitor agent

Azure Monitor agent supports two distinct OpenTelemetry collection paths. It can collect guest operating system metrics from monitored machines, and it can receive OpenTelemetry Protocol (OTLP) signals from instrumented applications running on supported machines. Both paths send data to Azure Monitor, but they use different data sources, configuration, and destinations.

## Compare collection paths

| Aspect | Guest operating system metrics | Application OTLP signals |
|:---|:---|:---|
| Purpose | Monitor operating system and process performance. | Collect logs, metrics, and traces emitted by an instrumented application. |
| Source | OpenTelemetry host metrics collected by Azure Monitor agent. | An application or SDK that sends OTLP data to the local Azure Monitor agent listener. |
| Supported resources | Azure virtual machines and Azure Arc-enabled servers. | Azure virtual machines, Virtual Machine Scale Sets, and Azure Arc-enabled servers. |
| Destination | Azure Monitor workspace. | Log Analytics workspace for logs and traces, and Azure Monitor workspace for metrics. |
| Configuration | An OpenTelemetry performance counters data source in a DCR. | An OTLP-enabled DCR associated with the machine running the application. |

## Collect guest operating system metrics

Use the metrics-based experience to collect a default set of OpenTelemetry system metrics at no additional ingestion cost. You can modify the associated DCR to collect more system and per-process metrics.

- [Compare the metrics-based and logs-based VM monitoring experiences](../vm/metrics-opentelemetry-guest.md).
- [Customize OpenTelemetry metrics collection](../vm/metrics-opentelemetry-guest-modify.md).
- [Migrate from logs-based to OpenTelemetry metrics](../vm/vm-opentelemetry-migrate.md).
- [Review the Guest OS metrics reference](../vm/metrics-guest-reference.md).

## Ingest application OTLP signals

Applications on supported machines can send OTLP logs, metrics, and traces to an Azure Monitor agent listener. Azure Monitor agent then forwards the telemetry to Azure Monitor. OTLP ingestion through Azure Monitor agent is generally available on Linux starting with agent version 1.45.1. Review the setup article for current operating system, protocol, and version requirements.

For deployment and configuration steps, see [Ingest OTLP data into Azure Monitor by using Azure Monitor agent](../containers/opentelemetry-ingest-agent.md).

> [!NOTE]
> Azure Monitor agent sends the collected OTLP signals to Azure Monitor. For a centralized collection and processing architecture that receives telemetry from multiple producers, see [Azure Monitor pipeline](../data-collection/pipeline-overview.md).

## Related content

- [Azure Monitor agent overview](./azure-monitor-agent-overview.md)
- [OpenTelemetry with Azure Monitor](../containers/opentelemetry-options.md)
