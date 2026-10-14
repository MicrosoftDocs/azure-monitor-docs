---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Content Delivery Network
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Content Delivery Network  
  
<!--062d41f2-0dfa-48e0-a9b8-fb40fa5b001f_begin-->

#### Migrate Azure CDN Standard from Microsoft (Classic) to Azure Front Door Standard/Premium tier  
  
Azure CDN Standard from Microsoft (classic) is scheduled for retirement on 30 September 2027. We encourage you to use the zero downtime migration tool to transition to Front Door Standard and Premium SKUs. These options offer not only feature parity but also additional features and enhanced security  
  
**Potential benefits**: Avoid potential disruptions and leverage new capabilities  

**Impact:** Medium
  
For more information, see [About Azure CDN from Microsoft (classic) to Azure Front Door migration](https://aka.ms/classic-cdn-migration)  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 062d41f2-0dfa-48e0-a9b8-fb40fa5b001f  

<!--062d41f2-0dfa-48e0-a9b8-fb40fa5b001f_end-->

<!--16c397fb-ccae-493f-9214-77eb088fc17d_begin-->

#### Complete your Azure Front Door migration by moving traffic to the new endpoint  
  
Complete your migration by moving traffic to the new Azure Front Door Standard/Premium endpoint. Update custom domain DNS and applications using the classic endpoint. Both endpoints remain active for validation, but classic support ends April 1, 2028.  
  
**Potential benefits**: Reduce migration risk by switching to new endpoint.  

**Impact:** High
  
For more information, see [About Azure CDN from Microsoft (classic) to Azure Front Door migration](https://aka.ms/cdn/migration).  

ResourceType: microsoft.cdn/profiles  
Recommendation ID: 16c397fb-ccae-493f-9214-77eb088fc17d  

<!--16c397fb-ccae-493f-9214-77eb088fc17d_end-->

<!--articleBody-->
