---
title: Use Azure Private Link to connect networks to Azure Monitor
description: Set up an Azure Monitor Private Link Scope to securely connect networks to Azure Monitor.
ms.reviewer: mahesh.sundaram
ms.topic: concept-article
ms.date: 01/27/2026
---

# Use Azure Private Link to connect networks to Azure Monitor

With [Azure Private Link](/azure/private-link/private-link-overview), you can securely link Azure data platform as a service (PaaS) resources to your virtual network by using private endpoints. This article describes Azure Monitor private links and how they operate.

Benefits of using Private Link with Azure Monitor include the following. See [Key benefits of Private Link](/azure/private-link/private-link-overview#key-benefits) for further benefits.

* Connect privately to Log Analytics workspaces and Azure Monitor workspaces without allowing public network access. Ensure your monitoring data is only accessed through authorized private networks.
* Prevent data exfiltration from your private networks by defining specific Azure Monitor resources that connect through your private endpoint.
* Securely connect your private on-premises network to Azure Monitor by using Azure ExpressRoute and Private Link.
* Keep all traffic inside the Azure backbone network.

## Basic concepts

Azure Monitor private links are structured differently from private links to other services. Instead of creating a private link for each resource the virtual network connects to, Azure Monitor uses a single private link connection using a private endpoint from the virtual network to an Azure Monitor Private Link Scope (AMPLS). The AMPLS is a set of Azure Monitor resources that define the boundaries of your monitoring network.

:::image type="content" source="media/private-link-security/private-link-basic-topology.png" lightbox="media/private-link-security/private-link-basic-topology.png" alt-text="Diagram that shows basic resource topology.":::

Notable aspects of the AMPLS include the following:

* **Uses private IPs**: The private endpoint on your virtual network allows it to reach Azure Monitor endpoints through private IPs from your network's pool instead of using the public IPs of these endpoints. This allows you to keep using your Log Analytics workspaces and Azure Monitor workspaces without opening your virtual network to unrequired outbound traffic.
* **Runs on the Azure backbone**: Traffic from the private endpoint to your workspaces will go over the Azure backbone and not be routed to public networks.
* **Controls which Azure Monitor resources can be reached**: Configure whether to allow traffic only to Private Link resources or to both Private Link and non-Private-Link resources outside of the AMPLS.
* **Controls network access to your workspaces**: Configure each of your workspaces or components to accept or block traffic from public networks, potentially using different settings for data ingestion and query requests.

## DNS zones

When you create an AMPLS, your DNS zones map Azure Monitor endpoints to private IPs to send traffic through the private link. Azure Monitor uses both resource-specific endpoints and shared global/regional endpoints to reach the workspaces and components in your AMPLS.

Because Azure Monitor uses some shared endpoints, configuring a private link even for a single resource changes the DNS configuration that affects traffic to *all resources*. The use of shared endpoints also means you should use a single AMPLS for all networks that share the same DNS. Creating multiple AMPLS resources will cause Azure Monitor DNS zones to override each other and break existing environments. See [Plan by network topology](private-link-design.md#plan-by-network-topology) for further details.

## Shared global and regional endpoints

When you configure private link even for a single resource, traffic to the following endpoints will be sent through the allocated private IPs:

* **Query endpoints.** The endpoint handling queries to Application Insights, Log Analytics workspaces, and Azure Monitor workspaces is global.
* **Application Insights ingestion endpoints.** Endpoints handling ingestion for Application Insights are global.

## Resource-specific endpoints

Adding a specific Log Analytics workspace or Azure Monitor workspace to the AMPLS will send ingestion requests to this workspace over the private link. Ingestion to other workspaces will continue to use the public endpoints.

[Data collection endpoints](../data-collection/data-collection-endpoint-overview.md) are also resource specific. You can use them to uniquely configure ingestion settings for collecting guest OS telemetry data from your machines (or set of machines) when you use the new [Azure Monitor Agent](../agents/azure-monitor-agent-overview.md) and [data collection rules](../data-collection/data-collection-rule-overview.md). Configuring a data collection endpoint for a set of machines doesn't affect ingestion of guest telemetry from other machines that use the new agent.

## Next steps

* [Design your Azure Private Link setup](private-link-design.md).
* Learn how to [configure your private link](private-link-configure.md).
* Learn about [private storage](private-storage.md) for custom logs and customer-managed keys.
<h3><a id="connect-to-a-private-endpoint"></a></h3>
