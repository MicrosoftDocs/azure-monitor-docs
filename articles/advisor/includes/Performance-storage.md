---
ms.service: azure
ms.topic: include
ms.date: 04/14/2026
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

<!--6708739d-5221-4d53-9960-698cd2fd9628_begin-->

#### Enable SMB Multichannel for storage account  
  
We observed that the SMB multichannel isn't enabled for your storage account. SMB Multichannel enables an SMB 3.x client to establish multiple network connections to an SMB file share. Increased performance is achieved by bandwidth aggregation over multiple NICs and utilizing RSS support.  
  
**Potential benefits**: Increase performance of file shares using SMB Multichannel  

**Impact:** Medium
  
For more information, see [SMB file shares in Azure Files](https://aka.ms/AzureFiles/SMBMultichannel/setup)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 6708739d-5221-4d53-9960-698cd2fd9628  

<!--6708739d-5221-4d53-9960-698cd2fd9628_end-->

<!--d05351cc-1014-4a6c-9173-bec1bcc48849_begin-->

#### Increase provisioned size of premium file share to avoid throttling of requests  
  
Your requests for premium file share are throttled as the I/O operations per second (IOPS) or throughput limits for the file share reached the share limits. To prevent your requests from being throttled, increase the provision size of the premium file share.  
  
**Potential benefits**: Boost performance of premium file share by increasing size  

**Impact:** High
  
For more information, see [Create a classic file share - Azure Files](https://aka.ms/azurefiles/advisor/expandfileshare)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: d05351cc-1014-4a6c-9173-bec1bcc48849  

<!--d05351cc-1014-4a6c-9173-bec1bcc48849_end-->

<!--articleBody-->
