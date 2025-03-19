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

#### Reduce the cache policy on your Data Explorer tables  
  
Based on your actual usage during the last month, update the cache policy to reduce the hot cache for the table. The number of instances in your cluster is determined by the CPU and ingestion load, not by the amount of data held in the hot cache and may change based on your usage. Based on current usage, changing the cache isn't enough to reduce the number of instances, we recommend further optimizations,such as changing the SKU, reducing the CPU load, and enabling autoscale to scale in efficiently.   
  
**Potential benefits**: Cache reduction  

**Impact:** Medium
  
For more information, see [Caching policy (hot and cold cache) - Kusto](https://aka.ms/adxcachepolicy)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 9a3ea211-a282-4ab6-a63b-81024975b796  


<!--9a3ea211-a282-4ab6-a63b-81024975b796_end-->

<!--articleBody-->
