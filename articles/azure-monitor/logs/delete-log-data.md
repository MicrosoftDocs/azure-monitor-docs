---
title: Delete data from a Log Analytics workspace by using the Delete Data API (Preview) 
description: Delete data ingested to a specific table in your Log Analytics workspace. 
author: guywi-ms
ms.author: guywild
ms.reviewer: yossiy
ms.service: azure-monitor
ms.topic: how-to 
ms.date: 10/28/2024

# Customer intent: As a Log Analytics workspace administrator, I want to delete data from tables in my Log Analytics workspace if the data is ingested by mistake, corrupt, or includes personal identifiable details.
---

# Delete data from a Log Analytics workspace by using the Delete Data API (Preview) 

The Delete Data API lets you delete entries from a specific table in your Log Analytics workspace.

This article explains how the Delete Data API works and how to remove data from your workspace by calling the API.

## How the Delete Data API works

The Delete Data API removes the relevant rows from the specified table in your Log Analytics workspace based on a given time range and filter. 

Deleting data ensures that the data can no longer be viewed or retrieved and that doesn't affect data analysis, but it doesn't affect billing. To control data retention costs, configure [data retention settings](data-retention-configure.md).

Use the Delete Data API to remove:

- Data ingested by mistake 
- Sensitive or personally identifiable information (PII)
- Corrupt or incorrect data

The deletion process is final and irreversible.

## Permissions required

| Action | Permissions required |
|:-------|:---------------------|
| Delete data from a table in a Log Analytics workspace | `Microsoft.OperationalInsights/workspaces/tables/deleteData/action` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

## Limitations

You can: 
- Submit 10 delete data requests per hour. 
- Only delete data from a table when the table plan is Analytics. If the table plan is Basic, change the plan to Analytics and then delete the data. You can't delete Auxiliary plan isn't supported.

## Call the delete data API to delete data from a specific table

Use this: 

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



## Check delete data operation status 

Operations are executed asynchronously. To check the status of operation:
 
```http
https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.
OperationalInsights/locations/{region}/operationstatuses/{responseOperation}?api-version=2023-09-01
```


## Next steps

Learn more about:

- [Azure Monitor Logs table plans](../logs/data-platform-logs.md#table-plans)
- [Collecting logs with the Log Ingestion API](../logs/logs-ingestion-api-overview.md)
- [Data collection rules](../essentials/data-collection-endpoint-overview.md)
