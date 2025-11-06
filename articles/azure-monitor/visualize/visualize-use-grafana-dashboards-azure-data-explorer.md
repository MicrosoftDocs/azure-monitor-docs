---
title: Use Dashboards with Grafana with Azure Data Explorer (ADX)
description: This article explains how to use Azure Monitor dashboards with Grafana with Azure Data Explorer (ADX).
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 11/03/2025
---

# Use Dashboards with Grafana with Azure Data Explorer (ADX)

This article explains how to Dashboards with Grafana with Azure Data Explorer (ADX). For more general information, see [Dashboards with Grafana overview]() and [Use Dashboards with Grafana]().

### Prerequisites

- Clusters already in use with Azure Data Explorer
- Control plane read access for clusters not currently in use with Azure Data Explorer. <!--For an explanation of control plane access, see Kayode to provide link to article. -->

By default, the clusters you have control plane read access to are available for use with Dashboards with Grafana. However, you can also use a cluster URL.

### Select the Azure Data Explorer data
1. From a dashboard screen select Azure Data Explorer from the **Data source** dropdown list. The Database and Tables lists for the ADX are populated.
1. Select a cluster from the **Cluster** dropdown list OR manually enter the URL for the cluster and selecting **Enter**.
1. Select a database from the **Database** dropdown list.
1. Select a table from the **Tables** dropdown list.
1. Use the query editor to write a KQL (Kusto) query.

## Import ADX dashboard JSON

First, save the JSON from Azure Data Explorer.

1. From the Dashboards with Grafana screen, select **Import**. The import screen appears.
1. Select **Load**.
1. Select the saved ADX JSON from your file sysem. The JSON loads.
1. Select a subscription from the **Subscription** dropdown list that has the resource provider.
1. Select the Azure Data Explorer data source.
1. Select the cluster that you have access to. If you don't see the cluster in the list, override the cluster using the URI. See [Override the data source cluster](#override-the-data-source-cluster).
1. Select **Import**.

### Override the data source cluster

You can override the data source cluster if the cluster you want to work with doesn't appear in the cluster list.

1. Select the **Override cluster URI** toggle.
1. Select *Enter Azure Data Explorer cluser URI manually* from the **Cluster URI Source** dropdown list.
1. Entering the URL of the cluster in the **Cluster URI** field.
1. Select **Import**.

## Related content

- [Azure Monitor Grafana overview](visualize-grafana-overview.md)
- [Use Dashboards with Grafana with Azure Kubernetes Service](visualize-use-grafana-dashboards-azure-kubernetes-service.md)
- [Use Managed Grafana](visualize-use-managed-grafana-how-to.md)