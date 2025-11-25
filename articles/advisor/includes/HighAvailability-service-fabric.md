---
ms.service: azure
ms.topic: include
ms.date: 11/25/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Service Fabric
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Service Fabric  
  
<!--c26fdcea-6dc5-4d41-874b-5bc2462834a7_begin-->

#### Distribute node types across zones to maintain quorum during faults  
  
Create node types with placement across multiple zones. Ensure durability level is set to Silver or Gold for quorum-based fault tolerance across zones.  
  
**Potential benefits**: Maintains quorum across zone failures  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.servicefabric/clusters  
Recommendation ID: c26fdcea-6dc5-4d41-874b-5bc2462834a7  
Subcategory: undefined

<!--c26fdcea-6dc5-4d41-874b-5bc2462834a7_end-->

<!--articleBody-->
