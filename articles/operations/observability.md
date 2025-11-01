---
title: Observability in Azure Operations Center (preview)
description: Describes the Observability pillar in Azure Operations Center, which helps you monitor the health and performance of your cloud applications and resources.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Observability in Azure Operations Center (preview)

The **Observability** pillar of [Azure operations center](./overview.md) helps you monitor the health and performance of your cloud applications and resources. It consolidates multiple Azure services to assess the current health of your environment, identify issues, and provide recommendations for maintaining optimal performance and availability. I


The Observability pillar uses the following Azure services:

- [Azure Monitor](/azure/azure-monitor/)
- [Azure Service Health](/azure/service-health/overview)
- [Change analysis](/azure/governance/resource-graph/changes/view-resource-changes)


## Observability pillar
The Observability pillar includes the following menu items:

| Menu | Description |
|:---|:---|
| Monitor | Summary of monitoring issues including top recommendation actions, summary of health and open issues, and recommended maintenance. |
| Azure service health | All features of [Azure service health](/azure/service-health/overview) which reports on current and upcoming issues such as service impacting events, planned maintenance, and other changes that might affect your availability. The tabs across the top of this view correspond to the menu items in the Azure service health portal. See [Azure service health portal](/azure/service-health/service-health-portal-update) for details. |
| Service Group health | Listing of your [service groups](./overview.md#service-groups) identifying any open health alerts.  |
| Alerts | View and manage [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview). The tabs across the top of this view correspond to the options at the top of the **Alerts** page in the Azure Monitor menu. See [Manage your alert instances](/azure/azure-monitor/alerts/alerts-manage-alert-instances) for details. |
| Logs | View and export activity logs which report on create, update, delete operations for each Azure resource. See [Activity log in Azure Monitor](/azure/azure-monitor/platform/activity-log) for details. |
| Metrics | Use metrics explorer to interactively analyze metrics data collected from Azure resources. See [Azure Monitor Metrics overview](/azure/azure-monitor/metrics/data-platform-metrics) for details. |
| Workbooks + dashboards | Access a variety of visualizations for data collected by Azure Monitor using [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) and [dashboards with Grafana](/azure/azure-monitor/visualize/visualize-grafana-overview). See [Visualize data in Azure Monitor](/azure/azure-monitor/visualize/best-practices-visualize) for details. |
| Monitor insights | Access insights which provide curated views and specialized analysis for different types of Azure resources. These are the same options available in the **Insights** section of the Azure Monitor menu and the same view as the **Insights hub** menu item. See [Azure Monitor Insights overview](/azure/azure-monitor/visualize/insights-overview) for details. |
| Change analysis | View and manage [change analysis](/azure/governance/resource-graph/changes/resource-graph-changes) data which can be useful when determining if a configuration change is responsible for a particular issue or a change in your performance patterns. This is the same view as the **Change Analysis** item in the Azure Monitor menu. See [View resource changes in the Azure portal (preview)](/azure/governance/resource-graph/changes/view-resource-changes) for details. |
| Monitor settings | Configure different settings for Azure monitor including [diagnostic settings](/azure/azure-monitor/platform/diagnostic-settings) and [data collection rules](/azure/azure-monitor/data-collection/data-collection-rule-overview).  The tabs across the top of this view correspond to the menu items in the **Settings** section of the Azure Monitor menu. |
| Recommendations | [Azure Advisor](/azure/advisor/advisor-overview) recommendations related to monitoring and change management. Accept these recommendations to collect additional data and improve Azure Monitor's ability to assess the health and performance of your environment. |

## Monitor overview
The **Monitor** page provides a consolidated view of the key information from the other pages in the Observability pillar. It leverages the Observability agent to surface important information and identify top actions that you can take to improve the monitoring and health of your Azure resources. Start here to identify any critical issues or other matters that require your attention before drilling down into specific areas.

:::image type="content" source="./media/portal/Observability-pillar.png" lightbox="./media/portal/Observability-pillar.png" alt-text="Screenshot of Monitor menu in the Azure portal":::


| Section | Description |
|:---|:---|
| Top actions | Combination of recommended actions based on Azure Advisor recommendations and suggested actions from the Observability agent. Click on any of these actions to open the relevant page in the Observability pillar or to open the Observability agent for guided assistance. |
| Health and Issues Summary | Identifies any recent service incidents from **Azure service health** and a summary of [issues](/azure/azure-monitor/aiops/aiops-issue-and-investigation-overview) created over the previous 24 hours.  |
| Recommendations and maintenance | Summary of open Azure Advisor recommendations separated by relative impact and any upcoming planned maintenance events from **Azure service health**. |



