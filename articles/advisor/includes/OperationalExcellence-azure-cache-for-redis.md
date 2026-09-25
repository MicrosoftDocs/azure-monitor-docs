---
ms.service: azure
ms.topic: include
ms.date: 09/24/2026
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Cache for Redis
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cache for Redis  
  
<!--f160c11d-9aab-4d41-979f-d119dec02392_begin-->

#### Migrate to the Enterprise tier of Azure Cache for Redis to access more powerful features  
  
The Azure Cache for Redis instance is using more than six shards, geo-replication, zone-redundancy, or persistence. Migrate to the Enterprise tier cache to improve availability, performance, and access more powerful features like active geo-replication.  
  
**Potential benefits**: Improve performance, availability, and additional features  

**Impact:** High
  
For more information, see [Azure Cache for Redis Enterprise GA](https://aka.ms/redisenterpriseupgrade)  

ResourceType: microsoft.cache/redis  
Recommendation ID: f160c11d-9aab-4d41-979f-d119dec02392  

<!--f160c11d-9aab-4d41-979f-d119dec02392_end-->

<!--e387838a-4fbc-47d5-9a3d-9d1aaa218345_begin-->

#### Enable Persistence  
  
Redis persistence allows you to persist data stored in Redis. You can also take snapshots and back up the data. If there's a hardware failure, the persisted data is automatically loaded in your cache instance.  Data loss is possible if a failure occurs where Cache nodes are down.  
  
**Potential benefits**: Avoid data loss due to hardware failure or Cache node failure  

**Impact:** Medium
  
For more information, see [Configure data persistence - Premium Azure Cache for Redis - Azure Cache for Redis](https://aka.ms/redis/persistence)  

ResourceType: microsoft.cache/redis  
Recommendation ID: e387838a-4fbc-47d5-9a3d-9d1aaa218345  

<!--e387838a-4fbc-47d5-9a3d-9d1aaa218345_end-->

<!--77204a4e-03ed-4db5-b059-3c3a26145b43_begin-->

#### Check to see if Soft Delete is enabled  
  
Check to see if your storage account has soft delete enabled before using the data persistence feature. Using data persistence with soft delete causes very high storage costs. For more information, see [Check to see if soft delete is enabled on my storage account](/azure/azure-cache-for-redis/cache-how-to-premium-persistence#how-do-i-check-if-soft-delete-is-enabled-on-my-storage-account)  
  
**Potential benefits**: Avoid high storage costs due to soft delete  

**Impact:** Medium
  
For more information, see [Configure data persistence - Premium Azure Cache for Redis - Azure Cache for Redis](https://aka.ms/redis/persistence)  

ResourceType: microsoft.cache/redis  
Recommendation ID: 77204a4e-03ed-4db5-b059-3c3a26145b43  

<!--77204a4e-03ed-4db5-b059-3c3a26145b43_end-->

<!--dc33091b-a748-4418-b4b0-d3d97466efe4_begin-->

#### Avoid affecting cache functionality by using private link.  
  
Injecting a cache into a virtual network (VNet) imposes complex requirements on your network configuration. It's difficult to configure the network accurately and avoid affecting cache functionality. It's easy to break the cache accidentally while making configuration changes for other network resources. This is a common source of incidents affecting customer applications  
  
**Potential benefits**: Avoid affecting cache functionality.  

**Impact:** Medium
  
For more information, see [Migrate from VNet injection caches to Private Link caches - Azure Cache for Redis](https://aka.ms/VnetToPrivateLink)  

ResourceType: microsoft.cache/redis  
Recommendation ID: dc33091b-a748-4418-b4b0-d3d97466efe4  

<!--dc33091b-a748-4418-b4b0-d3d97466efe4_end-->

<!--2bb28cf0-969d-43a3-baf8-51328ac497fc_begin-->

#### Migrate to Azure Managed Redis  
  
Azure Cache for Redis will be retired on September 30, 2028. New cache creation will be blocked in phases - starting April 1, 2026 for new customers and starting October 1, 2026 for existing customers. Proactively migrate workloads to Azure Managed Redis to avoid service disruption.  
  
**Potential benefits**: AMR offers low-latency, cost-effective data storage  

**Impact:** High
  
For more information, see [Frequently asked questions (FAQ) on the retirement of Azure Cache for Redis - Azure Cache for Redis](/azure/azure-cache-for-redis/retirement-faq)  

ResourceType: microsoft.cache/redis  
Recommendation ID: 2bb28cf0-969d-43a3-baf8-51328ac497fc  

<!--2bb28cf0-969d-43a3-baf8-51328ac497fc_end-->

<!--articleBody-->
