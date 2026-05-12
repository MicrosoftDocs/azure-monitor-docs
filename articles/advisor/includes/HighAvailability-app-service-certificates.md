---
ms.service: azure
ms.topic: include
ms.date: 05/12/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability App Service Certificates
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## App Service Certificates  
  
<!--a2385343-200c-4eba-bbe2-9252d3f1d6ea_begin-->

#### Domain verification required to issue your App Service Certificate  
  
You have an App Service Certificate that's currently in a Pending Issuance status and requires domain verification. Failure to validate domain ownership will result in an unsuccessful certificate issuance. Domain verification isn't automated for App Service Certificates and will require action.  
  
**Potential benefits**: Ensure successful issuance of App Service Certificate.  

**Impact:** High
  
For more information, see [Install a TLS/SSL Certificate for Your App - Azure App Service](https://aka.ms/ASCDomainVerificationRequired)  

ResourceType: microsoft.certificateregistration/certificateorders  
Recommendation ID: a2385343-200c-4eba-bbe2-9252d3f1d6ea  
Subcategory: undefined

<!--a2385343-200c-4eba-bbe2-9252d3f1d6ea_end-->


<!--articleBody-->
