---
ms.service: azure
ms.topic: include
ms.date: 11/25/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Arc-enabled Kubernetes Configuration
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Arc-enabled Kubernetes Configuration  
  

<!--79cfad72-9b6d-4215-922d-7df77e1ea3bb_begin-->

#### Upcoming Breaking Changes for Microsoft Flux Extension  
  
The Microsoft Flux extension frequently receives updates for security and stability. The upcoming update, in line with the OSS Flux Project, modifies the HelmRelease and HelmChart APIs by removing deprecated fields. To avoid disruption to workloads, necessary action is needed.  
  
**Potential benefits**: Improved stability, security, and new functionality  

**Impact:** High
  
For more information, see [Available extensions for Azure Arc-enabled Kubernetes clusters - Azure Arc](https://aka.ms/fluxreleasenotes)  

ResourceType: microsoft.kubernetesconfiguration/extensions  
Recommendation ID: 79cfad72-9b6d-4215-922d-7df77e1ea3bb  

<!--79cfad72-9b6d-4215-922d-7df77e1ea3bb_end-->

<!--51b9ef93-332d-4438-b1ba-851a6eae2e67_begin-->

#### Migrate to Azure Container Apps on Arc-enabled Kubernetes  
  
Azure App Service on Azure Arc-enabled Kubernetes is retiring. Installation of the Application Services extension is no longer available.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500016)  

ResourceType: microsoft.kubernetesconfiguration/extensions  
Recommendation ID: 51b9ef93-332d-4438-b1ba-851a6eae2e67  

<!--51b9ef93-332d-4438-b1ba-851a6eae2e67_end-->

<!--articleBody-->
