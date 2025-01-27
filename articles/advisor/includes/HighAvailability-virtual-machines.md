---
ms.service: azure
ms.topic: include
ms.date: 01/27/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Virtual Machines
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Virtual Machines  
  
<!--02cfb5ef-a0c1-4633-9854-031fbda09946_begin-->

#### Improve data reliability by using Managed Disks  
  
Virtual machines in an Availability Set with disks that share either storage accounts or storage scale units aren't resilient to single storage scale unit failures during outages. Migrate to Azure Managed Disks to ensure that the disks of different VMs in the Availability Set are sufficiently isolated to avoid a single point of failure.  
  
**Potential benefits**: Ensure business continuity through data resilience  

**Impact:** High
  
  

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

#### Enable virtual machine replication to protect your applications from regional outage  
  
Virtual machines are resilient to regional outages when replication to another region is enabled. To reduce adverse business impact during an Azure region outage, we recommend enabling replication of all business-critical virtual machines.  
  
**Potential benefits**: Ensure business continuity in case of any Azure region outage  

**Impact:** Medium
  
For more information, see [Set up Azure VM disaster recovery to a secondary region with Azure Site Recovery - Azure Site Recovery ](https://aka.ms/azure-site-recovery-dr-azure-vms)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: ed651749-cd37-4fd5-9897-01b416926745  
Subcategory: DisasterRecovery

<!--ed651749-cd37-4fd5-9897-01b416926745_end-->

<!--bcfeb92b-fe93-4cea-adc6-e747055518e9_begin-->

#### Update your outbound connectivity protocol to Service Tags for Azure Site Recovery  
  
IP address-based allowlisting is a vulnerable way to control outbound connectivity for firewalls, Service Tags are a good  alternative. We highly recommend the use of Service Tags, to allow connectivity to Azure Site Recovery services for the machines.  
  
**Potential benefits**: Ensures better security, stability and resiliency than hard coded IP Addresses  

**Impact:** High
  
For more information, see [About networking in Azure VM disaster recovery with Azure Site Recovery - Azure Site Recovery ](https://aka.ms/azure-site-recovery-using-service-tags)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: bcfeb92b-fe93-4cea-adc6-e747055518e9  
Subcategory: Other

<!--bcfeb92b-fe93-4cea-adc6-e747055518e9_end-->

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
  
For more information, see [Best practices for high availability with Azure VMs and managed disks - Azure Virtual Machines ](https://aka.ms/disks-high-availability)  

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
  
For more information, see [Best practices for high availability with Azure VMs and managed disks - Azure Virtual Machines ](https://aka.ms/disks-high-availability)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: e5e707f2-f41f-4aa6-bccf-3fb9748e5b66  
Subcategory: BusinessContinuity

<!--e5e707f2-f41f-4aa6-bccf-3fb9748e5b66_end-->



<!--3b739bd1-c193-4bb6-a953-1362ee3b03b2_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image version  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. Upgrade to newer version of the image to prevent disruption to your workload.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3b739bd1-c193-4bb6-a953-1362ee3b03b2  
Subcategory: ServiceUpgradeAndRetirement

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
  
For more information, see [Automatic instance repairs with Azure Virtual Machine Scale Sets - Azure Virtual Machine Scale Sets ](https://aka.ms/vmss-automatic-repair)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: b4d988a9-85e6-4179-b69c-549bdd8a55bb  
Subcategory: HighAvailability

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


<!--articleBody-->
