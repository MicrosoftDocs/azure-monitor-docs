---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure AI Search
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure AI Search  
  
<!--97b38421-f88c-4db0-b397-b2d81eff6630_begin-->

#### Create a Standard search service (2GB)  
  
When you exceed your storage quota, indexing operations stop working. You're close to exceeding your storage quota of 2GB. If you need more storage, create a Standard search service or add extra partitions.  
  
**Potential benefits**: capability to handle more data  

For more information, see [Service limits in Azure AI Search](https://aka.ms/azs/search-limits-quotas-capacity)  

<!--97b38421-f88c-4db0-b397-b2d81eff6630_end-->

<!--8d31f25f-31a9-4267-b817-20ee44f88069_begin-->

#### Create a Standard search service (50MB)  
  
When you exceed your storage quota, indexing operations stop working. You're close to exceeding your storage quota of 50MB. To maintain operations, create a Basic or Standard search service.  
  
**Potential benefits**: capability to handle more data  

For more information, see [Service limits in Azure AI Search](https://aka.ms/azs/search-limits-quotas-capacity)  

<!--8d31f25f-31a9-4267-b817-20ee44f88069_end-->

<!--b3efb46f-6d30-4201-98de-6492c1f8f10d_begin-->

#### Avoid exceeding your available storage quota by adding more partitions  
  
When you exceed your storage quota, you can still query, but indexing operations stop working. You're close to exceeding your available storage quota. If you need more storage, add extra partitions.  
  
**Potential benefits**: Able to index additional data  

For more information, see [Service limits in Azure AI Search](https://aka.ms/azs/search-limits-quotas-capacity)  

<!--b3efb46f-6d30-4201-98de-6492c1f8f10d_end-->

<!--articleBody-->
