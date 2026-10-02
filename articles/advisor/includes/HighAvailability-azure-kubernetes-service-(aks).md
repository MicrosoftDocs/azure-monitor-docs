---
ms.service: azure
ms.topic: include
ms.date: 05/12/2026
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

<!--70829b1a-272b-4728-b418-8f1a56432d33_end-->


<!--a9228ae7-4386-41be-b527-acd59fad3c79_begin-->

#### Have at least 2 nodes in your system node pool  
  
Ensure your system node pools have at least 2 nodes for reliability of your system pods. With a single node, your cluster can fail in the event of a node or hardware failure.  
  
**Potential benefits**: Having 2 nodes ensures resiliency against node failures.  

**Impact:** High
  
For more information, see [Use system node pools in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/use-system-pools?tabs=azure-cli#system-and-user-node-pools)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: a9228ae7-4386-41be-b527-acd59fad3c79  

<!--a9228ae7-4386-41be-b527-acd59fad3c79_end-->


<!--f31832f1-7e87-499d-a52a-120f610aba98_begin-->

#### Create a dedicated system node pool  
  
Your cluster doesn't have a dedicated system node pool. It's recommended to dedicate system node pools to only serve critical system pods. This prevents resource starvation between system and competing user pods. Enforce this behavior with the CriticalAddonsOnly=true:NoSchedule taint on the pool.  
  
**Potential benefits**: Prevents resource scarcity for core system pods  

**Impact:** High
  
For more information, see [Use system node pools in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/use-system-pools?tabs=azure-cli#before-you-begin)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: f31832f1-7e87-499d-a52a-120f610aba98  

<!--f31832f1-7e87-499d-a52a-120f610aba98_end-->



<!--fac2ad84-1421-4dd3-8477-9d6e605392b4_begin-->

#### Clusters with node pools using nonrecommended B-series
  
When a cluster has one or more node pools that use a nonrecommended burstable VM SKU, the cluster doesn't guarantee full vCPU capability at 100%. Ensure B-series VMs aren't used in production environments.
  
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

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485172)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 863d09bd-e767-472b-9980-f32709414ade  

<!--863d09bd-e767-472b-9980-f32709414ade_end-->

<!--b005ecf0-23e2-4279-9ca2-718d1518c9fb_begin-->

#### Migrate to Container insights managed identity authentication  
  
Migrate to Container insights managed identity authentication before the retirement date to maintain access and retain functionality.  
  
**Potential benefits**: Avoid service disruption and gain enhanced features  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500853)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: b005ecf0-23e2-4279-9ca2-718d1518c9fb  

<!--b005ecf0-23e2-4279-9ca2-718d1518c9fb_end-->

<!--8aad9adb-cb6a-4ddc-b659-12d1c6ca186a_begin-->

#### Use Fleet Manager auto-upgrade profiles to regularly update clusters  
  
Use Azure Kubernetes Fleet Manager to safely update multiple clusters using update runs, auto-upgrade profiles and strategies.  
  
**Potential benefits**: Safe and predictable updates of multiple clusters  

**Impact:** Medium
  
For more information, see [Automate upgrades of Kubernetes and node images across multiple clusters using Azure Kubernetes Fleet Manager](https://aka.ms/kubernetes-fleet/auto-upgrade)  

ResourceType: microsoft.containerservice/fleets  
Recommendation ID: 8aad9adb-cb6a-4ddc-b659-12d1c6ca186a  

<!--8aad9adb-cb6a-4ddc-b659-12d1c6ca186a_end-->

<!--ec938125-62ef-4dc5-b7b1-257eb8d006d9_begin-->

#### Migrate from NPM for Windows on AKS  
  
Customers should explore alternative options for restricting traffic access on Windows clusters, such as:
Network Security Groups (NSGs) at the node level or Open-source tools like Project Calico.
Microsoft encourages identifying the best approach for your environment before the retirement date.  
  
**Potential benefits**: Ensure secure traffic control on Windows-based AKS clusters  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500273)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: ec938125-62ef-4dc5-b7b1-257eb8d006d9  

<!--ec938125-62ef-4dc5-b7b1-257eb8d006d9_end-->

<!--0e15044d-e326-4281-bbe1-1e35b32308ec_begin-->

#### Migrate to Cilium Network Policy  
  
Azure Network Policy Manager for Azure Kubernetes Service clusters running Linux nodes is retiring. Migrate to Cilium Network Policy using Azure Container Networking Interface powered by Cilium before the retirement date.  
  
**Potential benefits**: Avoid service disruptions and unsupported configurations  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500268)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 0e15044d-e326-4281-bbe1-1e35b32308ec  

<!--0e15044d-e326-4281-bbe1-1e35b32308ec_end-->



<!--91594754-953c-4eda-ac71-7b8e2e9b0e74_begin-->

#### Migrate to Azure Linux 3.0  
  
Transition to Azure Linux 3.0 before the retirement date to receive future kernel updates, receive future security improvements, and avoid scaling failures.  
  
**Potential benefits**: Avoid service disruptions and unsupported configurations  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500645)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 91594754-953c-4eda-ac71-7b8e2e9b0e74  

<!--91594754-953c-4eda-ac71-7b8e2e9b0e74_end-->

<!--40985a2e-6876-4a4c-902e-c85d06272935_begin-->

#### Migrate from NGINX Ingress with Application Routing Add On  
  
Managed NGINX Ingress via the AKS Application Routing add-on is retiring. Plan migrations to alternative solutions like Application Gateway for Containers (AGC) or Istio-based service mesh.  
  
**Potential benefits**: Avoid service interruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=555839)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 40985a2e-6876-4a4c-902e-c85d06272935  

<!--40985a2e-6876-4a4c-902e-c85d06272935_end-->

<!--c7507a57-0abf-47af-81bb-819a675bc956_begin-->

#### Azure Kubernetes Support for HC-series is being retired  
  
Standard_HC44rs, Standard_HC44-16rs, and Standard_HC44-32rs virtual machine sizes will be retired. Transition to one of the current-generation Azure HPC VM families, HBv5-series, or HX-series VMs.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Migrate your HC-series virtual machines by May 31, 2027 - Azure Virtual Machines](/azure/virtual-machines/sizes/retirement/hc-series-retirement)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: c7507a57-0abf-47af-81bb-819a675bc956  

<!--c7507a57-0abf-47af-81bb-819a675bc956_end-->

<!--10378caa-f4fe-48f3-9893-6bdec79687b2_begin-->

#### Azure Kubernetes Support for HBv2-series is being retired  
  
Standard_HB120rs_v2, Standard_HB120-96rs_v2, Standard_HB120-64rs_v2, Standard_HB120-32rs_v2, and Standard_HB120-16rs_v2 virtual machine sizes will be retired. Transition to the HBv5-series VMs.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Migrate your HBv2-series virtual machines by May 31, 2027 - Azure Virtual Machines](/azure/virtual-machines/sizes/retirement/hbv2-series-retirement)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 10378caa-f4fe-48f3-9893-6bdec79687b2  

<!--10378caa-f4fe-48f3-9893-6bdec79687b2_end-->

<!--00dbcc9d-50d4-44ef-bc21-c15785cddf42_begin-->

#### Migrate to Ubuntu 24.04 or later versions  
  
Azure Kubernetes Service support for Ubuntu 22.04 is retiring, transition to Ubuntu 24.04+ or a supported alternative.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=557928)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 00dbcc9d-50d4-44ef-bc21-c15785cddf42  

<!--00dbcc9d-50d4-44ef-bc21-c15785cddf42_end-->

<!--1f0dbe45-11b2-44e5-a6e6-676f599f786f_begin-->

#### Azure Kubernetes Service support for NP-series is being retired  
  
Standard_NP10s, Standard_NP20s, and Standard_NP40s virtual machine sizes are being retired. Transition to NC-series or ND-series VMs.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Migrate your NP-series virtual machines by May 31, 2027 - Azure Virtual Machines](/azure/virtual-machines/sizes/retirement/np-series-retirement)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 1f0dbe45-11b2-44e5-a6e6-676f599f786f  

<!--1f0dbe45-11b2-44e5-a6e6-676f599f786f_end-->

<!--4686c4de-4652-475b-95a5-08f6518424a9_begin-->

#### Kubenet networking for Azure Kubernetes Service (AKS) is retiring  
  
After the retirement date, workloads running on kubenet networking for AKS aren't supported.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485172)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 4686c4de-4652-475b-95a5-08f6518424a9  

<!--4686c4de-4652-475b-95a5-08f6518424a9_end-->

<!--73d80d39-3c2c-4baa-908c-82d76027ab14_begin-->

#### Kubernetes workloads is stopping support of Windows Server 2019  
  
Windows Server 2019 retires when Kubernetes 1.32 reaches the end of platform support. On Kubernetes 1.33 and later, creation of new Windows Server 2019 node pools is blocked.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Upgrade the Operating System (OS) Version for your Azure Kubernetes Service (AKS) Windows Workloads - Azure Kubernetes Service](/azure/aks/upgrade-windows-os)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 73d80d39-3c2c-4baa-908c-82d76027ab14  

<!--73d80d39-3c2c-4baa-908c-82d76027ab14_end-->

<!--2c717abc-d6b0-4588-aa10-8ecaec0a33b4_begin-->

#### Migrate Windows Server 2022 to a supported version for Kubernetes workloads  
  
Windows Server 2022 retires when Kubernetes 1.34 reaches the end of platform support. On Kubernetes 1.35 and later, creation of new Windows Server 2022 node pools is blocked.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Upgrade the Operating System (OS) Version for your Azure Kubernetes Service (AKS) Windows Workloads - Azure Kubernetes Service](/azure/aks/upgrade-windows-os)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 2c717abc-d6b0-4588-aa10-8ecaec0a33b4  

<!--2c717abc-d6b0-4588-aa10-8ecaec0a33b4_end-->

<!--66e6be23-79fa-464a-b1b6-dfce922075c3_begin-->

#### Ubuntu 18.04 on Azure Kubernetes Service is being retired  
  
To avoid service disruptions, scaling restrictions, and remain supported, upgrade to a supported Kubernetes version.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485790)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 66e6be23-79fa-464a-b1b6-dfce922075c3  

<!--66e6be23-79fa-464a-b1b6-dfce922075c3_end-->

<!--7c4f5f17-03a6-4bc7-b59d-4e565f8dba87_begin-->

#### Ubuntu 20.04 LTS support is being retired  
  
Ubuntu 20.04 LTS support is being retired.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/support-for-ubuntu-2004-lts-for-batch-pools-will-be-retired-on-23-april-2025/)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 7c4f5f17-03a6-4bc7-b59d-4e565f8dba87  

<!--7c4f5f17-03a6-4bc7-b59d-4e565f8dba87_end-->

<!--b85966b5-4c36-475f-b230-d8a6e31c1375_begin-->

#### Upgrade your AKS cluster from 1.31 LTS Kubernetes version  
  
Azure Kubernetes Service retires 1.31 LTS Kubernetes version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.31 LTS Kubernetes version.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: b85966b5-4c36-475f-b230-d8a6e31c1375  

<!--b85966b5-4c36-475f-b230-d8a6e31c1375_end-->

<!--7dcef62e-792c-49dc-b36a-1938829c449c_begin-->

#### Upgrade your AKS cluster from 1.32 Kubernetes Official version  
  
Azure Kubernetes Service retires 1.32 Kubernetes Official version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.32 Kubernetes Official version.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 7dcef62e-792c-49dc-b36a-1938829c449c  

<!--7dcef62e-792c-49dc-b36a-1938829c449c_end-->

<!--11112bf2-7226-486c-94b3-cff3ea6b59e2_begin-->

#### Upgrade your AKS cluster from 1.32 LTS Kubernetes version  
  
Azure Kubernetes Service retires 1.32 LTS Kubernetes version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.32 LTS Kubernetes version.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 11112bf2-7226-486c-94b3-cff3ea6b59e2  

<!--11112bf2-7226-486c-94b3-cff3ea6b59e2_end-->

<!--cf2add1a-e133-4562-92a0-4bd39b2f659b_begin-->

#### Upgrade your AKS cluster from 1.33 Kubernetes Official version  
  
Azure Kubernetes Service retires 1.33 Kubernetes Official version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.33 Kubernetes Official version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: cf2add1a-e133-4562-92a0-4bd39b2f659b  

<!--cf2add1a-e133-4562-92a0-4bd39b2f659b_end-->

<!--56b606bb-1363-4fc0-91ef-b26127579d38_begin-->

#### Upgrade your AKS cluster from 1.33 LTS Kubernetes version  
  
Azure Kubernetes Service retires 1.33 LTS Kubernetes version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.33 LTS Kubernetes version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 56b606bb-1363-4fc0-91ef-b26127579d38  

<!--56b606bb-1363-4fc0-91ef-b26127579d38_end-->

<!--0b1bf3f1-eb3e-4855-b9a5-06cde224c60d_begin-->

#### Upgrade your AKS cluster from 1.34 Kubernetes Official version  
  
Azure Kubernetes Service retires 1.34 Kubernetes Official version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.34 Kubernetes Official version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 0b1bf3f1-eb3e-4855-b9a5-06cde224c60d  

<!--0b1bf3f1-eb3e-4855-b9a5-06cde224c60d_end-->

<!--997ec7aa-2f8d-4268-9ac0-4e8147cbe9d7_begin-->

#### Upgrade your AKS cluster from 1.34 LTS Kubernetes version  
  
Azure Kubernetes Service retires 1.34 LTS Kubernetes version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.34 LTS Kubernetes version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 997ec7aa-2f8d-4268-9ac0-4e8147cbe9d7  

<!--997ec7aa-2f8d-4268-9ac0-4e8147cbe9d7_end-->

<!--e228c486-197f-415c-8b93-5e2b07458c17_begin-->

#### Upgrade your AKS cluster from 1.35 Kubernetes Official version  
  
Azure Kubernetes Service retires 1.35 Kubernetes Official version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.35 Kubernetes Official version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: e228c486-197f-415c-8b93-5e2b07458c17  

<!--e228c486-197f-415c-8b93-5e2b07458c17_end-->

<!--af3198f6-7691-4d61-8e30-da79088eb579_begin-->

#### Upgrade your AKS cluster from 1.35 LTS Kubernetes version  
  
Azure Kubernetes Service retires 1.35 LTS Kubernetes version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.35 LTS Kubernetes version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: af3198f6-7691-4d61-8e30-da79088eb579  

<!--af3198f6-7691-4d61-8e30-da79088eb579_end-->

<!--e828d5b8-b7bd-47b8-ac15-30e825ccdcfe_begin-->

#### Upgrade your AKS cluster from 1.36 Kubernetes Official version  
  
Azure Kubernetes Service retires 1.36 Kubernetes Official version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.36 Kubernetes Official version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: e828d5b8-b7bd-47b8-ac15-30e825ccdcfe  

<!--e828d5b8-b7bd-47b8-ac15-30e825ccdcfe_end-->

<!--c540fc0a-d78a-4b6a-84df-c97dae512b2d_begin-->

#### Upgrade your AKS cluster from 1.37 Kubernetes Official version  
  
Azure Kubernetes Service retires 1.37 Kubernetes Official version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.37 Kubernetes Official version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: c540fc0a-d78a-4b6a-84df-c97dae512b2d  

<!--c540fc0a-d78a-4b6a-84df-c97dae512b2d_end-->

<!--cc60a05a-1e40-403f-9790-28f310d54249_begin-->

#### Upgrade your AKS cluster from 1.37 LTS Kubernetes version  
  
Azure Kubernetes Service retires 1.37 LTS Kubernetes version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.37 LTS Kubernetes version.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: cc60a05a-1e40-403f-9790-28f310d54249  

<!--cc60a05a-1e40-403f-9790-28f310d54249_end-->

<!--3afd0e0e-36bd-444b-97d7-d1e85d44066d_begin-->

#### Upgrade your AKS cluster to a supported long-term support (LTS) version  
  
Azure Kubernetes Service retires 1.30 LTS version. To stay within supported versions and service-level agreements (SLA), upgrade to a supported version within 30 days after Azure removes version 1.30 LTS.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Supported Kubernetes Versions in Azure Kubernetes Service (AKS) - Azure Kubernetes Service](/azure/aks/supported-kubernetes-versions?tabs=azure-cli)  

ResourceType: microsoft.containerservice/managedclusters  
Recommendation ID: 3afd0e0e-36bd-444b-97d7-d1e85d44066d  

<!--3afd0e0e-36bd-444b-97d7-d1e85d44066d_end-->

<!--articleBody-->
