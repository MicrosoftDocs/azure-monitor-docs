---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure NetApp Files
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure NetApp Files  
  
<!--1b93c1a0-5f0d-43a6-a02f-f2e3fd34b696_begin-->

#### Reduce user limit for NetApp Files FsLogix Container volume  
  
Regularly monitor the concurrent users and reduce users if the number of concurrent users on an Azure NetApp Files volume approaches 3000. If the specific scenario requires more than 3,000 concurrent users, group the users and move the groups to multiple regular volumes or use a large volume.  
  
**Potential benefits**: Reduce latency on a volume  

**Impact:** Medium
  
For more information, see [Store FSLogix profile containers on Azure NetApp Files - FSLogix](/azure/virtual-desktop/create-fslogix-profile-container)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 1b93c1a0-5f0d-43a6-a02f-f2e3fd34b696  


<!--1b93c1a0-5f0d-43a6-a02f-f2e3fd34b696_end-->

<!--articleBody-->
