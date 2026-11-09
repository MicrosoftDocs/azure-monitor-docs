---
title: Metrics usage insights in Azure Monitor (Preview)
description: Describes the metrics usage insights feature in Azure Monitor, which provides analysis of time‑series and event usage, throttling limits, trends, and cost‑optimization opportunities by sending usage data to a Log Analytics workspace.
ms.topic: how-to
ms.custom: references_regions
ms.date: 04/11/2025
---

# Metrics usage insights

Metrics usage insights gives you actionable insights into metrics usage and cost optimization opportunities for your Azure Monitor workspace. By providing information on time series and event usage, throttling limits, metrics usage trends, and unused metrics, you can take such actions as removing unused metrics and right-sizing resources.

Metrics usage insights sends usage data to a Log Analytics workspace for analysis. There's no additional charge for the data sent to the Log Analytics workspace, the queries, or the storage.

> [!TIP]
> Send data for multiple Azure Monitor workspaces to a single Log Analytics workspace. This simplifies your environment and allows you to analyze metrics usage across multiple workspaces and get a consolidated view of your Azure Monitor workspace usage. See [Design a Log Analytics workspace architecture](../logs/workspace-design.md) for guidance on when to create multiple workspaces.

## Supported regions

Metrics usage insights is available in all public regions where Azure Monitor workspace is GA. For the current list, see [Regional availability of Azure Monitor workspace](azure-monitor-workspace-overview.md#regional-availability).

## Enable metrics usage insights

To enable metrics usage insights, you create a [diagnostic setting](../essentials/diagnostic-settings.md), which instructs the Azure Monitor workspace to send data supporting the insights queries and workbooks to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md). You'll be prompted to enable it automatically when you create a new Azure Monitor workspace. You can enable it later for an existing Azure Monitor workspace.

### Enable at creation time

### [Portal](#tab/portal)

When you create a new Azure Monitor workspace, select **Enable insights** on the **Monitoring** tab of the **Create Azure Monitor workspace** page and specify a Log Analytics workspace. The required diagnostic setting will be created along with the Azure Monitor workspace.

:::image type="content" source="./media/metrics-usage-insights/enable-insights.png" lightbox="./media/metrics-usage-insights/enable-insights.png"  alt-text="A screenshot showing the monitoring tab of the Create Azure Monitor workspace page.":::

### [ARM (JSON)](#tab/arm)

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
                "workspaceId": "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<workspace-name>",
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
```

#### Parameters file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#","contentVersion": "1.0.0.0",
    "parameters": {
        "am_workspace_name": {
            "value": "<azure-monitor-workspace-name>"
        }
    }
}
```

### [Bicep](#tab/bicep)

Use the following template and parameter file to create a new Azure Monitor workspace with metrics usage insights enabled.

### Template file

```bicep
param am_workspace_name string = 'MyAMWorkspace'

resource am_workspace_name_resource 'microsoft.monitor/accounts@2025-10-03-preview' = {
    name: am_workspace_name
    location: '<location>'
    properties: {}
}

resource MyDiagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
    scope: am_workspace_name_resource
    name: 'MyDiagnosticSetting'
    properties: {
        workspaceId: '/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<workspace-name>'
        metrics: [
            {
                category: 'AllMetrics'
                enabled: false
                retentionPolicy: {
                    enabled: false
                    days: 0
                }
            }
        ]
        logs: [
            {
                category: 'MetricsUsageDetails'
                categoryGroup: null
                enabled: true
                retentionPolicy: {
                    enabled: false
                    days: 0
                }
            }
        ]
        logAnalyticsDestinationType: null
    }
}
```

#### Parameters file

```bicep
using './<template-file-name>.bicep'

param am_workspace_name = '<azure-monitor-workspace-name>'
```

---

### Enable for an existing workspace

### [Portal](#tab/portal)

In the **Monitoring** section of the menu for your Azure Monitor workspace, select **Diagnostic settings** and then **Add diagnostic setting**.

:::image type="content" source="./media/metrics-usage-insights/diagnostic-settings.png" lightbox="./media/metrics-usage-insights/diagnostic-settings.png" alt-text="A Screenshot showing the Diagnostic settings page.":::

Perform the following configurations on the diagnostic setting page and select **Save**:

1. Provide a descriptive name for the **Diagnostic setting name**.
2. Select **Send to Log Analytics workspace** and select a workspace to receive the data.
3. Select **Metrics Usage Details** to send the metrics usage logs for the Azure Monitor workspace to the Log Analytics workspace.

    :::image type="content" source="./media/metrics-usage-insights/configure-diagnostic-settings.png" lightbox="./media/metrics-usage-insights/configure-diagnostic-settings.png" alt-text="A screenshot showing the add diagnostic setting page.":::

### [ARM (JSON)](#tab/arm)

Use the following template and parameter file to enable metrics usage insights for an existing Azure Monitor workspace.

#### Template file

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
            "apiVersion": "2021-05-01-preview",
            "type": "Microsoft.Insights/diagnosticSettings",
            "scope": "[format('microsoft.monitor/accounts/{0}', parameters('am_workspace_name'))]",
            "name": "MyDiagnosticSetting",
            "properties": {
                "workspaceId": "/subscriptions/<subscription-id>/resourcegroups/<resource-group-name>/providers/microsoft.operationalinsights/workspaces/<workspace-name>",
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

#### Parameters file

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "am_workspace_name": {
            "value": "<azure-monitor-workspace-name>"
        }
    }
}
```

### [Bicep](#tab/bicep)

Use the following template and parameter file to enable metrics usage insights for an existing Azure Monitor workspace.

#### Template file

```bicep
@description('Azure Monitor account name')
param am_workspace_name string = 'MyAMWorkspace'

resource amAccount 'Microsoft.Monitor/accounts@2023-04-03' existing = {
    name: am_workspace_name
}

resource myDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
    name: 'MyDiagnosticSetting'
    scope: amAccount
    properties: {
        workspaceId: '/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.OperationalInsights/workspaces/<workspace-name>'
        metrics: [
            {
                category: 'AllMetrics'
                enabled: false
                retentionPolicy: {
                    enabled: false
                    days: 0
                }
            }
        ]
        logs: [
            {
                category: 'MetricsUsageDetails'
                categoryGroup: null
                enabled: true
                retentionPolicy: {
                  enabled: false
                  days: 0
                }
            }
        ]
        logAnalyticsDestinationType: null
    }
}
```

#### Parameters file

```bicep
using './<template-file-name>.bicep'

param am_workspace_name = '<azure-monitor-workspace-name>'
```

---

> [!NOTE]
> You need to wait approximately 24 hours to allow data to flow into the Log Analytics workspace. Once you have created the diagnostic setting and waited for 24 hours, verify that the "Active Time Series (Max)" value is not zero. A value of zero indicates that no data is being ingested into the Azure Monitor workspace, resulting in no available insights.

## Open metrics usage insights

You can open metrics usage insights either for a single Azure Monitor workspace or for all Azure Monitor workspaces in your subscription.

For a single Azure Monitor workspace, select **Insights** under **Monitoring** or **Metrics usage insights** from the **Overview** page.

:::image type="content" source="./media/metrics-usage-insights/workspace-overview.png" lightbox="./media/metrics-usage-insights/workspace-overview.png" alt-text="A screenshot showing the Azure Monitor workspace overview page.":::

To view a summary of all Azure Monitor workspaces in your subscription, select **Insights Hub** from the **Monitor** menu and then select **Azure Monitor workspaces**. Click on a workspace to view more details.

:::image type="content" source="./media/metrics-usage-insights/azure-monitor-insights.png" lightbox="./media/metrics-usage-insights/azure-monitor-insights.png" alt-text="A screenshot showing the Azure Monitor Insights page.":::

:::image type="content" source="./media/metrics-usage-insights/insights-workbook.png" lightbox="./media/metrics-usage-insights/insights-workbook.png" alt-text="A screenshot showing the summary of Azure Monitor workspaces.":::

The summary table of your Azure Monitor workspaces includes the following columns:

| Column                              | Description                                                                           |
|:------------------------------------|:--------------------------------------------------------------------------------------|
| Time series limit                   | The maximum number of active time series supported before ingestion is throttled.      |
| Active time series                  | The number of time series ingested per minute.                                        |
| Active time series timeline         | A chart showing the active time series over time.                                     |
| Time series utilization (%)         | The percentage of the active time series limit currently in use.                       |
| Event limit                         | The maximum event ingestion rate, in events per minute, supported before ingestion is throttled. |
| Events per minute ingested          | The number of individual metric values ingested per minute.                           |
| Events per minute ingested timeline | A chart showing the number of metric events ingested per minute over time.            |
| Events per minute utilization (%)   | The percentage of the events-per-minute ingestion limit currently in use.             |

## Dashboards

Metrics usage insights includes the dashboards described in the following sections.

### Limits & usage

**Limits & Usage** includes an overview of your Azure Monitor workspace's current usage and throttling limits. This page shows the time series and event ingestion against their limits and the percentage of the limit used.

:::image type="content" source="./media/metrics-usage-insights/limits-and-usage.png" lightbox="./media/metrics-usage-insights/limits-and-usage.png" alt-text="A screenshot showing the limits and usage page.":::

### Workspace exploration

**Workspace Exploration** allows you to delve deeper into your workspace data and gain valuable insights. Examine individual metrics to evaluate their financial implications. Analyze their quantity, ingestion volume, and their role in the total cost of ingestion and storage. The data in this dashboard is calculated once per day for each metric. The data is current as of the previous day.

> [!TIP]
> Click on the icon above each view to open Log Analytics with the query supporting that view. This allows you to view the data in more detail.

:::image type="content" source="./media/metrics-usage-insights/workspace-exploration.png" lightbox="./media/metrics-usage-insights/workspace-exploration.png" alt-text="A screenshot showing the workspace exploration page.":::

**Metric summary table**

The table on this page provides a high-level overview of the metrics ingested into the workspace. It has the following columns:
 
| Column Name | Description |
|:------------|:------------|
| Namespace | The metric namespace in the Azure Monitor workspace. |
| Metric | The name of the metric described by this insight. |
| Dimensions | The set of labels or dimensions being described. `*` indicates that all dimensions are included. |
| Daily Timeseries | The daily timeseries count associated with the metric’s labels or dimensions. |
| Event Rate (/min) | The average number of metric events received per minute on the “Insights as of” date. |
| Daily Events | The total number of metric events received on the “Insights as of” date. |
| Days Since Last Query | The number of days between the metric’s most recent query and the “Insights as of” date. |
| Daily Query Count | The number of queries run against the metric on the “Insights as of” date. |

**Top 10 metrics by timeseries growth (7-day vs. 28-day average)**

The bar chart compares each metric’s average daily timeseries count over the last seven days with its average over the last 28 days. The seven-day period is included in the 28-day period. Use this chart to identify metrics with the largest recent increases in daily timeseries and, if you receive throttling alerts, check their sampling and scraping frequencies.

**Top 10 metrics: Daily timeseries trend**

The daily timeseries trend line shows the daily counts for the 10 metrics with the highest total timeseries counts over the selected time range. Use this chart to identify changes in these metrics over time.

### Unused metrics

**Unused Metrics** shows the metrics that you didn't use in a query during the time you specify in **Days Since Last Query**. If a metric remains unused for a long time, you can remove it from the ingest processes to reduce ingestion and storage costs. Multiply the count of unused ingested samples by the meter rate to see potential savings after deleting the unused metrics. Adjust your Prometheus scrape-job settings to stop collecting unused data. For details on metrics relabeling, see [Configure custom Prometheus scrape jobs](../containers/prometheus-metrics-scrape-configuration.md).

:::image type="content" source="./media/metrics-usage-insights/unused-metrics.png" lightbox="./media/metrics-usage-insights/unused-metrics.png" alt-text="A screenshot showing the unused metrics page.":::

### Ingestion volume change

The **Ingestion Volume Change** dashboard helps you compare metrics ingestion volume between two points in time so you can identify significant changes in your workspace. Use this dashboard to detect unexpected spikes or drops in time series counts and event ingestion rates. It helps you investigate cost changes and plan capacity. You can filter the results by namespace and metric.

Select a comparison time range by using the **Comparison dates** dropdown to define the start and end dates for comparison. The dashboard uses the earliest and latest available data within the selected period, which might differ from the dates you selected. Use the **Summary** view to review starting values and changes, or select **Detailed** view to include ending values and daily event counts.


> [!TIP] 
> Use wider time ranges (such as 60 or 90 days) to identify long-term trends in ingestion volume. Use shorter ranges to investigate recent changes. 

:::image type="content" source="./media/metrics-usage-insights/ingestion-volume-change.png" lightbox="./media/metrics-usage-insights/ingestion-volume-change.png" alt-text="A screenshot showing the ingestion volume change page with summary view.":::

:::image type="content" source="./media/metrics-usage-insights/ingestion-volume-detailed.png" lightbox="./media/metrics-usage-insights/ingestion-volume-detailed.png" alt-text="A screenshot showing the ingestion volume change page with detailed view.":::

**Metric comparison table**

The table on this page compares time series, event rate, and daily event data between the start and end dates of the selected time period. It has the following columns:

| Column Name | Description |
|---|---|
| Namespace | The metric namespace in the Azure Monitor workspace. |
| Metric | The name of the metric described by this insight. |
| Dimensions | The set of labels or dimensions being described. `*` indicates that all dimensions are included. |
| Start Timeseries | The number of active metric time series on the start date of the selected comparison period. |
| End Timeseries | The number of active metric time series on the end date of the selected comparison period. |
| Timeseries Difference | The end time series count minus the start time series count. Positive values indicate an increase; negative values indicate a decrease. |
| Timeseries Change (%) | The magnitude of the percentage change in active metric time series from the start date to the end date. Use **Timeseries Difference** to determine direction. Shows 100% when the start value is zero and the end value is nonzero; blank when both values are zero. |
| Start Event Rate (/min) | The average number of metric events received per minute on the start date. Values are rounded to the nearest whole number. |
| End Event Rate (/min) | The average number of metric events received per minute on the end date. Values are rounded to the nearest whole number. |
| Event Rate Difference | The end event rate minus the start event rate. Positive values indicate an increase; negative values indicate a decrease. |
| Event Rate Change (%) | The magnitude of the percentage change in the per-minute event rate from the start date to the end date. Use **Event Rate Difference** to determine direction. Shows 100% when the start value is zero and the end value is nonzero; blank when both values are zero. |
| Start Daily Events | The total number of metric events received on the start date. |
| End Daily Events | The total number of metric events received on the end date. |
| Daily Events Difference | The end daily event count minus the start daily event count. Positive values indicate an increase; negative values indicate a decrease. |

> [!NOTE]
> If the start value for a metric is zero (the metric didn't exist on the start date), the percentage change columns display 100%, indicating that the metric is entirely new. If both start and end values are zero, the percentage change is blank.

## Advanced analytics

If you want to personalize the insights pages, you can modify the underlying queries behind the pages in a workbook. Select **Workbooks** from the navigation pane, then select the **Metrics Usage Insights** workbook. When your changes are complete, save the customized workbook for reuse. For details on workbooks and guidance, see [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview).

:::image type="content" source="./media/metrics-usage-insights/workbooks.png" lightbox="./media/metrics-usage-insights/workbooks.png" alt-text="A screenshot showing the workbooks gallery page.":::

You can query historical data beyond the data range of the insights pages by accessing the Log Analytics workspace directly. The data is stored in the `AMWMetricsUsageDetails` table. See [Overview of Log Analytics in Azure Monitor](../logs/log-analytics-overview.md) if you aren't familiar with Log Analytics and [Log queries in Azure Monitor](../logs/log-query-overview.md) for guidance on writing queries.

:::image type="content" source="./media/metrics-usage-insights/log-query.png" lightbox="./media/metrics-usage-insights/log-query.png" alt-text="A screenshot showing Azure Monitor workspace historical data.":::
