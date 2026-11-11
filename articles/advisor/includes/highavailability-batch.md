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

<!--bdc11098-207d-4e5f-9d00-ec506a407464_end-->

<!--c081d84e-3811-478b-b083-c8bb09b99ed7_begin-->

#### Migrate Azure Batch Pools from D, Ds, Dv2, Dsv2, Ls Virtual Machines  
  
Dsv2-series, and Ls-series Virtual Machines for Azure Batch pools are being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Retired VM Sizes Migration Guide - Azure Virtual Machines](/azure/virtual-machines/migration/sizes/d-ds-dv2-dsv2-ls-series-migration-guide)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: c081d84e-3811-478b-b083-c8bb09b99ed7  

<!--c081d84e-3811-478b-b083-c8bb09b99ed7_end-->

<!--6c4cd580-41fb-4f20-977b-3be3cbead46e_begin-->

#### Migrate Azure Batch Pools to VMs that support encryption at host  
  
Azure Disk Encryption (ADE) for Azure Virtual Machines and Virtual Machine Scale Sets are being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Migrate from Azure Disk Encryption to encryption at host - Azure Virtual Machines](/azure/virtual-machines/disk-encryption-migrate?tabs=CLI%2CCLI2%2CCLI3%2CCLI4%2CCLI5%2CCLI-cleanup)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 6c4cd580-41fb-4f20-977b-3be3cbead46e  

<!--6c4cd580-41fb-4f20-977b-3be3cbead46e_end-->

<!--5c23301a-1a3c-46c5-b4e5-c0bb2b91b36c_begin-->

#### Availability in select regions is retiring  
  
Azure Batch is retiring in the following regions: India West, China North 1, China East 1, USDoD East, and USDoD Central. Azure Batch isn't retiring in any other regions. This notification is strictly for the regions mentioned.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/batch-service-in-select-regions-will-be-retired-on-31-march-2026/)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 5c23301a-1a3c-46c5-b4e5-c0bb2b91b36c  

<!--5c23301a-1a3c-46c5-b4e5-c0bb2b91b36c_end-->

<!--2a857ec5-3fa1-4e25-8959-05147ffaa66a_begin-->

#### Classic compute node communication model is retiring  
  
The classic compute node communication model is retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/azure-batch-classic-compute-node-communication-model-will-be-retired-on-31-march-2026/)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 2a857ec5-3fa1-4e25-8959-05147ffaa66a  

<!--2a857ec5-3fa1-4e25-8959-05147ffaa66a_end-->

<!--bdb3cf17-47a1-4727-ab02-98856925e50f_begin-->

#### Migrate batch pools from HBv2 to newer virtual machine SKUs  
  
HBv2-series virtual machine sizes are retiring. To ensure continuity and improved performance, transition to one of the current‑generation Azure HPC VM families, Azure HBv5‑series or Azure HX‑series.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=548525)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: bdb3cf17-47a1-4727-ab02-98856925e50f  

<!--bdb3cf17-47a1-4727-ab02-98856925e50f_end-->

<!--0e613505-c557-41b8-90fd-2946528db0f2_begin-->

#### Migrate batch pools from HCv1 to newer virtual machine SKUs  
  
HC-series virtual machine (VM) sizes are retiring. To ensure continuity and improved performance, transition to one of the current‑generation Azure HPC VM families, Azure HBv5‑series or Azure HX‑series.
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=548543)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 0e613505-c557-41b8-90fd-2946528db0f2  

<!--0e613505-c557-41b8-90fd-2946528db0f2_end-->

<!--df47adb1-1b61-4091-911a-d776f85ae81c_begin-->

#### Migrate workload to a supported Windows Server image  
  
Azure Batch is retiring support for Windows Server 2016. Migrate workload to a supported Windows Server image.  
  
**Potential benefits**: Avoid service disruption.

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=549077)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: df47adb1-1b61-4091-911a-d776f85ae81c  

<!--df47adb1-1b61-4091-911a-d776f85ae81c_end-->

<!--3e7bb96a-9aa8-494c-8e43-fc1108a35a9d_begin-->

#### NP, HC, and HBv2-series VM family retirement in Azure Batch pools  
  
NP-series, HC-series, and HBv2-series virtual machines are retiring. Migrate Batch pools to a newer VM series before the retirement date.
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Update pool properties - Azure Batch](/azure/batch/batch-pool-update-properties)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 3e7bb96a-9aa8-494c-8e43-fc1108a35a9d  

<!--3e7bb96a-9aa8-494c-8e43-fc1108a35a9d_end-->

<!--articleBody-->
