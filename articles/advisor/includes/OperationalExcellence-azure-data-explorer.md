---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Data Explorer
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Data Explorer  
  
<!--9a3ea211-a282-4ab6-a63b-81024975b796_begin-->

#### Reduce the cache in the cache policy  
  
Based on usage over the past month, update the cache policy to reduce the hot cache for the table. The number of instances in the cluster is determined using CPU and ingestion load, rather than the amount of data in the hot cache, and varies based on your usage. Given the current usage, simply changing the cache isn't sufficient to reduce the number of instances. The platform recommends other optimizations like reducing CPU load, changing the SKU, and enabling autoscale to efficiently scale in.  
  
**Potential benefits**: Cache reduction  

**Impact:** Medium
  
For more information, see [Caching policy (hot and cold cache) - Kusto](https://aka.ms/adxcachepolicy)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 9a3ea211-a282-4ab6-a63b-81024975b796  

<!--9a3ea211-a282-4ab6-a63b-81024975b796_end-->

<!--articleBody-->
