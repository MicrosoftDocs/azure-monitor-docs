---
ms.service: azure
ms.topic: include
ms.date: 06/24/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Container Registry
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Container Registry  
  
<!--af0cdbce-c610-499b-9bd7-b169cdb1bb2e_begin-->

#### Use Premium tier for critical production workloads  
  
Premium registries provide the highest amount of included storage, concurrent operations and network bandwidth, enabling high-volume scenarios. The Premium tier also adds features such as geo-replication, availability zone support, content-trust, customer-managed keys and private endpoints.  
  
**Potential benefits**: The Premium tier provides the highest amount of performance, scale and resiliency options  

**Impact:** High
  
For more information, see [Registry Service Tiers and Features - Azure Container Registry](https://aka.ms/AAqwyv6)  

ResourceType: microsoft.containerregistry/registries  
Recommendation ID: af0cdbce-c610-499b-9bd7-b169cdb1bb2e  
Subcategory: HighAvailability

<!--af0cdbce-c610-499b-9bd7-b169cdb1bb2e_end-->



<!--dcfa2602-227e-4b6c-a60d-7b1f6514e690_begin-->

#### Ensure Geo-replication is enabled for resilience  
  
Geo-replication enables workloads to use a single image, tag and registry name across regions, provides network-close registry access, reduced data transfer costs and regional Registry resilience if a regional outage occurs. This feature is only available in the Premium service tier.  
  
**Potential benefits**: Improved resilience and pull performance, simplified registry management and reduced data transfer costs  

**Impact:** High
  
For more information, see [Geo-replicate Azure Container Registry to Multiple Regions - Azure Container Registry ](https://aka.ms/AAqwx90)  

ResourceType: microsoft.containerregistry/registries  
Recommendation ID: dcfa2602-227e-4b6c-a60d-7b1f6514e690  
Subcategory: HighAvailability

<!--dcfa2602-227e-4b6c-a60d-7b1f6514e690_end-->

<!--articleBody-->
