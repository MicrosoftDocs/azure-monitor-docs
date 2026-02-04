---
title: Observability in operations center (preview)
description: Describes the Observability menu in operations center, which helps you monitor the health and performance of your cloud applications and resources.
ms.topic: concept-article
ms.date: 11/14/2025
---


# Observability in operations center (preview)

[!INCLUDE [Preview-register](./includes/preview-register.md)]

The **Observability** menu of [operations center](./overview.md) helps you monitor the health and performance of your cloud applications and resources. It consolidates multiple Azure services to assess the current health of your environment, identify issues, and provide recommendations for maintaining optimal performance and availability.


The Observability menu uses the following Azure services:

- [Azure Monitor](/azure/azure-monitor/)
- [Azure Service Health](/azure/service-health/overview)
- [Change analysis](/azure/governance/resource-graph/changes/view-resource-changes)
- [Azure Advisor](/azure/advisor/advisor-overview)

## Observability menu
The Observability menu includes the following menu items:

| Menu | Description |
|:---|:---|
| Monitor | Summary of monitoring issues including top recommendation actions, summary of health and open issues, and recommended maintenance. See [Monitor overview](#monitor-overview) for details. |
| Azure service health | All features of [Azure service health](/azure/service-health/overview) which reports on current and upcoming issues such as service impacting events, planned maintenance, and other changes that might affect your availability. The tabs across the top of this view correspond to the menu items in the Azure service health portal. See [Azure service health portal](/azure/service-health/service-health-portal-update) for details. |
| Service Group health | Listing of your [service groups](/azure/governance/service-groups/overview) identifying any open health alerts. Select a service group to open its **Monitoring** page.  |
| Alerts | View and manage [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview). The tabs across the top of this view correspond to the options at the top of the **Alerts** page in the Azure Monitor menu. See [Manage your alert instances](/azure/azure-monitor/alerts/alerts-manage-alert-instances) for details. |
| Logs | **Logs** tab with access to Log Analytics, which allows you to use [log queries](/azure/azure-monitor/logs/log-query-overview) to analyze data collected in a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview). Select the menu on the **New Query** tab to change the [scope of the query](/azure/azure-monitor/logs/scope). See [Overview of Log Analytics in Azure Monitor](/azure/azure-monitor/logs/log-analytics-overview) for details.<br><br>**Activity Logs** tab that allows you to view and export activity logs which report on create, update, delete operations for each Azure resource. See [Activity log in Azure Monitor](/azure/azure-monitor/platform/activity-log) for details. |
| Metrics | Use metrics explorer to interactively analyze metrics data collected from Azure resources. See [Azure Monitor Metrics overview](/azure/azure-monitor/metrics/data-platform-metrics) for details. |
| Workbooks + dashboards | Access a variety of visualizations for data collected by Azure Monitor using [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) and [dashboards with Grafana](/azure/azure-monitor/visualize/visualize-grafana-overview). See [Visualize data in Azure Monitor](/azure/azure-monitor/visualize/best-practices-visualize) for details. |
| Monitor insights | Access insights which provide curated views and specialized analysis for different types of Azure resources. These are the same options available in the **Insights** section of the Azure Monitor menu and the same view as the **Insights hub** menu item. See [Azure Monitor Insights overview](/azure/azure-monitor/visualize/insights-overview) for details. |
| Change analysis | View and manage [change analysis](/azure/governance/resource-graph/changes/resource-graph-changes) data which can be useful when determining if a configuration change is responsible for a particular issue or a change in your performance patterns. This is the same view as the **Change Analysis** item in the Azure Monitor menu. See [View resource changes in the Azure portal (preview)](/azure/governance/resource-graph/changes/view-resource-changes) for details. |
| Monitor settings | Configure different settings for Azure monitor including [diagnostic settings](/azure/azure-monitor/platform/diagnostic-settings) and [data collection rules](/azure/azure-monitor/data-collection/data-collection-rule-overview).  The tabs across the top of this view correspond to the menu items in the **Settings** section of the Azure Monitor menu. |
| Recommendations | [Azure Advisor](/azure/advisor/advisor-overview) recommendations related to monitoring and change management. Accept these recommendations to collect additional data and improve Azure Monitor's ability to assess the health and performance of your environment. |
| Recommendations | Azure Advisor recommendations related to observability. This page is the same as the **Advisor recommendations** item in the **Support + Troubleshooting** section of the **Monitor** menu. See [Optimize costs from recommendations](/azure/cost-management-billing/costs/tutorial-acm-opt-recommendations) for details. | 


## Monitor overview
The **Monitor** overview page provides a consolidated view of the key information from the other pages in the Observability menu. It surfaces important information and identify top actions that you can take to improve the monitoring and health of your Azure resources. Start here to identify any critical issues or other matters that require your attention before drilling down into specific areas.

:::image type="content" source="./media/observability/observability-menu.png" lightbox="./media/observability/observability-menu.png" alt-text="Screenshot of Monitor menu in the Azure portal":::


| Section | Description |
|:---|:---|
| Top actions | Top recommended actions based on Azure Advisor recommendations to ensure that your resources are being appropriately monitored. Click on any of these actions to open the relevant page in the Observability menu. |
| Health and Issues Summary | Identifies any recent service incidents from **Azure service health** and a summary of [issues](/azure/azure-monitor/aiops/aiops-issue-and-investigation-overview) created over the previous 24 hours.  |
| Recommendations and maintenance | Summary of open Azure Advisor recommendations separated by relative impact and any upcoming planned maintenance events from **Azure service health**. |

## Next steps
- Learn more about [operations center](./overview.md)