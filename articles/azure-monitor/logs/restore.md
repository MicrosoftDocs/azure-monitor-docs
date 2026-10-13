---
title: Restore Logs in Azure Monitor
description: Learn how to restore archived log data in a Log Analytics workspace to run high-performance KQL queries on a specific time range in Azure Monitor.
ms.topic: how-to
ms.custom: cbo-v1.6
ms.reviewer: adi.biran
ms.date: 07/29/2026
ai-usage: ai-assisted

#customer intent: As a Log Analytics workspace admin, I want to restore archived log data so that I can run high-performance KQL queries on a specific time range from long-term retention.

---

# Restore logs in Azure Monitor

The restore operation makes a specific time range of data in a table available in the hot cache for high-performance queries. You specify a source table and time range, Azure Monitor creates a destination table (ending in `_RST`), and you run full KQL queries against the restored data. When you're done, you dismiss the restore to stop billing.

Restore is one way to access data in [long-term retention](data-retention-configure.md). Use restore to run full Kusto Query Language (KQL) queries against data in a particular time range. Use [search jobs](search-jobs.md) to access data based on specific criteria. Also use the restore operation to run queries on any Analytics table when log queries can't complete within the 10-minute timeout.

## Prerequisites

To restore data from long-term retention, you need `Microsoft.OperationalInsights/workspaces/tables/write` and `Microsoft.OperationalInsights/workspaces/restoreLogs/write` permissions to the Log Analytics workspace. The [Log Analytics Contributor built-in role](../logs/manage-access.md#built-in-roles) provides these permissions.

Tables with the [Auxiliary table plan](data-platform-logs.md) don't support data restore. Use a [search job](search-jobs.md) to retrieve data in long-term retention from an Auxiliary table.

> [!NOTE]
> Azure Lighthouse doesn't support delegated access for restore jobs or search jobs, even when a delegated role includes the `restoreLogs/write` permission.

## Restore data

When you restore data, you specify the source table and a name for the new destination table. The destination table name must end with `_RST`. The restore operation creates this table and allocates extra compute resources for querying the restored data by using high-performance queries that support full KQL. The destination table provides a view of the underlying source data but doesn't affect it.

Specify start and end times as UTC strings in ISO 8601 format, such as `2026-01-01T00:00:00Z`. Choose a range within the source table's retained data that meets the [restore constraints](#restore-considerations).

> [!IMPORTANT]
> Billing starts when the restore begins and continues until you [dismiss the restored data](#dismiss-restored-data). Dismiss the restore as soon as you're done querying. For cost details, see [Restore pricing](#restore-pricing).

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace table restore create`](/cli/azure/monitor/log-analytics/workspace/table/restore#az-monitor-log-analytics-workspace-table-restore-create) command. It restores a time range of data from a source table into a new destination table. The name of the destination table, which you set by using the `--name` parameter, must end with `_RST`.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
tableName="<TableName>_RST"
sourceTable="<SourceTableName>"
startRestoreTime="<StartRestoreTime>"
endRestoreTime="<EndRestoreTime>"

# Create the Log Analytics workspace restore logs table
az monitor log-analytics workspace table restore create \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --name "$tableName" \
  --restore-source-table "$sourceTable" \
  --start-restore-time "$startRestoreTime" \
  --end-restore-time "$endRestoreTime" \
  --no-wait
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`New-AzOperationalInsightsRestoreTable`](/powershell/module/az.operationalinsights/new-azoperationalinsightsrestoretable) cmdlet. It restores a time range of data from a source table into a new destination table. The name of the destination table, which you set by using the `-TableName` parameter, must end with `_RST`.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$tableName = "<TableName>_RST"
$sourceTable = "<SourceTableName>"
$startRestoreTime = "<StartRestoreTime>"
$endRestoreTime = "<EndRestoreTime>"

# Define parameters for New-AzOperationalInsightsRestoreTable
$newAzOperationalInsightsRestoreTableParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName     = $workspaceName
    TableName         = $tableName
    SourceTable       = $sourceTable
    StartRestoreTime  = $startRestoreTime
    EndRestoreTime    = $endRestoreTime
}

# Create the Log Analytics workspace restore logs table
New-AzOperationalInsightsRestoreTable @newAzOperationalInsightsRestoreTableParams
```

[!INCLUDE [Azure PowerShell default endpoint](../includes/powershell-default-endpoint.md)]

# [REST](#tab/rest)

The following REST example uses the [`Tables - Create Or Update`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation. It restores a time range of data from a source table into a new destination table. The name of the destination table must end with `_RST`.

Include the following values in the body of the request:

| Name | Type | Description |
|:---|:---|:---|
| `properties.restoredLogs.sourceTable` | string | Table with the data to restore. |
| `properties.restoredLogs.startRestoreTime` | string (date-time) | Start of the time range to restore, in UTC. |
| `properties.restoredLogs.endRestoreTime` | string (date-time) | End of the time range to restore, in UTC. |

**Restore table status**

The `provisioningState` property indicates the current state of the restore table operation. The API returns this property when you start the restore, and you retrieve this property later by using a `GET` operation on the table. The `provisioningState` property has one of the following values:

| Value | Description |
|:---|:---|
| Updating | Table schema is being updated; the table is locked for changes. |
| InProgress | Table schema is stable, but table data is still being updated. |
| Succeeded | Restore operation completed. |
| Deleting | Deleting the restored table. |

**Sample request**

This example restores the selected source table and time range into a new `_RST` table.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}_RST?api-version={apiVersion}
Authorization: Bearer {accessToken}
Content-Type: application/json

{
  "properties": {
    "restoredLogs": {
      "sourceTable": "<SourceTableName>",
      "startRestoreTime": "<StartRestoreTime>",
      "endRestoreTime": "<EndRestoreTime>"
    }
  }
}
```

**Response**

Status code: `202 Accepted` for an asynchronous restore. The API also documents `200 OK` for a completed operation. Check the table's `provisioningState` before querying restored data.

# [Bicep](#tab/bicep)

> [!NOTE]
> Bicep deployments are create-or-update operations, not partial PATCH operations. Use a new `_RST` table name; don't redeploy over an active restore. The parent workspace is an existing resource and isn't redeployed.

The following Bicep example uses the [`Microsoft.OperationalInsights/workspaces/tables`](/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-bicep) resource type. It creates a restored table for the selected source table and time range.

```bicep
param workspaceName string = '<WorkspaceName>'
param tableName string = '<TableName>_RST'
param sourceTable string = '<SourceTableName>'
param startRestoreTime string = '<StartRestoreTime>'
param endRestoreTime string = '<EndRestoreTime>'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@<ApiVersion>' existing = {
  name: workspaceName
}

resource restoredTable 'Microsoft.OperationalInsights/workspaces/tables@<ApiVersion>' = {
  parent: logAnalyticsWorkspace
  name: tableName
  properties: {
    restoredLogs: {
      sourceTable: sourceTable
      startRestoreTime: startRestoreTime
      endRestoreTime: endRestoreTime
    }
  }
}
```

# [ARM template](#tab/arm)

> [!NOTE]
> ARM template deployments are create-or-update operations, not partial PATCH operations. Use a new `_RST` table name; don't redeploy over an active restore. This template doesn't redeploy the parent workspace.

The following ARM template example uses the [`Microsoft.OperationalInsights/workspaces/tables`](/azure/templates/microsoft.operationalinsights/workspaces/tables?pivots=deployment-language-arm-template) resource type. It creates a restored table for the selected source table and time range.

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string",
      "defaultValue": "<WorkspaceName>"
    },
    "tableName": {
      "type": "string",
      "defaultValue": "<TableName>_RST"
    },
    "sourceTable": {
      "type": "string",
      "defaultValue": "<SourceTableName>"
    },
    "startRestoreTime": {
      "type": "string",
      "defaultValue": "<StartRestoreTime>"
    },
    "endRestoreTime": {
      "type": "string",
      "defaultValue": "<EndRestoreTime>"
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/tables",
      "apiVersion": "<ApiVersion>",
      "name": "[format('{0}/{1}', parameters('workspaceName'), parameters('tableName'))]",
      "properties": {
        "restoredLogs": {
          "sourceTable": "[parameters('sourceTable')]",
          "startRestoreTime": "[parameters('startRestoreTime')]",
          "endRestoreTime": "[parameters('endRestoreTime')]"
        }
      }
    }
  ]
}
```

---

For an asynchronous restore, retrieve the destination table with [`az monitor log-analytics workspace table show`](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-show), [`Get-AzOperationalInsightsTable`](/powershell/module/az.operationalinsights/get-azoperationalinsightstable), or [`Tables - Get`](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables). Wait until `provisioningState` is `Succeeded` before querying.

## Query restored data

When you query a restored table in Azure Monitor, use the destination table name (ending in `_RST`). Restored logs retain their original timestamps, not the time of the restore operation. Set the query time range based on when the data was originally generated.

Set the query time range by either:

* Selecting **Custom** in the **Time range** dropdown at the top of the query editor and setting **From** and **To** values.
* Specifying the time range in the query. For example:

    ```kusto
    let startTime = datetime(<StartRestoreTime>);
    let endTime = datetime(<EndRestoreTime>);
    <TableName>_RST
    | where TimeGenerated between (startTime .. endTime)
    ```

## Dismiss restored data

Dismissing restored data means deleting the destination `_RST` table to stop restore billing. [Delete the restored table](../logs/create-custom-table.md#delete-a-table) when you no longer need it.

Deleting the restored table doesn't delete the data in the source table.

> [!NOTE]
> Restored data is available as long as the underlying source data is available. When you delete the source table from the workspace or when the source table's retention period ends, the data is dismissed from the restored table. However, the empty table remains until you delete it explicitly.

## Restore considerations

The restore operation in Azure Monitor has the following constraints:

* **Supported table plans**: Analytics and Basic. The [Auxiliary plan](data-platform-logs.md#table-plans) isn't supported.
* **Minimum time range**: At least two days of data per restore.
* **Maximum data volume**: Up to 60 TB per restore.
* **Concurrent restores**: Up to two restore processes per workspace at the same time.
* **One active restore per table**: Running a second restore on a table that already has an active restore fails.
* **Weekly limit**: Up to four restores per table per week.

## Restore pricing

The cost of restored logs depends on the volume of data you restore and the duration the restore is active. The price is *per GB per day* on each UTC day the restore is active.

Key pricing rules:

* **Minimum data volume**: 2 TB per restore. If you restore less, you're charged for 2 TB.
* **Minimum duration**: 12 hours. If the restore is active for less, you're charged for 12 hours (0.5 days).
* **Partial-day billing**: On the first and last days, you're only billed for the part of the day the restore is active.
* **No query charges**: Querying restored data has no extra cost since restored tables use the Analytics plan.

For pricing details, see the **Logs** tab on [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

### Cost examples

| Scenario | Restored data | Duration | Billed daily volume | Calculation |
|:---|:---|:---|:---|:---|
| Large restore, multi-day | 5 TB (500 GB/day × 10 days) | Until dismissed | 5,000 GB | 5,000 GB × price per GB/day × number of days active |
| Small restore, multi-day | 700 GB | Until dismissed | 2,000 GB (minimum) | 2,000 GB × price per GB/day × number of days active |
| Large restore, 1 hour | 5 TB | 1 hour | 5,000 GB | 5,000 GB × price per GB/day × 0.5 days (12-hour minimum) |
| Small restore, 1 hour | 700 GB | 1 hour | 2,000 GB (minimum) | 2,000 GB × price per GB/day × 0.5 days (12-hour minimum) |

## Related content

* [Configure data retention and archive policies](data-retention-configure.md)
* [Run search jobs to access archived data](search-jobs.md)
