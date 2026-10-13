---
title: Log Analytics Data Export Rules in Azure Monitor
description: Log Analytics data export rules in Azure Monitor let you continuously export data per selected tables in your workspace. You can export to an Azure Blob Storage account or Azure Event Hubs as it's collected.
ms.topic: how-to
ms.custom: references_regions, devx-track-azurecli, devx-track-azurepowershell, cbo-v1.6
ms.reviewer: yossiy
ms.date: 02/16/2026
ai-usage: ai-assisted
---

# Log Analytics data export rules in Azure Monitor
Data export rules in a Log Analytics workspace let you continuously export data per selected tables. Export to an Azure Blob Storage account or Azure Event Hubs as the data arrives to Azure Monitor. This article provides details on this feature and steps to configure data export rules in your workspaces.

## Overview
Data in Log Analytics is available for the retention period defined in your workspace. It's used in various experiences provided in Azure Monitor and Azure services. There are cases where you need to use other tools:

* **Tamper-protected store compliance:** Data can't be altered in Log Analytics after ingestion, but it can be purged. Export to a storage account set with [immutability policies](/azure/storage/blobs/immutable-policy-configure-version-scope) to keep data tamper protected.
* **Integration with Azure services and other tools:** Export to Event Hubs as data arrives and is processed in Azure Monitor.
* **Long-term retention of audit and security data:** Export to a storage account in the workspace's region. Replicate data to other regions by using any of the [Azure Storage redundancy options](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region) including GRS and GZRS.

After you configure data export rules in a Log Analytics workspace, new data for tables in rules is exported from the Azure Monitor pipeline to your storage account or Event Hubs as it arrives. Data export traffic is in the Azure backbone network and doesn't leave the Azure network.

:::image type="content" source="media/logs-data-export/data-export-overview.png" lightbox="media/logs-data-export/data-export-overview.png" alt-text="Diagram that shows a data export flow.":::

Data is exported without a filter. For example, when you configure a data export rule for a *SecurityEvent* table, all data sent to the *SecurityEvent* table is exported starting from the configuration time. Alternatively, filter or modify exported data by configuring [transformations](../data-collection/data-collection-transformations.md) in your workspace. Transformations apply to incoming data before the data is sent to your Log Analytics workspace and to export destinations.

## Other export options
Log Analytics data export rules continuously export data that's sent to your Log Analytics workspace. Other options export data for these particular scenarios:

* To export historical records from a single table by query and time range to Azure Blob Storage, run an [export job (Preview)](export-job.md). An export job is purpose-built for on-demand export of historical data at scale and writes results in Parquet format.
* If an Azure resource is sending logs to your Log Analytics workspace through its diagnostic log settings already, consider updating the diagnostic settings on the Azure resource directly to add the new destination instead of regularly using a data export. This approach has lower latency compared to a data export but doesn't send historical data.
* Schedule an export of data based on a log query you define with the [Log Analytics query API](/rest/api/loganalytics/dataaccess/query/execute). Use Azure Data Factory, Azure Functions, or Azure Logic Apps to orchestrate queries in your workspace and export data to a destination. This method is similar to the data export feature, but you can use it to export historical data from your workspace by using filters and aggregation. This method is subject to [log query limits](../fundamentals/service-limits.md#log-analytics-workspaces) and isn't intended for scale. For more information, see [Export data from a Log Analytics workspace to a storage account by using Logic Apps](logs-export-logic-app.md).
* Use a one-time export to a local machine by using a PowerShell script. For more information, see [Invoke-AzOperationalInsightsQueryExport](https://www.powershellgallery.com/packages/Invoke-AzOperationalInsightsQueryExport).

## Permissions required

| Action | Permissions required |
| --- | --- |
| Create or update Data export rule | `Microsoft.OperationalInsights/workspaces/dataexports/write` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example |
| Delete Data export rule | `Microsoft.OperationalInsights/workspaces/dataexports/delete` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example |
| Export to storage account | `Microsoft.Storage/storageAccounts/blobServices/containers/write` permissions to the storage account, as provided by the Storage Account Contributor built-in role for example |
| Export to Event Hub | `Microsoft.EventHub/namespaces/eventhubs/write`, `Microsoft.EventHub/namespaces/eventhubs/messages/write`, `Microsoft.EventHub/namespaces/authorizationRules/listkeys/action` permissions to the Event Hub, as provided by the Azure Event Hubs Data Owner built-in roles for example |
| Query logs in a table | `Microsoft.OperationalInsights/workspaces/query/<table>/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |
| Query logs in a table (table action) | `Microsoft.OperationalInsights/workspaces/tables/query/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |

## Considerations

* You can't export custom logs created by using the [HTTP Data Collector API](/previous-versions/azure/azure-monitor/logs/data-collector-api), including text-based logs that the Log Analytics agent consumes. You can export custom logs created by using [data collection rules](./logs-ingestion-api-overview.md), including text-based logs.
* Data export will gradually support more tables. See the [Unsupported tables](#unsupported-tables) section.
* The maximum number of active rules per workspace is 10, and each rule can include multiple tables.
* The storage account must be unique across rules in the workspace.
* Supported table plans are Analytics and Basic. Auxiliary plan isn't supported.
* Destinations must be in the same region as the Log Analytics workspace.
* Export to a Premium storage account isn't supported.

## Data completeness

Data export is optimized to move large data volumes to your destinations. In the event of a destination with insufficient scale or availability, a retry process continues for up to 12 hours and might result in a fraction of the exported records being duplicated. Follow the recommendations for [storage account](#storage-account) and [Event Hubs](#event-hubs) destinations to improve reliability. If the destinations are still unavailable after the retry period, the data is discarded.

For more information about destination limits and recommended alerts, see [Create or update a data export rule](#create-or-update-a-data-export-rule).

## Pricing model
Data export charges are based on the number of bytes exported to destinations in JSON formatted data, and measured in GB (10^9 bytes). The table size reported in Azure Monitor Logs is smaller than the data size that lands in the export destination. This discrepancy is due to the following factors:

* Azure Monitor Logs excludes certain fields from the billable size calculation.
* Data exported to storage is uncompressed.
* Exported data includes property names with each record to ensure each record is valid JSON.
* When actual log records are small, the metadata is significant overhead, making the relative size increase more pronounced.

Data export size calculations can't be done with a workspace query since the size calculation doesn't include the JSON formatting overhead. When comparing the size reported in Azure Monitor Logs to what appears in the storage account, expect substantial differences. In Azure Monitor Logs, small events omit metadata such as property names, while the storage blob includes both the metadata and uncompressed JSON, making the records considerably larger.

For an accurate estimate, run a representative export to a test blob container and measure the result using this sample PowerShell script that [calculates the total billing size of a blob container](/azure/storage/scripts/storage-blobs-container-calculate-billing-size-powershell). There's currently no charge for export to sovereign clouds. A notification will be sent before enablement.

Data export rules are billed under the **Log Analytics Data Export** meter. The same meter is used by [export jobs (preview)](export-job.md). To distinguish the two on your invoice or in Cost analysis, check the **Additional info** field, where data export rules are tagged with `ExportType:Data export rule`.

For more information, including the data export billing timeline, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/). Billing for Data Export was enabled in early October 2023.

## Export destinations

The data export destination must be available before you create export rules in your workspace. Destinations can be in different subscriptions. With Azure Lighthouse, it's also possible to send data to destinations in another Microsoft Entra tenant.

### Storage account

Prevent storage ingress failures due to latency or exceeding rate limits by using an existing storage account that doesn't have other non-monitoring data. This approach helps you better control access to the data and improves data export reliability.

To send data to an immutable storage account, set the immutable policy for the storage account as described in [Set and manage immutability policies for Azure Blob Storage](/azure/storage/blobs/immutable-policy-configure-version-scope). You must follow all steps in this article, including enabling protected append blobs writes.

| Storage requirement | Detail |
|---|---|
| Account tier | StorageV1 or later. Premium isn't supported. |
| Region | Same region as the Log Analytics workspace. Use [Azure Storage redundancy options](/azure/storage/common/storage-redundancy#redundancy-in-a-secondary-region) (GRS, GZRS) for cross-region replication. |
| Container naming | One container per table, named *am-* followed by the table name (for example, *am-SecurityEvent*). |
| Folder structure | 5-minute folders: *WorkspaceResourceId=/subscriptions/.../y=\<year\>/m=\<month\>/d=\<day\>/h=\<hour\>/m=\<minute\>/PT05M.json* |
| Blob format | [JSON lines](/previous-versions/azure/azure-monitor/essentials/resource-logs-blob-format), newline-delimited, no outer array. |
| Append limit | 50,000 writes per blob. Additional blobs added as *PT05M_#.json*. |

> [!NOTE]
> Appends to blobs are written based on the "TimeGenerated" field and occur when receiving source data. Data arriving to Azure Monitor with delay, or retried following destinations throttling, is written to blobs according to its TimeGenerated.

The format of blobs in a storage account is in [JSON lines](/previous-versions/azure/azure-monitor/essentials/resource-logs-blob-format), where each record is delimited by a new line, with no outer records array and no commas between JSON records.

:::image type="content" source="media/logs-data-export/storage-data.png" lightbox="media/logs-data-export/storage-data.png" alt-text="Screenshot that shows data format in a blob.":::

### Event Hubs

Avoid using an Event Hub that has existing, non-monitoring data. This best practice helps prevent ingress failures due to latency or exceeding rate limits.

Data is sent to your Event Hub as it reaches Azure Monitor and is exported to destinations located in a workspace region. Create multiple export rules to the same Event Hub namespace by providing a different `Event Hub name` in the rule. When an `Event Hub name` isn't provided, a default Event Hub is created for tables that you export with the name *am-* followed by the name of the table. For example, the table *SecurityEvent* would be sent to an Event Hub named *am-SecurityEvent*.

The [number of supported Event Hubs in Basic and Standard namespace tiers is 10](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). When you're exporting more than 10 tables to these tiers, either split the tables between several export rules to different Event Hubs namespaces or provide an Event Hub name to export all tables to it.

> [!NOTE]
> * The Basic Event Hubs namespace tier is limited. It supports [lower event size](/azure/event-hubs/event-hubs-quotas#basic-vs-standard-vs-premium-vs-dedicated-tiers) and no [Auto-inflate](/azure/event-hubs/event-hubs-auto-inflate) option to automatically scale up and increase the number of throughput units. Because data volume to your workspace increases over time and as a consequence Event Hub scaling is required, use Standard, Premium, or Dedicated Event Hubs tiers with the **Auto-inflate** feature enabled. For more information, see [Automatically scale up Azure Event Hubs throughput units](/azure/event-hubs/event-hubs-auto-inflate).
> * You can't use a [compacted event hub](/azure/event-hubs/log-compaction) because it requires the message to have a partition key, which Azure Monitor doesn't include.
> * Data export can't reach Event Hubs resources when virtual networks are enabled. You have to select the **Allow Azure services on the trusted services list to access this Storage Account** checkbox to bypass this firewall setting in an Event Hub to grant access to your Event Hubs.

## Query exported data

Exporting data from workspaces to storage accounts helps satisfy various scenarios mentioned in [overview](#overview), and can be consumed by tools that can read blobs from storage accounts. The following methods let you query data using Log Analytics query language, which is the same for Azure Data Explorer.
* Use Azure Data Explorer to [query data in Azure Data Lake Storage](/azure/data-explorer/data-lake-query-data).
* Use Azure Data Explorer to [ingest data from a storage account](/azure/data-explorer/ingest-from-container).
* Use Log Analytics workspace to query [ingested data using Logs Ingestion API](./logs-ingestion-api-overview.md). Ingested data is sent to a custom log table and not to the original table.


## Enable data export
The following steps must be performed to enable Log Analytics data export.

* [Register the resource provider](#register-the-resource-provider)
* [Allow trusted Microsoft services](#allow-trusted-microsoft-services)
* [Create or update a data export rule](#create-or-update-a-data-export-rule)

After you create a data export rule, [monitor your destinations](#monitor-destinations) to ensure reliable export operations.

### Register the resource provider
The Azure resource provider **Microsoft.Insights** needs to be registered in your subscription to enable Log Analytics data export.

This resource provider is probably already registered for most Azure Monitor users. To verify, go to **Subscriptions** in the Azure portal. Select your subscription and then select **Resource providers** under the **Settings** section of the menu. Locate **Microsoft.Insights**. If its status is **Registered**, then it's already registered. If not, select **Register** to register it.

You can also use any of the available methods to register a resource provider as described in [Azure resource providers and types](/azure/azure-resource-manager/management/resource-providers-and-types). The following Azure CLI example uses the [`az provider register`](/cli/azure/provider#az-provider-register) command.

```bash
az provider register --namespace Microsoft.Insights
```

The following Azure PowerShell example uses the [`Register-AzResourceProvider`](/powershell/module/az.resources/register-azresourceprovider) cmdlet.

```powershell
Register-AzResourceProvider -ProviderNamespace Microsoft.Insights
```

### Allow trusted Microsoft services
If you configure your storage account to allow access from selected networks, you need to add an exception to allow Azure Monitor to write to the account. From **Firewalls and virtual networks** for your storage account, select **Allow Azure services on the trusted services list to access this Storage Account**.
<!-- convertborder later -->
:::image type="content" source="media/logs-data-export/storage-account-network.png" lightbox="media/logs-data-export/storage-account-network.png" alt-text="Screenshot that shows the option Allow Azure services on the trusted services list." border="false":::

## Monitor destinations

> [!IMPORTANT]
> Export destinations have limits. Monitor them to minimize throttling, failures, and latency. For more information, see [storage account scalability](/azure/storage/common/scalability-targets-standard-account#scale-targets-for-standard-storage-accounts) and [Event Hubs namespace quotas](/azure/event-hubs/event-hubs-quotas).

The following metrics are available for data export operation and alerts

| Metric name | Description |
|:---|:---|
| Bytes Exported | Total number of bytes exported to destination from Log Analytics workspace within the selected time range. The size of data exported is the number of bytes in the exported JSON formatted data. 1 GB = 10^9 bytes. |
| Export Failures | Total number of failed export requests to destination from Log Analytics workspace within the selected time range. This number includes export attempts failures due to destination resource throttling, forbidden access error, or any server error. A retry process handles failed attempts and the number isn't an indication for missing data. |
| Records Exported | Total number of records exported from Log Analytics workspace within the selected time range. This number counts records for operations that ended with success. |


### Monitor a storage account

1. Use a separate storage account for export.
1. Configure an alert on the metric:

    | Scope | Metric namespace | Metric | Aggregation | Threshold |
    |:---|:---|:---|:---|:---|
    | storage-name | Account | Ingress | Sum | 80% of maximum ingress per alert evaluation period. For example, the limit is 60 Gbps for general-purpose v2 in West US. The alert threshold is 1676 GiB per 5-minute evaluation period. |

1. Alert remediation actions:
    * Use a separate storage account for export that you don't share with non-monitoring data.
    * Azure Storage Standard accounts support a higher ingress limit by request. To request an increase, contact [Azure Support](https://azure.microsoft.com/support/faq/).
    * Split tables between more storage accounts.

### Monitor Event Hubs

1. Configure alerts on the [metrics](/azure/event-hubs/monitor-event-hubs-reference):

    | Scope | Metric namespace | Metric | Aggregation | Threshold |
    |:---|:---|:---|:---|:---|
    | namespaces-name | Event Hubs standard metrics | Incoming bytes | Sum | 80% of maximum ingress per alert evaluation period. For example, the limit is 1 MB/s per unit (TU or PU) and five units used. The threshold is 228 MiB per 5-minute evaluation period. |
    | namespaces-name | Event Hubs standard metrics | Incoming requests | Count | 80% of maximum events per alert evaluation period. For example, the limit is 1,000/s per unit (TU or PU) and five units used. The threshold is 1,200,000 per 5-minute evaluation period. |
    | namespaces-name | Event Hubs standard metrics | Quota exceeded errors | Count | Between 1% of request. For example, requests per 5 minutes is 600,000. The threshold is 6,000 per 5-minute evaluation period. |

1. Alert remediation actions:
   * Use a separate Event Hubs namespace for export that isn't shared with non-monitoring data.
   * Configure the [Auto-inflate](/azure/event-hubs/event-hubs-auto-inflate) feature to automatically scale up and increase the number of throughput units to meet usage needs.
   * Verify the increase of throughput units to accommodate data volume.
   * Split tables between more namespaces.
   * Use Premium or Dedicated tiers for higher throughput.

### Create or update a data export rule
A data export rule defines the destination and tables for which data is exported. The rule provisioning takes about 30 minutes before the export operation initiated. Data export rules considerations:
* The storage account must be unique across rules in the workspace.
* Multiple rules can use the same Event Hubs namespace when you're sending to separate Event Hubs.
* Export to a storage account: A separate container is created in the storage account for each table.
* Export to Event Hubs: If an Event Hub name isn't provided, a separate Event Hub is created for each table. The [number of supported Event Hubs in Basic and Standard namespace tiers is 10](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). When you're exporting more than 10 tables to these tiers, either split the tables between several export rules to different Event Hubs namespaces or provide an Event Hub name in the rule to export all tables to it.

# [Portal](#tab/portal)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu, under **Settings**, select **Rules**.
1. Select the **Data export rules** tab.
1. Select **New export rule** at the top of the pane.

   :::image type="content" source="media/logs-data-export/export-create-1.png" lightbox="media/logs-data-export/export-create-1.png" alt-text="Screenshot that shows the data export entry point.":::

1. Follow the steps, and then select **Create**. Only the tables with data in them are displayed under "Source" tab.

   :::image type="content" source="media/logs-data-export/export-create-2.png" lightbox="media/logs-data-export/export-create-2.png" alt-text="Screenshot of export rule configuration." border="false":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace data-export create`](/cli/azure/monitor/log-analytics/workspace/data-export#az-monitor-log-analytics-workspace-data-export-create) command.

#### Export to a storage account with Azure CLI

The rule exports each table to a separate container in a storage account.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
dataExportName="<DataExportName>"
storageAccountName="<StorageAccountName>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build destination storage account resource ID
storagePath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
storageProvider="Microsoft.Storage/storageAccounts/$storageAccountName"
storageAccountResourceId="$storagePath/providers/$storageProvider"

# Create the data export rule
az monitor log-analytics workspace data-export create \
  --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName" \
    --name "$dataExportName" \
  --tables SecurityEvent Heartbeat \
  --destination "$storageAccountResourceId"
```

#### Export to a specific event hub with Azure CLI

Use the following command to create a data export rule to a specific Event Hub by using the CLI. All tables are exported to the provided Event Hub name and can be filtered by the **Type** field to separate tables.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
dataExportName="<DataExportName>"
eventHubNamespace="<EventHubNamespace>"
eventHubName="<EventHubName>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build destination Event Hub namespace resource ID
eventHubNsPath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
eventHubNsProvider="Microsoft.EventHub/namespaces/$eventHubNamespace"
eventHubNamespaceResourceId="$eventHubNsPath/providers/$eventHubNsProvider"

# Create the data export rule
az monitor log-analytics workspace data-export create \
  --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName" \
    --name "$dataExportName" \
  --tables SecurityEvent Heartbeat \
    --destination "$eventHubNamespaceResourceId" \
    --event-hub-name "$eventHubName"
```

#### Export to an Event Hubs namespace with Azure CLI

Use the following command to create a data export rule to an Event Hubs namespace. When you don't provide a specific Event Hub name, the process creates a separate Event Hub for each table, up to the [number of supported Event Hubs for your Event Hubs tier](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). If you have more tables to export, provide an Event Hub name to export any number of tables, or set a new rule to export the remaining tables to another Event Hubs namespace.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
dataExportName="<DataExportName>"
eventHubNamespace="<EventHubNamespace>"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build destination Event Hub namespace resource ID
eventHubNsPath="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
eventHubNsProvider="Microsoft.EventHub/namespaces/$eventHubNamespace"
eventHubNamespaceResourceId="$eventHubNsPath/providers/$eventHubNsProvider"

# Create the data export rule
az monitor log-analytics workspace data-export create \
  --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName" \
    --name "$dataExportName" \
  --tables SecurityEvent Heartbeat \
  --destination "$eventHubNamespaceResourceId"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzOperationalInsightsDataExport`](/powershell/module/az.operationalinsights/new-azoperationalinsightsdataexport) cmdlet.

#### Export to a storage account with Azure PowerShell

The rule exports each table to a separate container in a storage account.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$dataExportName = "<DataExportName>"
$storageAccountName = "<StorageAccountName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build destination storage account resource ID
$storagePath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$storageProvider = "Microsoft.Storage/storageAccounts/$storageAccountName"
$storageAccountResourceId = "$storagePath/providers/$storageProvider"

# Define parameters for New-AzOperationalInsightsDataExport
$newAzOperationalInsightsDataExportParams = @{
    ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        DataExportName    = $dataExportName
        TableName         = @("SecurityEvent", "Heartbeat")
    ResourceId        = $storageAccountResourceId
}

# Create the data export rule
New-AzOperationalInsightsDataExport @newAzOperationalInsightsDataExportParams
```

#### Export to a specific event hub with Azure PowerShell

Use the following command to create a data export rule to a specific Event Hub by using PowerShell. The command exports all tables to the provided Event Hub name. Filter by the **Type** field to separate tables.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$dataExportName = "<DataExportName>"
$eventHubNamespace = "<EventHubNamespace>"
$eventHubName = "<EventHubName>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build destination Event Hub namespace resource ID
$eventHubNsPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$eventHubNsProvider = "Microsoft.EventHub/namespaces/$eventHubNamespace"
$eventHubNamespaceResourceId = "$eventHubNsPath/providers/$eventHubNsProvider"

# Define parameters for New-AzOperationalInsightsDataExport
$newAzOperationalInsightsDataExportParams = @{
    ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        DataExportName    = $dataExportName
        TableName         = @("SecurityEvent", "Heartbeat")
        ResourceId        = $eventHubNamespaceResourceId
    EventHubName      = $eventHubName
}

# Create the data export rule
New-AzOperationalInsightsDataExport @newAzOperationalInsightsDataExportParams
```

#### Export to an Event Hubs namespace with Azure PowerShell

Use the following command to create a data export rule to an Event Hubs namespace. When you don't provide a specific Event Hub name, the command creates a separate Event Hub for each table, up to the [number of Event Hubs supported in each Event Hubs tier](/azure/event-hubs/event-hubs-quotas#common-limits-for-all-tiers). To export more tables, provide an Event Hub name in the rule. Or you can set another rule and export the remaining tables to another Event Hubs namespace.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$dataExportName = "<DataExportName>"
$eventHubNamespace = "<EventHubNamespace>"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build destination Event Hub namespace resource ID
$eventHubNsPath = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$eventHubNsProvider = "Microsoft.EventHub/namespaces/$eventHubNamespace"
$eventHubNamespaceResourceId = "$eventHubNsPath/providers/$eventHubNsProvider"

# Define parameters for New-AzOperationalInsightsDataExport
$newAzOperationalInsightsDataExportParams = @{
    ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        DataExportName    = $dataExportName
        TableName         = @("SecurityEvent", "Heartbeat")
    ResourceId        = $eventHubNamespaceResourceId
}

# Create the data export rule
New-AzOperationalInsightsDataExport @newAzOperationalInsightsDataExportParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Data Exports - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-data-export-rules) REST API operation.

#### Export to a storage account with REST

The rule exports each table to a separate container in a storage account.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/dataexports/{dataExportName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Storage/storageAccounts/<StorageAccountName>"
        },
        "tableNames": [
            "<TableName1>",
            "<TableName2>"
        ],
        "enable": true
    }
}
```

#### Export to an Event Hubs namespace with REST

To export each table to a separate Event Hub, use an Event Hubs namespace as the destination in the request body:

```json
{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.EventHub/namespaces/<EventHubNamespace>"
        },
        "tableNames": [
            "<TableName1>",
            "<TableName2>"
        ],
        "enable": true
    }
}
```

#### Export to a specific event hub with REST

To export all tables to a specific Event Hub, provide its name in `metaData.eventHubName`:

```json
{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.EventHub/namespaces/<EventHubNamespace>",
            "metaData": {
                "eventHubName": "<EventHubName>"
            }
        },
        "tableNames": [
            "<TableName1>",
            "<TableName2>"
        ],
        "enable": true
    }
}
```

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments create or update the complete export rule. They aren't partial PATCH operations. Preserve the destination and table list when updating an existing rule.

The following three Bicep templates use the [`Microsoft.OperationalInsights/workspaces/dataExports`](/azure/templates/microsoft.operationalinsights/workspaces/dataexports?pivots=deployment-language-bicep) resource type. Deploy the selected template to the existing workspace's resource group. The `subscriptionId` and `resourceGroupName` parameters identify the destination resource's scope.

#### Export to a storage account with Bicep

When updating an existing rule:

* Retain all existing `tableNames` array entries unless you intend to change them.
* Retain the destination settings unless you intend to change them.
* Retain the `enable` state unless you intend to change it.

This is a complete child-resource definition, not a partial update to the workspace.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param workspaceName string = '<WorkspaceName>'
param dataExportName string = '<DataExportName>'
param storageAccountName string = '<StorageAccountName>'

var storageAccountResourceId = resourceId(
    subscriptionId,
    resourceGroupName,
    'Microsoft.Storage/storageAccounts',
    storageAccountName
)

resource logExport 'Microsoft.OperationalInsights/workspaces/dataExports@<ApiVersion>' = {
    name: '${workspaceName}/${dataExportName}'
  properties: {
    destination: {
      resourceId: storageAccountResourceId
    }
    tableNames: [
      'Heartbeat'
      'InsightsMetrics'
      'VMConnection'
      'Usage'
    ]
    enable: true
  }
}
```

#### Export to an Event Hubs namespace with Bicep

To create a separate Event Hub for each table, deploy this template:

When updating an existing rule:

* Retain all existing `tableNames` array entries unless you intend to change them.
* Retain the destination settings unless you intend to change them.
* Retain the `enable` state unless you intend to change it.

This is a complete child-resource definition, not a partial update to the workspace.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param workspaceName string = '<WorkspaceName>'
param dataExportName string = '<DataExportName>'
param eventHubNamespace string = '<EventHubNamespace>'

var eventHubNamespaceResourceId = resourceId(
    subscriptionId,
    resourceGroupName,
    'Microsoft.EventHub/namespaces',
    eventHubNamespace
)

resource logExport 'Microsoft.OperationalInsights/workspaces/dataExports@<ApiVersion>' = {
    name: '${workspaceName}/${dataExportName}'
  properties: {
    destination: {
            resourceId: eventHubNamespaceResourceId
    }
    tableNames: [
      'Usage'
      'Heartbeat'
    ]
    enable: true
  }
}
```

#### Export to a specific event hub with Bicep

To export all tables to a specific Event Hub, deploy this template:

When updating an existing rule:

* Retain all existing `tableNames` array entries unless you intend to change them.
* Retain the destination settings unless you intend to change them.
* Retain the `enable` state unless you intend to change it.

This is a complete child-resource definition, not a partial update to the workspace.

```bicep
param subscriptionId string = '<SubscriptionId>'
param resourceGroupName string = '<ResourceGroupName>'
param workspaceName string = '<WorkspaceName>'
param dataExportName string = '<DataExportName>'
param eventHubNamespace string = '<EventHubNamespace>'
param eventHubName string = '<EventHubName>'

var eventHubNamespaceResourceId = resourceId(
    subscriptionId,
    resourceGroupName,
    'Microsoft.EventHub/namespaces',
    eventHubNamespace
)

resource logExport 'Microsoft.OperationalInsights/workspaces/dataExports@<ApiVersion>' = {
    name: '${workspaceName}/${dataExportName}'
  properties: {
    destination: {
            resourceId: eventHubNamespaceResourceId
      metaData: {
                eventHubName: eventHubName
      }
    }
    tableNames: [
      'Usage'
      'Heartbeat'
    ]
    enable: true
  }
}
```

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments create or update the complete export rule. They aren't partial PATCH operations. Preserve the destination and table list when updating an existing rule.

The following three ARM templates use the [`Microsoft.OperationalInsights/workspaces/dataExports`](/azure/templates/microsoft.operationalinsights/workspaces/dataexports?pivots=deployment-language-arm-template) resource type. Deploy the selected template to the existing workspace's resource group. The `subscriptionId` and `resourceGroupName` parameters identify the destination resource's scope.

#### Export to a storage account with an ARM template

When updating an existing rule:

* Retain all existing `tableNames` array entries unless you intend to change them.
* Retain the destination settings unless you intend to change them.
* Retain the `enable` state unless you intend to change it.

This is a complete child-resource definition, not a partial update to the workspace.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "subscriptionId": {
            "defaultValue": "<SubscriptionId>",
            "type": "string"
        },
        "resourceGroupName": {
            "defaultValue": "<ResourceGroupName>",
            "type": "string"
        },
        "workspaceName": {
            "defaultValue": "<WorkspaceName>",
            "type": "string"
        },
        "dataExportName": {
            "defaultValue": "<DataExportName>",
            "type": "string"
        },
        "storageAccountName": {
            "defaultValue": "<StorageAccountName>",
            "type": "string"
        }
    },
    "variables": {
        "storageAccountResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.Storage/storageAccounts', parameters('storageAccountName'))]"
    },
    "resources": [
        {
            "type": "Microsoft.OperationalInsights/workspaces/dataExports",
            "apiVersion": "<ApiVersion>",
            "name": "[format('{0}/{1}', parameters('workspaceName'), parameters('dataExportName'))]",
            "properties": {
                "destination": {
                    "resourceId": "[variables('storageAccountResourceId')]"
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
```

#### Export to an Event Hubs namespace with an ARM template

Deploy the following ARM template to create a data export rule to an Event Hub. The template creates a separate Event Hub for each table.

When updating an existing rule:

* Retain all existing `tableNames` array entries unless you intend to change them.
* Retain the destination settings unless you intend to change them.
* Retain the `enable` state unless you intend to change it.

This is a complete child-resource definition, not a partial update to the workspace.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "subscriptionId": {
            "defaultValue": "<SubscriptionId>",
            "type": "string"
        },
        "resourceGroupName": {
            "defaultValue": "<ResourceGroupName>",
            "type": "string"
        },
        "workspaceName": {
            "defaultValue": "<WorkspaceName>",
            "type": "string"
        },
        "dataExportName": {
            "defaultValue": "<DataExportName>",
            "type": "string"
        },
        "eventHubNamespace": {
            "defaultValue": "<EventHubNamespace>",
            "type": "string"
        }
    },
    "variables": {
        "eventHubNamespaceResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.EventHub/namespaces', parameters('eventHubNamespace'))]"
    },
    "resources": [
        {
            "type": "Microsoft.OperationalInsights/workspaces/dataExports",
            "apiVersion": "<ApiVersion>",
            "name": "[format('{0}/{1}', parameters('workspaceName'), parameters('dataExportName'))]",
            "properties": {
                "destination": {
                    "resourceId": "[variables('eventHubNamespaceResourceId')]"
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
```

#### Export to a specific event hub with an ARM template

Deploy the following ARM template to create a data export rule to a specific Event Hub. The rule exports all tables to this Event Hub.

When updating an existing rule:

* Retain all existing `tableNames` array entries unless you intend to change them.
* Retain the destination settings unless you intend to change them.
* Retain the `enable` state unless you intend to change it.

This is a complete child-resource definition, not a partial update to the workspace.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "subscriptionId": {
            "defaultValue": "<SubscriptionId>",
            "type": "string"
        },
        "resourceGroupName": {
            "defaultValue": "<ResourceGroupName>",
            "type": "string"
        },
        "workspaceName": {
            "defaultValue": "<WorkspaceName>",
            "type": "string"
        },
        "dataExportName": {
            "defaultValue": "<DataExportName>",
            "type": "string"
        },
        "eventHubNamespace": {
            "defaultValue": "<EventHubNamespace>",
            "type": "string"
        },
        "eventHubName": {
            "defaultValue": "<EventHubName>",
            "type": "string"
        }
    },
    "variables": {
        "eventHubNamespaceResourceId": "[resourceId(parameters('subscriptionId'), parameters('resourceGroupName'), 'Microsoft.EventHub/namespaces', parameters('eventHubNamespace'))]"
    },
    "resources": [
        {
            "type": "Microsoft.OperationalInsights/workspaces/dataExports",
            "apiVersion": "<ApiVersion>",
            "name": "[format('{0}/{1}', parameters('workspaceName'), parameters('dataExportName'))]",
            "properties": {
                "destination": {
                    "resourceId": "[variables('eventHubNamespaceResourceId')]",
                    "metaData": {
                        "eventHubName": "[parameters('eventHubName')]"
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
```

---

## View data export rule configuration

# [Portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu, under **Settings**, select **Rules**.
1. Select the **Data export rules** tab to view all export rules in the workspace.

   :::image type="content" source="media/logs-data-export/export-view-1.png" lightbox="media/logs-data-export/export-view-1.png" alt-text="Screenshot that shows the Data Export screen.":::

1. Select a rule for a configuration view.
   <!-- convertborder later -->
   :::image type="content" source="media/logs-data-export/export-view-2.png" lightbox="media/logs-data-export/export-view-2.png" alt-text="Screenshot of data export rule view." border="false":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics workspace data-export show`](/cli/azure/monitor/log-analytics/workspace/data-export#az-monitor-log-analytics-workspace-data-export-show) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
dataExportName="<DataExportName>"

# Retrieve the data export rule
az monitor log-analytics workspace data-export show \
    --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName" \
    --name "$dataExportName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzOperationalInsightsDataExport`](/powershell/module/az.operationalinsights/get-azoperationalinsightsdataexport) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$dataExportName = "<DataExportName>"

# Define parameters for Get-AzOperationalInsightsDataExport
$getAzOperationalInsightsDataExportParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName     = $workspaceName
    DataExportName    = $dataExportName
}

# Retrieve the data export rule
Get-AzOperationalInsightsDataExport @getAzOperationalInsightsDataExportParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Data Exports - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-data-export-rules) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/dataexports/{dataExportName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## Disable or update an export rule

# [Portal](#tab/portal)

Disable export rules to stop the export for a certain period, such as when testing is being held.

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu, under **Settings**, select **Rules**.
1. Select the **Data export rules** tab.
1. Select the **Status** toggle to disable or enable the export rule.

:::image type="content" source="media/logs-data-export/export-disable.png" lightbox="media/logs-data-export/export-disable.png" alt-text="Screenshot that shows disabling the data export rule.":::

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace data-export update`](/cli/azure/monitor/log-analytics/workspace/data-export#az-monitor-log-analytics-workspace-data-export-update) command. It disables the rule by using the `--enable` parameter.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
dataExportName="<DataExportName>"

# Disable the data export rule
az monitor log-analytics workspace data-export update \
    --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName" \
    --name "$dataExportName" \
  --tables SecurityEvent Heartbeat \
  --enable false
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Update-AzOperationalInsightsDataExport`](/powershell/module/az.operationalinsights/update-azoperationalinsightsdataexport) cmdlet. It disables the rule by using the `Enable` parameter.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$dataExportName = "<DataExportName>"

# Define parameters for Update-AzOperationalInsightsDataExport
$updateAzOperationalInsightsDataExportParams = @{
        ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        DataExportName    = $dataExportName
        TableName         = @("SecurityEvent", "Heartbeat")
    Enable            = $false
}

# Disable the data export rule
Update-AzOperationalInsightsDataExport @updateAzOperationalInsightsDataExportParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Data Exports - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-data-export-rules) REST API operation. It disables the rule by using the `enable` property. Preserve the rule's destination and table list when sending the request.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/dataexports/{dataExportName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
    "properties": {
        "destination": {
            "resourceId": "/subscriptions/<SubscriptionId>/resourceGroups/<ResourceGroupName>/providers/Microsoft.Storage/storageAccounts/<StorageAccountName>"
        },
        "tableNames": [
            "<TableName1>",
            "<TableName2>"
        ],
        "enable": false
    }
}
```

# [Bicep](#tab/bicep)

> [!NOTE]
> Template deployments create or update the complete export rule. They aren't partial PATCH operations. Preserve the destination and table list when updating an existing rule.

Use the [`Microsoft.OperationalInsights/workspaces/dataExports`](/azure/templates/microsoft.operationalinsights/workspaces/dataexports?pivots=deployment-language-bicep) resource type in the Bicep template from [Create or update a data export rule](#create-or-update-a-data-export-rule). Set `enable: false` and redeploy it with the existing destination and complete table list.

# [ARM template](#tab/arm)

> [!NOTE]
> Template deployments create or update the complete export rule. They aren't partial PATCH operations. Preserve the destination and table list when updating an existing rule.

Use the [`Microsoft.OperationalInsights/workspaces/dataExports`](/azure/templates/microsoft.operationalinsights/workspaces/dataexports?pivots=deployment-language-arm-template) resource type in the ARM template from [Create or update a data export rule](#create-or-update-a-data-export-rule). Set `"enable": false` and redeploy it with the existing destination and complete table list.

---

## Delete an export rule

# [Portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu, under **Settings**, select **Rules**.
1. Select the **Data export rules** tab.
1. Select the ellipsis to the right of the rule and select **Delete**.

:::image type="content" source="media/logs-data-export/export-delete.png" lightbox="media/logs-data-export/export-delete.png" alt-text="Screenshot that shows deleting the data export rule.":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics workspace data-export delete`](/cli/azure/monitor/log-analytics/workspace/data-export#az-monitor-log-analytics-workspace-data-export-delete) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
dataExportName="<DataExportName>"

# Delete the data export rule
az monitor log-analytics workspace data-export delete \
    --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName" \
    --name "$dataExportName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Remove-AzOperationalInsightsDataExport`](/powershell/module/az.operationalinsights/remove-azoperationalinsightsdataexport) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$dataExportName = "<DataExportName>"

# Define parameters for Remove-AzOperationalInsightsDataExport
$removeAzOperationalInsightsDataExportParams = @{
        ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
        DataExportName    = $dataExportName
}

# Delete the data export rule
Remove-AzOperationalInsightsDataExport @removeAzOperationalInsightsDataExportParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Data Exports - Delete`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-data-export-rules) REST API operation.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/dataexports/{dataExportName}?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## View all data export rules in a workspace

# [Portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu, under **Settings**, select **Rules**.
1. Select the **Data export rules** tab to view all export rules in the workspace.

:::image type="content" source="media/logs-data-export/export-view.png" lightbox="media/logs-data-export/export-view.png" alt-text="Screenshot that shows the data export rules view.":::

# [Azure CLI](#tab/cli-2)

The following Azure CLI example uses the [`az monitor log-analytics workspace data-export list`](/cli/azure/monitor/log-analytics/workspace/data-export#az-monitor-log-analytics-workspace-data-export-list) command.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"

# List the data export rules
az monitor log-analytics workspace data-export list \
    --resource-group "$resourceGroupName" \
    --workspace-name "$workspaceName"
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell-2)

The following Azure PowerShell example uses the [`Get-AzOperationalInsightsDataExport`](/powershell/module/az.operationalinsights/get-azoperationalinsightsdataexport) cmdlet.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"

# Define parameters for Get-AzOperationalInsightsDataExport
$getAzOperationalInsightsDataExportParams = @{
        ResourceGroupName = $resourceGroupName
        WorkspaceName     = $workspaceName
}

# List the data export rules
Get-AzOperationalInsightsDataExport @getAzOperationalInsightsDataExportParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest-2)

The following REST example uses the [`Data Exports - List By Workspace`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-data-export-rules) REST API operation.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/dataexports?api-version={apiVersion}
Authorization: Bearer {accessToken}
```

---

## Unsupported tables

> [!NOTE]
> If the data export rule includes an unsupported table, the configuration will succeed, but no data will be exported for that table. When table is supported, data export will start then. We are in a process of adding support for more tables. Please check this article regularly.

| Table | Limitations |
|---|---|
| Alert | Partial support. Data ingestion for Zabbix alerts isn't supported. |
| AlertHistory |  |
| AzureActivity | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| AzureDiagnostics | |
| ConfigurationChange | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| ConfigurationData | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| DatabricksDatabricksSQL |  |
| DatabricksSQL |  |
| DeviceAppLaunch |  |
| DeviceCalendar |  |
| DeviceConnectSession |  |
| DeviceEtw | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| DeviceHeartbeat |  |
| ETWEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| Event | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| NetworkSessions |  |
| Operation | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| ProtectionStatus |  |
| SecurityEvent | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| ServiceFabricOperationalEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| ServiceFabricReliableActorEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| ServiceFabricReliableServiceEvent | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |
| Syslog | Partial support. Some of the data is ingested through internal services that aren't supported in export. Currently, this portion is missing in export. |
| W3CIISLog | Partial support. Data arriving from the Log Analytics agent or Azure Monitor Agent is fully supported in export. Data arriving via the Diagnostics extension agent is collected through storage. This path isn't supported in export. |


## Related content

[Query the exported data from Azure Data Explorer](/azure/data-explorer/data-lake-query-data)
