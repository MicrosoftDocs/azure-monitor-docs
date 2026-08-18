---
ms.service: azure
ms.topic: include
ms.date: 07/28/2026
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
  
For more information, see [Best Practices - Azure Front Door](https://aka.ms/afd-disable-health-probes)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: 1c7fc5ab-f776-4aee-8236-ab478519f68f  


<!--1c7fc5ab-f776-4aee-8236-ab478519f68f_end-->


<!--e6744163-0be2-4c17-83da-179a0af9d14f_begin-->

#### Consider migrating to Front Door Standard/Premium  
  
Your Front Door Classic tier contains a large number of domains or routing rules, which adds extra charges. Front Door Standard or Premium doesn't charge per additional domain or routing rule. Consider migrating to save costs.  
  
**Potential benefits**: Save costs  

**Impact:** Medium
  
For more information, see [Compare Pricing Between Azure Front Door Tiers](/azure/frontdoor/understanding-pricing)  

ResourceType: microsoft.network/frontdoors  
Recommendation ID: e6744163-0be2-4c17-83da-179a0af9d14f  


<!--e6744163-0be2-4c17-83da-179a0af9d14f_end-->



<!--746768e6-0478-4023-84db-ef80967ee988_begin-->

#### Example of Kusto recommendation  
  
Example of Kusto recommendation  
  
**Potential benefits**: Example  

**Impact:** Low
  
  

ResourceType: microsoft.network/loadbalancers  
Recommendation ID: 746768e6-0478-4023-84db-ef80967ee988  


<!--746768e6-0478-4023-84db-ef80967ee988_end-->

<!--c49de82b-eae1-426c-8f73-8d9c84d65fc9_begin-->

#### Example ARG with extendedProperties and strcat  
  
Example ARG  
  
**Potential benefits**: Example ARG  

**Impact:** Low
  
  

ResourceType: microsoft.network/loadbalancers  
Recommendation ID: c49de82b-eae1-426c-8f73-8d9c84d65fc9  


<!--c49de82b-eae1-426c-8f73-8d9c84d65fc9_end-->

<!--e3d3ce5f-a7b1-42e8-92ec-afbe1ee83c9c_begin-->

#### Example ARG with extendedProperties and bagpack  
  
Example ARG 2  
  
**Potential benefits**: Example ARG 2  

**Impact:** Low
  
  

ResourceType: microsoft.network/loadbalancers  
Recommendation ID: e3d3ce5f-a7b1-42e8-92ec-afbe1ee83c9c  


<!--e3d3ce5f-a7b1-42e8-92ec-afbe1ee83c9c_end-->

<!--articleBody-->
