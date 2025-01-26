---
ms.service: azure-monitor
ms.topic: include
ms.date: 01/13/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Kubernetes Service (AKS)
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Kubernetes Service (AKS)  
  
<!--70829b1a-272b-4728-b418-8f1a56432d33_begin-->

#### Enable Autoscaling for your system node pools  
  
To ensure your system pods are scheduled even during times of high load, enable autoscaling on your system node pool.  
  
**Potential benefits**: Enabling Autoscaler for system node pool ensures system pods are scheduled and cluster can function.  

For more information, see [Use the cluster autoscaler in Azure Kubernetes Service (AKS)](/azure/aks/cluster-autoscaler?tabs=azure-cli#before-you-begin)  

<!--70829b1a-272b-4728-b418-8f1a56432d33_end-->

<!--a9228ae7-4386-41be-b527-acd59fad3c79_begin-->

#### Have at least 2 nodes in your system node pool  
  
Ensure your system node pools have at least 2 nodes for reliability of your system pods. With a single node, your cluster can fail in the event of a node or hardware failure.  
  
**Potential benefits**: Having 2 nodes ensures resiliency against node failures.  

For more information, see [Manage system node pools in Azure Kubernetes Service (AKS)](/azure/aks/use-system-pools?tabs=azure-cli#system-and-user-node-pools)  

<!--a9228ae7-4386-41be-b527-acd59fad3c79_end-->

<!--f31832f1-7e87-499d-a52a-120f610aba98_begin-->

#### Create a dedicated system node pool  
  
A cluster without a dedicated system node pool is less reliable. We recommend you dedicate system node pools to only serve critical system pods, preventing resource starvation between system and competing user pods. Enforce this behavior with the CriticalAddonsOnly=true:NoSchedule taint on the pool.  
  
**Potential benefits**: Ensures cluster reliability by preventing resource scarcity for core system pods  

For more information, see [Manage system node pools in Azure Kubernetes Service (AKS)](/azure/aks/use-system-pools?tabs=azure-cli#before-you-begin)  

<!--f31832f1-7e87-499d-a52a-120f610aba98_end-->

<!--fac2ad84-1421-4dd3-8477-9d6e605392b4_begin-->

#### Ensure B-series Virtual Machine's (VMs) aren't used in production environments  
  
When a cluster has one or more node pools using a non-recommended burstable VM SKU, full vCPU capability 100% is unguaranteed. Ensure B-series VM's aren't used in production environments.  
  
**Potential benefits**: Best practice for consistent performance  

For more information, see [Bv1 sizes series](/azure/virtual-machines/sizes-b-series-burstable)  

<!--fac2ad84-1421-4dd3-8477-9d6e605392b4_end-->

<!--29f2eea3-b0d8-4934-a0f8-171dbd70ba13_begin-->

#### Use AKS Backup for a cluster with persistent volumes  
  
Azure Kubernetes Service (AKS) backup is a cloud-native solution for backing up and restoring containerized apps and data in an AKS cluster. AKS Backup supports scheduled backups for cluster state and persistent volumes. AKS Backup offers granular control over a namespace or an entire cluster.  
  
**Potential benefits**: Backups for cluster state and persistent volumes  

For more information, see [What is Azure Kubernetes Service backup?](https://aka.ms/aks-backup)  

<!--29f2eea3-b0d8-4934-a0f8-171dbd70ba13_end-->

<!--29a14bcd-36ad-41ea-9138-70049121eaea_begin-->

#### Set node pool subnet size to maximum auto scale setting  
  
To allow AKS to efficiently scale out nodes, update the subnet size for node pools to match the maximum settings for the auto-scaler.  
  
**Potential benefits**: Efficient scaling for demand. Reduced resource constraints.  

For more information, see [Configure Azure CNI networking for dynamic allocation of IPs and enhanced subnet support in Azure Kubernetes Service (AKS)](https://aka.ms/configure-azure-cni-dynamic-ip-allocation)  

<!--29a14bcd-36ad-41ea-9138-70049121eaea_end-->

<!--articleBody-->
