---
ms.service: azure
ms.topic: include
ms.date: 07/28/2026
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

<!--08bf438b-8464-41df-8148-d6fb109f11db_begin-->

#### Review degraded volume performance  
  
Review potential network connectivity issues that may affect access to the Azure NetApp Files volume. These issues can increase latency or cause intermittent connectivity when clients access the volume.  
  
**Potential benefits**: Mitigate volume latency  

**Impact:** Medium
  
For more information, see [Troubleshoot Azure NetApp Files using diagnose and solve problems tool](/azure/azure-netapp-files/troubleshoot-diagnose-solve-problems)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 08bf438b-8464-41df-8148-d6fb109f11db  


<!--08bf438b-8464-41df-8148-d6fb109f11db_end-->

<!--4e8eae65-6c4f-4ebb-bd49-f1a9410d531f_begin-->

#### Optimize Azure NetApp Files volume performance  
  
Optimize volume performance for Azure NetApp Files by using Auto-QoS or Manual-QoS to meet your volume performance requirements  
  
**Potential benefits**: Optimize volume performance for Azure NetApp Files  

**Impact:** Medium
  
For more information, see [General performance considerations for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-performance-considerations)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 4e8eae65-6c4f-4ebb-bd49-f1a9410d531f  


<!--4e8eae65-6c4f-4ebb-bd49-f1a9410d531f_end-->

<!--articleBody-->
