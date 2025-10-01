---
title: Monitor issues with ingestion and query in Azure Monitor Workspace
description: Monitor issues with ingestion and query in Azure Monitor workspace.
ms.topic: how-to
ms.date: 04/09/2025
---

# Monitor metrics ingestion in Azure Monitor workspace (preview)

Ingestion errors are issues that occurred during data ingestion. Error conditions in this category might suggest data loss, so they are important to monitor. These errors may include indications of reaching the Azure Monitor workspace ingestion limits. For service limits for Azure Monitor workspaces, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics).

> [!IMPORTANT]
> This feature is currently in preview and may be subject to change. Support for this feature is limited. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.


## Monitor ingestion Errors

To monitor errors in data ingestion for Azure Monitor workspace metrics, use the following steps:

1. In the Azure portal, navigate to your Azure Monitor workspace and select **Metrics** under the **Monitoring** section.
1. In the **Add metric** dropdown, select **Add with builder**.
1. Select the Azure Monitor workspace as scope.
1. Select **Standard metrics** for the **Metric Namespace**.
1. In the **Metric** drop-down, select **Events Dropped** and **Time Series Samples Dropped** to check for any errors in data ingestion.
1. Click on **Apply splitting**, and in the **Values** dropdown, select **Reason**.

    :::image type="content" source="./media/azure-monitor-workspace-monitor-ingest-limits/amw-ingestion-qos-1.png" alt-text="Screenshot that shows metrics chart for ingestion errors in Azure Monitor workspace." lightbox="./media/azure-monitor-workspace-monitor-ingest-limits/amw-ingestion-qos-1.png":::


### Events dropped

The events dropped metric indicates the number of events received but not accepted into Azure Monitor Workspace. It includes a **Reason** dimension to indicate why events are not accepted. The set of reasons are subject to change in the future to provide better fidelity. The following table describes the set of reasons and what conditions result in them.

| Reason | Description |
| ------ | ----------- |
| OldData | Data was dropped because events have timestamps older than 20 minutes. Only events with timestamps no more than 20 minutes in the past or 20 minutes in the future (relative to ingestion time) are accepted. |
| LimitThrottling | Data was dropped because ingestion limits were exceeded. [Request an increase in ingestion limits](./azure-monitor-workspace-monitor-ingest-limits.md)|
| BadInputFormat | Data was dropped because the input format was invalid. For valid input formats, see [Metric names, label names & label values](./prometheus-metrics-details.md#metric-names-label-names--label-values)|
| InternalError | Data was dropped because of an internal error. |

### Time series samples dropped

The time series samples dropped metric indicates the number of datapoints dropped during processing (after the corresponding event was accepted). It includes a **Reason** dimension to indicate why the datapoints were dropped. The set of reasons are subject to change in the future to provide better fidelity. The following table describes the set of reasons and what conditions result in them.

| Reason | Description |
| ------ | ----------- |
| Duplicate | Data was a duplicate of already received data.|
| OutOfOrder | Data was received out of order; the data received for a time series had an older timestamp than other data already ingested for the same time series. |
| LimitThrottling | Data was rejected because new time series are throttled at the monitoring account level. [Request an increase in ingestion limits](./azure-monitor-workspace-monitor-ingest-limits.md) |
| InvalidTimeRange | Data was rejected because it contained a timestamp too far in future. Only events with timestamps no more than 20 minutes in the future (relative to ingestion time) are accepted. |
| OldData | Data was rejected because it was too old. Only events with timestamps no more than 20 minutes in the past (relative to ingestion time) are accepted. |
| InternalError | Update has failed due to an internal error. |
| ReservedDimensionName | Data was rejected because it contained one or more dimension key(s)/label name(s) that conflicts with reserved dimension/label name(s). |
| BadInputFormat | Data was dropped because it contained values outside of the supported data range. For valid input formats, see [Metric names, label names & label values](./prometheus-metrics-details.md#metric-names-label-names--label-values) |


> [!NOTE]
> These metrics are currently in preview and support for these metrics are limited. If needed, you can create an alert for metrics dropped beyond a certain threshold, and in case such an alert is received, please review your data collection configurations for the specific conditions as described above.

## Next steps

+ [Monitor ingestion limits](./azure-monitor-workspace-monitor-ingest-limits.md)
+ [Azure Monitor service limits](../service-limits.md#prometheus-metrics)

