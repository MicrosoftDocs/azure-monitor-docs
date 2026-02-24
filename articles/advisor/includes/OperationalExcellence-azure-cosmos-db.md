---
ms.service: azure
ms.topic: include
ms.date: 02/24/2026
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Cosmos DB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cosmos DB  
  
<!--061dcd4a-2090-4ec0-b4e0-ec9eaae5cf80_begin-->

#### Migrate Azure Cosmos DB attachments to Azure Blob Storage  
  
We noticed that your Azure Cosmos collection is using the legacy attachments feature. We recommend migrating attachments to Azure Blob Storage to improve the resiliency and scalability of your blob data.  
  
**Potential benefits**: Improve attachment blob resiliency and scalability  

**Impact:** Medium
  
For more information, see [Attachments - Azure Cosmos DB for NoSQL](/azure/cosmos-db/attachments#migrating-attachments-to-azure-blob-storage)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 061dcd4a-2090-4ec0-b4e0-ec9eaae5cf80  


<!--061dcd4a-2090-4ec0-b4e0-ec9eaae5cf80_end-->

<!--52fef986-5897-4359-8b92-0f22749f0d73_begin-->

#### Improve resiliency by migrating your Azure Cosmos DB accounts to continuous backup  
  
Your Azure Cosmos DB accounts are configured with periodic backup. Continuous backup with point-in-time restore is now available on these accounts. With continuous backup, you can restore your data to any point in time within the past 30 days. Continuous backup may also be more cost-effective as a single copy of your data is retained.  
  
**Potential benefits**: Improve the resiliency of your Azure Cosmos DB workloads  

**Impact:** Medium
  
For more information, see [Continuous backup with point in time restore feature in Azure Cosmos DB](/azure/cosmos-db/continuous-backup-restore-introduction)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 52fef986-5897-4359-8b92-0f22749f0d73  


<!--52fef986-5897-4359-8b92-0f22749f0d73_end-->

<!--bf161e78-ce57-4198-82e8-a34522045518_begin-->

#### Enable partition merge to configure an optimal database partition layout  
  
Your account has collections that could benefit from enabling partition merge. Minimizing the number of partitions will reduce rate limiting and resolve storage fragmentation problems. Containers are likely to benefit from this if the RU/s per physical partition is < 3000 RUs and storage is < 20 GB.  
  
**Potential benefits**: Improve performance and lower the chance of rate-limiting  

**Impact:** High
  
For more information, see [Merge partitions (preview) - Azure Cosmos DB](/azure/cosmos-db/merge?tabs=azure-powershell)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: bf161e78-ce57-4198-82e8-a34522045518  


<!--bf161e78-ce57-4198-82e8-a34522045518_end-->

<!--54537590-fff7-4680-bdf8-5e37b5cf0c12_begin-->

#### Enable near real-time analytics or reporting on your Azure Cosmos DB data  
  
Mirroring Azure Cosmos DB in Microsoft Fabric is now available in preview for NoSQL API. If you are considering enabling near real-time analytics or reporting on your Azure Cosmos DB data, we recommend that you try mirroring to assess overall fit for your organization.  
  
**Potential benefits**: Better analytical performance  

**Impact:** Low
  
For more information, see [Microsoft Fabric Mirrored Databases From Azure Cosmos DB (Preview) - Microsoft Fabric](/fabric/database/mirrored-database/azure-cosmos-db)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 54537590-fff7-4680-bdf8-5e37b5cf0c12  


<!--54537590-fff7-4680-bdf8-5e37b5cf0c12_end-->

<!--a850ac78-dcea-485d-9c86-17a5f2cf56c4_begin-->

#### Monitor Azure Cosmos DB data by using resource-specific diagnostic settings.  
  
Save costs by switching to resource-specific diagnostic settings for Azure Cosmos DB to get more granular control over the logs and metrics that are collected for your resources.  
  
**Potential benefits**: Improve monitoring and troubleshooting of Azure Cosmos DB resources.  

**Impact:** Medium
  
For more information, see [Monitor data using diagnostic settings - Azure Cosmos DB](/azure/cosmos-db/monitor-resource-logs?tabs=azure-portal#create-diagnostic-settings)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: a850ac78-dcea-485d-9c86-17a5f2cf56c4  


<!--a850ac78-dcea-485d-9c86-17a5f2cf56c4_end-->

<!--5c48d9ec-397c-4f11-a342-929a1208c375_begin-->

#### Upgrade the Azure Cosmos DB account to TLS 1.2 or later  
  
Azure Cosmos database users must use secure connections using Transport Layer Security (TLS) 1.2 or later to provide optimal reliability, security, and performance.  
  
**Potential benefits**: Enhanced security and reliability for data transmissions.  

**Impact:** High
  
For more information, see [Self-Serve Minimum TLS Version Enforcement - Azure Cosmos DB](/azure/cosmos-db/self-serve-minimum-tls-enforcement)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 5c48d9ec-397c-4f11-a342-929a1208c375  


<!--5c48d9ec-397c-4f11-a342-929a1208c375_end-->


<!--articleBody-->
