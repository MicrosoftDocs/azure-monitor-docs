---
ms.service: azure
ms.topic: include
ms.date: 05/12/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Monitor pipeline
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Monitor pipeline  
  
<!--fe21e589-8398-4fae-be74-6364137782eb_begin-->

#### Migrate to direct Prometheus  
  
Azure Monitor is deprecating the sidecar for remote-write of Prometheus metrics to Azure Monitor Workspace. Configure self-hosted Prometheus or Prometheus Operator to remote-write directly to Azure Monitor Workspace.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=550519)  

ResourceType: microsoft.monitor/accounts  
Recommendation ID: fe21e589-8398-4fae-be74-6364137782eb  
Subcategory: undefined

<!--fe21e589-8398-4fae-be74-6364137782eb_end-->

<!--articleBody-->
