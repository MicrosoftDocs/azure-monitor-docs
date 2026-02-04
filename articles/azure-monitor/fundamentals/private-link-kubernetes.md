---
title: Enable private link for Kubernetes monitoring in Azure Monitor
description: Learn how to enable private link on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.custom: devx-track-azurecli
ms.reviewer: aul
---

# Enable private link for Kubernetes monitoring in Azure Monitor

[Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. An [Azure Monitor Private Link Scope (AMPLS)](../fundamentals/private-link-security.md) connects a private endpoint to a set of Azure Monitor resources to define the boundaries of your monitoring network. This article describes how to connect your Kubernetes cluster to an existing Azure Monitor Private Link Scope (AMPLS).

## Prerequisites

- Configure monitoring of Prometheus metrics and container logs for your AKS cluster by following the steps in [Enable Prometheus metrics and container logging](../containers/kubernetes-monitoring-enable.md).
- Create an AMPLS and connect it to your VNet using the process described in [Configure private link for Azure Monitor](./private-link-configure.md).
- Create a private endpoint to support querying data from your Azure Monitor workspace by following the steps in [Enable query from Azure Monitor workspace using private link](./private-link-azure-monitor-workspace.md).

## Conceptual overview
Kubernetes clusters send Prometheus metrics to an Azure Monitor workspace and logs to a Log Analytics workspace. When using private link, separate data collection endpoints (DCE) are required for clusters to retrieve configuration from the workspaces and to send data. 

Full configuration of private link for monitoring of your Kubernetes clusters requires configuration of existing DCEs and creation of new DCEs to support clusters in different regions. The sections below detail the steps required to configure private link for both the Azure Monitor workspace and the Log Analytics workspace.


## Configure Azure Monitor workspace
Instead of adding the Azure Monitor workspace directly to the AMPLS, Data Collection Endpoints (DCEs) are added to the AMPLS that are able to access the workspace. Two separate DCEs are required to support configuration retrieval and data ingestion.

**Configuration DCE**<br>
- A DCE is automatically created for each Azure Monitor workspace. Use this DCE for all clusters in the same region as the workspace.
- Create a new DCE for each region where clusters are located.
- Associate each cluster with the DCE in the same region.
- Add the DCE for each region to the AMPLS.

 **Ingestion DCE**<br>
- A DCE is created automatically for each cluster when enable Prometheus metrics.
- Add the DCE for each cluster to the AMPLS.


### Create configuration DCEs for clusters in different regions
A DCE is automatically created for each Azure Monitor workspace with the same name as the workspace. This DCE can be used for any clusters in the same region as the workspace to retrieve their configuration. If you have clusters in regions different from your workspace, then you need to create a new DCE for each region. Follow the guidance at [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview.md?tabs=portal#create-a-data-collection-endpoint) to create a new DCE in each region where you have clusters.

### Associate cluster with configuration DCE
For the cluster to use the DCE in its region to retrieve configuration, you need to create an association between the cluster and the DCE.

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
Each of the DCEs created for configuration access need to be added to the AMPLS. This includes the DCE created by the Azure Monitor workspace and any new DCEs created for clusters in different regions. 

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



## Configure Log Analytics workspace
Clusters only require a DCE to retrieve configuration from the Log Analytics workspace. The workspace itself is added to the AMPLS to support data ingestion. No DCEs are created by default for Log Analytics workspaces, so you need to create a new DCE for each region where clusters are located. These DCEs are then associated with the clusters in the same region and added to the AMPLS.


### Add Log Analytics workspace to AMPLS
Add the Log Analytics workspace to the AMPLS to enable ingestion from all clusters.

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


### Associate cluster with configuration DCE
For the cluster to use the DCE in its region to retrieve configuration, you need to create an association between the cluster and the DCE.

### [Azure portal](#tab/portal)

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
Each of the DCEs created for configuration access need to be added to the AMPLS.

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

### Ingestion from a private AKS cluster

If you choose to use an Azure Firewall to limit the egress from your cluster, you can implement one of the following:

* Open a path to the public ingestion endpoint. Update the routing table with the following two endpoints:
    * `*.handler.control.monitor.azure.com`
    * `*.ingest.monitor.azure.com`
* Enable the Azure Firewall to access the Azure Monitor Private Link scope and DCE that's used for data ingestion.

### Private link ingestion for remote write

Use the following steps to set up remote write for Prometheus metrics for a Kubernetes cluster over a private link virtual network and an AMPLS.

1. Configure the on-premises cluster to connect to an Azure VNET using a VPN gateway or ExpressRoutes with private-peering.
1. Connect the AMPLS to a private endpoint in the virtual network used by the on-premises cluster. This private endpoint is used to access your DCEs.
1. From the **Overview** page for your Azure Monitor workspace in the Azure portal, click on the **Data collection endpoint**.
1. Select the **Network Isolation** page for the DCE. 
1. Click **Add** and select your AMPLS. Wait a few minutes for the settings to propagate, and data from your on-premises AKS cluster should ingested into your Azure Monitor workspace over the private link.


## Verify data ingestion

There are multiple methods to verify that data is being ingested from your cluster over the private link. One method is to check the **Monitor** menu for one of your clusters. You should see metrics and events being collected. 

:::image type="content" source="media/kubernetes-monitoring-private-link/cluster-monitoring.png" lightbox="media/kubernetes-monitoring-private-link/cluster-monitoring.png" alt-text="Screenshot showing monitoring of a cluster to verify data collection.":::


## Next steps

* See [Connect to a data source privately](/azure/managed-grafana/how-to-connect-to-data-source-privately) for details on how to configure private link to query data from your Azure Monitor workspace using Grafana.
* See [Enable query from Azure Monitor workspace using private link](../fundamentals/private-link-azure-monitor-workspace.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.

