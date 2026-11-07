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
  
Based on your usage over the past 7 days, enabling autoscale can reduce costs by automatically scaling RU/s down when capacity isn't needed. Estimated savings are based on your provisioned RU/s compared with actual utilization.  
  
**Impact:** Medium
  
For more information, see [Create Azure Cosmos DB containers and databases in autoscale or dynamic scaling mode. ](/azure/cosmos-db/provision-throughput-autoscale)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: cdf51428-a41b-4735-ba23-39f3b7cde20c  

<!--cdf51428-a41b-4735-ba23-39f3b7cde20c_end-->

<!--4a993d7c-9d83-4d85-b5a9-7cce0b136378_begin-->

#### Review the configuration of your Azure Cosmos DB free tier account  
  
Your Azure Cosmos DB free tier account has provisioned throughput above 1,000 RU/s. Free tier covers only the first 1,000 RU/s, so any additional provisioned throughput is billed at standard rates.  
  
**Impact:** Medium
  
For more information, see [Understanding your Azure Cosmos DB bill ](/azure/cosmos-db/understand-your-bill#azure-free-tier)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 4a993d7c-9d83-4d85-b5a9-7cce0b136378  

<!--4a993d7c-9d83-4d85-b5a9-7cce0b136378_end-->

<!--a4255ba5-b07e-45ae-99ca-25e6c2079e3c_begin-->

#### Consider taking action on the idle Azure Cosmos DB containers  
  
We haven't detected any activity over the past 30 days on one or more of your Azure Cosmos DB containers. Consider lowering their throughput, or deleting them if you don't plan on using them.  
  
**Impact:** Medium
  
For more information, see [Provision Container Throughput - Azure Cosmos DB](/azure/cosmos-db/how-to-provision-container-throughput)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: a4255ba5-b07e-45ae-99ca-25e6c2079e3c  

<!--a4255ba5-b07e-45ae-99ca-25e6c2079e3c_end-->

<!--57a36b11-140b-4276-a162-9919ca4e9462_begin-->

#### Save cost by using continuous backup with Fabric Mirroring  
  
You can now enable continuous backup on the same Azure Cosmos DB accounts where Azure Synapse Link is enabled. With continuous backup, you can reduce cost with backups and enable Fabric Mirroring.  
  
**Impact:** Low
  
For more information, see [Microsoft Fabric Mirrored Databases From Azure Cosmos DB (Preview) - Microsoft Fabric ](/fabric/database/mirrored-database/azure-cosmos-db)  

ResourceType: microsoft.documentdb/databaseaccounts  
Recommendation ID: 57a36b11-140b-4276-a162-9919ca4e9462  

<!--57a36b11-140b-4276-a162-9919ca4e9462_end-->

<!--articleBody-->
