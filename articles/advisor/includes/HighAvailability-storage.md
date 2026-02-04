---
ms.service: azure
ms.topic: include
ms.date: 01/27/2026
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

<!--1d70919c-1a4a-4f79-8300-bb576c291e9d_begin-->

#### Upgrade general-purpose v1 storage accounts  
  
Migrate to general-purpose v2 storage account or specialized alternatives based on workload requirements, such as BlockBlobStorage or FileStorage.  
  
**Potential benefits**: Avoid service disruptions and gain improved performance  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=496964)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 1d70919c-1a4a-4f79-8300-bb576c291e9d  
Subcategory: undefined

<!--1d70919c-1a4a-4f79-8300-bb576c291e9d_end-->

<!--42dbf883-9e4b-4f84-9da4-232b87c4b5e9_begin-->

#### Enable Soft Delete to protect your blob data  
  
Soft Delete puts deleted data into a soft deleted state instead of permanently deleted. When data is overwritten, a soft deleted snapshot is generated to save the state of the overwritten data. You can configure the amount of time soft deleted data is recoverable before it permanently expires.  
  
**Potential benefits**: Restore blobs or snapshots after overwrite or deletion  

**Impact:** Medium
  
For more information, see [Soft delete for blobs - Azure Storage](https://aka.ms/softdelete)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 42dbf883-9e4b-4f84-9da4-232b87c4b5e9  
Subcategory: undefined

<!--42dbf883-9e4b-4f84-9da4-232b87c4b5e9_end-->

<!--26cbb942-7c43-4f4b-af10-116f5b107acc_begin-->

#### Migrate BlobFuse to version 2  
  
Migrate BlobFuse to BlobFuse2. All future enhancements and innovations related to Azure Blob Storage file system access exclusively focuses on BlobFuse2.  
  
**Potential benefits**: Enhancements to Azure Blob Storage file system access  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=498563)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 26cbb942-7c43-4f4b-af10-116f5b107acc  
Subcategory: undefined

<!--26cbb942-7c43-4f4b-af10-116f5b107acc_end-->

<!--ced5fa9f-b5bf-4982-9f25-8190fb36dfca_begin-->

#### Support for TLS 1.0 and TLS 1.1 in Azure storage accounts is ending  
  
Upgrade TLS to latest version. Support for TLS 1.0 and TLS 1.1 in Azure storage accounts is ending.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: ced5fa9f-b5bf-4982-9f25-8190fb36dfca  
Subcategory: undefined

<!--ced5fa9f-b5bf-4982-9f25-8190fb36dfca_end-->


<!--articleBody-->
