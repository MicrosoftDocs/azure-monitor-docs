---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Storage
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Storage  
  
<!--a0ad4f8c-f904-4b11-955d-e0044473c5fa_begin-->

#### Prevent hitting subscription limit for maximum storage accounts  
  
A region can support a maximum of 250 storage accounts per subscription. You have either already reached or are about to reach that limit. If you reach that limit, you will be unable to create any more storage accounts in that subscription/region combination. Evaluate the recommended action below to avoid hitting the limit.  
  
**Potential benefits**: Ensure you do not reach the limit that can prevent you from creating additional storage accounts  

**Impact:** High
  
For more information, see [Performance and scalability checklist for Blob storage - Azure Storage](https://aka.ms/subscalelimit)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: a0ad4f8c-f904-4b11-955d-e0044473c5fa  


<!--a0ad4f8c-f904-4b11-955d-e0044473c5fa_end-->

<!--3c374434-42e7-44db-8b0b-5b8ed970114b_begin-->

#### Update to newer releases of the Storage Java v12 SDK for better reliability.  
  
We noticed that one or more of your applications use an older version of the Azure Storage Java v12 SDK to write data to Azure Storage. Unfortunately, the version of the SDK being used has a critical issue that uploads incorrect data during retries (for example, in case of HTTP 500 errors), resulting in an invalid object being written. The issue is fixed in newer releases of the Java v12 SDK.  
  
**Potential benefits**: The issue is fixed in newer releases of the Java v12 SDK.  

**Impact:** High
  
For more information, see [Azure SDK for Java documentation](/azure/developer/java/sdk/?view=azure-java-stable)  

ResourceType: microsoft.storage/storageaccounts  
Recommendation ID: 3c374434-42e7-44db-8b0b-5b8ed970114b  


<!--3c374434-42e7-44db-8b0b-5b8ed970114b_end-->

<!--articleBody-->
