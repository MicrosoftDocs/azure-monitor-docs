---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Storage
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Storage  
  
<!--c6b94711-f1f5-4e7e-9c89-c17ed4190969_begin-->

#### Use premium performance block blob storage  
  
One or more of your storage accounts has a high transaction rate per GB of block blob data stored. Use premium performance block blob storage instead of standard performance storage for your workloads that require fast storage response times and/or high transaction rates and potentially save on storage costs.  
  
**Potential benefits**: Block blob storage performance boost with the lowest Azure transaction prices.  

**Impact:** Medium
  
For more information, see [Storage account overview - Azure Storage](https://aka.ms/usePremiumBlob)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: c6b94711-f1f5-4e7e-9c89-c17ed4190969  


<!--c6b94711-f1f5-4e7e-9c89-c17ed4190969_end-->

<!--d9823f54-3eaa-485b-a3b0-b9559c8e831f_begin-->

#### No Snapshots Detected  
  
We observed that there are no snapshots of your file shares. This means you aren't protected from accidental file deletion or file corruption scenarios. Enable snapshots to protect your data. To enable snapshots, you can use Azure Portal or Azure Backup or 3rd party solutions.  
  
**Potential benefits**: Schedule snapshots of your file shares to protect yourself from accidental file deletion or data corruption like ransomware.  

**Impact:** Medium
  
For more information, see [Use Azure Files share snapshots](/azure/storage/files/storage-snapshots-files)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: d9823f54-3eaa-485b-a3b0-b9559c8e831f  


<!--d9823f54-3eaa-485b-a3b0-b9559c8e831f_end-->

<!--b353f187-4cb4-4b2b-b502-472f45f32fd6_begin-->

#### Use Put Blob for blobs smaller than 256 MB  
  
When writing a block blob that is 256 MB or less (64 MB for requests using REST versions before May 31, 2016), you can upload it in its entirety with a single write operation using Put Blob. Based on your aggregated metrics, we believe your storage account's write operations can be optimized.  
  
**Potential benefits**: Increase performance and reduce operation costs.  

**Impact:** Medium
  
For more information, see [Understanding block blobs, append blobs, and page blobs - Azure Storage](https://aka.ms/understandblockblobs)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: b353f187-4cb4-4b2b-b502-472f45f32fd6  


<!--b353f187-4cb4-4b2b-b502-472f45f32fd6_end-->

<!--8433e84a-8f5c-4b6c-9052-9b98757348ea_begin-->

#### Upgrade to Standard SSD Disks for consistent and improved performance  
  
Because you are running IaaS virtual machine workloads on Standard HDD managed disks, we wanted to let you know that a Standard SSD disk option is now available for all Azure VM types. Standard SSD disks are a cost-effective storage option optimized for enterprise workloads that need consistent performance. Upgrade your disk configuration today for improved latency, reliability, and availability. Upgrading requires a VM reboot, which takes three to five minutes.  
  
**Potential benefits**: Improve disk latency, reliability, and availability using Standard SSD disks.  

**Impact:** Medium
  
For more information, see [Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines](/azure/virtual-machines/windows/disks-types#standard-ssd)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 8433e84a-8f5c-4b6c-9052-9b98757348ea  


<!--8433e84a-8f5c-4b6c-9052-9b98757348ea_end-->

<!--33557a7c-6dd6-4b46-9579-fc5273f07458_begin-->

#### Convert Unmanaged Disks from Standard HDD to Premium SSD for performance  
  
We have noticed your Unmanaged HDD Disk is approaching performance targets. Azure premium SSDs deliver high-performance and low-latency disk support for virtual machines with IO-intensive workloads. Give your disk performance a boost by upgrading your Standard HDD disk to Premium SSD disk. Upgrading requires a VM reboot, which takes three to five minutes.  
  
**Potential benefits**: Give your disk performance a boost using Premium SSD disks.  

**Impact:** Medium
  
For more information, see [Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines](/azure/virtual-machines/windows/disks-types#premium-ssd)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 33557a7c-6dd6-4b46-9579-fc5273f07458  


<!--33557a7c-6dd6-4b46-9579-fc5273f07458_end-->

<!--7e9fbfe8-1234-435c-b114-424445c9be6f_begin-->

#### Upgrade your Storage Client Library to the latest version for better reliability and performance  
  
The latest version of Storage Client Library/ SDK contains fixes to issues reported by customers and proactively identified through our QA process. The latest version also carries reliability and performance optimization in addition to new features that can improve your overall experience using Azure Storage.  
  
**Potential benefits**: Latest Storage Client Library contains fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [Install and manage packages in Visual Studio using the NuGet Package Manager](https://aka.ms/AA5wtca)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 7e9fbfe8-1234-435c-b114-424445c9be6f  


<!--7e9fbfe8-1234-435c-b114-424445c9be6f_end-->

<!--97172837-e5ea-45b2-af3b-cadbf428a6d9_begin-->

#### Upgrade your Storage Client Library to the latest version for better reliability and performance  
  
The latest version of Storage Client Library/ SDK contains fixes to issues reported by customers and proactively identified through our QA process. The latest version also carries reliability and performance optimization in addition to new features that can improve your overall experience using Azure Storage.  
  
**Potential benefits**: Latest Storage Client Library contains fixes for known issues and other improvements.  

**Impact:** Medium
  
  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 97172837-e5ea-45b2-af3b-cadbf428a6d9  


<!--97172837-e5ea-45b2-af3b-cadbf428a6d9_end-->

<!--6708739d-5221-4d53-9960-698cd2fd9628_begin-->

#### Enable SMB Multichannel for storage account  
  
We observed that the SMB multichannel isn't enabled for your storage account. SMB Multichannel enables an SMB 3.x client to establish multiple network connections to an SMB file share. An increased performance is achieved through bandwidth aggregation over multiple NICs and utilizing Receive S  
  
**Potential benefits**: Increase performance of file shares using SMB Multichannel  

**Impact:** Medium
  
For more information, see [SMB file shares in Azure Files](https://aka.ms/AzureFiles/SMBMultichannel/setup)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 6708739d-5221-4d53-9960-698cd2fd9628  


<!--6708739d-5221-4d53-9960-698cd2fd9628_end-->

<!--d05351cc-1014-4a6c-9173-bec1bcc48849_begin-->

#### Increase provisioned size of premium file share to avoid throttling of requests  
  
Your requests for premium file share are throttled as the I/O operations per second (IOPS) or throughput limits for the file share reached the share limits. To prevent your requests from being throttled, increase the provision size of the premium file share.  
  
**Potential benefits**: Boost performance of premium file share by increasing provisioned size  

**Impact:** High
  
For more information, see [Create an Azure file share - Azure Files](https://aka.ms/azurefiles/advisor/expandfileshare)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: d05351cc-1014-4a6c-9173-bec1bcc48849  


<!--d05351cc-1014-4a6c-9173-bec1bcc48849_end-->

<!--articleBody-->
