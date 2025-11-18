---
title: Use dashboards with Grafana with Azure Data Explorer (ADX)
description: This article explains how to use Azure Monitor dashboards with Grafana with Azure Data Explorer (ADX).
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 11/03/2025
---

# Use dashboards with Grafana with Azure Data Explorer (ADX)

Azure Monitor dashboards with Grafana allow you to use and create [Grafana](https://grafana.com/) dashboards directly in the Azure portal. This article explains how to create dashboards with data from Azure Data Explorer (ADX).


### Prerequisites

- Existing Azure Data Explorer cluster
- [Database viewer role](/kusto/access-control/role-based-access-control#roles-and-permissions) or higher on the relevant ADX cluster

### Select the Azure Data Explorer data
Use the following process to add Azure Data Explorer data to a new or existing Grafana dashboard.

1. Either create a new dashboard or add a visualization to an existing dashboard.
1. Select **Azure Data Explorer** for the **Data source**. 
1. Select a cluster from the **Cluster** dropdown list OR manually enter the URL for the cluster.
1. Select a **Database** and **Table** with the data you want.
1. Use the query editor to write a KQL (Kusto) query to retrieve the data that should populate the dashboard.

:::image type="content" source="./media/grafana-azure-data-explorer/data-source.png" lightbox="./media/grafana-azure-data-explorer/data-source.png" alt-text="Screenshot of Azure Data Explorer data source.":::

## Import ADX dashboard JSON
If you have existing dashboards in Grafana that use the [Azure Data Explorer data source](https://grafana.com/grafana/plugins/grafana-azure-data-explorer-datasource/), you can use the following process to import them into Azure Monitor dashboards with Grafana.

1. Export the JSON for the dashboard from Grafana.
2. From the dashboards with Grafana screen, select **New > Import**. The import screen appears.
3. Select the option to import the JSON file and select the saved JSON.
5. Select a subscription from the **Subscription** dropdown list that has the resource provider.
6. Select **Azure Data Explorer** for the data source.
7. Select the cluster to be included in the dashboard.
8. If you don't see the cluster in the list, select the **Override cluster URI** toggle, and then select *Enter Azure Data Explorer cluster URI manually* from the **Cluster URI Source** dropdown list. Enter the URL of the cluster in the **Cluster URI** field.
9. Select **Import**.

:::image type="content" source="./media/grafana-azure-data-explorer/import.png" lightbox="./media/grafana-azure-data-explorer/import.png" alt-text="Screenshot of Azure Data Explorer import screen.":::

## Related content

- [Azure Monitor Grafana overview](visualize-grafana-overview.md)
- [Use Managed Grafana](visualize-use-managed-grafana-how-to.md)