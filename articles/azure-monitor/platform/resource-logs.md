---
title: Resource logs in Azure Monitor
description: Learn how to send Azure resource logs to a Log Analytics workspace, event hub, or Azure Storage in Azure Monitor.
ms.topic: how-to
ms.date: 09/30/2024
ms.reviewer: lualderm
---

# Resource logs in Azure Monitor

Azure resource logs provide insight into operations that are performed in an Azure resource. The content of resource logs is different for each resource type. They can include information about the operations performed on the resource, the status of those operations, and other details that help you understand the health and performance of the resource.

Resource logs aren't collected by default. To collect them, you must create a diagnostic setting for each Azure resource. See [Diagnostic settings in Azure Monitor](diagnostic-settings.md) for details on creating diagnostic settings. The information below provides further details on the different destinations resources logs can be sent to.

> [!IMPORTANT]
> There is a cost to collecting resource logs. The cost depends on the destination you choose and the volume of data collected. For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## [Log Analytics workspace](#tab/log-analytics)

Send resource logs to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md), which offers the following benefits:

- Correlate resource logs with other log data using [log queries](../logs/log-query-overview.md). 
- Create [log alerts](../alerts/alerts-create-log-alert-rule.md) from resource log entries.
- Access resource log data with [Power BI](/power-bi/transform-model/log-analytics/desktop-log-analytics-overview).


[Create a diagnostic setting](../essentials/diagnostic-settings.md) to send resource logs to a Log Analytics workspace. This data is stored in tables as described in [Structure of Azure Monitor Logs](../logs/data-platform-logs.md). The tables used by resource logs depend on what the resource type and the type of collection the resource is using. There are two types of collection modes for resource logs:

* **Azure diagnostics**: All data is written to the [AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics) table.
* **Resource-specific**: Data is written to individual tables for each category of the resource.

### Resource-specific

For logs using resource-specific mode, individual tables in the selected workspace are created for each log category selected in the diagnostic setting.
Resource-specific logs have the following advantages over Azure diagnostics logs:

* Makes it easier to work with the data in log queries.
* Provides better discoverability of schemas and their structure.
* Improves performance across ingestion latency and query times.
* Provides the ability to grant Azure role-based access control rights on a specific table.

For a description of resource-specific logs and tables, see [Supported Resource log categories for Azure Monitor](/azure/azure-monitor/reference/logs-index)

### Azure diagnostics mode

In Azure diagnostics mode, all data from any diagnostic setting is collected in the [AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics) table. This legacy method is used today by a minority of Azure services. Because multiple resource types send data to the same table, its schema is the superset of the schemas of all the different data types being collected. For details on the structure of this table and how it works with this potentially large number of columns, see [AzureDiagnostics reference](/azure/azure-monitor/reference/tables/azurediagnostics).

The AzureDiagnostics table contains the resourceId of the resource that generated the log, the category of the log, and the time the log was generated as well as resource specific properties.

:::image type="content" source="media/resource-logs/azure-diagnostics-table.png" lightbox="media/resource-logs/azure-diagnostics-table.png" alt-text="A screenshot showing the AzureDiagnostics table in a Log Analytics workspace.":::

### Select the collection mode

Most Azure resources write data to the workspace in either **Azure diagnostics** or **resource-specific** mode without giving you a choice. For more information, see [Common and service-specific schemas for Azure resource logs](resource-logs-schema.md).

All Azure services will eventually use the resource-specific mode. As part of this transition, some resources allow you to select a mode in the diagnostic setting. Specify resource-specific mode for any new diagnostic settings because this mode makes the data easier to manage. It also might help you avoid complex migrations later.

:::image type="content" source="media/resource-logs/diagnostic-settings-mode-selector.png" lightbox="media/resource-logs/diagnostic-settings-mode-selector.png" alt-text="Screenshot that shows the Diagnostics settings mode selector.":::

> [!NOTE]
> For an example that sets the collection mode by using an Azure Resource Manager template, see [Resource Manager template samples for diagnostic settings in Azure Monitor](resource-manager-diagnostic-settings.md#diagnostic-setting-for-recovery-services-vault).

You can modify an existing diagnostic setting to resource-specific mode. In this case, data that was already collected remains in the `AzureDiagnostics` table until it's removed according to your retention setting for the workspace. New data is collected in the dedicated table. Use the [union](/azure/kusto/query/unionoperator) operator to query data across both tables.

Continue to watch the [Azure Updates](https://azure.microsoft.com/updates/) blog for announcements about Azure services that support resource-specific mode.

## Send to Azure Event Hubs

Send resource logs to an event hub to send them outside of Azure. For example, resource logs might be sent to a third-party SIEM or other log analytics solutions. Resource logs from event hubs are consumed in JSON format with a `records` element that contains the records in each payload. The schema depends on the resource type as described in [Common and service-specific schema for Azure resource logs](resource-logs-schema.md).

The following sample output data is from Azure Event Hubs for a resource log:

```json
{
    "records": [
        {
            "time": "2019-07-15T18:00:22.6235064Z",
            "workflowId": "/SUBSCRIPTIONS/AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E/RESOURCEGROUPS/JOHNKEMTEST/PROVIDERS/MICROSOFT.LOGIC/WORKFLOWS/JOHNKEMTESTLA",
            "resourceId": "/SUBSCRIPTIONS/AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E/RESOURCEGROUPS/JOHNKEMTEST/PROVIDERS/MICROSOFT.LOGIC/WORKFLOWS/JOHNKEMTESTLA/RUNS/08587330013509921957/ACTIONS/SEND_EMAIL",
            "category": "WorkflowRuntime",
            "level": "Error",
            "operationName": "Microsoft.Logic/workflows/workflowActionCompleted",
            "properties": {
                "$schema": "2016-04-01-preview",
                "startTime": "2016-07-15T17:58:55.048482Z",
                "endTime": "2016-07-15T18:00:22.4109204Z",
                "status": "Failed",
                "code": "BadGateway",
                "resource": {
                    "subscriptionId": "AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E",
                    "resourceGroupName": "JohnKemTest",
                    "workflowId": "2222cccc-33dd-eeee-ff44-aaaaaa555555",
                    "workflowName": "JohnKemTestLA",
                    "runId": "08587330013509921957",
                    "location": "westus",
                    "actionName": "Send_email"
                },
                "correlation": {
                    "actionTrackingId": "3333dddd-44ee-ffff-aa55-bbbbbbbb6666",
                    "clientTrackingId": "08587330013509921958"
                }
            }
        },
        {
            "time": "2019-07-15T18:01:15.7532989Z",
            "workflowId": "/SUBSCRIPTIONS/AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E/RESOURCEGROUPS/JOHNKEMTEST/PROVIDERS/MICROSOFT.LOGIC/WORKFLOWS/JOHNKEMTESTLA",
            "resourceId": "/SUBSCRIPTIONS/AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E/RESOURCEGROUPS/JOHNKEMTEST/PROVIDERS/MICROSOFT.LOGIC/WORKFLOWS/JOHNKEMTESTLA/RUNS/08587330012106702630/ACTIONS/SEND_EMAIL",
            "category": "WorkflowRuntime",
            "level": "Information",
            "operationName": "Microsoft.Logic/workflows/workflowActionStarted",
            "properties": {
                "$schema": "2016-04-01-preview",
                "startTime": "2016-07-15T18:01:15.5828115Z",
                "status": "Running",
                "resource": {
                    "subscriptionId": "AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E",
                    "resourceGroupName": "JohnKemTest",
                    "workflowId": "dddd3333-ee44-5555-66ff-777777aaaaaa",
                    "workflowName": "JohnKemTestLA",
                    "runId": "08587330012106702630",
                    "location": "westus",
                    "actionName": "Send_email"
                },
                "correlation": {
                    "actionTrackingId": "ffff5555-aa66-7777-88bb-999999cccccc",
                    "clientTrackingId": "08587330012106702632"
                }
            }
        }
    ]
}
```

## Send to Azure Storage

Send resource logs to Azure Storage to retain them for archiving. After you've created the diagnostic setting, a storage container is created in the storage account as soon as an event occurs in one of the enabled log categories.

> [!NOTE]
> An alternate to archiving is to send the resource log to a table in your Log Analytics workspace with [low-cost, long-term retention](../logs/data-retention-configure.md).

The blobs within the container use the following naming convention:

```
insights-logs-{log category name}/resourceId=/SUBSCRIPTIONS/{subscription ID}/RESOURCEGROUPS/{resource group name}/PROVIDERS/{resource provider name}/{resource type}/{resource name}/y={four-digit numeric year}/m={two-digit numeric month}/d={two-digit numeric day}/h={two-digit 24-hour clock hour}/m=00/PT1H.json
```

The blob for a network security group might have a name similar to this example:

```
insights-logs-networksecuritygrouprulecounter/resourceId=/SUBSCRIPTIONS/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/RESOURCEGROUPS/TESTRESOURCEGROUP/PROVIDERS/MICROSOFT.NETWORK/NETWORKSECURITYGROUP/TESTNSG/y=2016/m=08/d=22/h=18/m=00/PT1H.json
```

Each PT1H.json blob contains a JSON object with events from log files that were received during the hour specified in the blob URL. During the present hour, events are appended to the PT1H.json file as they're received, regardless of when they were generated. The minute value in the URL, `m=00` is always `00` as blobs are created on a per hour basis.

Within the PT1H.json file, each event is stored in the following format. It uses a common top-level schema but is unique for each Azure service, as described in [Resource logs schema](resource-logs-schema.md).

> [!NOTE]
> Logs are written to blobs based on the time that the log was received, regardless of the time it was generated. This means that a given blob can contain log data that is outside the hour specified in the blob's URL. Where a data source like Application insights, supports uploading stale telemetry a blob can contain data from the previous 48 hours.
> At the start of a new hour, it is possible that existing logs are still being written to the previous hour's blob while new logs are written to the new hour's blob.

```json
{"time": "2016-07-01T00:00:37.2040000Z","systemId": "a0a0a0a0-bbbb-cccc-dddd-e1e1e1e1e1e1","category": "NetworkSecurityGroupRuleCounter","resourceId": "/SUBSCRIPTIONS/AAAA0A0A-BB1B-CC2C-DD3D-EEEEEE4E4E4E/RESOURCEGROUPS/TESTRESOURCEGROUP/PROVIDERS/MICROSOFT.NETWORK/NETWORKSECURITYGROUPS/TESTNSG","operationName": "NetworkSecurityGroupCounters","properties": {"vnetResourceGuid": "{aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e}","subnetPrefix": "10.3.0.0/24","macAddress": "000123456789","ruleName": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/testresourcegroup/providers/Microsoft.Network/networkSecurityGroups/testnsg/securityRules/default-allow-rdp","direction": "In","type": "allow","matchedConnections": 1988}}
```

## Azure Monitor partner integrations

Resource logs can also be sent to partner solutions that are fully integrated into Azure. For a list of these solutions and details on how to configure them, see [Azure Monitor partner integrations](/azure/partner-solutions/overview).

## Next steps

* [Read more about resource logs](../fundamentals/data-sources.md).
* [Create diagnostic settings to send platform logs and metrics to different destinations](diagnostic-settings.md).
