---
ms.service: azure
ms.topic: include
ms.date: 10/14/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Arc-enabled Kubernetes Configuration
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Arc-enabled Kubernetes Configuration  
  
<!--4bc7a00b-edbb-4963-8800-1b0f8897fecf_begin-->

#### Upgrade Microsoft Flux extension to the newest major version  
  
The Microsoft Flux extension has a major version release. Plan for a manual upgrade to the latest major version for Microsoft Flux for all Azure Arc-enabled Kubernetes and Azure Kubernetes Service (AKS) clusters within 6 months for continued support and new functionality.  
  
**Potential benefits**: Continued support and new functionality  

**Impact:** Medium
  
For more information, see [Available extensions for Azure Arc-enabled Kubernetes clusters - Azure Arc ](https://aka.ms/fluxreleasenotes)  

ResourceType: microsoft.kubernetesconfiguration/extensions  
Recommendation ID: 4bc7a00b-edbb-4963-8800-1b0f8897fecf  
Subcategory: ServiceUpgradeAndRetirement

<!--4bc7a00b-edbb-4963-8800-1b0f8897fecf_end-->

<!--79cfad72-9b6d-4215-922d-7df77e1ea3bb_begin-->

#### Upcoming Breaking Changes for Microsoft Flux Extension  
  
The Microsoft Flux extension frequently receives updates for security and stability. The upcoming update, in line with the OSS Flux Project, modifies the HelmRelease and HelmChart APIs by removing deprecated fields. To avoid disruption to workloads, necessary action is needed.  
  
**Potential benefits**: Improved stability, security, and new functionality  

**Impact:** High
  
For more information, see [Available extensions for Azure Arc-enabled Kubernetes clusters - Azure Arc](https://aka.ms/fluxreleasenotes)  

ResourceType: microsoft.kubernetesconfiguration/extensions  
Recommendation ID: 79cfad72-9b6d-4215-922d-7df77e1ea3bb  
Subcategory: undefined

<!--79cfad72-9b6d-4215-922d-7df77e1ea3bb_end-->


<!--articleBody-->
