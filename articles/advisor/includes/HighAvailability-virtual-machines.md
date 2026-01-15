---
ms.service: azure
ms.topic: include
ms.date: 01/13/2026
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Virtual Machines
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Virtual Machines  
  
<!--02cfb5ef-a0c1-4633-9854-031fbda09946_begin-->

#### Improve data reliability using Managed Disks  
  
VMs in an Availability Set sharing storage accounts or scale units risk downtime from single-unit failures. Use Azure Managed Disks to isolate VM disks across units and eliminate single points of failure.  
  
**Potential benefits**: Ensure business continuity through data resilience  

**Impact:** High
  
For more information, see [Overview of Azure Disk Storage - Azure Virtual Machines](https://aka.ms/manageddiskintroduction)  

ResourceType: microsoft.compute/availabilitysets  
Recommendation ID: 02cfb5ef-a0c1-4633-9854-031fbda09946  
Subcategory: HighAvailability

<!--02cfb5ef-a0c1-4633-9854-031fbda09946_end-->


<!--d4102c0f-ebe3-4b22-8fe0-e488866a87af_begin-->

#### Use Azure Disks with Zone Redundant Storage (ZRS) for higher resiliency and availability  
  
Azure Disks with ZRS provide synchronous replication of data across three Availability Zones in a region, making the disk tolerant to zonal failures without disruptions to applications. For higher resiliency and availability, migrate disks from LRS to ZRS.  
  
**Potential benefits**: By designing your applications to use ZRS Disks, your data is replicated across 3 Availability Zones, making your disk resilient to a zonal outage  

**Impact:** High
  
For more information, see [Convert a disk from LRS to ZRS - Azure Virtual Machines ](https://aka.ms/migratedisksfromLRStoZRS)  

ResourceType: microsoft.compute/disks  
Recommendation ID: d4102c0f-ebe3-4b22-8fe0-e488866a87af  
Subcategory: HighAvailability

<!--d4102c0f-ebe3-4b22-8fe0-e488866a87af_end-->

<!--ed651749-cd37-4fd5-9897-01b416926745_begin-->

#### Enable virtual machine replication to protect applications from regional outage  
  
Virtual machines are resilient to regional outages when replication to another region is enabled. To reduce adverse business effect during an Azure region outage, the platform recommends enabling replication of all business-critical virtual machines.  
  
**Potential benefits**: Ensure business continuity during an Azure region outage.  

**Impact:** High
  
For more information, see [Set up Azure VM disaster recovery to a secondary region with Azure Site Recovery - Azure Site Recovery](https://aka.ms/azure-site-recovery-dr-azure-vms)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: ed651749-cd37-4fd5-9897-01b416926745  
Subcategory: undefined

<!--ed651749-cd37-4fd5-9897-01b416926745_end-->


<!--57ecb3cd-f2b4-4cad-8b3a-232cca527a0b_begin-->

#### Upgrade VM from Premium Unmanaged Disks to Managed Disks at no additional cost  
  
Azure Managed Disks provide higher resiliency, simplified service management, higher scale target and more choices among several disk types. Your VM is using premium unmanaged disks that can be migrated to managed disks at no additional cost through the portal in less than 5 minutes.  
  
**Potential benefits**: Leverage higher resiliency and other benefits of Managed Disks  

**Impact:** High
  
For more information, see [Overview of Azure Disk Storage - Azure Virtual Machines ](https://aka.ms/md_overview)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 57ecb3cd-f2b4-4cad-8b3a-232cca527a0b  
Subcategory: HighAvailability

<!--57ecb3cd-f2b4-4cad-8b3a-232cca527a0b_end-->

<!--11f04d70-5bb3-4065-b717-1f11b2e050a8_begin-->

#### Upgrade your deprecated Virtual Machine image to a newer image  
  
Virtual Machines (VMs) in your subscription are running on images scheduled for deprecation. Once the image is deprecated, new VMs can't be created from the deprecated image. To prevent disruption to your workloads, upgrade to a newer image. (VMRunningDeprecatedImage)  
  
**Potential benefits**: Minimize any potential disruptions to your VM workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 11f04d70-5bb3-4065-b717-1f11b2e050a8  
Subcategory: ServiceUpgradeAndRetirement

<!--11f04d70-5bb3-4065-b717-1f11b2e050a8_end-->

<!--937d85a4-11b2-4e13-a6b5-9e15e3d74d7b_begin-->

#### Upgrade to a newer offer of Virtual Machine image  
  
Virtual Machines (VMs) in your subscription are running on images scheduled for deprecation. Once the image is deprecated, new VMs can't be created from the deprecated image.  To prevent disruption to your workloads, upgrade to a newer image. (VMRunningDeprecatedOfferLevelImage)  
  
**Potential benefits**: Minimize any potential disruptions to your VM workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 937d85a4-11b2-4e13-a6b5-9e15e3d74d7b  
Subcategory: ServiceUpgradeAndRetirement

<!--937d85a4-11b2-4e13-a6b5-9e15e3d74d7b_end-->

<!--681acf17-11c3-4bdd-8f71-da563c79094c_begin-->

#### Upgrade to a newer SKU of Virtual Machine image  
  
Virtual Machines (VMs) in your subscription are running on images scheduled for deprecation. Once the image is deprecated, new VMs can't be created from the deprecated image.  To prevent disruption to your workloads, upgrade to a newer image.  
  
**Potential benefits**: Minimize any potential disruptions to your VM workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 681acf17-11c3-4bdd-8f71-da563c79094c  
Subcategory: ServiceUpgradeAndRetirement

<!--681acf17-11c3-4bdd-8f71-da563c79094c_end-->

<!--53e0a3cb-3569-474a-8d7b-7fd06a8ec227_begin-->

#### Provide access to mandatory URLs missing for your Azure Virtual Desktop environment  
  
For a session host to deploy and register to Windows Virtual Desktop (WVD) properly, you need a set of URLs in the 'allowed list' in case your VM runs in a restricted environment. For specific URLs missing from your allowed list, search your application event log for event 3702.  
  
**Potential benefits**: Ensure successful deployment and session host functionality when using Windows Virtual Desktop service  

**Impact:** Medium
  
For more information, see [Required FQDNs and endpoints for Azure Virtual Desktop ](/azure/virtual-desktop/safe-url-list)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 53e0a3cb-3569-474a-8d7b-7fd06a8ec227  
Subcategory: Other

<!--53e0a3cb-3569-474a-8d7b-7fd06a8ec227_end-->

<!--066a047a-9ace-45f4-ac50-6325840a6b00_begin-->

#### Use Availability zones for better resiliency and availability  
  
Availability Zones (AZ) in Azure help protect your applications and data from datacenter failures. Each AZ is made up of one or more datacenters equipped with independent power, cooling, and networking. By designing solutions to use zonal VMs, you can isolate your VMs from failure in any other zone.  
  
**Potential benefits**: Usage of zonal VMs protect your apps from zonal outage in any other zones.  

**Impact:** High
  
For more information, see [Tutorial - Move Azure single instance Virtual Machines from regional to zonal availability zones - Azure Virtual Machines ](/azure/virtual-machines/move-virtual-machines-regional-zonal-portal)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 066a047a-9ace-45f4-ac50-6325840a6b00  
Subcategory: HighAvailability

<!--066a047a-9ace-45f4-ac50-6325840a6b00_end-->

<!--2b5cf6e5-2792-49b2-9ec0-0e901be6488b_begin-->

#### Convert Standard to Premium disk for higher uptime  
  
Use a Premium SSD managed disk in a Single Instance virtual machine for the highest uptime. Conversion is allowed from a Standard managed disk to a Premium managed disk.  
  
**Potential benefits**: Enhanced performance, configurability, and uptime  

**Impact:** Low
  
For more information, see [Best practices for high availability with Azure VMs and managed disks - Azure Virtual Machines](https://aka.ms/disks-high-availability)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 2b5cf6e5-2792-49b2-9ec0-0e901be6488b  
Subcategory: BusinessContinuity

<!--2b5cf6e5-2792-49b2-9ec0-0e901be6488b_end-->





<!--490262e8-313c-431f-a143-a9c2cadba41b_begin-->

#### DNS Servers should be configured at the Virtual Network level  
  
Set the DNS Servers for the VM at the Virtual Network level to ensure consistency throughout the environment. In the configuration of the primary network interface, DNS Servers setting should be set to Inherit from virtual network.  
  
**Potential benefits**: Ensures consistency and reliable name resolution  

**Impact:** Low
  
For more information, see [Name resolution for resources in Azure virtual networks ](https://aka.ms/azvnetnameres)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 490262e8-313c-431f-a143-a9c2cadba41b  
Subcategory: Other

<!--490262e8-313c-431f-a143-a9c2cadba41b_end-->

<!--651c7925-17a3-42e5-85cd-73bd095cf27f_begin-->

#### Enable Backups on your Virtual Machines  
  
Secure your data by enabling backups for your virtual machines.  
  
**Potential benefits**: Protection of your Virtual Machines  

**Impact:** Medium
  
For more information, see [What is Azure Backup? - Azure Backup ](/azure/backup/backup-overview)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 651c7925-17a3-42e5-85cd-73bd095cf27f  
Subcategory: DisasterRecovery

<!--651c7925-17a3-42e5-85cd-73bd095cf27f_end-->

<!--e5e707f2-f41f-4aa6-bccf-3fb9748e5b66_begin-->

#### Add additional VM or use Premium disks for higher uptime  
  
Add a second instance VM to Availability Set or upgrade to Premium SSD managed disks for highest uptime.  
  
**Potential benefits**: Enhanced performance, configurability, and uptime  

**Impact:** Medium
  
For more information, see [Best practices for high availability with Azure VMs and managed disks - Azure Virtual Machines](https://aka.ms/disks-high-availability)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: e5e707f2-f41f-4aa6-bccf-3fb9748e5b66  
Subcategory: BusinessContinuity

<!--e5e707f2-f41f-4aa6-bccf-3fb9748e5b66_end-->





<!--3b739bd1-c193-4bb6-a953-1362ee3b03b2_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image version  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. Upgrade to newer version of the image to prevent disruption to your workload.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3b739bd1-c193-4bb6-a953-1362ee3b03b2  
Subcategory: undefined

<!--3b739bd1-c193-4bb6-a953-1362ee3b03b2_end-->


<!--3d18d7cd-bdec-4c68-9160-16a677d0f86a_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image offer  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. To prevent disruption to your workload, upgrade to newer offer of the image.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3d18d7cd-bdec-4c68-9160-16a677d0f86a  
Subcategory: ServiceUpgradeAndRetirement

<!--3d18d7cd-bdec-4c68-9160-16a677d0f86a_end-->

<!--44abb62e-7789-4f2f-8001-fa9624cb3eb3_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image SKU  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. To prevent disruption to your workload, upgrade to newer SKU of the image.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 44abb62e-7789-4f2f-8001-fa9624cb3eb3  
Subcategory: ServiceUpgradeAndRetirement

<!--44abb62e-7789-4f2f-8001-fa9624cb3eb3_end-->

<!--b4d988a9-85e6-4179-b69c-549bdd8a55bb_begin-->

#### Enable automatic repair policy on Azure Virtual Machine Scale Sets (VMSS)  
  
Enabling automatic instance repairs helps achieve high availability by maintaining a set of healthy instances. If an unhealthy instance is found by the Application Health extension or load balancer health probe, automatic instance repairs attempt to recover the instance by triggering repair actions.  
  
**Potential benefits**: Increase resiliency by automating repair of failed instances  

**Impact:** High
  
For more information, see [Automatic instance repairs with Azure Virtual Machine Scale Sets - Azure Virtual Machine Scale Sets](https://aka.ms/vmss-automatic-repair)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: b4d988a9-85e6-4179-b69c-549bdd8a55bb  
Subcategory: BusinessContinuity

<!--b4d988a9-85e6-4179-b69c-549bdd8a55bb_end-->


<!--3c03549b-9c0a-4c13-bed4-def3c7e34ddd_begin-->

#### Upgrade to Standard SSD OS disk  
  
Upgrade the operating system (OS) disk from Standard HDD to Standard SSD for increased uptime of single-instance virtual machine and improved input/output operations and throughput.  
  
**Potential benefits**: Boost single-instance VM uptime from 95% to 99.5%.  

**Impact:** Medium
  
For more information, see [Azure Disks Standard SSD billable transaction cap blog](https://aka.ms/billedcapsblog)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 3c03549b-9c0a-4c13-bed4-def3c7e34ddd  
Subcategory: HighAvailability

<!--3c03549b-9c0a-4c13-bed4-def3c7e34ddd_end-->




<!--7f71b153-c0b7-4e99-a23e-db8179183ec9_begin-->

#### Migrate workload to D-series or better virtual machine  
  
Migrate production workload from A-series or B-series virtual machine (VM) to D-series or better VM. A-series and B-series VMs are designed for entry-level workloads.  
  
**Potential benefits**: Full CPU performance for heavy workload in production  

**Impact:** High
  
For more information, see [Virtual machine sizes overview - Azure Virtual Machines](https://aka.ms/MigrateToHighPerfVMs)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 7f71b153-c0b7-4e99-a23e-db8179183ec9  
Subcategory: undefined

<!--7f71b153-c0b7-4e99-a23e-db8179183ec9_end-->



<!--1670c0af-6536-4cbf-872f-152c91a51a80_begin-->

#### Use Azure Capacity Reservation for virtual machine (VM)  
  
Use Azure Capacity Reservation for virtual machine (VM) that runs critical workloads. Azure Capacity Reservations reserve compute capacity in a specific region or availability zone.  
  
**Potential benefits**: Guaranteed compute capacity in constrained region or zone.  

**Impact:** High
  
For more information, see [On-demand capacity reservation in Azure - Azure Virtual Machines](https://aka.ms/ReserveComputeCapacity)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 1670c0af-6536-4cbf-872f-152c91a51a80  
Subcategory: undefined

<!--1670c0af-6536-4cbf-872f-152c91a51a80_end-->



<!--5f2613df-629f-4b07-9425-2a47ea0dfad3_begin-->

#### Migrate workload to Virtual Machine Scale Sets Flex  
  
Migrate production workload on stand-alone virtual machine (VM) to multiple VMs grouped in a Virtual Machine Scale Sets Flex to intelligently distribute across the platform.  
  
**Potential benefits**: Enhanced resilience to platform faults and updates.  

**Impact:** Medium
  
For more information, see [Orchestration modes for Virtual Machine Scale Sets in Azure - Azure Virtual Machine Scale Sets](/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-orchestration-modes#what-has-changed-with-flexible-orchestration-mode)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 5f2613df-629f-4b07-9425-2a47ea0dfad3  
Subcategory: HighAvailability

<!--5f2613df-629f-4b07-9425-2a47ea0dfad3_end-->


<!--39fb2718-a2ae-4662-a8c9-cd8df23f01eb_begin-->

#### Migrate to Virtual Machine Scale Sets Flex  
  
Migrate workloads from virtual machine (VM) to Virtual Machine Scale Sets Flex for deployment across zones or within the same zone across different fault domains.  
  
**Potential benefits**: Availability across zones or across different fault domains.  

**Impact:** Medium
  
For more information, see [Migrate deployments and resources to Virtual Machine Scale Sets in Flexible orchestration - Azure Virtual Machine Scale Sets](https://aka.ms/MigrateToVMSSFlex)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 39fb2718-a2ae-4662-a8c9-cd8df23f01eb  
Subcategory: HighAvailability

<!--39fb2718-a2ae-4662-a8c9-cd8df23f01eb_end-->


<!--3b587048-b04b-4f81-aaed-e43793652b0f_begin-->

#### Enable Azure Virtual Machine Scale Set (VMSS) application health monitoring  
  
Configuring Virtual Machine Scale Set application health monitoring using the Application Health extension or load balancer health probes enables the Azure platform to improve the resiliency of your application by responding to changes in application health.  
  
**Potential benefits**: Increase resiliency by exposing application health to Azure  

**Impact:** Medium
  
For more information, see [Use Application Health extension with Azure Virtual Machine Scale Sets - Azure Virtual Machine Scale Sets](https://aka.ms/vmss-app-health-monitoring)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3b587048-b04b-4f81-aaed-e43793652b0f  
Subcategory: MonitoringAndAlerting

<!--3b587048-b04b-4f81-aaed-e43793652b0f_end-->

<!--01c715f6-426a-47d3-87be-9f26e2ab2d8e_begin-->

#### Validate Virtual Machine reliability with a Site Recovery test failover  
  
Perform a test failover to validate Business Continuity and Disaster Recovery strategy and ensure that the applications are functioning correctly in the target region without impacting production environment.  
  
**Potential benefits**: Ensure business continuity. Verify disaster recovery plan.  

**Impact:** High
  
For more information, see [Tutorial to run an Azure VM disaster recovery drill with Azure Site Recovery - Azure Site Recovery](https://aka.ms/TestFailoverA2A)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 01c715f6-426a-47d3-87be-9f26e2ab2d8e  
Subcategory: undefined

<!--01c715f6-426a-47d3-87be-9f26e2ab2d8e_end-->


<!--4175946b-cd53-4a37-9e9a-0f8a418ef6ac_begin-->

#### Configure and deploy Azure Virtual Machine Scale Sets in a more resilient and balanced configuration  
  
Use Virtual Machine Scale Sets to deploy VMs across availability zones, fault domains, and have a balanced distribution. Balanced distribution provides a protection measure for the applications and data against the rare event of datacenter failure.  
  
**Potential benefits**: Increased application uptime.  

**Impact:** High
  
For more information, see [Azure Virtual Machine Scale Sets overview - Azure Virtual Machine Scale Sets](https://aka.ms/learnmore_compute_vmss)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 4175946b-cd53-4a37-9e9a-0f8a418ef6ac  
Subcategory: HighAvailability

<!--4175946b-cd53-4a37-9e9a-0f8a418ef6ac_end-->

<!--00e4ac6c-afa3-4578-a021-5f15e18850a2_begin-->

#### Align location of resource and resource group  
  
Move virtual machines to the same region as the related resource group. This way, Azure Resource Manager stores metadata related to all resources within the group in one region. By co-locating, you reduce the chance of being affected by region unavailability.  
  
**Potential benefits**: Reduce the impact of regional outages  

**Impact:** Medium
  
For more information, see [What is Azure Resource Manager? - Azure Resource Manager](/azure/azure-resource-manager/management/overview#which-location-should-i-use-for-my-resource-group)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 00e4ac6c-afa3-4578-a021-5f15e18850a2  
Subcategory: HighAvailability

<!--00e4ac6c-afa3-4578-a021-5f15e18850a2_end-->

<!--42d6dc9f-3e08-4a56-959d-0fd86310035f_begin-->

#### Shared disks should only be enabled in clustered servers  
  
Azure shared disks let you attach a disk to multiple VMs at once for deploying or migrating clustered applications, suitable only when a disk is shared among VM cluster members.  
  
**Potential benefits**: Enhances clustered server availability  

**Impact:** Medium
  
For more information, see [Share an Azure managed disk across VMs - Azure Virtual Machines](/azure/virtual-machines/disks-shared)  

ResourceType: microsoft.compute/disks  
Recommendation ID: 42d6dc9f-3e08-4a56-959d-0fd86310035f  
Subcategory: Other

<!--42d6dc9f-3e08-4a56-959d-0fd86310035f_end-->

<!--89496618-9e41-49e3-9db1-d08d61d9e820_begin-->

#### Standard_NC24rs_v3 virtual machine (VM) size in NCv3-series is being retired.  
  
To avoid any disruption to your service, we recommend that you change the VM sizing for your workloads from the current Standard_NC24rs_v3 to the newer VM series in the same NC product line.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=standardnc24rsv3-virtual-machines-will-be-retired-on-march-31st-2025)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 89496618-9e41-49e3-9db1-d08d61d9e820  
Subcategory: undefined

<!--89496618-9e41-49e3-9db1-d08d61d9e820_end-->

<!--71c69a25-0953-41d6-bf3a-1db323cd70b0_begin-->

#### Migrate to zonal aware deployment model  
  
Migrate to zonal aware deployment model such as Virtual Machine Scale Sets, Azure Kubernetes Service (AKS), or App Service for zone redundant benefit.  
  
**Potential benefits**: Zone failover reduces service disruption  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.compute/cloudservices  
Recommendation ID: 71c69a25-0953-41d6-bf3a-1db323cd70b0  
Subcategory: undefined

<!--71c69a25-0953-41d6-bf3a-1db323cd70b0_end-->

<!--61bd0aa3-f2b0-485f-8e5e-95d02ac3483a_begin-->

#### Spread dedicated hosts across zones for isolation of hardware failures  
  
Create host groups with hosts distributed across multiple zones. Assign virtual machine instances to hosts in different zones for isolation of faults.  
  
**Potential benefits**: Host isolation across zones for durability  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.compute/hostgroups  
Recommendation ID: 61bd0aa3-f2b0-485f-8e5e-95d02ac3483a  
Subcategory: undefined

<!--61bd0aa3-f2b0-485f-8e5e-95d02ac3483a_end-->

<!--3742247e-ea02-4202-bfef-a8a6be51fa4c_begin-->

#### Use zone-scoped Proximity Placement Groups and duplicate across zones  
  
Use zone-scoped proximity placement groups and deploy dependent resources in the same zone for low latency. Ensure multiple proximity placement groups exist across zones for redundancy.  
  
**Potential benefits**: Low latency plus zone-level fault isolation  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.compute/proximityplacementgroups  
Recommendation ID: 3742247e-ea02-4202-bfef-a8a6be51fa4c  
Subcategory: undefined

<!--3742247e-ea02-4202-bfef-a8a6be51fa4c_end-->

<!--13cea0f1-c3f7-4c66-8b3b-9928a0f07cea_begin-->

#### Review and migrate virtual machine workloads  
  
Azure Virtual Machine (VM) series F, Fs, Fsv2, Lsv2, G, Gs, Av2, and B are retiring. The VM series are no longer available for use or purchase. Applications and workloads currently operating on VM types must be migrated to newer VM series.  
  
**Potential benefits**: Avoid service disruptions by proactively migrating workloads  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500682)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 13cea0f1-c3f7-4c66-8b3b-9928a0f07cea  
Subcategory: undefined

<!--13cea0f1-c3f7-4c66-8b3b-9928a0f07cea_end-->

<!--0e68ab45-c2c8-4d1f-9873-908dc5828252_begin-->

#### Resize or migrate NVv3-series virtual machines  
  
To avoid service disruptions, migrate workloads to the Azure NVadsA10_v5-series VMs. Azure NVadsA10_v5-series VMs include increased GPU memory bandwidth per GPU, Small AI workloads and GPU accelerated graphics applications, virtual desktops, and visualizations.  
  
**Potential benefits**: Avoid service disruptions and loss of functionality  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500573)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 0e68ab45-c2c8-4d1f-9873-908dc5828252  
Subcategory: undefined

<!--0e68ab45-c2c8-4d1f-9873-908dc5828252_end-->

<!--cfeba225-ca14-48fe-83ba-50d24f60f84e_begin-->

#### Resize or migrate NVv4-series virtual machines  
  
To avoid service disruptions, migrate workloads to Azure NVads_V710_v5-series virtual machines. NVads_V710_v5-series virtual machines provide greater GPU memory bandwidth per GPU for small AI workloads and GPU accelerated graphics applications, virtual desktops, and visualizations.  
  
**Potential benefits**: Avoid service disruptions and loss of functionality  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500578)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: cfeba225-ca14-48fe-83ba-50d24f60f84e  
Subcategory: undefined

<!--cfeba225-ca14-48fe-83ba-50d24f60f84e_end-->

<!--da4fe6f8-35f4-4ea0-8704-1732ee88f695_begin-->

#### Contoso recommendation - R3  
  
Test recommendation for Contoso  
  
**Potential benefits**: Test potential benefits  

**Impact:** Medium
  
For more information, see [nohello](https://aka.ms/nohello)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: da4fe6f8-35f4-4ea0-8704-1732ee88f695  
Subcategory: undefined

<!--da4fe6f8-35f4-4ea0-8704-1732ee88f695_end-->

<!--d7d26cea-dca8-4033-9e7f-d8e8a7a08cf1_begin-->

#### Migrate to encryption at host  
  
Azure Disk Encryption is retiring. Migrate to encryption at host before the retirement date to ensure continued security, functionality, and performance.  
  
**Potential benefits**: Ensure continued security, functionality, and performance  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=493779)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: d7d26cea-dca8-4033-9e7f-d8e8a7a08cf1  
Subcategory: undefined

<!--d7d26cea-dca8-4033-9e7f-d8e8a7a08cf1_end-->

<!--779dbd8a-6102-47d0-b36c-75eb070b86d6_begin-->

#### Migrate D, Ds, Dv2, Dsv2, and Ls series VM instances to latest series VMs  
  
Migrate D, Ds, Dv2, Dsv2, and Ls series VM instances to newer VM generation instances. D, Ds, Dv2, Dsv2, and Ls series VMs in Azure Virtual Machines are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485569)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 779dbd8a-6102-47d0-b36c-75eb070b86d6  
Subcategory: undefined

<!--779dbd8a-6102-47d0-b36c-75eb070b86d6_end-->



<!--81076cd9-e656-4b1a-862b-63f2f40caa87_begin-->

#### Migrate to the newer VM series in the same NC product line  
  
Standard_NC24rs_v3 virtual machine size in NCv3-series virtual machines is retiring. Upgrade to the newer VM series in the same NC product line.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/standardnc24rsv3-virtual-machines-will-be-retired-on-march-31st-2025/)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 81076cd9-e656-4b1a-862b-63f2f40caa87  
Subcategory: undefined

<!--81076cd9-e656-4b1a-862b-63f2f40caa87_end-->

<!--98680ff0-2723-4c8b-9af4-54ce8a3a82d1_begin-->

#### Migrate to Windows Server 2022  
  
Kubernetes workloads will no longer be supported with Windows Server 2019 when Kubernetes version 1.32 reaches End of Life (EOL).  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/aks-will-stop-support-for-windows-server-2019-on-march-1-2026/)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 98680ff0-2723-4c8b-9af4-54ce8a3a82d1  
Subcategory: undefined

<!--98680ff0-2723-4c8b-9af4-54ce8a3a82d1_end-->

<!--5e2403d5-c39a-4701-a4d5-2181b0d3e426_begin-->

#### Desired State Configuration Extension for Azure Virtual Machines is retiring  
  
Migrate Desired State Configuration Extension for Azure Virtual Machines to Azure Machine Configuration in Azure Resource Manager. Desired State Configuration Extension for Azure Virtual Machines is retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485828)  

ResourceType: microsoft.compute/virtualmachines/extensions  
Recommendation ID: 5e2403d5-c39a-4701-a4d5-2181b0d3e426  
Subcategory: undefined

<!--5e2403d5-c39a-4701-a4d5-2181b0d3e426_end-->

<!--articleBody-->
