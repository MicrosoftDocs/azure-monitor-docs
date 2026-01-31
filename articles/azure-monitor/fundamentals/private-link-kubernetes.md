---
title: Enable private link with Container insights and Managed Prometheus
description: Learn how to enable private link on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.custom: devx-track-azurecli
ms.reviewer: aul
---

# Enable private link for Kubernetes monitoring in Azure Monitor

[Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. An [Azure Monitor Private Link Scope (AMPLS)](../fundamentals/private-link-security.md) connects a private endpoint to a set of Azure Monitor resources to define the boundaries of your monitoring network. This article describes how to connect your Kubernetes cluster to an existing Azure Monitor Private Link Scope (AMPLS).

## Prerequisites

- Configure monitoring of Prometheus metrics and container logs for your AKS cluster by following the steps in [Enable Prometheus metrics and container logging](./containers/kubernetes-monitoring-enable.md).
- Create an AMPLS and connect it to your VNet using the process described in [Configure private link for Azure Monitor](./private-link-configure.md).

## Conceptual overview
Kubernetes clusters send Prometheus metrics to an Azure Monitor workspace and logs to a Log Analytics workspace. When using private link, separate data collection endpoints (DCE) are required for clusters to retrieve configuration and to send data to the workspaces. To configure private link for Kubernetes clusters, you need to perform different steps in the following sections for the Azure Monitor workspace and Log Analytics workspace. 

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" alt-text="Diagram that shows overview of ingestion through private link.":::


## Configure Azure Monitor workspace
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


### Add Log Analytics workspace to AMPLS
Add the Log Analytics workspace to the AMPLS to enable ingestion from all clusters connected to the AMPLS.

### [Azure portal](#tab/portal)

From the **Monitor** menu in the Azure portal, select **Azure Monitor Private Link Scopes**. Select your AMPLS and then the **Azure Monitor Resources** tab. Click **Add** and select the workspace to add it to the AMPLS.

:::image type="content" source="media/kubernetes-monitoring-private-link/ampls-resources-workspace.png" lightbox="media/kubernetes-monitoring-private-link/ampls-resources-workspace.png" alt-text="Screenshot showing how to add a Log Analytics workspace to an AMPLS.":::

### [CLI](#tab/cli)

Add a Log Analytics workspace to the AMPLS using the following command:

```azurecli
az monitor private-link-scope scoped-resource create --resource-group <resource-group> --scope-name <ampls-name> --name <workspace-name> --linked-resource <workspace-resource-id>

#Example
az monitor private-link-scope scoped-resource create --resource-group my-resource-group --scope-name my-ampls --name aks-amw  --linked-resource /subscriptions/71b36fb6-
4fe4-4664-9a7b-245dc62f2930/resourceGroups/MA_aks-amw_eastus_managed/providers/Microsoft.Insights/dataCollectionEndpoints/aks-amw
```

### [PowerShell](#tab/powershell)

Add a Log Analytics workspace to the AMPLS using the following command:

```powershell
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName <resource-group> -ScopeName <ampls-name> -Name <workspace-name> -LinkedResourceId <workspace-resource-id>

# Example
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName my-resource-group -ScopeName my-ampls -Name my-workspace -LinkedResourceId /subscriptions/71b36fb6-4fe4-4664-9a7b-245dc62f2930/resourcegroups/aks/providers/microsoft.operationalinsights/workspaces/my-workspace
```

---



### Create DCEs for clusters in different regions
No DCEs are created by default for Log Analytics workspaces. Create a new DCE for each region where you have clusters following the guidance at [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview?tabs=portal#create-a-data-collection-endpoint).





## Verify metrics are ingested into Azure Monitor Workspace

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




## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
* [Query data from Azure Managed Grafana using Managed Private Endpoint](/azure/managed-grafana/how-to-connect-to-data-source-privately).
* [Use private endpoints for Managed Prometheus and Azure Monitor workspace](../metrics/azure-monitor-workspace-private-endpoint.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.
* [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)

