---
ms.service: azure
ms.topic: include
ms.date: 10/28/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Application Gateway
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Application Gateway  
  
<!--0e19257e-dcef-4d00-8de1-5fe1ae0fd948_begin-->

#### Application Gateway v1 has been retired. Migrate to Application Gateway v2.  
  
We announced the deprecation of Application Gateway V1 on April 28, 2023. Starting from April 28, 2026, we are retiring Application Gateway v1 SKU. If you use Application Gateway V1 SKU, start planning your migration to V2 now.  
  
**Potential benefits**: Plan your migration to v2 now.  

**Impact:** High
  
For more information, see [We're retiring Application Gateway V1 SKU in April 2026 - Azure Application Gateway](https://aka.ms/appgw/v1eol)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 0e19257e-dcef-4d00-8de1-5fe1ae0fd948  


<!--0e19257e-dcef-4d00-8de1-5fe1ae0fd948_end-->

<!--3467464b-955a-4caf-95e5-547344ba0281_begin-->

#### Resolve Azure Key Vault issue for your Application Gateway  
  
We detected that one or more of your Application Gateways is unable to obtain a certificate due to misconfigured Key Vault. You should fix this configuration immediately to avoid operational issues with your gateway.  
  
**Potential benefits**: Resolve control plane failures and data plane downtime  

**Impact:** High
  
For more information, see [Common key vault errors in Application Gateway - Azure Application Gateway](https://aka.ms/agkverror)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 3467464b-955a-4caf-95e5-547344ba0281  


<!--3467464b-955a-4caf-95e5-547344ba0281_end-->

<!--47ee7abd-4f5e-45d7-9d9f-d0329616fef9_begin-->

#### Upgrade your legacy WAF configuration to WAF policies  
  
WAF policies offer a richer set of advanced features: newer managed rule sets, custom rules, per rule exclusions, bot protection, and the next generation of WAF engine. Policies provide higher scale and better performance. It can be defined once and shared across gateways, listeners, and URL paths.  
  
**Potential benefits**: Richer feature set, improved performance and scalability  

**Impact:** High
  
For more information, see [Upgrade to Azure Application Gateway WAF policy](https://aka.ms/upgradewafpolicy)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 47ee7abd-4f5e-45d7-9d9f-d0329616fef9  


<!--47ee7abd-4f5e-45d7-9d9f-d0329616fef9_end-->

<!--884975b5-12b5-433d-a633-904d8db75c5f_begin-->

#### Fix DNS configuration causing resolution failures  
  
One or more of the Application Gateways are facing DNS resolution failures due to misconfiguration in the DNS configuration.  
  
**Potential benefits**: Prevents PUT failures or datapath issues within a Gateway.  

**Impact:** High
  
For more information, see [Azure Virtual Network Name Resolution Guide](https://aka.ms/azurednsresolution)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 884975b5-12b5-433d-a633-904d8db75c5f  


<!--884975b5-12b5-433d-a633-904d8db75c5f_end-->


<!--ea000e01-b053-4076-a61b-e4cc58e9db07_begin-->

#### Remove the conflicting private frontend IP configuration  
  
The update operations on the gateway are failing due to conflicts with static private IP addresses. To resolve the issue, remove the conflicting frontend IP configuration. Allow a day for the message to disappear after fixed.  
  
**Potential benefits**: Avoid disruption in management of Application Gateway V1  

**Impact:** High
  
For more information, see [Remove-AzApplicationGatewayFrontendIPConfig (Az.Network)](https://aka.ms/removeFrontEndIpConfig)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: ea000e01-b053-4076-a61b-e4cc58e9db07  


<!--ea000e01-b053-4076-a61b-e4cc58e9db07_end-->




<!--7aaefe5a-5b88-4790-9a3d-5106722f7c34_begin-->

#### Upgrade to the latest DRS rule set in Application Gateway WAF  
  
WAF rule sets are constantly updated to guard against new attacks. Upgrading to the latest DRS version will provide enhanced engine performance, better protection, and a reduction in false positives. It's recommended to use the latest DRS rule set version.  
  
**Potential benefits**: Ensure increased efficiency and better protection  

**Impact:** High
  
For more information, see [CRS and DRS rule groups and rules - Azure Web Application Firewall](https://aka.ms/appgwwafruleset)  

ResourceType: microsoft.network/applicationgatewaywebapplicationfirewallpolicies  
Recommendation ID: 7aaefe5a-5b88-4790-9a3d-5106722f7c34  


<!--7aaefe5a-5b88-4790-9a3d-5106722f7c34_end-->

<!--aa60b18a-feab-4857-8d9a-e4f6a8d3ef0e_begin-->

#### Upgrade from legacy CRS 2.2.9 rule set to the latest DRS version  
  
Usage of CRS 2.2.9 is no longer supported for new WAF policies. We recommend you upgrade to the latest DRS version. Upgrading to DRS 2.1 or later will migrate WAF to a newer engine with larger scale limits, enhanced performance, better protection and fewer false positive.  
  
**Potential benefits**: CRS 2.2.9 is no longer supported for new WAF policies  

**Impact:** High
  
For more information, see [CRS and DRS rule groups and rules - Azure Web Application Firewall](https://aka.ms/appgwwafruleset)  

ResourceType: microsoft.network/applicationgatewaywebapplicationfirewallpolicies  
Recommendation ID: aa60b18a-feab-4857-8d9a-e4f6a8d3ef0e  


<!--aa60b18a-feab-4857-8d9a-e4f6a8d3ef0e_end-->

<!--fd86a3fc-2048-46a7-8ea1-d859cecf54ef_begin-->

#### Upgrade to the latest bot protection rule set in Application Gateway WAF  
  
Bot protection in Web Application Firewall (WAF) will protect you application against malicious bots, crawlers and scanners. Using the latest version of bot Protection rule set will ensure the WAF engine will apply the latest rules.  
  
**Potential benefits**: Ensure increased efficiency and protection against bots  

**Impact:** Medium
  
For more information, see [What is Azure Web Application Firewall on Azure Application Gateway?](https://aka.ms/appgwwafbotrs)  

ResourceType: microsoft.network/applicationgatewaywebapplicationfirewallpolicies  
Recommendation ID: fd86a3fc-2048-46a7-8ea1-d859cecf54ef  


<!--fd86a3fc-2048-46a7-8ea1-d859cecf54ef_end-->

<!--8cf57fc1-66ee-4089-a92f-29b9fdb27ea7_begin-->

#### Configure Connection Monitor for ExpressRoute  
  
Connection Monitor is part of Azure Monitor logs. The extension also lets you monitor network connectivity for your private and Microsoft peering connections. When you configure Connection Monitor for ExpressRoute, you can detect network issues to identify and eliminate.  
  
**Potential benefits**: Provides monitoring of your ExpressRoute circuits for latency, point in time issues, and performance.  

**Impact:** Medium
  
For more information, see [Configure Connection Monitor for Azure ExpressRoute](https://aka.ms/exrcm)  

ResourceType: microsoft.network/expressroutecircuits  
Recommendation ID: 8cf57fc1-66ee-4089-a92f-29b9fdb27ea7  


<!--8cf57fc1-66ee-4089-a92f-29b9fdb27ea7_end-->

<!--14368063-38db-4dd6-a755-9c49ff123a5e_begin-->

#### Migrate Azure Front Door (classic) to Standard/Premium tier  
  
In March 2027, Azure Front Door (classic) will be retired, and you’ll need to migrate to Front Door Standard or Premium by that date. It combines the capabilities of static/dynamic content delivery with turnkey security, enhanced DevOps experiences, simplified pricing, and better Azure integrations.  
  
**Potential benefits**: Avoid potential disruptions and leverage new capabilities  

**Impact:** Medium
  
For more information, see [Migrate Azure Front Door (classic) to Standard or Premium tier](https://aka.ms/afd-migrate)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 14368063-38db-4dd6-a755-9c49ff123a5e  


<!--14368063-38db-4dd6-a755-9c49ff123a5e_end-->

<!--a1ad465b-8218-40d6-a6ce-4bfff566a6cd_begin-->

#### Upgrade to the latest DRS rule set in Front Door WAF  
  
WAF rule sets are constantly updated to guard against new attacks. Upgrading to the latest DRS version will provide enhanced engine performance, better protection, and a reduction in false positives. It's recommended to use the latest DRS rule set version.  
  
**Potential benefits**: Ensure increased efficiency and better protection  

**Impact:** High
  
  

ResourceType: microsoft.network/frontdoorwebapplicationfirewallpolicies  
Recommendation ID: a1ad465b-8218-40d6-a6ce-4bfff566a6cd  


<!--a1ad465b-8218-40d6-a6ce-4bfff566a6cd_end-->


<!--c7a883a4-fda2-4bcd-9f78-dad70c19429f_begin-->

#### Add explicit outbound method to disable default outbound  
  
Use an explicit connectivity method such as NAT gateway or a Public IP. After March 31, 2026, new virtual networks will default to creation of private subnets, which are intentionally designed to block default outbound access connectivity.  
  
**Potential benefits**: Secure and explicit outbound access for new subnets.  

**Impact:** Medium
  
For more information, see [Default Outbound Access in Azure - Azure Virtual Network](https://aka.ms/defaultoutboundretirement)  

ResourceType: microsoft.network/networkinterfaces  
Recommendation ID: c7a883a4-fda2-4bcd-9f78-dad70c19429f  


<!--c7a883a4-fda2-4bcd-9f78-dad70c19429f_end-->


<!--7c27d589-c7ed-47e1-8fe9-fe12ea81634a_begin-->

#### Enable Traffic Analytics to view insights into traffic patterns across Azure resources  
  
Traffic Analytics is a cloud-based solution that provides visibility into user and application activity in Azure. Traffic analytics analyzes Network Watcher network security group (NSG) flow logs to provide insights into traffic flow. With traffic analytics, you can view top talkers across Azure and non Azure deployments, investigate open ports, protocols and malicious flows in your environment and optimize your network deployment for performance. You can process flow logs at 10 mins and 60 mins processing intervals, giving you faster analytics on your traffic.  
  
**Potential benefits**: Identify top talkers, traffic hotspots, resource utilisation and security based on traffic patterns in NSG  

**Impact:** High
  
For more information, see [Traffic analytics overview - Azure Network Watcher](https://aka.ms/aa_enableta_learnmore)  

ResourceType: microsoft.network/networksecuritygroups  
Recommendation ID: 7c27d589-c7ed-47e1-8fe9-fe12ea81634a  


<!--7c27d589-c7ed-47e1-8fe9-fe12ea81634a_end-->

<!--6f087e7e-afdf-4a3d-a1de-41d70404b9cb_begin-->

#### Upgrade from network security group flow log to Virtual Network flow log  
  
Upgrade from a network security group flow log to a Virtual Network flow log. A Virtual Network flow log allows recording of IP traffic flow in a virtual network.  
  
**Potential benefits**: Improved coverage, observability, and accuracy.  

**Impact:** High
  
For more information, see [Virtual network flow logs - Azure Network Watcher](https://aka.ms/vnetflowlogs)  

ResourceType: microsoft.network/networkwatchers/flowlogs  
Recommendation ID: 6f087e7e-afdf-4a3d-a1de-41d70404b9cb  


<!--6f087e7e-afdf-4a3d-a1de-41d70404b9cb_end-->

<!--dedaaba3-b5aa-4e91-a12e-6886ba0b2f6d_begin-->

#### Configure Connection Monitor for ExpressRoute Gateway  
  
Connection Monitor is part of Azure Monitor logs. The extension also lets you monitor network connectivity for your private and Microsoft peering connections. When you configure Connection Monitor for ExpressRoute, you can detect network issues to identify and eliminate.  
  
**Potential benefits**: Provides monitoring of your ExpressRoute gateway for latency, point in time issues, and performance.  

**Impact:** Medium
  
For more information, see [Configure Connection Monitor for Azure ExpressRoute](https://aka.ms/exrcm)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: dedaaba3-b5aa-4e91-a12e-6886ba0b2f6d  


<!--dedaaba3-b5aa-4e91-a12e-6886ba0b2f6d_end-->

<!--f8d4da72-3b27-4dd7-839c-bd69b9b95111_begin-->

#### VNet with more than 5 peerings should be managed using AVNM connectivity configuration  
  
VNet with more than 5 peerings should be managed using AVNM connectivity configuration. Azure Virtual Network Manager is a management service that enables you to group, configure, deploy, and manage virtual networks globally across subscriptions.  
  
**Potential benefits**: Operational excellence will be increased and more reliable.  

**Impact:** Medium
  
  

ResourceType: microsoft.network/virtualnetworks  
Recommendation ID: f8d4da72-3b27-4dd7-839c-bd69b9b95111  


<!--f8d4da72-3b27-4dd7-839c-bd69b9b95111_end-->

<!--8a885111-34c0-4fd6-bb77-dbbb844ad7e5_begin-->

#### Monitor Azure Firewall Metrics  
  
Monitor Azure Firewall for overall health, processed throughput, and outbound SNAT port usage. Get alerted before limits affect services. Consider NAT gateway integration with zonal deployments; Take into account limitations with zone redundant Firewalls and Secure Virtual Hub Networks.  
  
**Potential benefits**: Improve health and performance monitoring.  

**Impact:** High
  
For more information, see [Azure Monitor supported metrics by resource type - Azure Monitor](/azure/azure-monitor/reference/metrics-index#microsoftnetworkazurefirewalls)  

ResourceType: microsoft.network/azurefirewalls  
Recommendation ID: 8a885111-34c0-4fd6-bb77-dbbb844ad7e5  


<!--8a885111-34c0-4fd6-bb77-dbbb844ad7e5_end-->

<!--8abe4b22-d8ad-4bff-babe-38b9267e46b7_begin-->

#### Monitor health for virtual hubs  
  
Configure monitoring and alerts for virtual hubs. Create alert rule to ensure prompt response to changes in BGP status and data processed by virtual hubs.  
  
**Potential benefits**: Detect and mitigate issues to avoid disruptions.  

**Impact:** Medium
  
For more information, see [Monitor Azure Virtual WAN](/azure/virtual-wan/monitor-virtual-wan#virtual-hub)  

ResourceType: microsoft.network/virtualhubs  
Recommendation ID: 8abe4b22-d8ad-4bff-babe-38b9267e46b7  


<!--8abe4b22-d8ad-4bff-babe-38b9267e46b7_end-->


<!--37652095-cbe3-4132-9c62-526eeb6f4d75_begin-->

#### Migrate from Basic to Standard Virtual WAN  
  
Basic tier isn't recommended for critical workloads. Standard tier provides important features including Inter-hub and VNet-to-VNet transiting through the virtual hub, ExpressRoute, VPN and Point-to-Site Gateways, ability to deploy Azure Firewalls and NVAs.  
  
**Potential benefits**: Full Mesh communication and resiliency  

**Impact:** High
  
For more information, see [Upgrade Virtual WAN - Basic SKU type to Standard - Azure Virtual WAN](/azure/virtual-wan/upgrade-virtual-wan)  

ResourceType: microsoft.network/virtualhubs  
Recommendation ID: 37652095-cbe3-4132-9c62-526eeb6f4d75  


<!--37652095-cbe3-4132-9c62-526eeb6f4d75_end-->

<!--articleBody-->
