---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance App Service
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## App Service  
  
<!--9ebff5d5-10c1-4fed-8c58-1954e27d3bfa_begin-->

#### Move your App Service Plan to PremiumV2 for better performance  
  
Your app served more than 1000 requests per day for the past 3 days. Your app may benefit from the higher performance infrastructure available with the Premium V2 App Service tier. The Premium V2 tier features Dv2-series VMs with faster processors, SSD storage, and doubled memory-to-core ratio when compared to the previous instances. Learn more about upgrading to Premium V2 from our documentation.  
  
**Potential benefits**: Obtain better performance with lower cost  

**Impact:** High
  
For more information, see [Configure Premium V3 tier - Azure App Service](https://aka.ms/ant-premiumv2)  

ResourceType: microsoft.web/sites  
Recommendation ID: 9ebff5d5-10c1-4fed-8c58-1954e27d3bfa  


<!--9ebff5d5-10c1-4fed-8c58-1954e27d3bfa_end-->

<!--07f9a07d-9030-465c-89dc-b1f712334b83_begin-->

#### Check outbound connections from your App Service resource  
  
Your app has opened too many TCP/IP socket connections. Exceeding ephemeral TCP/IP port connection limits can cause unexpected connectivity issues for your apps.  
  
**Potential benefits**: Better performance and lower cost  

**Impact:** High
  
  

ResourceType: microsoft.web/sites  
Recommendation ID: 07f9a07d-9030-465c-89dc-b1f712334b83  


<!--07f9a07d-9030-465c-89dc-b1f712334b83_end-->

<!--articleBody-->
