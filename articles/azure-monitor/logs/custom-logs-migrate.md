---
title: Migrate from the HTTP Data Collector API to the Logs Ingestion API
description: Learn how to migrate Azure Monitor custom log ingestion from the deprecated HTTP Data Collector API to the Logs ingestion API.
ms.reviewer: ivankh
ms.topic: how-to
ms.date: 05/13/2026
ai-usage: ai-assisted
#customer intent: As a developer, I want to migrate from the HTTP Data Collector API to the Logs ingestion API so that I can continue ingesting custom logs after the Data Collector API deprecation.

---

# Migrate from the HTTP Data Collector API to the Logs ingestion API

The [HTTP Data Collector API](../logs/data-collector-api.md) is deprecated and stops working on **September 14, 2026**. To continue ingesting custom logs into Azure Monitor, migrate to the [Logs ingestion API](../logs/logs-ingestion-api-overview.md), which provides more processing power and flexibility in ingesting logs and [managing tables](../logs/manage-logs-tables.md).

This article describes the differences between the two APIs and how to migrate to the Logs ingestion API.

## Advantages of the Logs ingestion API

The Logs ingestion API provides the following advantages over the Data Collector API:

* Supports [transformations](../data-collection/data-collection-transformations.md), which enable you to modify the data before you ingest it into the destination table, including filtering and data manipulation.
* Lets you send data to multiple destinations.  
* Lets you manage the destination table schema, including column names, and whether to add new columns to the destination table when the source data schema changes.
* Supports role-based access control (RBAC) to restrict data ingestion by data collection rule and identity.

## Prerequisites

To complete this migration, you need:

* A Log Analytics workspace where you have at least [contributor rights](manage-access.md#azure-rbac).
* [Permissions to create data collection rules](../data-collection/data-collection-rule-create-edit.md#permissions) in the Log Analytics workspace.
* [A Microsoft Entra application to authenticate API calls](../logs/tutorial-logs-ingestion-portal.md#create-azure-ad-application) or any other Resource Manager authentication scheme.

## Permissions required

The Logs ingestion API uses OAuth-based authentication via Microsoft Entra (for app registrations or managed identities) and data collection rule (DCR)–scoped RBAC. Assign the app permissions to the DCR and use a data collection endpoint (DCE) or the DCR logs ingestion endpoint for ingestion requests.

| Action | Permissions required |
|:-------|:---------------------|
| Create a data collection endpoint. | `Microsoft.Insights/dataCollectionEndpoints/write` permissions, for example through the [Monitoring Contributor built-in role](/azure/role-based-access-control/built-in-roles#monitoring-contributor). |
| Create or modify a data collection rule. | `Microsoft.Insights/DataCollectionRules/Write` permissions, for example through the [Monitoring Contributor built-in role](/azure/role-based-access-control/built-in-roles#monitoring-contributor). |
| Convert a table that uses the Data Collector API to data collection rules and the Logs ingestion API. | `Microsoft.OperationalInsights/workspaces/tables/migrate/action` permissions, for example through the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor). |
| Create new tables or modify table schemas. | `microsoft.operationalinsights/workspaces/tables/write` permissions, for example through the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor). |
| Call the Logs ingestion API. | See [Assign permissions to a DCR](tutorial-logs-ingestion-api.md#assign-permissions-to-a-dcr). |

## Create new resources required for the Logs ingestion API

The Logs ingestion API requires you to create two new types of resources, which the HTTP Data Collector API doesn't require: 

* [Data collection endpoints](../data-collection/data-collection-endpoint-overview.md), which ingest the data you collect into the pipeline for processing. Optionally use the [DCR ingestion endpoint](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) for direct ingestion without needing to create a separate DCE.
* [Data collection rules](../data-collection/data-collection-rule-overview.md), which define [data transformations](../data-collection/data-collection-transformations.md) and the destination table that receives your ingested data.

## Migrate existing custom tables or create new tables

If you have an existing custom table to which you currently send data by using the Data Collector API, your options are: 

* Migrate the table and switch to the Logs ingestion API. 
* Maintain the existing table and data and set up a new table into which you ingest data by using the Logs ingestion API. Delete the old table when you're ready.
* (Not recommended) Migrate the table but still use the legacy Data Collector API. Changes to existing data types and multiple schema changes to existing Data Collector API custom tables might lead to errors.
  
### Identify classic custom tables

To identify which tables use the Data Collector API, [view table properties](../logs/manage-logs-tables.md#view-table-properties). Tables that use the Data Collector API or ingest data by using the legacy Log Analytics agent (MMA) display **Custom table (classic)** as the **Type** property.

> [!WARNING]
> Migrate from the Log Analytics agent to the Azure Monitor Agent before converting MMA tables. Otherwise, data stops ingesting into custom fields in these tables after the table conversion.

### Migration considerations

[Microsoft Sentinel connectors are transitioning](https://techcommunity.microsoft.com/blog/microsoft-security-blog/action-required-transition-from-http-data-collector-api-in-microsoft-sentinel/4499777) to Codeless Connector Framework (CCF) connectors available via Content Hub. These CCF connectors use DCRs with the Logs ingestion API. This approach provides DCR-governed schema control, applies transformations for normalization, and improves reliability and scalability compared to the legacy Data Collector API. Migration might introduce new or updated table names and schemas. Old Azure Functions–based connectors that use the legacy HTTP Data Collector API and new CCF connectors might temporarily coexist during the transition period. 

When migrating Sentinel connectors, you must update dependent artifacts (analytics rules, hunting queries, workbooks, playbooks, parsers) to reference any new CCF-backed tables or changed schemas. Verify and update KQL queries, alerts, and content packs to prevent ingestion or detection gaps post-migration.

This table summarizes considerations for each option:

|  | Table migration | Side-by-side implementation |
|--|-----------------|-----------------------------|
| **Table and column naming** | Reuse existing table name.<br>Column naming options: <br>- Use new column names and define a transformation to direct incoming data to the newly named column.<br>- Continue using old names. | Set the new table name freely.<br>Adjust integrations, dashboards, and alerts before switching to the new table. |
| **Migration procedure** | One-off table migration. Not possible to roll back a migrated table. | You can migrate gradually, per table. |
| **Post-migration** | If you continue to ingest data by using the HTTP Data Collector API with existing columns, don't change the schema.<br>Create new columns only if you ingest data by using the Logs ingestion API. | Data in the old table is available until the end of the retention period.<br>When you first set up a new table or make schema changes, data changes can take 10-15 minutes to appear in the destination table. |

> [!WARNING]
> If you're still ingesting through the legacy Data Collector API after you migrate a table, don't use the [Tables API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) or the **Edit schema** option in the **Tables** UI to introduce schema changes (for example, adding a new column). Doing so breaks legacy ingestion. If you must continue ingesting by using the Data Collector API, don't make schema changes until you fully migrate to the [Logs ingestion API](logs-ingestion-api-overview.md).

### Convert a table from V1 to V2

To convert a table that uses the Data Collector API (V1) to data collection rules and the Logs ingestion API (V2), run the migrate operation against the table. This call is idempotent, so it has no effect if the table is already converted.

# [Azure CLI](#tab/azure-cli)

Use the [az monitor log-analytics workspace table migrate](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-migrate) command:

```azurecli
az monitor log-analytics workspace table migrate \
  --resource-group "myResourceGroup" \
  --workspace-name "myWorkspace" \
  --table-name "myTable_CL"
```

# [PowerShell](#tab/powershell)

Use the [Invoke-AzOperationalInsightsMigrateTable](/powershell/module/az.operationalinsights/invoke-azoperationalinsightsmigratetable) cmdlet:

```azurepowershell
$migrateTableParams = @{
    ResourceGroupName = 'myResourceGroup'
    WorkspaceName     = 'myWorkspace'
    TableName         = 'myTable_CL'
}

Invoke-AzOperationalInsightsMigrateTable @migrateTableParams
```

# [REST API](#tab/rest-api)

For more information about this API and the latest version, see the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) section and select the Tables API for the `migrate` operation group in the REST API docs.

```REST
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/tables/{tableName}/migrate?api-version=2025-02-01
Authorization: Bearer {accessToken}
Content-Type: application/json
```

---

The `migrate` operation enables all DCR-based custom logs features on the table. If the Data Collector API continues to ingest data into existing columns, it doesn't create any new columns. Any previously defined [custom fields](../logs/custom-fields.md) stop getting new data. Don't change the schema to create new columns or the Data Collector API stops ingesting for the entire table. Apply a [workspace transformation](../logs/tutorial-workspace-transformations-portal.md) to migrate a table to DCRs to delay switching to the Logs ingestion API.

> [!IMPORTANT]
> - Column names must start with a letter and can consist of up to 45 alphanumeric characters and underscores (`_`). 
> - `_ResourceId`, `id`, `_SubscriptionId`, `TenantId`, `Type`, `UniqueId`, and `Title` are reserved column names.
> - Custom columns you add to an Azure table must have the suffix `_CF`.
> - If you update the table schema in your Log Analytics workspace, you must also update the input stream definition in the data collection rule to ingest data into new or modified columns.

## Reduce data size per call

The Logs ingestion API lets you send up to 1 MB of compressed or uncompressed data per call. If you need to send more than 1 MB of data, you can send multiple calls in parallel. This limit differs from the Data Collector API, which lets you send up to 32 MB of data per call.

To call the Logs ingestion API, see [Logs ingestion REST API call](../logs/logs-ingestion-api-overview.md#rest-api-call).

## Handle source data schema changes

The Data Collector API automatically adjusts a destination legacy table's schema when the source data object schema changes, but the Logs ingestion API doesn't. The Logs ingestion API ensures you don't collect new data into columns that you don't intend to create.  

Options when the source data schema changes:

* [Modify destination table schemas](../logs/create-custom-table.md) and [data collection rules](../data-collection/data-collection-rule-create-edit.md) to align with source data schema changes.
* [Define a transformation](../data-collection/data-collection-transformations.md) in the data collection rule to send the new data into existing columns in the destination table.
* Leave the destination table and data collection rule unchanged. In this case, you don't ingest the new data.

> [!NOTE]
> You can't reuse a column name with a data type that differs from the column's original data type. 

## Related content

Microsoft MVP [Morten Waltorp Knudsen](https://mortenknudsen.net/) contributed to this article. For an example of automating the setup and ongoing use of the Logs ingestion API, see his [AzLogDcrIngestPS PowerShell module](https://github.com/KnudsenMorten/AzLogDcrIngestPS).

* [Tutorial: Send custom logs using the Azure portal](tutorial-logs-ingestion-portal.md)
* [Tutorial: Send custom logs using Resource Manager templates and REST API](tutorial-logs-ingestion-api.md)
