---
title: Monitor Azure resources with Azure Monitor | Microsoft Docs
description: This article describes how to collect and analyze monitoring data from resources in Azure by using Azure Monitor.
ms.topic: article
ms.date: 05/21/2025

---

# Monitor Azure resources with Azure Monitor

When you have critical applications and business processes that rely on Azure resources, you want to monitor those resources for their availability, performance, and operation. Azure Monitor is a full-stack monitoring service that provides a complete set of features to monitor your Azure resources. You can also use Azure Monitor to monitor resources in other clouds and on-premises.

In this article, you learn about:

> [!div class="checklist"]
> * Menu options in the Azure portal for monitoring Azure resources.
> * Azure Monitor tools that are used to collect and analyze data.
> * Data collected by Azure Monitor to monitor different Azure resources.

## Menu options
This article describes the menu options related to monitoring when you select a resource in the Azure portal. You can also access Azure Monitor features from the **Monitor** menu for all Azure resources. 

Different Azure services might have slightly different experiences, but they share a common set of monitoring options in the portal. These menu items include **Overview** and **Activity log** and multiple options in the **Monitoring** section of the menu.

:::image type="content" source="media/monitor-azure-resource/menu-01.png" lightbox="media/monitor-azure-resource/menu-01.png" alt-text="Screenshot that shows the Overview and Activity log menu items.":::


## Overview page

The **Overview** page includes details about the resource and often its current state. Many Azure services have a **Monitoring** tab that includes charts for a set of key metrics. Charts are a quick way to view the operation of the resource. You can select any of the charts to open them in Metrics Explorer for more detailed analysis.

To learn how to use Metrics Explorer, see [Analyze metrics for an Azure resource](./tutorial-metrics.md).

:::image type="content" source="media/monitor-azure-resource/overview-page.png" lightbox="media/monitor-azure-resource/overview-page.png" alt-text="Screenshot that shows the Overview page.":::

## Activity log

The **Activity log** menu item lets you view entries in the [activity log](./activity-log.md) for the resource. These are subscription-level events that track operations for each Azure resource, for example, creating a new resource or starting a virtual machine. Activity log events are automatically generated and collected for viewing in the Azure portal. 

:::image type="content" source="media/monitor-azure-resource/activity-log.png" lightbox="media/monitor-azure-resource/activity-log.png" alt-text="Screenshot that shows an activity log.":::

## Insights

The **Insights** menu item opens the insight for the resource if the Azure service has one. [Insights](../visualize/insights-overview.md) provide a customized monitoring experience built on the Azure Monitor data platform and standard features. Examples include [Application insights](../app/app-insights-overview.md), [Container insights](../containers/container-insights-overview.md), and [Virtual machine insights](../virtual-machines/monitor-vm-insights.md). 

:::image type="content" source="media/monitor-azure-resource/insights.png" lightbox="media/monitor-azure-resource/insights.png" alt-text="Screenshot that shows the Insights page." border="false":::


## Alerts

The **Alerts** page shows you any recent alerts that were fired for the resource. [Alerts](../alerts/alerts-overview.md) proactively notify you when important conditions are found in your monitoring data and can use data from either Metrics or Logs. To learn how to create alert rules and view alerts, see [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md) or [Create a log search alert for an Azure resource](../alerts/tutorial-log-alert.md).

:::image type="content" source="media/monitor-azure-resource/alerts-view.png" lightbox="media/monitor-azure-resource/alerts-view.png" alt-text="Screenshot that shows the Alerts page.":::

## Metrics

The **Metrics** menu item opens [Metrics Explorer](./metrics-getting-started.md) which allows you to analyze platform metrics for the resource. These are numerical values that are automatically collected at regular intervals and describe some aspect of a resource at a particular time. You can work with individual metrics or combine multiple metrics to identify correlations and trends. This is the same Metrics Explorer that opens when you select one of the charts on the **Overview** page. To learn how to use Metrics Explorer, see [Analyze metrics for an Azure resource](./tutorial-metrics.md).
<!-- convertborder later -->
:::image type="content" source="media/monitor-azure-resource/metrics.png" lightbox="media/monitor-azure-resource/metrics.png" alt-text="Screenshot that shows Metrics Explorer." border="false":::

## Diagnostic settings

The **Diagnostic settings** page lets you create a [diagnostic setting](./diagnostic-settings.md) to collect the resource logs for your resource. [Resource logs](../platform/resource-logs.md) provide insight into operations that were performed by an Azure resource, such as getting a secret from a key vault or making a request to a database. Resource logs are generated automatically, but you must create a diagnostic setting to send them to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) or some other destination.

To learn how to create a diagnostic setting, see [Collect and analyze resource logs from an Azure resource](./tutorial-resource-logs.md).

:::image type="content" source="media/monitor-azure-resource/diagnostic-settings.png" lightbox="media/monitor-azure-resource/diagnostic-settings.png" alt-text="Screenshot that shows the Diagnostic settings page.":::

## Logs
The **Logs** menu item opens [Log Analytics](../logs/log-analytics-overview.md) to analyze the resource logs and other data collected by Azure Monitor. Log Analytics is a powerful query engine that allows you to analyze large amounts of data and create custom queries to find specific information. Write your own custom queries using Kusto Query Language (KQL) or select from prebuilt queries to get started quickly.

There won't be any logs to query for the resource until you create a diagnostic setting to send its resource logs to a Log Analytics workspace. To learn how to create a diagnostic setting, see [Collect and analyze resource logs from an Azure resource](./tutorial-resource-logs.md).

:::image type="content" source="media/monitor-azure-resource/logs.png" lightbox="media/monitor-azure-resource/logs.png" alt-text="Screenshot that shows the Logs menu item with a KQL query for a sample resource.":::

## Next steps

Now that you have a basic understanding of Azure Monitor, get started analyzing some metrics for an Azure resource.

> [!div class="nextstepaction"]
> [Analyze metrics for an Azure resource](./tutorial-metrics.md)
