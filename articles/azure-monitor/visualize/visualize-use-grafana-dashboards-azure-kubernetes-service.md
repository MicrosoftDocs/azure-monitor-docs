---
title: Use Dashboards with Grafana with Azure Kubernetes Service (AKS)
description: This article explains how to use Dashboards with Grafana with Azure Kubernetes Service (AKS).
ms.topic: how-to
ms.reviewer: kayodeprinceMS
ms.date: 11/03/2025
---

# Use Dashboards with Grafana with Azure Kubernetes Service (AKS)

This article explains how to use Dashboards with Grafana with Azure Kubernetes Service (AKS). For more general information, see [Dashboards with Grafana overview]() and [Use Dashboards with Grafana]().

## Prerequisites

The Kubernetes cluster must be onboarded to Azure Managed Prometheus.

### Prometheus prerequisites

To query Prometheus metrics from an Azure Monitor workspace with Azure Monitor dashboards with Grafana, you need to do the following: 

1. [Create an Azure Monitor workspace](/azure/azure-monitor/metrics/azure-monitor-workspace-overview). 
1. Ensure that the Azure Monitor workspace is collecting Prometheus metrics from an AKS cluster.
1. Enable Managed Prometheus on an existing AKS cluster (Prometheus only): 
    1. Navigate to your cluster in the Azure portal. 
    1. In the service menu, under Monitoring, select **Insights** > **Monitor Settings**. 
    1. Select the **Enable Prometheus metrics** checkbox only. *You do not need to enable Azure Managed Grafana.*
    1. Select **Advanced settings** if you want to select alternate workspaces or create new ones. 
    1. Select **Configure**. 

> [!NOTE] 
> Azure Managed Grafana is not required to view Prometheus in Azure Monitor dashboards with Grafana. See a comparison of the solutions [here](visualize-grafana-overview.md#solution-comparison). 

### Role assignment
The user must be assigned role that can perform the microsoft.monitor/accounts/read operation on the Azure Monitor workspace.

### Select a dashboard

1. Navigate to the AKS cluster you want to work with in the Azure portal.
1. Select **Dashboards with Grafana**.
1. Select a dashboard. The dashboard is populated with the Data source and the cluster.

The relevant filters for Data Source and Cluster are pre-populated based on your AKS Cluster. Apply additional filters as needed. The dashboard visuals update to reflect selections.

## Use dashboards with Azure Data Explorer (ADX)
By default, the clusters you have control plane read access to are available for use with Dashboards with Grafana. However, you can also use a cluster URL.

### Prerequisites

- Clusters already in use with Azure Data Explorer
- Control plane read access for clusters not currently in use with Azure Data Explorer. <!--For an explanation of control plane access, see Kayode to provide link to article. -->

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
- [Use Dashboards with Grafana with Azure Data Explorer](visualize-use-grafana-dashboards-azure-data-explorer.md)
- [Use Managed Grafana](visualize-use-managed-grafana-how-to.md)
