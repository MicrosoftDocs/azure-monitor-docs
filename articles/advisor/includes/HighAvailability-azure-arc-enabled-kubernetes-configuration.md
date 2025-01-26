---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
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

For more information, see [Available extensions for Azure Arc-enabled Kubernetes clusters](https://aka.ms/fluxreleasenotes)  

<!--4bc7a00b-edbb-4963-8800-1b0f8897fecf_end-->

<!--79cfad72-9b6d-4215-922d-7df77e1ea3bb_begin-->

#### Upcoming Breaking Changes for Microsoft Flux Extension  
  
The Microsoft Flux extension frequently receives updates for security and stability. The upcoming update, in line with the OSS Flux Project, will modify the HelmRelease and HelmChart APIs by removing deprecated fields. To avoid disruption to your workloads, necessary action is needed.  
  
**Potential benefits**: Improved stability, security, and new functionality  

For more information, see [Available extensions for Azure Arc-enabled Kubernetes clusters](https://aka.ms/fluxreleasenotes)  

<!--79cfad72-9b6d-4215-922d-7df77e1ea3bb_end-->

<!--c8e3b516-a0d5-4c64-8a7a-71cfd068d5e8_begin-->

#### Upgrade Microsoft Flux extension to a supported version  
  
Current version of Microsoft Flux on one or more Azure Arc enabled clusters and Azure Kubernetes clusters is out of support. To get security patches, bug fixes and Microsoft support, upgrade to a supported version.  
  
**Potential benefits**: Get security patches, bug fixes and Microsoft support  

For more information, see [Available extensions for Azure Arc-enabled Kubernetes clusters](https://aka.ms/fluxreleasenotes)  

<!--c8e3b516-a0d5-4c64-8a7a-71cfd068d5e8_end-->

<!--articleBody-->
