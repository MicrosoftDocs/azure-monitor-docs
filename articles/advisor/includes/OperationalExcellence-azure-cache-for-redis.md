---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Cache for Redis
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cache for Redis  
  
<!--f160c11d-9aab-4d41-979f-d119dec02392_begin-->

#### You may benefit from using an Enterprise tier cache instance  
  
This instance of Azure Cache for Redis is using one or more advanced features from the list - more than 6 shards, geo-replication, zone-redundancy or persistence. Consider switching to an Enterprise tier cache to get the most out of your Redis experience. Enterprise tier caches offer higher availability, better performance and more powerful features like active geo-replication.  
  
**Potential benefits**: Better performance, higher availability, and additional features.  

**Impact:** High
  
For more information, see [Azure Cache for Redis Enterprise GA](https://aka.ms/redisenterpriseupgrade)  

ResourceType: microsoft.cache/redis  
Recommendation ID: f160c11d-9aab-4d41-979f-d119dec02392  


<!--f160c11d-9aab-4d41-979f-d119dec02392_end-->

<!--e387838a-4fbc-47d5-9a3d-9d1aaa218345_begin-->

#### Redis persistence allows you to persist data stored in a cache so you can reload data from an event that caused data loss.  
  
Redis persistence allows you to persist data stored in Redis. You can also take snapshots and back up the data. If there's a hardware failure, the persisted data is automatically loaded in your cache instance.  Data loss is possible if a failure occurs where Cache nodes are down.  
  
**Potential benefits**: Avoid data loss due to hardware failure or Cache node failure  

**Impact:** Medium
  
For more information, see [Configure data persistence - Premium Azure Cache for Redis - Azure Cache for Redis](https://aka.ms/redis/persistence)  

ResourceType: microsoft.cache/redis  
Recommendation ID: e387838a-4fbc-47d5-9a3d-9d1aaa218345  


<!--e387838a-4fbc-47d5-9a3d-9d1aaa218345_end-->

<!--204cc04b-0e75-46f9-9a43-9bcb39955236_begin-->

#### Cloud service caches are being retired in August 2024, migrate before then to avoid any problems  
  
This instance of Azure Cache for Redis has a dependency on Cloud Services (classic) which is being retired in August 2024. Follow the instructions found in the learn more link to migrate to an instance without this dependency. If you need to upgrade your cache to Redis 6 please note that upgrading a cache with a dependency on cloud services isn't supported. You should migrate your cache instance to Virtual Machine Scale Set before upgrading. For more information, see /azure/azure-cache-for-redis/cache-faq for details on cloud services hosted caches. Note: If you have completed your migration away from Cloud Services, please allow up to 24 hours for this recommendation to be removed  
  
**Potential benefits**: Avoid service interruptions by migrating before cloud services are retired.  

**Impact:** High
  
For more information, see [Azure Managed Redis and Azure Cache for Redis FAQ - Azure Cache for Redis](/azure/azure-cache-for-redis/cache-faq#caches-with-a-dependency-on-cloud-services-%28classic%29)  

ResourceType: microsoft.cache/redis  
Recommendation ID: 204cc04b-0e75-46f9-9a43-9bcb39955236  


<!--204cc04b-0e75-46f9-9a43-9bcb39955236_end-->

<!--77204a4e-03ed-4db5-b059-3c3a26145b43_begin-->

#### Using persistence with soft delete enabled can increase storage costs.  
  
Check to see if your storage account has soft delete enabled before using the data persistence feature. Using data persistence with soft delete causes very high storage costs. For more information, see /azure/azure-cache-for-redis/cache-how-to-premium-persistence#how-do-i-check-if-soft-delete-is-enabled-on-my-storage-account  
  
**Potential benefits**: Avoid high storage costs due to soft delete  

**Impact:** Medium
  
For more information, see [Configure data persistence - Premium Azure Cache for Redis - Azure Cache for Redis](https://aka.ms/redis/persistence)  

ResourceType: microsoft.cache/redis  
Recommendation ID: 77204a4e-03ed-4db5-b059-3c3a26145b43  


<!--77204a4e-03ed-4db5-b059-3c3a26145b43_end-->





<!--dc33091b-a748-4418-b4b0-d3d97466efe4_begin-->

#### Injecting a cache into a virtual network (VNet) imposes complex requirements on your network configuration. This is a common source of incidents affecting customer applications  
  
Injecting a cache into a virtual network (VNet) imposes complex requirements on your network configuration. It's difficult to configure the network accurately and avoid affecting cache functionality. It's easy to break the cache accidentally while making configuration changes for other network resources. This is a common source of incidents affecting customer applications  
  
**Potential benefits**: Avoid affecting cache functionality.  

**Impact:** Medium
  
For more information, see [Migrate from VNet injection caches to Private Link caches - Azure Cache for Redis](https://aka.ms/VnetToPrivateLink)  

ResourceType: microsoft.cache/redis  
Recommendation ID: dc33091b-a748-4418-b4b0-d3d97466efe4  


<!--dc33091b-a748-4418-b4b0-d3d97466efe4_end-->

<!--articleBody-->
