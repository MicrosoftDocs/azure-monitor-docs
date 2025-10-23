---
title: Observability in Azure Operations Center (preview)
description: Provides guidance on navigating and utilizing the features of the Azure Operations Center portal for managing operations and accessing agentic workflows.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Observability in Azure Operations Center (preview)

The **Observability** pillar of [Azure operations center](./overview.md) helps you monitor the health and performance of your cloud applications and resources. It consolidates data gathered from different Azure services to help you gain insights, detect issues, and optimize your operations.

The Observability pillar uses the following Azure services:

- [Azure Monitor](/azure/azure-monitor/)
- [Azure Service Health](/azure/service-health/overview)
- [Change analysis](/azure/governance/resource-graph/changes/view-resource-changes)


## Observability pillar
The Observability pillar includes the following menu items:

| Menu | Description |
|:---|:---|
| Monitor | Summary of monitoring issues including top recommendation actions, summary of health and open issues, and recommended maintenance. |
| Azure service health | All features of [Azure service health](/azure/service-health/overview) which reports on current and upcoming issues such as service impacting events, planned maintenance, and other changes that might affect your availability. The tabs across the top of this view correspond to the menu items in the Azure service health portal.<br><br>See [Azure service health portal](/azure/service-health/service-health-portal-update) for details. |
| Service Group health | Listing of your [service groups](./overview.md#service-groups) identifying any open health alerts.  |
| Alerts | View and manage [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview). The tabs across the top of this view correspond to the options at the top of the **Alerts** page in the Azure Monitor menu.<br><br>See [Manage your alert instances](/azure/azure-monitor/alerts/alerts-manage-alert-instances) for details. |
| Logs | View and export activity logs which report on create, update, delete operations for each Azure resource.<br><br>See [Activity log in Azure Monitor](/azure/azure-monitor/platform/activity-log) for details. |
| Metrics | Use [Metrics explorer](/azure/azure-monitor/metrics/data-platform-metrics) to analyze and visualize metrics data.<br><br>See [Activity log in Azure Monitor] |
| Workbooks + dashboards | Create and analyze [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) and [dashboards with Grafana](/azure/azure-monitor/visualize/visualize-grafana-overview). |
| Monitor insights | Access different [insights in Azure Monitor](/azure/azure-monitor/visualize/insights-overview). These are the same options available in the **Insights** section of the Azure Monitor menu and the same view as the **Insights hub** menu item. |
| Change analysis | View and manage [change analysis](/azure/governance/resource-graph/changes/resource-graph-changes) data. This is the same view as the **Change Analysis** item in the Azure Monitor menu. |
| Monitor settings | Configure different settings for Azure monitor including [diagnostic settings](/azure/azure-monitor/platform/diagnostic-settings) and [data collection rules](/azure/azure-monitor/data-collection/data-collection-rules).  The tabs across the top of this view correspond to the menu items in the **Settings** section of the Azure Monitor menu. |
| Recommendations |  |

## Monitor overview
The **Monitor** page provides a consolidated view of the key information from the other pages in the Observability pillar. Start here to identify any critical issues or other matters that require your attention before drilling down into specific areas.

 such as the number of open alerts, service health issues, and recent changes that may impact your resources. The page also highlights recommended actions to address any identified issues.



:::image type="content" source="./media/portal/monitor-pillar.png" lightbox="./media/portal/monitor-pillar.png" alt-text="Screenshot of Monitor menu in the Azure portal":::



## Observability agent

