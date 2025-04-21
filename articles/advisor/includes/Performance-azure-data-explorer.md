---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Data Explorer
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Data Explorer  
  
<!--a17ff303-56eb-4382-ac2c-ac7e317945fc_begin-->

#### Enable Optimized Autoscale for Data Explorer resources  
  
Looks like your resource could automatically scale to improve performance (based on your actual usage during the last week, cache utilization, ingestion utilization, CPU, and streaming ingests utilization). To optimize costs and performance, we recommend enabling Optimized Autoscale.  
  
**Potential benefits**: Optimize performance  

**Impact:** Medium
  
For more information, see [Manage cluster horizontal scaling (scale out) to match demand in Azure Data Explorer - Azure Data Explorer](https://aka.ms/adxoptimizedautoscale)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: a17ff303-56eb-4382-ac2c-ac7e317945fc  


<!--a17ff303-56eb-4382-ac2c-ac7e317945fc_end-->

<!--389653ce-d564-4b95-aac4-ca30e1602536_begin-->

#### Increase the cache in the cache policy  
  
Based on your actual usage during the last month, update the cache policy to increase the hot cache for the table. The retention period must always be larger than the cache period. If, after increasing the cache, the retention period is lower than the cache period, update the retention policy. (*) The analysis is based only on user queries that scanned data.  
  
**Potential benefits**: Optimize performance  

**Impact:** Medium
  
For more information, see [Caching policy (hot and cold cache) - Kusto](https://aka.ms/adxcachepolicy)  

ResourceType: microsoft.kusto/clusters  
Recommendation ID: 389653ce-d564-4b95-aac4-ca30e1602536  


<!--389653ce-d564-4b95-aac4-ca30e1602536_end-->

<!--articleBody-->
