---
title: Using the Azure operations center portal (preview)
description: Provides guidance on navigating and utilizing the features of the Azure Operations Center portal for managing operations and accessing agentic workflows.
ms.topic: conceptual
ms.date: 09/24/2025
---


# Using the Azure operations center portal (preview)

Operations center provides a unified portal for managing and monitoring your Azure and hybrid environments. This article guides you through the key features and navigation of the operations center portal.

Operations center is organized into five pillars that correspond to the [pillars in Microsoft Azure Well-Architected Framework](/azure/well-architected/pillars). 


## Operations center home


## Monitor pillar

:::image type="content" source="./media/portal/monitor-pillar" lightbox="./media/portal/monitor-pillar" alt-text="Screenshot of Monitor menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Monitor | Summary of monitoring issues including top recommendation actions, summary of health and open issues, and recommended maintenance. |
| Azure service health | All features of [Azure service health](/azure/service-health/overview). The tabs across the top of this view correspond to the menu items in the Azure service health portal. |
| Alerts | View and manage [Azure Monitor alerts](/azure/azure-monitor/alerts/alerts-overview). The tabs across the top of this view correspond to the options at the top of the **Alerts** page in the Azure Monitor menu. |
| Logs | View and export [activity logs](/azure/azure-monitor/platform/activity-log). |
| Metrics | Use [Metrics explorer](/azure/azure-monitor/metrics/data-platform-metrics) to analyze and visualize metrics data. |
| Workbooks + dashboards | Create and analyze [Azure Monitor workbooks](/azure/azure-monitor/visualize/workbooks-overview) and [dashboards with Grafana](/azure/azure-monitor/visualize/visualize-grafana-overview). |
| Monitor insights | Access different [insights in Azure Monitor](/azure/azure-monitor/visualize/insights-overview). These are the same options available in the **Insights** section of the Azure Monitor menu and the same view as the **Insights hub** menu item. |
| Change analysis | View and manage [change analysis](/azure/governance/resource-graph/changes/resource-graph-changes) data. This is the same view as the **Change Analysis** item in the Azure Monitor menu. |
| Monitor settings | Configure different settings for Azure monitor including [diagnostic settings](/azure/azure-monitor/essentials/diagnostic-settings) and [data collection rules](/azure/azure-monitor/essentials/data-collection-rules).  The tabs across the top of this view correspond to the menu items in the **Settings** section of the Azure Monitor menu. |

> [!NOTE]
> No Prometheus metrics?


## Security pillar

:::image type="content" source="./media/portal/monitor-security" lightbox="./media/portal/monitor-security" alt-text="Screenshot of Security menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Overview | Summary of security issues. |
| Recommendations | Recommendations to remediate security issues and improve security posture based on based on assessments of your resources and subscriptions against security standards. This view is the same as the **Security alerts** item in the **General** section of the **Microsoft Defender for Cloud** menu. |
| Security posture | View your [secure score](/azure/defender-for-cloud/secure-score-security-controls) and explore your [security posture](/azure/defender-for-cloud/concept-cloud-security-posture-management). This view is the same as the **Recommendations** item in the **General** section of the **Microsoft Defender for Cloud** menu. |
| Security alerts | Manage and respond to [security alerts](/azure/defender-for-cloud/managing-and-responding-alerts)  This view is the same as the **Security alerts** item in the **General** section of the **Microsoft Defender for Cloud** menu. |
| Resource protections | Analyze threat detection and protection for protected resources. This view is the same as the **Workload protections** item in the **Cloud Security** section of the **Microsoft Defender for Cloud** menu. |


## Resiliency pillar

:::image type="content" source="./media/portal/monitor-resiliency" lightbox="./media/portal/monitor-resiliency" alt-text="Screenshot of Resiliency menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Resiliency | Consolidated view of information related to protection of your resources across solutions. This page is the same as the **Overview** page in the **Business Continuity Center** menu. |
| Recommendations | Azure Advisor recommendations related to resiliency. |
| Backup + recovery | Use [Azure Business Continuity Center](/azure/business-continuity-center/business-continuity-center-overview) to manage your protection estate across solutions and environments. The tabs across the top of this view correspond to menu items in the **Business Continuity Center** menu. |

## Configuration pillar

:::image type="content" source="./media/portal/monitor-configuration" lightbox="./media/portal/monitor-configuration" alt-text="Screenshot of Configuration menu in the Azure portal":::


| Menu | Description |
|:---|:---|
| Configuration | |
| Recommendations |  |
| Policy | Use [Azure Policy](/azure/governance/policy/overview) to enforce organizational standards and to assess compliance at-scale. The tabs across the top of this view correspond to menu items in the **Policy** menu. |
| Machine configuration | |
| Machine updates | Use [Azure Update Manager](/azure/update-manager/overview) to manage and govern updates for all your machines. The tabs across the top of this view correspond to menu items in the **Azure Update Manager** menu. |
| Machines changes + inventory | Use [Change tracking and inventory](/azure/automation/change-tracking/overview-monitoring-agent) to monitor changes and access detailed inventory logs for servers across your different virtual machines. The tabs across the top of this view correspond to menu items in the **Change Tracking and Inventory Center** menu. |


## Optimization pillar

:::image type="content" source="./media/portal/monitor-optimization" lightbox="./media/portal/monitor-Optimization" alt-text="Screenshot of Optimization menu in the Azure portal":::

| Menu | Description |
|:---|:---|
| Optimization |  |
| Recommendations | Azure Advisor recommendations related to cost and performance. This view is the same as the **Advisor recommendations** item in the **Cost Management** section of the **Subscription** menu. | 
| Cost + emission |  |
| Emission reports | Measure and minimize the carbon impact of your Azure footprint.  The tabs across the top of this view correspond to menu items in the **Carbon Optimization** menu. |


## Help & Support
Access documentation, FAQs, and support directly from the portal menu.
