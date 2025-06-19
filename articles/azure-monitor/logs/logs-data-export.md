---
title: Log Analytics workspace data export in Azure Monitor
description: Log Analytics workspace data export in Azure Monitor lets you continuously export data per selected tables in your workspace. You can export to an Azure Storage Account or Azure Event Hubs as it's collected. 
ms.topic: how-to
ms.custom: references_regions, devx-track-azurecli, devx-track-azurepowershell
ms.reviewer: yossiy
ms.date: 03/06/2025
---

# Log Analytics workspace data export in Azure Monitor
Data export in a Log Analytics workspace lets you continuously export data per selected tables in your workspace. You can export to an Azure Storage Account or Azure Event Hubs as the data arrives to an Azure Monitor pipeline. This article provides details on this feature and steps to configure data export in your workspaces.

## Overview
Data in Log Analytics is available for the retention period defined in your workspace. It's used in various experiences provided in Azure Monitor and Azure services. There are cases where you need to use other tools:

* **Tamper-protected store compliance:** Data can't be altered in Log Analytics after it's ingested, but it can be purged. Export to a Storage Account set with [immutability policies](/azure/storage/blobs/immutable-policy-configure-version-scope) to keep data tamper protected.
* **Integration with Azure services and other tools:** Export to Event Hubs as data arrives and is processed in Azure Monitor.
* **Long-term retention of audit and security data:** Export to a Storage Account in the workspace's region. Or you can replicate data to other regions by using any of the [Azure Storage redundancy options](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region) including GRS and GZRS.

After you've configured data export rules in a Log Analytics workspace, new data for tables in rules is exported from the Azure Monitor pipeline to your Storage Account or Event Hubs as it arrives. Data export traffic is in Azure backbone network and doesn't leave the Azure network.

:::image type="content" source="media/logs-data-export/data-export-overview.png" lightbox="media/logs-data-export/data-export-overview.png" alt-text="Diagram that shows a data export flow.":::

Data is exported without a filter. For example, when you configure a data export rule for a *SecurityEvent* table, all data sent to the *SecurityEvent* table is exported starting from the configuration time. Alternatively, you can filter or modify exported data by configuring [transformations](./../essentials/data-collection-transformations.md) in your workspace, which apply to incoming data, before it's sent to your Log Analytics workspaces and to export destinations.

## Other export options
Log Analytics workspace data export continuously exports data that's sent to your Log Analytics workspace. There are other options to export data for particular scenarios:

- If an Azure resource is sending logs to your Log Analytics workspace through its diagnostic log settings already, consider updating the diagnostic settings on the Azure resource directly to add the new destination instead of regularly using a data export. This approach has lower latency compared to a data export but doesn't send historical data.
- Schedule an export of data based on a log query you define with the [Log Analytics query API](/rest/api/loganalytics/dataaccess/query/execute). Use Azure Data Factory, Azure Functions, or Azure Logic Apps to orchestrate queries in your workspace and export data to a destination. This method is similar to the data export feature, but you can use it to export historical data from your workspace by using filters and aggregation. This method is subject to [log query limits](../service-limits.md#log-analytics-workspaces) and isn't intended for scale. For more information, see [Export data from a Log Analytics workspace to a Storage Account by using Logic Apps](logs-export-logic-app.md).
- Use a one-time export to a local machine by using a PowerShell script. For more information, see [Invoke-AzOperationalInsightsQueryExport](https://www.powershellgallery.com/packages/Invoke-AzOperationalInsightsQueryExport).

## Permissions required

| Action | Permissions required |
| --- | --- |
| Create or update Data export rule | `Microsoft.OperationalInsights/workspaces/dataexports/write` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example |
| Delete Data export rule | `Microsoft.OperationalInsights/workspaces/dataexports/delete` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example |
| Export to Storage Account | `Microsoft.Storage/storageAccounts/blobServices/containers/write` permissions to the Storage Account, as provided by the Storage Account Contributor built-in role for example |
| Export to Event Hub | `Microsoft.EventHub/namespaces/eventhubs/write`, `Microsoft.EventHub/namespaces/eventhubs/messages/write`, `Microsoft.EventHub/namespaces/authorizationRules/listkeys/action` permissions to the Event Hub, as provided by the Azure Event Hubs Data Owner built-in roles for example |
| Query logs in a table | `Microsoft.OperationalInsights/workspaces/query/<table>/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |
| Query logs in a table (table action) | `Microsoft.OperationalInsights/workspaces/tables/query/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |

## Limitations

- Custom logs created using the [HTTP Data Collector API](./data-collector-api.md) can't be exported, including text-based logs consumed by Log Analytics agent. Custom logs created using [data collection rules](./logs-ingestion-api-overview.md), including text-based logs, can be exported.
- Data export will gradually support more tables. See [Unsupported tables](#unsupported-tables) section.
- The maximum number of active rules per workspace is 10, each can include multiple tables.
- The Storage Account must be unique across rules in the workspace.
- Supported table plans are Analytics and Basic. Auxiliary plan isn't supported.
- Destinations must be in the same region as the Log Analytics workspace.
- Export to Premium Storage Account isn't supported.

## Data completeness

Data export is optimized to move large data volumes to your destinations. In the event of a destination with insufficient scale or availability, a retry process continues for up to 12 hours and may a result in a fraction of the exported records duplicated. Follow the recommendations for [Storage Account](#storage-account) and [Event Hubs](#event-hubs) destinations to improve reliability. If the destinations are still unavailable after the retry period, the data is discarded.

For more information about destination limits and recommended alerts, see [Create or update a data export rule](#create-or-update-a-data-export-rule).

## Pricing model
Data export charges are based on the number of bytes exported to destinations in JSON formatted data, and measured in GB (10^9 bytes). Data export size calculations can't be done with a workspace query since the size calculation doesn't include the JSON formatting overhead. Use the method in this sample PowerShell script to [calculate the total billing size of a blob container](/azure/storage/scripts/storage-blobs-container-calculate-billing-size-powershell). There's currently no charge for export to sovereign clouds. A notification will be sent before enablement.

For more information, including the data export billing timeline, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/). Billing for Data Export was enabled in early October 2023. 

## Export destinations

The data export destination must be available before you create export rules in your workspace. Destinations can be in different subscriptions. With Azure Lighthouse, it's also possible to send data to destinations in another Microsoft Entra tenant.

### Storage Account

Prevent storage ingress failures due to latency or exceeding rate limits by using an existing Storage Account that doesn't have other non-monitoring data. This helps you better control access to the data and improves data export reliability.

To send data to an immutable Storage Account, set the immutable policy for the Storage Account as described in [Set and manage immutability policies for Azure Blob Storage](/azure/storage/blobs/immutable-policy-configure-version-scope). You must follow all steps in this article, including enabling protected append blobs writes.

The Storage Account can't be Premium, must be StorageV1 or later, and located in the same region as your workspace. If you need to replicate your data to other Storage Accounts in other regions, use any of the [Azure Storage redundancy options](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region), including GRS and GZRS.

Data is sent to Storage Accounts as it reaches Azure Monitor and exported to destinations located in a workspace region. A container is created for each table in the Storage Account with the name *am-* followed by the name of the table. For example, the table *SecurityEvent* would send to a container named *am-SecurityEvent*.

Blobs are stored in 5-minute folders in the following path structure: *WorkspaceResourceId=/subscriptions/subscription-id/resourcegroups/\<resource-group\>/providers/microsoft.operationalinsights/workspaces/\<workspace\>/y=\<four-digit numeric year\>/m=\<two-digit numeric month\>/d=\<two-digit numeric day\>/h=\<two-digit 24-hour clock hour\>/m=\<two-digit 60-minute clock minute\>/PT05M.json*. Appends to blobs are limited to 50-K writes. More blobs will be added in the folder as *PT05M_#.json**, where '#' is the incremental blob count.

> [!NOTE]
> Appends to blobs are written based on the "TimeGenerated" field and occur when receiving source data. Data arriving to Azure Monitor with delay, or retried following destinations throttling, is written to blobs according to its TimeGenerated.

The format of blobs in a Storage Account is in [JSON lines](/previous-versions/azure/azure-monitor/essentials/resource-logs-blob-format), where each record is delimited by a new line, with no outer records array and no commas between JSON records.

:::image type="content" source="media/logs-data-export/storage-data.png" lightbox="media/logs-data-export/storage-data.png" alt-text="Screenshot that shows data format in a blob.":::

### Event Hubs

Avoid using an Event Hub that has existing, non-monitoring data. This best practice helps prevent ingress failures due to latency or exceeding rate limits.

Data is sent to your Event Hub as it reaches Azure Monitor and is exported to destinations located in a workspace region. Create multiple export rules to the same Event Hub namespace by providing a different `Event Hub name` in the rule. When an `Event Hub name` isn't provided, a default Event Hub is created for tables that you export with the name *am-* followed by the name of the table. For example, the table *SecurityEvent* would be sent to an Event Hub named *am-SecurityEvent*.

The [number of supported Event Hubs in Basic and Standard namespace tiers is 10](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). When you're exporting more than 10 tables to these tiers, either split the tables between several export rules to different Event Hubs namespaces or provide an Event Hub name to export all tables to it.

> [!NOTE]
> - The Basic Event Hubs namespace tier is limited. It supports [lower event size](/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers) and no [Auto-inflate](/azure/event-hubs/event-hubs-auto-inflate) option to automatically scale up and increase the number of throughput units. Because data volume to your workspace increases over time and as a consequence Event Hub scaling is required, use Standard, Premium, or Dedicated Event Hubs tiers with the **Auto-inflate** feature enabled. For more information, see [Automatically scale up Azure Event Hubs throughput units](/azure/event-hubs/event-hubs-auto-inflate).
> - Data export can't reach Event Hubs resources when virtual networks are enabled. You have to select the **Allow Azure services on the trusted services list to access this Storage Account** checkbox to bypass this firewall setting in an Event Hub to grant access to your Event Hubs.

## Query exported data

Exporting data from workspaces to Storage Accounts help satisfy various scenarios mentioned in [overview](#overview), and can be consumed by tools that can read blobs from Storage Accounts. The following methods let you query data using Log Analytics query language, which is the same for Azure Data Explorer.
1. Use Azure Data Explorer to [query data in Azure Data Lake](/azure/data-explorer/data-lake-query-data).
2. Use Azure Data Explorer to [ingest data from a Storage Account](/azure/data-explorer/ingest-from-container).
3. Use Log Analytics workspace to query [ingested data using Logs Ingestion API ](./logs-ingestion-api-overview.md). Ingested data is sent to a custom log table and not to the original table.
   

## Enable data export
The following steps must be performed to enable Log Analytics data export.

- [Register the resource provider](#register-the-resource-provider)
- [Allow trusted Microsoft services](#allow-trusted-microsoft-services)
- [Monitor destinations](#monitor-destinations) (Recommended)
- [Create or update a data export rule](#create-or-update-a-data-export-rule)

### Register the resource provider
The Azure resource provider **Microsoft.Insights** needs to be registered in your subscription to enable Log Analytics data export.

This resource provider is probably already registered for most Azure Monitor users. To verify, go to **Subscriptions** in the Azure portal. Select your subscription and then select **Resource providers** under the **Settings** section of the menu. Locate **Microsoft.Insights**. If its status is **Registered**, then it's already registered. If not, select **Register** to register it.

You can also use any of the available methods to register a resource provider as described in [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types). The following sample command uses the Azure CLI:

```azurecli
az provider register --namespace 'Microsoft.insights'
```

The following sample command uses PowerShell:

```PowerShell
Register-AzResourceProvider -ProviderNamespace Microsoft.insights
```

### Allow trusted Microsoft services
If you've configured your Storage Account to allow access from selected networks, you need to add an exception to allow Azure Monitor to write to the account. From **Firewalls and virtual networks** for your Storage Account, select **Allow Azure services on the trusted services list to access this Storage Account**.
<!-- convertborder later -->
:::image type="content" source="media/logs-data-export/storage-account-network.png" lightbox="media/logs-data-export/storage-account-network.png" alt-text="Screenshot that shows the option Allow Azure services on the trusted services list." border="false":::

### Monitor destinations

> [!IMPORTANT]
> Export destinations have limits and should be monitored to minimize throttling, failures, and latency. For more information, see [Storage Account scalability](/azure/storage/common/scalability-targets-standard-account#scale-targets-for-standard-storage-accounts) and [Event Hubs namespace quotas](/azure/event-hubs/event-hubs-quotas).

The following metrics are available for data export operation and alerts

| Metric name	| Description |
|:---|:---|
| Bytes Exported | Total number of bytes exported to destination from Log Analytics workspace within the selected time range. The size of data exported is the number of bytes in the exported JSON formatted data. 1 GB = 10^9 bytes. |
| Export Failures	| Total number of failed export requests to destination from Log Analytics workspace within the selected time range. This number includes export attempts failures due to destination resource throttling, forbidden access error, or any server error. A retry process handles failed attempts and the number isn't an indication for missing data. |
| Records exported | Total number of records exported from Log Analytics workspace within the selected time range. This number counts records for operations that ended with success. |


#### Monitor a Storage Account

1. Use a separate Storage Account for export.
1. Configure an alert on the metric:

    | Scope | Metric namespace | Metric | Aggregation | Threshold |
    |:---|:---|:---|:---|:---|
    | storage-name | Account | Ingress | Sum | 80% of maximum ingress per alert evaluation period. For example, the limit is 60 Gbps for general-purpose v2 in West US. The alert threshold is 1676 GiB per 5-minute evaluation period. |
  
1. Alert remediation actions:
    - Use a separate Storage Account for export that isn't shared with non-monitoring data.
    - Azure Storage Standard accounts support higher ingress limit by request. To request an increase, contact [Azure Support](https://azure.microsoft.com/support/faq/).
    - Split tables between more Storage Accounts.

#### Monitor Event Hubs

1. Configure alerts on the [metrics](/azure/event-hubs/monitor-event-hubs-reference):
  
    | Scope | Metric namespace | Metric | Aggregation | Threshold |
    |:---|:---|:---|:---|:---|
    | namespaces-name | Event Hubs standard metrics | Incoming bytes | Sum | 80% of maximum ingress per alert evaluation period. For example, the limit is 1 MB/s per unit (TU or PU) and five units used. The threshold is 228 MiB per 5-minute evaluation period. |
    | namespaces-name | Event Hubs standard metrics | Incoming requests | Count | 80% of maximum events per alert evaluation period. For example, the limit is 1,000/s per unit (TU or PU) and five units used. The threshold is 1,200,000 per 5-minute evaluation period. |
    | namespaces-name | Event Hubs standard metrics | Quota exceeded errors | Count | Between 1% of request. For example, requests per 5 minutes is 600,000. The threshold is 6,000 per 5-minute evaluation period. |

1. Alert remediation actions:
   - Use a separate Event Hubs namespace for export that isn't shared with non-monitoring data.
   - Configure the [Auto-inflate](/azure/event-hubs/event-hubs-auto-inflate) feature to automatically scale up and increase the number of throughput units to meet usage needs.
   - Verify the increase of throughput units to accommodate data volume.
   - Split tables between more namespaces.
   - Use Premium or Dedicated tiers for higher throughput.

### Create or update a data export rule
A data export rule defines the destination and tables for which data is exported. The rule provisioning takes about 30 minutes before the export operation initiated. Data export rules considerations:
- The Storage Account must be unique across rules in the workspace.
- Multiple rules can use the same Event Hubs namespace when you're sending to separate Event Hubs.
- Export to a Storage Account: A separate container is created in the Storage Account for each table.
- Export to Event Hubs: If an Event Hub name isn't provided, a separate Event Hub is created for each table. The [number of supported Event Hubs in Basic and Standard namespace tiers is 10](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). When you're exporting more than 10 tables to these tiers, either split the tables between several export rules to different Event Hubs namespaces or provide an Event Hub name in the rule to export all tables to it.

# [Azure portal](#tab/portal)

1. On the **Log Analytics workspace** menu in the Azure portal, select **Data Export** under the **Settings** section. Select **New export rule** at the top of the pane.

   :::image type="content" source="media/logs-data-export/export-create-1.png" lightbox="media/logs-data-export/export-create-1.png" alt-text="Screenshot that shows the data export entry point.":::

1. Follow the steps, and then select **Create**. Only the tables with data in them are displayed under "Source" tab.
   <!-- convertborder later -->
   :::image type="content" source="media/logs-data-export/export-create-2.png" lightbox="media/logs-data-export/export-create-2.png" alt-text="Screenshot of export rule configuration." border="false":::

# [PowerShell](#tab/powershell)

Use the following command to create a data export rule to a Storage Account by using PowerShell. A separate container is created for each table.

```powershell
$storageAccountResourceId = '/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.Storage/storageAccounts/storage-account-name'
New-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName -DataExportName 'ruleName' -TableName 'SecurityEvent,Heartbeat' -ResourceId $storageAccountResourceId
```

Use the following command to create a data export rule to a specific Event Hub by using PowerShell. All tables are exported to the provided Event Hub name and can be filtered by the **Type** field to separate tables.

```powershell
$eventHubResourceId = '/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.EventHub/namespaces/namespaces-name/eventhubs/eventhub-name'
New-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName -DataExportName 'ruleName' -TableName 'SecurityEvent,Heartbeat' -ResourceId $eventHubResourceId -EventHubName EventhubName
```

Use the following command to create a data export rule to an Event Hub by using PowerShell. When a specific Event Hub name isn't provided, a separate container is created for each table, up to the [number of Event Hubs supported in each Event Hubs tier](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). To export more tables, provide an Event Hub name in the rule. Or you can set another rule and export the remaining tables to another Event Hubs namespace.

```powershell
$eventHubResourceId = '/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.EventHub/namespaces/namespaces-name'
New-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName -DataExportName 'ruleName' -TableName 'SecurityEvent,Heartbeat' -ResourceId $eventHubResourceId
```

# [Azure CLI](#tab/azure-cli)

Use the following command to create a data export rule to a Storage Account by using the CLI. A separate container is created for each table.

```azurecli
$storageAccountResourceId = '/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.Storage/storageAccounts/storage-account-name'
az monitor log-analytics workspace data-export create --resource-group resourceGroupName --workspace-name workspaceName --name ruleName --tables SecurityEvent Heartbeat --destination $storageAccountResourceId
```

Use the following command to create a data export rule to a specific Event Hub by using the CLI. All tables are exported to the provided Event Hub name and can be filtered by the **Type** field to separate tables.

```azurecli
$eventHubResourceId = '/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.EventHub/namespaces/namespaces-name/eventhubs/eventhub-name'
az monitor log-analytics workspace data-export create --resource-group resourceGroupName --workspace-name workspaceName --name ruleName --tables SecurityEvent Heartbeat --destination $eventHubResourceId
```

Use the following command to create a data export rule to an Event Hub by using the CLI. When a specific Event Hub name isn't provided, a separate container is created for each table up to the [number of supported Event Hubs for your Event Hubs tier](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). If you have more tables to export, provide an Event Hub name to export any number of tables. Or you can set another rule to export the remaining tables to another Event Hubs namespace.

```azurecli
$eventHubsNamespacesResourceId = '/subscriptions/subscription-id/resourceGroups/resource-group-name/providers/Microsoft.EventHub/namespaces/namespaces-name'
az monitor log-analytics workspace data-export create --resource-group resourceGroupName --workspace-name workspaceName --name ruleName --tables SecurityEvent Heartbeat --destination $eventHubsNamespacesResourceId
```

# [REST](#tab/rest)

Use the following request to create a data export rule to a Storage Account by using the REST API. A separate container is created for each table. The request should use bearer token authorization and content type application/json.

```rest
PUT https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.operationalInsights/workspaces/<workspace-name>/dataexports/<data-export-name>?api-version=2023-09-01
```

The body of the request specifies the table's destination. The following example is a sample body for the REST request.

```json
{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/subscription-id/resourcegroups/resource-group-name/providers/Microsoft.Storage/storageAccounts/storage-account-name"
        },
        "tablenames": [
            "table1",
            "table2" 
        ],
        "enable": true
    }
}
```

The following example is a sample body for the REST request for an Event Hub.

```json
{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/subscription-id/resourcegroups/resource-group-name/providers/Microsoft.EventHub/namespaces/eventhub-namespaces-name"
        },
        "tablenames": [
            "table1",
            "table2"
        ],
        "enable": true
    }
}
```

The following example is a sample body for the REST request for an Event Hub where the Event Hub name is provided. In this case, all exported data is sent to it.

```json
{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/subscription-id/resourcegroups/resource-group-name/providers/Microsoft.EventHub/namespaces/eventhub-namespaces-name",
            "metaData": {
                "EventHubName": "eventhub-name"
        },
        "tablenames": [
            "table1",
            "table2"
        ],
        "enable": true
    }
  }
}
```

# [Template](#tab/json)

Use the following command to create a data export rule to a Storage Account by using an Azure Resource Manager template.

```
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workspaceName": {
            "defaultValue": "workspace-name",
            "type": "String"
        },
        "workspaceLocation": {
            "defaultValue": "workspace-region",
            "type": "string"
        },
        "storageAccountRuleName": {
            "defaultValue": "storage-account-rule-name",
            "type": "string"
        },
        "storageAccountResourceId": {
            "defaultValue": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/resource-group-name/providers/Microsoft.Storage/storageAccounts/storage-account-name",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.operationalinsights/workspaces",
            "apiVersion": "2023-09-01",
            "name": "[parameters('workspaceName')]",
            "location": "[parameters('workspaceLocation')]",
            "resources": [
                {
                  "type": "microsoft.operationalinsights/workspaces/dataexports",
                  "apiVersion": "2023-09-01",
                  "name": "[concat(parameters('workspaceName'), '/' , parameters('storageAccountRuleName'))]",
                  "dependsOn": [
                      "[resourceId('microsoft.operationalinsights/workspaces', parameters('workspaceName'))]"
                  ],
                  "properties": {
                      "destination": {
                          "resourceId": "[parameters('storageAccountResourceId')]"
                      },
                      "tableNames": [
                          "Heartbeat",
                          "InsightsMetrics",
                          "VMConnection",
                          "Usage"
                      ],
                      "enable": true
                  }
              }
            ]
        }
    ]
}
```

Use the following command to create a data export rule to an Event Hub by using a Resource Manager template. A separate Event Hub is created for each table.

```
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workspaceName": {
            "defaultValue": "workspace-name",
            "type": "String"
        },
        "workspaceLocation": {
            "defaultValue": "workspace-region",
            "type": "string"
        },
        "eventhubRuleName": {
            "defaultValue": "event-hub-rule-name",
            "type": "string"
        },
        "namespacesResourceId": {
            "defaultValue": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/resource-group-name/providers/microsoft.eventhub/namespaces/namespaces-name",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.operationalinsights/workspaces",
            "apiVersion": "2023-09-01",
            "name": "[parameters('workspaceName')]",
            "location": "[parameters('workspaceLocation')]",
            "resources": [
              {
                  "type": "microsoft.operationalinsights/workspaces/dataexports",
                  "apiVersion": "2023-09-01",
                  "name": "[concat(parameters('workspaceName'), '/', parameters('eventhubRuleName'))]",
                  "dependsOn": [
                      "[resourceId('microsoft.operationalinsights/workspaces', parameters('workspaceName'))]"
                  ],
                  "properties": {
                      "destination": {
                          "resourceId": "[parameters('namespacesResourceId')]"
                      },
                      "tableNames": [
                          "Usage",
                          "Heartbeat"
                      ],
                      "enable": true
                  }
              }
            ]
        }
    ]
}
```

Use the following command to create a data export rule to a specific Event Hub by using a Resource Manager template. All tables are exported to it.

```
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "workspaceName": {
            "defaultValue": "workspace-name",
            "type": "String"
        },
        "workspaceLocation": {
            "defaultValue": "workspace-region",
            "type": "string"
        },
        "eventhubRuleName": {
            "defaultValue": "event-hub-rule-name",
            "type": "string"
        },
        "namespacesResourceId": {
            "defaultValue": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/resource-group-name/providers/microsoft.eventhub/namespaces/namespaces-name",
            "type": "String"
        },
        "eventhubName": {
            "defaultValue": "event-hub-name",
            "type": "string"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.operationalinsights/workspaces",
            "apiVersion": "2023-09-01",
            "name": "[parameters('workspaceName')]",
            "location": "[parameters('workspaceLocation')]",
            "resources": [
              {
                  "type": "microsoft.operationalinsights/workspaces/dataexports",
                  "apiVersion": "2023-09-01",
                  "name": "[concat(parameters('workspaceName'), '/', parameters('eventhubRuleName'))]",
                  "dependsOn": [
                      "[resourceId('microsoft.operationalinsights/workspaces', parameters('workspaceName'))]"
                  ],
                  "properties": {
                      "destination": {
                          "resourceId": "[parameters('namespacesResourceId')]",
                          "metaData": {
                              "eventHubName": "[parameters('eventhubName')]"
                          }
                      },
                      "tableNames": [
                          "Usage",
                          "Heartbeat"
                      ],
                      "enable": true
                  }
              }
            ]
        }
    ]
}
```


---

## View data export rule configuration

# [Azure portal](#tab/portal)

1. On the **Log Analytics workspace** menu in the Azure portal, select **Data Export** under the **Settings** section.

   :::image type="content" source="media/logs-data-export/export-view-1.png" lightbox="media/logs-data-export/export-view-1.png" alt-text="Screenshot that shows the Data Export screen.":::

1. Select a rule for a configuration view.
   <!-- convertborder later -->
   :::image type="content" source="media/logs-data-export/export-view-2.png" lightbox="media/logs-data-export/export-view-2.png" alt-text="Screenshot of data export rule view." border="false":::

# [PowerShell](#tab/powershell)

Use the following command to view the configuration of a data export rule by using PowerShell.

```powershell
Get-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName -DataExportName 'ruleName'
```

# [Azure CLI](#tab/azure-cli)

Use the following command to view the configuration of a data export rule by using the CLI.

```azurecli
az monitor log-analytics workspace data-export show --resource-group resourceGroupName --workspace-name workspaceName --name ruleName
```

# [REST](#tab/rest)

Use the following request to view the configuration of a data export rule by using the REST API. The request should use bearer token authorization.

```rest
GET https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.operationalInsights/workspaces/<workspace-name>/dataexports/<data-export-name>?api-version=2023-09-01
```

# [Template](#tab/json)

The template option doesn't apply.

---

## Disable or update an export rule

# [Azure portal](#tab/portal)

You can disable export rules to stop the export for a certain period, such as when testing is being held. On the **Log Analytics workspace** menu in the Azure portal, select **Data Export** under the **Settings** section. Select the **Status** toggle to disable or enable the export rule.

:::image type="content" source="media/logs-data-export/export-disable.png" lightbox="media/logs-data-export/export-disable.png" alt-text="Screenshot that shows disabling the data export rule.":::

# [PowerShell](#tab/powershell)

You can disable export rules to stop the export for a certain period, such as when testing is being held. Use the following command to disable or update rule parameters by using PowerShell.

```powershell
Update-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName -DataExportName 'ruleName' -TableName 'SecurityEvent,Heartbeat' -Enable: $false
```

# [Azure CLI](#tab/azure-cli)

You can disable export rules to stop the export for a certain period, such as when testing is being held. Use the following command to disable or update rule parameters by using the CLI.

```azurecli
az monitor log-analytics workspace data-export update --resource-group resourceGroupName --workspace-name workspaceName --name ruleName --tables SecurityEvent Heartbeat --enable false
```

# [REST](#tab/rest)

You can disable export rules to stop the export for a certain period, such as when testing is being held. Use the following command to disable or update rule parameters by using the REST API. The request should use bearer token authorization.

```rest
PUT https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.operationalInsights/workspaces/<workspace-name>/dataexports/<data-export-name>?api-version=2023-09-01
Authorization: Bearer <token>
Content-type: application/json

{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/subscription-id/resourcegroups/resource-group-name/providers/Microsoft.Storage/storageAccounts/storage-account-name"
        },
        "tablenames": [
"table1",
    "table2" 
        ],
        "enable": false
    }
}
```

# [Template](#tab/json)

You can disable export rules to stop export when testing is performed and you don't need data sent to a destination. Set ```"enable": false``` in the template to disable a data export.

---

## Delete an export rule

# [Azure portal](#tab/portal)

On the **Log Analytics workspace** menu in the Azure portal, select **Data Export** under the **Settings** section. Select the ellipsis to the right of the rule and select **Delete**.

:::image type="content" source="media/logs-data-export/export-delete.png" lightbox="media/logs-data-export/export-delete.png" alt-text="Screenshot that shows deleting the data export rule.":::

# [PowerShell](#tab/powershell)

Use the following command to delete a data export rule by using PowerShell.

```powershell
Remove-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName -DataExportName 'ruleName'
```

# [Azure CLI](#tab/azure-cli)

Use the following command to delete a data export rule by using the CLI.

```azurecli
az monitor log-analytics workspace data-export delete --resource-group resourceGroupName --workspace-name workspaceName --name ruleName
```

# [REST](#tab/rest)

Use the following request to delete a data export rule by using the REST API. The request should use bearer token authorization.

```rest
DELETE https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.operationalInsights/workspaces/<workspace-name>/dataexports/<data-export-name>?api-version=2023-09-01
```

# [Template](#tab/json)

The template option doesn't apply.

---

## View all data export rules in a workspace

# [Azure portal](#tab/portal)

On the **Log Analytics workspace** menu in the Azure portal, select **Data Export** under the **Settings** section to view all export rules in the workspace.

:::image type="content" source="media/logs-data-export/export-view.png" lightbox="media/logs-data-export/export-view.png" alt-text="Screenshot that shows the data export rules view.":::

# [PowerShell](#tab/powershell)

Use the following command to view all the data export rules in a workspace by using PowerShell.

```powershell
Get-AzOperationalInsightsDataExport -ResourceGroupName resourceGroupName -WorkspaceName workspaceName
```

# [Azure CLI](#tab/azure-cli)

Use the following command to view all data export rules in a workspace by using the CLI.

```azurecli
az monitor log-analytics workspace data-export list --resource-group resourceGroupName --workspace-name workspaceName
```

# [REST](#tab/rest)

Use the following request to view all data export rules in a workspace by using the REST API. The request should use bearer token authorization.

```rest
GET https://management.azure.com/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/Microsoft.operationalInsights/workspaces/<workspace-name>/dataexports?api-version=2023-09-01
```

# [Template](#tab/json)

The template option doesn't apply.

---

## Unsupported tables

> [!NOTE]
> If the data export rule includes an unsupported table, the configuration will succeed, but no data will be exported for that table. When table is supported, data export will start then. We are in a process of adding support for more tables. Please check this article regularly.

| Table | Limitations |
|---|---|
| ADXDataOperation |  |
| Alert | Partial support. Data ingestion for Zabbix alerts isn't supported. |
| AlertHistory |  |
| AzureActivity | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| AzureDiagnostics |  |
| AzureMetrics |  |
| ConfigurationChange |  |
| ConfigurationData | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| DatabricksDatabricksSQL |  |
| DatabricksSQL |  |
| DeviceAppLaunch |  |
| DeviceCalendar |  |
| DeviceConnectSession |  |
| DeviceEtw |  |
| DeviceHealth |  |
| DeviceHeartbeat |  |
| ETWEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| Event | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| InsightsMetrics | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| NetworkSessions |  |
| Operation | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| ProtectionStatus |  |
| ServiceFabricOperationalEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| ServiceFabricReliableActorEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| ServiceFabricReliableServiceEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| Update | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| VMBoundPort |  |
| VMComputer |  |
| VMConnection |  |
| VMProcess |  |
| W3CIISLog | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| WireData | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |


## Next steps

[Query the exported data from Azure Data Explorer](../logs/azure-data-explorer-query-storage.md)
