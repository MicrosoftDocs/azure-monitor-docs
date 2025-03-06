---
title: Monitor DCR data collection in Azure Monitor
description: Configure log collection for monitoring of DCR-based data collection in Azure Monitor.
ms.topic: conceptual
ms.date: 12/04/2024
---

# Monitor DCR data collection in Azure Monitor
This article provides detailed metrics and logs that you can use to monitor performance and troubleshoot any issues related to data collection in Azure Monitor. This telemetry is currently available for data collection scenarios defined by a [data collection rules (DCR)](./data-collection-rule-overview.md) such as Azure Monitor agent and Logs ingestion API.

> [!IMPORTANT]
> This article only refers to data collection scenarios that use DCRs, including the following:
> 
> - Logs collected using [Azure Monitor Agent (AMA)](../agents/agents-overview.md)
> - Logs ingested using [Log Ingestion API](../logs/logs-ingestion-api-overview.md)
> - Logs collected by other methods that use a [workspace transformation DCR](./data-collection-transformations.md#workspace-transformation-dcr)
>
> See the documentation for other scenarios for any monitoring and troubleshooting information that may be available.

DCR diagnostic features include metrics and error logs emitted during log processing. [DCR metrics](#dcr-metrics) provide information about the volume of data being ingested, the number and nature of any processing errors, and statistics related to data transformation. [DCR error logs](#dcr-metrics) are generated any time data processing is not successful and the data doesn’t reach its destination.

## DCR Error Logs

Error logs are generated when data reaches the Azure Monitor ingestion pipeline but fails to reach its destination. Examples of error conditions include:

- Log delivery errors
- [Transformation](./data-collection-transformations.md) errors where the structure of the logs makes the transformation KQL invalid
- Log Ingestion API calls:
  - with any HTTP response other than 200/202
  - with payload containing malformed data
  - with payload over any [ingestion limits](/azure/azure-monitor/service-limits#logs-ingestion-api)
  - throttling due to overage of API call limits

To avoid excessive logging of persistent errors related to the same data flow, some errors will be logged only a limited number of times each hour followed by a summary error message. The error is then muted until the end of the hour. The number of times a given error is logged may vary depending on the region where DCR is deployed. 

Some log ingestion errors will not be logged because they can't be associated with a DCR. The following errors may not be logged:

- Failures caused by malformed call URI (HTTP response code 404)
- Certain internal server errors (HTTP response code 500)

### Enable DCR error logs
DCR error logs are implemented as [resource logs](./resource-logs.md) in Azure Monitor. Enable log collection by creating a [diagnostic setting](./diagnostic-settings.md) for the DCR. Each DCR will require its own diagnostic setting. See [Create diagnostic settings in Azure Monitor](./create-diagnostic-settings.md) for the detailed process. Select the category **Log Errors** and **Send to Log Analytics workspace**. You may want to select the same workspace that's used by the DCR, or you may want to consolidate all of your error logs in a single workspace.

:::image type="content" source="media/data-collection-monitor/diagnostic-settings.png" lightbox="media/data-collection-monitor/diagnostic-settings.png" alt-text="Screenshot that shows diagnostic settings for a DCR.":::

:::image type="content" source="media/data-collection-monitor/diagnostic-settings-detail.png" lightbox="media/data-collection-monitor/diagnostic-settings-detail.png" alt-text="Screenshot that shows detail of a diagnostic setting for a DCR.":::


### Retrieve DCR error logs
Error logs are written to the [DCRLogErrors](/azure/azure-monitor/reference/tables/dcrlogerrors) table in the Log Analytics workspace you specified in the diagnostic setting. Following are sample queries you can use in [Log Analytics](../logs/log-analytics-overview.md) to retrieve these logs.

**Retrieve all error logs for a particular DCR**

```kusto
DCRLogErrors
| where _ResourceId == "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
```

**Retrieve all error logs for a particular input stream in a particular DCR**

```kusto
DCRLogErrors
| where _ResourceId == "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/microsoft.insights/datacollectionrules/my-dcr"
| where InputStreamId == "Custom-MyTable_CL"
```


## DCR Metrics
DCR metrics are collected automatically for all DCRs, and you can analyze them using [metrics explorer](./analyze-metrics.md) like the platform metrics for other Azure resources. *Input stream* is included as a dimension so if you have a DCR with multiple input streams, you can analyze each by [filtering or splitting](./analyze-metrics.md#use-dimension-filters-and-splitting). Some metrics include other dimensions as shown in the table below.


| Metric | Dimensions | Description |
|---|---|---|
| Logs Ingestion Bytes per Min | Input Stream | Total number of bytes received per minute. |
| Logs Ingestion Requests per Min | Input stream<br>HTTP response code | Number of calls received per minute  |
| Logs Rows Dropped per Min | Input stream | Number of log rows dropped during processing per minute. This includes rows dropped both due to filtering criteria in KQL transformation and rows dropped due to errors. |
| Logs Rows Received per Min | Input stream | Number of log rows received for processing per minute. |
| Logs Transformation Duration per Min | Input stream | Average KQL transformation runtime per minute. Represents KQL transformation code efficiency. Data flows with longer transformation run time can experience delays in data processing and greater data latency. |
| Logs Transformation Errors per Min | Input stream<br>Error type | Number of processing errors encountered per minute |


## Monitoring your log ingestion

The following signals could be useful for monitoring the health of your log collection with DCRs. Create alert rules to identify these conditions.

| Signal | Possible causes and actions |
|---|---|
| New entries in `DCRErrorLogs` or  sudden change in `Log Transform Errors`. | - Problems with Log Ingestion API setup such as authentication, access to DCR or DCE, call payload issues.<br>- Changes in data structure causing KQL transformation failures.<br>- Changes in data destination configuration causing data delivery failures. |
| Sudden change in `Logs Ingestion Bytes per Min` | - Changes in configuration of log ingestion on the client, including AMA settings.<br>- Changes in structure of logs sent.|
| Sudden change in ratio between `Logs Ingestion Bytes per Min` and `Logs Rows Received per Min` | - Changes in the structure of logs sent. Examine the changes to make sure the data is properly processed with KQL transformation. |
| Sudden change in `Logs Transformation Duration per Min` | - Changes in the structure of logs affecting the efficiency of log filtering criteria set in KQL transformation. Examine the changes to make sure the data is properly processed with KQL transformation. |
| `Logs Ingestion Requests per Min` or `Logs Ingestion Bytes per Min` approaching Log Ingestion API service limits. | - Examine and optimize your DCR configuration to avoid throttling. |

## Alerts
Rather than reactively troubleshooting issues, create alert rules to be proactively notified when a potential error condition occurs. The following table provides examples of alert rules you can create to monitor your log ingestion.

| Condition | Alert details |
|:---|:---|
| Sudden changes of rows dropped | Metric alert rule using a dynamic threshold for `Logs Rows Dropped per Min`. |
| Number of API calls approaching service limits | Metric alert rule using a static threshold for `Logs Ingestion Requests per Min`. Set threshold near 12,000, which is the service limit for maximum requests/minute per DCR.  |
| Error logs | Log query alert using `DCRLogErrors`. Use a **Table rows** measure and **Threshold value** of **1** to be alerted whenever any errors are logged. |

## Next steps
- [Read more about data collection rules.](./data-collection-rule-overview.md)
- [Read more about ingestion-time transformations.](./data-collection-transformations.md)
