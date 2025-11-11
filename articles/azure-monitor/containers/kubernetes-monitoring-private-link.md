---
title: Enable private link with Container insights and Managed Prometheus
description: Learn how to enable private link on an Azure Kubernetes Service (AKS) cluster.
ms.topic: how-to
ms.date: 08/25/2025
ms.custom: devx-track-azurecli
ms.reviewer: aul
---

# Enable private link for Kubernetes monitoring in Azure Monitor

[Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. An [Azure Monitor Private Link Scope (AMPLS)](../logs/private-link-security.md) connects a private endpoint to a set of Azure Monitor resources to define the boundaries of your monitoring network. Using private endpoints for Managed Prometheus/Container Insights and Azure Monitor workspace/Log Analytics Workspace you can allow clients on a virtual network (VNet) to securely ingest data over a Private Link.

This article describes how to connect your cluster to an existing Azure Monitor Private Link Scope (AMPLS). If you don't yet have an AMPLS, create one using the guidance at [Configure private link for Azure Monitor](../logs/private-link-configure.md).


## Managed Prometheus (Azure Monitor workspace)

Follow the steps below to set up ingestion of Prometheus metrics from private AKS cluster into Azure Monitor Workspace.

### Conceptual overview

* A private endpoint is a special network interface for an Azure service in your Virtual Network (VNet). When you create a private endpoint for your Azure Monitor workspace, it provides secure connectivity between clients on your VNet and your workspace. For more information, see [Private Endpoint](/azure/private-link/private-endpoint-overview).

* An Azure Private Link enables you to securely link Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. Azure Monitor uses a single private link connection called **Azure Monitor Private Link Scope or AMPLS**, which enables each client in the virtual network to connect with all Azure Monitor resources like Log Analytics Workspace, Azure Monitor Workspace etc. (instead of creating multiple private links). For more information, see [Azure Monitor Private Link Scope (AMPLS)](../logs/private-link-security.md)

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" alt-text="Diagram that shows overview of ingestion through private link.":::

To set up ingestion of Managed Prometheus metrics from virtual network using private endpoints into Azure Monitor Workspace, follow these high-level steps:

* Create an Azure Monitor Private Link Scope (AMPLS) and connect it with the Data Collection Endpoint of the Azure Monitor Workspace.
* Connect the AMPLS to a private endpoint that is set up for the virtual network of your private AKS cluster.

### Prerequisites

A [private AKS cluster](/azure/aks/private-clusters) with Managed Prometheus enabled. As part of Managed Prometheus enablement, you also have an Azure Monitor Workspace that is set up. For more information, see [Enable Managed Prometheus in AKS](./kubernetes-monitoring-enable.md).

### Set up data ingestion from private AKS cluster to Azure Monitor Workspace

### 1. Create an AMPLS for Azure Monitor Workspace

Metrics collected with Azure Managed Prometheus are ingested and stored in Azure Monitor workspace, so you must make the workspace accessible over a private link. For this, create an Azure Monitor Private Link Scope or AMPLS.

1. In the Azure portal, search for *Azure Monitor Private Link Scopes*, then click **Create**.

1. Enter the resource group and name, select **Private Only** for **Ingestion Access Mode**.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls.png" alt-text="Screenshot showing AMPLS configuration.":::

1. Click on "Review + Create" to create the AMPLS.

For more information on setup of AMPLS, see [Configure private link for Azure Monitor](/azure/azure-monitor/logs/private-link-configure).

### 2. Connect the AMPLS to the Data Collection Endpoint of Azure Monitor Workspace

Private links for data ingestion for Managed Prometheus are configured on the Data Collection Endpoints (DCE) of the Azure Monitor workspace that stores the data. To identify the DCEs associated with your Azure Monitor workspace, select Data Collection Endpoints from your Azure Monitor workspace in the Azure portal.

1. In the Azure portal, search for the Azure Monitor Workspace that you created as part of enabling Managed Prometheus for your private AKS cluster. Note the Data Collection Endpoint name.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dce.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dce.png" alt-text="A screenshot showing the data collection endpoints page for an Azure Monitor workspace.":::

1. Now, in the Azure portal, search for the AMPLS that you created in the previous step. Go to the AMPLS overview page, click on **Azure Monitor Resources**, click **Add**, and then connect the DCE of the Azure Monitor Workspace that you noted in the previous step.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls-dce.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls-dce.png" alt-text="Screenshot showing connection of DCE to the AMPLS.":::

### 2a. Configure DCEs

> [!NOTE]
> If your AKS cluster isn't in the same region as your Azure Monitor Workspace, then you need to configure a new Data Collection Endpoint for the Azure Monitor Workspace. 

Follow the steps below **only if your AKS cluster is not in the same region as your Azure Monitor Workspace**. If your cluster is in the same region, skip this step and move to step 3.

1. [Create a Data Collection Endpoint](../data-collection/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) in the same region as the AKS cluster.

1. Go to your Azure Monitor Workspace, and click on the Data collection rule (DCR) on the Overview page. This DCR has the same name as your Azure Monitor Workspace.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr.png" alt-text="A screenshot show the data collection rule for an Azure Monitor workspace.":::

1. From the DCR overview page, click on **Resources** -> **+ Add**, and then select the AKS cluster.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-aks.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-aks.png" alt-text="Screenshot showing how to connect AMW DCR to AKS":::

1. Once the AKS cluster is added (you might need to refresh the page), click on the AKS cluster, and then **Edit Data Collection of Endpoint**. On the blade that opens, select the Data Collection Endpoint that you created in step 1 of this section. This DCE should be in the same region as the AKS cluster.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-dce.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-dce.png" alt-text="A screenshot showing association of the DCE.":::

1. Go to the AMPLS overview page, click on **Azure Monitor Resources**, click **Add**, and then connect the created DCE.

### 3. Connect AMPLS to private endpoint of AKS cluster

A private endpoint is a special network interface for an Azure service in your Virtual Network (VNet). We now create a private endpoint in the VNet of your private AKS cluster and connect it to the AMPLS for secure ingestion of metrics.

1. In the Azure portal, search for the AMPLS that you created in the previous steps. Go to the AMPLS overview page, click on **Configure** -> **Private Endpoint connections**, and then select **+ Private Endpoint**.

1. Select the resource group and enter a name of the private endpoint, then click *Next*.

1. In the **Resource** section, select **Microsoft.Monitor/accounts** as the Resource type, the Azure Monitor Workspace as the Resource, and then select **prometheusMetrics**. Click *Next*.

    :::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-private-endpoint-config.png" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-private-endpoint-config.png" alt-text="A screenshot show the private endpoint config":::

1. In the **Virtual Network** section, select the virtual network of your AKS cluster. You can find this in the portal under AKS overview -> Settings -> Networking -> Virtual network integration.

### 4. Verify if metrics are ingested into Azure Monitor Workspace

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

### Cluster using legacy authentication

Use the following procedures to enable network isolation by connecting your cluster to the Log Analytics workspace using [Azure Private Link](../logs/private-link-security.md) if your cluster isn't using managed identity authentication. This requires a [private AKS cluster](/azure/aks/private-clusters).

1. Create a private AKS cluster following the guidance in [Create a private Azure Kubernetes Service cluster](/azure/aks/private-clusters).

1. Disable public Ingestion on your Log Analytics workspace. 

    Use the following command to disable public ingestion on an existing workspace.

    ```cli
    az monitor log-analytics workspace update --resource-group <azureLogAnalyticsWorkspaceResourceGroup> --workspace-name <azureLogAnalyticsWorkspaceName> --ingestion-access Disabled
    ```

    Use the following command to create a new workspace with public ingestion disabled.

    ```cli
    az monitor log-analytics workspace create --resource-group <azureLogAnalyticsWorkspaceResourceGroup> --workspace-name <azureLogAnalyticsWorkspaceName> --ingestion-access Disabled
    ```

1. Configure private link by following the instructions at [Configure your private link](../logs/private-link-configure.md). Set ingestion access to public and then set to private after the private endpoint is created but before monitoring is enabled. The private link resource region must be same as AKS cluster region. 

1. Enable monitoring for the AKS cluster.

    ```cli
    az aks enable-addons -a monitoring --resource-group <AKSClusterResourceGorup> --name <AKSClusterName> --workspace-resource-id <workspace-resource-id> --enable-msi-auth-for-monitoring false
    ```

## Next steps

* If you experience issues while you attempt to onboard the solution, review the [Troubleshooting guide](container-insights-troubleshoot.md).
* With monitoring enabled to collect health and resource utilization of your AKS cluster and workloads running on them, learn [how to use](container-insights-analyze.md) Container insights.
* [Query data from Azure Managed Grafana using Managed Private Endpoint](/azure/managed-grafana/how-to-connect-to-data-source-privately).
* [Use private endpoints for Managed Prometheus and Azure Monitor workspace](../metrics/azure-monitor-workspace-private-endpoint.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.
* [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
