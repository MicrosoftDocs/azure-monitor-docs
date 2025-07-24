---
title: Query Prometheus Metrics by Using Azure Workbooks
description: Query Prometheus metrics in the portal by using Azure workbooks.
ms.topic: how-to
ms.date: 09/23/2024
---

# Query Prometheus metrics by using Azure workbooks

Create dashboards powered by Azure Monitor managed service for Prometheus by using [Azure workbooks](../visualize/workbooks-overview.md).
This article introduces workbooks for Azure Monitor workspaces and shows you how to query Prometheus metrics by using Azure workbooks and Prometheus Query Language (PromQL).

You can also query Prometheus metrics by using PromQL from the metrics explorer in an Azure Monitor workspace. For more information, see [Azure Monitor metrics explorer with PromQL (preview)](metrics-explorer.md).

## Prerequisites

To query Prometheus metrics from an Azure Monitor workspace:

* You need an Azure Monitor workspace. For more information, see [Create an Azure Monitor workspace](azure-monitor-workspace-overview.md?tabs=azure-portal.md).
* Your Azure Monitor workspace must be [collecting Prometheus metrics](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana) from an Azure Kubernetes Service (AKS) cluster or from a virtual machine or virtual machine scale set. For more information, see [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md).
* The user must be assigned a role that can perform the `microsoft.monitor/accounts/read` operation on the Azure Monitor workspace.

## Prometheus explorer workbook

Azure Monitor workspaces include an exploration workbook to query your Prometheus metrics.

1. On the **Overview** page for the Azure Monitor workspace, select **Prometheus explorer**.

   :::image type="content" source="media/prometheus-workbooks/prometheus-explorer-menu.png" lightbox="media/prometheus-workbooks/prometheus-explorer-menu.png" alt-text="Screenshot that shows Azure Monitor workspace menu selection.":::

1. On the **Workbooks** menu item, and in the Azure Monitor workspace gallery, select the **Prometheus Explorer** workbook tile.

   :::image type="content" source="media/prometheus-workbooks/prometheus-gallery.png" lightbox="media/prometheus-workbooks/prometheus-gallery.png" alt-text="Screenshot that shows the Azure Monitor workspace gallery.":::

    A workbook has the following input options:
    
    * **Time Range**: Select the period of time that you want to include in your query. Select **Custom** to set a start and end time.
    * **PromQL**: Enter the PromQL query to retrieve your data. For more information about PromQL, see [Query Prometheus](https://prometheus.io/docs/prometheus/latest/querying/basics/#querying-prometheus).
    * **Graph, Grid, Dimensions**: Use the tabs to switch between a graphic, tabular, and dimensional view of the query output.
    
    :::image type="content" source="media/prometheus-workbooks/prometheus-explorer.png" lightbox="media/prometheus-workbooks/prometheus-explorer.png" alt-text="Screenshot that shows the PromQL explorer.":::

## Create a Prometheus workbook

Workbooks support many visualizations and Azure integrations. For more information about Azure workbooks, see [Create an Azure workbook](../visualize/workbooks-create-workbook.md).

1. From your Azure Monitor workspace, select **Workbooks**.

1. Select **New**.

1. In the new workbook, select **Add**, and then select **Add query** from the dropdown list.

   :::image type="content" source="media/prometheus-workbooks/prometheus-workspace-add-query.png" lightbox="media/prometheus-workbooks/prometheus-workspace-add-query.png" alt-text="Screenshot that shows the Add dropdown list in a blank workspace.":::

1. Azure workbooks use [data sources](../visualize/workbooks-data-sources.md#prometheus) to set the source scope for the data they present. To query Prometheus metrics, select the **Data source** dropdown list and choose **Prometheus** .

1. From the **Azure Monitor workspace** dropdown list, select your workspace.

1. From the **Prometheus query type** dropdown list, select your query type.

1. Enter your PromQL query in the **Prometheus (Preview) Query** field.

1. Select **Run Query**.

1. Select **Done Editing** and save your work.

   :::image type="content" source="media/prometheus-workbooks/prometheus-query.png" lightbox="media/prometheus-workbooks/prometheus-query.png" alt-text="Screenshot that shows a sample PromQL query.":::

## Troubleshooting

If you receive the message "You currently do not have any Prometheus data ingested to this Azure Monitor workspace," then:

* Verify that you turned on metrics collection on the **Monitored clusters** pane of your Azure Monitor workspace.

If your workbook query doesn't return data and returns with the message "You do not have query access," then:

* Check that you have sufficient permissions to perform `microsoft.monitor/accounts/read` assigned through the **Access control (IAM)** option in your Azure Monitor workspace.
* Confirm if your **Networking** settings support query access. You might need to enable private access through your private endpoint or change settings to allow public access.
* Check if you have an ad blocker enabled in your browser. If you do, you might need to pause or disable and then refresh the workbook to view data.

## Frequently asked questions

This section provides answers to common questions.

[!INCLUDE [prometheus-faq-i-am-missing-some-metrics](includes/prometheus-faq-i-am-missing-some-metrics.md)]

[!INCLUDE [prometheus-faq-i-am-missing-metrics-with-same-name-different-casing](includes/prometheus-faq-i-am-missing-metrics-with-same-name-different-casing.md)]

[!INCLUDE [prometheus-faq-i-see-gaps-in-metric-data](includes/prometheus-faq-i-see-gaps-in-metric-data.md)]

## Related content

* [Collect Prometheus metrics from an AKS cluster](../containers/kubernetes-monitoring-enable.md#enable-prometheus-and-grafana)
* [Send Prometheus metrics from virtual machines, scale sets, or Kubernetes clusters to an Azure Monitor workspace](prometheus-remote-write-virtual-machines.md)
* [Azure Monitor metrics explorer with PromQL (preview)](metrics-explorer.md)
* [Azure Monitor workspace](azure-monitor-workspace-overview.md)
* [Use Azure Monitor managed service for Prometheus as a data source for Grafana by using managed system identity](prometheus-grafana.md)
