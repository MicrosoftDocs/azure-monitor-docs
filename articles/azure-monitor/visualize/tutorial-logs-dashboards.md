---
title: Create and share dashboards that visualize data in Azure Monitor Logs
description: This tutorial explains how to create a dashboard that visualizes data based on a query that you run in Azure Monitor Logs.
ms.topic: tutorial
ms.date: 01/23/2025

ms.custom: mvc
---

# Create and share dashboards that visualize data in Azure Monitor Logs

Log Analytics dashboards can visualize all of your saved log queries. Visualizations let you find, correlate, and share IT operational data in your organization. This tutorial shows how to create a shared dashboard, based on log query, which can to be accessed by your IT operations support team. You learn how to:

> [!div class="checklist"]
> * Create a shared dashboard in the Azure portal.
> * Visualize a performance log query.
> * Add a log query to a shared dashboard.
> * Customize a tile in a shared dashboard.

To complete the example in this tutorial, you must have an existing virtual machine [connected to the Log Analytics workspace](../vm/monitor-virtual-machine.md).

> [!TIP]
> In this tutorial, you create a dashboard based on a simple query on the `Perf` table. For more complex queries on large data sets or long time ranges, use [summary rules](../logs/summary-rules.md) to aggregate the data you want to visualize. Summary rules aggregate data from one or more tables as the data arrives at your Log Analytics workspace. Visualizing the aggregated data directly from a custom table of summarized data, instead of querying raw data from one or more tables, improves query performance and reduces query errors and timeouts.

## Sign in to the Azure portal
Sign in to the [Azure portal](https://portal.azure.com).

## Create a shared dashboard
Select **Dashboard** to open your default [dashboard](/azure/azure-portal/azure-portal-dashboards). Your dashboard will look different from the following example.
<!-- convertborder later -->
:::image type="content" source="media/tutorial-logs-dashboards/log-analytics-portal-dashboard.png" lightbox="media/tutorial-logs-dashboards/log-analytics-portal-dashboard.png" alt-text="Screenshot that shows an Azure portal dashboard." border="false":::

Here you can bring together operational data that's most important to IT across all your Azure resources, including telemetry from Azure Log Analytics. Before we visualize a log query, let's first create a dashboard and share it. We can then focus on our example performance log query, which will render as a line chart, and add it to the dashboard.

> [!NOTE]
> The following chart types are supported in Azure dashboards by using log queries:
> - `areachart`
> - `columnchart`
> - `piechart` (will render in dashboard as a donut)
> - `scatterchart`
> - `timechart`

To create a dashboard, select **New dashboard**.
<!-- convertborder later -->
:::image type="content" source="media/tutorial-logs-dashboards/log-analytics-create-dashboard-01.png" lightbox="media/tutorial-logs-dashboards/log-analytics-create-dashboard-01.png" alt-text="Screenshot that shows creating a new dashboard in the Azure portal." border="false":::

This action creates a new, empty, private dashboard. It opens in a customization mode where you can name your dashboard and add or rearrange tiles. Edit the name of the dashboard and specify **Sample Dashboard** for this tutorial. Then select **Done customizing**.<br><br> <!-- convertborder later -->:::image type="content" source="media/tutorial-logs-dashboards/log-analytics-create-dashboard-02.png" lightbox="media/tutorial-logs-dashboards/log-analytics-create-dashboard-02.png" alt-text="Screenshot that shows saving a customized Azure dashboard." border="false":::

When you create a dashboard, it's private by default, so you're the only person who can see it. To make it visible to others, select **Share**.
<!-- convertborder later -->
:::image type="content" source="media/tutorial-logs-dashboards/log-analytics-share-dashboard.png" lightbox="media/tutorial-logs-dashboards/log-analytics-share-dashboard.png" alt-text="Screenshot that shows sharing a new dashboard in the Azure portal." border="false":::

Choose a subscription and resource group for your dashboard to be published to. For convenience, you're guided toward a pattern where you place dashboards in a resource group called **dashboards**. Verify the subscription selected and then select **Publish**. Access to the information displayed in the dashboard is controlled with [Azure role-based access control](/azure/role-based-access-control/role-assignments-portal).

## Visualize a log query
[Log Analytics](../logs/log-analytics-overview.md) is a dedicated portal used to work with log queries and their results. Features include the ability to edit a query on multiple lines and selectively execute code. Log Analytics also uses context-sensitive IntelliSense and Smart Analytics. 

In this tutorial, you'll use Log Analytics to create a performance view in graphical form and save it for a future query. Then you'll pin it to the shared dashboard you created earlier.

> [!NOTE]
> **Multi-scope pinning**: You can pin queries to a dashboard from multiple resources, but only if they are of the *same resource type*.
>
> **Edit mode limitation**: Changing the query scope while the dashboard tile is in **Edit** mode is *not supported*.

Open Log Analytics by selecting **Logs** on the Azure Monitor menu. It starts with a new blank query.
<!-- convertborder later -->
:::image type="content" source="media/tutorial-logs-dashboards/homepage.png" lightbox="media/tutorial-logs-dashboards/homepage.png" alt-text="Screenshot that shows the home page." border="false":::

Enter the following query to return processor utilization records for both Windows and Linux computers. The records are grouped by `Computer` and `TimeGenerated` and displayed in a visual chart. Select **Run** to run the query and view the resulting chart.

```Kusto
Perf 
| where CounterName == "% Processor Time" and ObjectName == "Processor" and InstanceName == "_Total" 
| summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 1hr), Computer 
| render timechart
```

Save the query by selecting **Save**.

:::image type="content" source="media/tutorial-logs-dashboards/save-query.png" lightbox="media/tutorial-logs-dashboards/save-query.png" alt-text="Screenshot that shows how to save a query and pin it to a dashboard.":::

In the **Save Query** control panel, provide a name such as **Azure VMs - Processor Utilization** and a category such as **Dashboards**. Select **Save**. This way you can create a library of common queries that you can use and modify. Finally, pin this query to the shared dashboard you created earlier. Select the **Pin to dashboard** button in the upper-right corner of the page and then select the dashboard name.

Now that we have a query pinned to the dashboard, you'll notice that it has a generic title and comment underneath it.

:::image type="content" source="media/tutorial-logs-dashboards/log-analytics-modify-dashboard-01.png" lightbox="media/tutorial-logs-dashboards/log-analytics-modify-dashboard-01.png" alt-text="Screenshot that shows an Azure dashboard sample.":::

 Rename the query with a meaningful name that can be easily understood by anyone who views it. Select **Edit** to customize the title and subtitle for the tile, and then select **Update**. A banner appears that asks you to publish changes or discard. Select **Save a copy**.

:::image type="content" source="media/tutorial-logs-dashboards/log-analytics-modify-dashboard-02.png" lightbox="media/tutorial-logs-dashboards/log-analytics-modify-dashboard-02.png" alt-text="Screenshot that shows a completed configuration of a sample dashboard.":::

> [!TIP]
> To learn more about using Log Analytics, see [Log Analytics tutorial](../logs/log-analytics-tutorial.md).

## Next steps
In this tutorial, you learned how to create a dashboard in the Azure portal and add a log query to it. Follow this link to see prebuilt Log Analytics script samples.

> [!div class="nextstepaction"]
> [Log Analytics script samples](../logs/queries.md)
