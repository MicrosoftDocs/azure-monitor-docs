---
ms.service: azure
ms.topic: include
ms.date: 02/24/2025
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
  
For more information, see [Frequently asked questions about Application Gateway ](/azure/application-gateway/application-gateway-faq#can-i-change-the-virtual-network-or-subnet-for-an-existing-application-gateway)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 511a9f7b-7b5e-4713-b18d-0b7464a84d1f  
Subcategory: BusinessContinuity

<!--511a9f7b-7b5e-4713-b18d-0b7464a84d1f_end-->

<!--5c488377-be3e-4365-92e8-09d1e8d9038c_begin-->

#### Deploy your Application Gateway across Availability Zones  
  
Achieve zone redundancy by deploying Application Gateway across Availability Zones. Zone redundancy boosts resilience by enabling Application Gateway to survive various outages. Zone redundancy ensures continuity even if one zone is affected and enhances overall reliability.  
  
**Potential benefits**: Resiliency of Application Gateways is considerably increased when using Availability Zones.  

**Impact:** High
  
For more information, see [Scaling and Zone-redundant Application Gateway v2 ](https://aka.ms/appgw/az)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 5c488377-be3e-4365-92e8-09d1e8d9038c  
Subcategory: HighAvailability

<!--5c488377-be3e-4365-92e8-09d1e8d9038c_end-->

<!--6cc8be07-8c03-4bd7-ad9b-c2985b261e01_begin-->

#### Update VNet permission of Application Gateway users  
  
To improve security and provide a more consistent experience across Azure, all users must pass a permission check to create or update an Application Gateway in a Virtual Network. The users or service principals minimum permission required is Microsoft.Network/virtualNetworks/subnets/join/action.  
  
**Potential benefits**: Avoid disruptions in management of Application Gateway resource  

**Impact:** High
  
For more information, see [Azure Application Gateway infrastructure configuration ](https://aka.ms/agsubnetjoin)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 6cc8be07-8c03-4bd7-ad9b-c2985b261e01  
Subcategory: Other

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
  
For more information, see [Frequently asked questions about Application Gateway ](/azure/application-gateway/application-gateway-faq#can-i-change-the-virtual-network-or-subnet-for-an-existing-application-gateway)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: df989782-82d1-420d-b354-71956bd9379c  
Subcategory: BusinessContinuity

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

For more information, see [Troubleshoot Azure Private Link Service connectivity problems](https://aka.ms/pe-troubleshooting)  

<!--5db013ba-e657-4b80-93f7-8c5b5f9e780a_end-->




<!--6cd70072-c45c-4716-bf7b-b35c18e46e72_begin-->

#### Add at least one more endpoint to the profile, preferably in another Azure region  
  
Profiles need more than one endpoint to ensure availability if one of the endpoints fails. We also recommend that endpoints be in different regions.  
  
**Potential benefits**: Improve resiliency by allowing failover  

**Impact:** Medium
  
For more information, see [Traffic Manager Endpoint Types ](https://aka.ms/AA1o0x4)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: 6cd70072-c45c-4716-bf7b-b35c18e46e72  
Subcategory: BusinessContinuity

<!--6cd70072-c45c-4716-bf7b-b35c18e46e72_end-->

<!--0bbe0a49-3c63-49d3-ab4a-aa24198f03f7_begin-->

#### Add an endpoint configured to "All (World)"  
  
For geographic routing, traffic is routed to endpoints in defined regions. When a region fails, there is no pre-defined failover. Having an endpoint where the Regional Grouping is configured to "All (World)" for geographic profiles avoids traffic black holing and guarantees service availability.  
  
**Potential benefits**: Improve resiliency by avoiding traffic black holes  

**Impact:** High
  
For more information, see [Manage endpoints in Azure Traffic Manager ](https://aka.ms/Rf7vc5)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: 0bbe0a49-3c63-49d3-ab4a-aa24198f03f7  
Subcategory: BusinessContinuity

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
  
Your ExpressRoute circuit is close to reaching its IP route limits. Exceeding these limits will disrupt the connectivity. Connectivity will restore once routes are within limits
Suggestions:
Regularly monitor route counts.
Explore Virtual WAN RouteMap to reduce advertised IP routes.  
  
**Potential benefits**: Monitoring IP route counts prevents connectivity issues and ensures stability.  

**Impact:** High
  
For more information, see [Azure Virtual WAN FAQ ](https://aka.ms/mseeprefixtracking)  

ResourceType: microsoft.network/virtualhubs  
Recommendation ID: e3489565-d891-406e-91d1-44f476563850  
Subcategory: HighAvailability

<!--e3489565-d891-406e-91d1-44f476563850_end-->

<!--70f87e66-9b2d-4bfa-ae38-1d7d74837689_begin-->

#### Implement multiple ExpressRoute circuits in your Virtual Network for cross premises resiliency  
  
When an ExpressRoute gateway only has one ExpressRoute circuit associated to it, resiliency issues might occur. To ensure peering location redundancy and resiliency, connect one or more additional circuits to your gateway.  
  
**Potential benefits**: Improve resiliency in case of ExpressRoute peering location failure  

**Impact:** Medium
  
For more information, see [Azure ExpressRoute: Designing for high availability ](/azure/expressroute/designing-for-high-availability-with-expressroute)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 70f87e66-9b2d-4bfa-ae38-1d7d74837689  
Subcategory: BusinessContinuity

<!--70f87e66-9b2d-4bfa-ae38-1d7d74837689_end-->

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
  
For more information, see [Design highly available gateway connectivity - Azure VPN Gateway ](https://aka.ms/aa_vpnha_learnmore)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: c249dc0e-9a17-423e-838a-d72719e8c5dd  
Subcategory: BusinessContinuity

<!--c249dc0e-9a17-423e-838a-d72719e8c5dd_end-->

<!--8d61a7d4-5405-4f43-81e3-8c6239b844a6_begin-->

#### Implement Site Resiliency for ExpressRoute  
  
To ensure maximum resiliency, Microsoft recommends that you connect to two ExpressRoute circuits in two peering locations. The goal of Maximum Resiliency is to enhance availability and ensure the highest level of resilience for critical workloads.  
  
**Potential benefits**: Maximum Resiliency in ExpressRoute is designed to ensure there isn’t a single point of failure within the Microsoft network path. This is achieved by offering dual (2) circuits across two different locations for site diversity in ExpressRoute. The goal of Maximum Resiliency is to enhance availability and ensure the highest level of resilience for critical workloads.  

**Impact:** High
  
For more information, see [Design and architect Azure ExpressRoute for resiliency ](https://aka.ms/ersiteresiliency)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 8d61a7d4-5405-4f43-81e3-8c6239b844a6  
Subcategory: null

<!--8d61a7d4-5405-4f43-81e3-8c6239b844a6_end-->

<!--c9af1ef6-55bc-48af-bfe4-2c80490159f8_begin-->

#### Implement Zone Redundant ExpressRoute Gateways  
  
Implement zone-redundant Virtual Network Gateway in Azure Availability Zones. This brings resiliency, scalability, and higher availability to your Virtual Network Gateways.  
  
**Potential benefits**: Provides zonal resiliency and redundancy for ExpressRoute  

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
  
For more information, see [Health monitoring overview for Azure Application Gateway ](/azure/application-gateway/application-gateway-probe-overview)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 01c0dcd3-d6f7-4d50-a98b-4e15f9486a32  
Subcategory: Scalability

<!--01c0dcd3-d6f7-4d50-a98b-4e15f9486a32_end-->

<!--articleBody-->
