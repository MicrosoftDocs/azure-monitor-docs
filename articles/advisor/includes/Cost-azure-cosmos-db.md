---
ms.service: azure
ms.topic: include
ms.date: 04/14/2026
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Azure Cosmos DB
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Cosmos DB  
  
<!--cdf51428-a41b-4735-ba23-39f3b7cde20c_begin-->

#### Enable autoscale on your Azure Cosmos DB database or container  
  
Based on your usage in the past 7 days, you can save by enabling autoscale. For each hour, we compared the RU/s provisioned to the actual utilization of the RU/s (what autoscale would have scaled to) and calculated the cost savings across the time period. Autoscale helps optimize your cost by scaling down RU/s when not in use.  
  
**Potential benefits**: Optimize Azure spend  

**Impact:** Medium
  
For more information, see [Create Azure Cosmos DB containers and databases in autoscale or dynamic scaling mode. ](/azure/cosmos-db/provision-throughput-autoscale)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: cdf51428-a41b-4735-ba23-39f3b7cde20c  


<!--cdf51428-a41b-4735-ba23-39f3b7cde20c_end-->

<!--4a993d7c-9d83-4d85-b5a9-7cce0b136378_begin-->

#### Review the configuration of your Azure Cosmos DB free tier account  
  
Your Azure Cosmos DB free tier account is currently containing resources with a total provisioned throughput exceeding 1000 Request Units per second (RU/s). Because Azure Cosmos DB's free tier only covers the first 1000 RU/s of throughput provisioned across your account, any throughput beyond 1000 RU/s is billed at the regular pricing. As a result, we anticipate that you are charged for the throughput currently provisioned on your Azure Cosmos DB account.  
  
**Potential benefits**: Confirm your expected Azure Cosmos DB costs  

**Impact:** Medium
  
For more information, see [Understanding your Azure Cosmos DB bill ](/azure/cosmos-db/understand-your-bill#azure-free-tier)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 4a993d7c-9d83-4d85-b5a9-7cce0b136378  


<!--4a993d7c-9d83-4d85-b5a9-7cce0b136378_end-->

<!--a4255ba5-b07e-45ae-99ca-25e6c2079e3c_begin-->

#### Consider taking action on the idle Azure Cosmos DB containers  
  
We haven't detected any activity over the past 30 days on one or more of your Azure Cosmos DB containers. Consider lowering their throughput, or deleting them if you don't plan on using them.  
  
**Potential benefits**: Optimize Azure spend  

**Impact:** Medium
  
For more information, see [Provision Container Throughput - Azure Cosmos DB](/azure/cosmos-db/how-to-provision-container-throughput)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: a4255ba5-b07e-45ae-99ca-25e6c2079e3c  


<!--a4255ba5-b07e-45ae-99ca-25e6c2079e3c_end-->


<!--ceb9372d-60f6-4564-8033-a8b1ead4fa76_begin-->

#### Upgrade the Azure Cosmos DB for MongoDB API to version 4.2 for reduced query and storage costs  
  
Migrate the data in the existing database account to a new database account created using Azure Cosmos DB for MongoDB API version 4.2. It uses a new storage format to reduce storage costs up to 55% and query costs up to 45%. It provides other features including multi-document transactions.  
  
**Potential benefits**: Improved query and storage cost efficiency.  

**Impact:** Medium
  
For more information, see [4.2 Supported Features and Syntax - Azure Cosmos DB for MongoDB](/azure/cosmos-db/mongodb/feature-support-42)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: ceb9372d-60f6-4564-8033-a8b1ead4fa76  


<!--ceb9372d-60f6-4564-8033-a8b1ead4fa76_end-->


<!--57a36b11-140b-4276-a162-9919ca4e9462_begin-->

#### Save cost by using continuous backup with Fabric Mirroring  
  
You can now enable continuous backup on the same Azure Cosmos DB accounts where Azure Synapse Link is enabled. With continuous backup, you can reduce cost with backups and enable Fabric Mirroring.  
  
**Potential benefits**: Enables better performance and cost saving  

**Impact:** Low
  
For more information, see [Microsoft Fabric Mirrored Databases From Azure Cosmos DB (Preview) - Microsoft Fabric ](/fabric/database/mirrored-database/azure-cosmos-db)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 57a36b11-140b-4276-a162-9919ca4e9462  


<!--57a36b11-140b-4276-a162-9919ca4e9462_end-->

<!--articleBody-->
