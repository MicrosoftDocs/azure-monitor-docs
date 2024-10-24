---
title: Use Azure Private Link to connect networks to Azure Monitor
description: Set up an Azure Monitor Private Link Scope to securely connect networks to Azure Monitor.
ms.reviewer: mahesh.sundaram
ms.topic: conceptual
ms.date: 10/23/2024
---

# Use Azure Private Link to connect networks to Azure Monitor

With [Azure Private Link](/azure/private-link/private-link-overview), you can securely link Azure platform as a service (PaaS) resources to your virtual network by using private endpoints. Azure Monitor private links are structured differently from private links to other services. This article describes the main principles of Azure Monitor private links and how they operate.

Advantages of using Private Link with Azure Monitor include the following. See [Key benefits of Private Link](/azure/private-link/private-link-overview#key-benefits) for further benefits.

- Connect privately to Azure Monitor without allowing any public network access. Ensure your monitoring data is only accessed through authorized private networks.
- Prevent data exfiltration from your private networks by defining specific Azure Monitor resources that connect through your private endpoint.
- Securely connect your private on-premises network to Azure Monitor by using Azure ExpressRoute and Private Link.
- Keep all traffic inside the Azure backbone network.


## Basic concepts
Instead of creating a private link for each resource the virtual network connects to, Azure Monitor uses a single private link connection using a private endpoint from the virtual network to an Azure Monitor Private Link Scope (AMPLS). The AMPLS is a set of Azure Monitor resources that define the boundaries of your monitoring network.

:::image type="content" source="./media/private-link-security/private-link-basic-topology.png" lightbox="./media/private-link-security/private-link-basic-topology.png" alt-text="Diagram that shows basic resource topology.":::

Notable aspects of the AMPLS include the following:

* **Uses private IPs**: The private endpoint on your virtual network allows it to reach Azure Monitor endpoints through private IPs from your network's pool instead of using the public IPs of these endpoints. This allows you to keep using your Azure Monitor resources without opening your virtual network to unrequired outbound traffic.
* **Runs on the Azure backbone**: Traffic from the private endpoint to your Azure Monitor resources will go over the Azure backbone and not be routed to public networks.
* **Controls which Azure Monitor resources can be reached**: Configure whether to allow traffic only to Private Link resources or to both Private Link and non-Private-Link resources outside of the AMPLS.
* **Controls network access to your Azure Monitor resources**: Configure each of your workspaces or components to accept or block traffic from public networks, potentially using different settings for data ingestion and query requests.

## DNS zones
When you create an AMPLS, your DNS zones map Azure Monitor endpoints to private IPs to send traffic through the private link. Azure Monitor uses both resource-specific endpoints and shared global/regional endpoints to reach the workspaces and components in your AMPLS.

Because Azure Monitor uses some shared endpoints, configuring a private link even for a single resource changes the DNS configuration that affects traffic to *all resources*. The use of shared endpoints also means you should use a single AMPLS for all networks that share the same DNS. Creating multiple AMPLS resources will cause Azure Monitor DNS zones to override each other and break existing environments. See [Plan by network topology](./private-link-design.md#plan-by-network-topology) for further details.

### Shared global and regional endpoints
When you configure Private Link even for a single resource, traffic to the following endpoints will be sent through the allocated private IPs:

* **All Application Insights endpoints**: Endpoints handling ingestion, live metrics, the Profiler, and the debugger to Application Insights endpoints are global.
* **The query endpoint**: The endpoint handling queries to both Application Insights and Log Analytics resources is global.

> [!IMPORTANT]
> Creating a private link affects traffic to *all* monitoring resources, not only resources in your AMPLS. Effectively, it will cause all query requests and ingestion to Application Insights components to go through private IPs. It doesn't mean the private link validation applies to all these requests.</br>
>
> Resources not added to the AMPLS can only be reached if the AMPLS access mode is Open and the target resource accepts traffic from public networks. When you use the private IP, *private link validations don't apply to resources not in the AMPLS*. To learn more, see [Private Link access modes](#private-link-access-modes-private-only-vs-open).
>
> Private Link settings for Managed Prometheus and ingesting data into your Azure Monitor workspace are configured on the Data Collection Endpoints for the referenced resource. Settings for querying your Azure Monitor workspace over Private Link are made directly on the Azure Monitor workspace and are not handled via AMPLS.

### Resource-specific endpoints
Log Analytics endpoints are workspace specific, except for the query endpoint discussed earlier. As a result, adding a specific Log Analytics workspace to the AMPLS will send ingestion requests to this workspace over the private link. Ingestion to other workspaces will continue to use the public endpoints.

[Data collection endpoints](../essentials/data-collection-endpoint-overview.md) are also resource specific. You can use them to uniquely configure ingestion settings for collecting guest OS telemetry data from your machines (or set of machines) when you use the new [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) and [data collection rules](../essentials/data-collection-rule-overview.md). Configuring a data collection endpoint for a set of machines doesn't affect ingestion of guest telemetry from other machines that use the new agent.

## Private Link access modes: Private Only vs. Open
As discussed in [Azure Monitor private links rely on your DNS](#azure-monitor-private-links-rely-on-your-dns), only a single AMPLS resource should be created for all networks that share the same DNS. As a result, organizations that use a single global or regional DNS have a single private link to manage traffic to all Azure Monitor resources, across all global or regional networks.

For private links created before September 2021, that means:

* Log ingestion works only for resources in the AMPLS. Ingestion to all other resources is denied (across all networks that share the same DNS), regardless of subscription or tenant.
* Queries have a more open behavior that allows query requests to reach even resources not in the AMPLS. The intention here was to avoid breaking customer queries to resources not in the AMPLS and allow resource-centric queries to return the complete result set.

This behavior proved to be too restrictive for some customers because it breaks ingestion to resources not in the AMPLS. But it was too permissive for others because it allows querying resources not in the AMPLS.

Starting September 2021, private links have new mandatory AMPLS settings that explicitly set how they should affect network traffic. When you create a new AMPLS resource, you're now required to select the access modes you want for ingestion and queries separately:

* **Private Only mode**: Allows traffic only to Private Link resources.
* **Open mode**: Uses Private Link to communicate with resources in the AMPLS, but also allows traffic to continue to other resources. To learn more, see [Control how private links apply to your networks](./private-link-design.md#control-how-private-links-apply-to-your-networks).

Although Log Analytics query requests are affected by the AMPLS access mode setting, Log Analytics ingestion requests use resource-specific endpoints and aren't controlled by the AMPLS access mode. To ensure Log Analytics ingestion requests can't access workspaces out of the AMPLS, set the network firewall to block traffic to public endpoints, regardless of the AMPLS access modes.

> [!NOTE]
> If you've configured Log Analytics with Private Link by initially setting the network security group rules to allow outbound traffic by `ServiceTag:AzureMonitor`, the connected VMs send the logs through a public endpoint. Later, if you change the rules to deny outbound traffic by `ServiceTag:AzureMonitor`, the connected VMs keep sending logs until you reboot the VMs or cut the sessions. To make sure the desired configuration takes immediate effect, reboot the connected VMs.
>

## Next steps
- [Design your Azure Private Link setup](private-link-design.md).
- Learn how to [configure your private link](private-link-configure.md).
- Learn about [private storage](private-storage.md) for custom logs and customer-managed keys.
<h3><a id="connect-to-a-private-endpoint"></a></h3>
