---
title: Monitor Prometheus metrics ingestion
description: How to monitor Prometheus metrics ingestion and set up an alert on Azure Monitor Workspace ingestion limits
author: EdB-MSFT
ms.service: azure-monitor
ms-author: edbaynash
ms.topic: conceptual
ms.date: 10/06/2024
---

# Monitor Prometheus metrics ingestion

Prometheus metrics are ingested into an Azure Monitor workspace. Azure monitor workspaces have default limits and quotas for ingestion. When you reach the ingestion limits throttling can occur. In order to avoid throttling, you can monitor and set up an alert on Azure Monitor Workspace ingestion limits. 

For more information on Prometheus and Azure Monitor workspace limits and quotas, see [Azure Monitor service limits](../service-limits.md#prometheus-metrics).

## Query the Azure Monitor workspace metrics to monitor the ingestion limits

To query an Azure Monitor workspace metrics to monitor the ingestion limits use the following steps:

1. In the Azure portal, navigate to your Azure Monitor workspace and select **Metrics** under the **Monitoring** section.
1. Select the Azure Monitor workspace as scope.
1. In the **Metric** dropdown, select **View standard metrics with the builder**.
1. In the **Metric** drop-down, select **Active Time Series % Utilization** and **Events Per Minute Ingested % Utilization** and verify that they are below 100%.

    :::image type="content" source="./media/prometheus-monitor-ingest-limits/monitor-ingest-limits.png" alt-text="Screenshot that shows how to create an alert rule for Azure Monitor Workspace ingestion limits." lightbox="./media/prometheus-monitor-ingest-limits/monitor-injest-limits.png":::

1. Set an Azure Alert to monitor the utilization and fire an alert when the utilization is greater than a certain threshold. Select **New alert rule** to create an Azure alert. For more information, see [Create an alert rule in Azure Monitor](../alerts-log-based-metrics.md#create-an-alert-rule).`


    :::image type="content" source="./media/prometheus-monitor-ingest-limits/alert-azure-monitor-workspace.png" alt-text="Screenshot that shows how to create an alert for Azure Monitor Workspace limits." lightbox="media/azure-monitor-workspace-overview/alert-azure-monitor-workspace.png":::

If the alert is fired i.e. the ingestion utilization is more than the threshold, you can request an increase in these limits by creating a support ticket.

1. In the Azure portal, navigate to your Azure Monitor Workspace, click on **Support + Troubleshooting**.
2. Type the issue, e.g., "Service and subscription limits (quotas)", then select **Service and subscription limits (quotas)** and select **Next**.

:::image type="content" source="media/azure-monitor-workspace-overview/azure-monitor-workspace-support-ticket.png" alt-text="Screenshot that shows how to create a support ticket for limit increase." lightbox="media/azure-monitor-workspace-overview/azure-monitor-workspace-support-ticket.png":::

3. In the next screen, select your subscription and then select **Managed Prometheus** as the **Quota type**.
4. Provide additional details to create the support ticket.