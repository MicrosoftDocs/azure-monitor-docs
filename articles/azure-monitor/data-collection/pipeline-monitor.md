---
title: Monitor your Azure Monitor pipeline deployment
description: Learn how to monitor the health and performance of Azure Monitor pipeline by using metrics and logs.
ai-usage: ai-assisted
ms.date: 04/08/2026
author: bwren
ms.author: bwren
ms.reviewer: bwren
ms.topic: how-to
ms.subservice: data-collection
---

# Monitor your Azure Monitor pipeline

Use Azure Monitor metrics and logs to monitor the health of your pipeline deployment.

## View metrics in the Azure portal

In the Azure portal, open your Azure Monitor pipeline resource and select **Monitoring**. The following metrics are available:

| Metric name | Display name | Description | Dimensions | Supported aggregation types |
|:---|:---|:---|:---|:---|
| `process_cpu_utilization` | CPU utilization (preview) | The percentage of CPU utilized by the pipeline group process, normalized across all cores. | Instance ID | Average, Minimum, Maximum |
| `process_memory_usage` | Memory used (preview) | Total physical memory (resident set size) used by the pipeline group process. | Instance ID | Average, Minimum, Maximum |
| `process_uptime` | Process uptime (preview) | Uptime of the pipeline group process since last start. | Instance ID | Maximum |
| `exporter_sent_log_records` | Logs exported (preview) | Number of log records successfully sent by the exporter to the destination. | Instance ID, Pipeline name, Component name | Total |

<!-- Metric visualization workbook screenshots will be added when available. -->

## View metrics through Prometheus scraping

You can also scrape pipeline metrics by using Prometheus. For more information about configuring Prometheus metrics collection, see [Collect Prometheus metrics from an Arc-enabled Kubernetes cluster](/azure/azure-monitor/containers/kubernetes-monitoring-enable#enable-prometheus-and-grafana).

## View logs in the Azure portal

Create a [diagnostic setting in Azure Monitor](../platform/diagnostic-settings.md) to collect resource logs for the pipeline. After you configure diagnostic settings, you can view logs for your Azure Monitor pipeline instance in the `AzureMonitorPipelineLogErrors` table in your Log Analytics workspace. Use this table to troubleshoot pipeline data collection issues.

## Obtain logs locally

To troubleshoot problems that you can't see in the Azure portal, collect pipeline logs directly from the Kubernetes cluster. Use the following command to get logs from the pipeline pods:

```bash
kubectl logs <pod-name> -n <namespace>
```

Replace `<pod-name>` with the name of the pipeline pod and `<namespace>` with the namespace where you deployed the pipeline.

## Related articles

- Review the core setup flow in [Configure Azure Monitor pipeline](./pipeline-configure.md).
- Learn how to modify incoming data in [pipeline transformations](./pipeline-transformations.md).
- Review the product overview in [What is Azure Monitor pipeline?](./pipeline-overview.md).