---
ms.service: azure
ms.topic: include
ms.date: 06/09/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Cosmos DB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cosmos DB  
  
<!--5e4e9f04-9201-4fd9-8af6-a9539d13d8ec_begin-->

#### Configure Azure Cosmos DB containers with a partition key  
  
The Cosmos DB nonpartitioned collections are approaching the provisioned storage quota and might lose the ability to add data. Migrate to new collections that use a partition key definition, so the service automatically scales out the collections.
  
**Potential benefits**: Scale your containers seamlessly with increase in storage or request rates without running into any limits  

**Impact:** High
  
For more information, see [Partitioning and horizontal scaling - Azure Cosmos DB](/azure/cosmos-db/partitioning-overview#choose-partitionkey).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 5e4e9f04-9201-4fd9-8af6-a9539d13d8ec  
Subcategory: Scalability 

<!--5e4e9f04-9201-4fd9-8af6-a9539d13d8ec_end-->

<!--bdb595a4-e148-41f9-98e8-68ec92d1932e_begin-->

#### Use static Cosmos DB client instances in your code and cache the names of databases and collections  
  
A high number of metadata operations on an account can result in rate limiting. Metadata operations have a system-reserved request unit (RU) limit. Avoid rate limiting from metadata operations by using static Cosmos DB client instances in your code and caching the names of databases and collections.  
  
**Potential benefits**: Optimize your RU usage and avoid rate limiting  

**Impact:** Medium
  
For more information, see [Performance Tips for .NET SDK V2 - Azure Cosmos DB](/azure/cosmos-db/performance-tips)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: bdb595a4-e148-41f9-98e8-68ec92d1932e  

<!--bdb595a4-e148-41f9-98e8-68ec92d1932e_end-->

<!--44a0a07f-23a2-49df-b8dc-a1b14c7c6a9d_begin-->

#### Your Cosmos DB account can't access its linked Azure Key Vault that hosts your encryption key
  
When an Azure Cosmos DB account can't access its linked Azure Key Vault hosting the encyrption key, data access and security issues might happen. Your Azure Key Vault's configuration is preventing your Cosmos DB account from contacting the key vault to access your managed encryption keys. If you  recently performed a key rotation, ensure that the previous key, or key version, remains enabled and available until Cosmos DB completes the rotation. The previous key or key version can be disabled after 24 hours, or after the Azure Key Vault audit logs don't show any activity from Azure Cosmos DB on that key or key version.  
  
**Potential benefits**: Update your configurations to continue using customer-managed keys and access your data  

**Impact:** Medium
  
For more information, see [Configure customer-managed keys - Azure Cosmos DB](/azure/cosmos-db/how-to-setup-cmk).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 44a0a07f-23a2-49df-b8dc-a1b14c7c6a9d  
Subcategory: Other

<!--44a0a07f-23a2-49df-b8dc-a1b14c7c6a9d_end-->

<!--213974c8-ed9c-459f-9398-7cdaa3c28856_begin-->

#### Consider Consistent indexing mode on Azure Cosmos DB containers  
  
Azure Cosmos containers configured with the Lazy indexing mode update asynchronously, which improves write performance, but can impact query freshness. Your container is configured with the Lazy indexing mode. If query freshness is critical, use Consistent Indexing Mode for immediate index updates.  
  
**Potential benefits**: Improve query result consistency and reliability  

**Impact:** Medium
  
For more information, see [Manage indexing policies in Azure Cosmos DB](/azure/cosmos-db/how-to-manage-indexing-policy).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 213974c8-ed9c-459f-9398-7cdaa3c28856  
Subcategory: Other

<!--213974c8-ed9c-459f-9398-7cdaa3c28856_end-->

<!--bc9e5110-a220-4ab9-8bc9-53f92d3eef70_begin-->

#### Update Azure Cosmos DB Java SDK v2 to version 2.6.14 or migrate to Azure Cosmos DB Java SDK v4  
  
Migrate to Azure Cosmos DB Java SDK v4. As a hotflix, update Azure Cosmos DB Java SDK v2 to version 2.6.14. A critical bug in Azure Cosmos DB Async Java SDK v2 version 2.6.13 and earlier causes errors when a Global logical sequence number (LSN) is greater than the Max Integer value.  
  
**Potential benefits**: Without action, operations fail with NumberFormatException  

**Impact:** High
  
For more information, see [SQL Async Java API, SDK and Resources - Azure Cosmos DB](/azure/cosmos-db/sql/sql-api-sdk-async-java)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: bc9e5110-a220-4ab9-8bc9-53f92d3eef70  

<!--bc9e5110-a220-4ab9-8bc9-53f92d3eef70_end-->

<!--38942ae5-3154-4e0b-98d9-23aa061c334b_begin-->

#### Upgrade to the current recommended version of the Java SDK v4 to avoid a critical issue  
  
A critical bug affects Azure Cosmos DB Java SDK v4 versions 4.15 and earlier. When the Global Logical Sequence Number (LSN) exceeds the maximum integer value—something that can occur transparently after a large volume of transactions over a container’s lifetime—the SDK may start returning errors. To  
  
**Potential benefits**: All CRUD operations may fail with NumberFormatException  

**Impact:** High
  
For more information, see [Java SDK V4 for API for Nosql Release Notes and Resources - Azure Cosmos DB](/azure/cosmos-db/sql/sql-api-sdk-java-v4)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 38942ae5-3154-4e0b-98d9-23aa061c334b  

<!--38942ae5-3154-4e0b-98d9-23aa061c334b_end-->

<!--123039b5-0fda-4744-9a17-d6b5d5d122b2_begin-->

#### Use the new 3.6+ endpoint to connect to your upgraded Azure Cosmos DB's API for MongoDB account  
  
Some of your applications are connecting to your upgraded Azure Cosmos DB's API for MongoDB account using the legacy 3.2 endpoint - [accountname].documents.azure.com. Use the new endpoint - [accountname].mongo.cosmos.azure.com (or its equivalent in sovereign, government, or restricted clouds).  
  
**Potential benefits**: Take advantage of the latest features in version 3.6+ of Azure Cosmos DB's API for MongoDB  

**Impact:** Medium
  
For more information, see [4.0 server version supported features and syntax in Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb-feature-support-40).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 123039b5-0fda-4744-9a17-d6b5d5d122b2  
Subcategory: ServiceUpgradeAndRetirement

<!--123039b5-0fda-4744-9a17-d6b5d5d122b2_end-->

<!--0da795d9-26d2-4f02-a019-0ec383363c88_begin-->

#### Upgrade your Azure Cosmos DB API for MongoDB account to v4.2 to save on query/storage costs and utilize new features  
  
Your Azure Cosmos DB API for MongoDB account is eligible to upgrade to version 4.2. Upgrading to v4.2 can reduce your storage costs by up to 55% and your query costs by up to 45% by leveraging a new storage format. Numerous additional features such as multi-document transactions are also included in v4.2.  
  
**Potential benefits**: Improved reliability, query/storage efficiency, performance, and new feature capabilities  

**Impact:** Medium
  
For more information, see [Upgrade the Mongo version - Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb-version-upgrade).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 0da795d9-26d2-4f02-a019-0ec383363c88  
Subcategory: Other

<!--0da795d9-26d2-4f02-a019-0ec383363c88_end-->

<!--ec6fe20c-08d6-43da-ac18-84ac83756a88_begin-->

#### Enable Server Side Retry (SSR) on your Azure Cosmos DB's API for MongoDB account  
  
When an account is throwing a TooManyRequests error with the 16500 error code, enabling Server Side Retry (SSR) can help mitigate the issue.  
  
**Potential benefits**: Prevent throttling and improve your query reliability and performance  

**Impact:** High
  
For more information, see [Prevent rate-limiting errors for Azure Cosmos DB for MongoDB operations. - Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/prevent-rate-limiting-errors)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: ec6fe20c-08d6-43da-ac18-84ac83756a88  

<!--ec6fe20c-08d6-43da-ac18-84ac83756a88_end-->

<!--b57f7a29-dcc8-43de-86fa-18d3f9d3764d_begin-->

#### Add a second region to your production workloads on Azure Cosmos DB  
  
Production workloads on Azure Cosmos DB run in a single region might have availability issues, this appears to be the case with some of your Cosmos DB accounts. Increase their availability by configuring them to span at least two Azure regions. NOTE: Additional regions incur additional costs.  
  
**Potential benefits**: Improve the availability of your production workloads  

**Impact:** Medium
  
For more information, see [High availability (Reliability)  in Azure Cosmos DB for NoSQL](/azure/cosmos-db/high-availability).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: b57f7a29-dcc8-43de-86fa-18d3f9d3764d  
Subcategory: BusinessContinuity

<!--b57f7a29-dcc8-43de-86fa-18d3f9d3764d_end-->

<!--51a4e6bd-5a95-4a41-8309-40f5640fdb8b_begin-->

#### Upgrade your old Azure Cosmos DB SDK to the latest version  
  
An Azure Cosmos DB account using an old version of the SDK lacks the latest fixes and improvements. Your Azure Cosmos DB account is using an old version of the SDK. For the latest fixes, performance improvements, and new feature capabilities, upgrade to the latest version.  
  
**Potential benefits**: Improved reliability, performance, and new feature capabilities  

**Impact:** Medium
  
For more information, see [Azure Cosmos DB](/azure/cosmos-db/).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 51a4e6bd-5a95-4a41-8309-40f5640fdb8b  
Subcategory: Other

<!--51a4e6bd-5a95-4a41-8309-40f5640fdb8b_end-->

<!--60a55165-9ccd-4536-81f6-e8dc6246d3d2_begin-->

#### Upgrade outdated Azure Cosmos DB SDK to the latest version  
  
An Azure Cosmos DB account using an old version of the SDK lacks the latest fixes and improvements. Your Azure Cosmos DB account is using an outdated version of the SDK. We recommend upgrading to the latest version for the latest fixes, performance improvements, and new feature capabilities.  
  
**Potential benefits**: Improved reliability, performance, and new capabilities  

**Impact:** High
  
For more information, see [Azure Cosmos DB documentation - Azure Cosmos DB](/azure/cosmos-db/)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 60a55165-9ccd-4536-81f6-e8dc6246d3d2  

<!--60a55165-9ccd-4536-81f6-e8dc6246d3d2_end-->

<!--5de9f2e6-087e-40da-863a-34b7943beed4_begin-->

#### Enable service managed failover for Cosmos DB account  
  
Enable service managed failover for Cosmos DB account to ensure high availability of the account. Service managed failover automatically switches the write region to the secondary region in case of a primary region outage. This ensures that the application continues to function without any downtime.  
  
**Potential benefits**: Azure's Service-Managed Failover feature enhances system availability by automating failover processes, reducing downtime, and improving resilience.  

**Impact:** Medium
  
For more information, see [High availability (Reliability)  in Azure Cosmos DB for NoSQL](/azure/cosmos-db/high-availability).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 5de9f2e6-087e-40da-863a-34b7943beed4  
Subcategory: Other

<!--5de9f2e6-087e-40da-863a-34b7943beed4_end-->

<!--92056ca3-8fab-43d1-bebf-f9c377ef20e9_begin-->

#### Add at least one data center in another Azure region  
  
Your Azure Managed Instance for Apache Cassandra cluster is designated as a production cluster but is currently deployed in a single Azure region. For production clusters, we recommend adding at least one more data center in another Azure region to guard against disaster recovery scenarios.  
  
**Potential benefits**: Ensure applications have another region in case of disaster recovery  

**Impact:** Medium
  
For more information, see [Building resilient applications - Azure Managed Instance for Apache Cassandra](/azure/managed-instance-apache-cassandra/resilient-applications).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 92056ca3-8fab-43d1-bebf-f9c377ef20e9  
Subcategory: DisasterRecovery

<!--92056ca3-8fab-43d1-bebf-f9c377ef20e9_end-->

<!--a030f8ab-4dd4-4751-822b-f231a0df5f5a_begin-->

#### Avoid being rate limited for Control Plane operation  
  
We found high number of Control Plane operations on your account through resource provider. Request that exceeds the documented limits at sustained levels over consecutive 5-minute periods may experience request being throttling as well failed or incomplete operation on Azure Cosmos DB resources.  
  
**Potential benefits**: Optimize control plane operation and avoid operation failure due to rate limiting  

**Impact:** Medium
  
For more information, see [Service quotas and default limits - Azure Cosmos DB](/azure/cosmos-db/concepts-limits#control-plane).

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: a030f8ab-4dd4-4751-822b-f231a0df5f5a  
Subcategory: Scalability

<!--a030f8ab-4dd4-4751-822b-f231a0df5f5a_end-->

<!--52fef986-5897-4359-8b92-0f22749f0d73_begin-->

#### Improve resiliency by migrating your Azure Cosmos DB accounts to continuous backup  
  
Your Azure Cosmos DB accounts use periodic backup. Continuous backup with point-in-time restore is now available - restore data to any moment in the past 30 days. It may also be more cost-effective, retaining only a single copy of your data.  
  
**Potential benefits**: Improve the resiliency of your Azure Cosmos DB workloads  

**Impact:** Medium
  
For more information, see [Continuous Backup with Point-in-Time Restore - Azure Cosmos DB](/azure/cosmos-db/continuous-backup-restore-introduction)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 52fef986-5897-4359-8b92-0f22749f0d73  
Subcategory: BusinessContinuity

<!--52fef986-5897-4359-8b92-0f22749f0d73_end-->

<!--a2002089-9dd1-46b6-881c-d0f349515230_begin-->

#### Evaluate multi-region write capability in Azure Cosmos DB  
  
Multi-region writes enable high availability but require careful consistency and conflict resolution. Using Bounded Staleness is an anti-pattern, as replication lag increases latency and coordination overhead. This setup undermines scalability, impacting performance and availability.  
  
**Potential benefits**: Enhances high availability  

**Impact:** High
  
For more information, see [Configure Multi-Region Writes](/azure/cosmos-db/nosql/how-to-multi-master?tabs=api-async)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: a2002089-9dd1-46b6-881c-d0f349515230  

<!--a2002089-9dd1-46b6-881c-d0f349515230_end-->

<!--687f83d3-db01-4ab1-a77b-b31e99f16d33_begin-->

#### Enable zone redundancy for multi-region Cosmos DB accounts  
  
Enabling zone redundancy for multi-region Cosmos DB accounts to improve high availability and reduce the risk of data loss in case of a regional outage.  
  
**Potential benefits**: Improved availability and reliability  

**Impact:** High
  
For more information, see [High Availability (Reliability) in Azure Cosmos DB for NoSQL](https://aka.ms/learnmore_cosmos)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 687f83d3-db01-4ab1-a77b-b31e99f16d33  

<!--687f83d3-db01-4ab1-a77b-b31e99f16d33_end-->

<!--36b07167-9b19-4725-81bc-54e8e0510a0c_begin-->

#### Improve Resiliency with Per‑Partition Automatic Failover  
  
PPAF is a new Azure Cosmos DB preview feature that boosts availability for single‑write region accounts by failing over at the partition level instead of the entire account, reducing downtime and enabling faster recovery during regional outages.  
  
**Potential benefits**: Enhances single‑region availability  

**Impact:** Medium
  
  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 36b07167-9b19-4725-81bc-54e8e0510a0c  

<!--36b07167-9b19-4725-81bc-54e8e0510a0c_end-->

<!--649fd0b8-0bf0-43fe-bfa1-c408f6d33200_begin-->

#### Configure protection for Cosmos DB  
  
Vaulted backup helps in achieving cyber resiliency goals and long-term retention of backups helps in meeting compliance needs. The platform recommends configuring protection for Cosmos DB.  
  
**Potential benefits**: Achieve cyber resiliency goals and meet compliance needs  

**Impact:** Medium
  
For more information, see [About Azure Cosmos DB backup - Azure Backup](https://aka.ms/AzureBackupforCosmosDBPublicDoc)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 649fd0b8-0bf0-43fe-bfa1-c408f6d33200  

<!--649fd0b8-0bf0-43fe-bfa1-c408f6d33200_end-->

<!--3086bd6c-a257-4577-9401-fa9d1e0ce48a_begin-->

#### Azure Cosmos DB requires using TLS 1.2 or later  
  
All Cosmos DB database accounts must use Transport Layer Security (TLS) 1.2 or higher.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Self-Serve Minimum TLS Version Enforcement - Azure Cosmos DB](/azure/cosmos-db/self-serve-minimum-tls-enforcement)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 3086bd6c-a257-4577-9401-fa9d1e0ce48a  

<!--3086bd6c-a257-4577-9401-fa9d1e0ce48a_end-->

<!--0082c3b0-5b9c-4157-bb43-29307b6f882e_begin-->

#### Migrate Cosmos DB Synapse Link (NoSQL) to Fabric mirroring
  
Azure Synapse Link for Azure Cosmos DB NoSQL will be retired on March 31, 2029. Customers using this feature should migrate analytical workloads to Cosmos DB mirroring in Microsoft Fabric, the recommended replacement solution, before the retirement date to avoid service disruption and potential loss.
  
**Potential benefits**: Prevent disruption to Cosmos DB analytics workloads.

**Impact:** Medium
  
For more information, see [Migrate from Azure Synapse Link to Azure Cosmos DB mirroring in Microsoft Fabric - Microsoft Fabric](https://aka.ms/CosmosMirrorSynapseMigration)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 0082c3b0-5b9c-4157-bb43-29307b6f882e  

<!--0082c3b0-5b9c-4157-bb43-29307b6f882e_end-->

<!--articleBody-->
