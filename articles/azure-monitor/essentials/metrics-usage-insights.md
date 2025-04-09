---
title: Azure Monitor metrics usage insights (Preview)
description: What is Azure Monitor metrics usage insights, and how to set it up.
ms.topic: conceptual
ms.date: 03/18/2025
---

# Azure Monitor metrics usage insights (Preview)

Azure Monitor metrics usage insights gives you actionable insights into metrics usage and cost optimization opportunities. Metrics usage insights monitors your Azure monitor workspace providing information on time series and event usage, throttling limits, metrics usage trends, and unused metrics. By providing an insight into metrics usage, it helps identify opportunities for optimization, such as removing unused metrics and right-sizing resources by analyzing usage patterns.

Azure Monitor metrics usage insights sends usage data to a Log analytics workspace for analysis. There's no extra cost for using metrics usage insights, and no charge for the data sent to the Log Analytics workspace, the queries, or the storage.

## Supported regions

During the Preview, Azure Monitor metrics usage insights is available in the following regions:
+ East US
+ TBD


## Enabling Azure Monitor metrics usage insights

To enable metrics usage insights, you create a diagnostic setting to send  on the AMW to send insights data to Log Analytics Workspace (LAW).

Customers will be guided to enable metrics usage insights as part of the standard out of the box experience during new AMW resource creation where diagnostic settings will be created behind the scenes. For existing AMWs this will have to be configured using diagnostic settings as explained in the further sections.


### Enable Azure Monitor metrics usage insights at creation time

### [Portal](#tab/portal)

When you create a new Azure Monitor workspace, select **Enable insights** on the **Monitoring** tab of the **Create Azure Monitor workspace** page and specify a Log Analytics workspace. This will cause the diagnostic setting to be created when the Azure Monitor workspace is created.

:::image type="content" source="./media/metrics-usage-insights/enable-insights.png" lightbox="./media/metrics-usage-insights/enable-insights.png"  alt-text="A screenshot showing the monitoring tab of the Create Azure Monitor workspace page.":::


### [ARM template](#tab/arm)

Use the following template and parameter file to create a new Azure Monitor workspace with metrics usage insights enabled.

### Template file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "am_workspace_name": {
            "defaultValue": "MyAMWorkspace",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "microsoft.monitor/accounts",
            "apiVersion": "2023-04-03",
            "name": "[parameters('am_workspace_name')]",
            "location": "<location>",
            "properties": {}
        },
        {
            "apiVersion": "2021-05-01-preview",
            "type": "Microsoft.Insights/diagnosticSettings",
            "scope": "[format('microsoft.monitor/accounts/{0}', 
parameters('am_workspace_name'))]",
            "name": "MyDiagnosticSetting",
            "properties": {
                "workspaceId": "/subscriptions/<subscriPtion ID>/resourcegroups/<resource group name>/providers/microsoft.operationalinsights/workspaces/<workspace name>",
                "metrics": [
                    {
                        "category": "AllMetrics",
                        "enabled": false,
                        "retentionPolicy": {
                            "enabled": false,
                            "days": 0
                        }
                    }
                ],
                "logs": [
                    {
                        "category": "MetricsUsageDetails",
                        "categoryGroup": null,
                        "enabled": true,
                        "retentionPolicy": {
                            "enabled": false,
                            "days": 0
                        }
                    }
                ],
                "logAnalyticsDestinationType": null
            },
            "dependsOn": [
                "[resourceId('microsoft.monitor/accounts', 
parameters('am_workspace_name'))]"
            ]
        }
    ]
}

#### Parameter file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#","contentVersion": "1.0.0.0",
    "parameters": {
        "am_workspace_name": {
            "value": "<Azure Monitor workspace name>"
        }
    }
}
```

---



### Enable Azure Monitor metrics usage insights for an existing workspace

### [Portal](#tab/portal)

To enable metrics usage insights for an existing Azure Monitor workspace, you need to create a diagnostic setting.

1. In the Azure portal, navigate to the Azure Monitor workspace.
1. In the **Monitoring** section of the menu, select **Diagnostic settings**.
1. Select **Add diagnostic setting**.

    :::image type="content" source="./media/metrics-usage-insights/diagnostic-settings.png" lightbox="./media/metrics-usage-insights/diagnostic-settings.png" alt-text="A Screenshot showing the Diagnostic settings page.":::

1. On the diagnostic setting page, enter a **Diagnostic setting name**
1. Select **allLogs**
1. Under **Destination details**, select **Send to Log Analytics workspace**.
1. Select a **Subscription** and a **Log Analytics workspace**.
1. Select ** Save**.

    :::image type="content" source="./media/metrics-usage-insights/configure-diagnostic-settings.png" lightbox="./media/metrics-usage-insights/configure-diagnostic-settings.png" alt-text="A screenshot showing the add diagnostic setting page.":::

### [ARM template](#tab/arm)

Use the following template and parameter file to enable metrics usage insights for an existing Azure Monitor workspace.

Template File:

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "am_workspace_name": {
            "defaultValue": "MyAMWorkspace",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "apiVersion": "2021-05-01-preview",
            "type": "Microsoft.Insights/diagnosticSettings",
            "scope": "[format('microsoft.monitor/accounts/{0}', 
parameters('am_workspace_name'))]",
            "name": "MyDiagnosticSetting",
            "properties": {
                "workspaceId": "/subscriptions/<subscription ID>/resourcegroups/<resourcegroup name>/providers/microsoft.operationalinsights/workspaces/<workspace name>",
                "metrics": [
                    {
                        "category": "AllMetrics",
                        "enabled": false,
                        "retentionPolicy": {
                            "enabled": false,
                            "days": 0
                        }
                    }
                ],
                "logs": [
                    {
                        "category": "MetricsUsageDetails",
                        "categoryGroup": null,
                        "enabled": true,
                        "retentionPolicy": {
                            "enabled": false,
                            "days": 0
                        }
                    }
                ],
                "logAnalyticsDestinationType": null
            }
        }
    ]
}

```

Parameter File:

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "am_workspace_name": {
            "value": "<Azure Monitor workspace name>"
        }
    }
}
```
---

## Azure Monitor metrics usage insights pages

The Azure Monitor metrics usage insights pages show data for time series and events.

+ **Time Series**  
A time series is a set of data points or metric values for a given time.

+ **Active Time Series**  
 An active time series is a time series that was ingested into the workspace in the last 12 hours.

+ **Events**  
An event is a discrete metric value for a given time and set of dimensions.

### View Azure Monitor metrics usage insights

View the Azure Monitor metrics usage insights either directly form the Azure Monitor workspace resource page, or from in the Azure Monitor portal page.

1. To view the Azure Monitor workspace metrics from the Azure Monitor workspace resource page, navigate to the Azure Monitor workspace resource page. Under **Monitoring** select **Insights (preview)**.

    :::image type="content" source="./media/metrics-usage-insights/workspace-overview.png" lightbox="./media/metrics-usage-insights/workspace-overview.png" alt-text="A screenshot showing the Azure Monitor workspace overview page.":::


1. To view the Azure Monitor metrics usage insights from the Azure Monitor workspace resource page, navigate to the Azure monitor overview page and select **View all insights**

    :::image type="content" source="./media/metrics-usage-insights/azure-monitor-overview.png" lightbox="./media/metrics-usage-insights/azure-monitor-overview.png" alt-text="A screenshot showing the Azure Monitor overview page.":::

1. Scroll down ans select **Azure Monitor workspaces**
    :::image type="content" source="./media/metrics-usage-insights/azure-monitor-insights.png" lightbox="./media/metrics-usage-insights/azure-monitor-overview.png" alt-text="A screenshot showing the Azure Monitor Insights page.":::

    The workbooks page shows a summary table of your Azure Monitor workspaces.
    The table includes the following columns:

    | Column                           | Description                                                                                           |
    |----------------------------------|-------------------------------------------------------------------------------------------------------|
    | Time series limit                | The maximum number of time series you can ingest per minute.                                          |
    | Active time series               | The number of time series ingested per minute. |
    | Active time series timeline      | A chart showing the active time series over time.                                                     |
    | Time series utilization (%)      | The active time series as a percentage of the limit.                                                  |
    | Event limit                      | The maximum number of events you can ingest per minute. |
    | Events per minute ingested       | The number of individual metric values ingested per minute.                                           |
    | Events per minute ingested timeline   | A chart showing the number of metric samples events ingested per minute over time.                    |
    | Events per minute utilization (%)| The number of metric samples events ingested per minute as a percentage of the limit.                 |

 1. Select a workspace to view more details.

    :::image type="content" source="./media/metrics-usage-insights/insights-workbook.png" lightbox="./media/metrics-usage-insights/insights-workbook.png" alt-text="A screenshot showing the workbooks page.":::

### Limits and usage page

The limits and usage page gives you an overview of your Azure monitor workspace's current usage and throttling limits The page shows your time series and event ingestion against their limits and the percentage of the limit used. 

:::image type="content" source="./media/metrics-usage-insights/limits-and-usage.png" lightbox="./media/metrics-usage-insights/insights-workbook.png" alt-text="A screenshot showing the limits and usage page.":::

## Account exploration page

The Account exploration page allows you to delve deeper into your workspace data and gain valuable 
insights. Examine individual metrics to evaluate their financial implications, 
observing their quantity, ingestion volume, and their role in the total cost of ingestion and storage.


:::image type="content" source="./media/metrics-usage-insights/account-exploration.png" lightbox="./media/metrics-usage-insights/account-exploration.png" alt-text="A screenshot showing the account exploration page.":::

The dashboard has three views:

### Exploratory Table view

The Exploratory table provides a high-level overview of the metrics ingested into the workspace. The 
exploratory table has the following columns:
 
| Column Name | Description|
|------------|------------|
| Namespace |Namespace in the Azure Monitor the metric belongs to.|
| Metric | The name of the metric that the insights are generated for|
| Dimensions | The set of labels/dimensions being described. `*` indicates All Dimensions are included |
| Daily Time series | The daily time series count associated with the labels/dimensions for the metric |
| Incoming Events | The number of events received for the metric as of the "Insights as of" date on the report, sorted in descending order. Note: Events showing zero indicate the incoming events are very low. |
| Last Queried (days ago) | The number of days from "Insights as of" date on the report when the a query was last run on the metric.
| Number of Queries | The number of queries run on the metric as of the "Insights as of" date on the report.

The table can be sorted by any of the columns by selecting the column header.


### Top 10 metrics by recent growth view

The bar chart gives an insight into the disproportionate growth of a metric or metrics relative to other metrics. 
If you receive throttling alerts, or want to check the growth of your workspace, use this chart to see which metrics are growing the more than others, then check sampling and scraping frequencies. Unexpected negative growth may indicate a problem in the collection pipeline.


### Daily time series trend by baseline period view

The daily time series trend line for each metric can be used to identify sudden spikes or dips over a baseline period. A 28-day time range is used to establish a baseline for the number of daily time series for a metric, and is compared to the average over 7 days


## Unused metrics

The unused page shows the metrics that haven't been used in a query for the specified duration. Select duration of 30, 60, and 90 days from the **Not Used In days** filter. The longer a metric remains unused, the more confident you can be that it will continue to be unused. Unused metrics don't provide value, and can be removed from the ingest processes to reduce ingestion and storage costs.
Multiplying the ingested samples count that are unused by the meter rate gives an indicative cost of potential saving after deleting the unused metrics.

:::image type="content" source="./media/metrics-usage-insights/unused-metrics.png" lightbox="./media/metrics-usage-insights/unused-metrics.png" alt-text="A screenshot showing the unused metrics page.":::


## Advanced Analytics

If you want to personalize the insights pages, you can modify the underlying queries behind the pages in a workbook.  

Select **Workbooks** from the navigation pane, then select the **Usage Insights** workbook. When your changes are complete, save the customized workbook for reuse.

For more information on workbooks, see [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview).

:::image type="content" source="./media/metrics-usage-insights/workbooks.png" lightbox="./media/metrics-usage-insights/workbooks.png" alt-text="A screenshot showing the workbooks gallery page.":::


