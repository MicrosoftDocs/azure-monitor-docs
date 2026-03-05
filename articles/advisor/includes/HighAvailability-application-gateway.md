---
ms.service: azure
ms.topic: include
ms.date: 12/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Application Gateway
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Application Gateway  
  
<!--6a2b1e70-bd4c-4163-86de-5243d7ac05ee_begin-->

#### Upgrade your SKU or add more instances  
  
Deploying two or more medium or large sized instances ensures business continuity (fault tolerance) during outages caused by planned or unplanned maintenance.  
  
**Potential benefits**: Ensure business continuity through application gateway resilience  

**Impact:** Medium
  
For more information, see [Multi-region load balancing - Azure Reference Architectures ](https://aka.ms/aa_gatewayrec_learnmore)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 6a2b1e70-bd4c-4163-86de-5243d7ac05ee  
Subcategory: BusinessContinuity

<!--6a2b1e70-bd4c-4163-86de-5243d7ac05ee_end-->

<!--52a9d0a7-efe1-4512-9716-394abd4e0ab1_begin-->

#### Avoid hostname override to ensure site integrity  
  
Avoid overriding the hostname when configuring Application Gateway. Having a domain on the frontend of Application Gateway different than the one used to access the backend, can lead to broken cookies or redirect URLs. Make sure the backend is able to deal with the domain difference, or update the Application Gateway configuration so the hostname doesn't need to be overwritten towards the backend. When used with App Service, attach a custom domain name to the Web App and avoid use of the *.azurewebsites.net host name towards the backend. Note that a different frontend domain isn't a problem in all situations, and certain categories of backends like REST APIs, are less sensitive in general.  
  
**Potential benefits**: Ensure site integrity and avoid broken cookies or redirect urls through a resilient Application Gateway configuration.  

**Impact:** Medium
  
For more information, see [Troubleshoot redirection to App Service URL - Azure Application Gateway ](https://aka.ms/appgw-advisor-usecustomdomain)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 52a9d0a7-efe1-4512-9716-394abd4e0ab1  
Subcategory: Other

<!--52a9d0a7-efe1-4512-9716-394abd4e0ab1_end-->

<!--511a9f7b-7b5e-4713-b18d-0b7464a84d1f_begin-->

#### Change subnet of V1 gateway as the current subnet contains a NAT gateway  
  
Your Application Gateway may be deleted after October 2024 due to a failed internal upgrade. This is because it lacks a dedicated subnet and contains a NAT Gateway. To resolve, either change the subnet, remove the NAT Gateway, or migrate to V2. Allow a day for the message to disappear once fixed  
  
**Potential benefits**: Avoid disruption in management of Application Gateway V1 resource  

**Impact:** High
  
For more information, see [Frequently asked questions about Application Gateway](/azure/application-gateway/application-gateway-faq#can-i-change-the-virtual-network-or-subnet-for-an-existing-application-gateway)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 511a9f7b-7b5e-4713-b18d-0b7464a84d1f  
Subcategory: undefined

<!--511a9f7b-7b5e-4713-b18d-0b7464a84d1f_end-->


<!--5c488377-be3e-4365-92e8-09d1e8d9038c_begin-->

#### Deploy your Application Gateway across Availability Zones  
  
Achieve zone redundancy by deploying Application Gateway across Availability Zones. Zone redundancy boosts resilience by enabling Application Gateway to survive various outages. Zone redundancy ensures continuity even if one zone is affected and enhances overall reliability.  
  
**Potential benefits**: Availability zones add resiliency for Application Gateways  

**Impact:** High
  
For more information, see [Scaling and Zone-redundant Application Gateway v2](https://aka.ms/appgw/az)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 5c488377-be3e-4365-92e8-09d1e8d9038c  
Subcategory: undefined

<!--5c488377-be3e-4365-92e8-09d1e8d9038c_end-->


<!--6cc8be07-8c03-4bd7-ad9b-c2985b261e01_begin-->

#### Update VNet permission of Application Gateway users  
  
To improve security and provide a more consistent experience across Azure, all users must pass a permission check to create or update an Application Gateway in a Virtual Network. The users or service principals minimum permission required is Microsoft.Network/virtualNetworks/subnets/join/action.  
  
**Potential benefits**: Avoid disruptions in management of Application Gateway resource  

**Impact:** High
  
For more information, see [Azure Application Gateway infrastructure configuration](https://aka.ms/agsubnetjoin)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 6cc8be07-8c03-4bd7-ad9b-c2985b261e01  
Subcategory: undefined

<!--6cc8be07-8c03-4bd7-ad9b-c2985b261e01_end-->



<!--c9c9750b-9ddb-436f-b19a-9c725539a0b5_begin-->

#### Ensure autoscaling is used for increased performance and resiliency  
  
When configuring the Application Gateway, it's recommended to provision autoscaling to scale in and out in response to changes in demand. This helps to minimize the effects of a single failing component.  
  
**Potential benefits**: Increase performance and resiliency.  

**Impact:** Medium
  
For more information, see [Scaling and Zone-redundant Application Gateway v2 ](/azure/application-gateway/application-gateway-autoscaling-zone-redundant)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: c9c9750b-9ddb-436f-b19a-9c725539a0b5  
Subcategory: Scalability

<!--c9c9750b-9ddb-436f-b19a-9c725539a0b5_end-->

<!--df989782-82d1-420d-b354-71956bd9379c_begin-->

#### Change subnet of V1 gateway named GatewaySubnet as it's reserved for VPN/Express Route  
  
Your Application Gateway is at risk of deletion after October 2024 due to a failed internal upgrade. This is due to subnet named Gatewaysubnet, which is reserved for VPN/ExpressRoute. To resolve, please change the subnet or migrate to V2. Allow a day for the message to disappear once fixed  
  
**Potential benefits**: Avoid disruption in management of Application Gateway V1 resource  

**Impact:** High
  
For more information, see [Frequently asked questions about Application Gateway](/azure/application-gateway/application-gateway-faq#can-i-change-the-virtual-network-or-subnet-for-an-existing-application-gateway)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: df989782-82d1-420d-b354-71956bd9379c  
Subcategory: undefined

<!--df989782-82d1-420d-b354-71956bd9379c_end-->


<!--fa44bc92-1747-4cef-9f78-7861be4c0db9_begin-->

#### Reactivate the Subscription to unblock internal upgrade for V1 gateway  
  
Your Application Gateway is at risk of deletion after October 2024 due to a failed internal upgrade. This is because the subscription is set to a state other than Active. To fix this, please activate the subscription. Allow a day for this message to disappear once the issue is fixed.  
  
**Potential benefits**: Avoid disruption in management of Application Gateway V1 resource  

**Impact:** High
  
For more information, see [Reactivate a disabled Azure subscription - Microsoft Cost Management ](/azure/cost-management-billing/manage/subscription-disabled)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: fa44bc92-1747-4cef-9f78-7861be4c0db9  
Subcategory: BusinessContinuity

<!--fa44bc92-1747-4cef-9f78-7861be4c0db9_end-->

<!--17454550-1543-4068-bdaf-f3ed7cdd3d86_begin-->

#### Implement ExpressRoute Monitor on Network Performance Monitor  
  
When ExpressRoute circuit isn't monitored by ExpressRoute Monitor on Network Performance, you miss notifications of loss, latency, and performance of on-premises to Azure resources, and Azure to on-premises resources. For end-to-end monitoring, implement ExpressRoute Monitor on Network Performance.  
  
**Potential benefits**: Improve time-to-detect and time-to-mitigate issues in your network and provide insights on your network path via ExpressRoute  

**Impact:** Medium
  
For more information, see [Azure ExpressRoute: Configure NPM for circuits ](/azure/expressroute/how-to-npm)  

ResourceType: microsoft.network/expressroutecircuits  
Recommendation ID: 17454550-1543-4068-bdaf-f3ed7cdd3d86  
Subcategory: MonitoringAndAlerting

<!--17454550-1543-4068-bdaf-f3ed7cdd3d86_end-->

<!--5185d64e-46fd-4ed2-8633-6d81f5e3ca59_begin-->

#### Use managed TLS certificates  
  
When Front Door manages your TLS certificates, it reduces your operational costs, and helps you to avoid costly outages caused by forgetting to renew a certificate. Front Door automatically issues and rotates the managed TLS certificates.  
  
**Potential benefits**: Ensure service availability by having Front Door manage and rotate your certificates  

**Impact:** Medium
  
For more information, see [Azure Front Door - Best practices ](https://aka.ms/afd-use-managed-tls)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 5185d64e-46fd-4ed2-8633-6d81f5e3ca59  
Subcategory: Other

<!--5185d64e-46fd-4ed2-8633-6d81f5e3ca59_end-->

<!--589ab0b0-1362-44fd-8551-0e7847767600_begin-->

#### Consider having at least two origins  
  
Multiple origins support redundancy by distributing traffic across multiple instances of the application. If one instance is unavailable, then other backend origins can still receive traffic.  
  
**Potential benefits**: Increase your workload resiliency  

**Impact:** High
  
For more information, see [Azure Well-Architected Framework perspective on Azure Front Door - Microsoft Azure Well-Architected Framework ](https://aka.ms/afd-reliability-checklist)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 589ab0b0-1362-44fd-8551-0e7847767600  
Subcategory: HighAvailability

<!--589ab0b0-1362-44fd-8551-0e7847767600_end-->

<!--79f543f9-60e6-4ef6-ae42-2095f6149cba_begin-->

#### Use the same domain name on Front Door and your origin  
  
When you rewrite the Host header, request cookies and URL redirections might break. When you use platforms like Azure App Service, features like session affinity and authentication and authorization might not work correctly. Make sure to validate whether your application is going to work correctly.  
  
**Potential benefits**: Ensure application integrity by preserving original host name  

**Impact:** Medium
  
For more information, see [Azure Front Door - Best practices ](https://aka.ms/afd-same-domain-origin)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 79f543f9-60e6-4ef6-ae42-2095f6149cba  
Subcategory: Other

<!--79f543f9-60e6-4ef6-ae42-2095f6149cba_end-->

<!--825ff735-ed9a-4335-b132-321df86b0e81_begin-->

#### Avoid placing Traffic Manager behind Front Door  
  
Using Traffic Manager as one of the origins for Front Door isn't recommended, as this can lead to routing issues. If you need both services in a high availability architecture, always place Traffic Manager in front of Azure Front Door.  
  
**Potential benefits**: Increase your workload resiliency  

For more information, see [Best practices for Front Door](https://aka.ms/afd-avoid-tm-frontdoor)  

<!--825ff735-ed9a-4335-b132-321df86b0e81_end-->




<!--5db013ba-e657-4b80-93f7-8c5b5f9e780a_begin-->

#### Resolve issues for private endpoint not in succeeded state  
  
Private Endpoint not in a succeeded state potentially influences application availability and reliability. Healthy state of connectivity over private endpoints is crucial to reliably and securely access resources. Troubleshoot and resolve issues that cause a failed state.  
  
**Potential benefits**: Resume private connectivity and availability of application  

**Impact:** Medium
  
For more information, see [Troubleshoot Azure Private Link Service connectivity problems](https://aka.ms/pe-troubleshooting)  

ResourceType: microsoft.network/privateendpoints  
Recommendation ID: 5db013ba-e657-4b80-93f7-8c5b5f9e780a  
Subcategory: BusinessContinuity

<!--5db013ba-e657-4b80-93f7-8c5b5f9e780a_end-->





<!--6cd70072-c45c-4716-bf7b-b35c18e46e72_begin-->

#### Add at least one more endpoint to the profile, preferably in another Azure region  
  
Profiles need more than one endpoint to ensure availability if one of the endpoints fails. We also recommend that endpoints be in different regions.  
  
**Potential benefits**: Improve resiliency by allowing failover  

**Impact:** Medium
  
For more information, see [Traffic Manager Endpoint Types](https://aka.ms/AA1o0x4)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: 6cd70072-c45c-4716-bf7b-b35c18e46e72  
Subcategory: undefined

<!--6cd70072-c45c-4716-bf7b-b35c18e46e72_end-->


<!--0bbe0a49-3c63-49d3-ab4a-aa24198f03f7_begin-->

#### Add an endpoint configured to All (World)  
  
For geographic routing, traffic is routed to endpoints in defined regions. When a region fails, there is no pre-defined failover. Having an endpoint where the Regional Grouping is configured to All (World) for geographic profiles avoids traffic black holing and guarantees service availability.  
  
**Potential benefits**: Improve resiliency by avoiding traffic black holes  

**Impact:** High
  
For more information, see [Manage endpoints in Azure Traffic Manager](https://aka.ms/Rf7vc5)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: 0bbe0a49-3c63-49d3-ab4a-aa24198f03f7  
Subcategory: undefined

<!--0bbe0a49-3c63-49d3-ab4a-aa24198f03f7_end-->


<!--0db76759-6d22-4262-93f0-2f989ba2b58e_begin-->

#### Add or move one endpoint to another Azure region  
  
All endpoints associated to this proximity profile are in the same region. Users from other regions may experience long latency when attempting to connect. Adding or moving an endpoint to another region will improve overall performance for proximity routing and provide better availability if all endpoints in one region fail.  
  
**Potential benefits**: Improve resiliency by allowing failover to another region  

**Impact:** Medium
  
For more information, see [Configure performance traffic routing method using Azure Traffic Manager ](https://aka.ms/Ldkkdb)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: 0db76759-6d22-4262-93f0-2f989ba2b58e  
Subcategory: BusinessContinuity

<!--0db76759-6d22-4262-93f0-2f989ba2b58e_end-->

<!--e3489565-d891-406e-91d1-44f476563850_begin-->

#### ExpressRoute IP routes nearing specified limit  
  
Your ExpressRoute circuit is close to reaching its IP route limits. Exceeding these limits will disrupt the connectivity. Connectivity will restore once routes are within limit. Suggestions: Regularly monitor route counts. Explore Virtual WAN RouteMap to reduce advertised IP routes.  
  
**Potential benefits**: Prevent connectivity issues and ensure stability  

**Impact:** High
  
For more information, see [Azure Virtual WAN FAQ](https://aka.ms/mseeprefixtracking)  

ResourceType: microsoft.network/virtualhubs  
Recommendation ID: e3489565-d891-406e-91d1-44f476563850  
Subcategory: undefined

<!--e3489565-d891-406e-91d1-44f476563850_end-->


<!--e070c4bf-afaf-413e-bc00-e476b89c5f3d_begin-->

#### Move to production gateway SKUs from Basic gateways  
  
The Basic VPN SKU is for development or testing scenarios. If you're using the VPN gateway for production, move to a production SKU, which offers higher numbers of tunnels, Border Gateway Protocol (BGP), active-active configuration, custom IPsec/IKE policy, and increased stability and availability.  
  
**Potential benefits**: Additional available features and higher stability and availability  

**Impact:** Medium
  
For more information, see [Azure VPN Gateway configuration settings ](https://aka.ms/aa_basicvpngateway_learnmore)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: e070c4bf-afaf-413e-bc00-e476b89c5f3d  
Subcategory: HighAvailability

<!--e070c4bf-afaf-413e-bc00-e476b89c5f3d_end-->

<!--c249dc0e-9a17-423e-838a-d72719e8c5dd_begin-->

#### Enable Active-Active gateways for redundancy  
  
In active-active configuration, both instances of the VPN gateway establish site-to-site (S2S) VPN tunnels to your on-premise VPN device. When a planned maintenance or unplanned event happens to one gateway instance, traffic is automatically switched over to the other active IPsec tunnel.  
  
**Potential benefits**: Ensure business continuity through connection resilience  

**Impact:** Medium
  
For more information, see [Design highly available gateway connectivity - Azure VPN Gateway](https://aka.ms/aa_vpnha_learnmore)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: c249dc0e-9a17-423e-838a-d72719e8c5dd  
Subcategory: BusinessContinuity

<!--c249dc0e-9a17-423e-838a-d72719e8c5dd_end-->


<!--8d61a7d4-5405-4f43-81e3-8c6239b844a6_begin-->

#### Implement Site Resiliency for ExpressRoute  
  
To ensure maximum resiliency, the platform recommends connecting to two ExpressRoute circuits in two peering locations. The goal of maximum resiliency is to enhance availability and ensure the highest level of resilience for critical workloads.  
  
**Potential benefits**: Improve ExpressRoute uptime with Site Resilient Connectivity  

**Impact:** High
  
For more information, see [Design and architect Azure ExpressRoute for resiliency](https://aka.ms/ersiteresiliency)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 8d61a7d4-5405-4f43-81e3-8c6239b844a6  
Subcategory: HighAvailability

<!--8d61a7d4-5405-4f43-81e3-8c6239b844a6_end-->


<!--c9af1ef6-55bc-48af-bfe4-2c80490159f8_begin-->

#### Implement Zone Redundant ExpressRoute Gateways  
  
Implement zone-redundant Virtual Network Gateway in Azure Availability Zones. This brings resiliency, scalability, and higher availability to your Virtual Network Gateways.  
  
**Potential benefits**: Provides zone resiliency and redundancy for ExpressRoute  

**Impact:** High
  
For more information, see [Create a zone-redundant virtual network gateway in Azure availability zones - Azure VPN Gateway ](/azure/vpn-gateway/create-zone-redundant-vnet-gateway)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: c9af1ef6-55bc-48af-bfe4-2c80490159f8  
Subcategory: null

<!--c9af1ef6-55bc-48af-bfe4-2c80490159f8_end-->

<!--56f0c458-521d-4b8b-a704-c0a099483d19_begin-->

#### Use NAT gateway for outbound connectivity  
  
Prevent connectivity failures due to source network address translation (SNAT) port exhaustion by using NAT gateway for outbound traffic from your virtual networks. NAT gateway scales dynamically and provides secure connections for traffic headed to the internet.  
  
**Potential benefits**: Prevent outbound connection failures with NAT gateway  

**Impact:** Medium
  
For more information, see [Source Network Address Translation (SNAT) for outbound connections - Azure Load Balancer ](/azure/load-balancer/load-balancer-outbound-connections#2-associate-a-nat-gateway-to-the-subnet)  

ResourceType: microsoft.network/virtualnetworks  
Recommendation ID: 56f0c458-521d-4b8b-a704-c0a099483d19  
Subcategory: HighAvailability

<!--56f0c458-521d-4b8b-a704-c0a099483d19_end-->

<!--01c0dcd3-d6f7-4d50-a98b-4e15f9486a32_begin-->

#### Use a health probe for monitoring the health of servers  
  
Use a health probe of the application gateway for monitoring the health of servers in the backend pool. The health probe of the application gateway stops traffic from sending to a server the health probe considers unhealthy.  
  
**Potential benefits**: Prevent sending traffic to unhealthy server.  

**Impact:** High
  
For more information, see [Health monitoring overview for Azure Application Gateway](/azure/application-gateway/application-gateway-probe-overview)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 01c0dcd3-d6f7-4d50-a98b-4e15f9486a32  
Subcategory: undefined

<!--01c0dcd3-d6f7-4d50-a98b-4e15f9486a32_end-->



<!--1afa00b3-bb4c-496d-99e5-b7bda59a057c_begin-->

#### Configure and deploy VPN gateway and related resources to use availability zones  
  
Deploying zone-redundant virtual network gateways across availability zones ensures zone-resiliency, improving access to mission-critical, scalable services on Azure.  
  
**Potential benefits**: Improved availability and reliability  

**Impact:** High
  
For more information, see [About zone-redundant virtual network gateway in Azure availability zones - Azure VPN Gateway](/azure/vpn-gateway/about-zone-redundant-vnet-gateways?toc=%2Fazure%2Freliability%2Ftoc.json&bc=%2Fazure%2Freliability%2Fbreadcrumb%2Ftoc.json)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 1afa00b3-bb4c-496d-99e5-b7bda59a057c  
Subcategory: HighAvailability

<!--1afa00b3-bb4c-496d-99e5-b7bda59a057c_end-->

<!--e82f5b61-b0f8-48e7-8e18-5aa1f57bff81_begin-->

#### Deploy Azure Firewall across multiple availability zones  
  
Azure Firewall SLAs vary by deployment type such as single or multiple availability zones to improve reliability and performance.  
  
**Potential benefits**: Enhanced SLA and reliability  

**Impact:** High
  
For more information, see [Deploy Azure Firewall with Availability Zones using PowerShell](https://aka.ms/learnmore_firewalls)  

ResourceType: microsoft.network/azurefirewalls  
Recommendation ID: e82f5b61-b0f8-48e7-8e18-5aa1f57bff81  
Subcategory: HighAvailability

<!--e82f5b61-b0f8-48e7-8e18-5aa1f57bff81_end-->

<!--796b9be0-487d-4daa-8771-f08e4d7c9c0c_begin-->

#### Configure and deploy load balancers and related resources to use availability zones  
  
Standard Load Balancers and related resources configured to use availability zones offer resilience to zone faults. Assigning a zone-redundant frontend IP to a Standard Load Balancer ensures continuous traffic distribution even if one availability zone fails.  
  
**Potential benefits**: Improved availability and reliability  

**Impact:** High
  
For more information, see [Reliability in Azure Load Balancer](https://aka.ms/learnmore_loadbalancers)  

ResourceType: microsoft.network/loadbalancers  
Recommendation ID: 796b9be0-487d-4daa-8771-f08e4d7c9c0c  
Subcategory: HighAvailability

<!--796b9be0-487d-4daa-8771-f08e4d7c9c0c_end-->

<!--5b132ebc-bd86-46fc-b2ee-95bc3e2d3017_begin-->

#### Ensure backend pools contain at least two instances  
  
Deploying Azure Load Balancer backend pools with at least two instances prevents a single point of failure. Pairing with Virtual Machine Scale Sets can provide additional scalability.  
  
**Potential benefits**: Enhanced reliability and scalability  

**Impact:** High
  
For more information, see [Resiliency checklist for services - Azure Architecture Center](/azure/architecture/checklist/resiliency-per-service#azure-load-balancer)  

ResourceType: microsoft.network/loadbalancers  
Recommendation ID: 5b132ebc-bd86-46fc-b2ee-95bc3e2d3017  
Subcategory: HighAvailability

<!--5b132ebc-bd86-46fc-b2ee-95bc3e2d3017_end-->

<!--bc45d55d-3902-4505-8e34-ef8777bc6177_begin-->

#### Configure and deploy public IP addresses and related resources to use availability zones.  
  
Standard Public IP addresses and related resources configured to use availability zones offer resilience to zone faults.  Zone-aligned resources, or resources all in the same zone, offer  isolation protection from faults in other zones.  
  
**Potential benefits**: Improved uptime and application availability.  

**Impact:** High
  
For more information, see [Public IP addresses in Azure - Azure Virtual Network](https://aka.ms/learnmore_network_publicip)  

ResourceType: microsoft.network/publicipaddresses  
Recommendation ID: bc45d55d-3902-4505-8e34-ef8777bc6177  
Subcategory: HighAvailability

<!--bc45d55d-3902-4505-8e34-ef8777bc6177_end-->

<!--b4af9e04-3570-41f1-b4cf-b7af07224799_begin-->

#### Configure a maintenance configuration  
  
Configure a maintenance configuration to avoid upgrades during important service hours.  
  
**Potential benefits**: Improve reliability during important service hours.  

**Impact:** Low
  
For more information, see [Configure customer-controlled maintenance for your virtual network gateway - ExpressRoute](/azure/expressroute/customer-controlled-gateway-maintenance)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: b4af9e04-3570-41f1-b4cf-b7af07224799  
Subcategory: BusinessContinuity

<!--b4af9e04-3570-41f1-b4cf-b7af07224799_end-->

<!--cdf6b706-a12c-4b65-96b6-00cb125b7c26_begin-->

#### Use Standard SKU with zone-redundant IP addresses  
  
Use Standard SKU and deploy across three or more zones.  
  
**Potential benefits**: Ensures IP availability during zone failures  

**Impact:** High
  
For more information, see [Azure Public IP address prefix - Azure Virtual Network](/azure/virtual-network/public-ip-address-prefix)  

ResourceType: microsoft.network/publicipprefixes  
Recommendation ID: cdf6b706-a12c-4b65-96b6-00cb125b7c26  
Subcategory: HighAvailability

<!--cdf6b706-a12c-4b65-96b6-00cb125b7c26_end-->

<!--20f2ff6a-3940-4cc9-8f14-909466c4ddd0_begin-->

#### Traffic Manager monitor status should be online  
  
Monitor status should be online to ensure failover for application workload. If Traffic Manager's health shows degraded, one or more endpoints may also be degraded.  
  
**Potential benefits**: Ensures failover functionality  

**Impact:** High
  
For more information, see [Azure Traffic Manager endpoint monitoring](/azure/traffic-manager/traffic-manager-monitoring)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: 20f2ff6a-3940-4cc9-8f14-909466c4ddd0  
Subcategory: undefined

<!--20f2ff6a-3940-4cc9-8f14-909466c4ddd0_end-->


<!--80415aba-c979-4199-b093-873d3a31fec0_begin-->

#### Monitor health for Virtual WAN point-to-site VPN gateways  
  
Configure monitoring and alerts for point-to-site VPN gateways. Create alert rule to ensure prompt response for critical events including gateway over utilization, connection count limits, and user VPN route limits. Mission Critical workloads should use dual express routes instead of VPN.  
  
**Potential benefits**: Proactively detect and mitigate disruptions  

**Impact:** High
  
For more information, see [Monitor Azure Virtual WAN](/azure/virtual-wan/monitor-virtual-wan#point-to-site-vpn-gateway)  

ResourceType: microsoft.network/p2svpngateways  
Recommendation ID: 80415aba-c979-4199-b093-873d3a31fec0  
Subcategory: undefined

<!--80415aba-c979-4199-b093-873d3a31fec0_end-->

<!--c7b5d99f-9759-4a04-9e86-ff6a41e0902f_begin-->

#### Use version-less Key Vault secret identifier to reference the certificates  
  
To allow your application gateway resource to automatically retrieve a new certificate version, we strongly recommend using a version-less secret identifier, whenever available. For example: https://myvault.vault.azure.net/secrets/mysecret/  
  
**Potential benefits**: Ensure auto-rotation for new certificate versions  

**Impact:** High
  
For more information, see [TLS termination with Azure Key Vault certificates](https://aka.ms/agkvversion)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: c7b5d99f-9759-4a04-9e86-ff6a41e0902f  
Subcategory: undefined

<!--c7b5d99f-9759-4a04-9e86-ff6a41e0902f_end-->

<!--0e19257e-dcef-4d00-8de1-5fe1ae0fd948_begin-->

#### Application Gateway v1 has been retired. Migrate to Application Gateway v2.  
  
We announced the deprecation of Application Gateway V1 on April 28, 2023. Starting from April 28, 2026, we are retiring Application Gateway v1 SKU. If you use Application Gateway V1 SKU, start planning your migration to V2 now.  
  
**Potential benefits**: Plan your migration to v2 now.  

**Impact:** High
  
For more information, see [We're retiring Application Gateway V1 SKU in April 2026 - Azure Application Gateway](https://aka.ms/appgw/v1eol)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 0e19257e-dcef-4d00-8de1-5fe1ae0fd948  
Subcategory: undefined

<!--0e19257e-dcef-4d00-8de1-5fe1ae0fd948_end-->


<!--96e232d0-9b01-4e96-8c24-f9160ba3535a_begin-->

#### Standard and High-Performance VPN Gateway SKUs are being retired  
  
Basic SKU public IP addresses are retiring. The Standard and High-Performance SKUs that only accept Basic SKU public IP addresses are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=standard-and-highperformance-vpn-gateway-skus-will-be-retired-on-30-september-2025)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 96e232d0-9b01-4e96-8c24-f9160ba3535a  
Subcategory: undefined

<!--96e232d0-9b01-4e96-8c24-f9160ba3535a_end-->

<!--830e326a-d280-4d4e-887a-884d7d8994ce_begin-->

#### Monitor changes in Route Tables with Azure Monitor  
  
Create Alerts with Azure Monitor for operations like Create or Update Route Table to spot unauthorized and undesired changes in production resources. This setup aids in identifying improper routing changes, including efforts to evade firewalls or access resources from outside.  
  
**Potential benefits**: Enhanced security and change detection  

**Impact:** Medium
  
For more information, see [Azure Monitor activity log - Azure Monitor](/azure/azure-monitor/essentials/activity-log)  

ResourceType: microsoft.network/routetables  
Recommendation ID: 830e326a-d280-4d4e-887a-884d7d8994ce  
Subcategory: undefined

<!--830e326a-d280-4d4e-887a-884d7d8994ce_end-->

<!--a7ecaaaa-dc86-444b-8aad-e0773d5c2324_begin-->

#### Migrate to TLS 1.2 or above for Application Gateway  
  
Support for TLS 1.0 and 1.1 on Azure Application Gateway is retiring. Update the TLS policy for Application Gateway to the latest version.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/Azure-Application-Gateway-support-for-TLS-10-and-TLS-11-will-end-by-31-August-2025)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: a7ecaaaa-dc86-444b-8aad-e0773d5c2324  
Subcategory: undefined

<!--a7ecaaaa-dc86-444b-8aad-e0773d5c2324_end-->

<!--954daefb-e247-4e27-85c6-a212f9df5a53_begin-->

#### Migrate to virtual network flow logs  
  
Network security group (NSG) flow logs in Azure Network Watcher is retiring. As part of this retirement, customers will no longer be able to create new NSG flow logs. Migrate to virtual network flow logs in Network Watcher.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/Azure-NSG-flow-logs-Retirement)  

ResourceType: microsoft.network/networkwatchers/flowlogs  
Recommendation ID: 954daefb-e247-4e27-85c6-a212f9df5a53  
Subcategory: undefined

<!--954daefb-e247-4e27-85c6-a212f9df5a53_end-->

<!--articleBody-->
