---
title: Configure a Table Plan in a Log Analytics Workspace
description: Use the Auxiliary, Basic, and Analytics Logs plans to reduce costs and take advantage of advanced analytics capabilities in Azure Monitor Logs.
ms.reviewer: adi.biran
ms.topic: how-to
ms.date: 05/25/2026
ai-usage: ai-assisted

# Customer intent: As a Log Analytics workspace administrator, I want to configure the tables in my Log Analytics workspace so that I pay less for data I use less frequently.
---

# Configure a table plan in a Log Analytics workspace

Log Analytics workspaces store any type of log for any purpose. They support three types of table plans to accomplish this goal: 

| Table plan | Example purpose     |
|:-----------|:------------------|
| **Analytics**  | High-performance analytics and complex queries |
| **Basic**     | Cost-effective storage for less frequently accessed data |
| **Auxiliary / Lake** | High-volume, verbose data for long-term, inexpensive storage and aggregated data trends |

<br>

Review the table plan selection criteria in [Table plans](data-platform-logs.md#table-plans), and then use the following steps to configure the table. 

## Permissions required

| Action | Permissions required |
|:-------|:---------------------|
| View table plan | `Microsoft.OperationalInsights/workspaces/tables/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example |
| Set table plan | `Microsoft.OperationalInsights/workspaces/write` and `microsoft.operationalinsights/workspaces/tables/write` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example |

<br>  

## Set the table plan

Set a custom table's plan when you [create it](create-custom-table.md). Azure tables default to the Analytics plan. Change the plan for any table after it's created based on these criteria:

- All tables support the **Analytics** plan. 
- All DCR-based custom tables support all plans.
- Azure table support for **Basic** and **Auxiliary / Lake** plans varies by table. For more information, see [Logs table feature support](../reference/tables-features.md).

## Change the table plan

Change your table plans to accommodate your data usage and analysis needs. Consider the [feature support of the table plan](data-platform-logs.md#table-feature-comparison) you switch to and the considerations listed here:

| Original table plan | Table plan change | Considerations |
|:------------------|:---------------|:----------------|
| **Basic** or **Auxiliary / Lake** | **Analytics** | You get the full set of features and capabilities in Azure Monitor Logs but the cost increases. |
| **Analytics** | **Basic** if the table supports those plans | - Extra billing for queries including [summary rule queries](summary-rules.md#summary-rule-pricing-model).<br>- **Summary rules** break if the rule uses resource query scope.<br>- Total retention period doesn't change, but data older than 30 days is treated as long-term retention. |
| **Analytics** | **Auxiliary / Lake** if the table supports those plans | - **Alerts** stop working for that table.<br>- Extra billing for queries including [summary rule queries](summary-rules.md#summary-rule-pricing-model).<br>- **Summary rules** break if the rule uses resource query scope.<br> |

<br>

> [!NOTE]
> Table plan updates are limited to one switch per table per week.

The following examples show how to update a table's plan.

# [Azure portal](#tab/portal)

1. From the **Log Analytics workspaces** menu, select **Tables**.

    The **Tables** screen lists all the tables in the workspace.

1. Select the context menu for the table you want to configure and select **Manage table**.

    :::image type="content" source="media/logs-table-plans/manage-common-security-log-table.png" lightbox="media/logs-table-plans/manage-common-security-log-table.png" alt-text="Screenshot that shows the Manage table button for one of the tables in a workspace.":::

1. From the **Table plan** dropdown on the table configuration screen, select **Analytics**, **Basic**, or **Auxiliary / Lake**.

    The **Table plan** dropdown shows the plans available for the selected table.

    :::image type="content" source="media/logs-table-plans/change-azure-table-plan-portal.png" lightbox="media/logs-table-plans/change-azure-table-plan-portal.png" alt-text="Screenshot that shows the table plan update options, including data retention settings for the table configuration screen.":::

1. Select **Save**.

# [Azure CLI](#tab/cli)

The following Azure CLI example uses the [`az monitor log-analytics workspace table update`](/cli/azure/monitor/log-analytics/workspace/table#az-monitor-log-analytics-workspace-table-update) command. It updates the table plan by using the `--plan` parameter, set to `Analytics` or `Basic`.

```bash
# Set variables
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
tableName="<TableName>"

# Update the table plan
az monitor log-analytics workspace table update \
  --resource-group "$resourceGroupName" \
  --workspace-name "$workspaceName" \
  --name "$tableName" \
  --plan Analytics
```

# [Azure PowerShell](#tab/powershell)

The following Azure PowerShell example uses the [`Update-AzOperationalInsightsTable`](/powershell/module/az.operationalinsights/update-azoperationalinsightstable) cmdlet. It updates the table plan by using the `Plan` parameter, set to `Analytics` or `Basic`.

```powershell
# Set variables
$resourceGroupName = "<ResourceGroupName>"
$workspaceName = "<WorkspaceName>"
$tableName = "<TableName>"

# Update the table plan
$updateAzOperationalInsightsTableParams = @{
    ResourceGroupName = $resourceGroupName
    WorkspaceName     = $workspaceName
    TableName         = $tableName
    Plan              = "Basic"
}

Update-AzOperationalInsightsTable @updateAzOperationalInsightsTableParams
```

# [REST](#tab/rest)

The following REST example uses the [`Tables - Update`](../fundamentals/azure-monitor-rest-api-index.md#logs-management) REST API operation. It sets the table `plan` to `Analytics`, `Basic`, or `Auxiliary`.

```REST
PATCH https://management.azure.com/subscriptions/{SubscriptionId}/resourceGroups/{ResourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{WorkspaceName}/tables/{TableName}?api-version={ApiVersion}
Authorization: Bearer {AccessToken}
Content-Type: application/json

{
  "properties": {
    "plan": "Auxiliary"
  }
}
```

---

### Data continuity for table plan changes
 
Changing a table plan requires new access behavior to data ingested after the change. Data ingested before the change is preserved for its retention period. The change doesn't delete or move existing data. How you access the data ingested before the change depends on the table plan before the change.
 
| Table plan change | Data access behavior |
|----|----|
| Analytics to Auxiliary | Data ingested during the Analytics plan before the table plan change is available in the interactive query experience. A single interactive query might get the following warning if it spans the date when Auxiliary / Lake data became available:<br><br>  *"message: Table '{TableName}' has Auxiliary / Lake data starting from {TimeDate}. Query spanning this date may return partial results. Please adjust your query time range to either before or after this date."* |
| Auxiliary to Analytics | Data ingested under the Auxiliary plan before the table plan change isn't available in the interactive query experience. To access the data ingested before the change, run a [search job](search-jobs.md#run-a-search-job) or use the [`search` REST API](basic-logs-query.md#run-a-query-on-a-basic-or-auxiliary-table). Data ingested after the change is fully available for interactive queries. |

## Related content

Learn about [managing data retention](../logs/data-retention-configure.md).
