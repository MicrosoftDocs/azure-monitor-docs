---
ms.service: azure
ms.topic: include
ms.date: 02/24/2026
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

**Impact:** Medium
  
For more information, see [Service limits for tiers and skus - Azure AI Search ](https://aka.ms/azs/search-limits-quotas-capacity)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: 97b38421-f88c-4db0-b397-b2d81eff6630  
Subcategory: Scalability

<!--97b38421-f88c-4db0-b397-b2d81eff6630_end-->

<!--8d31f25f-31a9-4267-b817-20ee44f88069_begin-->

#### Create a Standard search service (50MB)  
  
When you exceed your storage quota, indexing operations stop working. You're close to exceeding your storage quota of 50MB. To maintain operations, create a Basic or Standard search service.  
  
**Potential benefits**: capability to handle more data  

**Impact:** Medium
  
For more information, see [Service limits for tiers and skus - Azure AI Search ](https://aka.ms/azs/search-limits-quotas-capacity)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: 8d31f25f-31a9-4267-b817-20ee44f88069  
Subcategory: Scalability

<!--8d31f25f-31a9-4267-b817-20ee44f88069_end-->

<!--b3efb46f-6d30-4201-98de-6492c1f8f10d_begin-->

#### Avoid exceeding your available storage quota by adding more partitions  
  
When you exceed your storage quota, you can still query, but indexing operations stop working. You're close to exceeding your available storage quota. If you need more storage, add extra partitions.  
  
**Potential benefits**: Able to index additional data  

**Impact:** Medium
  
For more information, see [Service limits for tiers and skus - Azure AI Search ](https://aka.ms/azs/search-limits-quotas-capacity)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: b3efb46f-6d30-4201-98de-6492c1f8f10d  
Subcategory: Scalability

<!--b3efb46f-6d30-4201-98de-6492c1f8f10d_end-->

<!--e24f566a-0ea9-4a6b-94c5-be0a73f251c8_begin-->

#### Upgrade to the newest version of the listQueryKeys request  
  
Upgrade to the newest version of the Search/searchServices/mysearchservice/listQueryKeys request. The platform identified resources under the subscription using an outdated version of the Search/searchServices/mysearchservice/listQueryKeys request.  
  
**Potential benefits**: Improved security.  

**Impact:** Medium
  
For more information, see [Query Keys - List By Search Service - REST API (Azure Search Management)](/rest/api/searchmanagement/query-keys/list-by-search-service)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: e24f566a-0ea9-4a6b-94c5-be0a73f251c8  
Subcategory: ServiceUpgradeAndRetirement

<!--e24f566a-0ea9-4a6b-94c5-be0a73f251c8_end-->


<!--98acf571-d0a4-4111-993c-829f91b8c71b_begin-->

#### Add a replica for instance of the Azure AI Search  
  
Add a replica for Azure AI Search. Instance of Azure AI Search isn't covered by service-level agreement. In Azure AI Search, a replica is a copy of the index. Adding replicas allows Azure AI Search to do machine reboots and maintenance against one replica, while a query runs on another replica.  
  
**Potential benefits**: Improve reliability of Azure AI Search instance.  

**Impact:** Medium
  
For more information, see [Reliability in Azure AI Search - Azure AI Search](https://aka.ms/AISearchHighAvailability)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: 98acf571-d0a4-4111-993c-829f91b8c71b  
Subcategory: HighAvailability

<!--98acf571-d0a4-4111-993c-829f91b8c71b_end-->




<!--bc416431-6245-4337-97b5-de1761692866_begin-->

#### Bing Search APIs are retiring  
  
Bing Search APIs are retiring. Existing instances of Bing Search APIs are decommissioned. Bing Search APIs are no longer available to existing or new customers.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=492574)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: bc416431-6245-4337-97b5-de1761692866  
Subcategory: undefined

<!--bc416431-6245-4337-97b5-de1761692866_end-->

<!--articleBody-->
