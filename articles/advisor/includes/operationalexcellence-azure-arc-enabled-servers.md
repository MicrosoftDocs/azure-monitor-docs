---
ms.service: azure
ms.topic: include
ms.date: 09/25/2026
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Arc-enabled servers
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Arc-enabled servers  
  
<!--18700d61-0b5a-4807-86a1-b7d669475335_begin-->

#### Restore connectivity for Arc-enabled servers disconnected for more than 30 days  
  
Azure Arc didn't receive a heartbeat from your machine for more than 30 days. Restore connectivity to maintain management access and ensure your managed identity certificate stays current.  
  
**Potential benefits**: Restore connectivity early to avoid service disruption.  

**Impact:** Medium
  
For more information, see [Resolve Azure Advisor recommendations for Azure Arc-enabled servers - Azure Arc](/azure/azure-arc/servers/resolve-azure-advisor-recommendations#restore-connectivity-for-30-day-disconnected-arc-enabled-server)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: 18700d61-0b5a-4807-86a1-b7d669475335  

<!--18700d61-0b5a-4807-86a1-b7d669475335_end-->

<!--157eb7ac-9b3d-4a0c-9bfb-dd2ffa37d1ae_begin-->

#### Re-onboard expired Arc-enabled server  
  
Azure didn't receive a heartbeat from this machine for more than 90 days, so the managed identity certificate expired. You must re-onboard the machine to use Azure management capabilities.  
  
**Potential benefits**: Restore connectivity to continue using services.  

**Impact:** High
  
For more information, see [Resolve Azure Advisor recommendations for Azure Arc-enabled servers - Azure Arc](/azure/azure-arc/servers/resolve-azure-advisor-recommendations#re-onboard-expired-arc-enabled-server)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: 157eb7ac-9b3d-4a0c-9bfb-dd2ffa37d1ae  

<!--157eb7ac-9b3d-4a0c-9bfb-dd2ffa37d1ae_end-->

<!--5a6e1150-2d8a-4865-b423-df234577d29b_begin-->

#### Reconnect Arc-enabled server before the managed identity certificate expires  
  
Azure didn't receive a heartbeat from this machine for more than 45 days. If you don't restore connectivity, the machine’s managed identity credential might expire, and Azure management capabilities might stop working.  
  
**Potential benefits**: Restore connectivity early to avoid service disruption.  

**Impact:** High
  
For more information, see [Resolve Azure Advisor recommendations for Azure Arc-enabled servers - Azure Arc](/azure/azure-arc/servers/resolve-azure-advisor-recommendations#reconnect-arc-enabled-server-before-the-managed-identity-certificate-expires)  

ResourceType: microsoft.hybridcompute/machines  
Recommendation ID: 5a6e1150-2d8a-4865-b423-df234577d29b  

<!--5a6e1150-2d8a-4865-b423-df234577d29b_end-->

<!--articleBody-->