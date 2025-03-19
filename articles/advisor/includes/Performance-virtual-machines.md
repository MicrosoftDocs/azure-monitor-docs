---
ms.service: azure
ms.topic: include
ms.date: 02/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Performance Virtual Machines
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Virtual Machines  
  
<!--00c14add-2aef-4bb4-a3bd-5759096d4417_begin-->

#### Convert Managed Disks from Standard HDD to Premium SSD for performance  
  
We noticed your Standard HDD disk is approaching performance targets. Azure premium SSDs deliver high-performance and low-latency disk support for virtual machines with IO-intensive workloads. Give your disk performance a boost by upgrading your Standard HDD disk to Premium SSD disk. Upgrading requires a VM reboot, which takes three to five minutes.  
  
**Potential benefits**: Give your disk performance a boost using Premium SSD disks.  

**Impact:** Medium
  
For more information, see [Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines](/azure/virtual-machines/windows/disks-types#premium-ssd)  

ResourceType: microsoft.compute/disks  
Recommendation ID: 00c14add-2aef-4bb4-a3bd-5759096d4417  


<!--00c14add-2aef-4bb4-a3bd-5759096d4417_end-->

<!--3a3c1a2a-8597-4d3a-981a-0a24a0ee9de4_begin-->

#### Enable Accelerated Networking to improve network performance and latency  
  
We detected that Accelerated Networking isn't enabled on VM resources in your existing deployment that may be capable of supporting this feature. If your VM OS image supports Accelerated Networking as detailed in the documentation, make sure to enable this free feature on these VMs to maximize the performance and latency of your networking workloads in cloud  
  
**Potential benefits**: Improves performance throughput while reducing latency and jitter  

**Impact:** Medium
  
For more information, see [Create an Azure Virtual Machine with Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli#enable-accelerated-networking-on-existing-vms)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 3a3c1a2a-8597-4d3a-981a-0a24a0ee9de4  


<!--3a3c1a2a-8597-4d3a-981a-0a24a0ee9de4_end-->

<!--a06456ed-afb7-4d16-86fd-0054e25268ed_begin-->

#### Accelerated Networking may require stopping and starting the VM  
  
We detected that Accelerated Networking isn't engaged on a VM resources in your existing deployment even though the feature has been requested. In rare cases like this, it may be necessary to stop and start your VM, at your convenience, to re-engage AccelNet.  
  
**Potential benefits**: Improves performance throughput while reducing latency and jitter  

**Impact:** Medium
  
For more information, see [Create an Azure Virtual Machine with Accelerated Networking](/azure/virtual-network/create-vm-accelerated-networking-cli#enable-accelerated-networking-on-existing-vms)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: a06456ed-afb7-4d16-86fd-0054e25268ed  


<!--a06456ed-afb7-4d16-86fd-0054e25268ed_end-->

<!--7fc8d697-5101-4dd2-abf5-32deac4b9cae_begin-->

#### Update Automanage to the latest API Version  
  
We identified SDK requests from outdated API for resources under this subscription. We recommend switching to the latest SDK versions. This ensures you receive the latest features and performance improvements.  
  
**Potential benefits**: Latest Automanage API contains fixes for known issues and other improvements.  

**Impact:** Medium
  
For more information, see [SDK Overview](/azure/automanage/reference-sdk)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 7fc8d697-5101-4dd2-abf5-32deac4b9cae  


<!--7fc8d697-5101-4dd2-abf5-32deac4b9cae_end-->

<!--7cdecd2c-a8b0-41cf-b0a4-528bd4d85f5a_begin-->

#### Take advantage of Ultra Disk low latency for your log disks and improve your database workload performance  
  
Ultra disk is available in the same region as your database workload. Ultra disk offers high throughput, high IOPS, and consistent low latency disk storage for your database workloads: For Oracle DBs, you can now use either 4k or 512E sector sizes with Ultra disk depending on your Oracle DB version. For SQL server, leveraging Ultra disk for your log disk might offer more performance for your database. See instructions here for migrating your log disk to Ultra disk.  
  
**Potential benefits**: Boost the performance of your database on IaaS VMs by using Ultra disk as log disk.  

**Impact:** Medium
  
For more information, see [Ultra disks for VMs - Azure managed disks - Azure Virtual Machines](/azure/virtual-machines/disks-enable-ultra-ssd?tabs=azure-portal)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 7cdecd2c-a8b0-41cf-b0a4-528bd4d85f5a  


<!--7cdecd2c-a8b0-41cf-b0a4-528bd4d85f5a_end-->

<!--9b0d1cf7-8a3a-4c8b-8f9f-1c3e70e399d6_begin-->

#### Match production Virtual Machines with Production Disk for consistent performance and better latency  
  
Production virtual machines need production disks if you want to get the best performance. We see that you are running a production level virtual machine, however, you are using a low performing disk with standard HDD. Upgrading your disks that are attached to your production disks, either Standard SSD or Premium SSD, provides a more consistent experience and improvements in latency.  
  
**Potential benefits**: More consistent performance, better latency  

**Impact:** Medium
  
For more information, see [Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines](/azure/virtual-machines/windows/disks-types#disk-comparison)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 9b0d1cf7-8a3a-4c8b-8f9f-1c3e70e399d6  


<!--9b0d1cf7-8a3a-4c8b-8f9f-1c3e70e399d6_end-->

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

#### Use Managed disks to prevent disk I/O throttling  
  
Your virtual machine disks belong to a storage account that reached its scalability target, and is susceptible to I/O throttling. To protect your virtual machine from performance degradation and to simplify storage management, use Managed Disks.  
  
**Potential benefits**: Improved data resilience and performance  

**Impact:** High
  
  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 36c3633b-daac-4e01-af95-11b8c2f4fe20  


<!--36c3633b-daac-4e01-af95-11b8c2f4fe20_end-->

<!--6747b02b-b6ac-4c2e-aeca-c2aa0438f58d_begin-->

#### Use SSD Disks for your production workloads  
  
We noticed that you are using SSD disks while also using Standard HDD disks on the same VM. Standard HDD managed disks are recommended for dev-test and backup; we recommend you use Premium SSDs or Standard SSDs for production. Premium SSDs deliver high-performance and low-latency disk support for virtual machines with IO-intensive workloads. Standard SSDs provide consistent and lower latency. Upgrade your disk configuration today for improved latency, reliability, and availability. Upgrading requires a VM reboot, which takes three to five minutes.  
  
**Potential benefits**: Improve latency, reliability, and availability  

**Impact:** High
  
For more information, see [Select a disk type for Azure IaaS VMs - managed disks - Azure Virtual Machines](/azure/virtual-machines/windows/disks-types#disk-comparison)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 6747b02b-b6ac-4c2e-aeca-c2aa0438f58d  


<!--6747b02b-b6ac-4c2e-aeca-c2aa0438f58d_end-->

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

<!--articleBody-->
