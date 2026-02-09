---
title: Design Azure Monitor Private Link configuration
description: This article shows how to design your Azure Private Link setup
ms.reviewer: noakuper
ms.topic: concept-article
ms.date: 10/23/2024
---

# Design Azure Monitor Private Link configuration

When you create an [Azure Monitor Private Link Scope (AMPLS)](./private-link-security.md), you limit access to Azure Monitor resources to only the networks connected to the private endpoint. This article provides guidance on how to design your Azure Monitor private link configuration and other considerations you should take into account before you actually implement it using the guidance at [Configure private link for Azure Monitor](./private-link-configure.md).

## AMPLS limits

[!INCLUDE [ampls-limitations](../fundamentals//includes/ampls-limitations.md)]

## Plan by network topology

The following sections describe how to plan your Azure Monitor private link configuration based on your network topology.

### Avoid DNS overrides by using a single AMPLS

Some networks are composed of multiple virtual networks or other connected networks. If these networks share the same DNS, configuring a private link on any of them would update the DNS and affect traffic across all networks.

In the following diagram, virtual network 10.0.1.x connects to AMPLS1, which creates DNS entries that map Azure Monitor endpoints to IPs from range 10.0.1.x. Later, virtual network 10.0.2.x connects to AMPLS2, which overrides the same DNS entries by mapping *the same global/regional endpoints* to IPs from the range 10.0.2.x. Because these virtual networks aren't peered, the first virtual network now fails to reach these endpoints. To avoid this conflict, create only a single AMPLS object per DNS.

:::image type="content" source="./media/private-link-security/dns-overrides-multiple-vnets.png" lightbox="./media/private-link-security/dns-overrides-multiple-vnets.png" alt-text="Diagram that shows DNS overrides in multiple virtual networks." border="false":::

### Hub-and-spoke networks

Hub-and-spoke networks should use a single private link connection set on the hub (main) network, and not on each spoke virtual network.

You might prefer to create separate private links for your spoke virtual networks to allow each virtual network to access a limited set of monitoring resources. In this case, you can create a dedicated private endpoint and AMPLS for each virtual network. You must also verify they don't share the same DNS zones to avoid DNS overrides.

:::image type="content" source="./media/private-link-security/hub-and-spoke-with-single-private-endpoint-with-data-collection-endpoint.png" lightbox="./media/private-link-security/hub-and-spoke-with-single-private-endpoint-with-data-collection-endpoint.png" alt-text="Diagram that shows a hub-and-spoke single private link." border="false":::

### Peered networks

With network peering, networks can share each other's IP addresses and most likely share the same DNS. In this case, create a single private link on a network that's accessible to your other networks. Avoid creating multiple private endpoints and AMPLS objects because only the last one set in the DNS applies.

### Isolated networks

If your networks aren't peered, you must also separate their DNS to use private links. You can then create a separate private endpoint for each network, and a separate AMPLS object. Your AMPLS objects can link to the same workspaces/components or to different ones.






## Control network access to AMPLS resources

Azure Monitor components can be set to either:

* Accept or block ingestion from public networks (networks not connected to the resource AMPLS).
* Accept or block queries from public networks (networks not connected to the resource AMPLS).

This granularity allows you to set access per workspace according to your specific needs. For example, you might accept ingestion only through private link-connected networks but still choose to accept queries from all networks, public and private.

> [!NOTE]
> Blocking queries from public networks means clients like machines and SDKs outside of the connected AMPLS can't query data in the resource. That data includes logs, metrics, and the live metrics stream. Blocking queries from public networks affects all experiences that run these queries, such as workbooks, dashboards, insights in the Azure portal, and queries run from outside the Azure portal.

Following are exceptions to this network access:

- **Diagnostic logs**. Logs and metrics sent to a workspace from a [diagnostic setting](../essentials/diagnostic-settings.md) are over a secure private Microsoft channel and aren't controlled by these settings.
- **Custom metrics or Azure Monitor guest metrics**. [Custom metrics](../essentials/metrics-custom-overview.md) sent from the Azure Monitor Agent aren't controlled by DCEs and can't be configured over private links.

> [!NOTE]
> Queries sent through the Resource Manager API can't use Azure Monitor private links. These queries can only gain access if the target resource allows queries from public networks.
>
> The following experiences are known to run queries through the Resource Manager API:
> * LogicApp connector
> * Update Management solution
> * Change Tracking solution
> * VM Insights
> * Container Insights
> * Log Analytics **Workspace Summary (deprecated)** pane (that shows the solutions dashboard)
> * Metrics pane in Application Insights (log-based metrics charting)

## Special considerations

### Application Insights

* Add resources hosting the monitored workloads to a private link. For example, see [Using private endpoints for Azure Web App](/azure/app-service/networking/private-endpoint).
* Non-portal consumption experiences must also run on the private-linked virtual network that includes the monitored workloads.
* [Provide your own storage account](../app/profiler-bring-your-own-storage.md) to support private links for the .NET Profiler and Debugger.

> [!NOTE]
> To fully secure workspace-based Application Insights, lock down access to the Application Insights resource and the underlying Log Analytics workspace.

### Managed Prometheus

* Private Link ingestion settings are made using AMPLS and settings on the Data Collection Endpoints (DCEs) that reference the Azure Monitor workspace used to store Prometheus metrics.
* Private Link query settings are made directly on the Azure Monitor workspace used to store Prometheus metrics and aren't handled with AMPLS.

To set up ingestion of Managed Prometheus metrics using AMPLS, see [Enable ingestion of metrics from AKS with AMPLS](../fundamentals/private-link-kubernetes.md).

## Next steps

- Learn how to [configure your private link](../logs/private-link-configure.md).
- Learn about [private storage](../logs/private-storage.md) for custom logs and customer-managed keys.
- Learn about [Private Link for Automation](/azure/automation/how-to/private-link-security).
