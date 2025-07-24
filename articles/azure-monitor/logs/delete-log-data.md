---
title: Delete data from a Log Analytics workspace by using the Delete Data API 
description: Delete data from a table in your Log Analytics workspace. 
ms.reviewer: yossiy
ms.service: azure-monitor
ms.topic: how-to 
ms.date: 03/11/2025

# Customer intent: As a Log Analytics workspace administrator, I want to delete data from tables in my Log Analytics workspace if the data is ingested by mistake, corrupt, or includes personal identifiable details.
---

# Delete data from a Log Analytics workspace by using the Delete Data API 

The Delete Data API lets you remove data such as sensitive, personal, corrupt, or incorrect log entries.

This article explains how to delete log entries from a specific table in your Log Analytics workspace by calling the Delete Data API.

## How the Delete Data API works

The Delete Data API is ideal for unplanned deletions of individual records. For example, when you discover that corrupt telemetry data was ingested to the workspace and you want to prevent it from skewing query results. The Delete Data API mark records that meet the specified filter criteria as deleted without physically removing them from storage.

To specify which rows of the table you want to delete, you send one or more filters in the body of the API call.

The deletion process is final and irreversible. Therefore, before calling the API, check that your filters produce the intended results by running a query in your workspace, using the Kusto Query Language (KQL) `where` operator.

For example, to delete data from the `AzureMetrics` table based on a `TimeGenerated` value: 

- You might send this filter in the body of your API call:

  ```json 
  {
    "filters": [
      {
        "column": "TimeGenerated",      
        "operator": "==",                
        "value": "2024-09-23T00:00:00"  
      }
    ]
  }
  ```

- Check that your filter returns the entry you want to delete by running this query in your Log Analytics workspace:

  ```kusto
  AzureMetrics
  | where TimeGenerated == "2024-09-23T00:00:00" 
  ```


Delete data requests are asynchronous and typically completed within a few minutes. In extreme cases, a request might be queued up to five days.

If you enable [workspace replication](workspace-replication.md) on your Log Analytics workspace, the API call deletes data from both your primary and secondary workspaces.

## Permissions required

| Action | Permissions required |
|:-------|:---------------------|
| Delete data from a table in a Log Analytics workspace | `Microsoft.OperationalInsights/workspaces/tables/deleteData/action` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

> [!NOTE]
> Delete-data operation doesn't affect on retention charge. The charge for retention is governed by the retention period configured in your [workspace](./data-retention-configure.md#configure-the-default-analytics-retention-period-of-analytics-tables), or [tables](./data-retention-configure.md#configure-table-level-retention).

## Considerations

- You can submit up to 10 Delete Data requests per hour in a single Log Analytics workspace. 
- Delete data API operates on data in Analytics plan. To delete data from a table with the Basic plan, change the plan to Analytics and then delete the data. The Auxiliary plan isn't supported.

## Call the Delete Data API to delete data from a specific table

To delete rows from a table, use this command: 

```http  
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourcegroup}/providers/Microsoft.OperationalInsights/workspaces/{workspace_name}/tables/{table_name}/deleteData?api-version=2023-09-01
Authorization: Bearer eyJ0e...
```

Specify one or more filters in the body of the API call. This example filters on the `TimeGenerated` and `Resource` columns:

```json 
{
  "filters": [
    {
      "column": "TimeGenerated",      
      "operator": "==",                
      "value": "2024-09-23T00:00:00"  
    },
    {
      "column": "Resource",      
      "operator": "==",                
      "value": "VM-1"  
    }
  ]
}
```

#### Filter parameters

| Name | Description|
| - | - |
| `column` | The name of the column in the destination table on which to apply the filter. |
| `operator` | The supported operators are `==`, `=~`, `in`, `in~`, `>`, `>=`, `<`, `<=`, `between`. |
| `value` | The value to filter by, in the supported format. The value can be a specific date, string, or other data type depending on the column. |
 
#### Responses

| Response | Description| 
| - | - |
|202 (accepted)|Asynchronous request received successfully. To check whether your operation succeeded or failed, use the `Azure-AsyncOperation` URL provided in the response header. |
|Other status codes|Error response describing why the operation failed.|



## Check delete data operations and status 

You can track data deletion activities in a workspace through the Azure Activity Log. In the **Log Analytics workspace** menu within the Azure portal, choose **Activity Log** and find **Delete Data from log analytics workspace** events. Select an event and open it in JSON format for details such as number of records deleted, caller, and message.

To check the status of your operation and view the number of deleted records, send a GET request with the `Azure-AsyncOperation` URL provided in the response header:
 
```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.OperationalInsights/locations/{region}/operationstatuses/{responseOperation}?api-version=2023-09-01
Authorization: Bearer eyJ0e...
```

#### Responses
```http
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.OperationalInsights/locations/eastus/operationstatuses/00000000-0000-0000-0000-000000001234",
  "name": "00000000-0000-0000-0000-000000001234",
  "status": "Succeeded",
  "startTime": "2024-11-04T09:31:41.689659Z",
  "endTime": "2024-11-04T09:36:49.0252644Z",
  "properties": {
    "RecordCount": 234812,
    "Status": "Completed"
  }
}
```

For more information, see [Track asynchronous Azure operations](/azure/azure-resource-manager/management/async-operations).

## Next steps

Learn how to:

- [Filter data during ingestion using transformations](../essentials/data-collection-transformations.md)
- [Managing personal data in Azure Monitor Logs](../logs/personal-data-mgmt.md)

