---
title: Add or Delete Tables and Columns in Azure Monitor Logs
description: Create a table with a custom schema to collect logs from any data source. 
ms.reviewer: adi.biran
ms.custom: devx-track-azurepowershell
ms.topic: how-to 
ms.date: 08/29/2025
# Customer intent: As a Log Analytics workspace administrator, I want to manage table schemas and be able create a table with a custom schema to store logs from an Azure or non-Azure data source.
---

# Add or delete tables and columns in Azure Monitor Logs

[Data collection rules](../data-collection/data-collection-rule-overview.md) let you [filter and transform log data](../data-collection/data-collection-transformations.md) before sending the data to an [Azure table or a custom table](../logs/manage-logs-tables.md#table-type-and-schema). This article explains how to create custom tables and add custom columns to tables in your Log Analytics workspace.

> [!IMPORTANT]
> Whenever you update a table schema, be sure to [update any data collection rules](../data-collection/data-collection-rule-overview.md) that send data to the table. The table schema you define in your data collection rule determines how Azure Monitor streams data to the destination table. Azure Monitor doesn't update data collection rules automatically when you make table schema changes.

## Prerequisites

To create a custom table, you need:

* A Log Analytics workspace where you have at least [contributor rights](../logs/manage-access.md#azure-rbac).
* A [data collection endpoint (DCE)](../data-collection/data-collection-endpoint-overview.md).
* A JSON file with at least one record of sample for your custom table, which looks similar to the following example:

    ```json
    [
      {
        "TimeGenerated": "supported_datetime_format",
        "<column_name_1>": "<column_name_1_value>",
        "<column_name_2>": "<column_name_2_value>"
      },
      {
        "TimeGenerated": "supported_datetime_format",
        "<column_name_1>": "<column_name_1_value>",
        "<column_name_2>": "<column_name_2_value>"
      },
      {
        "TimeGenerated": "supported_datetime_format",
        "<column_name_1>": "<column_name_1_value>",
        "<column_name_2>": "<column_name_2_value>"
      }
    ]
    ``` 

    All tables in a Log Analytics workspace must have a `TimeGenerated` column, which is used to identify the ingestion time of the record. If the column is missing, it's added to the transformation in your DCR for the table. For information about the `TimeGenerated` format, see [supported datetime formats](/azure/data-explorer/kusto/query/scalar-data-types/datetime#supported-formats).

## Create a custom table

Azure tables have predefined schemas. To store log data in a different schema, use data collection rules to define how to collect, transform, and send the data to a custom table in your Log Analytics workspace. To create a custom table with the Auxiliary plan, see [Set up a table with the Auxiliary plan](create-custom-table-auxiliary.md).

> [!IMPORTANT]
> Custom tables have a suffix of **_CL**; for example, *tablename_CL*. The Azure portal adds the **_CL** suffix to the table name automatically. When you create a custom table using a different method, you need to add the **_CL** suffix yourself. The *tablename_CL* in the [DataFlows Streams](../data-collection/data-collection-rule-structure.md#data-flows) properties in your data collection rules must match the *tablename_CL* name in the Log Analytics workspace.

> [!WARNING]
> Table names are used for billing purposes so they shouldn't contain sensitive information.

# [Portal](#tab/azure-portal-1)

To create a custom table using the Azure portal:

1. From the **Log Analytics workspaces** menu, select **Tables**.

    :::image type="content" source="media/manage-logs-tables/azure-monitor-logs-table-configuration.png" lightbox="media/manage-logs-tables/azure-monitor-logs-table-configuration.png" alt-text="Screenshot that shows the Tables screen for a Log Analytics workspace.":::

1. Select **Create** and then **New custom log (DCR-based)**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-custom-log.png" lightbox="media/tutorial-logs-ingestion-portal/new-custom-log.png" alt-text="Screenshot showing new DCR-based custom log.":::

1. Specify a name and, optionally, a description for the table. You don't need to add the *_CL* suffix to the custom table's name - this is added automatically to the name you specify in the portal.

1. Select an existing data collection rule from the **Data collection rule** dropdown, or select **Create a new data collection rule** and specify the **Subscription**, **Resource group**, and **Name** for the new data collection rule. 

    :::image type="content" source="media/tutorial-logs-ingestion-portal/new-data-collection-rule.png" lightbox="media/tutorial-logs-ingestion-portal/new-data-collection-rule.png" alt-text="Screenshot showing new data collection rule.":::

1. Select a [data collection endpoint](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) and select **Next**.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-table-name.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-table-name.png" alt-text="Screenshot showing custom log table name.":::

1. Select **Browse for files** and locate the JSON file with the sample data for your new table.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-browse-files.png" alt-text="Screenshot showing custom log browse for files.":::

    If your sample data doesn't include a `TimeGenerated` column, you receive a message that a transformation is being created with this column.

1. If you want to [transform log data before ingestion](../data-collection/data-collection-transformations.md) into your table:

    1. Select **Transformation editor**.

        The transformation editor lets you create a transformation for the incoming data stream. This is a KQL query that runs against each incoming record. Azure Monitor Logs stores the results of the query in the destination table.

        :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-data-preview.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-data-preview.png" alt-text="Screenshot showing custom log data preview.":::

    1. Select **Run** to view the results.

        :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-query-01.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-query-01.png" alt-text="Screenshot showing initial custom log data query.":::

1. Select **Apply** to save the transformation and view the schema of the table that's about to be created. Select **Next** to proceed.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-final-schema.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-final-schema.png" alt-text="Screenshot showing custom log final schema.":::

1. Verify the final details and select **Create** to save the custom log.

    :::image type="content" source="media/tutorial-logs-ingestion-portal/custom-log-create.png" lightbox="media/tutorial-logs-ingestion-portal/custom-log-create.png" alt-text="Screenshot showing custom log create.":::

# [API](#tab/api-1)

To create a custom table, call the [Tables - Create Or Update API](/rest/api/loganalytics/tables/create-or-update).

# [CLI](#tab/azure-cli-1)

To create a custom table, run the [az monitor log-analytics workspace table create](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-create) command.
# [PowerShell](#tab/azure-powershell-1)

Use the [Tables - Update PATCH API](/rest/api/loganalytics/tables/update) to create a custom table with the following PowerShell code. This code creates a table called *MyTable_CL* with two columns. Modify this schema to collect a different table. 

1. Select the **Cloud Shell** button in the Azure portal and ensure the environment is set to **PowerShell**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/open-cloud-shell.png" lightbox="../logs/media/tutorial-workspace-transformations-api/open-cloud-shell.png" alt-text="Screenshot of opening Cloud Shell in the Azure portal.":::

1. Copy the following PowerShell code and replace the **Path** parameter with the appropriate values for your workspace in the `Invoke-AzRestMethod` command. Paste it into the Cloud Shell prompt to run it.

    ```PowerShell
    $tableParams = @'
    {
        "properties": {
            "schema": {
                "name": "MyTable_CL",
                "columns": [
                    {
                        "name": "TimeGenerated",
                        "type": "DateTime"
                    }, 
                    {
                        "name": "RawData",
                        "type": "String"
                    }
                ]
            }
        }
    }
    '@

    Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{workspace}/tables/MyTable_CL?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
    ```

---

## Delete a table

There are several types of tables in Azure Monitor Logs. You can delete any table that's not an Azure table, but what happens to the data when you delete the table is different for each type of table.

For more information, see [What happens to data when you delete a table in a Log Analytics workspace](../logs/data-retention-configure.md#what-happens-to-data-when-you-delete-a-table-in-a-log-analytics-workspace).

# [Portal](#tab/azure-portal-2)

To delete a table from the Azure portal:

1. From the Log Analytics workspace menu, select **Tables**.

1. Search for the tables you want to delete by name, or by selecting **Search results** in the **Type** field.

    :::image type="content" source="media/search-job/search-results-on-log-analytics-tables-screen.png" alt-text="Screenshot that shows the Tables screen for a Log Analytics workspace with the Filter by name and Type fields highlighted." lightbox="media/search-job/search-results-on-log-analytics-tables-screen.png":::

1. Select the table you want to delete, select the ellipsis ( **...** ) to the right of the table, select **Delete**, and confirm the deletion by typing **yes**.

    :::image type="content" source="media/search-job/delete-table.png" lightbox="media/search-job/delete-table.png" alt-text="Screenshot that shows the Delete Table screen for a table in a Log Analytics workspace.":::

# [API](#tab/api-2)

To delete a table, call the [Tables - Delete API](/rest/api/loganalytics/tables/delete).

# [CLI](#tab/azure-cli-2)

To delete a table, run the [az monitor log-analytics workspace table delete](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-delete) command.

# [PowerShell](#tab/azure-powershell-2)

To delete a table using PowerShell:

1. Select the **Cloud Shell** button in the Azure portal and ensure the environment is set to **PowerShell**.

    :::image type="content" source="../logs/media/tutorial-workspace-transformations-api/open-cloud-shell.png" lightbox="../logs/media/tutorial-workspace-transformations-api/open-cloud-shell.png" alt-text="Screenshot of opening Cloud Shell in the Azure portal.":::

1. Copy the following PowerShell code and replace the **Path** parameter with the appropriate values for your workspace in the `Invoke-AzRestMethod` command. Paste it into the Cloud Shell prompt to run it.

    ```PowerShell
    Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{workspace}/tables/NewCustom_CL?api-version=2021-12-01-preview" -Method DELETE
    ```

---

## Add or delete a custom column

You can modify the schema of custom tables and add custom columns to, or delete columns from, a standard table.

Use these rules when defining column names for custom tables:
 
* Column names must start with a letter (A-Z or a-z).
* After the first character, use only letters, digits, or underscores.
* Don't use spaces, dots, dashes, or other punctuation in column names.
* Non-ASCII letters (for example, Æ, É, Ö) aren't supported in column names.
* Column names are only case sensitive for Analytics and Basic tables. Auxiliary log table ingestion drops data to duplicate column names when the only difference is case.
* Column names must be 2 to 45 characters long.

* Don't use names that conflict with system or reserved columns, including `id`, `BilledSize`, `IsBillable`, `InvalidTimeGenerated`, `TenantId`, `Title`, `Type`, `UniqueId`, `_ItemId`, `_ResourceGroup`, `_ResourceId`, `_SubscriptionId`, `_TimeReceived`.

> [!IMPORTANT]
> The schema rules for custom tables are stricter than [general Kusto identifier rules](/kusto/query/schema-entities/entity-names). Kusto can reference unusual property names with quoting in queries, but the custom table schema accepts only letters, digits, and underscores for column names.

# [Portal](#tab/azure-portal-3)

To add a custom column to a table in your Log Analytics workspace, or delete a column:

1. From the **Log Analytics workspaces** menu, select **Tables**.

1. Select the ellipsis ( **...** ) to the right of the table you want to edit and select **Edit schema**.

    This opens the **Schema Editor** screen.

1. Scroll down to the **Custom Columns** section of the **Schema Editor** screen.
 
    :::image type="content" source="media/create-custom-table/add-or-delete-column-azure-monitor-logs.png" lightbox="media/create-custom-table/add-or-delete-column-azure-monitor-logs.png" alt-text="Screenshot showing the Schema Editor screen with the Add a column and Delete buttons highlighted.":::

1. To add a new column:

    1. Select **Add a column**.
    1. Set the column name and description (optional), and select the expected value type from the **Type** dropdown.
    1. Select **Save** to save the new column.

1. To delete a column, select the **Delete** icon to the left of the column you want to delete.

# [API](#tab/api-3)

To add or delete a custom column, call the [Tables - Create Or Update API](/rest/api/loganalytics/tables/create-or-update).

# [CLI](#tab/azure-cli-3)

To add or delete a custom column, run the [az monitor log-analytics workspace table update](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-update) command.

# [PowerShell](#tab/azure-powershell-3)

To add a new column to an Azure or custom table, run:

```powershell
$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "<TableName>",
            "columns": [
                {
                    "name": ""<ColumnName>",
                    "description": "First custom column",
                    "type": "string",
                    "isDefaultDisplay": true,
                    "isHidden": false
                }
            ]
        }
    }
}
'@

Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{workspace}/tables/<TableName>?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
```

The `PUT` call returns the updated table properties, which should include the newly added column.

**Example**

Run this command to add a custom column, called `Custom1_CF`, to the Azure `Heartbeat` table:

```powershell
$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "Heartbeat",
            "columns": [
                {
                    "name": "Custom1_CF",
                    "description": "The second custom column",
                    "type": "datetime",
                    "isDefaultDisplay": true,
                    "isHidden": false
                }
            ]
        }
    }
}
'@

Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{workspace}/tables/Heartbeat?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
```

Now, to delete the newly added column and add another one instead, run:

```powershell
$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "Heartbeat",
            "columns": [
                {
                    "name": "Custom2_CF",
                    "description": "The second custom column",
                    "type": "datetime",
                    "isDefaultDisplay": true,
                    "isHidden": false
                }
            ]
        }
    }
}
'@

Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{workspace}/tables/Heartbeat?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
```

To delete all custom columns in the table, run:

```powershell
$tableParams = @'
{
    "properties": {
        "schema": {
            "name": "Heartbeat",
            "columns": [
            ]
        }
    }
}
'@

Invoke-AzRestMethod -Path "/subscriptions/{subscription}/resourcegroups/{resourcegroup}/providers/microsoft.operationalinsights/workspaces/{workspace}/tables/Heartbeat?api-version=2021-12-01-preview" -Method PUT -payload $tableParams
```

---

## Next steps

Learn more about:

* [Collecting logs with the Log Ingestion API](../logs/logs-ingestion-api-overview.md)
* [Collecting logs with Azure Monitor Agent](../agents/agents-overview.md)
* [Data collection rules](../data-collection/data-collection-endpoint-overview.md)
