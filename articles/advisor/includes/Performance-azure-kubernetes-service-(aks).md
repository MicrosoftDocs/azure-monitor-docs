---
ms.service: azure
ms.topic: include
ms.date: 09/09/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Azure Kubernetes Service (AKS)
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Kubernetes Service (AKS)  
  
<!--835e829e-9af6-4758-80d2-98df565d1524_begin-->

#### Update the Fleet API to the latest version  
  
We identified SDK requests from outdated Fleet API for resources in this subscription. We recommend upgrade to the latest SDK version. This ensures you receive the latest features and performance improvements.  
  
**Potential benefits**: Latest Fleet API contains fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [Azure Kubernetes Fleet Manager Preview API lifecycle](https://aka.ms/kubernetes-fleet/arm-api-updates)  

ResourceType: microsoft.containerservice/fleets  
Recommendation ID: 835e829e-9af6-4758-80d2-98df565d1524  


<!--835e829e-9af6-4758-80d2-98df565d1524_end-->


<!--492c8468-bb25-4a03-b8e5-9ae99723a017_begin-->

#### Add node pools to the cluster  
  
It is recommended to add one or more node pools instead of using a single node pool. This helps to isolate critical system pods from your application to prevent misconfigured or rogue application pods from accidentally shutting down system pods.  
  
**Potential benefits**: Prevent accidental shutting down of system pods  

**Impact:** Medium
  
For more information, see [Use system node pools in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/use-system-pools#system-and-user-node-pools)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 492c8468-bb25-4a03-b8e5-9ae99723a017  


<!--492c8468-bb25-4a03-b8e5-9ae99723a017_end-->


<!--462b5f77-4a65-4287-885b-01a0f471743f_begin-->

#### Unsupported Kubernetes version is detected  
  
Unsupported Kubernetes version is detected. Ensure Kubernetes cluster runs with a supported version.  
  
**Potential benefits**: Ensure Kubernetes cluster runs with a supported version.  

**Impact:** Medium
  
For more information, see [Supported Kubernetes versions in Azure Kubernetes Service (AKS). - Azure Kubernetes Service](https://aka.ms/aks-supported-versions)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 462b5f77-4a65-4287-885b-01a0f471743f  


<!--462b5f77-4a65-4287-885b-01a0f471743f_end-->

<!--articleBody-->
