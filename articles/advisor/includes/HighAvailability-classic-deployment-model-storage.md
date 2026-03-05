---
ms.service: azure
ms.topic: include
ms.date: 12/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Classic deployment model storage
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Classic deployment model storage  
  
<!--fd04ff97-d3b3-470a-9544-dfea3a5708db_begin-->

#### Action required: Migrate classic storage accounts by 8/30/2024  
  
Migrate your classic storage accounts to Azure Resource Manager to ensure business continuity. Azure Resource Manager will provide all of the same functionality plus a consistent management layer, resource grouping, and access to new features and updates.  
  
**Potential benefits**: Maintain the ability to manage your data  

**Impact:** High
  
For more information, see [We're retiring classic storage accounts on August 31, 2024 - Azure Storage](/azure/storage/common/classic-account-migration-overview)  

ResourceType: microsoft.classicstorage/storageaccounts  
Recommendation ID: fd04ff97-d3b3-470a-9544-dfea3a5708db  
Subcategory: undefined

<!--fd04ff97-d3b3-470a-9544-dfea3a5708db_end-->


<!--3b56a230-55c4-410f-89e6-d8d596f78593_begin-->

#### The legacy version of the Azure Storage Data Movement Library (v2) is retiring  
  
The modern version of the Azure Storage Data Movement Library offers important upgrades including checkpointing, shared infrastructure with Azure Storage v12 client libraries, and provides improved performance and reliability.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485106)  

ResourceType: microsoft.classicstorage/storageaccounts  
Recommendation ID: 3b56a230-55c4-410f-89e6-d8d596f78593  
Subcategory: ServiceUpgradeAndRetirement

<!--3b56a230-55c4-410f-89e6-d8d596f78593_end-->

<!--articleBody-->
