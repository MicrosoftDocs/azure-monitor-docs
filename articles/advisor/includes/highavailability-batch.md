---
ms.service: azure
ms.topic: include
ms.date: 06/09/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Batch
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Batch  
  
<!--bdc11098-207d-4e5f-9d00-ec506a407464_begin-->

#### Migrate Azure Batch Pools from Av2, F, Fs, Fsv2, G, Gs, Lsv2  
  
Av2-series, F-series, Fs-series, Fsv2-series, G-series, Gs-series, and Lsv2-series Virtual Machines for Azure Batch pools are being retired. Need to migrate to Dsv5/Ddsv5/Dasv5 (general purpose/compute); Lsv3/Lasv3 (storage/memory optimized); Dlsv6/Falsv6 (compute optimized).  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=500682)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: bdc11098-207d-4e5f-9d00-ec506a407464  
Subcategory: undefined

<!--bdc11098-207d-4e5f-9d00-ec506a407464_end-->

<!--c081d84e-3811-478b-b083-c8bb09b99ed7_begin-->

#### Migrate Azure Batch Pools from D, Ds, Dv2, Dsv2, Ls Virtual Machines  
  
Dsv2-series, and Ls-series Virtual Machines for Azure Batch pools are being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Retired VM Sizes Migration Guide - Azure Virtual Machines](/azure/virtual-machines/migration/sizes/d-ds-dv2-dsv2-ls-series-migration-guide)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: c081d84e-3811-478b-b083-c8bb09b99ed7  
Subcategory: undefined

<!--c081d84e-3811-478b-b083-c8bb09b99ed7_end-->

<!--6c4cd580-41fb-4f20-977b-3be3cbead46e_begin-->

#### Migrate Azure Batch Pools to VMs that support encryption at host  
  
Azure Disk Encryption (ADE) for Azure Virtual Machines and Virtual Machine Scale Sets are being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Migrate from Azure Disk Encryption to encryption at host - Azure Virtual Machines](/azure/virtual-machines/disk-encryption-migrate?tabs=CLI%2CCLI2%2CCLI3%2CCLI4%2CCLI5%2CCLI-cleanup)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 6c4cd580-41fb-4f20-977b-3be3cbead46e  
Subcategory: undefined

<!--6c4cd580-41fb-4f20-977b-3be3cbead46e_end-->

<!--articleBody-->
