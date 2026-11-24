---
title: Send Azure Monitor pipeline data to Azure Monitor metrics
description: Send OpenTelemetry metrics from Azure Monitor pipeline to an Azure Monitor workspace.
ai-usage: ai-assisted
ms.topic: concept-article
ms.date: 11/23/2026
---

# Send Azure Monitor pipeline data to Azure Monitor metrics

Azure Monitor pipeline sends OpenTelemetry metrics to an Azure Monitor workspace (`Microsoft.Monitor/accounts`).

In the dataflow DCR:

- Define the Azure Monitor workspace in `destinations.monitoringAccounts`.
- Use an author-named metrics stream that starts with `Custom-Metrics-`.
- Connect the metrics stream to the named destination in `dataFlows`.

The DCR must use the same region as the Azure Monitor workspace. The pipeline extension's managed identity requires **Monitoring Metrics Publisher** on the dataflow DCR.

Pipeline KQL transformations don't apply to OTel metrics. Process or select metrics at the source before sending them to the pipeline.

For a complete metrics, logs, and traces configuration, see [Collect OTel logs, metrics, and traces](./pipeline-configure-cli.md#collect-otel-logs-metrics-and-traces). Verify the emitted metric by name with the [Prometheus query API](../metrics/prometheus-api-promql.md), as described in [Verify OTel routing](./pipeline-configure-cli.md#verify-otel-routing).
