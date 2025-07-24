---
ms.service: azure
ms.topic: include
ms.date: 07/22/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Batch
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Batch  
  
<!--a37462ed-d4d7-4c42-bf88-f16a60e2f8b6_begin-->

#### Recreate your pool with a new image  
  
Your pool is using an image with an imminent expiration date. Recreate the pool with a new image to avoid potential interruptions. A list of newer images is available via the ListSupportedImages API.  
  
**Potential benefits**: Avoid potential interruptions  

**Impact:** High
  
For more information, see [Choose VM sizes and images for pools - Azure Batch](https://aka.ms/batch_expiring_image_learn_more)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: a37462ed-d4d7-4c42-bf88-f16a60e2f8b6  


<!--a37462ed-d4d7-4c42-bf88-f16a60e2f8b6_end-->

<!--48ae14cb-10de-4bd9-a005-5c25f498649b_begin-->

#### Delete and recreate your pool using a VM size that will soon be retired  
  
Your pool is using A8-A11 VMs, which are set to be retired in March 2021. Delete your pool and recreate it with a different VM size.  
  
**Potential benefits**: Avoid potential interruptions  

**Impact:** High
  
For more information, see [Analyst Reports, E-Books, and White Papers](https://aka.ms/batch_a8_a11_retirement_learnmore)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: 48ae14cb-10de-4bd9-a005-5c25f498649b  


<!--48ae14cb-10de-4bd9-a005-5c25f498649b_end-->

<!--bbc3f0f1-85b7-4bcb-b474-0e02571eb5fa_begin-->

#### Upgrade to the latest API version to ensure your Batch account remains operational.  
  
In the past 14 days, you have invoked a Batch management or service API version that is scheduled for deprecation. Upgrade to the latest API version to ensure your Batch account remains operational.  
  
**Potential benefits**: Improved functionality and stability  

**Impact:** High
  
For more information, see [Azure Batch API Life Cycle and Deprecation](https://aka.ms/batch_deprecatedapi_learnmore)  

ResourceType: microsoft.batch/batchaccounts  
Recommendation ID: bbc3f0f1-85b7-4bcb-b474-0e02571eb5fa  


<!--bbc3f0f1-85b7-4bcb-b474-0e02571eb5fa_end-->

<!--articleBody-->
