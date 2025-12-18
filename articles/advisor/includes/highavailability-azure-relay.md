---
ms.service: azure
ms.topic: include
ms.date: 11/25/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Relay
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Relay  
  
<!--f94e36fd-c8c1-4af3-8ac6-39c151f9515e_begin-->

#### Create in availability zone supported regions to keep relays running during zone outages  
  
Deploy relays in regions that support availability zones and zone redundancy. If available, enable zone redundancy for service or resource during creation.  
  
**Potential benefits**: Messaging continuity during zone outages  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.relay/namespaces  
Recommendation ID: f94e36fd-c8c1-4af3-8ac6-39c151f9515e  
Subcategory: undefined

<!--f94e36fd-c8c1-4af3-8ac6-39c151f9515e_end-->

<!--articleBody-->
