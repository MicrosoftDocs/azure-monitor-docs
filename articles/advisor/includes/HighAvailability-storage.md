---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Storage
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Storage

<!--8ef907f4-f8e3-4bf1-962d-27e005a7d82d_begin-->

#### Configure blob backup  
  
Azure blob backup helps protect data from accidental or malicious deletion. We recommend that you configure blob backup.  
  
**Potential benefits**: Protect data from accidental or malicious deletion  

**Impact:** Medium
  
For more information, see [Overview of Azure Blobs backup - Azure Backup ](/azure/backup/blob-backup-overview)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 8ef907f4-f8e3-4bf1-962d-27e005a7d82d  
Subcategory: DisasterRecovery

<!--8ef907f4-f8e3-4bf1-962d-27e005a7d82d_end-->




<!--4c10f447-fc3d-48b5-931d-23cea8486023_begin-->

#### Enable zone redundancy for storage accounts to improve high availability and resiliency  
  
By default, data in a storage account is replicated three times within a single data center. If the application must be highly available, convert the data to Zone Redundant Storage (ZRS). ZRS takes advantage of Azure availability zones to replicate data across three separate data centers.  
  
**Potential benefits**: Achieve higher availability for the application.  

**Impact:** High
  
For more information, see [Data redundancy - Azure Storage](https://aka.ms/learnmore_storage_storageaccounts)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 4c10f447-fc3d-48b5-931d-23cea8486023  
Subcategory: HighAvailability

<!--4c10f447-fc3d-48b5-931d-23cea8486023_end-->

<!--articleBody-->
