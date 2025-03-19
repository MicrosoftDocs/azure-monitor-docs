---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure AI Search
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure AI Search  
  
<!--3b1b26f2-bacb-437f-b481-f4dc3a0bbf9b_begin-->

#### Frequent throttling occurs on the Azure Search API, consider increasing the search units  
  
Increase the search units. In the last 7 days, the platform observed throttling for Azure Search API requests in over 20% of the recorded minutes.  
  
**Potential benefits**: Scale the resource to reduce throttling errors.  

**Impact:** Medium
  
  

ResourceType: microsoft.search/searchservices  
Recommendation ID: 3b1b26f2-bacb-437f-b481-f4dc3a0bbf9b  


<!--3b1b26f2-bacb-437f-b481-f4dc3a0bbf9b_end-->

<!--4cab9b17-7fa9-4d20-88ba-47232ee0ee24_begin-->

#### Upgrade the version of the Search SDK to the newest version  
  
Upgrade the version of the Search SDK to the newest version. The newest version of the Azure AI Search SDK contains new functionality and issue fixes.  
  
**Potential benefits**: Add new feature capabilities. Fix issues.  

**Impact:** Medium
  
For more information, see [API versions - Azure AI Search](/azure/search/search-api-versions)  

ResourceType: microsoft.search/searchservices  
Recommendation ID: 4cab9b17-7fa9-4d20-88ba-47232ee0ee24  


<!--4cab9b17-7fa9-4d20-88ba-47232ee0ee24_end-->

<!--articleBody-->
