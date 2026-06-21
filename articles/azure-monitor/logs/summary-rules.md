---
title: Aggregate data in a Log Analytics workspace with summary rules
description: Aggregate data in Log Analytics workspace with summary rules feature in Azure Monitor, including creating, starting, stopping, and troubleshooting rules.
ms.subservice: logs
ms.topic: how-to
ms.reviewer: yossi-y
ms.date: 05/27/2026

# Customer intent: As a Log Analytics workspace administrator or developer, I want to optimize my query performance, cost-effectiveness, security, and analysis capabilities by using summary rules to aggregate data I ingest to specific tables.
---

# Aggregate data in a Log Analytics workspace by using summary rules

A summary rule lets you aggregate log data at a regular cadence and send the aggregated results to a custom log table in your Log Analytics workspace. Use summary rules to optimize your data for:

- **Analysis and reports**, especially over large data sets and time ranges, for example, security and incident analysis or month-over-month and annual business reports. Complex queries on a large data set often time out. It's easier and more efficient to analyze and report on _cleaned_ and _aggregated_ summarized data. 

- **Cost savings** on verbose logs, which you retain for as little or as long as you need in a low-cost Basic log table, while sending summarized data to an Analytics table for analysis and reports. 

- **Security and data privacy** by removing or obfuscating privacy details in summarized shareable data and limiting access to tables with raw data.

This article describes how summary rules work and how to define and view summary rules, and provides some examples of the use and benefits of summary rules.

Here's a video that provides an overview of some of the benefits of summary rules:

> [!VIDEO https://www.youtube.com/embed/uuZlOps42LE?cc_load_policy=1&cc_lang_pref=auto]


## How summary rules work

Summary rules perform batch processing directly in your Log Analytics workspace. The summary rule aggregates chunks of data, defined by bin size, based on a KQL query, and re-ingests the summarized results into a custom table with an [Analytics log plan](logs-table-plans.md) in your Log Analytics workspace. 

:::image type="content" source="media/summary-rules/summary-rule-azure-monitor.png" alt-text="A diagram that shows how data is ingested into a Log Analytics workspace and is aggregated and re-ingested into the workspace by using a summary rule." lightbox="media/summary-rules/summary-rule-azure-monitor.png":::

Summary rules aggregate data from any table, regardless of whether the table has an [Analytics or Basic data plan](basic-logs-query.md). Azure Monitor creates the destination table schema based on the query you define. If the destination table already exists, Azure Monitor appends any columns required to support the query results. All destination tables also include a set of standard fields with summary rule information, including: 

- `_RuleName`: The summary rule that generated the aggregated log entry.
- `_RuleLastModifiedTime`: When the rule was last modified. 
- `_BinSize`: The aggregation interval.  
- `_BinStartTime`: The aggregation start time.

Configure up to 100 active rules to aggregate data from multiple tables and send the aggregated data to separate destination tables or the same table. 

To export summarized data from a custom log table to a storage account or Event Hubs for further integrations, define a [data export rule](logs-data-export.md).

### Example: Summarize ContainerLogV2 data

If you're monitoring containers, you ingest a large volume of verbose logs into the `ContainerLogV2` table.

You might use this query in your summary rule to aggregate unique records within 60 minutes, only promoting the data that's useful for analysis to the destination table:

```kusto
ContainerLogV2 
| summarize Count = count() 
  by
  Computer, 
  ContainerName,
  PodName, 
  PodNamespace, 
  LogSource, 
  LogLevel, 
  Message = tostring(LogMessage.Message)
```

Here's the raw data in the `ContainerLogV2` table:

:::image type="content" source="media/summary-rules/summary-rules-raw-data-verbose-logs.png" alt-text="Screenshot that shows raw log data in the ContainerLogV2 table." lightbox="media/summary-rules/summary-rules-raw-data-verbose-logs.png":::

Here's the aggregated data that the summary rule sends to the destination table:

:::image type="content" source="media/summary-rules/summary-rules-aggregated-logs.png" alt-text="Screenshot that shows aggregated data that the summary rule sends to the destination table." lightbox="media/summary-rules/summary-rules-aggregated-logs.png":::

Instead of logging hundreds of similar entries within an hour, the destination table shows the count of each unique entry, as defined in the KQL query. Set the [Basic data plan](logs-table-plans.md) on the `ContainerLogV2` table for low-cost retention of the raw data, and use the summarized data in the destination table for your analysis needs.

## Permissions required

| Action | Permissions required |
| --- | --- |
| Create or update summary rule | `Microsoft.Operationalinsights/workspaces/summarylogs/write` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example |
| Create or update destination table | `Microsoft.OperationalInsights/workspaces/tables/write` permissions to the Log Analytics workspace, as provided by the [Log Analytics Contributor built-in role](manage-access.md#log-analytics-contributor), for example |
| Enable query operation in workspace | `Microsoft.OperationalInsights/workspaces/query/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |
| Query all tables in workspace | `Microsoft.OperationalInsights/workspaces/query/*/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |
| Query logs in a table | `Microsoft.OperationalInsights/workspaces/query/<table>/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |
| Query logs in a table (table action) | `Microsoft.OperationalInsights/workspaces/tables/query/read` permissions to the Log Analytics workspace, as provided by the [Log Analytics Reader built-in role](manage-access.md#log-analytics-reader), for example |
| Use queries encrypted in a customer-managed storage account | `Microsoft.Storage/storageAccounts/*` permissions to the storage account, as provided by the [Storage Account Contributor built-in role](/azure/role-based-access-control/built-in-roles/storage#storage-account-contributor), for example |


## Implementation considerations

- The maximum number of active rules in a workspace is 100.
- Summary rules are currently only available in the public cloud.
- The summary rule processes incoming data and doesn't allow a historical time range. Data can only be processed from the recent past up to 24 hours. This corresponds to a maximum `binSize` of 1440 minutes when `binStartTime` is set to the full 24-hour window.
- Creating a summary rule with a query across another tenant under Lighthouse isn't supported.
- Adding [workspace transformation](tutorial-workspace-transformations-portal.md#add-a-transformation-to-the-table) to a summary rule's destination table isn't supported.
- Using `union *` and `isfuzzy=true` in summary rule queries isn't supported.

## Summary rule pricing model

Summary rules incur no extra cost. You only pay for the query and the ingestion of results to the destination table, based on the table plan of the source table on which you run the query:

| Source table plan | Query cost | Summary results ingestion cost |
| --- | --- | --- |
| Analytics | No cost    | Ingestion of Analytics logs | 
| Basic and Auxiliary    | Data scan | Ingestion of Analytics logs | 

For example, the cost calculation for an hourly rule that returns 100 records per bin is:

| Source table plan | Monthly price calculation |
| --- | --- |
| Analytics  | Ingestion price x record volume x number of records x 24 hours x 30 days. | 
| Basic and Auxiliary | Data scan price x scanned volume + Ingestion price x record volume x number of records x 24 hours x 30 days. For continuously running rule, all incoming data to source table is scanned. | 

For more information, see [Azure Monitor pricing](https://azure.microsoft.com/pricing/details/monitor/).

## Create or update a summary rule

The operators available in your summary rule query depend on the plan of the source table in the query.

- Analytics: Supports all KQL operators and functions, except for:
  - [Cross-resource queries](cross-workspace-query.md), which use the `workspaces()`, `app()`, and `resource()` expressions, and [cross-service queries](azure-monitor-data-explorer-proxy.md), which use the `ADX()` and `ARG()` expressions.
  - Plugins that reshape the data schema, including [bag unpack](/azure/data-explorer/kusto/query/bag-unpack-plugin), [narrow](/azure/data-explorer/kusto/query/narrow-plugin), and [pivot](/azure/data-explorer/kusto/query/pivot-plugin).
- Basic: Supports all KQL operators on a single table. Join up to five Analytics tables using the [lookup](/azure/data-explorer/kusto/query/lookup-operator) operator.
- Functions: User-defined functions aren't supported. System functions provided by Microsoft are supported.

Summary rules deliver the most cost and query benefits when the rule query includes the `summarize` operator and the result count or volume is reduced significantly. For example, aim for a result volume of 0.01% or less of the source. Before you create a rule, test the query in [Log Analytics](log-analytics-overview.md) and verify the following:

1. The query produces the intended results and schema.
1. The query doesn't reach or come near the [query API limits](../service-limits.md#log-analytics-workspaces). If the query is close to the query limits, consider using a smaller `binSize` to process less data per bin. As an alternative, modify the query to return fewer records or fewer high-volume fields.
1. The record size in the results is less than 1 MB.

> [!NOTE]
> Do not use a time filter in a summary rule query because the query already operates over the time range defined by the bin size. If you add a time filter, it combines with the bin size, resulting in only the overlapping time period being used.

When you update a query and the summary results contain fewer fields, Azure Monitor doesn't automatically remove the columns from the destination table. [Delete columns from your table](create-custom-table.md#add-or-delete-a-custom-column) manually if needed.

To create or update a summary rule:

# [Azure portal](#tab/portal-1)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu under **Settings**, select **Rules**.
1. Select the **Summary rules** tab.

   :::image type="content" source="media/summary-rules/summary-rules-overview.png" alt-text="Screenshot that shows the overview of the summary rule experience in the Azure portal." lightbox="media/summary-rules/summary-rules-overview.png":::

1. Select **+ Create** to create a new summary rule. 
1. Fill in the **Rule name**, **Description**, and **Destination table**, then select **Next: Set rule logic**.

   :::image type="content" source="media/summary-rules/summary-rules-create-basics.png" alt-text="Screenshot that shows the create summary rule experience in the Azure portal." lightbox="media/summary-rules/summary-rules-create-basics.png":::

1. The **Rule logic** step starts in the query experience of Log Analytics. Craft and test your query here, then **Apply** once it produces the results you expect. 

   :::image type="content" source="media/summary-rules/summary-rules-create-rule-logic.png" alt-text="Screenshot that shows the create summary rule logic experience in the Azure portal." lightbox="media/summary-rules/summary-rules-create-rule-logic.png":::

1. Select the **Run summary every** value which corresponds to `binSize` and adjust other scheduling options as needed. Then select **Next: Review + create**.
1. Review the summary rule settings, then select **Create**.

# [Azure CLI](#tab/azure-cli-1)

Use the following command to create or update a summary rule by using Azure CLI. The `<RuleName>` becomes the `name` property for the rule, while the optional `displayName` is a user-friendly name shown in the Azure portal for easier identification.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
ruleName="<RuleName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

az rest --method put --url "$url" --body @body.json
```

Save the following JSON as **body.json** in the same directory before running the command:

```json
{
  "properties": {
    "ruleType": "User",
    "description": "My test rule",
    "ruleDefinition": {
      "query": "StorageBlobLogs | summarize count() by AccountName",
      "binSize": 30,
      "destinationTable": "MySummaryLogs_CL"
    }
  }
}
```

# [Azure PowerShell](#tab/powershell-1)

Use the following command to create or update a summary rule by using Azure PowerShell. The `<RuleName>` becomes the `name` property for the rule, while the optional `displayName` is a user-friendly name shown in the Azure portal for easier identification.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$ruleName = '<RuleName>'
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

$body = @{
    properties = @{
        ruleType = "User"
        description = "My test rule"
        ruleDefinition = @{
            query = "StorageBlobLogs | summarize count() by AccountName"
            binSize = 30
            destinationTable = "MySummaryLogs_CL"
        }
    }
} | ConvertTo-Json -Depth 10

Invoke-AzRestMethod -Method PUT -Path $url -Payload $body
```

# [REST API](#tab/rest-1)

Use the following `PUT` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `create or update` a summary rule. The `<RuleName>` becomes the `name` property for the rule, while the optional `displayName` is a user-friendly name shown in the Azure portal for easier identification.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs/{ruleName}?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json

{
  "properties": {
    "ruleType": "User",
    "description": "My test rule",
    "ruleDefinition": {
      "query": "StorageBlobLogs | summarize count() by AccountName",
      "binSize": 30,
      "destinationTable": "MySummaryLogs_CL"
    }
  }
}
```

# [ARM template](#tab/json-1)

Use this template to create or update a summary rule. For more information about using and deploying Azure Resource Manager templates, see [Azure Resource Manager templates](/azure/azure-resource-manager/templates/syntax). The `summaryRuleName` parameter, which corresponds to your input `<RuleName>`, becomes the `name` property for the rule, while the optional `displayName` is a user-friendly name shown in the Azure portal for easier identification.

<details>
<summary>Create or update a summary rule template</summary>

#### Template file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "String",
      "metadata": {
        "description": "The workspace name where summary rule is deployed."
      }
    },
    "summaryRuleName": {
      "type": "String",
      "metadata": {
        "description": "The summary rule name."
      }
    },
    "description": {
      "type": "String",
      "metadata": {
        "description": "A description of the rule."
      }
    },
    "location": {
      "defaultValue": "[resourceGroup().location]",
      "type": "String",
      "metadata": {
        "description": "The Location of the workspace summary rule is deployed."
      }
    },
    "ruleType": {
      "defaultValue": "User",
      "allowedValues": [
        "User"
      ],
      "type": "String",
      "metadata": {
        "description": "The summary rule type (User,System). Should be 'User' for and rule with query that you define."
      }
    },
    "query": {
      "type": "String",
      "metadata": {
      "description": "The query used in summary rules."
      }
    },
    "binSize": {
      "defaultValue": 60,
      "allowedValues": [
        20,
        30,
        60,
        120,
        180,
        360,
        720,
        1440
      ],
      "type": "Int",
      "metadata": {
        "description": "The execution interval in minutes, and the lookback time range."
      }
    },
    "destinationTable": {
      "type": "String",
      "metadata": {
        "description": "The name of the custom log table that the summary results are sent to. Name must end with '_CL'."
      }
    }
    // ----- optional -----
    // "displayName": {
    //   "type": "String",
    //   "metadata": {
    //     "description": "Optional - The summary rule display name when provided."
    //   }
    // },
    // "binDelay": {
    //   "type": "Int",
    //   "metadata": {
    //     "description": "Optional - The minimum wait time in minutes before bin execution. For example, value of '10' cause bin (01:00-02:00) to be executed after 02:10."
    //   }
    // },
    // "timeSelector": {
    //   "defaultValue": "TimeGenerated",
    //   "allowedValues": [
    //     "TimeGenerated"
    //   ],
    //   "type": "String",  
    //   "metadata": {
    //     "description": "Optional - The time field to be used by the summary rule. Must be 'TimeGenerated'."
    //   }
    // },
    // "binStartTime": {
    //   "type": "String",
    //   "metadata": {
    //     "description": "Optional - The Time of initial bin. Can start at current time minus binSize, or future, and in whole hours. For example: '2024-01-01T08:00'."
    //   }
    // }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/summaryLogs",
      "apiVersion": "2025-07-01",
      //"name": "[format('{0}/{1}', parameters('workspaceName'), parameters('summaryRuleName'))]",
      "name": "[concat(parameters('workspaceName'), '/', parameters('summaryRuleName'))]",
      "properties": {
        "ruleType": "[parameters('ruleType')]",
        "description": "[parameters('description')]",
        "ruleDefinition": {
          "query": "[parameters('query')]",
          "binSize": "[parameters('binSize')]",
          "destinationTable": "[parameters('destinationTable')]"
          // ----- optional -----
          //"binDelay": "[parameters('binDelay')]",
          //"timeSelector": "[parameters('timeSelector')]",
          //"binStartTime": "[parameters('binStartTime')]"
        }
      }
    }
  ]
}
```


#### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "value": "<WorkspaceName>"
    },
    "summaryRuleName": {
      "value": "<RuleName>"
    },
    "description": {
      "value": "My rule description"
    },
    "location": {
      "value": "<AzureRegion>" //Log Analytics workspace region
    },
    "ruleType": {
      "value": "User"
    },
    "query": {
      "value": "StorageBlobLogs | summarize Count = count(), DurationMs98 = percentile(DurationMs, 90) by StatusCode, CallerIpAddress, OperationName"
    },
    "binSize": {
      "value": 20
    },
    "destinationTable": {
      "value": "MySummaryLogs_CL"
    }
  }
}
```

</details>

---

### Summary rule properties

This table describes the parameters available for summary rule creation and management.

| Parameter | Valid values | Description |
| --- | --- | --- |
| `ruleType` | `User` or `System` | Specifies the type of rule. <br> - `User`: Rules you define. <br> - `System`: Predefined rules managed by Azure services. |
| `description` | String | Describes the rule and its function. This parameter is helpful when you have several rules and can help with rule management. |
| `binSize` |`20`, `30`, `60`, `120`, `180`, `360`, `720`, or `1440` (minutes) | Defines the aggregation interval and lookback time range. For example, if you set `"binSize": 120`, you might get entries for `02:00 to 04:00` and `04:00 to 06:00`.|
| `query` | [Kusto Query Language (KQL) query](get-started-queries.md) | Defines the query to execute in the rule. You don't need to specify a time range because the `binSize` parameter determines the aggregation interval, for example, `02:00 to 03:00` if `"binSize": 60`. If you add a time filter in the query, the time range used in the query is the intersection between the filter and the bin size. |
| `destinationTable` | tablename_CL | Specifies the name of the destination custom log table. The name value must have the suffix `_CL`. Azure Monitor creates the table in the workspace, if it doesn't already exist, based on the query you set in the rule. If the table already exists in the workspace, Azure Monitor adds any new columns introduced in the query. <br><br> If the summary results include a reserved column name - such as `TimeGenerated`, `_IsBillable`, `_ResourceId`, `TenantId`, or `Type` - Azure Monitor appends the `_Original` prefix to the original fields to preserve their original values.|
| `binDelay` (optional) | Integer (minutes) | Sets a time to wait before bin execution, typically useful when executed on late arriving data, also known as [ingestion latency](data-ingestion-time.md), and allows most data to arrive. The default delay is from three and a half minutes to 10% of the `binSize` value. <br><br> If you know that the data you query is typically ingested with delay, set the `binDelay` parameter with the known delay value or greater, up to 1440 minutes. For more information, see [Configure the aggregation timing](#configure-the-aggregation-timing).<br>In some cases, Azure Monitor might begin bin execution slightly after the set bin delay to ensure service reliability and query success.|
| `retryBinStartTime` | Datetime in<br>`%Y-%n-%eT%H:%M %Z` format | Rerun a bin by provided `retryBinStartTime`. The rest of the rule's definitions remain per last update. The chosen `retryBinStartTime` value must be after `RuleLastModifiedTime` and fit within the divisions of `binSize`. For example, if the rule's `binSize` is 20 minutes, you could set `retryBinStartTime` to "2026-02-16T10:00:00Z", "2026-02-16T10:20:00Z", or "2026-02-16T10:40:00Z".|
| `binStartTime` (optional) | Datetime in<br>`%Y-%n-%eT%H:%M %Z` format | Specifies the date and time for the initial bin execution. The value can start at rule creation datetime minus the `binSize` value, or later and in whole hours. For example, if the datetime is `2023-12-03T12:13Z` and `binSize` is 1,440, the earliest valid `binStartTime` value is `2023-12-02T13:00Z`, and the aggregation includes data logged between 02T13:00 and 03T13:00. In this scenario, the rules start aggregating a 03T13:00 plus the default or specified delay. <br><br> The `binStartTime` parameter is useful in daily summary scenarios. Suppose you're in the UTC-8 time zone and you create a daily rule at `2023-12-03T12:13Z`. You want the rule to complete before you start your day at 8:00 (00:00 UTC). Set the `binStartTime` parameter to `2023-12-02T22:00Z`. The first aggregation includes all data logged between 02T:06:00 and 03T:06:00 local time, and the rule runs at the same time daily. For more information, see [Configure the aggregation timing](#configure-the-aggregation-timing).<br><br> When you update rules, choose one of the following options: <br> - Use the existing `binStartTime` value or remove the `binStartTime` parameter, in which case execution continues based on the initial definition.<br> - Update the rule with a new `binStartTime` value to set a new datetime value. |
| `name` | String | Specifies the rule name. The name must be unique within the workspace and can contain letters, numbers, underscores, hyphens, and periods (no spaces). The name value is used in the `_RuleName` field in the destination table. |
| `displayName` (optional) | String | Specifies the rule display name in Azure portal experiences. |
| `timeSelector` (optional) | `TimeGenerated` | Defines the timestamp field that Azure Monitor uses to aggregate data. For example, if you set `"binSize": 120`, you might get entries with a `TimeGenerated` value between `02:00` and `04:00`. |

### Configure the aggregation timing

By default, the summary rule creates the first aggregation shortly after the next whole hour. 

The short delay Azure Monitor adds accounts for ingestion latency, which is the time between when the data is created in the monitored system and the time it becomes available for analysis in Azure Monitor. By default, this delay is between three and a half minutes and 10% of the bin size value before aggregating each bin. In most cases, this delay ensures that Azure Monitor aggregates all data logged within each bin period.

For example: 

- You create a summary rule with a bin size of 30 minutes at 14:44. The first aggregation is generated at 15:04, which is the next whole hour plus 4 minutes delay.
- You create a summary rule with a bin size of 720 minutes at 14:44. The first aggregation is generated at 16:12, which is the next whole hour plus 72 minutes (10% of the 720 bin size) delay. 

Use the `binStartTime` and `binDelay` parameters to change the timing of the first aggregation and the delay Azure Monitor adds before each aggregation.

The next sections provide examples of the default aggregation timing and the more advanced aggregation timing options.

#### Use default aggregation timing 

In this example, the summary rule is created on 2023-06-07 at 14:44, and Azure Monitor adds a default delay of **four minutes**.

| binSize (minutes) | Initial rule run | First aggregation | Second aggregation |
| --- | --- | --- | --- |
| 1440  | 2023-06-07 15:04 | 2023-06-06 15:00 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-08 15:00 |
|  720  | 2023-06-07 15:04 | 2023-06-07 03:00 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-08 03:00 |
|  360  | 2023-06-07 15:04 | 2023-06-07 09:00 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-07 21:00 |
|  180  | 2023-06-07 15:04 | 2023-06-07 12:00 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-07 18:00 |
|  120  | 2023-06-07 15:04 | 2023-06-07 13:00 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-07 17:00 |
|   60  | 2023-06-07 15:04 | 2023-06-07 14:00 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-07 16:00 |
|   30  | 2023-06-07 15:04 | 2023-06-07 14:30 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-07 15:30 |
|   20  | 2023-06-07 15:04 | 2023-06-07 14:40 - 2023-06-07 15:00 | 2023-06-07 15:00 - 2023-06-07 15:20 |

#### Set optional aggregation timing parameters

In this example, the summary rule is created on 2023-06-07 at 14:44, and the rule includes these advanced configuration settings:
- `binStartTime`: 2023-06-08 07:00
- `binDelay`: **8 minutes**

| binSize (minutes) | Initial rule run | First aggregation | Second aggregation |
| --- | --- | --- | --- |
| 1440 | 2023-06-09 07:08 | 2023-06-08 07:00 - 2023-06-09 07:00 | 2023-06-09 07:00 - 2023-06-10 07:00 |
|  720 | 2023-06-08 19:08 | 2023-06-08 07:00 - 2023-06-08 19:00 | 2023-06-08 19:00 - 2023-06-09 07:00 |
|  360 | 2023-06-08 13:08 | 2023-06-08 07:00 - 2023-06-08 13:00 | 2023-06-08 13:00 - 2023-06-08 19:00 |
|  180 | 2023-06-08 10:08 | 2023-06-08 07:00 - 2023-06-08 10:00 | 2023-06-08 10:00 - 2023-06-08 13:00 |
|  120 | 2023-06-08 09:08 | 2023-06-08 07:00 - 2023-06-08 09:00 | 2023-06-08 09:00 - 2023-06-08 11:00 |
|   60 | 2023-06-08 08:08 | 2023-06-08 07:00 - 2023-06-08 08:00 | 2023-06-08 08:00 - 2023-06-08 09:00 |
|   30 | 2023-06-08 07:38 | 2023-06-08 07:00 - 2023-06-08 07:30 | 2023-06-08 07:30 - 2023-06-08 08:00 |
|   20 | 2023-06-08 07:28 | 2023-06-08 07:00 - 2023-06-08 07:20 | 2023-06-08 07:20 - 2023-06-08 07:40 |

## View all summary rules

View or enumerate all the summary rules in your workspace. 

The `displayName` property of the summary rule visible in the Azure portal is different from the `name` property used in API calls, especially if you created the rule through the portal. The `name` property is the unique identifier for the rule and is used in API calls to manage the rule. The `displayName` is a user-friendly name shown in the Azure portal for easier identification.

# [Azure portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu under **Settings**, select **Rules**.
1. Select the **Summary rules** tab.

:::image type="content" source="media/summary-rules/view-all-summary-rules.png" alt-text="Screenshot that shows the Summary rules pane with all summary rules in the Azure portal." lightbox="media/summary-rules/view-all-summary-rules.png":::

# [Azure CLI](#tab/azure-cli-2)

Use the following command to view all summary rules by using Azure CLI.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs?api-version=$apiVersion"

az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell-2)

Use the following command to view all summary rules by using Azure PowerShell.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs?api-version=$apiVersion"

Invoke-AzRestMethod -Method GET -Path $url
```

# [REST API](#tab/rest-2)

Use the following `GET` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `view` all summary rules.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json
```

---

## View a summary rule

View or update the configuration for a specific summary rule.

# [Azure portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu under **Settings**, select **Rules**.
1. Select the **Summary rules** tab.
1. Select the **ellipsis (...)** next to the summary rule you want to view from the list.
1. Select **Edit** to view the summary rule configuration.

   :::image type="content" source="media/summary-rules/view-edit-summary-rule.png" alt-text="Screenshot that shows the selected summary rule in the Azure portal with the edit option." lightbox="media/summary-rules/view-edit-summary-rule.png":::

1. Select **Next: Set rule logic** to view the query used in the summary rule.

# [Azure CLI](#tab/azure-cli-2)

Use the following command to view a summary rule by using Azure CLI. The `<RuleName>` is the `name` property for the rule, while the `displayName` is a user-friendly name shown in the Azure portal for easier identification.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
ruleName="<RuleName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

az rest --method get --url "$url"
```

# [Azure PowerShell](#tab/powershell-2)

Use the following command to view a summary rule by using Azure PowerShell.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$ruleName = '<RuleName>'
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

Invoke-AzRestMethod -Method GET -Path $url
```

# [REST API](#tab/rest-2)

Use the following `GET` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `view` a summary rule.

```REST
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs/{ruleName}?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json
```

---


## Stop a summary rule

Stop a rule for a period of time. One example use case is when you want to verify that data is ingested to a table without affecting the summarized table and reports.

To stop a rule:

# [Azure portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu under **Settings**, select **Rules**.
1. Select the **Summary rules** tab.
1. Select the *Active* **Status** toggle button and confirm the status changes to *Inactive*.

:::image type="content" source="media/summary-rules/stop-summary-rule.png" alt-text="Screenshot that shows the selected summary rule in the Azure portal with the status toggle button set to inactive." lightbox="media/summary-rules/stop-summary-rule.png":::

# [Azure CLI](#tab/azure-cli-2)

Use the following command to stop a summary rule by using Azure CLI.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
ruleName="<RuleName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs/$ruleName/stop?api-version=$apiVersion"

az rest --method post --url "$url"
```

# [Azure PowerShell](#tab/powershell-2)

Use the following command to stop a summary rule by using Azure PowerShell.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$ruleName = '<RuleName>'
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs/$ruleName/stop?api-version=$apiVersion"

Invoke-AzRestMethod -Method POST -Path $url
```

# [REST API](#tab/rest-2)

Use the following `POST` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `stop` a summary rule.

```REST
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs/{ruleName}/stop?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json
```

---

## Start a summary rule

When you restart the rule, Azure Monitor starts processing data from the next whole hour or based on the defined `binStartTime` (optional) parameter.

To start a rule:

# [Azure portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu under **Settings**, select **Rules**.
1. Select the **Summary rules** tab.
1. Select the *Inactive* **Status** toggle button and confirm the status changes to *Active*.

:::image type="content" source="media/summary-rules/start-summary-rule.png" alt-text="Screenshot that shows the selected summary rule in the Azure portal with the status toggle button set to active." lightbox="media/summary-rules/start-summary-rule.png":::

# [Azure CLI](#tab/azure-cli-2)

Use the following command to start a summary rule by using Azure CLI.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
ruleName="<RuleName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs/$ruleName/start?api-version=$apiVersion"

az rest --method post --url "$url"
```

# [Azure PowerShell](#tab/powershell-2)

Use the following command to start a summary rule by using Azure PowerShell.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$ruleName = '<RuleName>'
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs/$ruleName/start?api-version=$apiVersion"

Invoke-AzRestMethod -Method POST -Path $url
```

# [REST API](#tab/rest-2)

Use the following `POST` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `start` a summary rule.

```REST
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs/{ruleName}/start?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json
```

---

## Delete a summary rule

A Log Analytics workspace supports up to 100 active summary rules. If you already have 100 active rules and want to create a new one, you must first stop or delete an active summary rule. 

To delete a rule:

# [Azure portal](#tab/portal-2)

1. From the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. In the left menu under **Settings**, select **Rules**.
1. Select the **Summary rules** tab.
1. Select the **ellipsis (...)** next to the summary rule you want to view from the list.
1. Select **Delete**.

# [Azure CLI](#tab/azure-cli-2)

Use the following command to delete a summary rule by using Azure CLI.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
ruleName="<RuleName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

az rest --method delete --url "$url"
```

# [Azure PowerShell](#tab/powershell-2)

Use the following command to delete a summary rule by using Azure PowerShell.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$ruleName = '<RuleName>'
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

Invoke-AzRestMethod -Method DELETE -Path $url
```

# [REST API](#tab/rest-2)

Use the following `DELETE` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `delete` a summary rule.

```REST
DELETE https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs/{ruleName}?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json
```

---

## Monitor summary rules

To monitor summary rules, enable the **Summary Logs** category in the [diagnostic settings](../essentials/create-diagnostic-settings.md) of your Log Analytics workspace. Azure Monitor sends summary rule execution details, including summary rule run Start, Succeeded, and Failed information, to the [LASummaryLogs](/azure/azure-monitor/reference/tables/lasummarylogs) table in your workspace. 

[Set up log alert rules](../alerts/alerts-create-log-alert-rule.md) to receive notifications of bin failures or when bin execution nears time-out, as shown in the following examples. Depending on the failure reason, either reduce the bin size to process less data on each execution, or modify the query to return fewer records or fewer high-volume fields.

This query returns failed runs:

```kusto
LASummaryLogs | where Status == "Failed"
```

This query returns bin runs where the `QueryDurationMs` value is greater than 90% of the [maximum query running time](../fundamentals/service-limits.md#query-api):

```kusto
LASummaryLogs | where QueryDurationMs > 0.9 * 600000
```

### Verify data completeness

Summary rules are designed for scale and include a retry mechanism to overcome transient service or query failures related to [query limits](../service-limits.md#log-analytics-workspaces). The retry mechanism makes 10 attempts to aggregate a failed bin within eight hours and skips the bin if all attempts are exhausted. The rule is set to `isActive: false` and put on hold after eight consecutive bin retries.

If you enable the diagnostic setting to [monitor summary rules](#monitor-summary-rules), Azure Monitor logs events in the `LASummaryLogs` table in your workspace, letting you view runs and [retry failed ones](#retry-a-summary-rule-bin). View runs with the following query or through the portal.

```kusto
let startTime = datetime("2024-02-16");
let endTime = datetime("2024-03-03");
let ruleName = "myRuleName";
let stepSize = 20m; // The stepSize value is equal to the bin size defined in the rule
LASummaryLogs
| where RuleName == ruleName
| where Status == 'Succeeded'
| make-series dcount(BinStartTime) default=0 on BinStartTime from startTime to endTime step stepSize
| render timechart
```
This query renders the results as a timechart:

:::image type="content" source="media/summary-rules/data-completeness.png" alt-text="Screenshot that shows a graph that charts the query results for failed bins in summary rules." lightbox="media/summary-rules/data-completeness.png":::

See the [Monitor summary rules](#monitor-summary-rules) section for rule remediation options and proactive alerts.

## Retry a summary rule bin

Summary rules are designed for scale and include a retry mechanism to overcome transient service issues or query limit failures. When service retries are exhausted, retry the failed run (or *bin*) manually.

# [Azure portal](#tab/portal-1)

1. Select the **ellipsis (...)** at the far right of the summary rule you want to retry.
1. Select **View runs** from the menu.
1. Change the filter to show **Failed** runs.
1. Find the **Run time** you want to retry and select the **ellipsis (...)** at the end of the row.
1. Select **Rerun this bin** from the menu.

:::image type="content" source="media/summary-rules/summary-rules-rerun-bin.png" alt-text="Screenshot that shows a failed summary rule run selected in the Azure portal, with the menu option to rerun the bin." lightbox="media/summary-rules/summary-rules-rerun-bin.png":::

# [Azure CLI](#tab/azure-cli-1)

To retry a specific run of a summary rule, find the `BinStartTime` of the bin that failed and provide it as the `retryBinStartTime` value. For example, if you have a summary rule with a `binSize` of 60 minutes and you want to retry the bin that includes data from `2026-02-16T10:00:00Z` to `2026-02-16T11:00:00Z`, set the `retryBinStartTime` value to `2026-02-16T10:00:00Z`.

Use the following command to retry the summary rule bin by using Azure CLI.

```bash
# User input variables - update values in <AngleBrackets>
resourceGroupName="<ResourceGroupName>"
workspaceName="<WorkspaceName>"
ruleName="<RuleName>"
apiVersion="2025-07-01"

# Get the subscription ID from the current Azure CLI context
subscriptionId=$(az account show --query id --output tsv)

# Build request URL
path="/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
provider="Microsoft.OperationalInsights/workspaces/$workspaceName"
url="$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

az rest --method put --url "$url" --body @body.json
```

Save the following JSON as **body.json**, replacing the `retryBinStartTime` value with the `BinStartTime` to retry:

```json
{
  "properties": {
    "retryBinStartTime": "2026-02-16T10:00:00Z"
  }
}
```

# [Azure PowerShell](#tab/powershell-1)

To retry a specific run of a summary rule, find the `BinStartTime` of the bin that failed and provide it as the `retryBinStartTime` value. For example, if you have a summary rule with a `binSize` of 60 minutes and you want to retry the bin that includes data from `2026-02-16T10:00:00Z` to `2026-02-16T11:00:00Z`, set the `retryBinStartTime` value to `2026-02-16T10:00:00Z`.

Use the following command to retry a summary rule bin by using Azure PowerShell.

```powershell
# User input variables - update values in <AngleBrackets>
$resourceGroupName = '<ResourceGroupName>'
$workspaceName = '<WorkspaceName>'
$ruleName = '<RuleName>'
$retryBinStartTime = "2026-02-16T10:00:00Z"
$apiVersion = "2025-07-01"

# Get the subscription ID from the current Azure PowerShell context
$subscriptionId = (Get-AzContext).Subscription.Id

# Build request URL
$path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName"
$provider = "Microsoft.OperationalInsights/workspaces/$workspaceName"
$url = "$path/providers/$provider/summarylogs/$ruleName?api-version=$apiVersion"

$body = @{
    properties = @{
        retryBinStartTime = $retryBinStartTime
    }
} | ConvertTo-Json -Depth 10

Invoke-AzRestMethod -Method PUT -Path $url -Payload $body
```

# [REST API](#tab/rest-1)

To retry a specific run of a summary rule, find the `BinStartTime` of the bin that failed and provide it as the `retryBinStartTime` value. For example, if you have a summary rule with a `binSize` of 60 minutes and you want to retry the bin that includes data from `2026-02-16T10:00:00Z` to `2026-02-16T11:00:00Z`, set the `retryBinStartTime` value to `2026-02-16T10:00:00Z`.

Use the following `PUT` request for the [Logs management API](../fundamentals/azure-monitor-rest-api-index.md#logs-management) **Summary rules** operation group to `retry` a summary rule bin.

```REST
PUT https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.OperationalInsights/workspaces/{workspaceName}/summarylogs/{ruleName}?api-version=2025-07-01
Authorization: Bearer {token}
Content-Type: application/json

{
  "properties": {
    "retryBinStartTime": "2026-02-16T10:00:00Z"
  }
}
```

# [ARM template](#tab/json-1)

To retry a specific run of a summary rule, find the `BinStartTime` of the bin that failed and provide it as the `retryBinStartTime` value. For example, if you have a summary rule with a `binSize` of 60 minutes and you want to retry the bin that includes data from `2026-02-16T10:00:00Z` to `2026-02-16T11:00:00Z`, set the `retryBinStartTime` value to `2026-02-16T10:00:00Z`.

Use this template and parameters to retry a bin:

<details>
<summary>Retry a summary rule bin</summary>

#### Template file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "type": "string"
    },
    "ruleName": {
      "type": "string"
    },
    "retryBinStartTime": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.OperationalInsights/workspaces/summarylogs",
      "apiVersion": "2025-07-01",
      "name": "[format('{0}/{1}', parameters('workspaceName'), parameters('ruleName'))]",
      "properties": {
        "retryBinStartTime": "[parameters('retryBinStartTime')]"
      }
    }
  ]
}
```

#### Parameter file

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "workspaceName": {
      "value": "my-law-workspace"
    },
    "ruleName": {
      "value": "my-summary-rule"
    },
    "retryBinStartTime": {
      "value": "<YYYY-MM-DDTHH:mm:ssZ>"
    }
  }
}
```

</details>

---

## Encrypt summary rule queries by using customer-managed keys

A KQL query can contain sensitive information in comments or in the query syntax. To encrypt summary rule queries, [link a storage account to your Log Analytics workspace and use customer-managed keys](private-storage.md).

Considerations when you work with encrypted queries:

- Linking a storage account to encrypt your queries doesn't interrupt existing rules.
- By default, Azure Monitor stores summary rule queries in Log Analytics storage. If you have existing summary rules before you link a storage account to your Log Analytics workspace, update those rules so the queries are saved in the storage account.
- Queries that you save in a storage account are located in the `CustomerConfigurationStoreTable` table. These queries are considered service artifacts and their format might change.
- The same storage account supports summary rule queries, [saved queries in Log Analytics](save-query.md), and [log alerts](../alerts/alerts-types.md#log-alerts).

## Troubleshoot summary rules

This section provides tips for troubleshooting summary rules.

### Summary rule destination table accidentally deleted

If you delete the destination table while the summary rule is active, the rule gets suspended and Azure Monitor sends an event to the `LASummaryLogs` table with a message indicating that the rule was suspended. 

If you don't need the summary results in the destination table, delete the rule and table. If you need the summary results, follow the steps in the [Create or update summary rules](#create-or-update-a-summary-rule) section to recreate the destination table and restore all data, including the data ingested before the delete, depending on the retention policy in the table.

### Query uses operators that create new columns in the destination table

The destination table schema is defined when you create or update a summary rule. If the query includes operators that allow output schema expansion based on incoming data (for example, the `arg_max(expression, *)` function), Azure Monitor doesn't add new columns to the destination table after you create or update the rule, and the output data that requires these columns is dropped. To add the new fields to the destination table, [update the summary rule](#create-or-update-a-summary-rule) or [add a column to your table manually](create-custom-table.md#add-or-delete-a-custom-column).

### Data in removed columns remains in the workspace based on the table's retention settings

When you remove a field from the query, the columns and data remain in the destination table based on the [retention period](data-retention-configure.md) defined on the table or workspace. If you don't need the removed columns in the destination table, [delete the columns from the table schema](create-custom-table.md#add-or-delete-a-custom-column). If you then add columns with the same name, any data that's not older than the retention period appears again.

## Related content

- [Azure Monitor Logs data plans](logs-table-plans.md)
- [Log Analytics tutorial](log-analytics-tutorial.md)
- [KQL reference documentation](/azure/kusto/query/)

