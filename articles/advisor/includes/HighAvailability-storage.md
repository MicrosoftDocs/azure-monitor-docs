---
ms.service: azure
ms.topic: include
ms.date: 06/24/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Storage
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Storage  
  
<!--d42d751d-682d-48f0-bc24-bb15b61ac4b8_begin-->

#### Use Managed Disks for storage accounts reaching capacity limit  
  
When Premium SSD unmanaged disks in storage accounts are about to reach their Premium Storage capacity limit, failures might occur. To avoid failures when this limit is reached, migrate to Managed Disks that don't have an account capacity limit. This migration can be done through the portal in less than 5 minutes.  
  
**Potential benefits**: Avoid scale issues when account reaches capacity limit  

**Impact:** High
  
For more information, see [Scalability and performance targets for standard storage accounts - Azure Storage ](https://aka.ms/premium_blob_quota)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: d42d751d-682d-48f0-bc24-bb15b61ac4b8  
Subcategory: Scalability

<!--d42d751d-682d-48f0-bc24-bb15b61ac4b8_end-->

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
