---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Cache for Redis
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cache for Redis  
  
<!--7c380315-6ad9-4fb2-8930-a8aeb1d6241b_begin-->

#### Increase fragmentation memory reservation  
  
Fragmentation and memory pressure can cause availability incidents. To help in reduce cache failures when running under high memory pressure, increase reservation of memory for fragmentation through the  maxfragmentationmemory-reserved setting available in the Advanced Settings options.  
  
**Potential benefits**: Avoid availability incidents when your cache has high memory fragmentation  

For more information, see [How to configure Azure Cache for Redis](https://aka.ms/redis/recommendations/memory-policies)  

<!--7c380315-6ad9-4fb2-8930-a8aeb1d6241b_end-->

<!--c9e4a27c-79e6-4e4c-904f-b6612b6cd892_begin-->

#### Configure geo-replication for Cache for Redis instances to increase durability of applications  
  
Geo-Replication enables disaster recovery for cached data, even in the unlikely event of a widespread regional failure. This can be essential for mission-critical applications. We recommend that you configure passive geo-replication for Premium Azure Cache for Redis instances.  
  
**Potential benefits**: Geo-Replication enables disaster recovery for cached data.  

For more information, see [Configure passive geo-replication for Premium Azure Cache for Redis instances](https://aka.ms/redispremiumgeoreplication)  

<!--c9e4a27c-79e6-4e4c-904f-b6612b6cd892_end-->

<!--articleBody-->
