---
ms.service: azure
ms.topic: include
ms.date: 03/18/2025
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

<!--6641760c-2bf8-41df-bac9-177af4a6b6b9_begin-->

#### Expired ETCD cert  
  
Expired ETCD cert, please update.  
  
**Potential benefits**: Your cluster will work correctly  

**Impact:** Medium
  
For more information, see [Update or rotate the credentials for an Azure Kubernetes Service (AKS) cluster - Azure Kubernetes Service](https://aka.ms/AKSUpdateCredentials)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 6641760c-2bf8-41df-bac9-177af4a6b6b9  


<!--6641760c-2bf8-41df-bac9-177af4a6b6b9_end-->

<!--dccd771b-3484-4a41-bdbf-00b35103d5bb_begin-->

#### Enable Container Insights  
  
Enable container insights to monitor your AKS cluster health and performance metrics. Container Insights will collect logs and events to help you debug your cluster.  
  
**Potential benefits**: Use Container Insights to monitor your AKS cluster's health and performance to ensure nodes and containers are performing as expected  

**Impact:** Medium
  
For more information, see [Monitor your Kubernetes cluster performance with Container insights - Azure Monitor](/azure/azure-monitor/containers/container-insights-analyze)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: dccd771b-3484-4a41-bdbf-00b35103d5bb  


<!--dccd771b-3484-4a41-bdbf-00b35103d5bb_end-->

<!--deb97441-d830-49f6-b9a5-9d04306abde9_begin-->

#### Use the latest generation VM series such as Ddv5 series  
  
Use latest generation of Azure VMs such as Ddv5 series for better performance and higher availability during host maintenance events. These VM series run the latest generation of hardware in our data centers to help optimize your cluster performance.  
  
**Potential benefits**: Ensure high performance and lower impact of maintenance events by using the latest generation of Azure hardware  

**Impact:** Low
  
For more information, see [Dpsv5 size series - Azure Virtual Machines](/azure/virtual-machines/dpsv5-dpdsv5-series)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: deb97441-d830-49f6-b9a5-9d04306abde9  


<!--deb97441-d830-49f6-b9a5-9d04306abde9_end-->

<!--articleBody-->
