---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Cosmos DB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cosmos DB  
  
<!--683b5e32-48aa-4b46-a822-4e22a20ee244_begin-->

#### Optimize your Azure Cosmos DB indexing policy to only index what's needed  
  
Your Azure Cosmos DB containers are using the default indexing policy, which indexes every property in your documents. Because you're storing large documents, a high number of properties get indexed that results in high Request Unit consumption and poor write latency. To optimize write performance, we recommend overriding the default indexing policy to only index the properties used in your queries.  
  
**Potential benefits**: Improve the write throughput of your container  

**Impact:** Medium
  
For more information, see [Azure Cosmos DB indexing policies](/azure/cosmos-db/index-policy)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 683b5e32-48aa-4b46-a822-4e22a20ee244  


<!--683b5e32-48aa-4b46-a822-4e22a20ee244_end-->

<!--75c8c891-46d2-41fa-a81c-84e870a139a9_begin-->

#### Configure your Azure Cosmos DB applications to use Direct connectivity in the SDK  
  
We noticed that your Azure Cosmos DB applications are using Gateway mode via the Cosmos DB .NET or Java SDKs. We recommend switching to Direct connectivity for lower latency and higher scalability.  
  
**Potential benefits**: Improved latency and high availability for your applications  

**Impact:** High
  
For more information, see [Azure Cosmos DB performance tips for .NET SDK v2](/azure/cosmos-db/performance-tips#networking)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 75c8c891-46d2-41fa-a81c-84e870a139a9  


<!--75c8c891-46d2-41fa-a81c-84e870a139a9_end-->

<!--3a7c4990-18e7-4581-b62d-c745260e7c5b_begin-->

#### Use hierarchical partition keys for optimal data distribution  
  
This account has a custom setting that allows the logical partition size in a container to exceed the limit of 20 GB. This setting was applied by the Azure Cosmos DB team as a temporary measure to give you time to architect your application again with a different partition key. It's not recommended as a long-term solution, as SLA guarantees aren't honored when the limit is increased. You can now use hierarchical partition keys (preview) to architect your application again. The feature allows you to exceed the limit of 20 GB by setting up to three partition keys, ideal for multi-tenant scenarios or workloads that use synthetic keys.  
  
**Potential benefits**: Optimize data distribution and performance  

**Impact:** Medium
  
For more information, see [Now in private preview: optimize your data distribution with hierarchical partition keys - Azure Cosmos DB Blog](https://devblogs.microsoft.com/cosmosdb/hierarchical-partition-keys-private-preview/)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 3a7c4990-18e7-4581-b62d-c745260e7c5b  


<!--3a7c4990-18e7-4581-b62d-c745260e7c5b_end-->

<!--e27c5181-5005-4dc3-a449-89b726a3bf54_begin-->

#### Configure your Azure Cosmos DB query page size (MaxItemCount) to -1  
  
You are using the query page size of 100 for queries for your Azure Cosmos container. We recommend using a page size of -1 for faster scans.  
  
**Potential benefits**: End to end query latency is significantly improved.  

**Impact:** Medium
  
For more information, see [SQL query metrics for Azure Cosmos DB for NoSQL](/azure/cosmos-db/sql-api-query-metrics#max-item-count)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: e27c5181-5005-4dc3-a449-89b726a3bf54  


<!--e27c5181-5005-4dc3-a449-89b726a3bf54_end-->

<!--1ff3c87f-63c6-4b94-9bb1-28f8d115103e_begin-->

#### Take advantage of your database or container's idle throughput capacity to handle spikes of traffic  
  
Use burst capacity to leverage idle database/container capacity to handle traffic spikes, preventing rate limiting (429 errors) and maintaining performance during workload bursts.  
  
**Potential benefits**: Improve performance and productivity  

**Impact:** Low
  
For more information, see [Burst capacity - Azure Cosmos DB](/azure/cosmos-db/burst-capacity)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 1ff3c87f-63c6-4b94-9bb1-28f8d115103e  


<!--1ff3c87f-63c6-4b94-9bb1-28f8d115103e_end-->

<!--4391ebb6-9519-4563-97c8-85f40cb92a63_begin-->

#### Add missing indexes to your Azure Cosmos DB container  
  
Queries can benefit from adding indexes for reduced cost and increased performance. We recommend you consider adding these index paths to your container's indexing policy.  
  
**Potential benefits**: Reduce query RU charge and increase performance  

**Impact:** Medium
  
For more information, see [Azure Cosmos DB indexing policies](/azure/cosmos-db/index-policy#include-exclude-paths)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 4391ebb6-9519-4563-97c8-85f40cb92a63  


<!--4391ebb6-9519-4563-97c8-85f40cb92a63_end-->

<!--b633adb4-0c3c-4ab6-ab52-a9d752c6ac52_begin-->

#### PerformanceBoostervCore  
  
When CPU usage surpasses 90% within a 12-hour timeframe, users are notified about the high usage. Additionally it advises them to scale up to a higher tier to get a better performance.  
  
**Potential benefits**: Get a performance boost  

**Impact:** Medium
  
For more information, see [Scale or configure a cluster - Azure Cosmos DB for MongoDB vCore](/azure/cosmos-db/mongodb/vcore/how-to-scale-cluster)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: b633adb4-0c3c-4ab6-ab52-a9d752c6ac52  


<!--b633adb4-0c3c-4ab6-ab52-a9d752c6ac52_end-->

<!--articleBody-->
