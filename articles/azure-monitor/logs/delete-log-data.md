---
title: Delete data ingested to a Log Analytics workspace (Preview) 
description: Delete data ingested to a specific table in your Log Analytics workspace. 
author: guywi-ms
ms.author: guywild
ms.reviewer: yossiy
ms.service: azure-monitor
ms.topic: how-to 
ms.date: 10/28/2024

# Customer intent: As a Log Analytics workspace administrator, I want to delete data from tables in my Log Analytics workspace if the data is ingested by mistake, corrupt, or includes personal identifiable details.
---

# Delete data ingested to a Log Analytics workspace (Preview) 


- **Delete incorrect data ingestion** - service team can execute Delete data Geneva action to remove "florin" data from workspace, where Activity log event is sent to customer's subscription with notification and reference to support for more information.
- **Remove privacy data** - customer realized that sensitive or privacy data was ingested to the workspace, and can use Delete data API to remove it.
- **Remove corrupted data** - customer realized that corrupted data was ingested and skew query results, and can use Delete data API to remove it.

## Permissions

## Prerequisites

## Limitations

You can: 
- Submit 10 delete data requests per hour. 
- Only delete data from a table when the table plan is Analytics. If the table plan is Basic, change the plan to Analytics and then delete the data. You can't delete Auxiliary plan isn't supported.

## Call the delete data API to delete data from a specific table

Users can request to delete data in a table using a list of columns, operators, and values as query filter -  Supported operators are ==, =~, in, in~, >, >=, <, <=, between, and have the same behavior as they would in a KQL query. For example:

```json 
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourcegroup}/providers/Microsoft.
OperationalInsights/workspaces/{workspace}/tables/{table}/deleteData?api-version=2023-09-01
```

Specify filters in the body of the API call:

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

## Check delete data operation status 

Operations are executed asynchronously. To check the status of operation:
 
 ```json 
https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.
OperationalInsights/locations/{region}/operationstatuses/{responseOperation}?api-version=2023-09-01
Authorization: {{credential}}
```


## Next steps

Learn more about:

- [Azure Monitor Logs table plans](../logs/data-platform-logs.md#table-plans)
- [Collecting logs with the Log Ingestion API](../logs/logs-ingestion-api-overview.md)
- [Data collection rules](../essentials/data-collection-endpoint-overview.md)
