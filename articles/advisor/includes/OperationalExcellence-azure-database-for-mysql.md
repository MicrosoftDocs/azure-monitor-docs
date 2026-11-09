---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Database for MySQL
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Database for MySQL  
  

<!--43b6411e-c197-4e3d-9295-af1b84e552cf_begin-->

#### Enable storage autogrow for MySQL Flexible Server  
  
Storage auto-growth prevents a server from running out of storage and becoming read-only.  
  
**Potential benefits**: Prevent servers from going read-only due to low storage  

**Impact:** High
  
For more information, see [Service Tiers - Azure Database for MySQL](/azure/mysql/flexible-server/concepts-service-tiers-storage#storage-autogrow)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 43b6411e-c197-4e3d-9295-af1b84e552cf  

<!--43b6411e-c197-4e3d-9295-af1b84e552cf_end-->

<!--605bf72e-f058-46a5-a077-ca91692d0bc4_begin-->

#### Update your Microsoft Entra token audience  
  
For Azure Database for MySQL Flexible Servers that use Microsoft Entra authentication, Microsoft is moving from legacy JWT-based validation to Microsoft Identity Service Essentials (MISE). MISE enforces stricter audience validation, so connections that use tokens with unsupported audiences fail.  
  
**Potential benefits**: Compatibility with security and service enhancements  

**Impact:** High
  
For more information, see [Set up Microsoft Entra Authentication - Azure Database for MySQL](/azure/mysql/security/security-how-to-entra#use-the-recommended-microsoft-entra-token-audience)  

ResourceType: microsoft.dbformysql/flexibleservers  
Recommendation ID: 605bf72e-f058-46a5-a077-ca91692d0bc4  

<!--605bf72e-f058-46a5-a077-ca91692d0bc4_end-->

<!--articleBody-->
