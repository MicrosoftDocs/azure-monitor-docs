---
title: Use Azure Private Link to connect networks to Azure Monitor
description: Set up an Azure Monitor Private Link Scope to securely connect networks to Azure Monitor.
ms.reviewer: mahesh.sundaram
ms.topic: concept-article
ms.date: 01/27/2026
---

# Use Azure Private Link to connect networks to Azure Monitor

[Azure Private Link](/azure/private-link/private-link-overview) allows you to securely link Azure data platform as a service (PaaS) resources to your virtual network (VNet) by using private endpoints. This article describes how to use private link with Azure Monitor resources.

## Benefits

Azure Monitor shares the same benefits from private link as other services as described in [Key benefits of Private Link](/azure/private-link/private-link-overview#key-benefits).

* Connect privately to Log Analytics workspaces and Azure Monitor workspaces without allowing public network access. Ensure your monitoring data is only accessed through authorized private networks.
* Prevent data exfiltration from your private networks by defining specific Azure Monitor resources that connect through your private endpoint.
* Securely connect to Azure Monitor from on-premises networks that connect to the VNet using [VPN](/azure/vpn-gateway/vpn-gateway-about-vpngateways) or [ExpressRoutes](/azure/expressroute/expressroute-locations) with private-peering.
* Keep all monitoring traffic inside the Azure backbone network.

## Basic concepts

Private links for Azure Monitor are structured differently from private links for other services. Instead of creating a private link for each resource the VNet connects to, Azure Monitor uses a single private link connection using a private endpoint from the virtual network to an Azure Monitor Private Link Scope (AMPLS). The AMPLS is a set of Azure Monitor resources that define the boundaries of your monitoring network.

:::image type="content" source="media/private-link-security/private-link-basic-topology.png" lightbox="media/private-link-security/private-link-basic-topology.png" alt-text="Diagram that shows basic resource topology." border="false":::

The private endpoint uses a separate IP address within the VNet address space allowing AMPLS resources to be accessed privately from the VNet without using public IPs. Traffic from the clients on the VNet to Azure Monitor resources traverse the Azure backbone eliminating exposure to the public internet.

Applications in the VNet can connect to resources in the AMPLS over the private endpoint seamlessly, using the same connection strings and authorization mechanisms that they would use otherwise.

## Shared global and regional endpoints
When you create an AMPLS, your DNS zones map Azure Monitor endpoints to private IPs to send traffic through the private link. Some Azure Monitor resource use resource-specific endpoints while others use shared endpoints. You need to understand the difference between each and how each Azure Monitor resource uses them to properly configure your private link and the resources in your AMPLS.

### Resource-specific endpoints
The following Azure Monitor resources use resource-specific endpoints. This means that each must be configured separately. and, only traffic to this resource will be sent through the allocated private IPs. Traffic to other resources will continue to use public endpoints.

| Resource | Function |
|:---|:---|
| Log Analytics workspace | Ingestion |
| Data collection endpoints | Log Analytics workspace configuration<br>
    - Azure Monitor workspace configuration
    - Azure Monitor workspace ingestion
- Azure Monitor workspace query

### Shared endpoints
Configuring a private link  for a single resource that uses shared endpoints will change the DNS configuration that affects traffic to all resources that uses shared endpoints.

For example, Log Analytics workspaces use shared endpoints for log queries. When you add a single Log Analytics workspace to an AMPLS, the DNS for that VNet is updated to access that shared endpoint over private link. Since all Log Analytics workspaces share that endpoint, queries to all Log Analytics workspaces from that VNet will use the private IPs. 

You should use a single AMPLS for all networks that share the same DNS. Creating multiple AMPLS resources will cause Azure Monitor DNS zones to override each other and break existing environments. See [Plan by network topology](private-link-design.md#plan-by-network-topology) for further details and examples.

The following Azure Monitor resources use shared endpoints. :

- Log Analytics workspace query
- Application insights query
- Application Insights ingestion endpoints


## Resources

### Log Analytics workspaces
[Log Analytics workspaces]() support ingestion of log data and queries using KQL. Add Log Analytics workspaces to the AMPLS to enable ingestion and queries. Ingestion uses a resource-specific endpoint while queries use a shared endpoint. 

### Data collection endpoints (DCEs)
[Data collection endpoints (DCE)]() are Azure resources that define a unique set of endpoints related to data collection, configuration, and ingestion in Azure Monitor. DCEs use resource-specific ingestion. Configuring a DCE for a set of clients, doesn't affect ingestion of telemetry of other clients in the same VNet.

Add DCEs to the AMPLS to support the following:

- Data ingestion for Azure Monitor workspaces.
- Retrieve configuration for clients that use [Azure Monitor agent (AMA)] such as virtual machines and Kubernetes clusters.

### Application insights 
Endpoints handling ingestion for Application insights are global.

> [!NOTE]
> ### Azure Monitor workspaces
>
> [Azure Monitor workspaces]() support ingestion of metric data and queries using PromQL. Azure Monitor workspaces aren't added to the AMPLS. When an Azure Monitor workspace is created, a [data collection endpoint (DCE)]() is automatically created for it. This DCE needs to be added to the AMPLS to support data ingestion for the workspace. To support queries, a managed private endpoint needs to be created for the workspace and added to the AMPLS.

## Access modes
Private link access modes let you to control how private links affect your network traffic. Which you select is critical to ensuring continuous, uninterrupted network traffic. 

Access modes can apply to all networks connected to your AMPLS or to specific networks connected. Data ingestion and queries each have their own setting. For example, you can set the **Private Only** mode for ingestion and the **Open** mode for queries.

> [!IMPORTANT]
> Log Analytics ingestion uses resource-specific endpoints so it doesn't adhere to AMPLS access modes. To assure Log Analytics ingestion requests can't access workspaces out of the AMPLS, set the network firewall to block traffic to public endpoints, regardless of the AMPLS access modes.

### Private Only access mode
**Private Only** mode allows the virtual network to reach only private link resources in the AMPLS. This is the most secure option and prevents data exfiltration by blocking traffic out of the AMPLS to Azure Monitor resources.

:::image type="content" source="./media/private-link-security/ampls-private-only-access-mode.png" lightbox="./media/private-link-security/ampls-private-only-access-mode.png" alt-text="Diagram that shows the AMPLS Private Only access mode." border="false":::

### Open access mode
**Open** mode allows the virtual network to reach both private link resources and resources not in the AMPLS (if they [accept traffic from public networks](#control-network-access-to-ampls-resources)). The Open access mode doesn't prevent data exfiltration, but it still offers the other benefits of private links. Traffic to private link resources is sent through private endpoints before it's validated and then sent over the Microsoft backbone. The Open mode is useful for mixed mode where some resources are accessed publicly and others accessed over a private link. It can also be useful during a gradual onboarding process.
 
:::image type="content" source="./media/private-link-security/ampls-open-access-mode.png" lightbox="./media/private-link-security/ampls-open-access-mode.png" alt-text="Diagram that shows the AMPLS Open access mode." border="false":::

> [!IMPORTANT]
> Apply caution when you select the access mode. Using Private Only will block traffic to resources not in the AMPLS across all networks that share the same DNS regardless of subscription or tenant. If you can't add all Azure Monitor resources to the AMPLS, start by adding select resources and applying themode. Switch to the Private Only mode for maximum security only after you've added all Azure Monitor resources to your AMPLS.

### Set access modes for specific networks
The access modes set on the AMPLS resource affect all networks, but you can override these settings for specific networks.

In the following diagram, VNet1 uses the Open mode and VNet2 uses the Private Only mode. Requests from VNet1 can reach Workspace 1 and Component 2 over a private link. Requests can reach Component 3 only if it [accepts traffic from public networks](#control-network-access-to-ampls-resources). VNet2 requests can't reach Component 3.

:::image type="content" source="./media/private-link-security/ampls-mixed-access-modes.png" lightbox="./media/private-link-security/ampls-mixed-access-modes.png" alt-text="Diagram that shows mixed access modes." border="false":::

## Pricing

For pricing details, see [Azure Private Link pricing](https://azure.microsoft.com/pricing/details/private-link).


## Next steps

* [Design your Azure Private Link setup](private-link-design.md).
* Learn how to [configure your private link](private-link-configure.md).
* Learn about [private storage](private-storage.md) for custom logs and customer-managed keys.
<h3><a id="connect-to-a-private-endpoint"></a></h3>
