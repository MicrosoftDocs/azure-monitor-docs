---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
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

**Impact:** Medium
  
For more information, see [How to configure Azure Cache for Redis - Azure Cache for Redis ](https://aka.ms/redis/recommendations/memory-policies)  

ResourceType: microsoft.cache/redis  
Recommendation ID: 7c380315-6ad9-4fb2-8930-a8aeb1d6241b  
Subcategory: Other

<!--7c380315-6ad9-4fb2-8930-a8aeb1d6241b_end-->

<!--c9e4a27c-79e6-4e4c-904f-b6612b6cd892_begin-->

#### Configure geo-replication for Cache for Redis instances to increase durability of applications  
  
Geo-Replication enables disaster recovery for cached data, even in the unlikely event of a widespread regional failure. This can be essential for mission-critical applications. We recommend that you configure passive geo-replication for Premium Azure Cache for Redis instances.  
  
**Potential benefits**: Geo-Replication enables disaster recovery for cached data.  

**Impact:** High
  
For more information, see [Configure passive geo-replication for Premium Azure Cache for Redis instances - Azure Cache for Redis ](https://aka.ms/redispremiumgeoreplication)  

ResourceType: microsoft.cache/redis  
Recommendation ID: c9e4a27c-79e6-4e4c-904f-b6612b6cd892  
Subcategory: DisasterRecovery

<!--c9e4a27c-79e6-4e4c-904f-b6612b6cd892_end-->

<!--1a0a309c-54f0-4cb0-a839-2cee5912ba62_begin-->

#### Enable zone redundancy for Redis  
  
Enable multi-node replication configuration across Availability Zones, with automatic failover  
  
**Potential benefits**: Reduces outage risk; 99.9% uptime for Premium cache  

**Impact:** High
  
For more information, see [What is Azure Cache for Redis? - Azure Cache for Redis](https://aka.ms/CacheRedis)  

ResourceType: microsoft.cache/redis  
Recommendation ID: 1a0a309c-54f0-4cb0-a839-2cee5912ba62  
Subcategory: HighAvailability

<!--1a0a309c-54f0-4cb0-a839-2cee5912ba62_end-->

<!--08cff11d-aa10-44a1-a92f-a76a19e63f7d_begin-->

#### Use Enterprise SKU with zone redundancy  
  
Select Zone Redundancy in portal or ARM template  
  
**Potential benefits**: Reduces outage risk; 99.9% uptime for Enterprise cache  

**Impact:** High
  
For more information, see [What is Azure Cache for Redis? - Azure Cache for Redis](https://aka.ms/CacheRedisEnterprise)  

ResourceType: microsoft.cache/redisenterprise  
Recommendation ID: 08cff11d-aa10-44a1-a92f-a76a19e63f7d  
Subcategory: HighAvailability

<!--08cff11d-aa10-44a1-a92f-a76a19e63f7d_end-->

<!--articleBody-->
