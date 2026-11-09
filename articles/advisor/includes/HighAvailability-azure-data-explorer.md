---
ms.service: azure
ms.topic: include
ms.date: 05/12/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Data Explorer
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Data Explorer  
  
<!--fa2649e9-e1a5-4d07-9b26-51c080d9a9ba_begin-->

#### Resolve virtual network issues  
  
Service failed to install or resume due to virtual network (VNet) issues. To resolve this issue, follow the steps in the troubleshooting guide.   
  
**Potential benefits**: Fix connectivity problems for private endpoints.  

**Impact:** High
  
For more information, see [Troubleshoot access, ingestion, and operation of your Azure Data Explorer cluster in your virtual network - Azure Data Explorer ](/azure/data-explorer/vnet-deploy-troubleshoot)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: fa2649e9-e1a5-4d07-9b26-51c080d9a9ba  
Subcategory: Other

<!--fa2649e9-e1a5-4d07-9b26-51c080d9a9ba_end-->



<!--3c3f5efa-cd4e-4065-ae51-0931ddd25af0_begin-->

#### Configure and deploy Azure Data Explorer and related resources to use availability zones  
  
Kusto clusters are identified as zone-resilient when you deploy them in two or more zones. By using availability zones, a cluster better withstands the failure of a single datacenter in a region to support business continuity scenarios.  
  
**Potential benefits**: Improved availability and reliability.  

**Impact:** High
  
For more information, see [Azure Data Explorer business continuity overview](https://aka.ms/learnmore_kusto_clusters)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 3c3f5efa-cd4e-4065-ae51-0931ddd25af0  

<!--3c3f5efa-cd4e-4065-ae51-0931ddd25af0_end-->

<!--articleBody-->
