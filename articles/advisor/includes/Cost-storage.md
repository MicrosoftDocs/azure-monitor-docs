---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Storage
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Storage  
  
<!--386452d3-8df0-4174-94cb-fee063b3084f_begin-->

#### Revisit retention policy for classic log data in storage accounts  
  
Large classic log data is detected on your storage accounts. You are billed on capacity of data stored in storage accounts including classic logs. You are recommended to check the retention policy of classic logs and update with necessary period to retain less log data. This would reduce unnecessary classic log data and save your billing cost from less capacity.  
  
**Potential benefits**: Save cost from unneeded log data  

**Impact:** Medium
  
For more information, see [Enable and manage Azure Storage Analytics logs (classic) ]( /azure/storage/common/manage-storage-analytics-logs#modify-retention-policy)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 386452d3-8df0-4174-94cb-fee063b3084f  


<!--386452d3-8df0-4174-94cb-fee063b3084f_end-->

<!--c81a0349-18c0-4bd2-81c7-475adde922d2_begin-->

#### Based on your high transactions/TB  ratio, there's a possibility that premium storage might be more cost effective in addition to being performant for your scenario. More details on pricing for premium and standard accounts can be found here  
  
The customer can lower the bill if the transactions/TB ratio is high. Exact number would depend on transaction mix and region but anywhere >30 or 35 TPB/TB may be good candidates to at least evaluate a move to premium storage.  
  
**Potential benefits**: Based on your high transactions/TB  ratio, there is a possibility that premium storage might be more cost effective in addition to being performant for your scenario.  

**Impact:** Medium
  
For more information, see [Azure Blob Storage pricing ](https://aka.ms/azureblobstoragepricing)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: c81a0349-18c0-4bd2-81c7-475adde922d2  


<!--c81a0349-18c0-4bd2-81c7-475adde922d2_end-->

<!--articleBody-->
