---
title: Manage tables in a Log Analytics workspace 
description: Learn how to manage table settings in a Log Analytics workspace based on your data analysis and cost management needs.
ms.reviewer: adi.biran
ms.topic: how-to
ms.date: 05/24/2026
# Customer intent: As a Log Analytics workspace administrator, I want to view and manage table properties so that I can manage the data and costs related to a Log Analytics workspace effectively.

---

# Manage tables in a Log Analytics workspace

In a Log Analytics workspace, tables organize log data from your data sources. Configure table properties to manage your data model, data access, and costs. For an overview on table types, column data types, and table schema, see [Tables in Azure Monitor Logs](logs-table-overview.md).

## View table properties

> [!NOTE]
> Table names are case sensitive.

# [Portal](#tab/azure-portal)

To view and set table properties in the Azure portal:

1. From your Log Analytics workspace, select **Tables**.   

    The **Tables** screen presents table configuration information for all tables in your Log Analytics workspace. 

    :::image type="content" source="media/manage-logs-tables/azure-monitor-logs-table-configuration.png" alt-text="Screenshot that shows the Tables screen for a Log Analytics workspace." lightbox="media/manage-logs-tables/azure-monitor-logs-table-configuration.png":::

1. Select the ellipsis (**...**) to the right of a table to open the table management menu.

    The available table management options vary based on the table type. 

    1. Select **Manage table** to edit the table properties.
    
    1. Select **Edit schema** to view and edit the table schema. Even though the `guid` type is available for columns in the table schema, GUID values are stored and queried as strings. For more information, see [Column data types in Azure Monitor Logs](logs-table-overview.md#column-data-types).

# [API](#tab/api)

To manage table properties, call the **Tables** operation of the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management). 

Here's an example of how to call the API to view table properties:

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}?api-version={api-version}
```

**Response body**

|Name | Type | Description |
| --- | --- | --- |
|properties.plan | string  | The table plan. `Analytics`, `Basic`, or `Auxiliary`. |
|properties.retentionInDays | integer  | The table's interactive retention in days. For `Basic` and `Auxiliiary`, this value is 30 days. For `Analytics`, the value is between four and 730 days.|
|properties.totalRetentionInDays | integer  | The table's total data retention, including interactive and long-term retention.|
|properties.archiveRetentionInDays|integer|The table's long-term retention period (read-only, calculated).|
|properties.lastPlanModifiedDate|String|Last time when the plan was set for this table. Null if no change was ever done from the default settings (read-only).

Here's an example of how to call the API to view table schema:

```http
GET https://management.azure.com/subscriptions/ContosoSID/resourcegroups/ContosoRG/providers/Microsoft.OperationalInsights/workspaces/ContosoWorkspace/tables/ContainerLogV2?api-version=2025-02-01
```

**Sample response**
 
Status code: 200
```http
{
    "properties": {
        "retentionInDays": 8,
        "totalRetentionInDays": 8,
        "archiveRetentionInDays": 0,
        "plan": "Basic",
        "lastPlanModifiedDate": "2022-01-01T14:34:04.37",
        "schema": {...},
        "provisioningState": "Succeeded"        
    },
    "id": "subscriptions/ContosoSID/resourcegroups/ContosoRG/providers/Microsoft.OperationalInsights/workspaces/ContosoWorkspace",
    "name": "ContainerLogV2"
}
```

Even though the `guid` type is shown for columns in the table schema, GUID values are stored and queried as strings. For more information, see [Column data types in Azure Monitor Logs](logs-table-overview.md#column-data-types).

# [Azure CLI](#tab/azure-cli)

To view table properties using Azure CLI, run the [az monitor log-analytics workspace table show](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-show) command.

For example:

```azurecli 
az monitor log-analytics workspace table show --subscription ContosoSID --resource-group ContosoRG --workspace-name ContosoWorkspace --name Syslog --output table  
```

To set table properties using Azure CLI, run the [az monitor log-analytics workspace table update](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-update) command.

# [PowerShell](#tab/azure-powershell)

To view table properties using PowerShell, run:

```powershell
Invoke-AzRestMethod -Path "/subscriptions/ContosoSID/resourcegroups/ContosoRG/providers/microsoft.operationalinsights/workspaces/ContosoWorkspace/tables/Heartbeat?api-version=2025-02-01" -Method GET 
```

**Sample response**

```json
{
  "properties": {
    "totalRetentionInDays": 30,
    "archiveRetentionInDays": 0,
    "plan": "Analytics",
    "retentionInDaysAsDefault": true,
    "totalRetentionInDaysAsDefault": true,
    "schema": {
      "tableSubType": "Any",
      "name": "Heartbeat",
      "tableType": "Microsoft",
      "standardColumns": [
        {
          "name": "TenantId",
          "type": "guid",
          "description": "ID of the workspace that stores this record.",
          "isDefaultDisplay": true,
          "isHidden": true
        },
        {
          "name": "SourceSystem",
          "type": "string",
          "description": "Type of agent the data was collected from. Possible values are OpsManager (Windows agent) or Linux.",
          "isDefaultDisplay": true,
          "isHidden": false
        },
        {
          "name": "TimeGenerated",
          "type": "datetime",
          "description": "Date and time the record was created.",
          "isDefaultDisplay": true,
          "isHidden": false
        },
        {
          "name": "ComputerPrivateIPs",
          "type": "dynamic",
          "description": "The list of private IP addresses of the computer.",
          "isDefaultDisplay": true,
          "isHidden": false
        }
      ],
      "solutions": [
        "LogManagement"
      ],
      "isTroubleshootingAllowed": false
    },
    "provisioningState": "Succeeded",
    "retentionInDays": 30
  },
  "id": "/subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/ContosoRG/providers/Microsoft.OperationalInsights/workspaces/ContosoWorkspace/tables/Heartbeat",
  "name": "Heartbeat"
}
```

Even though the `guid` type is available for columns in the table schema, GUID values are stored and queried as strings. For more information, see [Column data types in Azure Monitor Logs](logs-table-overview.md#column-data-types).

Use the [Update-AzOperationalInsightsTable](/powershell/module/az.operationalinsights/Update-AzOperationalInsightsTable) cmdlet to set table properties.

---

## Related content

Learn how to:

- [Understand table types, column types, and GUID handling](logs-table-overview.md)
- [Set a table's log data plan](../logs/logs-table-plans.md)
- [Add custom tables and columns](../logs/create-custom-table.md)
- [Configure data retention](../logs/data-retention-configure.md)
- [Design a workspace architecture](../logs/workspace-design.md)
