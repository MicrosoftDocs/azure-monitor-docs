---
ms.service: azure
ms.topic: include
ms.date: 11/11/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Virtual Machines
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Virtual Machines  
  
<!--48eda464-1485-4dcf-a674-d0905df5054a_begin-->

#### Review disks that aren't attached to a VM and evaluate if you still need the disks  
  
We have observed that you have disks that aren't attached to a VM. Evaluate if you still need the disk. If you decide to delete the disk, recovery isn't possible. We recommend that you create a snapshot before deletion or ensure the data in the disk is no longer required.  
  
**Potential benefits**: Cost saving.  

**Impact:** Medium
  
For more information, see [Identify unattached Azure disks - Azure portal - Azure Virtual Machines](https://aka.ms/unattacheddisks)  

ResourceType: microsoft.compute/disks  
Recommendation ID: 48eda464-1485-4dcf-a674-d0905df5054a  


<!--48eda464-1485-4dcf-a674-d0905df5054a_end-->


<!--201fb2fe-989f-45c1-8533-785ee8a4a08f_begin-->

#### Standard SSD disks billing caps  
  
Customers running high IO workloads in Standard HDDs can upgrade to Standard SSDs and benefit from better performance and SLA and now experience a limit on the maximum number of billed transactions.  
  
**Potential benefits**: Better performance and lower costs  

**Impact:** Medium
  
For more information, see [Azure Disks Standard SSD billable transaction cap blog](https://techcommunity.microsoft.com/blog/azurestorageblog/cost-saving-with-standard-ssd-billing-caps/3758792)  

ResourceType: microsoft.compute/disks  
Recommendation ID: 201fb2fe-989f-45c1-8533-785ee8a4a08f  


<!--201fb2fe-989f-45c1-8533-785ee8a4a08f_end-->


<!--702b474d-698f-4029-9f9d-4782c626923e_begin-->

#### Use Standard Storage to store Managed Disks snapshots  
  
To save 60% of cost, we recommend storing your snapshots in Standard Storage, regardless of the storage type of the parent disk. This option is the default for Managed Disks snapshots. Migrate your snapshot from Premium to Standard Storage. Refer to Managed Disks pricing details.  
  
**Potential benefits**: 60% reduction in the snapshot cost for Managed Disks  

**Impact:** High
  
For more information, see [Pricing - Managed Disks ](https://aka.ms/aa_manageddisksnapshot_learnmore)  

ResourceType: microsoft.compute/snapshots  
Recommendation ID: 702b474d-698f-4029-9f9d-4782c626923e  


<!--702b474d-698f-4029-9f9d-4782c626923e_end-->

<!--e10b1381-5f0a-47ff-8c7b-37bd13d7c974_begin-->

#### Right-size or shutdown underutilized virtual machines  
  
We've analyzed the usage patterns of your virtual machine and identified virtual machines with low usage. While certain scenarios can result in low utilization by design, you can often save money by managing the size and number of virtual machines.  
  
**Potential benefits**: savings  

**Impact:** High
  
For more information, see [Reduce service costs using Azure Advisor - Azure Advisor ](https://aka.ms/aa_lowusagerec_learnmore)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: e10b1381-5f0a-47ff-8c7b-37bd13d7c974  


<!--e10b1381-5f0a-47ff-8c7b-37bd13d7c974_end-->

<!--94aea435-ef39-493f-a547-8408092c22a7_begin-->

#### Right-size or shutdown underutilized virtual machine scale sets  
  
We've analyzed the usage patterns of your virtual machine scale sets over the past 7 days and identified virtual machine scale sets with low usage. While certain scenarios can result in low utilization by design, you can often save money by managing the size and number of virtual machine scale sets.  
  
**Potential benefits**: savings  

**Impact:** High
  
For more information, see [Reduce service costs using Azure Advisor - Azure Advisor ](https://aka.ms/aa_lowusagerec_vmss_learnmore)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 94aea435-ef39-493f-a547-8408092c22a7  


<!--94aea435-ef39-493f-a547-8408092c22a7_end-->

<!--articleBody-->
