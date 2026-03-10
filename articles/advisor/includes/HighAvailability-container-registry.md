---
ms.service: azure
ms.topic: include
ms.date: 03/10/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Container Registry
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Container Registry  
  
<!--af0cdbce-c610-499b-9bd7-b169cdb1bb2e_begin-->

#### Use Premium tier for critical production workloads  
  
Premium registries provide the highest amount of included storage, concurrent operations and network bandwidth, enabling high-volume scenarios. The Premium tier also adds features such as geo-replication, availability zone support, content-trust, customer-managed keys and private endpoints.  
  
**Potential benefits**: Premium tier provides maximum performance and resiliency  

**Impact:** High
  
For more information, see [Azure Container Registry SKU Features and Limits - Azure Container Registry](https://aka.ms/AAqwyv6)  

ResourceType: microsoft.containerregistry/registries  
Recommendation ID: af0cdbce-c610-499b-9bd7-b169cdb1bb2e  
Subcategory: HighAvailability

<!--af0cdbce-c610-499b-9bd7-b169cdb1bb2e_end-->




<!--dcfa2602-227e-4b6c-a60d-7b1f6514e690_begin-->

#### Ensure Geo-replication is enabled for resilience  
  
Geo-replication lets your registry serve image pulls from multiple regions. Without it, a regional outage can disrupt pulls and deployments. Enabling this reduces single-region risk, improves region-local pull performance, and strengthens failover resilience. Available in the Premium service tier.  
  
**Potential benefits**: Reduced outage risk and faster region-local pulls.  

**Impact:** High
  
For more information, see [Geo-replication in Azure Container Registry - Azure Container Registry](https://aka.ms/AAqwx90)  

ResourceType: microsoft.containerregistry/registries  
Recommendation ID: dcfa2602-227e-4b6c-a60d-7b1f6514e690  
Subcategory: undefined

<!--dcfa2602-227e-4b6c-a60d-7b1f6514e690_end-->



<!--articleBody-->
