---
title: Enable private link with Container insights and Managed Prometheus
description: Learn how to enable private link on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.custom: devx-track-azurecli
ms.reviewer: aul
---

# Enable private link for Kubernetes monitoring in Azure Monitor

[Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. An [Azure Monitor Private Link Scope (AMPLS)](../logs/private-link-security.md) connects a private endpoint to a set of Azure Monitor resources to define the boundaries of your monitoring network. This article describes how to connect your Kubernetes cluster to an existing Azure Monitor Private Link Scope (AMPLS).

## Prerequisites

- Configure monitoring of Prometheus metrics and container logs for your AKS cluster by following the steps in [Enable Prometheus metrics and container logging](./kubernetes-monitoring-enable.md).
- Create an AMPLS and connect it to your VNet using the process described in [Configure private link for Azure Monitor](./private-link-configure.md).

## Conceptual overview
Kubernetes clusters send Prometheus metrics to an Azure Monitor workspace and logs to a Log Analytics workspace. When using private link, separate data collection endpoints (DCE) are required for clusters to retrieve configuration and to send data to the workspaces. To configure private link for Kubernetes clusters, you need to perform different steps in the following sections for the Azure Monitor workspace and Log Analytics workspace. 

## Azure Monitor workspace for Prometheus metrics
Instead of adding the Azure Monitor workspace directly to the AMPLS, Data Collection Endpoints (DCEs) are added to the AMPLS that are able to access the workspace. A DCE is created automatically for each Azure Monitor workspace and can be used for any clusters in the same region as the workspace. For any clusters in a different region, create a new DCE in the same region as the cluster as described below.

**Configuration**<br>
- DCE automatically created for each Azure Monitor workspace. Use for all clusters in the same region as the workspace.
- Create a new DCE for each region where clusters are located.
- Associate each cluster with the DCE in the same region.
- Add the DCE to the AMPLS.

 **Ingestion**<br>
- DCE created automatically for each cluster when enabling Prometheus metrics.
- Add the DCE to the AMPLS.


### Create configuration DCEs for clusters in different regions
A DCE is automatically created for each Azure Monitor workspace with the same name as the workspace. This DCE can be used for any clusters in the same region as the workspace to retrieve their configuration. If you have clusters in regions different from your workspace, then you need to create new DCEs for those regions. Follow the guidance at [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview?tabs=portal#create-a-data-collection-endpoint) to create a new DCE in each region where you have clusters.

### Associate cluster with configuration DCE
Create an association between each cluster and the configuration DCE in its region.

### [Azure portal](#tab/portal)

Identify the DCE created by the Azure Monitor workspace from its **Overview** page in the Azure portal.

:::image type="content" source="media/kubernetes-monitoring-private-link/amw-dce.png" lightbox="media/kubernetes-monitoring-private-link/amw-dce.png" alt-text="Screenshot showing the DCE for an Azure Monitor workspace.":::

From the **Monitor** menu in the Azure portal, select **Data Collection Endpoints**. Select the DCE and then 
the **Resources** tab. Click **Add** and select the cluster to create the association.

:::image type="content" source="media/kubernetes-monitoring-private-link/dce-resources.png" lightbox="media/kubernetes-monitoring-private-link/dce-resources.png" alt-text="Screenshot showing the Resources for a DCE.":::


### [CLI](#tab/cli)

Create association between the cluster and the DCE using the following command:

```azurecli
az monitor data-collection rule association create --association-name configurationAccessEndpoint --data-collection-endpoint-id <dce-resource-id> --resource-uri <cluster-resource-id>

#Example
az monitor data-collection rule association create --association-name configurationAccessEndpoint --data-collection-endpoint-id /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce --resource-uri /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/aks/providers/Microsoft.ContainerService/managedClusters/aks06
```

### [PowerShell](#tab/powershell)

Create association between the cluster and the DCE using the following command:

```powershell
New-AzDataCollectionRuleAssociation -associationname configurationAccessEndpoint -DataCollectionEndpointId <dce-resource-id> -resourceuri <cluster-resource-id>  

# Example
New-AzDataCollectionRuleAssociation   -resourceuri /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/vm/providers/Microsoft.Compute/virtualMachines/win03 -associationname configurationAccessEndpoint -DataCollectionEndpointId /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/bwlab/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce
```

---


### Add DCEs to AMPLS
The following DCEs need to be added to the AMPLS:

- DCE created by the Azure Monitor workspace
- DCEs that you created for clusters in different regions

### [Azure portal](#tab/portal)

From the **Monitor** menu in the Azure portal, select **Azure Monitor Private Link Scopes**. Select your AMPLS and then the **Azure Monitor Resources** tab. Click **Add** and select the DCE to add it to the AMPLS.

:::image type="content" source="media/kubernetes-monitoring-private-link/ampls-resources-dce.png" lightbox="media/kubernetes-monitoring-private-link/ampls-resources-dce.png" alt-text="Screenshot showing how to add a DCE to an AMPLS.":::

### [CLI](#tab/cli)

Add a DCE to the AMPLS using the following command:

```azurecli
az monitor private-link-scope scoped-resource create --resource-group <resource-group> --scope-name <ampls-name> --name <dce-name> --linked-resource <dce-resource-id>

#Example
az monitor private-link-scope scoped-resource create --resource-group my-resource-group --scope-name my-ampls --name aks-amw  --linked-resource /subscriptions/71b36fb6-
4fe4-4664-9a7b-245dc62f2930/resourceGroups/MA_aks-amw_eastus_managed/providers/Microsoft.Insights/dataCollectionEndpoints/aks-amw
```

### [PowerShell](#tab/powershell)

Add a DCE to the AMPLS using the following command:

```powershell
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName <resource-group> -ScopeName <ampls-name> -Name <dce-name> -LinkedResourceId <dce-resource-id>

# Example
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName my-resource-group -ScopeName my-ampls -Name aks-amw-LinkedResourceId /subscriptions/71b36fb6-
4fe4-4664-9a7b-245dc62f2930/resourceGroups/MA_aks-amw_eastus_managed/providers/Microsoft.Insights/dataCollectionEndpoints/aks-amw
```

---


### Create private endpoint for queries
The final step for enabling private link for Prometheus metrics is to create a private endpoint to support queries to the Azure Monitor workspace. [Connect AMPLS to a private endpoint](./private-link-configure.md#connect-ampls-to-a-private-endpoint) describes how to create a private endpoint to support data ingestion. And additional private endpoint is required to support queries to the workspace.

### [Azure portal](#tab/portal)

Follow the guidance in [Connect AMPLS to a private endpoint](./private-link-configure.md#connect-ampls-to-a-private-endpoint) to create a new private endpoint. One the **Resources** tab select the following settings:

- **Resource type**: `Microsoft.Monitor/accounts`
- **Resource**: Your Azure Monitor workspace
- **Target sub-resource**: `prometheusMetrics`

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-private-endpoint-config.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-private-endpoint-config.png" alt-text="A screenshot show the private endpoint config":::

### [CLI](#tab/cli)

Create the query private link endpoint using the following command:

```azurecli
az network private-endpoint create --resource-group <resource-group>  --name <private-endpoint-name> --location <region> --subnet <subnet-id>     -
-private-connection-resource-id <workspade-resource-id> --group-ids prometheusMetrics --connection-name <connection-name>

# Example
az network private-endpoint create --resource-group my-resource-group --name AzMon-QueryPrivateEndpoint  --location eastus  --subnet /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/vm/providers/Microsoft.Network/virtualNetworks/vnet-eastus/subnets/snet-eastus-1  --private-connection-resource-id "/subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourceGroups/aks/providers/microsoft.monitor/accounts/aks-amw"  --group-ids prometheusMetrics  --connection-name AzMon-QueryPrivateEndpoint-conn
```



### [PowerShell](#tab/powershell)

Create the query private link endpoint using the following command:

```powershell
```
---


## Log Analytics workspace for log collection


**Configuration**<br>
- Create a new DCE for each region where clusters are located.
- Associate each cluster with the DCE in the same region.

 **Ingestion**<br>
- Add the Log Analytics workspace to the AMPLS.
- DCE not required.



- The ingestion DCE for the Azure Monitor workspace needs to be added to the AMPLS, while each Log Analytics workspace is added directly to the AMPLS. 

Clusters can only connect to a DCE in the same region. If you have clusters in regions different from your workspaces, then you need to create new DCEs for those regions. A DCE is automatically created for each Azure Monitor workspace. You can use this DCE for any clusters in the same region as the workspace for connections to both Azure Monitor workspace and Log Analytics workspace. If you're only enabling private link for logs collection, then you need to create a new DCE in each region where you have clusters.

### Create DCEs for clusters in different regions
If you're enabling Prometheus metrics and only connecting clusters in the same region as the Azure Monitor workspace, you don't need to create any DCEs. If you have clusters in other regions, create a new DCE in each region. If you have existing DCEs in those regions you can also use them for your Azure Monitor workspace without creating a new one.

If you aren't enabling Prometheus metrics but enabling log collection, create a new DCE in each region where you have clusters. If you have existing DCEs in those regions you can also use them for your Azure Monitor workspace without creating a new one.


### Create configuration DCEs for clusters in different regions
A DCE is automatically created for each Azure Monitor workspace with the same name as the workspace. This DCE can be used for any clusters in the same region as the workspace to retrieve their configuration. If you have clusters in regions different from your workspace, then you need to create new DCEs for those regions. Follow the guidance at [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview?tabs=portal#create-a-data-collection-endpoint) to create a new DCE in each region where you have clusters.







## Log Analytics workspace for Container insights logs
While a DCE is required for each cluster to connect to the Log Analytics workspace over private link, the Log Analytics workspace itself is added directly to the AMPLS. No DCE is created automatically, but you can use the same DCEs that created for the Azure Monitor workspace if both metrics and log collections is being enabled.







## Prometheus metrics ingestion over private link

Follow the steps below to set up ingestion of Prometheus metrics from private AKS cluster into Azure Monitor Workspace.

### Conceptual overview

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" alt-text="Diagram that shows overview of ingestion through private link.":::

To set up ingestion of Managed Prometheus metrics from virtual network using private endpoints into Azure Monitor Workspace, follow these high-level steps:

* Create an Azure Monitor Private Link Scope (AMPLS) and connect it with the Data Collection Endpoint of the Azure Monitor Workspace.
* Connect the AMPLS to a private endpoint that is set up for the virtual network of your private AKS cluster.

### 2. Connect the AMPLS to the Data Collection Endpoint of Azure Monitor Workspace

Private links for data ingestion for Managed Prometheus are configured on the Data Collection Endpoints (DCE) of the Azure Monitor workspace that stores the data. To identify the DCEs associated with your Azure Monitor workspace, select Data Collection Endpoints from your Azure Monitor workspace in the Azure portal.

1. In the Azure portal, search for the Azure Monitor Workspace that you created as part of enabling Managed Prometheus for your private AKS cluster. Note the Data Collection Endpoint name.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dce.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dce.png" alt-text="A screenshot showing the data collection endpoints page for an Azure Monitor workspace.":::

1. Now, in the Azure portal, search for the AMPLS that you created in the previous step. Go to the AMPLS overview page, click on **Azure Monitor Resources**, click **Add**, and then connect the DCE of the Azure Monitor Workspace that you noted in the previous step.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls-dce.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls-dce.png" alt-text="Screenshot showing connection of DCE to the AMPLS.":::











## Verify if metrics are ingested into Azure Monitor Workspace

Verify if Prometheus metrics from your private AKS cluster are ingested into Azure Monitor Workspace:

1. In the Azure portal, search for the Azure Monitor Workspace, and go to **Monitoring** -> **Metrics**.
1. In the Metrics Explorer, query for metrics and verify that you're able to query.

> [!NOTE]
> * See [Connect to a data source privately](/azure/managed-grafana/how-to-connect-to-data-source-privately) for details on how to configure private link to query data from your Azure Monitor workspace using Grafana.
> * See [Use private endpoints for Managed Prometheus and Azure Monitor workspace](../metrics/azure-monitor-workspace-private-endpoint.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.

### Ingestion from a private AKS cluster

If you choose to use an Azure Firewall to limit the egress from your cluster, you can implement one of the following:

* Open a path to the public ingestion endpoint. Update the routing table with the following two endpoints:
    * `*.handler.control.monitor.azure.com`
    * `*.ingest.monitor.azure.com`
* Enable the Azure Firewall to access the Azure Monitor Private Link scope and DCE that's used for data ingestion.

### Private link ingestion for remote write

Use the following steps to set up remote write for a Kubernetes cluster over a private link virtual network and an Azure Monitor Private Link scope.

1. Create your Azure virtual network.
1. Configure the on-premises cluster to connect to an Azure VNET using a VPN gateway or ExpressRoutes with private-peering.
1. Create an Azure Monitor Private Link scope.
1. Connect the Azure Monitor Private Link scope to a private endpoint in the virtual network used by the on-premises cluster. This private endpoint is used to access your DCEs.
1. From your Azure Monitor workspace in the portal, select **Data Collection Endpoints** from the Azure Monitor workspace menu.
1. You have at least one DCE which has the same name as your workspace. Click on the DCE to open its details.
1. Select the **Network Isolation** page for the DCE. 
1. Click **Add** and select your Azure Monitor Private Link scope. It takes a few minutes for the settings to propagate. Once completed, data from your private AKS cluster is ingested into your Azure Monitor workspace over the private link.

## Container insights (Log Analytics workspace)

Data for Container insights, is stored in a [Log Analytics workspace](../logs/log-analytics-workspace-overview.md), so you must make this workspace accessible over a private link.

> [!NOTE]
> This section describes how to enable private link for Container insights using CLI. For details on using an ARM template, see [Enable Prometheus metrics and container logging](./kubernetes-monitoring-enable.md?tabs=arm#enable-prometheus-metrics-and-container-logging) and note the parameters `useAzureMonitorPrivateLinkScope` and `azureMonitorPrivateLinkScopeResourceId`.

### Prerequisites

* This article describes how to connect your cluster to an existing Azure Monitor Private Link Scope (AMPLS). Create an AMPLS following the guidance in [Configure your private link](../logs/private-link-configure.md).
* Azure CLI version 2.61.0 or higher.

### Cluster using managed identity authentication

**Existing AKS cluster with default Log Analytics workspace**

```azurecli
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --ampls-resource-id "<azure-monitor-private-link-scope-resource-id>"
```

Example:

```azurecli
az aks enable-addons --addon monitoring --name "my-cluster" --resource-group "my-resource-group" --workspace-resource-id "/subscriptions/my-subscription/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace" --ampls-resource-id "/subscriptions/my-subscription /resourceGroups/my-resource-group/providers/microsoft.insights/privatelinkscopes/my-ampls-resource"
```

**Existing AKS cluster with existing Log Analytics workspace**

```azurecli
az aks enable-addons --addon monitoring --name <cluster-name> --resource-group <cluster-resource-group-name> --workspace-resource-id <workspace-resource-id> --ampls-resource-id "<azure-monitor-private-link-scope-resource-id>"
```

Example:

```azurecli
az aks enable-addons --addon monitoring --name "my-cluster" --resource-group "my-resource-group" --workspace-resource-id "/subscriptions/my-subscription/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace" --ampls-resource-id "/subscriptions/my-subscription /resourceGroups/ my-resource-group/providers/microsoft.insights/privatelinkscopes/my-ampls-resource"
```

**New AKS cluster**

```azurecli
az aks create --resource-group rgName --name clusterName --enable-addons monitoring --workspace-resource-id "workspaceResourceId" --ampls-resource-id "azure-monitor-private-link-scope-resource-id"
```

Example:

```azurecli
az aks create --resource-group "my-resource-group" --name "my-cluster" --enable-addons monitoring --workspace-resource-id "/subscriptions/my-subscription/resourceGroups/my-resource-group/providers/Microsoft.OperationalInsights/workspaces/my-workspace" --ampls-resource-id "/subscriptions/my-subscription /resourceGroups/ my-resource-group/providers/microsoft.insights/privatelinkscopes/my-ampls-resource"
```



## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
* [Query data from Azure Managed Grafana using Managed Private Endpoint](/azure/managed-grafana/how-to-connect-to-data-source-privately).
* [Use private endpoints for Managed Prometheus and Azure Monitor workspace](../metrics/azure-monitor-workspace-private-endpoint.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.
* [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)

