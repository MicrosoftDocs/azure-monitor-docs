---
ms.service: azure
ms.topic: include
ms.date: 05/12/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Azure Kubernetes Service (AKS)
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Kubernetes Service (AKS)  
  
<!--22ae3910-a9a7-4e3d-8234-6a6b9ec7275b_begin-->

#### Enable Vertical Pod Autoscaler recommendation mode to rightsize resource requests and limits  
  
Vertical Pod Autoscaler provides recommended CPU and memory request and limit values based on workload usage patterns to rightsize applications. Reduce over-provisioning and maximize the utilization of the Azure Kubernetes Service cluster.  
  
**Potential benefits**: Optimize requests and limits to maximize utilization  

**Impact:** Medium
  
For more information, see [Use the Vertical Pod Autoscaler in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](https://aka.ms/aks/docs/vpa)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 22ae3910-a9a7-4e3d-8234-6a6b9ec7275b  


<!--22ae3910-a9a7-4e3d-8234-6a6b9ec7275b_end-->

<!--56b0837b-7d02-4ca6-859f-59dc452fd93e_begin-->

#### Use Azure Kubernetes Service Cost Analysis  
  
Get full visibility into Azure Kubernetes Service (AKS) cluster cost trends and allocate costs by Kubernetes constructs or Azure assets. AKS Cost Analysis also helps identify workload inefficiencies, such as idle resource costs, indicating opportunity to optimize and achieve cost savings.  
  
**Potential benefits**: Understand cluster cost trends and identify idle resources  

**Impact:** Medium
  
For more information, see [Azure Kubernetes Service (AKS) cost analysis - Azure Kubernetes Service](https://aka.ms/aks/docs/cost-analysis)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 56b0837b-7d02-4ca6-859f-59dc452fd93e  


<!--56b0837b-7d02-4ca6-859f-59dc452fd93e_end-->

<!--82d10dcf-5127-4a8c-a2b1-fd02ab46df60_begin-->

#### Fine-tune the cluster autoscaler profile for rapid scale down and cost savings  
  
Configuring the cluster autoscaler profile for aggressive scale-down ensures that nodes are quickly removed when not needed. This efficient scaling minimizes idle resources, leading to significant cost savings.  
  
**Potential benefits**: Rapidly scale down nodes to minimize idle resources  

**Impact:** Medium
  
For more information, see [Use the cluster autoscaler in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](https://aka.ms/aks.docs/cas-cost-profile)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 82d10dcf-5127-4a8c-a2b1-fd02ab46df60  


<!--82d10dcf-5127-4a8c-a2b1-fd02ab46df60_end-->

<!--17f6ab99-c9b6-4800-bebd-7466699cec31_begin-->

#### Consider Spot nodes for workloads that can handle interruptions  
  
Take advantage of unutilized Azure capacity at a reduced price with Spot nodes. Spot nodes are best for workloads that tolerate interruptions, early terminations, or evictions.  
  
**Potential benefits**: Use unutilized Azure capacity at a reduced price  

**Impact:** Medium
  
For more information, see [Add an Azure Spot node pool to an Azure Kubernetes Service (AKS) cluster - Azure Kubernetes Service](https://aka.ms/aks/docs/spot)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 17f6ab99-c9b6-4800-bebd-7466699cec31  


<!--17f6ab99-c9b6-4800-bebd-7466699cec31_end-->

<!--articleBody-->
