---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Application Gateway
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Application Gateway  
  
<!--2ee9f31e-df58-4893-b3e7-66c0cd74183a_begin-->

#### Verify enough instances exist in the Application Gateway for the traffic  
  
The Application Gateway is under high utilization and faces latency or traffic loss. Scale with buffer capacity. The v1 SKU supports manual scaling. The v2 SKU supports manual and autoscaling. Set a high maximum instance count to handle spikes.  
  
**Potential benefits**: Ensure availability of your sites  

**Impact:** Medium
  
For more information, see [Application Gateway high traffic volume support](https://aka.ms/hotappgw)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: 2ee9f31e-df58-4893-b3e7-66c0cd74183a  

<!--2ee9f31e-df58-4893-b3e7-66c0cd74183a_end-->

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

#### Firewall policy is reaching limitation of 600 IP Groups  
  
The Azure Firewall policy is reaching or exceeded the maximum limit of 600 IP Groups. Prevent performance and latency issues by reducing the quantity of IP Groups, adjusting the IP Group, or adjusting rule configurations.  
  
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

<!--83d8749f-cbdd-4268-9a7b-bc0512f36fca_begin-->

#### Convert the ExpressRoute legacy connections  
  
ExpressRoute gateways need ongoing maintenance. The platform upgrades aging hardware to ensure reliability, availability, security, and performance. Most upgrades are seamless, but some affect deployments. Gateways connected before 2017 may not perform optimally.  
  
**Potential benefits**: Improved performance on newer hardware  

**Impact:** High
  
For more information, see [How to convert your legacy ExpressRoute gateway connections](https://aka.ms/exr-recreatelegacyconnections)  

ResourceType: microsoft.network/virtualnetworkgateways  
Recommendation ID: 83d8749f-cbdd-4268-9a7b-bc0512f36fca  

<!--83d8749f-cbdd-4268-9a7b-bc0512f36fca_end-->

<!--ef4da732-f541-4109-bc0e-465c68b6c7eb_begin-->

#### A minimum subnet size of /24 is recommended for Application Gateway v2 subnets  
  
Application Gateway (Standard_v2 or WAF_v2 SKU) can support up to 125 instances (125 instance IP addresses + 1 private frontend IP configuration + 5 Azure reserved). A minimum subnet size of /24 is recommended.  
  
**Potential benefits**: Enough room for scalability  

**Impact:** High
  
For more information, see [Azure Application Gateway infrastructure configuration](https://aka.ms/appgw/infra)  

ResourceType: microsoft.network/applicationgateways  
Recommendation ID: ef4da732-f541-4109-bc0e-465c68b6c7eb  

<!--ef4da732-f541-4109-bc0e-465c68b6c7eb_end-->

<!--articleBody-->
