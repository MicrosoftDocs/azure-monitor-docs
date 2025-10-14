---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
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

<!--f39dc18e-4830-4027-962b-e27cb9bb1458_begin-->

#### Configure backup and enable soft delete for Azure Files to provide data protection  
  
Configure backup and enable soft delete to store data on a schedule and make the backup available to restore as needed.  
  
**Potential benefits**: Protect data against accidental loss or corruption  

**Impact:** Medium
  
For more information, see [Accidental Delete Protection for Azure Files - Azure Backup](/azure/backup/soft-delete-azure-file-share)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: f39dc18e-4830-4027-962b-e27cb9bb1458  
Subcategory: undefined

<!--f39dc18e-4830-4027-962b-e27cb9bb1458_end-->

<!--b18744b9-2718-4617-9cdd-f6fad6cbc0cf_begin-->

#### Migrate to geo-redundant storage for standard files replicated using locally redundant storage  
  
Migrate storage accounts with standard files to geo-redundant storage to replicate data across Azure regions, ensure durability, and protect against regional failures.  
  
**Potential benefits**: Increase data durability and availability across regions.  

**Impact:** High
  
For more information, see [Change how a storage account is replicated - Azure Storage](/azure/storage/common/redundancy-migration?tabs=portal)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: b18744b9-2718-4617-9cdd-f6fad6cbc0cf  
Subcategory: undefined

<!--b18744b9-2718-4617-9cdd-f6fad6cbc0cf_end-->

<!--ebe76d14-0f9e-4fd2-b453-f04f8852dc8f_begin-->

#### Configure backup for Azure Files to provide data protection  
  
Configure backup to store data on a schedule and make the backup available to restore as needed.  
  
**Potential benefits**: Protect data against accidental loss or corruption  

**Impact:** Medium
  
For more information, see [Back up Azure Files in the Azure portal - Azure Backup](/azure/backup/backup-azure-files?tabs=recovery-services-vault)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: ebe76d14-0f9e-4fd2-b453-f04f8852dc8f  
Subcategory: undefined

<!--ebe76d14-0f9e-4fd2-b453-f04f8852dc8f_end-->

<!--articleBody-->
