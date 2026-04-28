---
ms.service: azure
ms.topic: include
ms.date: 04/28/2026
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure Kubernetes Service (AKS)
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Kubernetes Service (AKS)  
  
<!--0b341a36-99c1-41be-b9fb-71efd8029d31_begin-->

#### Use the Standard Load Balancer  
  
Your cluster is currently using a basic load balancer. This will be retired on September 30, 2025 and will not be supported. Moving to Standard Load Balancer will help you achieve high performance and low latency management of network traffic both within and across regions and availability zones.  
  
**Potential benefits**: Provides high performance for traffic across regions and AZs  

**Impact:** Medium
  
For more information, see [Azure Load Balancer SKUs](/azure/load-balancer/skus)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 0b341a36-99c1-41be-b9fb-71efd8029d31  


<!--0b341a36-99c1-41be-b9fb-71efd8029d31_end-->

<!--37a054b6-21dc-4f5c-bdfe-360c0827205f_begin-->

#### Deprecated Kubernetes APIs are found. Avoid using deprecated API.  
  
The cluster has been detected using deprecated Kubernetes APIs. Using these APIs can cause operations failures such as cluster upgrade, resulting in performance issues. Follow the Kubernetes deprecated API migration guide to remove these APIs.  
  
**Potential benefits**: Best practice for consistent performance  

**Impact:** High
  
For more information, see [Deprecated API Migration Guide](https://kubernetes.io/docs/reference/using-api/deprecation-guide/)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 37a054b6-21dc-4f5c-bdfe-360c0827205f  


<!--37a054b6-21dc-4f5c-bdfe-360c0827205f_end-->





<!--deb97441-d830-49f6-b9a5-9d04306abde9_begin-->

#### Use the latest generation VM series such as Ddv5 series  
  
Use latest generation of Azure VMs such as Ddv5 series for better performance and higher availability during host maintenance events. These VM series run the latest generation of hardware in our data centers to help optimize your cluster performance.  
  
**Potential benefits**: Ensure high performance and lower impact of maintenance events by using the latest generation of Azure hardware  

**Impact:** Low
  
For more information, see [Dpsv5 size series - Azure Virtual Machines](/azure/virtual-machines/dpsv5-dpdsv5-series)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: deb97441-d830-49f6-b9a5-9d04306abde9  


<!--deb97441-d830-49f6-b9a5-9d04306abde9_end-->

<!--e32c5e70-515f-45aa-90e7-94fb4fdb1b6c_begin-->

#### Use Uptime SLA  
  
The cluster uses the Free tier and has more than 10 nodes. The Kubernetes Control Plane on the Free tier comes with limited resources and isn't intended for production use or any cluster with 10 or more nodes. To avoid performance issues, upgrade to the Standard tier.  
  
**Potential benefits**: High Availability for cluster  

**Impact:** High
  
For more information, see [Azure Kubernetes Service (AKS) Free, Standard, and Premium Pricing Tiers - Azure Kubernetes Service](/azure/aks/free-standard-pricing-tiers)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: e32c5e70-515f-45aa-90e7-94fb4fdb1b6c  


<!--e32c5e70-515f-45aa-90e7-94fb4fdb1b6c_end-->


<!--c2f34a5d-2742-4c3d-9247-e0a8b85c3e51_begin-->

#### Configure the Cluster Autoscaler  
  
The cluster autoscaler isn't configured in the cluster. The cluster can't automatically adapt to changing load conditions unless it's scaling another way.  
  
**Potential benefits**: Optimized scaling for cost and performance  

**Impact:** Low
  
For more information, see [Use the cluster autoscaler in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/cluster-autoscaler)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: c2f34a5d-2742-4c3d-9247-e0a8b85c3e51  


<!--c2f34a5d-2742-4c3d-9247-e0a8b85c3e51_end-->

<!--79dd48e7-cd34-4f35-a8be-a7d483353c1c_begin-->

#### Use Ephemeral OS disk  
  
This cluster isn't using ephemeral OS disks which can provide lower read/write latency, along with faster node scaling and cluster upgrades  
  
**Potential benefits**: Faster scaling, upgrades & I/O  

**Impact:** Low
  
  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 79dd48e7-cd34-4f35-a8be-a7d483353c1c  


<!--79dd48e7-cd34-4f35-a8be-a7d483353c1c_end-->


<!--d1e9f4a0-926e-4480-a4e4-3ea94877370c_begin-->

#### Enable container monitoring for Azure Kubernetes Service (AKS) clusters  
  
The Azure Kubernetes Service (AKS) cluster doesn't have container monitoring enabled. Enable monitoring to collect logs and Prometheus metrics in Azure Monitor for better visibility about pod health, performance, and cluster issues.  
  
**Potential benefits**: Improve visibility and performance insights  

**Impact:** Medium
  
For more information, see [Kubernetes monitoring in Azure Monitor - Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-overview)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: d1e9f4a0-926e-4480-a4e4-3ea94877370c  


<!--d1e9f4a0-926e-4480-a4e4-3ea94877370c_end-->

<!--cc62fec4-24e5-4fc4-bf99-2b83d0702549_begin-->

#### Simplify multi-cluster management with Azure Kubernetes Fleet Manager  
  
Use Azure Kubernetes Fleet Manager to simplify management of Kubernetes clusters in any Azure region or subscription.  
  
**Potential benefits**: Simplified multi-cluster management  

**Impact:** Medium
  
For more information, see [Azure Kubernetes Fleet Manager](https://aka.ms/kubernetes-fleet/)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: cc62fec4-24e5-4fc4-bf99-2b83d0702549  


<!--cc62fec4-24e5-4fc4-bf99-2b83d0702549_end-->

<!--89e238d9-56e5-4f05-bd9a-295ebd55711d_begin-->

#### Use Fleet Manager auto-upgrade profiles to replace cluster auto-upgrades  
  
Use Azure Kubernetes Fleet Manager auto-upgrade profiles to safely update multiple member clusters in a defined order.  
  
**Potential benefits**: Safely automate the update of multiple clusters  

**Impact:** Medium
  
For more information, see [Automate Upgrades of Kubernetes and Node Images Across Multiple Clusters using Azure Kubernetes Fleet Manager](https://aka.ms/kubernetes-fleet/auto-upgrade)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 89e238d9-56e5-4f05-bd9a-295ebd55711d  


<!--89e238d9-56e5-4f05-bd9a-295ebd55711d_end-->

<!--articleBody-->
