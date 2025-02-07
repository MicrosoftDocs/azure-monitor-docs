---
title: Setup ingestion with private endpoints for Managed Prometheus and Azure Monitor workspaces
description: Overview of private endpoints for secure query access to Azure Monitor workspace from virtual networks, and details about setting up e2e ingestion of Managed Prometheus metrics
author: sunasing
ms.author: sunasing
ms.reviewer: tbd
ms.topic: conceptual
ms.date: 01/25/2025
---

# Setup data ingestion of Managed Prometheus metrics from private AKS cluster to Azure Monitor workspace

[Azure Private Link](/azure/private-link/private-link-overview) enables you to access Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. An [Azure Monitor Private Link Scope (AMPLS)](../logs/private-link-security.md) connects a private endpoint to a set of Azure Monitor resources to define the boundaries of your monitoring network. Using private endpoints for Managed Prometheus and your Azure Monitor workspace you can allow clients on a virtual network (VNet) to securely ingest data over a Private Link.

This article describes the end-to-end instructions on how to configure Managed Prometheus for data ingestion from your private Azure Kubernetes Service (AKS) cluster to an Azure Monitor Workspace.

## Conceptual overview

- A private endpoint is a special network interface for an Azure service in your Virtual Network (VNet). When you create a private endpoint for your Azure Monitor workspace, it provides secure connectivity between clients on your VNet and your workspace. For more details, see [Private Endpoint](/azure/private-link/private-endpoint-overview).
- An Azure Private Link enables you to securely link Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. Azure Monitor uses a single private link connection called Azure Monitor Private Link Scope or AMPLS, which enables each client in the virtual network to connect with all Azure Monitor resources like Log Analytics Workspace, Azure Monitor Workspace etc. (instead of creating multiple private links).
For more details, see [Azure Monitor Private Link Scope (AMPLS)](../logs/private-link-security.md)

:::image type="content" source="./media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" lightbox="./media/kubernetes-monitoring-private-link/amp-private-ingestion-overview.png" alt-text="Diagram that shows overview of ingestion through private link.":::

To setup ingestion of Managed Prometheus metrics from virtual network using private endpoints into Azure Monitor Workspace, below are the high-level steps:

- Create an Azure Monitor Private Link Scope (AMPLS) and connect it with the Data Collection Endpoint of the Azure Monitor Workspace
- Connect the AMPLS to a private endpoint that is setup for the virtual network of your private AKS cluster

## Prerequisites

A [private AKS cluster](/azure/aks/private-clusters) with Managed Prometheus enabled. As part of Managed Prometheus enablement, you will also have an Azure Monitor Workspace setup. For more information, see [Enable Managed Prometheus in AKS](./kubernetes-monitoring-enable.md#enable-prometheus-and-grafana).

## Setup data ingestion from private AKS cluster to Azure Monitor Workspace

### 1. Create an AMPLS for Azure Monitor Workspace

Metrics collected with Azure Managed Prometheus is ingested and stored in Azure Monitor workspace, so you must make the workspace accessible over a private link. For this, create an Azure Monitor Private Link Scope or AMPLS.

1. In the Azure portal, search for "Azure Monitor Private Link Scopes", and then click "Create".
2. Enter the resource group and name, select **Private Only** for **Ingestion Access Mode**.

   :::image type="content" source="./media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls.png" alt-text="AMPLS configuration" lightbox="./media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls.png" :::

3. Click on "Review + Create" to create the AMPLS.

For more details on setup of AMPLS see [Configure private link for Azure Monitor](/azure/azure-monitor/logs/private-link-configure).

### 2. Connect the AMPLS to the Data Collection Endpoint of Azure Monitor Workspace

Private links for data ingestion for Managed Prometheus are configured on the Data Collection Endpoints (DCE) of the Azure Monitor workspace that stores the data. To identify the DCEs associated with your Azure Monitor workspace, select Data Collection Endpoints from your Azure Monitor workspace in the Azure portal.

1. In the Azure portal, search for the Azure Monitor Workspace that you created as part of enabling Managed Prometheus for your private AKS cluster. Note the Data Collection Endpoint name.
   
:::image type="content" source="./media/kubernetes-monitoring-private-link/amp-private-ingestion-dce.png" alt-text="A screenshot show the data collection endpoints page for an Azure Monitor workspace." lightbox="./media/kubernetes-monitoring-private-link/amp-private-ingestion-dce.png" :::

2. Now, in the Azure portal, search for the AMPLS that you created in the previous step. Go to the AMPLS overview page, click on **Azure Monitor Resources**, click **Add**, and then connect the DCE of the Azure Monitor Workspace that you noted in the previous step.

:::image type="content" source="./media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls-dce.png" alt-text="Connect DCE to the AMPLS" lightbox="./media/kubernetes-monitoring-private-link/amp-private-ingestion-ampls-dce.png" :::

#### 2a. Configure DCEs

> [!NOTE]
> If your AKS cluster isn't in the same region as your Azure Monitor Workspace, then you need to configure the Data Collection Rule for the Azure Monitor Workspace. 

Follow the steps below **only if your AKS cluster is not in the same region as your Azure Monitor Workspace**. If your cluster is in the same region, skip this step and move to step 3.

1. [Create a Data Collection Endpoint](../essentials/data-collection-endpoint-overview.md#create-a-data-collection-endpoint) in the same region as the AKS cluster.
2. Go to your Azure Monitor Workspace, and click on the Data collection rule (DCR) on the Overview page. This DCR has the same name as your Azure Monitor Workspace. 

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr.png" alt-text="A screenshot show the data collection rule for an Azure Monitor workspace." lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr.png" :::

3. From the DCR overview page, click on **Resources** -> **+ Add**, and then select the AKS cluster.

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-aks.png" alt-text="Screenshot showing how to connect AMW DCR to AKS" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-aks.png" :::

4. Once the AKS cluster is added (you might need to refresh the page), click on the AKS cluster, and then **Edit Data Collection of Endpoint**. On the blade that opens, select the Data Collection Endpoint that you created in step 1 of this section. Note that this DCE should be in the same region as the AKS cluster.

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-dce.png" alt-text="A screenshot showing association of the DCE." lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-dcr-dce.png" :::

### 3. Connect AMPLS to private endpoint of AKS cluster

A private endpoint is a special network interface for an Azure service in your Virtual Network (VNet). We will create a private endpoint in the VNet of your private AKS cluster and connect it to the AMPLS for secure ingestion of metrics.

1. In the Azure portal, search for the AMPLS that you created in the previous steps. Go to the AMPLS overview page, click on **Configure** -> **Private Endpoint connections**, and then select **+ Private Endpoint**.
2. Select the resource group and enter a name of the private endpoint, then click *Next*.
3. In the **Resource** section, select **Microsoft.Monitor/accounts** as the Resource type, the Azure Monitor Workspace as the Resource, and then select **prometheusMetrics**. Click *Next*.

:::image type="content" source="media/kubernetes-monitoring-private-link/amp-private-ingestion-private-endpoint-config.png" alt-text="A screenshot show the private endpoint config" lightbox="media/kubernetes-monitoring-private-link/amp-private-ingestion-private-endpoint-config.png" :::

3. In the **Virtual Network** section, select the virtual network of your AKS cluster. You can find this in the portal under AKS overview -> Settings -> Networking -> Virtual network integration.

## 4. Verify if metrics are ingested into Azure Monitor Workspace

Verify if Prometheus metrics from your private AKS cluster are ingested into Azure Monitor Workspace:

1. In the Azure portal, search for the Azure Monitor Workspace, and go to **Monitoring** -> **Metrics**.
2. In the Metrics Explorer, query for metrics and verify that you are able to query.

## Next steps

- [Query data from Azure Managed Grafana using Managed Private Endpoint](/azure/managed-grafana/how-to-connect-to-data-source-privately).
- [Use private endpoints for Managed Prometheus and Azure Monitor workspace](../essentials/azure-monitor-workspace-private-endpoint.md) for details on how to configure private link to query data from your Azure Monitor workspace using workbooks.
- [Azure Private Endpoint DNS configuration](/azure/private-link/private-endpoint-dns)
