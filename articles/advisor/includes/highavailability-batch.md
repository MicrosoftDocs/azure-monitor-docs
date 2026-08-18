---
ms.service: azure
ms.topic: include
ms.date: 08/11/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Batch
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Batch  
  
<!--aa137cec-e89e-4e49-9c24-ce72272f7141_begin-->

#### The ability to allocate low-priority compute nodes in Azure Batch pools is being retired.  
  
Migrate your Batch pools with low-priority compute nodes to compute nodes based on Spot instances.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=azure-batch-low-priority-vms-will-be-retired-on-30-september-2025)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: aa137cec-e89e-4e49-9c24-ce72272f7141  
Subcategory: ServiceUpgradeAndRetirement

<!--aa137cec-e89e-4e49-9c24-ce72272f7141_end-->

<!--a0c7e2c5-1e3c-42bf-8261-e0fa32802b23_begin-->

#### Azure Batch classic compute node communication model is being retired  
  
The simplified compute node communication model replaces the classic compute node communication model  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://aka.ms/batchclassiccomputenoderetirement)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: a0c7e2c5-1e3c-42bf-8261-e0fa32802b23  
Subcategory: ServiceUpgradeAndRetirement

<!--a0c7e2c5-1e3c-42bf-8261-e0fa32802b23_end-->

<!--f899b06d-e069-475d-abb3-292aa803db11_begin-->

#### Azure Batch is being retired in select regions  
  
The ability to allocate low-priority compute nodes in Azure Batch pools is being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://aka.ms/batchregion1retirement)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: f899b06d-e069-475d-abb3-292aa803db11  
Subcategory: ServiceUpgradeAndRetirement

<!--f899b06d-e069-475d-abb3-292aa803db11_end-->

<!--9203ac17-27f9-4457-81d7-deb45ad0ce60_begin-->

#### Azure Batch custom image pools using VHD or managed images are being retired  
  
Azure Batch is retiring support for custom image pools using VHD blobs in Azure Storage and Azure Managed Images  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://aka.ms/batchcipvhdretirement)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 9203ac17-27f9-4457-81d7-deb45ad0ce60  
Subcategory: ServiceUpgradeAndRetirement

<!--9203ac17-27f9-4457-81d7-deb45ad0ce60_end-->

<!--22fee21a-ecbc-4662-be2f-4611290bcabe_begin-->

#### Default outbound access connectivity for VMs in Azure is being retired  
  
If you are currently relying on default Internet outbound access, add an explicit outbound access mechanism for your Batch pools without public IP addresses  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://aka.ms/batchdoaretirement)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 22fee21a-ecbc-4662-be2f-4611290bcabe  
Subcategory: ServiceUpgradeAndRetirement

<!--22fee21a-ecbc-4662-be2f-4611290bcabe_end-->

<!--42447382-5a3f-4da4-88e3-0ee174ab7764_begin-->

#### Ubuntu 22.04 LTS support ends for Azure Batch pools  
  
Ubuntu 22.04 LTS is reaching the end of standard support life. Batch pools with Ubuntu 22.04 LTS VM images will no longer be supported in Batch. Migrate Batch pools to a newer VM image.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=558365)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 42447382-5a3f-4da4-88e3-0ee174ab7764  
Subcategory: undefined

<!--42447382-5a3f-4da4-88e3-0ee174ab7764_end-->

<!--bdb3cf17-47a1-4727-ab02-98856925e50f_begin-->

#### Migrate batch pools from HBv2 to newer virtual machine SKUs  
  
HBv2-series virtual machine (VMs) sizes are retiring. To ensure continuity and improved performance, transition to one of the current‑generation Azure HPC VM families, Azure HBv5‑series or Azure HX‑series.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=548525)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: bdb3cf17-47a1-4727-ab02-98856925e50f  
Subcategory: undefined

<!--bdb3cf17-47a1-4727-ab02-98856925e50f_end-->

<!--0e613505-c557-41b8-90fd-2946528db0f2_begin-->

#### Migrate batch pools from HCv1 to newer virtual machine SKUs  
  
HC-series virtual machine (VMs) sizes are retiring. To ensure continuity and improved performance, transition to one of the current‑generation Azure HPC VM families, Azure HBv5‑series or Azure HX‑series.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=548543)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 0e613505-c557-41b8-90fd-2946528db0f2  
Subcategory: undefined

<!--0e613505-c557-41b8-90fd-2946528db0f2_end-->

<!--articleBody-->
