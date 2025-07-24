---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Application Gateway
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Application Gateway  
  
<!--2ee9f31e-df58-4893-b3e7-66c0cd74183a_begin-->

#### Make sure you have enough instances in your Application Gateway to support your traffic  
  
Your Application Gateway has been running on high utilization recently and under heavy load, you may experience traffic loss or increase in latency. It's important that you scale your Application Gateway according to your traffic and with a bit of a buffer, so you are prepared for any traffic surges or spikes and minimizing the impact on your QoS Application Gateway v1 SKU (Standard/WAF) supports manual scaling and v2 SKU (Standard_v2/WAF_v2) support manual and autoscaling. In manual scaling, increase your instance count and if autoscaling is enabled, make sure your maximum instance count is set to a higher value so Application Gateway can scale out as the traffic increases.  
  
**Potential benefits**: Ensure availability of your sites  

**Impact:** Medium
  
For more information, see [Application Gateway high traffic volume support](https://aka.ms/hotappgw)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 2ee9f31e-df58-4893-b3e7-66c0cd74183a  


<!--2ee9f31e-df58-4893-b3e7-66c0cd74183a_end-->

<!--17ebccd8-1405-405c-8695-1981d115ffdc_begin-->

#### Delete and recreate your Azure Bastion resource before February 19, 2021  
  
We are unable to update your Azure Bastion resource due to its current configuration. Delete and recreate your resource before February 19, 2021 to receive the updates. If you do not delete and recreate your resource by this date, it's automatically deleted and recreated for you.  
  
**Potential benefits**: Receive necessary updates for your Azure Bastion resource.  

**Impact:** High
  
For more information, see [Tutorial: Deploy Azure Bastion using specified settings: Azure portal](/azure/bastion/tutorial-create-host-portal)  

ResourceType: microsoft.network/bastionhosts  
Recommendation ID: 17ebccd8-1405-405c-8695-1981d115ffdc  


<!--17ebccd8-1405-405c-8695-1981d115ffdc_end-->

<!--10b153b5-59d0-45ac-bb3f-6a0b7ad9c0cd_begin-->

#### Firewall policy is reaching network rule limitations.  
  
Your Azure Firewall deployment is reaching or exceeding 20,000 unique source/destinations in network rules.  Optimize network rule configuration and processing to prevent performance and latency issues.  
  
**Potential benefits**: Ensure Azure Firewall is configured to optimize performance.  

**Impact:** High
  
For more information, see [Azure Firewall best practices for performance](/azure/firewall/firewall-best-practices#recommendations)  

ResourceType: microsoft.network/firewallpolicies  
Recommendation ID: 10b153b5-59d0-45ac-bb3f-6a0b7ad9c0cd  


<!--10b153b5-59d0-45ac-bb3f-6a0b7ad9c0cd_end-->

<!--80b35b4e-1e5c-4ddf-835e-a774ce2ab81e_begin-->

#### Azure Firewall Policy: Rule Collection Group size is reaching limitation  
  
Your Rule Collection Group (RCG) in firewall policy is reaching 2 MB. Optimize Rule Collection Group (RCG) to prevent performance impact.  
  
**Potential benefits**: Ensure Azure Firewall is configured to optimize performance.  

**Impact:** High
  
For more information, see [Azure subscription and service limits, quotas, and constraints - Azure Resource Manager](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits)  

ResourceType: microsoft.network/firewallpolicies  
Recommendation ID: 80b35b4e-1e5c-4ddf-835e-a774ce2ab81e  


<!--80b35b4e-1e5c-4ddf-835e-a774ce2ab81e_end-->

<!--db00ef71-91ab-418a-a2ea-da45a678bb34_begin-->

#### Firewall policy is reaching IP Group limitations.  
  
Your Azure Firewall policy is reaching or exceeding the 200 IP Groups maximum. Consider reducing the quantity, adjusting the IP Group, or adjusting rule configurations to prevent performance and latency issues.  
  
**Potential benefits**: Ensure Azure Firewall is configured to optimize performance.  

**Impact:** High
  
For more information, see [Azure subscription and service limits, quotas, and constraints - Azure Resource Manager](/azure/azure-resource-manager/management/azure-subscription-service-limits#azure-firewall-limits)  

ResourceType: microsoft.network/firewallpolicies  
Recommendation ID: db00ef71-91ab-418a-a2ea-da45a678bb34  


<!--db00ef71-91ab-418a-a2ea-da45a678bb34_end-->

<!--241b9d61-3657-4096-85c3-83ad2a5f36e2_begin-->

#### Use HEAD health probes  
  
Health probes can use either the GET or HEAD HTTP methods. It's a good practice to use the HEAD method for health probes, which reduces the amount of traffic load on your origins.  
  
**Potential benefits**: Reduce traffic load on your origins  

**Impact:** Medium
  
For more information, see [Azure Front Door - Best practices](https://aka.ms/afd-use-health-probes)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 241b9d61-3657-4096-85c3-83ad2a5f36e2  


<!--241b9d61-3657-4096-85c3-83ad2a5f36e2_end-->

<!--b020ff96-37bf-4a64-8bd5-2bfb3fdf3f87_begin-->

#### Configure DNS Time to Live to 20 seconds  
  
Time to Live (TTL) affects how recent of a response a client gets when it makes a request to Azure Traffic Manager. Reducing the TTL value means that the client is routed to a functioning endpoint faster in the case of a failover. Configure your TTL to 20 seconds to route traffic to a health endpoint as quickly as possible.  
  
**Potential benefits**: Improve availability by failing over to healthy endpoints  

**Impact:** High
  
For more information, see [Azure Traffic Manager endpoint monitoring](https://aka.ms/Ngfw4r)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: b020ff96-37bf-4a64-8bd5-2bfb3fdf3f87  


<!--b020ff96-37bf-4a64-8bd5-2bfb3fdf3f87_end-->

<!--d374a732-e69b-41dc-bbc2-a7234e2270be_begin-->

#### Configure DNS Time to Live to 60 seconds  
  
Time to Live (TTL) affects how recent of a response a client gets when it makes a request to Azure Traffic Manager. Reducing the TTL value means that the client is routed to a functioning endpoint faster in the case of a failover. Configure your TTL to 60 seconds to route traffic to a health endpoint as quickly as possible.  
  
**Potential benefits**: Improve availability by failing over to healthy endpoints faster  

**Impact:** Medium
  
For more information, see [Azure Traffic Manager endpoint monitoring](https://aka.ms/Um3xr5)  

ResourceType: microsoft.network/trafficmanagerprofiles  
Recommendation ID: d374a732-e69b-41dc-bbc2-a7234e2270be  


<!--d374a732-e69b-41dc-bbc2-a7234e2270be_end-->

<!--f78c8e26-9c40-4a74-a091-f76aecb49099_begin-->

#### Consider increasing the size of your VNet Gateway SKU to address high P2S use  
  
Each gateway SKU can only support a specified count of concurrent P2S connections. Your connection count is close to your gateway limit, so more connection attempts may fail.  
  
**Potential benefits**: Increasing the size of your gateway allows you to support more concurrent P2S users  

**Impact:** High
  
  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: f78c8e26-9c40-4a74-a091-f76aecb49099  


<!--f78c8e26-9c40-4a74-a091-f76aecb49099_end-->

<!--2e41fe84-7173-4fe9-b257-61aa4679c3fe_begin-->

#### Consider increasing the size of your VNet Gateway SKU to address consistently high CPU use  
  
Under high traffic load, the VPN gateway may drop packets due to high CPU. You should consider upgrading your VPN Gateway SKU since your VPN has consistently been running.  
  
**Potential benefits**: Increasing the size of your VPN gateway ensures that connections aren't dropped due to high CPU  

**Impact:** High
  
For more information, see [Virtual machine sizes overview - Azure Virtual Machines](https://aka.ms/HighCPUP2SVNetGateway)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 2e41fe84-7173-4fe9-b257-61aa4679c3fe  


<!--2e41fe84-7173-4fe9-b257-61aa4679c3fe_end-->

<!--83d8749f-cbdd-4268-9a7b-bc0512f36fca_begin-->

#### Convert the ExpressRoute legacy connections  
  
ExpressRoute gateways need ongoing maintenance. The platform upgrades aging hardware to ensure reliability, availability, security, and performance. Most upgrades are seamless, but some affect deployments. Gateways connected before 2017 may not perform optimally.  
  
**Potential benefits**: Improved performance on newer hardware  

**Impact:** High
  
For more information, see [How to convert your legacy ExpressRoute gateway connections](https://aka.ms/exr-recreatelegacyconnections)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 83d8749f-cbdd-4268-9a7b-bc0512f36fca  


<!--83d8749f-cbdd-4268-9a7b-bc0512f36fca_end-->

<!--ad65c036-7bb0-4f2e-9059-e4bea4799412_begin-->

#### Update the prefix to be smaller than the maximum prefix limit  
  
Update the prefix to be smaller than the maximum prefix limit for the ExpressRoute virtual network gateway. The ExpressRoute virtual network gateway allows a maximum of 11000 prefixes.  
  
**Potential benefits**: Prevent loss of connectivity.  

**Impact:** High
  
For more information, see [Azure subscription and service limits, quotas, and constraints - Azure Resource Manager](https://aka.ms/ExRGatewayPrefixLimit)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: ad65c036-7bb0-4f2e-9059-e4bea4799412  


<!--ad65c036-7bb0-4f2e-9059-e4bea4799412_end-->

<!--articleBody-->
