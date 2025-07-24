---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure SQL Database
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure SQL Database  
  
<!--ef14bcc2-41a5-41f6-bca8-10764cfbdee0_begin-->

#### Create statistics on table columns  
  
We detected that you are missing table statistics which may be impacting query performance. The query optimizer uses statistics to estimate the cardinality or number of rows in the query result which enables the query optimizer to create a high quality query plan.  
  
**Potential benefits**: Increase query performance  

**Impact:** High
  
For more information, see [Create and update statistics on tables - Azure Synapse Analytics](https://aka.ms/learnmorestatistics)  

ResourceType: microsoft.sql/sqldatawarehouses  
Recommendation ID: ef14bcc2-41a5-41f6-bca8-10764cfbdee0  


<!--ef14bcc2-41a5-41f6-bca8-10764cfbdee0_end-->

<!--9d7196d1-2d7c-4316-820f-7374a4ddf250_begin-->

#### Remove data skew to increase query performance  
  
We detected distribution data skew greater than 15%. This can cause costly performance bottlenecks.  
  
**Potential benefits**: Increase query performance  

**Impact:** High
  
For more information, see [Distributed tables design guidance - Azure Synapse Analytics](https://aka.ms/learnmoredataskew)  

ResourceType: microsoft.sql/sqldatawarehouses  
Recommendation ID: 9d7196d1-2d7c-4316-820f-7374a4ddf250  


<!--9d7196d1-2d7c-4316-820f-7374a4ddf250_end-->

<!--dd93fbbf-e5ef-4c7c-886e-2bfef0958f45_begin-->

#### Split staged files in the storage account to increase load performance  
  
We detected that you can increase load throughput by splitting your compressed files that are staged in your storage account. A good rule of thumb is to split compressed files into 60 or more to maximize the parallelism of your load.  
  
**Potential benefits**: Increase load performance  

**Impact:** High
  
For more information, see [Data loading best practices for dedicated SQL pools - Azure Synapse Analytics](https://aka.ms/learnmorefilesplit)  

ResourceType: microsoft.sql/sqldatawarehouses  
Recommendation ID: dd93fbbf-e5ef-4c7c-886e-2bfef0958f45  


<!--dd93fbbf-e5ef-4c7c-886e-2bfef0958f45_end-->

<!--33e515fe-354c-4016-a0f7-c4d6585aea61_begin-->

#### Scale up or update resource class to reduce tempdb contention with SQL Data Warehouse  
  
We detected that you had high tempdb utilization which can impact the performance of your workload.  
  
**Potential benefits**: Increase query performance  

**Impact:** High
  
For more information, see [Monitor your dedicated SQL pool workload using DMVs - Azure Synapse Analytics](https://aka.ms/learnmoretempdb)  

ResourceType: microsoft.sql/sqldatawarehouses  
Recommendation ID: 33e515fe-354c-4016-a0f7-c4d6585aea61  


<!--33e515fe-354c-4016-a0f7-c4d6585aea61_end-->

<!--293984cf-b551-461f-b22d-9659ebd09a4f_begin-->

#### Convert tables to replicated tables with SQL Data Warehouse  
  
We detected that you may benefit from using replicated tables. To avoid costly data movement operations and significantly increase the performance of your workload, use replicated tables.  
  
**Potential benefits**: Increase query performance  

**Impact:** High
  
For more information, see [Design guidance for replicated tables - Azure Synapse Analytics](https://aka.ms/learnmorereplicatedtables)  

ResourceType: microsoft.sql/sqldatawarehouses  
Recommendation ID: 293984cf-b551-461f-b22d-9659ebd09a4f  


<!--293984cf-b551-461f-b22d-9659ebd09a4f_end-->

<!--01dea77b-3ca4-4583-9b09-88f5a8fd5857_begin-->

#### Update statistics on table columns  
  
We detected that you do not have up-to-date table statistics which may be impacting query performance. The query optimizer uses up-to-date statistics to estimate the cardinality or number of rows in the query result which enables the query optimizer to create a high quality query plan.  
  
**Potential benefits**: Increase query performance  

**Impact:** High
  
For more information, see [Create and update statistics on tables - Azure Synapse Analytics](https://aka.ms/learnmorestatistics)  

ResourceType: microsoft.sql/sqldatawarehouses  
Recommendation ID: 01dea77b-3ca4-4583-9b09-88f5a8fd5857  


<!--01dea77b-3ca4-4583-9b09-88f5a8fd5857_end-->

<!--articleBody-->
