---
title: Log Analytics integration with Power BI
description: Learn how to connect Azure Monitor Log Analytics to Power BI and create datasets, reports, and dashboards from log query results.
ms.topic: how-to
ms.reviewer: ilanawaitser
ms.date: 05/08/2026
ai-usage: ai-assisted

---
# Integrate Log Analytics with Power BI

[Azure Monitor Logs](../logs/data-platform-logs.md) provides an end-to-end solution for ingesting logs. From [Log Analytics](../data-platform.md), Azure Monitor's user interface for querying logs, you can connect log data to Microsoft's [Power BI](https://powerbi.microsoft.com/) data visualization platform. 

This article explains how to connect Log Analytics to Power BI by exporting query results. Use the exported data from Log Analytics to build reports and dashboards in Power BI.

> [!NOTE]
> Use free Power BI features to integrate and create reports and dashboards. More advanced features, such as sharing your work, scheduled refreshes, dataflows, and incremental refresh might require purchasing a Power BI Pro or Premium account. For more information, see [Learn more about Power BI pricing and features](https://powerbi.microsoft.com/pricing/).

## Prerequisites

- To export the query to a .txt file that you can use in Power BI Desktop, you need [Power BI Desktop](https://powerbi.microsoft.com/desktop/).
- To create a new dataset based on your query directly in the Power BI service:
  - You need a Power BI account.
  - You must give permission in Azure for the Power BI service to write logs. For more information, see [Prerequisites to configure Azure Log Analytics for Power BI](/power-bi/transform-model/log-analytics/desktop-log-analytics-configure#prerequisites).

## Permissions required

- To export the query to a .txt file that you can use in Power BI Desktop, you need `Microsoft.OperationalInsights/workspaces/query/*/read` permissions to the Log Analytics workspaces you query, as provided by the [Log Analytics Reader built-in role](./manage-access.md#log-analytics-reader), for example.
- To create a new dataset based on your query directly in the Power BI service, you need `Microsoft.OperationalInsights/workspaces/write` permissions to the Log Analytics workspaces you query, as provided by the [Log Analytics Contributor built-in role](./manage-access.md#log-analytics-contributor), for example.

## Connect to Power BI from Log Analytics

To export log data to Power BI, start with a query in Log Analytics:

1. In the [Azure portal](https://portal.azure.com), go to your Log Analytics workspace.
1. Select **Logs** to open the Log Analytics query editor.
1. Write or select a [Kusto Query Language (KQL)](/azure/data-explorer/kusto/query/) query that returns the data you want to visualize in Power BI.
1. Select **Run** to verify the query returns the expected results.
1. On the toolbar, select **Export**, and then choose one of the **Power BI** options described in the next section.

## Create Power BI datasets and reports from Log Analytics queries

The **Export** menu provides two options for working with your Log Analytics query results in Power BI:

:::image type="content" source="media/log-powerbi/export-to-power-bi-log-analytics-option.png" alt-text="Screenshot showing Export to Power BI option in the Log Analytics Export menu." lightbox="media/log-powerbi/export-to-power-bi-log-analytics-option.png":::

- **Power BI (as an M query)**: This option exports the query to a .txt file that contains an [M (Power Query formula language)](/powerquery-m/) script with the connection details for your Log Analytics workspace. Open this file in Power BI Desktop to load the query results as a data source. Use this option when you need to model or transform data in ways that aren't available in the Power BI service. Otherwise, consider exporting the query as a new dataset.
- **Power BI (new Dataset)**: This option creates a new dataset based on your query directly in the Power BI service. After you create the dataset, you can create reports, use Analyze in Excel, share it with others, and use other Power BI features. For more information, see [Create a Power BI dataset directly from Log Analytics](/power-bi/connect-data/create-dataset-log-analytics).

> [!NOTE]
> The export operation is subject to the [Log Analytics Query API limits](../service-limits.md#la-query-api). If your query results exceed the maximum size of data returned by the Query API, the operation exports partial results.

## Collect data with Power BI dataflows

[Power BI dataflows](/power-bi/service-dataflows-overview) provide an alternative way to bring Log Analytics data into Power BI. A dataflow is a cloud-based ETL (extract, transform, and load) process that collects, transforms, and stores data for use across multiple Power BI datasets.

Use dataflows when you need to:

- Centralize data preparation logic that multiple datasets and reports share.
- Combine Log Analytics data with data from other sources before modeling.
- Schedule data refresh without requiring Power BI Desktop.

To connect a dataflow to Log Analytics, add an Azure Log Analytics connector as a data source in your dataflow. For more information, see [Create and use dataflows in Power BI](/power-bi/transform-model/dataflows/dataflows-create).

## Incremental refresh

Both Power BI datasets and Power BI dataflows support incremental refresh. Incremental refresh for datasets is available with Power BI Pro and Premium licenses. Incremental refresh for dataflows requires Power BI Premium.

Incremental refresh runs small queries and updates smaller amounts of data per run instead of ingesting all the data again and again when you run the query. You can save large amounts of data but add a new increment of data every time the query is run. This behavior is ideal for longer-running reports.

Power BI incremental refresh relies on the existence of a **datetime** field in the result set. Before you configure incremental refresh, make sure your Log Analytics query result set includes at least one **datetime** field.

To learn more and how to configure incremental refresh, see [Power BI datasets and incremental refresh](/power-bi/service-premium-incremental-refresh) and [Power BI dataflows and incremental refresh](/power-bi/service-dataflows-incremental-refresh).

## Reports and dashboards

After your data is available in Power BI, you can create reports and dashboards to visualize your log data. Common use cases include:

- Building dashboards that show operational health metrics from Azure Monitor logs.
- Creating trend reports that track log query results over time.
- Sharing insights with stakeholders who don't have access to Log Analytics.

For more information, see [Create and share your first Power BI report](/training/modules/build-your-first-power-bi-report/) and [Introduction to dashboards for Power BI designers](/power-bi/create-reports/service-dashboards).

## Next steps

Learn how to:
- [Get started with Log Analytics queries](./log-query-overview.md).
- [Integrate Log Analytics and Excel](log-excel.md).
