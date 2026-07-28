---
ms.service: azure
ms.topic: include
ms.date: 07/28/2026
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Subscriptions
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Subscriptions

<!--a58fd47f-d7b9-49dc-b763-c511d8774639_begin-->

#### Subscription with more than 10 VNets should be managed using AVNM  
  
Subscription with more than 10 VNets should be managed using AVNM. Azure Virtual Network Manager is a management service that enables you to group, configure, deploy, and manage virtual networks globally across subscriptions.  
  
**Potential benefits**: Operational excellence will be increased and more reliable.  

**Impact:** Medium
  
For more information, see [Azure Virtual Network Manager documentation](/azure/virtual-network-manager/)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: a58fd47f-d7b9-49dc-b763-c511d8774639  


<!--a58fd47f-d7b9-49dc-b763-c511d8774639_end-->

<!--f52ed1b8-9d60-469c-b1d8-b671043fe264_begin-->

#### Upgrade to latest version of carbon optimization API  
  
Upgrade the carbon optimization API version to 2025-04-01 for updated features and access to a more scalable API. The newer version improves performance and efficiency while managing carbon optimization tasks.  
  
**Potential benefits**: Access to new features and a more scalable API.  

**Impact:** Low
  
For more information, see [Azure Carbon Optimization REST APIs (Preview)](/rest/api/carbon/)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: f52ed1b8-9d60-469c-b1d8-b671043fe264  


<!--f52ed1b8-9d60-469c-b1d8-b671043fe264_end-->

<!--c19f3817-e270-4989-aff6-dc3927cc0e74_begin-->

#### Virtual networks aren't managed by IP Address Manager (IPAM)  
  
One or more virtual networks in this subscription aren't managed by IP Address Manager (IPAM). Associate them with IPAM pools to centrally track IP allocation, prevent address space overlaps, and simplify network planning.  
  
**Potential benefits**: Centralized IP address management and overlap prevention  

**Impact:** Medium
  
For more information, see [What is IP address management (IPAM) in Azure Virtual Network Manager?](/azure/virtual-network-manager/concept-ip-address-management)  

ResourceType: microsoft.subscriptions/subscriptions  
Recommendation ID: c19f3817-e270-4989-aff6-dc3927cc0e74  


<!--c19f3817-e270-4989-aff6-dc3927cc0e74_end-->

<!--articleBody-->
