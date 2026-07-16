---
title: Advanced platform metrics (preview)
description: Learn about advanced platform metrics in Azure Monitor, a premium tier of platform metrics that provides deeper observability for Azure resource providers.
ms.topic: concept-article
ms.date: 05/29/2026
ms.reviewer: alyssaschimm
---

# Advanced platform metrics (preview)

Advanced platform metrics are a premium, paid tier of platform metrics in Azure Monitor that provide more granular observability for Azure resources. Azure Monitor automatically collects platform metrics at no cost and covers baseline monitoring scenarios. Advanced platform metrics extend this capability with deeper, more detailed metrics that Azure resources generate on demand.

Examples of advanced platform metrics for Azure Storage include container-level blob capacity and container-level blob count. These metrics give you visibility into resource behavior at a level of detail that out-of-the-box platform metrics don't provide.

> [!NOTE]
> Advanced platform metrics are a paid feature. For pricing details, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## What are advanced platform metrics

Azure Monitor supports several types of metrics, including platform metrics, Prometheus metrics, and more. For a full overview of metric types, see [Azure Monitor Metrics overview](data-platform-metrics.md).

Advanced platform metrics are a subset of platform metrics. Azure resources automatically emit platform metrics at no cost. Advanced platform metrics extend platform metrics with deeper, more granular data that Azure resources generate when you enable this feature. You explicitly opt in to these metrics at the resource level.

The following table summarizes the differences between platform metrics and advanced platform metrics:

| Feature | Platform metrics | Advanced platform metrics |
|---|---|---|
| Configuration | None required | Opt-in at the resource level |
| Cost | Free | Paid ([see pricing](https://azure.microsoft.com/pricing/details/monitor/)) |
| Granularity | Baseline resource health and performance | Deeper, more detailed resource observability |
| Availability | All Azure resources | Select resource providers |
| Query and visualization | Metrics Explorer, Azure Monitor APIs, REST API | Metrics Explorer, Azure Monitor APIs, REST API |
| Storage | Microsoft-managed telemetry stores | Microsoft-managed telemetry stores |

## How advanced platform metrics work

Advanced platform metrics use the same infrastructure as platform metrics. After you enable them, the Azure resource generates the metrics, stores them in Microsoft-managed telemetry stores, and makes them available through the same tools and APIs you already use for metrics.

The process works as follows:

1. In the Azure portal, go to a supported resource (for example, a storage account).
1. Enable advanced platform metrics by following the Azure resource's instructions (see [Supported resource providers](#supported-resource-providers)).
1. Select the specific advanced metrics you want to enable.
1. After you save your changes, the resource provider begins generating the selected metrics.
1. Query and visualize the metrics by using [Metrics Explorer](analyze-metrics.md), the [Azure Monitor REST API](/rest/api/monitor/metrics/list), or other Azure Monitor tools.

You don't need to manage any underlying storage. Advanced platform metrics are stored in the same Microsoft-managed telemetry stores used by platform metrics.

> [!TIP]
> You can enable advanced platform metrics on only the resources you need. You don't have to enable them across all accounts or resources.

## Supported resource providers

Advanced platform metrics are available for select Azure resource providers. The following table lists the resource providers that currently support advanced platform metrics. This list expands as more resource providers adopt the capability.

| Resource provider | Description | Enablement instructions |
|---|---|---|
| Azure Storage | Advanced metrics for storage accounts, including container blob capacity and container blob count. | [Enable Azure Storage advanced platform metrics](/azure/storage/blobs/blob-storage-advanced-platform-metrics) |

> [!NOTE]
> More resource providers are planned to support advanced platform metrics in future releases. Check back for updates.

## Enable advanced platform metrics

The steps to enable advanced platform metrics vary by resource provider. Each resource provider defines which advanced metrics are available and how to enable them. For specific enablement instructions, refer to the documentation for each resource provider in the [Supported resource providers](#supported-resource-providers) table.

After you enable advanced platform metrics, the resource provider begins generating the selected metrics. You can then query and visualize them by using the same tools you use for platform metrics.

> [!NOTE]
> It can take up to six hours for changes to advanced platform metrics settings to be reflected. This delay includes enabling, updating, and disabling these metrics.

> [!IMPORTANT]
> Enablement steps differ for each resource provider. Always refer to the RP-specific documentation linked in the [Supported resource providers](#supported-resource-providers) table for detailed instructions.

## Related content

- [Azure Monitor Metrics overview](data-platform-metrics.md)
- [Analyze metrics with Azure Monitor metrics explorer](analyze-metrics.md)
- [Supported metrics with Azure Monitor](../reference/metrics-index.md)
- [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/)