---
title: Monitor Azure Monitor workspace metrics ingestion
description: How to monitor Azure Monitor workspace metrics ingestion and set up an alert on Azure Monitor Workspace ingestion limits
ms.topic: conceptual
ms.date: 10/06/2024
---

# Monitor Azure Monitor workspace metrics ingestion

Prometheus metrics are ingested into an Azure Monitor workspace. Azure monitor workspaces have default limits and quotas for ingestion. When you reach the ingestion limits, throttling can occur. In order to avoid throttling, you can monitor and alert on the workspace ingestion limits. 

For more information on Prometheus and Azure Monitor workspace limits and quotas, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics).

## Query and alert on workspace ingestion metrics

To query Azure Monitor workspace metrics to monitor the ingestion limits, use the following steps:

1. In the Azure portal, navigate to your Azure Monitor workspace and select **Metrics** under the **Monitoring** section.
1. In the **Add metric** dropdown, select **Add with builder**.
1. Select the Azure Monitor workspace as scope.
1. Select **Standard metrics** for the **Metric Namespace**.
1. In the **Metric** drop-down, select **Active Time Series % Utilization** and **Events Per Minute Received % Utilization** and verify that they are below 100%.

    :::image type="content" source="./media/azure-monitor-workspace-monitor-ingest-limits/monitor-ingest-limits.png" alt-text="Screenshot that shows a metrics chart for Azure Monitor workspace metrics." lightbox="./media/azure-monitor-workspace-monitor-ingest-limits/monitor-ingest-limits.png":::

1. Select **New alert rule** to create an Azure alert. Set an Azure Alert to monitor the utilization and fire an alert when the utilization is greater than a certain threshold. For more information, see [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md).


    :::image type="content" source="./media/azure-monitor-workspace-monitor-ingest-limits/create-alert.png" alt-text="Screenshot that shows how to create an alert for Azure Monitor Workspace limits." lightbox="./media/azure-monitor-workspace-monitor-ingest-limits/create-alert.png":::

See your alerts in the Azure portal by selecting **Alerts** under the **Monitoring** section of your Azure Monitor workspace.

The alert is fired if the ingestion utilization is more than the threshold. Request an increase in the limit by creating a support ticket.

To open a support ticket:
1. Select **Support + Troubleshooting** from the left pane of the Azure portal. 
1. Enter *Service and subscription limits (quotas)* in the search field and select **Go**.
1. Select **Service and subscription limits (quotas)**, select **Next**, then select **Create a new support request**.
1. Select your subscription and then select **Managed Prometheus** as the **Quota type**.
1. Complete the requested details and submit the request.

## Next steps

+ [Azure Monitor service limits](../service-limits.md#prometheus-metrics)
+ [Create an alert rule in Azure Monitor](../alerts/alerts-create-metric-alert-rule.md)
+ [Create a metric alert for an Azure resource](../alerts/tutorial-metric-alert.md)