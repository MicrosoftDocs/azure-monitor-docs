---
title: Detect and analyze anomalies with KQL in Azure Monitor
description: Learn how to use KQL machine learning tools for time series analysis and anomaly detection in Azure Monitor Log Analytics.
ms.topic: tutorial
ms.reviewer: ilanawaitser
ms.date: 08/07/2026
ai-usage: ai-assisted
# Customer intent: As a data analyst, I want to use the native machine learning capabilities of Azure Monitor Logs to gain insights from my log data without having to export data outside of Azure Monitor.
---

# Tutorial: Detect and analyze anomalies using KQL machine learning capabilities in Azure Monitor

The Kusto Query Language (KQL) includes machine learning operators, functions and plugins for time series analysis, anomaly detection, forecasting, and root cause analysis. Use these KQL capabilities to perform advanced data analysis in Azure Monitor without the overhead of exporting data to external machine learning tools.

Azure Monitor Logs is the service that stores your log data. Log Analytics is the tool in the Azure portal for querying that data by using KQL. The KQL function reference articles linked in this tutorial are shared Kusto documentation.

In this tutorial, you learn how to:

> [!div class="checklist"]
> * Create a time series
> * Identify anomalies in a time series
> * Tweak anomaly detection settings to refine results
> * Analyze the root cause of anomalies

> [!NOTE]
> This tutorial provides links to a Log Analytics demo environment where you run the KQL query examples. The data in the demo environment is dynamic, so the query results aren't the same as the query results shown in this article. Run the same KQL queries and principles in your own environment and in all [Azure Monitor tools that use KQL](log-query-overview.md).

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A workspace with log data.

[!INCLUDE [log-analytics-query-permissions](includes/log-analytics-query-permissions.md)]

## Create a time series with make-series

Use the KQL `make-series` operator to create a time series.

Create a time series based on logs in the [Usage table](/azure/azure-monitor/reference/tables/usage), which holds information about how much data each table in a workspace ingests every hour, including billable and non-billable data.

This query uses `make-series` to chart the total amount of billable data ingested by each table in the workspace every day, over the past 21 days:

<a href="https://portal.azure.com#@ec7cb332-9a0a-4569-835a-ce7658e8444e/blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade/resourceId/%2FDemo/source/LogsBlade.AnalyticsShareLinkToQuery/q/H4sIAAAAAAAAA6VSu04DMRDs8xWrVHdSyKsEpQggQQoKUPiAvfNecorPF%252By1IiMKfoPf40tYO5cEBaWiHY9nd2ZWE4NjtMx1QzCD6UTdwGgEyzXtcVDIBG0FLEgiObI1uQGUrTdcmxUUWG6gsm2TOKW3lsz%252BX0%252BLPBnViY9P2gL%252BXzl%252Bqiwm7W7vx3YnkkwGuAWHzVZT5GPv1eGKDtMZC8F39P35ZQnQoA7vMq%252F3Abs1CbIU4QcyZGWSgoJ4R6KYpUDaSmHIcNVmx9zyfDg8e%252BtM53meZkZ3Fo1sULU2mXnzZMNAtFe1MdErMkym1%252BMxzJ8OoVS1ddFukBVVjOwCT2NHq80pzDTu6Gjhbmutk%252B3ZDPpsPfXjZgtTaq%252BkBqMDFAdKTOwgZsl5LUdCLGINbuhqXxPMS%252FaoU64z55vs2aO0xiEHRRXGP9K4CJ%252Blmeq8nGTq7UKW8kDbX60XAe5l02XYpmbvLMkE9%252FeedO1Sj2FvjCNfzMgxKbKJWq7jqYvGS8Jc59rFEPDE%252BAERMgnLLgMAAA%253D%253D" target="_blank">Run this query in the demo environment</a>

```kusto
let starttime = 21d; // The start date of the time series, counting back from the current date
let endtime = 0d; // The end date of the time series, counting back from the current date
let timeframe = 1d; // How often to sample data
Usage // The table we're analyzing
| where TimeGenerated between (startofday(ago(starttime))..startofday(ago(endtime))) // Time range for the query, beginning at 12:00 AM of the first day and ending at 12:00 AM of the last day in the time range
| where IsBillable == "true" // Include only billable data in the result set
| make-series ActualUsage=sum(Quantity) default = 0 on TimeGenerated from startofday(ago(starttime)) to startofday(ago(endtime)) step timeframe by DataType // Creates the time series, listed by data type
| render timechart // Renders results in a timechart
```

The resulting chart shows some anomalies, for example, in the `AzureDiagnostics` and `SecurityEvent` data types:

:::image type="content" source="./media/machine-learning-azure-monitor-log-analytics/make-series-kql.gif" alt-text="An animated GIF showing a chart of the total data ingested by each table in the workspace each day, over 21 days. The cursor moves to highlight three usage anomalies on the chart.":::

To list all anomalies in a time series, use the `series_decompose_anomalies()` function, described in [Find anomalies in a time series with series_decompose_anomalies()](#find-anomalies-in-a-time-series-with-series_decompose_anomalies).

> [!NOTE]
> For more information about `make-series` syntax and usage, see [make-series operator](/kusto/query/make-series-operator).

## Find anomalies in a time series with series_decompose_anomalies()

The `series_decompose_anomalies()` function takes a series of values as input and extracts anomalies.

Give the result set of the [make-series query in Create a time series](#create-a-time-series-with-make-series) as input to the `series_decompose_anomalies()` function:

<a href="https://portal.azure.com#@ec7cb332-9a0a-4569-835a-ce7658e8444e/blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade/resourceId/%2FDemo/source/LogsBlade.AnalyticsShareLinkToQuery/q/H4sIAAAAAAAAA61Uu3LUQBDM%252FRWDI6lKfoZQFxjsAgcEYBO75rQj3eLVrtiH70QR8Bv8Hl%252FC7Ejn09mYiExa9fRMd8%252FKUIQQ0ceoO4IFnJ%252BpN3ByAjf5DBRGgsZ5iCsCQQTymkIFtUs2atvCEut7aLzrBFMn78mOhQeGucmqifl0JL6y6j%252FQ5qLGoxBPE39wa3BNJAvRQcCuN5TxePAlYEsZcZu74ZLP1%252FT75y9PgBbN8J37HfyA9Yr45JaJ35Mlz50ULCmuiRkLscg1CocCW1c8OlaWx8dPvk2Ky7KUnlmdR9vuBH9L5IeKuVttbdaKEc7OX5%252BewsVHViCYRvuQ5Q48osomvoAzOMG03Zkp7R4VXYe32hiRvVjAYfSJDvNk17Y2SVEAZ80Ayy0mW7Zl8xSS4f2gyGwd3tPRmBNc1DGhEWMXIXXFp4QcWxxKUNRgruG8mfiJnZLny1ZKcC%252BYyR%252Bon8W%252BHOCSJ70deon2nSfuEJ4vlNFBghxGYZHxrIU2vCequLCuQyO48XG4qZ2nCq42PdVcJwpLFjPS3SmqXde7QHe4LS1mXkjiQhHG3DbRYx3zy4TmvQ48jhv9dSn2KeYs5%252BZmrx%252BOaNNnihl7tifP75pCucRZldUTf2cAfhfjtsoy8fP6ueq%252F0e%252F5MAMYZ1sReyVTjr6j97yItSQhjv%252FDtPJxPXfjvco7k0k%252FU0zesmvGANfpqB9I%252FLTUorwoetD85BgkO0XTnJDyoMzde%252FeVT%252Fb9qWZmVnvS9oyodmsxX7FLarTlMdcrXa%252F4R2VSZ8VTL%252BPm2ILjfyYLx2Uo5oz5WoRaloMRYbpXQaAjDIJEwPcuI6f77rxiB237B35S8SykBQAA" target="_blank">Run this query in the demo environment</a>

```kusto
let starttime = 21d; // Start date for the time series, counting back from the current date
let endtime = 0d; // End date for the time series, counting back from the current date
let timeframe = 1d; // How often to sample data
Usage // The table we're analyzing
| where TimeGenerated between (startofday(ago(starttime))..startofday(ago(endtime))) // Time range for the query, beginning at 12:00 AM of the first day and ending at 12:00 AM of the last day in the time range
| where IsBillable == "true" // Includes only billable data in the result set
| make-series ActualUsage=sum(Quantity) default = 0 on TimeGenerated from startofday(ago(starttime)) to startofday(ago(endtime)) step timeframe by DataType // Creates the time series, listed by data type
| extend(Anomalies, AnomalyScore, ExpectedUsage) = series_decompose_anomalies(ActualUsage) // Scores and extracts anomalies based on the output of make-series
| mv-expand ActualUsage to typeof(double), TimeGenerated to typeof(datetime), Anomalies to typeof(double),AnomalyScore to typeof(double), ExpectedUsage to typeof(long) // Expands the array created by series_decompose_anomalies()
| where Anomalies != 0  // Returns all positive and negative deviations from expected usage
| project TimeGenerated,ActualUsage,ExpectedUsage,AnomalyScore,Anomalies,DataType // Defines which columns to return
| sort by abs(AnomalyScore) desc // Sorts results by anomaly score in descending ordering
```

This query returns all usage anomalies for all tables in the last three weeks:

:::image type="content" source="./media/machine-learning-azure-monitor-log-analytics/anomalies-kql.png" lightbox="./media/machine-learning-azure-monitor-log-analytics/anomalies-kql.png" alt-text="A screenshot of a table showing a list of anomalies in usage for all tables in the workspace.":::

The query results show that the function:

- Calculates an expected daily usage for each table.
- Compares actual daily usage to expected usage.
- Assigns an anomaly score to each data point, indicating the extent of the deviation of actual usage from expected usage.
- Identifies positive (`1`) and negative (`-1`) anomalies in each table.

> [!NOTE]
> For more information about `series_decompose_anomalies()` syntax and usage, see [series_decompose_anomalies()](/kusto/query/series-decompose-anomalies-function).

## Tweak anomaly detection settings to refine results

It's good practice to review initial query results and make tweaks to the query, if necessary. Outliers in input data can affect the function's learning, and you might need to adjust the function's anomaly detection settings to get more accurate results.

Filter the results of the `series_decompose_anomalies()` query for anomalies in the `AzureDiagnostics` data type:

:::image type="content" source="./media/machine-learning-azure-monitor-log-analytics/anomalies-filtered-kql.png" lightbox="./media/machine-learning-azure-monitor-log-analytics/anomalies-filtered-kql.png" alt-text="A table showing the results of the anomaly detection query, filtered for results from the Azure Diagnostics data type.":::

The dates and scores in the results change as the 21-day query window moves. Compare the current results with the chart from the [make-series query in Create a time series](#create-a-time-series-with-make-series) and note which points the function identifies as anomalies:

:::image type="content" source="./media/machine-learning-azure-monitor-log-analytics/make-series-kql-anomalies.png" lightbox="./media/machine-learning-azure-monitor-log-analytics/make-series-kql-anomalies.png" alt-text="A screenshot showing a chart of the total data ingested by the Azure Diagnostics table with anomalies highlighted.":::

The difference in results occurs because the `series_decompose_anomalies()` function scores anomalies relative to the expected usage value, which the function calculates based on the full range of values in the input series.

To evaluate recent points against a baseline learned from earlier points, exclude one or more points at the end of the series from the function's learning process.

The [syntax of the `series_decompose_anomalies()` function](/kusto/query/series-decompose-anomalies-function) is:

`series_decompose_anomalies(Series [, Threshold, Seasonality, Trend, Test_points, AD_method, Seasonality_threshold])`

The function takes these arguments:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `Series` | The input series of values to analyze. | Required |
| `Threshold` | Anomaly detection threshold. Lower values increase sensitivity. | `1.5` |
| `Seasonality` | Controls seasonal analysis. `-1` autodetects seasonality, `0` disables it, and a positive integer sets the period. | `-1` |
| `Trend` | Trend analysis method, such as `avg` or `linefit`. | `avg` |
| `Test_points` | Number of points at the end of the series to exclude from the learning (regression) process. | `0` |
| `AD_method` | Anomaly detection method. | `ctukey` |
| `Seasonality_threshold` | Threshold for scoring seasonality when autodetecting. | `0.6` |

To exclude the last data point from the learning process, set `Test_points` to `1`. This setting always holds out the final point in the current series. It doesn't refer to a fixed calendar date:

<a href="https://portal.azure.com#@ec7cb332-9a0a-4569-835a-ce7658e8444e/blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade/resourceId/%2FDemo/source/LogsBlade.AnalyticsShareLinkToQuery/q/H4sIAAAAAAAAA61Uy27UQBC85yuaXGJLzmMjcQHtISgR5IAiIJyjXk%252FbazKeMfPYXSMO%252FAa%252Fx5fQ0%252FbuegPhxM0eV1dXV%252FVYUwAf0IXQtARzuJyp13B%252BDp%252FSGSgMBJV1EJYEgvDkGvIFlDaa0JgaFlg%252BQuVsK5gyOkdmKDzSzE1GjcwXA%252FGNUf%252BBNhVVDoV4VPzOrsFWgQwECx7bTlPC49FnjzUlxH3qhgs%252BX9OvHz8dARrU%252FTfud%252FQd1kvik3smfkuGHHdSsKCwJmbMxCJbKewzrG22cyzPz86efBsnzvNceqbpHJp6P%252FDXSK4vmLtujEmzYoDZ5auLC7h6zxMIpmqcT%252BP2LFElE5%252FBaRxhjdmbKe12E936N43WMvZ8DsfBRTpOym5NqaMiD9boHhZbTLJsy%252BbIR837QYHZWnyk0yEnuCpDRC3Gzn1ssw8RObbQ56CowlTDeTPxEzslz%252BetlOCeMZM%252FUDeJfdHDNSu977sh2rvrO9ZIG85fZVfGtqhloYbH%252FlNpHRVws%252BmoZCWiPGeRwzwPikrbdtbTA25Ls8mMxezsZXE6K05wVZ8UMwlWGP0QzyY4LEN6GYt5fT3PawcbbQxdDCmyiYcFl6UAUrC7JFeoI23dH71O1q9OadOlVhNRya3A49sqUzZydHnxxO4JgN%252FFx60hifjP%252BqlZf6M%252FsG8C0NbUYsqNqPQiH53jvSwdDTep%252F5fX%252BW5b9%252FJepBVKpB8pRGfYXa2B65rQrEh8N1SjvChaNfxkGSQrRqNOiEkoc3fOfuGTQ3%252BKacIHox0YUey3abpx11Q1hmWul0255P%252BWjq0RT53ITbF5y79QHhwXPpsyplviS1kiRvjxmnmBDjDwEgEvQkKO1986xQ6a%252BjfngHTtswUAAA%253D%253D" target="_blank">Run this query in the demo environment</a>

```kusto
let starttime = 21d; // Start date for the time series, counting back from the current date
let endtime = 0d; // End date for the time series, counting back from the current date
let timeframe = 1d; // How often to sample data
Usage // The table we're analyzing
| where TimeGenerated between (startofday(ago(starttime))..startofday(ago(endtime))) // Time range for the query, beginning at 12:00 AM of the first day and ending at 12:00 AM of the last day in the time range
| where IsBillable == "true" // Includes only billable data in the result set
| make-series ActualUsage=sum(Quantity) default = 0 on TimeGenerated from startofday(ago(starttime)) to startofday(ago(endtime)) step timeframe by DataType // Creates the time series, listed by data type
| extend(Anomalies, AnomalyScore, ExpectedUsage) = series_decompose_anomalies(ActualUsage, 1.5, -1, 'avg', 1) // Excludes the final series value from learning. Other input values are the function defaults
| mv-expand ActualUsage to typeof(double), TimeGenerated to typeof(datetime), Anomalies to typeof(double),AnomalyScore to typeof(double), ExpectedUsage to typeof(long) // Expands the array created by series_decompose_anomalies()
| where Anomalies != 0  // Returns all positive and negative deviations from expected usage
| project TimeGenerated,ActualUsage,ExpectedUsage,AnomalyScore,Anomalies,DataType // Defines which columns to return
| sort by abs(AnomalyScore) desc // Sorts results by anomaly score in descending ordering
```

Filter the results for the `AzureDiagnostics` data type:

:::image type="content" source="./media/machine-learning-azure-monitor-log-analytics/refined-anomalies-filtered-kql.png" lightbox="./media/machine-learning-azure-monitor-log-analytics/refined-anomalies-filtered-kql.png" alt-text="A table showing the results of the modified anomaly detection query, filtered for results from the Azure Diagnostics data type.":::

Compare the modified results with the original results. Depending on the current data, holding out the final point might change its expected value, anomaly score, or classification. Increase `Test_points` only when you intend to evaluate or forecast that many points at the end of the series.

## Analyze the root cause of anomalies with the diffpatterns() plugin

Comparing expected values to anomalous values helps you understand the cause of the differences between the two sets.

The KQL `diffpatterns()` plugin compares two data sets of the same structure and finds patterns that characterize differences between the two data sets.

The following query selects the strongest `AzureDiagnostics` usage anomaly in the current 21-day window. It then compares records from that date with records from the other dates. Open the [Log Analytics demo environment](https://portal.azure.com/#blade/Microsoft_Azure_Monitoring_Logs/DemoLogsBlade), and run the query.

```kusto
let starttime = 21d; // Start date for the time series, counting back from the current date
let endtime = 0d; // End date for the time series, counting back from the current date
let anomalyDate = toscalar(
	Usage
	| where TimeGenerated between (startofday(ago(starttime))..startofday(ago(endtime)))
	| where IsBillable == "true" and DataType == "AzureDiagnostics"
	| make-series ActualUsage=sum(Quantity) default = 0 on TimeGenerated from startofday(ago(starttime)) to startofday(ago(endtime)) step 1d
	| extend (Anomalies, AnomalyScore, ExpectedUsage) = series_decompose_anomalies(ActualUsage)
	| mv-expand TimeGenerated to typeof(datetime), Anomalies to typeof(double), AnomalyScore to typeof(double)
	| where Anomalies != 0
	| top 1 by abs(AnomalyScore) desc
	| project TimeGenerated
);
AzureDiagnostics
| extend AnomalyDate = iff(startofday(TimeGenerated) == anomalyDate, "AnomalyDate", "OtherDates") // Splits the result set into the selected anomaly date and all other dates
| where TimeGenerated between (startofday(ago(starttime))..startofday(ago(endtime))) // Defines the time range for the query
| project AnomalyDate, Resource // Defines which columns to return
| evaluate diffpatterns(AnomalyDate, "OtherDates", "AnomalyDate") // Compares usage on the anomaly date with the regular usage pattern
```

The query identifies each entry in the table as occurring on *AnomalyDate* or *OtherDates*. The `diffpatterns()` plugin then splits these data sets (A is *OtherDates*, and B is *AnomalyDate*) and returns patterns that contribute to the differences between the sets. If the query doesn't detect an anomaly, increase the time range or adjust the anomaly threshold before running this analysis.

:::image type="content" source="./media/machine-learning-azure-monitor-log-analytics/diffpatterns-kql-log-analytics.png" lightbox="./media/machine-learning-azure-monitor-log-analytics/diffpatterns-kql-log-analytics.png" alt-text="A screenshot showing a table with three rows. Each row shows a difference between the usage on the anomalous use and the baseline usage.":::

Review the returned patterns to find resources whose record count or percentage differs most between *AnomalyDate* and *OtherDates*. The values vary with the selected anomaly and the current contents of the demo workspace.

The *PercentDiffAB* column shows the absolute percentage point difference between A and B (|PercentA - PercentB|), which is the main measure of the difference between the two sets. By default, the `diffpatterns()` plugin returns differences of over 5% between the two data sets. Adjust the threshold argument to change this behavior:

| Argument | Description | Default |
|----------|-------------|---------|
| Threshold | Minimum percentage point difference between the two data sets for a pattern to be returned. Accepts a value between `0.015` and `1`. | `0.05` |

For example, to return only differences of 20% or more between the two data sets, set `| evaluate diffpatterns(AnomalyDate, "OtherDates", "AnomalyDate", "~", 0.20)` in the query above. The query returns only patterns with an absolute percentage-point difference of 20% or more. The number of results depends on the selected anomaly and the current demo data. The following image shows an example result:

:::image type="content" source="media/machine-learning-azure-monitor-log-analytics/diffpatterns-kql-log-analytics-threshold.png" lightbox="media/machine-learning-azure-monitor-log-analytics/diffpatterns-kql-log-analytics-threshold.png" alt-text="Screenshot of a diffpatterns query result with one resource and a 73.36 percentage-point difference between data sets.":::

> [!NOTE]
> For more information about `diffpatterns()` syntax and usage, see [diffpatterns plugin](/kusto/query/diffpatterns-plugin).

## Next steps

Learn more about:

- [Log queries in Azure Monitor](log-query-overview.md).
- [Tutorial: Learn common operators](/kusto/query/tutorials/learn-common-operators).
- [Analyze logs in Azure Monitor with KQL](/training/modules/analyze-logs-with-kql/)
