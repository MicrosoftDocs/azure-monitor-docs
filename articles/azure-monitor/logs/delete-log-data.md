---
title: Delete data from a Log Analytics workspace by using the Delete Data API (Preview) 
description: Delete data from a specific table in your Log Analytics workspace. 
author: guywi-ms
ms.author: guywild
ms.reviewer: yossiy
ms.service: azure-monitor
ms.topic: how-to 
ms.date: 11/04/2024

# Customer intent: As a Log Analytics workspace administrator, I want to delete data from tables in my Log Analytics workspace if the data is ingested by mistake, corrupt, or includes personal identifiable details.
---

# Delete data from a Log Analytics workspace by using the Delete Data API (Preview) 

This article explains how to delete log entries from a specific table in your Log Analytics workspace by calling the Delete Data API.

## How the Delete Data API works

The Delete Data API removes the relevant rows from the table you specify in your Log Analytics workspace.

The body of the API call consists of filters on one or more columns using which you define which rows of the table you want to delete.

The deletion process is final and irreversible. Therefore, before calling the API, check that your filters produces the intended results by writing a Kusto Query Language (KQL) query in your workspace. Then, translate the query to a list of column filters supported in the Delete Data API.

so the data can't be viewed, retrieved, and used in data analysis. Deleting data doesn't affect billing. To control data retention costs, configure [data retention settings](data-retention-configure.md).

Use the Delete Data API to remove:

- Data ingested by mistake 
- Sensitive or personal data
- Corrupt or incorrect data



## Limitations

You can: 

- Submit 10 delete data requests per hour. 
- Only delete data from a table when the table plan is Analytics. If the table plan is Basic, change the plan to Analytics and then delete the data. You can't delete data from a table with the Auxiliary plan.

## Permissions required

| Action | Permissions required |
|:-------|:---------------------|
| Delete data from a table in a Log Analytics workspace | `Microsoft.OperationalInsights/workspaces/tables/deleteData/action` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

## Call the Delete Data API to delete data from a specific table

To delete rows from a table, use this command: 

```http  
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourcegroup}/providers/Microsoft.
OperationalInsights/workspaces/{workspace_name}tables/{table_name}/deleteData?api-version=2023-09-01
```

Specify filters in the body of the API call - for example:

```json 
{
  "filters": [
    {
      "column": "TimeGenerated",
      "operator": "<",
      "value": "2024-09-23T00:00:00"
    }
  ]
}
```

Where:

- `column` - 
- `operator` - Supported operators are `==`, `=~`, `in`, `in~`, `>`, `>=`, `<`, `<=`, `between`. 
- `value` - 

The example in this section applies a filter on the `TimeGenerated` field, but you can include multiple filters.

## Check delete data operation status 

Azure Monitor Logs executes data deletion operations asynchronously. 

To check the status of the operation, use this command:
 
```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.
OperationalInsights/locations/{region}/operationstatuses/{responseOperation}?api-version=2023-09-01
```


## Next steps

Learn more about:

- [Azure Monitor Logs table plans](../logs/data-platform-logs.md#table-plans)
- [Collecting logs with the Log Ingestion API](../logs/logs-ingestion-api-overview.md)
- [Data collection rules](../essentials/data-collection-endpoint-overview.md)
