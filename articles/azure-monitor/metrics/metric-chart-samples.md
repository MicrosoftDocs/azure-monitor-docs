---
title: Azure Monitor metric chart example
description: Learn about visualizing your Azure Monitor data.
ms.topic: how-to
ms.date: 08/26/2024
ms.reviewer: vitalyg
---

# Metric chart examples 

The Azure platform offers [over a thousand metrics](../reference/supported-metrics/metrics-index.md), many of which have dimensions. By [using dimension filters and splitting](analyze-metrics.md#use-dimension-filters-and-splitting), controlling chart type, and adjusting chart settings you can create powerful diagnostic views and dashboards that provide insight into the health of your infrastructure and applications. This article shows some examples of the charts that you can build using Metrics Explorer, and explains the necessary steps to configure each of these charts.

## Website CPU utilization by server instances

This chart shows if the CPU usage for an App Service Plan was within the acceptable range and breaks it down by instance to determine whether the load was properly distributed. 

:::image type="content" source="media/metric-chart-samples/cpu-by-instance.png" lightbox="media/metric-chart-samples/cpu-by-instance.png" alt-text="A screenshot showing a line chart of average cpu percentage by server instance.":::

### How to configure this chart

1. Select **Metrics** from the **Monitoring** section of your App service plan's menu
1. Select the **CPU Percentage** metric. 
1. Select **Apply splitting** and select the **Instance** dimension.

## Application availability by region

View your application's availability by region to identify which geographic locations are having problems. This chart shows the Application Insights availability metric. The chart shows that the monitored application has no problem with availability from the East US data center, but it's experiencing a partial availability problem from West US, and East Asia.

:::image type="content" source="media/metric-chart-samples/availability-by-location.png" lightbox="media/metric-chart-samples/availability-by-location.png" alt-text="A screenshot showing a line chart of average availability by location.":::

### How to configure this chart

1. Turn on [Application Insights availability](/previous-versions/azure/azure-monitor/app/monitor-web-app-availability) monitoring for your website.
1. Select your Application Insights resource.
1. Select the **Availability** metric. 
1. Apply splitting on the **Run location** dimension.

## Volume of failed storage account transactions by API name

Your storage account resource is experiencing an excess volume of failed transactions. Use the transactions metric to identify which API is responsible for the excess failure. Notice that the following chart is configured with the same dimension (API name) in splitting and filtered by failed response type:

:::image type="content" source="media/metric-chart-samples/split-and-filter-example.png" lightbox="media/metric-chart-samples/split-and-filter-example.png" alt-text="A screenshot showing a chart of transactions by API name.":::

### How to configure this chart

1. In the scope dropdown, select your Storage Account
1. In the metric dropdown, select the **Transactions** metric.
1. Select **Add filter** and select **Response type** from the **Property** dropdown.
1. Select **CLientOtherError** from the **Values** dropdown.
1. Select **Apply splitting** and select **API name** from the values dropdown.

## Total requests of Cosmos DB by Database Names and Collection Names

You want to identify which collection in which database of your Cosmos DB instance is having maximum requests to adjust your costs for Cosmos DB.

:::image source="media/metric-chart-samples/multiple-split-example.png" lightbox="media/metric-chart-samples/multiple-split-example.png" alt-text="A screenshot showing a segmented line chart of total requests.":::

### How to configure this chart

1. In the scope dropdown, select your Cosmos DB.
1. In the metric dropdown, select **Total Requests**.
1. Select **Apply splitting** and select the **DatabaseName** and **CollectionName** dimensions from the **Values** dropdown.

## Next steps

* Learn about Azure Monitor [Workbooks](../visualize/workbooks-overview.md)
* Learn more about [Metric Explorer](analyze-metrics.md)
