---
title: Restore logs in Azure Monitor
description: Learn how to restore archived log data in a Log Analytics workspace to run high-performance KQL queries on a specific time range in Azure Monitor.
ms.topic: how-to
ms.date: 07/29/2026
ms.reviewer: adi.biran
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

> [!IMPORTANT]
> Billing starts when the restore begins and continues until you [dismiss the restored data](#dismiss-restored-data). Dismiss the restore as soon as you're done querying. For cost details, see [Restore pricing](#restore-pricing).

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [az monitor log-analytics workspace table restore create](/cli/azure/monitor/log-analytics/workspace/table/restore#az-monitor-log-analytics-workspace-table-restore-create) command. It restores a time range of data from a source table into a new destination table. The name of the destination table, which you set by using the `--name` parameter, must end with `_RST`.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
tableName="<TableName>_RST"
restoreSourceTable="<SourceTableName>"
startRestoreTime="2026-01-01T00:00:00.000Z"
endRestoreTime="2026-01-08T00:00:00.000Z"

# Create the Log Analytics workspace restore logs table
az monitor log-analytics workspace table restore create \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --name "$tableName" \
  --restore-source-table "$restoreSourceTable" \
  --start-restore-time "$startRestoreTime" \
  --end-restore-time "$endRestoreTime" \
  --no-wait
```

[!INCLUDE [Azure CLI default endpoint](../includes/cli-default-endpoint.md)]

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [New-AzOperationalInsightsRestoreTable](/powershell/module/az.operationalinsights/new-azoperationalinsightsrestoretable) cmdlet. It restores a time range of data from a source table into a new destination table. The name of the destination table, which you set by using the `-TableName` parameter, must end with `_RST`.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$tableName = "<TableName>_RST"
$sourceTable = "<SourceTableName>"
$startRestoreTime = "2026-01-01T00:00:00.000Z"
$endRestoreTime = "2026-01-08T00:00:00.000Z"

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

The following REST example uses the [Tables - Create Or Update](../fundamentals/azure-monitor-rest-api-index.md#op-logs-tables) REST API operation. It restores a time range of data from a source table into a new destination table. The name of the destination table must end with `_RST`.

Include the following values in the body of the request:

| Name | Type | Description |
|:---|:---|:---|
| `properties.restoredLogs.sourceTable` | string | Table with the data to restore. |
| `properties.restoredLogs.startRestoreTime` | string | Start of the time range to restore. |
| `properties.restoredLogs.endRestoreTime` | string | End of the time range to restore. |

**Restore table status**

The `provisioningState` property indicates the current state of the restore table operation. The API returns this property when you start the restore, and you retrieve this property later by using a `GET` operation on the table. The `provisioningState` property has one of the following values:

| Value | Description |
|:---|:---|
| Updating | Restore operation in progress. |
| Succeeded | Restore operation completed. |
| Deleting | Deleting the restored table. |

**Sample request**

This example restores data from January 2026 from the `Usage` table to a table called `Usage_RST`.

```REST
PUT https://management.azure.com/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{WorkspaceName}/tables/{TableName}_RST?api-version={apiVersion}
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "properties": {
    "restoredLogs": {
      "sourceTable": "Usage",
      "startRestoreTime": "2026-01-01T00:00:00.000Z",
      "endRestoreTime": "2026-01-31T00:00:00.000Z"
    }
  }
}
```

**Response**

Status code: 202 Accepted.

---

## Query restored data

When you query a restored table in Azure Monitor, use the destination table name (ending in `_RST`). Restored logs retain their original timestamps, not the time of the restore operation. Set the query time range based on when the data was originally generated.

Set the query time range by either:

- Selecting **Custom** in the **Time range** dropdown at the top of the query editor and setting **From** and **To** values.
- Specifying the time range in the query. For example:

    ```kusto
    let startTime = datetime(01/01/2026 8:00:00 PM);
    let endTime = datetime(01/05/2026 8:00:00 PM);
    TableName_RST
    | where TimeGenerated between (startTime .. endTime)
    ```

## Dismiss restored data

Dismissing restored data means deleting the destination `_RST` table to stop restore billing. [Delete the restored table](../logs/create-custom-table.md#delete-a-table) when you no longer need it.

Deleting the restored table doesn't delete the data in the source table.

> [!NOTE]
> Restored data is available as long as the underlying source data is available. When you delete the source table from the workspace or when the source table's retention period ends, the data is dismissed from the restored table. However, the empty table remains until you delete it explicitly.

## Restore considerations

The restore operation in Azure Monitor has the following constraints:

- **Supported table plans**: Analytics and Basic. The [Auxiliary plan](data-platform-logs.md#table-plans) isn't supported.
- **Minimum time range**: At least two days of data per restore.
- **Maximum data volume**: Up to 60 TB per restore.
- **Concurrent restores**: Up to two restore processes per workspace at the same time.
- **One active restore per table**: Running a second restore on a table that already has an active restore fails.
- **Weekly limit**: Up to four restores per table per week.

## Restore pricing

The cost of restored logs depends on the volume of data you restore and the duration the restore is active. The price is *per GB per day* on each UTC day the restore is active.

Key pricing rules:

- **Minimum data volume**: 2 TB per restore. If you restore less, you're charged for 2 TB.
- **Minimum duration**: 12 hours. If the restore is active for less, you're charged for 12 hours (0.5 days).
- **Partial-day billing**: On the first and last days, you're only billed for the part of the day the restore is active.
- **No query charges**: Querying restored data has no extra cost since restored tables use the Analytics plan.

For pricing details, see the **Logs** tab on [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

### Cost examples

| Scenario | Restored data | Duration | Billed daily volume | Calculation |
|:---|:---|:---|:---|:---|
| Large restore, multi-day | 5 TB (500 GB/day × 10 days) | Until dismissed | 5,000 GB | 5,000 GB × price per GB/day × number of days active |
| Small restore, multi-day | 700 GB | Until dismissed | 2,000 GB (minimum) | 2,000 GB × price per GB/day × number of days active |
| Large restore, 1 hour | 5 TB | 1 hour | 5,000 GB | 5,000 GB × price per GB/day × 0.5 days (12-hour minimum) |
| Small restore, 1 hour | 700 GB | 1 hour | 2,000 GB (minimum) | 2,000 GB × price per GB/day × 0.5 days (12-hour minimum) |

## Related content

- [Configure data retention and archive policies](data-retention-configure.md)
- [Run search jobs to access archived data](search-jobs.md)
