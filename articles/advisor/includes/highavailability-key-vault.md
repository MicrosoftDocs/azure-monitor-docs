---
ms.service: azure
ms.topic: include
ms.date: 04/14/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Key Vault
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Key Vault  
  
<!--7ff06874-39e9-41be-9552-fa1ae2a83c88_begin-->

#### Azure Key Vault API versions prior to 2026-02-01 are being retired  
  
Transition to API version 2026-02-01. Azure role-based access control (RBAC) will be the default access control model for all newly created vaults. Existing key vaults will continue using their current access control model.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Prepare for Key Vault API version 2026-02-01 and later - Azure RBAC as default](/azure/key-vault/general/access-control-default?tabs=azure-cli)  

ResourceType: microsoft.keyvault/vaults  
Recommendation ID: 7ff06874-39e9-41be-9552-fa1ae2a83c88  

<!--7ff06874-39e9-41be-9552-fa1ae2a83c88_end-->

<!--2ee11d3b-0e4c-48ae-84a9-ca3bdf998fd2_begin-->

#### Enable diagnostic logs in Key Vault  
  
Enable logs, set up alerts, and adhere to retention requirements for improved monitoring and security of Key Vault access. The logs detail the frequency and identity of users.  
  
**Potential benefits**: Enhanced monitoring and security compliance  

**Impact:** Low
  
For more information, see [Azure Key Vault logging](/azure/key-vault/general/logging?tabs=Vault)  

ResourceType: microsoft.keyvault/vaults  
Recommendation ID: 2ee11d3b-0e4c-48ae-84a9-ca3bdf998fd2  

<!--2ee11d3b-0e4c-48ae-84a9-ca3bdf998fd2_end-->

<!--ffb6883e-a7c2-470b-91fc-aa3a21f9ed59_begin-->

#### Enable purge protection on key vaults  
  
Purge protection secures against malicious deletions by enforcing a retention period for soft deleted key vaults. No one, not even insiders or Microsoft, can purge your key vaults during this period. This protection prevents permanent data loss.  
  
**Potential benefits**: Protects from insider attacks, avoids data loss  

**Impact:** Medium
  
For more information, see [Azure Key Vault soft-delete](/azure/key-vault/general/soft-delete-overview#purge-protection)  

ResourceType: microsoft.keyvault/vaults  
Recommendation ID: ffb6883e-a7c2-470b-91fc-aa3a21f9ed59  

<!--ffb6883e-a7c2-470b-91fc-aa3a21f9ed59_end-->

<!--a6d218b1-a826-4183-8cc8-4b111371e47b_begin-->

#### Migrate to HSM Platform 2 Keys  
  
To keep your operations secure and working properly, transition to HSM Platform 2 keys as soon as possible.
  
**Potential benefits**: Avoid service disruptions and maintain secure operations.  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=494676).  

ResourceType: microsoft.keyvault/managedhsms  
Recommendation ID: a6d218b1-a826-4183-8cc8-4b111371e47b  

<!--a6d218b1-a826-4183-8cc8-4b111371e47b_end-->

<!--articleBody-->
