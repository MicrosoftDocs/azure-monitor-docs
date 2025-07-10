---
ms.service: azure
ms.topic: include
ms.date: 05/27/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Key Vault
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Key Vault  
  
<!--47e36ece-24bb-4d3e-8172-af28c9df172d_begin-->

#### Update Key Vault SDK Version  
  
New Key Vault Client Libraries are split to keys, secrets, and certificates SDKs, which are integrated with recommended Azure Identity library to provide seamless authentication to Key Vault across all languages and environments. It also contains several performance fixes to issues reported by customers and proactively identified through our QA process. **Important**: Be aware that you can only remediate recommendation for custom applications you have access to. Recommendations can be shown due to integration with other Azure services like Storage, Disk encryption, which are in process to update to new version of our SDK. If you use .NET 4.0 in all your applications, dismiss this.  
  
**Potential benefits**: Latest Key Vault Client Libraries contain fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [Client Libraries for Azure Key Vault](/azure/key-vault/general/client-libraries)  

ResourceType: microsoft.keyvault/managedhsms  
Recommendation ID: 47e36ece-24bb-4d3e-8172-af28c9df172d  


<!--47e36ece-24bb-4d3e-8172-af28c9df172d_end-->

<!--9017e82f-b7ac-4a06-8b9b-5858cb3d5113_begin-->

#### Upgrade the Azure Key Vault SDK to the latest version  
  
New Key Vault libraries split keys, secrets, and certificates into separate SDKs with Azure Identity integration for seamless auth and performance improvements. DISMISS: If using Key Vault with Azure Storage, Disk, or other services, and all custom apps that use .NET SDK 4.0+.  
  
**Potential benefits**: Fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [Client Libraries for Azure Key Vault](/azure/key-vault/general/client-libraries)  

ResourceType: microsoft.keyvault/vaults  
Recommendation ID: 9017e82f-b7ac-4a06-8b9b-5858cb3d5113  


<!--9017e82f-b7ac-4a06-8b9b-5858cb3d5113_end-->



<!--articleBody-->
