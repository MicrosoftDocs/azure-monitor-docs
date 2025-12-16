---
title: Run search jobs in Azure Monitor
description: Search jobs are asynchronous log queries in Azure Monitor that make results available as a table for further analytics.
ms.topic: how-to
ms.date: 12/16/2025
ms.custom: references_regions
ms.reviewer: adi.biran
# Customer intent: As a data scientist or workspace administrator, I want an efficient way to search through large volumes of data in a table, including data in long-term retention.
---

# Run search jobs in Azure Monitor

A search job is an asynchronous query you run on any data in your Log Analytics - in both [analytics and long-term retention](data-retention-configure.md) - that makes the query results available for interactive queries in a new search table within your workspace. The search job uses parallel processing and can run for hours across large datasets. This article describes how to create a search job and how to query its resulting data.

This video explains when and how to use search jobs:
 
> [!VIDEO https://www.youtube.com/embed/5iShgXRu1sU?cc_load_policy=1&cc_lang_pref=auto]

## Permissions required

| Action | Permissions required |
|:-------|:---------------------|
| Run a search job | `Microsoft.OperationalInsights/workspaces/tables/write` and `Microsoft.OperationalInsights/workspaces/searchJobs/write` permissions to the Log Analytics workspace, for example, as provided by the [Log Analytics Contributor built-in role](../logs/manage-access.md#built-in-roles). |

> [!NOTE]
> Cross-tenant search jobs aren't supported. Azure Lighthouse delegated access is also not supported for search jobs (or restore) even when a delegated role is assigned which includes the searchJobs/write permission.

## When to use search jobs

Use search jobs to: 

- Retrieve records from [long-term retention](data-retention-configure.md) and [tables with the Basic and Auxiliary plans](data-platform-logs.md#table-plans) into a new Analytics table where you can take advantage of Azure Monitor Log's full analytics capabilities. 
- Scan through large volumes of data, if the log query time-out of 10 minutes isn't sufficient.

## What does a search job do?

A search job scans data and sends its results to a new table in the same workspace as the source data. The results table is available as soon as the search job begins, but it may take time for results to begin to appear. A cost is incurred based on the [pricing model](#pricing-model) of scanned data and the size of the ingested results. Before a search job is run, a cost estimation is available to help you decide whether to run the job.

:::image type="content" source="media/search-job/cost-estimation-preview.png" alt-text="Screenshot showing cost estimation preview.":::

The search job results table is an [Analytics table](../logs/logs-table-plans.md) that is available for log queries and other Azure Monitor features that use tables in a workspace. The table uses the [retention value](data-retention-configure.md) set for the workspace, but you can modify this value after the table is created.

The search results table schema is based on the source table schema and the specified query. The following other columns help you track the source records:

| Column                 | Value                                    |
|:-----------------------|:-----------------------------------------|
| _OriginalType          | *Type* value from source table.          |
| _OriginalItemId        | *_ItemID* value from source table.       |
| _OriginalTimeGenerated | *TimeGenerated* value from source table. |
| TimeGenerated          | Time at which the search job ran.        |

Queries on the results table appear in [log query auditing](query-audit.md) but not the initial search job.

## Run a search job

Run a search job to fetch records from large datasets into a new search results table in your workspace.

> [!TIP] 
> You incur charges for running a search job. Write and optimize your query in interactive query mode before running the search job. Use the cost estimation preview to understand the potential costs.

### [Portal](#tab/portal-1)

To run a search job, in the Azure portal:

1. From the **Log Analytics workspace** menu, select **Logs**.

1. Type a search job query or just select the table you want. 

1. Select the ellipsis menu on the right-hand side of the screen and select **Search job**. 

    :::image type="content" source="media/search-job/search-job-ellipses-menu.png" alt-text="Screenshot of the Logs screen with the Search job menu item highlighted." lightbox="media/search-job/search-job-ellipses-menu.png"::: 

1. Or use the **Run** pull-down menu and select **Run as Search job**.

   :::image type="content" source="media/search-job/search-job-run-menu.png" alt-text="Screenshot of the Logs screen with the Run as Search job menu item highlighted." lightbox="media/search-job/search-job-run-menu.png":::

1. Specify the search job date range using the time picker. Choose any period within the total retention period.

    If your Kusto query also specifies a time range, the union of the time ranges is used for the search job.
    
    :::image type="content" source="media/search-job/search-job-time-selector.png" alt-text="Screenshot that shows the search job interface prompting for time range and the search job results table." lightbox="media/search-job/search-job-time-selector.png":::

1. Enter a name for the search job result table and select **Run a search job**.

    Azure Monitor Logs runs the search job and creates a new table in your workspace for your search job results. 

1. When the new table is ready, select **View '*\<searchtablename\>*_SRCH'** to view the table in Log Analytics.

    Search job results are available as they begin flowing into the newly created search job results table.

    :::image type="content" source="media/search-job/search-job-processing.png" alt-text="Screenshot that shows search job results table with data." lightbox="media/search-job/search-job-processing.png":::

    Azure Monitor Logs shows a **Search job is done** message when it's completed. When you see that message or the progress shows 100%, the results table is now ready with all the records that match the search query.

### [API](#tab/api-1)

To run a search job, call the **Tables - Create or Update** API. The call includes the name of the results table to be created. The name of the results table must end with *_SRCH*.
 
```http
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/<TableName>_SRCH?api-version=2021-12-01-preview
```

**Request body**

Include the following values in the body of the request:

| Name | Type | Description |
| ---- | ---- | ------------------------------------------------------------------------------------------------------------------------- |
| properties.searchResults.query           | string  | Log query written in KQL to retrieve data.                                         |
| properties.searchResults.limit           | integer | Maximum number of records in the result set, up to 100 million records. (Optional) |
| properties.searchResults.startSearchTime | string  | Start of the time range to search.                                                 |
| properties.searchResults.endSearchTime   | string  | End of the time range to search.                                                   |

**Sample request**

This example creates a table called *Syslog_suspected_SRCH* with the results of a query that searches for particular records in the *Syslog* table.

**Request**

```http
PUT https://management.azure.com/subscriptions/00000000-0000-0000-0000-00000000000/resourcegroups/testRG/providers/Microsoft.OperationalInsights/workspaces/testWS/tables/Syslog_suspected_SRCH?api-version=2021-12-01-preview
```

**Request body**

```json
{
    "properties": { 
        "searchResults": {
                "query": "Syslog | where * has 'suspected.exe'",
                "limit": 1000,
                "startSearchTime": "2025-01-01T00:00:00Z",
                "endSearchTime": "2025-11-30T00:00:00Z"
            }
    }
}
```

**Response**

Status code: 202 accepted.

### [CLI](#tab/cli-1)

To run a search job, run the [az monitor log-analytics workspace table search-job create](/cli/azure/monitor/log-analytics/workspace/table/search-job#az-monitor-log-analytics-workspace-table-search-job-create) command. The name of the results table, which you set using the `--name` parameter, must end with *_SRCH*.

**Example**

```azurecli
az monitor log-analytics workspace table search-job create --subscription ContosoSID --resource-group ContosoRG  --workspace-name ContosoWorkspace --name HeartbeatByIp_SRCH --search-query 'Heartbeat | where ComputerIP has "00.000.00.000"' --limit 1500 --start-search-time "2022-01-01T00:00:00.000Z" --end-search-time "2022-01-08T00:00:00.000Z" --no-wait
```

### [PowerShell](#tab/powershell-1)

To run a search job, run the [New-AzOperationalInsightsSearchTable](/powershell/module/az.operationalinsights/new-azoperationalinsightssearchtable) command. The name of the results table, which you set using the `TableName` parameter, must end with *_SRCH*.

**Example**

```powershell
New-AzOperationalInsightsSearchTable -ResourceGroupName ContosoRG -WorkspaceName ContosoWorkspace -TableName HeartbeatByIp_SRCH -SearchQuery "Heartbeat" -StartSearchTime "01-01-2022 00:00:00" -EndSearchTime "01-01-2022 00:00:00"
```

---

## Get search job status and details

### [Portal](#tab/portal-2)

1. From the **Log Analytics workspace** menu, select **Logs**.

1. From **Tables** > **Search results**, hover over your search results table to view the progress. 

    The icon on the search job results table displays an update indicator icon until the search job is completed.  
    
    :::image type="content" source="media/search-job/run-as-search-job-running.png" alt-text="Screenshot shows the status of the search table results." lightbox="media/search-job/run-as-search-job-running.png":::

### [API](#tab/api-2)

Use the `Get` operation of the [Tables](/rest/api/loganalytics/tables) API to check the status and details of a search job.

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName_SRCH}?api-version={api-version}
```

**Table status**

Each search job table has a property called *provisioningState*, which can have one of the following values:

| Status     | Description                           |
|:-----------|:--------------------------------------|
| Updating   | Populating the table and its schema.  |
| InProgress | Search job is running, fetching data. |
| Succeeded  | Search job completed.                 |
| Deleting   | Deleting the search job table.        |

**Sample request**

This example retrieves the table status for the search job in the previous example.

**Request**

```http
GET https://management.azure.com/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/ContosoResourceGroup/providers/Microsoft.OperationalInsights/workspaces/ContosoWorkspace/tables/Syslog_SRCH?api-version={api-version}
```

**Response**

```json
{
        "properties": {
        "retentionInDays": 30,
        "totalRetentionInDays": 30,
        "archiveRetentionInDays": 0,
        "plan": "Analytics",
        "lastPlanModifiedDate": "Mon, 01 Nov 2021 16:38:01 GMT",
        "schema": {
            "name": "Syslog_SRCH",
            "tableType": "SearchResults",
            "description": "This table was created using a Search Job with the following query: 'Syslog | where * has 'suspected.exe'.'",
            "columns": [...],
            "standardColumns": [...],
            "solutions": [
                "LogManagement"
            ],
            "searchResults": {
                "query": "Syslog | where * has 'suspected.exe'",
                "limit": 1000,
                "startSearchTime": "Wed, 01 Jan 2020 00:00:00 GMT",
                "endSearchTime": "Fri, 31 Jan 2020 00:00:00 GMT",
                "sourceTable": "Syslog"
            }
        },
        "provisioningState": "Succeeded"
    },
    "id": "subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourcegroups/ContosoResourceGroup/providers/Microsoft.OperationalInsights/workspaces/ContosoWorkspace/tables/Syslog_SRCH",
    "name": "Syslog_SRCH"
}
```

### [CLI](#tab/cli-2)

To check the status and details of a search job table, run the [az monitor log-analytics workspace table show](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-show) command.

**Example**

```azurecli
az monitor log-analytics workspace table show --subscription aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e --resource-group ContosoResourceGroup --workspace-name ContosoWorkspace --name HeartbeatByIp_SRCH --output table \
```

### [PowerShell](#tab/powershell-2)

To check the status and details of a search job table, run the [Get-AzOperationalInsightsTable](/powershell/module/az.operationalinsights/get-azoperationalinsightstable) command.

**Example**

```powershell
Get-AzOperationalInsightsTable -ResourceGroupName "ContosoResourceGroup" -WorkspaceName "ContosoWorkspace" -tableName "HeartbeatByIp_SRCH"
```

> [!NOTE]
> When "-TableName" isn't provided, the command lists all tables associated with a workspace.

---

## Delete a search job table

We recommend you [delete the search job table](../logs/create-custom-table.md#delete-a-table) when you're done querying the table. This best practice reduces workspace clutter and extra charges for data retention. 

## Considerations

Search jobs are subject to the following considerations:

* Optimized to query one table at a time
* Search date range is any period within the total retention
* Supports long running searches up to a 24-hour time-out
* Results are limited to 100 million records in the record set - if limit is surpassed, Azure Monitor aborts the job with a status of *partial success*, and the table contains only records ingested up to that point
* Concurrent execution is limited to ten search jobs per workspace.
* Limited to 200 search results tables per workspace
* Limited to 200 search job executions per day per workspace
* Cross-tenant search jobs aren't supported
* Azure Lighthouse delegated access isn't supported for search jobs even if the delegation contains the proper searchJobs/write permission - fails with error message:
   :::row:::
   :::column span="3":::
   *User* \<managing-tenant-userId\> *does not maintain access to action Microsoft.OperationalInsights/workspaces/searchJobs/write at scope* 
   <delegated-workspace-resourceID\>.
   :::column-end:::
   :::row-end:::

### KQL query considerations

Search jobs are intended to scan large volumes of data in a specific table, so search job queries must always start with a table name. To enable asynchronous execution using distribution and segmentation, the query supports a subset of KQL, including these tabular operators: 

* [`where`](/azure/data-explorer/kusto/query/whereoperator)
* [`extend`](/azure/data-explorer/kusto/query/extendoperator)
* [`project`](/azure/data-explorer/kusto/query/projectoperator)
* [`project-away`](/azure/data-explorer/kusto/query/projectawayoperator)
* [`project-keep`](/azure/data-explorer/kusto/query/project-keep-operator)
* [`project-rename`](/azure/data-explorer/kusto/query/projectrenameoperator)
* [`project-reorder`](/azure/data-explorer/kusto/query/projectreorderoperator)
* [`parse`](/azure/data-explorer/kusto/query/parse-operator)
* [`parse-where`](/azure/data-explorer/kusto/query/parse-where-operator)

All functions and binary operators within these operators are usable.

The [`contains`](/azure/data-explorer/kusto/query/contains-operator) string operator is blocked from use in search jobs since advanced text matches have significant impact on performance. Instead, use the [`has`](/azure/data-explorer/kusto/query/has-operator) string operator. For more information on performance considerations, see [Optimize log queries in Azure Monitor](../logs/query-optimization.md#use-effective-aggregation-commands-and-dimensions-in-summarize-and-join).


## Pricing model

The search job charge is based on:

* Search job execution: 

  - **Analytics plan** - The amount of data the search job scans that's in long-term retention. There's no charge for scanning data that's in analytics retention in Analytics tables.
  - **Basic or Auxiliary plans** - All data the search job scans in long-term retention. 
    
    The data scanned is defined as the volume of data in the table that you run the search job on, within the time range you specified. For more information about analytics and long-term retention, see [Manage data retention in a Log Analytics workspace](data-retention-configure.md).
  
* Search job results - The amount of data the search job finds and is ingested into the results table, based on the data ingestion rate for Analytics tables.

For example, if a search on a Basic table spans 30 days and the table holds 500 GB of data per day, you're charged for 15,000 GB of scanned data. If the search job returns 1,000 records, you're charged for ingesting these 1,000 records into the results table.

For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Related content

- [Learn more about managing data retention in a Log Analytics workspace.](data-retention-configure.md)
- [Learn about directly querying Basic and Auxiliary tables.](basic-logs-query.md)
