---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Application Gateway
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Application Gateway  
  
<!--1c7fc5ab-f776-4aee-8236-ab478519f68f_begin-->

#### Disable health probes when there's only one origin in an origin group  
  
We recommend having at least two origins for resiliency. However, if only a single origin is available, Azure Front Door will continue to route traffic to it regardless of the health probe status. In such cases, health probes don't influence Front Door's routing behavior and offer no benefits.  
  
**Potential benefits**: Save on bandwidth costs by disabling health probes  

**Impact:** Low
  
For more information, see [Azure Front Door - Best practices ](https://aka.ms/afd-disable-health-probes)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 1c7fc5ab-f776-4aee-8236-ab478519f68f  


<!--1c7fc5ab-f776-4aee-8236-ab478519f68f_end-->

<!--e6744163-0be2-4c17-83da-179a0af9d14f_begin-->

#### Consider migrating to Front Door Standard/Premium  
  
Your Front Door Classic tier contains a large number of domains or routing rules, which adds extra charges. Front Door Standard or Premium doesn't charge per additional domain or routing rule. Consider migrating to save costs.  
  
**Potential benefits**: Save costs  

**Impact:** Medium
  
For more information, see [Compare pricing between Azure Front Door tiers ](/azure/frontdoor/understanding-pricing)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: e6744163-0be2-4c17-83da-179a0af9d14f  


<!--e6744163-0be2-4c17-83da-179a0af9d14f_end-->


<!--articleBody-->
