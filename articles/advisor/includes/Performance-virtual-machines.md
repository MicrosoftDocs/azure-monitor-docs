---
ms.service: azure
ms.topic: include
ms.date: 11/25/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Virtual Machines
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Virtual Machines

<!--3a3c1a2a-8597-4d3a-981a-0a24a0ee9de4_begin-->

#### Enable Accelerated Networking to improve network performance and latency  
  
We detected that Accelerated Networking isn't enabled on VM resources in your existing deployment that may be capable of supporting this feature. If your VM OS image supports Accelerated Networking as detailed in the documentation, make sure to enable this free feature on these VMs to maximize the performance and latency of your networking workloads in cloud  
  
**Potential benefits**: Improves performance throughput while reducing latency and jitter  

**Impact:** Medium
  
For more information, see [Create an Azure Virtual Machine with Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli#enable-accelerated-networking-on-existing-vms)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 3a3c1a2a-8597-4d3a-981a-0a24a0ee9de4  


<!--3a3c1a2a-8597-4d3a-981a-0a24a0ee9de4_end-->

<!--06c03895-e210-4153-a4a0-a5e5c8e8eb83_begin-->

#### Upgrade the size of your most active virtual machines to prevent resource exhaustion and improve performance  
  
We analyzed data for the past 7 days and identified virtual machines (VMs) with high utilization across different metrics, for example, CPU, Memory, and VM I/O. The VMs may experience performance issues since they are nearing or at the SKU limits. Consider upgrading their SKU to improve performance.  
  
**Potential benefits**: Improve the performance and reliability of your VMs  

**Impact:** High
  
For more information, see [Improve the performance of highly used VMs using Azure Advisor - Azure Advisor](https://aka.ms/aa_resizehighusagevmrec_learnmore)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 06c03895-e210-4153-a4a0-a5e5c8e8eb83  


<!--06c03895-e210-4153-a4a0-a5e5c8e8eb83_end-->

<!--36c3633b-daac-4e01-af95-11b8c2f4fe20_begin-->

#### Use Managed Disks to prevent disk I/O throttling  
  
Your virtual machine disks belong to a storage account that reached its scalability target, and is susceptible to I/O throttling. To protect your virtual machine from performance degradation and to simplify storage management, use Managed Disks.  
  
**Potential benefits**: Improved data resilience and performance  

**Impact:** High
  
For more information, see [Overview of Azure Disk Storage - Azure Virtual Machines](https://aka.ms/manageddiskintroduction)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 36c3633b-daac-4e01-af95-11b8c2f4fe20  


<!--36c3633b-daac-4e01-af95-11b8c2f4fe20_end-->


<!--5e305558-6944-40bb-9d69-eb161b42fcec_begin-->

#### Upgrade to the current generation virtual machines  
  
The v5 VMs provides newer and faster cores, increased networking throughputs, and better global redundancy and availability. Upgrade to the v5 VMs from the v3 or v2 VMs to match or exceed performance at the same cost.  
  
**Potential benefits**: 5 VM offers improved core, storage, and network performance  

**Impact:** Medium
  
For more information, see [D-family size series - Azure Virtual Machines](https://aka.ms/AAsjnij)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 5e305558-6944-40bb-9d69-eb161b42fcec  


<!--5e305558-6944-40bb-9d69-eb161b42fcec_end-->

<!--c889b55f-9132-444d-a31f-c9e91f1345c9_begin-->

#### Improve user experience and connectivity by deploying VMs closer to user's location  
  
We determined that your VMs are located in a region different or far from where your users are connecting, using Windows Virtual Desktop (WVD). This leads to prolonged connection response times and impacts overall user experience on WVD.  
  
**Potential benefits**: Improves satisfaction with network round-trip time of the WVD service deployments.  

**Impact:** Medium
  
For more information, see [Analyze connection quality in Azure Virtual Desktop - Azure](/azure/virtual-desktop/connection-latency)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: c889b55f-9132-444d-a31f-c9e91f1345c9  


<!--c889b55f-9132-444d-a31f-c9e91f1345c9_end-->

<!--031dcbd7-479c-4059-a7ba-c5474c94b72e_begin-->

#### Upgrade OS disks approaching the disk limit  
  
The OS hard disk drive (HDD) is approaching disk limits, upgrade to SSD. Azure SSDs provide industry-leading performance with high I/O operations per second (IOPS) and low latency. Particularly, Premium SSD supports bursting and performance tiers whereas Standard SSD supports bursting.  
  
**Potential benefits**: Improved performance, scalability, and cost-effectiveness.  

**Impact:** Medium
  
For more information, see [Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines](/azure/virtual-machines/disks-types#premium-ssds)  

ResourceType: microsoft.compute/disks  
Recommendation ID: 031dcbd7-479c-4059-a7ba-c5474c94b72e  


<!--031dcbd7-479c-4059-a7ba-c5474c94b72e_end-->

<!--articleBody-->
