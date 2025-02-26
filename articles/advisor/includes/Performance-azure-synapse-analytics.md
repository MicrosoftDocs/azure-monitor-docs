---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Synapse Analytics
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Synapse Analytics  
  
<!--7c83695a-3fa9-4668-9080-85151f5ab7be_begin-->

#### Update SynapseManagementClient SDK Version  
  
New SynapseManagementClient is using .NET SDK 4.0 or above.  
  
**Potential benefits**: Latest SynapseManagementClient Libraries contain fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [SynapseManagementClient Class (Microsoft.Azure.Management.Synapse) - Azure for .NET Developers](https://aka.ms/UpgradeSynapseManagementClientSDK)  

ResourceType: microsoft.synapse/workspaces  
Recommendation ID: 7c83695a-3fa9-4668-9080-85151f5ab7be  


<!--7c83695a-3fa9-4668-9080-85151f5ab7be_end-->

<!--2699ef96-788d-41b6-939c-cebe568f7875_begin-->

#### Tables with Clustered Columnstore Indexes (CCI) with less than 60 million rows  
  
Clustered columnstore tables are organized in data into segments. Having high segment quality is critical to achieving optimal query performance on a columnstore table. Segment quality is measured using the number of rows in a compressed row group.  
  
**Potential benefits**: CCI (Clustered Columnstore Index) is suitable for large tables, typically over 60 million rows. For smaller tables, consider creating the table as HEAP or Clustered Index with additional secondary Indexes.  

**Impact:** Medium
  
For more information, see [Best practices for dedicated SQL pools - Azure Synapse Analytics](https://aka.ms/AzureSynapseCCIGuidance)  

ResourceType: microsoft.synapse/workspaces  
Recommendation ID: 2699ef96-788d-41b6-939c-cebe568f7875  


<!--2699ef96-788d-41b6-939c-cebe568f7875_end-->

<!--articleBody-->
