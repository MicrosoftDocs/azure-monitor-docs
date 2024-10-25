---
title: Design Azure Monitor Private Link configuration
description: This article shows how to design your Azure Private Link setup
ms.author: guywild
author: guywi-ms
ms.reviewer: noakuper
ms.topic: conceptual
ms.date: 10/23/2024
---

# Design Azure Monitor Private Link configuration

When you create an [Azure Monitor Private Link Scope (AMPLS)](./private-link-security.md), you limit access to Azure Monitor resources to only the networks connected to the private endpoint. This article provides guidance on how to design your Azure Monitor private link configuration before you actually implement it using the guidance at [Configure private link for Azure Monitor](./private-link-configure.md).

Creating a private link affects traffic to all Azure Monitor resources. That's especially true for Application Insights resources. It also affects not only the network connected to the private endpoint but also all other networks that share the same DNS.

## Basic approach

The simplest and most secure approach to desiging your Azure Monitor private link configuration is the following steps.

1. Create a single private link connection, with a single private endpoint and a single Azure Monitor Private Link Scope (AMPLS). If your networks are peered, create the private link connection on the shared (or hub) virtual network.
1. Add *all* Azure Monitor resources like Application Insights components, Log Analytics workspaces, and data collection endpoints (DCEs) to the AMPLS.
1. Block network egress traffic as much as possible.

If you can't add all Azure Monitor resources to your AMPLS, you can still apply your private link to some resources, as descibed in in [Control how private links apply to your networks](#control-how-private-links-apply-to-your-networks). This is not a recommended approach though because it doesn't prevent data exfiltration.

## Plan by network topology

The following sections describe how to plan your Azure Monitor private link configuration based on your network topology.

### Avoid DNS overrides by using a single AMPLS
Some networks are composed of multiple virtual networks or other connected networks. If these networks share the same DNS, setting up a private link on any of them would update the DNS and affect traffic across all networks.

In the following diagram, virtual network 10.0.1.x connects to AMPLS1, which creates DNS entries that map Azure Monitor endpoints to IPs from range 10.0.1.x. Later, virtual network 10.0.2.x connects to AMPLS2, which overrides the same DNS entries by mapping *the same global/regional endpoints* to IPs from the range 10.0.2.x. Because these virtual networks aren't peered, the first virtual network now fails to reach these endpoints.

To avoid this conflict, create only a single AMPLS object per DNS.

:::image type="content" source="./media/private-link-security/dns-overrides-multiple-vnets.png" lightbox="./media/private-link-security/dns-overrides-multiple-vnets.png" alt-text="Diagram that shows DNS overrides in multiple virtual networks.":::

### Hub-and-spoke networks
Hub-and-spoke networks should use a single private link connection set on the hub (main) network, and not on each spoke virtual network.

:::image type="content" source="./media/private-link-security/hub-and-spoke-with-single-private-endpoint-with-data-collection-endpoint.png" lightbox="./media/private-link-security/hub-and-spoke-with-single-private-endpoint-with-data-collection-endpoint.png" alt-text="Diagram that shows a hub-and-spoke single private link.":::

You might prefer to create separate private links for your spoke virtual networks to allow each virtual network to access a limited set of monitoring resources. In this case, you can create a dedicated private endpoint and AMPLS for each virtual network. You must also verify they don't share the same DNS zones to avoid DNS overrides.

### Peered networks
With network peering, networks can share each other's IP addresses and most likely share the same DNS. In this case, create a single private link on a network that's accessible to your other networks. Avoid creating multiple private endpoints and AMPLS objects because only the last one set in the DNS applies.

### Isolated networks
If your networks aren't peered, you must also separate their DNS to use private links. You can then create a separate private endpoint for each network, and a separate AMPLS object. Your AMPLS objects can link to the same workspaces/components or to different ones.


## Selecting an access mode
By using private link access modes, you can control how private links affect your network traffic. These settings can apply to your AMPLS object to affect all connected networks or to specific networks connected to it. Access modes are set separately for ingestion and queries. For example, you can set the Private Only mode for ingestion and the Open mode for queries.

> [!IMPORTANT]
> Log Analytics ingestion uses resource-specific endpoints so it doesn't adhere to AMPLS access modes. To assure Log Analytics ingestion requests can't access workspaces out of the AMPLS, set the network firewall to block traffic to public endpoints, regardless of the AMPLS access modes.

Choosing the proper access mode is critical to ensuring continuous, uninterrupted network traffic. Each of these modes can be set for ingestion and queries, separately:

### Private Only access mode
This mode allows the virtual network to reach only private link resources in the AMPLS. This is the most secure option and prevents data exfiltration by blocking traffic out of the AMPLS to Azure Monitor resources.

:::image type="content" source="./media/private-link-security/ampls-private-only-access-mode.png" lightbox="./media/private-link-security/ampls-private-only-access-mode.png" alt-text="Diagram that shows the AMPLS Private Only access mode.":::


### Open access mode
This mode allows the virtual network to reach both private link resources and resources not in the AMPLS (if they [accept traffic from public networks](./private-link-design.md#control-network-access-to-your-resources)). The Open access mode doesn't prevent data exfiltration, but it still offers the other benefits of private links. Traffic to private link resources is sent through private endpoints, validated, and sent over the Microsoft backbone. The Open mode is useful for mixed mode where some resources are accessed publicly and others accessed over a private link. It can also be useful during a gradual onboarding process.
* 
:::image type="content" source="./media/private-link-security/ampls-open-access-mode.png" lightbox="./media/private-link-security/ampls-open-access-mode.png" alt-text="Diagram that shows the AMPLS Open access mode.":::


> [!IMPORTANT]
> Apply caution when you select your access mode. Using the Private Only access mode will block traffic to resources not in the AMPLS across all networks that share the same DNS regardless of subscription or tenant. If you can't add all Azure Monitor resources to the AMPLS, start by adding select resources and applying the Open access mode. Switch to the Private Only mode for maximum security only after you've added all Azure Monitor resources to your AMPLS.

### Set access modes for specific networks
The access modes set on the AMPLS resource affect all networks, but you can override these settings for specific networks.

In the following diagram, VNet1 uses the Open mode and VNet2 uses the Private Only mode. Requests from VNet1 can reach Workspace 1 and Component 2 over a private link. Requests can reach Component 3 only if it [accepts traffic from public networks](./private-link-design.md#control-network-access-to-your-resources). VNet2 requests can't reach Component 3.

:::image type="content" source="./media/private-link-security/ampls-mixed-access-modes.png" lightbox="./media/private-link-security/ampls-mixed-access-modes.png" alt-text="Diagram that shows mixed access modes.":::

## AMPLS limits

[!INCLUDE [ampls-limitations](../includes/ampls-limitations.md)]


## Control network access to resources

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

## Application Insights considerations

* Add resources hosting the monitored workloads to a private link. For example, see [Using private endpoints for Azure Web App](/azure/app-service/networking/private-endpoint).
* Non-portal consumption experiences must also run on the private-linked virtual network that includes the monitored workloads.
* [Provide your own storage account](../app/profiler-bring-your-own-storage.md) to support private links for the Profiler and Debugger.

> [!NOTE]
> To fully secure workspace-based Application Insights, lock down access to the Application Insights resource and the underlying Log Analytics workspace.

## Managed Prometheus considerations
* Private Link ingestion settings are made using AMPLS and settings on the Data Collection Endpoints (DCEs) that reference the Azure Monitor workspace used to store Prometheus metrics.
* Private Link query settings are made directly on the Azure Monitor workspace used to store Prometheus metrics and aren't handled with AMPLS.

## Network subnet size
The smallest supported IPv4 subnet is /27 using CIDR subnet definitions. Although Azure virtual networks [can be as small as /29](/azure/virtual-network/virtual-networks-faq#how-small-and-how-large-can-virtual-networks-and-subnets-be), Azure [reserves five IP addresses](/azure/virtual-network/virtual-networks-faq#are-there-any-restrictions-on-using-ip-addresses-within-these-subnets). The Azure Monitor private link setup requires at least 11 more IP addresses even if you're connecting to a single workspace. [Review your endpoint's DNS settings](./private-link-configure.md#review-your-endpoints-dns-settings) for the list of Azure Monitor private link endpoints.

## Azure portal
To use Azure Monitor portal experiences for Application Insights, Log Analytics, and DCEs, allow the Azure portal and Azure Monitor extensions to be accessible on the private networks. Add **AzureActiveDirectory**, **AzureResourceManager**, **AzureFrontDoor.FirstParty**, and **AzureFrontdoor.Frontend** [service tags](/azure/firewall/service-tags) to your network security group.

## Programmatic access
To use the REST API, the Azure [CLI](/cli/azure/monitor), or PowerShell with Azure Monitor on private networks, add the [service tags](/azure/virtual-network/service-tags-overview) **AzureActiveDirectory** and **AzureResourceManager** to your firewall.

## Browser DNS settings
If you're connecting to your Azure Monitor resources over a private link, traffic to these resources must go through the private endpoint that's configured on your network. To enable the private endpoint, update your DNS settings as described in [Connect to a private endpoint](./private-link-configure.md#connect-to-a-private-endpoint). Some browsers use their own DNS settings instead of the ones you set. The browser might attempt to connect to Azure Monitor public endpoints and bypass the private link entirely. Verify that your browser settings don't override or cache old DNS settings.

## Querying limitation: externaldata operator

* The [externaldata](/azure/data-explorer/kusto/query/externaldata-operator?pivots=azuremonitor) operator isn't supported over a private link because it reads data from storage accounts but doesn't guarantee the storage is accessed privately.
* The [Azure Data Explorer proxy (ADX proxy)](azure-monitor-data-explorer-proxy.md) allows log queries to query Azure Data Explorer. The ADX proxy isn't supported over a private link because it doesn't guarantee the targeted resource is accessed privately. 

## Next steps
- Learn how to [configure your private link](private-link-configure.md).
- Learn about [private storage](private-storage.md) for custom logs and customer-managed keys.
- Learn about [Private Link for Automation](/azure/automation/how-to/private-link-security).
