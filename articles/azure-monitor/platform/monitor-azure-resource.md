---
title: Monitor Azure resources with Azure Monitor
description: This article describes how to collect and analyze monitoring data from resources in Azure by using Azure Monitor.
ms.topic: concept-article
ms.date: 08/07/2026
ai-usage: ai-assisted

---

# Monitor Azure resources with Azure Monitor

When critical applications and business processes rely on Azure resources, monitor those resources for their availability, performance, and operation. Azure Monitor is a full-stack monitoring service that provides a complete set of features to monitor your Azure resources. Azure Monitor also monitors resources in other clouds and on-premises.

In this article, you learn about:

> [!div class="checklist"]
> * Menu options in the Azure portal for monitoring Azure resources.
> * Azure Monitor tools that are used to collect and analyze data.
> * Data collected by Azure Monitor to monitor different Azure resources.

## Monitoring menu options in the Azure portal

This article describes the menu options related to monitoring when you select an Azure resource in the Azure portal. Access Azure Monitor features from the **Monitor** menu for all Azure resources.

Different Azure services might have slightly different experiences, but they share a common set of monitoring options in the portal. These menu items include **Overview** and **Activity log** and multiple options in the **Monitoring** section of the menu.

:::image type="content" source="media/monitor-azure-resource/menu-01.png" lightbox="media/monitor-azure-resource/menu-01.png" alt-text="Screenshot that shows the Overview and Activity log menu items.":::

The following table summarizes each monitoring menu item, what it does, and where to learn more.

| Menu item | What it does | Learn more |
|-----------|--------------|------------|
| **Overview** | Shows details about the Azure resource, its current state, and charts for key metrics. | [Overview page for an Azure resource](#overview-page-for-an-azure-resource) |
| **Activity log** | Displays subscription-level events that track operations for the Azure resource. | [Activity log for an Azure resource](#activity-log-for-an-azure-resource) |
| **Insights** | Opens the customized monitoring experience for the Azure service, if one exists. | [Insights for an Azure resource](#insights-for-an-azure-resource) |
| **Alerts** | Shows recent alerts fired for the Azure resource and lets you create alert rules. | [Alerts for an Azure resource](#alerts-for-an-azure-resource) |
| **Metrics** | Opens Metrics explorer to analyze platform metrics for the Azure resource. | [Metrics for an Azure resource](#metrics-for-an-azure-resource) |
| **Diagnostic settings** | Lets you create a diagnostic setting to collect resource logs for the Azure resource. | [Diagnostic settings for an Azure resource](#diagnostic-settings-for-an-azure-resource) |
| **Logs** | Opens Log Analytics to analyze resource logs and other collected data. | [Logs for an Azure resource](#logs-for-an-azure-resource) |


## Overview page for an Azure resource

The **Overview** page includes details about the Azure resource and often its current state. Many Azure services have a **Monitoring** tab that includes charts for a set of key metrics. Charts are a quick way to view the operation of the Azure resource. Select any of the charts to open them in Metrics explorer for more detailed analysis.

To learn how to use Metrics explorer, see [Analyze metrics for an Azure resource](./tutorial-metrics.md).

:::image type="content" source="media/monitor-azure-resource/overview-page.png" lightbox="media/monitor-azure-resource/overview-page.png" alt-text="Screenshot that shows the Overview page.":::

## Activity log for an Azure resource

The **Activity log** menu item lets you view entries in the [activity log](./activity-log.md) for the Azure resource. Activity log entries are subscription-level events that track operations for each Azure resource, such as creating a new resource or starting a virtual machine. Azure automatically generates and collects activity log events for viewing in the Azure portal.

:::image type="content" source="media/monitor-azure-resource/activity-log.png" lightbox="media/monitor-azure-resource/activity-log.png" alt-text="Screenshot that shows an activity log.":::

## Insights for an Azure resource

The **Insights** menu item opens the insight for the Azure resource if the Azure service has one. [Insights](../visualize/insights-overview.md) provide a customized monitoring experience built on the Azure Monitor data platform and standard features. Examples include [Application Insights](../app/app-insights-overview.md), [Container insights](../containers/kubernetes-monitoring-overview.md), and [VM insights](../vm/monitor-vm.md).

:::image type="content" source="media/monitor-azure-resource/insights.png" lightbox="media/monitor-azure-resource/insights.png" alt-text="Screenshot that shows the Insights page." border="false":::


## Alerts for an Azure resource

The **Alerts** page shows you any recent alerts that were fired for the Azure resource. [Alerts](../alerts/alerts-overview.md) proactively notify you when important conditions are found in your monitoring data and can use data from either Metrics or Logs. To learn how to create alert rules and view alerts, see [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md) or [Create a log search alert for an Azure resource](../alerts/tutorial-log-alert.md).

:::image type="content" source="media/monitor-azure-resource/alerts-view.png" lightbox="media/monitor-azure-resource/alerts-view.png" alt-text="Screenshot that shows the Alerts page.":::

## Metrics for an Azure resource

The **Metrics** menu item opens [Metrics explorer](../metrics/analyze-metrics.md) to analyze platform metrics for the Azure resource. Platform metrics are numerical values that Azure automatically collects at regular intervals. They describe some aspect of an Azure resource at a particular time. Work with individual metrics or combine multiple metrics to identify correlations and trends. The same Metrics explorer opens when you select one of the charts on the **Overview** page. To learn how to use Metrics explorer, see [Analyze metrics for an Azure resource](./tutorial-metrics.md).
<!-- convertborder later -->
:::image type="content" source="media/monitor-azure-resource/metrics.png" lightbox="media/monitor-azure-resource/metrics.png" alt-text="Screenshot that shows Metrics explorer." border="false":::

## Diagnostic settings for an Azure resource

The **Diagnostic settings** page lets you create a [diagnostic setting](./diagnostic-settings.md) to collect the resource logs for your Azure resource. [Resource logs](../platform/resource-logs.md) provide insight into operations that an Azure resource performs, such as getting a secret from a key vault or making a request to a database. Azure automatically generates resource logs, but you must create a diagnostic setting to send them to a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md) or another destination.

To learn how to create a diagnostic setting, see [Collect and analyze resource logs from an Azure resource](./tutorial-resource-logs.md).

:::image type="content" source="media/monitor-azure-resource/diagnostic-settings.png" lightbox="media/monitor-azure-resource/diagnostic-settings.png" alt-text="Screenshot that shows the Diagnostic settings page.":::

## Logs for an Azure resource

The **Logs** menu item opens [Log Analytics](../logs/log-analytics-overview.md) to analyze the resource logs and other data collected by Azure Monitor. Log Analytics is a powerful query engine that allows you to analyze large amounts of data and create custom queries to find specific information. Write your own custom queries using Kusto Query Language (KQL) or select from prebuilt queries to get started quickly.

You can't query resource logs until you create a diagnostic setting to send them to a Log Analytics workspace. To learn how to create a diagnostic setting, see [Collect and analyze resource logs from an Azure resource](./tutorial-resource-logs.md).

:::image type="content" source="media/monitor-azure-resource/logs.png" lightbox="media/monitor-azure-resource/logs.png" alt-text="Screenshot that shows the Logs menu item with a KQL query for a sample resource.":::

## Next steps

Now that you have a basic understanding of Azure Monitor, get started analyzing some metrics for an Azure resource.

> [!div class="nextstepaction"]
> [Analyze metrics for an Azure resource](./tutorial-metrics.md)
