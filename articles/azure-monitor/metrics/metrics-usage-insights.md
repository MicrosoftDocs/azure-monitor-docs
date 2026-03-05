---
title: Metrics usage insights in Azure Monitor (Preview)
description: Describes the 
ms.topic: how-to
ms.date: 04/11/2025
---

# Metrics usage insights (Preview)

Metrics usage insights gives you actionable insights into metrics usage and cost optimization opportunities for your Azure monitor workspace. By providing information on time series and event usage, throttling limits, metrics usage trends, and unused metrics, you can take such actions as removing unused metrics and right-sizing resources. 

Metrics usage insights sends usage data to a Log analytics workspace for analysis. There's no extra cost and no charge for the data sent to the Log Analytics workspace, the queries, or the storage.

> [!TIP]
> Send data for multiple Azure Monitor workspaces to a single Log Analytics workspace. This simplifies your environment and allows you to analyze metrics usage across multiple workspaces and get a consolidated view of your Azure Monitor workspace usage. See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for guidance on when to create multiple workspaces.

## Supported regions

During public preview, metrics usage insights is available only in the following regions:

| Geo           | Regions                                                                 |
| ------------- | ----------------------------------------------------------------------- |
| Africa        | South Africa North                                                      |
| Asia Pacific  | East Asia, Southeast Asia                                               |
| Australia     | Australia East, Australia Southeast                                     |
| Brazil        | Brazil South                                                            |
| Canada        | Canada Central, Canada East                                             |
| Europe        | North Europe, West Europe                                               |
| France        | France Central, France South                                            |
| Germany       | Germany West Central                                                    |
| India         | Central India, South India                                              |
| Israel        | Israel Central                                                          |
| Italy         | Italy North                                                             |
| Japan         | Japan East, Japan West                                                  |
| Korea         | Korea Central                                                           |
| Norway        | Norway East                                                             |
| Spain         | Spain Central                                                           |
| Sweden        | Sweden South, Sweden Central                                            |
| Switzerland   | Switzerland North                                                       |
| UAE           | UAE North                                                               |
| UK            | UK South, UK West                                                       |
| US            | Central US, East US, East US 2, South Central US, West Central US, West US, West US 2, West US 3 |



## Enable metrics usage insights

To enable metrics usage insights, you create a [diagnostic setting](../essentials/diagnostic-settings.md), which instructs the AMW to send data supporting the insights queries and workbooks to a [Log Analytics Workspace (LAW)](../logs/log-analytics-workspace-overview.md). You'll be prompted to enable it automatically when you create a new Azure Monitor workspace. You can enable it later for an existing Azure Monitor workspace.

### Enable at creation time

### [Portal](#tab/portal)

When you create a new Azure Monitor workspace, select **Enable insights** on the **Monitoring** tab of the **Create Azure Monitor workspace** page and specify a Log Analytics workspace. The required diagnostic setting will be created along with the Azure Monitor workspace.

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
            "scope": "[format('microsoft.monitor/accounts/{0}', parameters('am_workspace_name'))]",
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
                "[resourceId('microsoft.monitor/accounts', parameters('am_workspace_name'))]"
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



### Enable for an existing workspace

### [Portal](#tab/portal)

In the **Monitoring** section of the menu for your Azure Monitor workspace, select **Diagnostic settings** and then **Add diagnostic setting**.

:::image type="content" source="./media/metrics-usage-insights/diagnostic-settings.png" lightbox="./media/metrics-usage-insights/diagnostic-settings.png" alt-text="A Screenshot showing the Diagnostic settings page.":::

Perform the following configurations on the diagnostic setting page and select **Save**:

1. Provide a descriptive name for the **Diagnostic setting name**
2. Select **Send to Log Analytics workspace** and select a workspace to receive the data.
3. Select **Metrics Usage Details** to send the metrics usage logs for the Azure Monitor workspace to the Log Analytics workspace.

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
            "scope": "[format('microsoft.monitor/accounts/{0}', parameters('am_workspace_name'))]",
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

> [!NOTE]
>
> You will need to wait approximately 24 hours to allow data to flow into LAW.
>Once you have created the Diagnostic Settings and waited for 24 hours, verify that the "Active Time Series (Max)" value is not zero. A value of zero indicates that no data is being ingested into AMW, resulting in no available insights.

## Open metrics usage insights
You can open metrics usage insights either for a single Azure Monitor workspace or for all Azure Monitor workspaces in your subscription.

For a single Azure Monitor workspace, select **Insights (preview)** under **Monitoring** or **Metrics usage insights** from the **Overview page**.

:::image type="content" source="./media/metrics-usage-insights/workspace-overview.png" lightbox="./media/metrics-usage-insights/workspace-overview.png" alt-text="A screenshot showing the Azure Monitor workspace overview page.":::

To view a summary of all Azure Monitor workspaces in your subscription, select **Insights Hub** from the **Monitor** menu and then select **Azure Monitor workspaces**. Click on a workspace to view more details.

:::image type="content" source="./media/metrics-usage-insights/azure-monitor-insights.png" lightbox="./media/metrics-usage-insights/azure-monitor-insights.png" alt-text="A screenshot showing the Azure Monitor Insights page.":::

The summary table of your Azure Monitor workspaces includes a table with the following columns:

| Column | Description |
|:---|:---|
| Time series limit | The maximum number of time series you can ingest per minute. |
| Active time series | The number of time series ingested per minute. |
| Active time series timeline | A chart showing the active time series over time. |
| Time series utilization (%) | The active time series as a percentage of the limit. |
| Event limit | The maximum number of events you can ingest per minute. |
| Events per minute ingested | The number of individual metric values ingested per minute. |
| Events per minute ingested timeline | A chart showing the number of metric samples events ingested per minute over time. |
| Events per minute utilization (%)| The number of metric samples events ingested per minute as a percentage of the limit. |


## Dashboards
Metrics usage insights includes the dashboards described in the following sections.

### Limits & usage

**Limits & Usage** includes an overview of your Azure monitor workspace's current usage and throttling limits. This page shows the time series and event ingestion against their limits and the percentage of the limit used. 

:::image type="content" source="./media/metrics-usage-insights/limits-and-usage.png" lightbox="./media/metrics-usage-insights/insights-workbook.png" alt-text="A screenshot showing the limits and usage page.":::

### Workspace Exploration

**Workspace Exploration** allows you to delve deeper into your workspace data and gain valuable insights. Examine individual metrics to evaluate their financial implications. Analyze their quantity, ingestion volume, and their role in the total cost of ingestion and storage. The data in this dashboard is calculated once per day for each metric. The data is current as of the previous day.

> [!TIP]
> Click on the icon above each view to open Log Analytics with the query supporting that view. This allows you to view the data in more detail.

:::image type="content" source="./media/metrics-usage-insights/workspace-exploration.png" lightbox="./media/metrics-usage-insights/workspace-exploration.png" alt-text="A screenshot showing the workspace exploration page.":::

**Metric summary table**
The table on this page provides a high-level overview of the metrics ingested into the workspace. It has the following columns:
 
| Column Name | Description|
|:---|:---|
| Namespace |Namespace in the Azure Monitor the metric belongs to.|
| Metric | The name of the metric that the insights are generated for|
| Dimensions | The set of labels/dimensions being described. `*` indicates All Dimensions are included |
| Daily Time series | The daily time series count associated with the labels/dimensions for the metric |
| Incoming Events | The number of events received for the metric as of the "Insights as of" date on the report, sorted in descending order. Note: Events showing zero indicate the incoming events are very low. |
| Last Queried (days ago) | The number of days from "Insights as of" date on the report when the a query was last run on the metric.
| Number of Queries | The number of queries run on the metric as of the "Insights as of" date on the report.


**Top 10 metrics by recent growth view**<br>
The bar chart gives insight into the disproportionate growth of a metric relative to other metrics. If you receive throttling alerts or want to check the growth of your workspace, use this chart to see which metrics are growing disproportionate to others and then check sampling and scraping frequencies. Unexpected negative growth may indicate a problem in the collection pipeline.


**Daily time series trend by baseline period view**<br>
The daily time series trend line for each metric can be used to identify sudden spikes or dips over a baseline period. A 28-day time range is used to establish a baseline for the number of daily time series for a metric and is compared to the average over 7 days.


### Unused Metrics

**Unused Metrics** shows the metrics that haven't been used in a query for the duration specified in **Not Used In days**. The longer a metric remains unused, the more confident you can be that it can be removed from the ingest processes to reduce ingestion and storage costs. Multiplying the ingested samples count that are unused by the meter rate gives an indication of potential saving after deleting the unused metrics. Adjust the scrape job settings in your Prometheus settings to stop collecting unused data. For details on metrics relabeling, see [Configure custom Prometheus scrape jobs](../containers/prometheus-metrics-scrape-configuration.md).

:::image type="content" source="./media/metrics-usage-insights/unused-metrics.png" lightbox="./media/metrics-usage-insights/unused-metrics.png" alt-text="A screenshot showing the unused metrics page.":::


## Advanced Analytics

If you want to personalize the insights pages, you can modify the underlying queries behind the pages in a workbook. Select **Workbooks** from the navigation pane, then select the **Usage Insights** workbook. When your changes are complete, save the customized workbook for reuse. For details on workbooks and guidance, see [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview).

:::image type="content" source="./media/metrics-usage-insights/workbooks.png" lightbox="./media/metrics-usage-insights/workbooks.png" alt-text="A screenshot showing the workbooks gallery page.":::

You can query historical data beyond the data range of the insights pages by accessing the Log Analytics workspace directly. The data is stored in the `AMWMetricsUsageDetails` table. See [Overview of Log Analytics in Azure Monitor](../logs/log-analytics-overview.md) if you aren't familiar with Log Analytics and [Log queries in Azure Monitor](../logs/log-query-overview.md) for guidance on writing queries.


:::image type="content" source="./media/metrics-usage-insights/log-query.png" lightbox="./media/metrics-usage-insights/log-query.png" alt-text="A screenshot showing Azure Monitor workspace historical data.":::

