---
title: Enable private link for monitoring virtual machines and Kubernetes clusters in Azure Monitor
description: Learn how to enable private link on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.custom: devx-track-azurecli
ms.reviewer: aul
---

# Enable private link for monitoring virtual machines and Kubernetes clusters in Azure Monitor

[Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. An [Azure Monitor Private Link Scope (AMPLS)](../fundamentals/private-link-security.md) connects a private endpoint to a set of Azure Monitor resources to define the boundaries of your monitoring network. 

This article describes how to configure monitoring of your virtual machines (VMs) and Kubernetes clusters with an existing Azure Monitor Private Link Scope (AMPLS).

## Prerequisites

- Enable monitoring of your VM or cluster using relevant guidance.
    - Enable monitoring of your Kubernetes cluster using the guidance in [Enable Prometheus metrics and container logging](../containers/kubernetes-monitoring-enable.md).
    - Enable monitoring of your VM using the guidance in [Enable VM Insights](../vm/vminsights-enable.md) or [Collect data from virtual machine client with Azure Monitor](../vm/data-collection.md).
- Create an AMPLS and connect it to your VNet using the process described in [Configure private link for Azure Monitor](./private-link-configure.md).


## Conceptual overview
VMs and Kubernetes clusters monitored by Azure Monitor both use the [Azure Monitor agent](../agents/azure-monitor-agent-overview.md) for monitoring so their configuration for private link is similar. Depending on their configuration, each will send metrics to an Azure Monitor workspace and/or logs to a Log Analytics workspace. 

The Azure Monitor agent running on the VM or cluster needs to have connectivity for the following operations:

- Retrieve configuration from Azure Monitor. This includes the [data collection rules (DCRs)](../data-collection/data-collection-rule-overview.md) associated with the agent that define what log and metric data to collect and where to send it.
- Send data to Azure Monitor workspace and Log Analytics workspace.
- Query data from Azure Monitor workspace and Log Analytics workspace.

> [!NOTE]
> VMs only send metrics to an Azure Monitor workspace if they've been migrated to OpenTelemetry metrics as described in [Migrate to VM insights OpenTelemetry (preview)](../vm/vminsights-opentelemetry.md). If not, they store metrics in Log Analytics workspaces. The same guidance in this article applies to a VM that hasn't been migrated to OpenTelemetry metrics, but only the Log Analytics workspace needs to be configured.

[Data collection endpoints (DCEs)](../data-collection/data-collection-endpoint-overview.md) are used for different functions when using private link with Azure Monitor as described in [AMPLS resources](./private-link-security.md#ampls-resources). You will use a combination of existing DCEs and new DCEs that you create depending on your requirements.

## Enable agent configuration

Both the VM and cluster require [data collection endpoints (DCEs)](../data-collection/data-collection-endpoint-overview.md) in the AMPLS to retrieve their configuration from Azure Monitor over private link. Only a single DCE is required for the VM or cluster to retrieve its configuration. It will use this DCE to retrieve DCRs for both logs and metrics if both are enabled. Any DCE in the same region as the VM or cluster can be used, but it's typically best to use an existing DCE if it's available.

If you're using an Azure Monitor workspace for metrics, then you can use the DCE created automatically for the workspace. If you're not using an Azure Monitor workspace or if your VM or cluster is in a different region than your Azure Monitor workspace, then you need to create a new DCE in the same region as your VM or cluster. Follow the guidance at [Create a data collection endpoint](../data-collection/data-collection-endpoint-overview.md?tabs=portal#create-a-data-collection-endpoint) to create a new DCE in the same region as your VM or cluster if needed.

### Associate VM or cluster with DCE
Create an association between the VM or cluster and a DCE for the VM/cluster to retrieve its configuration from Azure Monitor using the DCE. Each VM or cluster can only have an association with a single DCE, so if you create another association, the existing one will be replaced. 

### [Azure portal](#tab/portal)

If you're using the the DCE created by the Azure Monitor workspace, then identify it from its **Overview** page in the Azure portal.

:::image type="content" source="media/private-link-vm-kubernetes/azure-monitor-workspace-data-collection-endpoint.png" lightbox="media/private-link-vm-kubernetes/azure-monitor-workspace-data-collection-endpoint.png" alt-text="Screenshot showing the DCE for an Azure Monitor workspace.":::

From the **Monitor** menu in the Azure portal, select **Data Collection Endpoints**. Select the DCE and then the **Resources** tab. Click **Add** and select the cluster to create the association.

:::image type="content" source="media/private-link-vm-kubernetes/data-collection-endpoint-resources.png" lightbox="media/private-link-vm-kubernetes/data-collection-endpoint-resources.png" alt-text="Screenshot showing the Resources for a DCE.":::


### [CLI](#tab/cli)

Create association between the VM or cluster and the DCE using the following command:

```azurecli
az monitor data-collection rule association create --association-name configurationAccessEndpoint --data-collection-endpoint-id <dce-resource-id> --resource-uri <vm-resource-id/cluster-resource-id>

# Example VM
az monitor data-collection rule association create --association-name configurationAccessEndpoint --data-collection-endpoint-id /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce --resource-uri /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/vm/providers/Microsoft.Compute/virtualMachines/my-vm

# Example AKS
az monitor data-collection rule association create --association-name configurationAccessEndpoint --data-collection-endpoint-id /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce --resource-uri /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.ContainerService/managedClusters/my-cluster
```

### [PowerShell](#tab/powershell)

Create association between the VM or cluster and the DCE using the following command:

```powershell
New-AzDataCollectionRuleAssociation -associationname configurationAccessEndpoint -DataCollectionEndpointId <dce-resource-id> -resourceuri <vm-resource-id/cluster-resource-id>  

# Example VM
New-AzDataCollectionRuleAssociation   -resourceuri /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/vm/providers/Microsoft.Compute/virtualMachines/win03 -associationname configurationAccessEndpoint -DataCollectionEndpointId /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce

# Example AKS
New-AzDataCollectionRuleAssociation   -resourceuri /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/vm/providers/Microsoft.Compute/virtualMachines/win03 -associationname configurationAccessEndpoint -DataCollectionEndpointId /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/Microsoft.Insights/dataCollectionEndpoints/my-dce
```

---

### Add DCEs to AMPLS
Each of the DCEs created for configuration access need to be added to the AMPLS. This includes the DCE created by the Azure Monitor workspace and any new DCEs created for clusters in different regions. 

### [Azure portal](#tab/portal)

From the **Monitor** menu in the Azure portal, select **Azure Monitor Private Link Scopes**. Select your AMPLS and then the **Azure Monitor Resources** tab. Click **Add** and select the DCE to add it to the AMPLS.

:::image type="content" source="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-resources-data-collection-endpoint.png" lightbox="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-resources-data-collection-endpoint.png" alt-text="Screenshot showing how to add a DCE to an AMPLS.":::

### [CLI](#tab/cli)

Add a DCE to the AMPLS using the following command:

```azurecli
az monitor private-link-scope scoped-resource create --resource-group <resource-group> --scope-name <ampls-name> --name <dce-name> --linked-resource <dce-resource-id>

# Example
az monitor private-link-scope scoped-resource create --resource-group my-resource-group --scope-name my-ampls --name my-cluster  --linked-resource /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-groups/providers/Microsoft.Insights/dataCollectionEndpoints/my-cluster
```

### [PowerShell](#tab/powershell)

Add a DCE to the AMPLS using the following command:

```powershell
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName <resource-group> -ScopeName <ampls-name> -Name <dce-name> -LinkedResourceId <dce-resource-id>

# Example
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName my-resource-group -ScopeName my-ampls -Name my-cluster-LinkedResourceId /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-groups/providers/Microsoft.Insights/dataCollectionEndpoints/my-cluster
```

---

## Enable data ingestion
The VM or cluster requires a DCE in the AMPLS to send data to an Azure Monitor workspace using private link. No DCE is required to send log data to the Log Analytics workspace since the Log Analytics workspace is added to the AMPLS directly.

### Configure Azure Monitor workspace
A DCE is created automatically for each cluster when Prometheus metrics is enabled. This DCE will have a name similar to `MSProm-<region>-<cluster>` and is used for ingestion from the cluster. It just needs to be added to the AMPLS.

### [Azure portal](#tab/portal)

From the **Monitor** menu in the Azure portal, select **Azure Monitor Private Link Scopes**. Select your AMPLS and then the **Azure Monitor Resources** tab. Click **Add** and select the DCE to add it to the AMPLS.

:::image type="content" source="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-resources-data-collection-endpoint.png" lightbox="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-resources-data-collection-endpoint.png" alt-text="Screenshot showing how to add a DCE to an AMPLS.":::

### [CLI](#tab/cli)

Add a DCE to the AMPLS using the following command:

```azurecli
az monitor private-link-scope scoped-resource create --resource-group <resource-group> --scope-name <ampls-name> --name <dce-name> --linked-resource <dce-resource-id>

# Example
az monitor private-link-scope scoped-resource create --resource-group my-resource-group --scope-name my-ampls --name my-cluster  --linked-resource /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-groups/providers/Microsoft.Insights/dataCollectionEndpoints/my-cluster
```

### [PowerShell](#tab/powershell)

Add a DCE to the AMPLS using the following command:

```powershell
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName <resource-group> -ScopeName <ampls-name> -Name <dce-name> -LinkedResourceId <dce-resource-id>

# Example
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName my-resource-group -ScopeName my-ampls -Name my-cluster-LinkedResourceId /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-groups/providers/Microsoft.Insights/dataCollectionEndpoints/my-cluster
```

---

### Configure Log Analytics workspace
No DCE is required for ingestion to the Log Analytics workspace since it's added to the AMPLS directly as described in [AMPLS resources](./private-link-security.md#ampls-resources). Add a Log Analytics workspace to the AMPLS to support data ingestion from clusters and VMs in the connected VNet.

### [Azure portal](#tab/portal)

From the **Monitor** menu in the Azure portal, select **Azure Monitor Private Link Scopes**. Select your AMPLS and then the **Azure Monitor Resources** tab. Click **Add** and select the Log Analytics workspace to add it to the AMPLS.

:::image type="content" source="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-resources-workspace.png" lightbox="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-resources-workspace.png" alt-text="Screenshot showing how to add a Log Analytics workspace to an AMPLS.":::

### [CLI](#tab/cli)

Add a Log Analytics workspace to the AMPLS using the following command:

```azurecli
az monitor private-link-scope scoped-resource create --resource-group <resource-group> --scope-name <ampls-name> --name <workspace-name> --linked-resource <workspace-resource-id>

# Example VM
az monitor private-link-scope scoped-resource create --resource-group my-resource-group --scope-name my-ampls --name my-cluster  --linked-resource /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-groups/providers/Microsoft.Insights/dataCollectionEndpoints/my-cluster

# Example AKS
az monitor private-link-scope scoped-resource create --resource-group my-resource-group --scope-name my-ampls --name my-cluster  --linked-resource /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-groups/providers/Microsoft.Insights/dataCollectionEndpoints/my-cluster
```

### [PowerShell](#tab/powershell)

Add a Log Analytics workspace to the AMPLS using the following command:

```powershell
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName <resource-group> -ScopeName <ampls-name> -Name <workspace-name> -LinkedResourceId <workspace-resource-id>

# Example VM
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName my-resource-group -ScopeName my-ampls -Name my-workspace -LinkedResourceId /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace

# Example AKS
 New-AzInsightsPrivateLinkScopedResource -ResourceGroupName my-resource-group -ScopeName my-ampls -Name my-workspace -LinkedResourceId /subscriptions/aaaa0a0a-bb1b-cc2c-dd3d-eeeeee4e4e4e/resourceGroups/my-resource-group/providers/microsoft.operationalinsights/workspaces/my-workspace
```

---

## Enable query for Azure Monitor workspace
An additional private endpoint is required to support queries to the Azure Monitor workspace over private link. This is similar to the private endpoint created for the AMPLS, but this private endpoint is specifically for the Azure Monitor workspace to support queries over private link. For more details about this private endpoint and the DNS records created for it, see [Use private endpoints for Managed Prometheus and Azure Monitor workspace](./private-link-azure-monitor-workspace.md).

Follow the same guidance at [Connect AMPLS to a private endpoint](./private-link-configure.md#connect-ampls-to-a-private-endpoint) to create a new private endpoint connection, but use the following settings for the resource to connect to:

:::image type="content" source="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-private-endpoint.png" lightbox="media/private-link-vm-kubernetes/azure-monitor-private-link-scope-private-endpoint.png" alt-text="Screenshot that shows creating a private endpoint connection.":::

| Property | Description |
|:---|:---|
| Subscription | Subscription that contains your AMPLS. |
| Resource type | Microsoft.Monitor/accounts |
| Resource | Name for the link |
| Target sub-resource | prometheusMetrics |

## Ingestion from a private AKS cluster

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

There are multiple methods to verify that data is being ingested from your cluster over the private link. One method is to check the **Monitor** menu for one of your clusters or VMs. You should see metrics and events being collected. 

:::image type="content" source="media/private-link-vm-kubernetes/cluster-monitoring.png" lightbox="media/private-link-vm-kubernetes/cluster-monitoring.png" alt-text="Screenshot showing monitoring of a cluster to verify data collection.":::


## Next steps

* See [Connect to a data source privately](/azure/managed-grafana/how-to-connect-to-data-source-privately) for details on how to configure private link to query data from your Azure Monitor workspace using Grafana.
* See [Enable query from Azure Monitor workspace using private link](../fundamentals/private-link-azure-monitor-workspace.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.


