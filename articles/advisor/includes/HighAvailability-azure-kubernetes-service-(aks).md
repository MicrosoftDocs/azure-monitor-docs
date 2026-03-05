---
ms.service: azure
ms.topic: include
ms.date: 02/24/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Kubernetes Service (AKS)
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Kubernetes Service (AKS)  
  





<!--29f2eea3-b0d8-4934-a0f8-171dbd70ba13_begin-->

#### Use AKS Backup for a cluster with persistent volumes  
  
Azure Kubernetes Service (AKS) backup is a cloud-native solution for backing up and restoring containerized apps and data in an AKS cluster. AKS Backup supports scheduled backups for cluster state and persistent volumes. AKS Backup offers granular control over a namespace or an entire cluster.  
  
**Potential benefits**: Backups for cluster state and persistent volumes  

**Impact:** Medium
  
For more information, see [What is Azure Kubernetes Service (AKS) backup? - Azure Backup](https://aka.ms/aks-backup)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 29f2eea3-b0d8-4934-a0f8-171dbd70ba13  
Subcategory: DisasterRecovery

<!--29f2eea3-b0d8-4934-a0f8-171dbd70ba13_end-->





<!--70829b1a-272b-4728-b418-8f1a56432d33_begin-->

#### Enable Autoscaling for your system node pools  
  
To ensure your system pods are scheduled even during times of high load, enable autoscaling on your system node pool.  
  
**Potential benefits**: Autoscaler improves system pod uptime  

**Impact:** High
  
For more information, see [Use the cluster autoscaler in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/cluster-autoscaler?tabs=azure-cli#before-you-begin)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 70829b1a-272b-4728-b418-8f1a56432d33  
Subcategory: undefined

<!--70829b1a-272b-4728-b418-8f1a56432d33_end-->


<!--a9228ae7-4386-41be-b527-acd59fad3c79_begin-->

#### Have at least 2 nodes in your system node pool  
  
Ensure your system node pools have at least 2 nodes for reliability of your system pods. With a single node, your cluster can fail in the event of a node or hardware failure.  
  
**Potential benefits**: Having 2 nodes ensures resiliency against node failures.  

**Impact:** High
  
For more information, see [Use system node pools in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/use-system-pools?tabs=azure-cli#system-and-user-node-pools)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: a9228ae7-4386-41be-b527-acd59fad3c79  
Subcategory: undefined

<!--a9228ae7-4386-41be-b527-acd59fad3c79_end-->


<!--f31832f1-7e87-499d-a52a-120f610aba98_begin-->

#### Create a dedicated system node pool  
  
A cluster without a dedicated system node pool is less reliable. We recommend you dedicate system node pools to only serve critical system pods, preventing resource starvation between system and competing user pods. Enforce this behavior with the CriticalAddonsOnly=true:NoSchedule taint on the pool.  
  
**Potential benefits**: Prevents resource scarcity for core system pods  

**Impact:** High
  
For more information, see [Use system node pools in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/use-system-pools?tabs=azure-cli#before-you-begin)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: f31832f1-7e87-499d-a52a-120f610aba98  
Subcategory: undefined

<!--f31832f1-7e87-499d-a52a-120f610aba98_end-->


<!--fac2ad84-1421-4dd3-8477-9d6e605392b4_begin-->

#### Ensure B-series Virtual Machine's (VMs) aren't used in production environments  
  
When a cluster has one or more node pools using a non-recommended burstable VM SKU, full vCPU capability 100% is unguaranteed. Ensure B-series VMs aren't used in production environments.  
  
**Potential benefits**: Best practice for consistent performance  

**Impact:** Medium
  
For more information, see [Bv1 size series - Azure Virtual Machines ](/azure/virtual-machines/sizes-b-series-burstable)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: fac2ad84-1421-4dd3-8477-9d6e605392b4  
Subcategory: HighAvailability

<!--fac2ad84-1421-4dd3-8477-9d6e605392b4_end-->

<!--9f3263db-b9c0-43bb-8523-6800f9f50793_begin-->

#### Configure and deploy Azure Kubernetes Service (AKS) and related resources to use availability zones  
  
The availability zones in Azure regions ensure high availability by offering independent locations. An availability zone is equipped with independent power, cooling, and networking to ensure applications and data are protected from datacenter-level failures.  
  
**Potential benefits**: Improved availability and reliability  

**Impact:** High
  
For more information, see [Availability Zones in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/availability-zones?toc=%2Fazure%2Freliability%2Ftoc.json&bc=%2Fazure%2Freliability%2Fbreadcrumb%2Ftoc.json)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 9f3263db-b9c0-43bb-8523-6800f9f50793  
Subcategory: HighAvailability

<!--9f3263db-b9c0-43bb-8523-6800f9f50793_end-->

<!--863d09bd-e767-472b-9980-f32709414ade_begin-->

#### Ubuntu 20.04 on Azure Kubernetes Service is retiring  
  
To avoid service disruptions, scaling restrictions, and remain supported; upgrade to a supported Kubernetes version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485172)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 863d09bd-e767-472b-9980-f32709414ade  
Subcategory: undefined

<!--863d09bd-e767-472b-9980-f32709414ade_end-->

<!--b005ecf0-23e2-4279-9ca2-718d1518c9fb_begin-->

#### Migrate to Container insights managed identity authentication  
  
Migrate to Container insights managed identity authentication before the retirement date to maintain access and retain functionality.  
  
**Potential benefits**: Avoid service disruption and gain enhanced features  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500853)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: b005ecf0-23e2-4279-9ca2-718d1518c9fb  
Subcategory: undefined

<!--b005ecf0-23e2-4279-9ca2-718d1518c9fb_end-->

<!--8aad9adb-cb6a-4ddc-b659-12d1c6ca186a_begin-->

#### Use Fleet Manager auto-upgrade profiles to regularly update clusters  
  
Use Azure Kubernetes Fleet Manager to safely update multiple clusters using update runs, auto-upgrade profiles and strategies.  
  
**Potential benefits**: Safe and predictable updates of multiple clusters  

**Impact:** Medium
  
For more information, see [Automate upgrades of Kubernetes and node images across multiple clusters using Azure Kubernetes Fleet Manager](https://aka.ms/kubernetes-fleet/auto-upgrade)  

ResourceType: microsoft.containerservice/fleets  
Recommendation ID: 8aad9adb-cb6a-4ddc-b659-12d1c6ca186a  
Subcategory: undefined

<!--8aad9adb-cb6a-4ddc-b659-12d1c6ca186a_end-->

<!--ec938125-62ef-4dc5-b7b1-257eb8d006d9_begin-->

#### Migrate from NPM for Windows on AKS  
  
Customers should explore alternative options for restricting traffic access on Windows clusters, such as:
Network Security Groups (NSGs) at the node level or Open-source tools like Project Calico.
Microsoft encourages identifying the best approach for your environment before the retirement date.  
  
**Potential benefits**: Ensure secure traffic control on Windows-based AKS clusters  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500273)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: ec938125-62ef-4dc5-b7b1-257eb8d006d9  
Subcategory: undefined

<!--ec938125-62ef-4dc5-b7b1-257eb8d006d9_end-->

<!--0e15044d-e326-4281-bbe1-1e35b32308ec_begin-->

#### Migrate to Cilium Network Policy  
  
Azure Network Policy Manager for Azure Kubernetes Service clusters running Linux nodes is retiring. Migrate to Cilium Network Policy using Azure Container Networking Interface powered by Cilium before the retirement date.  
  
**Potential benefits**: Avoid service disruptions and unsupported configurations  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500268)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 0e15044d-e326-4281-bbe1-1e35b32308ec  
Subcategory: undefined

<!--0e15044d-e326-4281-bbe1-1e35b32308ec_end-->



<!--91594754-953c-4eda-ac71-7b8e2e9b0e74_begin-->

#### Migrate to Azure Linux 3.0  
  
Transition to Azure Linux 3.0 before the retirement date to receive future kernel updates, receive future security improvements, and avoid scaling failures.  
  
**Potential benefits**: Avoid service disruptions and unsupported configurations  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500645)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 91594754-953c-4eda-ac71-7b8e2e9b0e74  
Subcategory: undefined

<!--91594754-953c-4eda-ac71-7b8e2e9b0e74_end-->

<!--articleBody-->
