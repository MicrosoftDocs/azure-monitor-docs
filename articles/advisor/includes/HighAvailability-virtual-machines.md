---
ms.service: azure
ms.topic: include
ms.date: 06/23/2026
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

#### Ensure Azure Disks are in the same zone as your VM for higher resiliency and availability  
  
Azure VMs can be regional or zonal. For higher resilience, use a zonal VM with the disk in the same zone to be isolated from zonal failures without disruptions to applications. For higher even resiliency and availability, migrate disks from LRS to ZRS.  
  
**Potential benefits**: Improved availability and reliability.  

**Impact:** High
  
For more information, see [Best practices for high availability with Azure VMs and managed disks - Azure Virtual Machines](https://aka.ms/learnmore_compute_disks)  

ResourceType: microsoft.compute/disks  
Recommendation ID: d4102c0f-ebe3-4b22-8fe0-e488866a87af  

<!--d4102c0f-ebe3-4b22-8fe0-e488866a87af_end-->

<!--ed651749-cd37-4fd5-9897-01b416926745_begin-->

#### Enable virtual machine replication to protect applications from regional outage  
  
Virtual machines are resilient to regional outages when replication to another region is enabled. To reduce adverse business effect during an Azure region outage, the platform recommends enabling replication of all business-critical virtual machines.  
  
**Potential benefits**: Ensure business continuity during an Azure region outage.  

**Impact:** High
  
For more information, see [Set up Azure VM disaster recovery to a secondary region with Azure Site Recovery - Azure Site Recovery](https://aka.ms/azure-site-recovery-dr-azure-vms)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: ed651749-cd37-4fd5-9897-01b416926745  

<!--ed651749-cd37-4fd5-9897-01b416926745_end-->

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
  
**Potential benefits**: Zonal VMs protect your apps from zonal outage in other zones  

**Impact:** High
  
For more information, see [Move Azure single-instance virtual machines from regional to zonal availability - Azure Virtual Machines](/azure/virtual-machines/move-virtual-machines-regional-zonal-portal)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 066a047a-9ace-45f4-ac50-6325840a6b00  

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

#### Upgrade your VMSS to alternative image version  
  
VMSS in your subscription are running on images that are scheduled for deprecation. When the image is deprecated, your VMSS workloads stop scaling out. Upgrade to a newer version of the image to prevent disruption to your workload.
  
**Potential benefits**: Minimize any potential disruptions to your VMSS workloads.

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3b739bd1-c193-4bb6-a953-1362ee3b03b2  

<!--3b739bd1-c193-4bb6-a953-1362ee3b03b2_end-->

<!--3d18d7cd-bdec-4c68-9160-16a677d0f86a_begin-->

#### Upgrade your VMSS to alternative image offer  
  
VMSS in your subscription are running on images that are scheduled for deprecation. When the image is deprecated, your VMSS workloads stop scaling out. To prevent disruption to your workload, upgrade to a newer offer of the image.
  
**Potential benefits**: Minimize any potential disruptions to your VMSS workloads.

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3d18d7cd-bdec-4c68-9160-16a677d0f86a  
Subcategory: ServiceUpgradeAndRetirement

<!--3d18d7cd-bdec-4c68-9160-16a677d0f86a_end-->

<!--44abb62e-7789-4f2f-8001-fa9624cb3eb3_begin-->

#### Upgrade your VMSS to alternative image SKU  
  
VMSS in your subscription are running on images that are scheduled for deprecation. When the image is deprecated, your VMSS workloads stop scaling out. To prevent disruption to your workload, upgrade to a newer SKU of the image.
  
**Potential benefits**: Minimize any potential disruptions to your VMSS workloads.

**Impact:** High
  
For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 44abb62e-7789-4f2f-8001-fa9624cb3eb3  
Subcategory: ServiceUpgradeAndRetirement

<!--44abb62e-7789-4f2f-8001-fa9624cb3eb3_end-->

<!--b4d988a9-85e6-4179-b69c-549bdd8a55bb_begin-->

#### Enable Automatic Repair Policy on Azure Virtual Machine Scale Sets  
  
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
  
HDD operating system (OS) disks are being retired in September 2028. Upgrade the OS disk from Standard HDD to Standard SSD for increased uptime of single-instance virtual machine and improved input/output operations and throughput.  
  
**Potential benefits**: Boost single-instance VM uptime from 95% to 99.5%.  

**Impact:** Medium
  
For more information, see [Migrate Standard HDD OS disks by September 08, 2028 - Azure Virtual Machines](https://aka.ms/standard-hdd-os-disk-retirement)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 3c03549b-9c0a-4c13-bed4-def3c7e34ddd  

<!--3c03549b-9c0a-4c13-bed4-def3c7e34ddd_end-->

<!--7f71b153-c0b7-4e99-a23e-db8179183ec9_begin-->

#### Migrate workload on A-series or B-series virtual machine (VM) to D-series or better VM  
  
Migrate production workload from A-series or B-series virtual machine (VM) to D-series or better VM. A-series and B-series VMs are designed for entry-level workloads.  
  
**Potential benefits**: Full CPU performance for heavy workload in production  

**Impact:** High
  
For more information, see [Virtual machine sizes overview - Azure Virtual Machines](https://aka.ms/MigrateToHighPerfVMs)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 7f71b153-c0b7-4e99-a23e-db8179183ec9  

<!--7f71b153-c0b7-4e99-a23e-db8179183ec9_end-->

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

#### Migrate virtual machine using availability sets to Virtual Machine Scale Sets Flex  
  
Migrate workloads from virtual machine (VM) to Virtual Machine Scale Sets Flex for deployment across zones or within the same zone across different fault domains.  
  
**Potential benefits**: Availability across zones or across different fault domains.  

**Impact:** Medium
  
For more information, see [Migrate deployments and resources to Virtual Machine Scale Sets in Flexible orchestration - Azure Virtual Machine Scale Sets](https://aka.ms/MigrateToVMSSFlex)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 39fb2718-a2ae-4662-a8c9-cd8df23f01eb  
Subcategory: HighAvailability

<!--39fb2718-a2ae-4662-a8c9-cd8df23f01eb_end-->

<!--3b587048-b04b-4f81-aaed-e43793652b0f_begin-->

#### Enable application health monitoring for Virtual Machine Scale Sets (VMSS)  
  
Configure VM scale set application health monitoring using the Application Health extension or load balancer probes so Azure can detect unhealthy instances, trigger repairs, and enable safer upgrades to improve application resiliency.  
  
**Potential benefits**: App-health detection during upgrade and auto-repair  

**Impact:** Medium
  
For more information, see [Use Application Health extension with Azure Virtual Machine Scale Sets - Azure Virtual Machine Scale Sets](https://aka.ms/vmss-app-health-monitoring)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 3b587048-b04b-4f81-aaed-e43793652b0f  

<!--3b587048-b04b-4f81-aaed-e43793652b0f_end-->

<!--01c715f6-426a-47d3-87be-9f26e2ab2d8e_begin-->

#### Validate Virtual Machine reliability with a Site Recovery test failover  
  
Perform a test failover to validate Business Continuity and Disaster Recovery strategy and ensure that the applications are functioning correctly in the target region without impacting production environment.  
  
**Potential benefits**: Ensure business continuity. Verify disaster recovery plan.  

**Impact:** High
  
For more information, see [Tutorial to run an Azure VM disaster recovery drill with Azure Site Recovery - Azure Site Recovery](https://aka.ms/TestFailoverA2A)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 01c715f6-426a-47d3-87be-9f26e2ab2d8e  

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

<!--71c69a25-0953-41d6-bf3a-1db323cd70b0_begin-->

#### Migrate to zonal aware deployment model  
  
Migrate to zonal aware deployment model such as Virtual Machine Scale Sets, Azure Kubernetes Service (AKS), or App Service for zone redundant benefit.  
  
**Potential benefits**: Zone failover reduces service disruption  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.compute/cloudservices  
Recommendation ID: 71c69a25-0953-41d6-bf3a-1db323cd70b0  

<!--71c69a25-0953-41d6-bf3a-1db323cd70b0_end-->

<!--61bd0aa3-f2b0-485f-8e5e-95d02ac3483a_begin-->

#### Spread dedicated hosts across zones for isolation of hardware failures  
  
Create host groups with hosts distributed across multiple zones. Assign virtual machine instances to hosts in different zones for isolation of faults.  
  
**Potential benefits**: Host isolation across zones for durability  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.compute/hostgroups  
Recommendation ID: 61bd0aa3-f2b0-485f-8e5e-95d02ac3483a  

<!--61bd0aa3-f2b0-485f-8e5e-95d02ac3483a_end-->

<!--3742247e-ea02-4202-bfef-a8a6be51fa4c_begin-->

#### Use zone-scoped Proximity Placement Groups and duplicate across zones  
  
Use zone-scoped proximity placement groups and deploy dependent resources in the same zone for low latency. Ensure multiple proximity placement groups exist across zones for redundancy.  
  
**Potential benefits**: Low latency plus zone-level fault isolation  

**Impact:** High
  
For more information, see [Enable Zone Resiliency for Azure Workloads](/azure/reliability/availability-zones-enable-zone-resiliency)  

ResourceType: microsoft.compute/proximityplacementgroups  
Recommendation ID: 3742247e-ea02-4202-bfef-a8a6be51fa4c  

<!--3742247e-ea02-4202-bfef-a8a6be51fa4c_end-->

<!--13cea0f1-c3f7-4c66-8b3b-9928a0f07cea_begin-->

#### Review and migrate virtual machine workloads  
  
Azure Virtual Machine (VM) series F, Fs, Fsv2, Lsv2, G, Gs, Av2, and B are retiring. The VM series are no longer available for use or purchase. Applications and workloads currently operating on VM types must be migrated to newer VM series.  
  
**Potential benefits**: Avoid service disruptions by proactively migrating workloads  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500682)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 13cea0f1-c3f7-4c66-8b3b-9928a0f07cea  

<!--13cea0f1-c3f7-4c66-8b3b-9928a0f07cea_end-->

<!--0e68ab45-c2c8-4d1f-9873-908dc5828252_begin-->

#### Resize or migrate NVv3-series virtual machines  
  
To avoid service disruptions, migrate workloads to the Azure NVadsA10_v5-series VMs. Azure NVadsA10_v5-series VMs include increased GPU memory bandwidth per GPU, Small AI workloads and GPU accelerated graphics applications, virtual desktops, and visualizations.  
  
**Potential benefits**: Avoid service disruptions and loss of functionality  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500573)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 0e68ab45-c2c8-4d1f-9873-908dc5828252  

<!--0e68ab45-c2c8-4d1f-9873-908dc5828252_end-->

<!--cfeba225-ca14-48fe-83ba-50d24f60f84e_begin-->

#### Resize or migrate NVv4-series virtual machines  
  
To avoid service disruptions, migrate workloads to Azure NVads_V710_v5-series virtual machines. NVads_V710_v5-series virtual machines provide greater GPU memory bandwidth per GPU for small AI workloads and GPU accelerated graphics applications, virtual desktops, and visualizations.  
  
**Potential benefits**: Avoid service disruptions and loss of functionality  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500578)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: cfeba225-ca14-48fe-83ba-50d24f60f84e  

<!--cfeba225-ca14-48fe-83ba-50d24f60f84e_end-->

<!--d7d26cea-dca8-4033-9e7f-d8e8a7a08cf1_begin-->

#### Migrate to encryption at host  
  
Azure Disk Encryption is retiring. Migrate to encryption at host before the retirement date to ensure continued security, functionality, and performance.  
  
**Potential benefits**: Ensure continued security, functionality, and performance  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=493779)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: d7d26cea-dca8-4033-9e7f-d8e8a7a08cf1  

<!--d7d26cea-dca8-4033-9e7f-d8e8a7a08cf1_end-->

<!--779dbd8a-6102-47d0-b36c-75eb070b86d6_begin-->

#### Migrate D, Ds, Dv2, Dsv2, and Ls series VM instances to latest series VMs  
  
Migrate D, Ds, Dv2, Dsv2, and Ls series VM instances to newer VM generation instances. D, Ds, Dv2, Dsv2, and Ls series VMs in Azure Virtual Machines are retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485569)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 779dbd8a-6102-47d0-b36c-75eb070b86d6  

<!--779dbd8a-6102-47d0-b36c-75eb070b86d6_end-->

<!--81076cd9-e656-4b1a-862b-63f2f40caa87_begin-->

#### Migrate to the newer VM series in the same NC product line  
  
Standard_NC24rs_v3 virtual machine size in NCv3-series virtual machines is retiring. Upgrade to the newer VM series in the same NC product line.  
  
**Potential benefits**: Avoid service disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/standardnc24rsv3-virtual-machines-will-be-retired-on-march-31st-2025/)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 81076cd9-e656-4b1a-862b-63f2f40caa87  

<!--81076cd9-e656-4b1a-862b-63f2f40caa87_end-->

<!--98680ff0-2723-4c8b-9af4-54ce8a3a82d1_begin-->

#### Migrate to Windows Server 2022  
  
Kubernetes workloads will no longer be supported with Windows Server 2019 when Kubernetes version 1.32 reaches End of Life (EOL).  
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/aks-will-stop-support-for-windows-server-2019-on-march-1-2026/)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 98680ff0-2723-4c8b-9af4-54ce8a3a82d1  

<!--98680ff0-2723-4c8b-9af4-54ce8a3a82d1_end-->

<!--6885dc91-c4d1-4695-be6f-f64be575769f_begin-->

#### Migrate Standard HDD OS Disks to SSD  
  
To improve customer experience and align with current disk usage patterns, Standard HDD OS Disks are retiring. Customers should stop using Standard HDD OS Disks for new virtual machines and migrate existing OS disk workloads to Standard SSD or Premium SSD.  
  
**Potential benefits**: Avoid potential service disruption after retirement  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=500157)  

ResourceType: microsoft.compute/disks  
Recommendation ID: 6885dc91-c4d1-4695-be6f-f64be575769f  

<!--6885dc91-c4d1-4695-be6f-f64be575769f_end-->

<!--f49d7356-7251-4e15-a577-a3398527f3fd_begin-->

#### Migrate from Dependency Agent and VM Insights Map  
  
Dependency Agent and VM Insights Map is retiring. We recommend considering a replacement solution from the Azure Marketplace to continue collecting data about processes running on virtual machines and external process dependencies.  
  
**Potential benefits**: Avoid Service Disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=491629)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: f49d7356-7251-4e15-a577-a3398527f3fd  

<!--f49d7356-7251-4e15-a577-a3398527f3fd_end-->

<!--69e994b4-9b84-4581-930b-edcf9cc81582_begin-->

#### Cloud Services (extended support) is being retired  
  
Migrating to Virtual Machine Scale Sets with Flexible orchestration enhances the scalability, flexibility, and reliability of the Azure deployments. After the retirement date, workloads running Cloud Services (extended support) are deleted and associated application data is lost.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=486344)  

ResourceType: microsoft.compute/cloudservices  
Recommendation ID: 69e994b4-9b84-4581-930b-edcf9cc81582  
Subcategory: ServiceUpgradeAndRetirement

<!--69e994b4-9b84-4581-930b-edcf9cc81582_end-->

<!--851ac46b-6ac2-4074-9ba2-447bb8754cb6_begin-->

#### Migrate HBv2 to latest HPC Virtual machine families  
  
Microsoft is retiring following HBv2-series virtual machine (VMs) sizes: Standard_HB120rs_v2, Standard_HB120-96rs_v2, Standard_HB120-64rs_v2, Standard_HB120-32rs_v2, and Standard_HB120-16rs_v2. To ensure continuity and improved performance, transition to current generation Azure HPC VM families.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=548525)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 851ac46b-6ac2-4074-9ba2-447bb8754cb6  

<!--851ac46b-6ac2-4074-9ba2-447bb8754cb6_end-->

<!--c6199b8a-db76-4a4f-b45b-ef5e9d2be09c_begin-->

#### Migrate HCv1 to latest HPC Virtual machine families  
  
HC-series virtual machine sizes are retiring. To ensure continuity and improved performance, transition to one of the current‑generation Azure HPC VM families, Azure HBv5‑series or Azure HX‑series.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: c6199b8a-db76-4a4f-b45b-ef5e9d2be09c  

<!--c6199b8a-db76-4a4f-b45b-ef5e9d2be09c_end-->

<!--ac992ddf-2bbf-4049-b142-a30d6236291e_begin-->

#### NP-series virtual machines are retiring  
  
NP-series virtual machines are retiring. To ensure continuity and optimal performance, transition to latest GPU VM families. e.g. 
NDv2 VMs, NDv2 VMs, NCasT4_v3.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=548497)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: ac992ddf-2bbf-4049-b142-a30d6236291e  

<!--ac992ddf-2bbf-4049-b142-a30d6236291e_end-->

<!--b131ddbe-5439-4c87-95bc-6999b0648252_begin-->

#### Service Fabric support for Windows Server 2022 is ending  
  
Service Fabric support for Windows Server 2022 is retiring. To remain supported, upgrade all Service Fabric clusters to Windows Server 2025.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=558247)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: b131ddbe-5439-4c87-95bc-6999b0648252  

<!--b131ddbe-5439-4c87-95bc-6999b0648252_end-->

<!--2ae93784-84f0-4f3a-8a9c-4ee4f8549cd4_begin-->

#### Service Fabric support for Windows Server 2019 is retiring  
  
Service Fabric support for Windows Server 2019 is retiring. To remain supported, upgrade all Service Fabric clusters to Windows Server 2025.  
  
**Potential benefits**: Avoid service disruption  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=558246)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 2ae93784-84f0-4f3a-8a9c-4ee4f8549cd4  

<!--2ae93784-84f0-4f3a-8a9c-4ee4f8549cd4_end-->

<!--40df4452-9b9f-47d7-921c-638e6cac6333_begin-->

#### Add and enable the LegacyVMNVA tag for NVA virtual machines  
  
The workload uses a VM series that is eligible to be deployed on MANA-capable hardware. If the workload isn't MANA ready, apply and enable the 'LegacyVMNVA' tag on affected VMs to temporarily avoid deployment on MANA-capable hardware until 5/31/2027. Migrate to a supported OS or VM series by then.  
  
**Potential benefits**: Reduce network performance risk due to MANA incompatibility.  

**Impact:** High
  
For more information, see [MANA support for Network Virtual Appliances (NVAs) - Microsoft Azure Network Adapter](/azure/virtual-network/accelerated-networking-mana-network-virtual-appliance-opt-out)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 40df4452-9b9f-47d7-921c-638e6cac6333  

<!--40df4452-9b9f-47d7-921c-638e6cac6333_end-->

<!--53f3eb12-bd32-4e63-8241-234ae2b58615_begin-->

#### Enable LegacyVMNVA tag for NVA virtual machines  
  
The workload uses a VM series that is eligible to be deployed on MANA-capable hardware. The workload has the LegacyVMNVA tag but the tag needs to be enabled. Enabling the tag will temporarily avoid deployment on MANA-capable hardware until 5/31/2027. Migrate to a supported OS or VM series by then.  
  
**Potential benefits**: Reduce network performance risk due to MANA incompatibility.  

**Impact:** High
  
For more information, see [MANA support for Network Virtual Appliances (NVAs) - Microsoft Azure Network Adapter](/azure/virtual-network/accelerated-networking-mana-network-virtual-appliance-opt-out#temporary-mana-exception-with-legacyvmnva)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 53f3eb12-bd32-4e63-8241-234ae2b58615  

<!--53f3eb12-bd32-4e63-8241-234ae2b58615_end-->

<!--2a126a9d-b0ec-4352-bb39-863cb8fafdcf_begin-->

#### Add and enable LegacyVMNVA tag on VM Scale Set with NVAs  
  
The VMs in VMSS use a VM series that is eligible to be deployed on MANA-capable hardware. If the VMs are not MANA ready, apply and enable the 'LegacyVMNVA' tag on the VMSS to temporarily avoid deployment on MANA-capable hardware until 5/31/2027. Migrate to a MANA supported OS or VM series by then.  
  
**Potential benefits**: Reduce network performance risk due to MANA incompatibility.  

**Impact:** High
  
For more information, see [MANA support for Network Virtual Appliances (NVAs) - Microsoft Azure Network Adapter](/azure/virtual-network/accelerated-networking-mana-network-virtual-appliance-opt-out#compatibility)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 2a126a9d-b0ec-4352-bb39-863cb8fafdcf  

<!--2a126a9d-b0ec-4352-bb39-863cb8fafdcf_end-->

<!--b70fccd9-37c8-435a-8868-7b5b2ec759f7_begin-->

#### Enable LegacyVMNVA tag for VM Scale Set Uniform  
  
The VMs in VMSS use a VM series that is eligible to be deployed on MANA-capable hardware. If the VMs are not MANA ready, enable the 'LegacyVMNVA' tag on the VMSS to temporarily avoid deployment on MANA-capable hardware until 5/31/2027. Migrate to a MANA supported OS or VM series by then.  
  
**Potential benefits**: Reduce network performance risk due to MANA incompatibility.  

**Impact:** High
  
For more information, see [MANA support for Network Virtual Appliances (NVAs) - Microsoft Azure Network Adapter](/azure/virtual-network/accelerated-networking-mana-network-virtual-appliance-opt-out#compatibility)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: b70fccd9-37c8-435a-8868-7b5b2ec759f7  

<!--b70fccd9-37c8-435a-8868-7b5b2ec759f7_end-->

<!--dcca165d-ffec-43e4-a21d-bc41b7812e09_begin-->

#### Enable LegacyVMNVA tag for NVAs in VM Scale Set Uniform  
  
The VM uses a VM series that is eligible to be deployed on MANA-capable hardware. The VMSS has the LegacyVMNVA tag but the tag needs to be enabled for the VM. Enabling the tag will temporarily avoid deployment on MANA-capable hardware until 5/31/2027. Migrate to a supported OS or VM series by then.  
  
**Potential benefits**: Reduce network performance risk due to MANA incompatibility.  

**Impact:** High
  
For more information, see [MANA support for Network Virtual Appliances (NVAs) - Microsoft Azure Network Adapter](/azure/virtual-network/accelerated-networking-mana-network-virtual-appliance-opt-out#compatibility)  

ResourceType: microsoft.compute/virtualmachinescalesets/virtualmachines  
Recommendation ID: dcca165d-ffec-43e4-a21d-bc41b7812e09  

<!--dcca165d-ffec-43e4-a21d-bc41b7812e09_end-->

<!--5d4bb790-d34a-4b45-81d7-4dd060e59853_begin-->

#### Migrate from Dependency Agent and VM Insights Map  
  
Dependency Agent and VM Insights Map is retiring. We recommend considering a replacement solution from the Azure Marketplace to continue collecting data about processes running on virtual machines and external process dependencies.  
  
**Potential benefits**: Avoid Service Disruption  

**Impact:** Medium
  
For more information, see [VM Insights Map and Dependency Agent retirement guidance - Azure Monitor](https://aka.ms/DependencyAgentRetirement)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 5d4bb790-d34a-4b45-81d7-4dd060e59853  

<!--5d4bb790-d34a-4b45-81d7-4dd060e59853_end-->

<!--8db086d4-6f1e-4459-86c1-7e83e4c436a9_begin-->

#### Azure Diagnostic Extensions are retiring  
  
Microsoft is retiring Azure Diagnostic Extensions for Windows and Linux (WAD/LAD) and will no longer support them. This retirement also includes the collection of diagnostic extension data from Azure Storage accounts imported into Log Analytics workspaces.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/Azure-Diagnostics-Extensions-retiring-march-31-2026)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 8db086d4-6f1e-4459-86c1-7e83e4c436a9  

<!--8db086d4-6f1e-4459-86c1-7e83e4c436a9_end-->

<!--ad6df2a0-827c-493f-8307-d9d553bb5531_begin-->

#### Azure Virtual Machines DCsv2-series are retiring  
  
You can't use Virtual Machines DCsv2-series anymore. Review changes to the VMs billing after changing SKUs.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=496104)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: ad6df2a0-827c-493f-8307-d9d553bb5531  

<!--ad6df2a0-827c-493f-8307-d9d553bb5531_end-->

<!--2d1f43c1-9d8d-46be-873c-6ddda75636ee_begin-->

#### Azure unmanaged disks are being retired  
  
Migrate your data from Azure unmanaged disk storage to managed disks.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** High
  
For more information, see [Unmanaged disks have been retired - Azure Virtual Machines](/azure/virtual-machines/unmanaged-disks-deprecation).  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 2d1f43c1-9d8d-46be-873c-6ddda75636ee  

<!--2d1f43c1-9d8d-46be-873c-6ddda75636ee_end-->

<!--990f7204-592d-49e4-8ddf-251a056dada0_begin-->

#### Configure your node pool worker virtual machines across availability zones to improve availability.  
  
Your Azure Red Hat OpenShift node pool runs worker virtual machines in a single availability zone. Create node pools across availability zones to improve availability for your applications.  
  
**Potential benefits**: Improve application availability across availability zones.  

**Impact:** High
  
For more information, see [What are Azure Availability Zones?](/azure/reliability/availability-zones-overview)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 990f7204-592d-49e4-8ddf-251a056dada0  

<!--990f7204-592d-49e4-8ddf-251a056dada0_end-->

<!--e3a21ba5-e34b-4614-a718-131670d51e3f_begin-->

#### Default outbound access connectivity for virtual machines in Azure is retiring.  
  
Default outbound access connectivity for virtual machines in Azure is retiring.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/default-outbound-access-for-vms-in-azure-will-be-retired-transition-to-a-new-method-of-internet-access/)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: e3a21ba5-e34b-4614-a718-131670d51e3f  

<!--e3a21ba5-e34b-4614-a718-131670d51e3f_end-->

<!--beae2503-c504-47b1-8ca4-d0e708559af9_begin-->

#### Desired State Configuration Extension for Azure Virtual Machines is retiring
  
After the retirement date, Azure won't support the Desired State Configuration Extension for Azure Virtual Machines.
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=485828)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: beae2503-c504-47b1-8ca4-d0e708559af9  

<!--beae2503-c504-47b1-8ca4-d0e708559af9_end-->

<!--8e73c079-f841-49c6-9fca-cd552930efb8_begin-->

#### Migrate ccV5 to general purpose virtual machines  
  
The cc_v5 confidential VM series is retiring, and DCas_cc_v5, DCads_cc_v5, ECas_cc_v5, and ECads_cc_v5 are no longer available for use or purchase. Migrate your workloads to general-purpose VM series.
  
**Potential benefits**: Avoid service disruption  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/?id=568661)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 8e73c079-f841-49c6-9fca-cd552930efb8  

<!--8e73c079-f841-49c6-9fca-cd552930efb8_end-->

<!--475ee3a1-e973-4a80-9f41-7f5fafc48e93_begin-->

#### NCv3 VM Family Support - Azure Batch is being retired  
  
Microsoft Azure is retiring support for NCv3-series VMs, including Standard_NC24rs_v3, Standard_NC6s_v3, Standard_NC12s_v3, and Standard_NC24s_v3. Azure Batch follows Microsoft Azure support retirement dates for NCv3-series VM support in Batch pools.  
  
**Potential benefits**: Avoid potential disruptions  

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates/v2/NCv3-series-VM-family-support-in-azure-batch-pools-retirement)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 475ee3a1-e973-4a80-9f41-7f5fafc48e93  

<!--475ee3a1-e973-4a80-9f41-7f5fafc48e93_end-->

<!--e1c591d0-5ccb-4aca-91d7-b41b6924da8c_begin-->

#### Standard_M192idms_v2 is being retired.  
  
Workloads running Standard_M192idms_v2 are deleted and associated application data is lost.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=support-for-standardm192idmsv2-will-be-retired-on-31-march-2027)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: e1c591d0-5ccb-4aca-91d7-b41b6924da8c  

<!--e1c591d0-5ccb-4aca-91d7-b41b6924da8c_end-->

<!--06e322e4-61bd-4399-8074-09eef9272950_begin-->

#### Standard_M192ids_v2 is being retired  
  
Workloads running Standard_M192ids_v2 are deleted and associated application data is lost.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=community-support-for-standardm192idsv2-is-ending-on-31-march-2027)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 06e322e4-61bd-4399-8074-09eef9272950  

<!--06e322e4-61bd-4399-8074-09eef9272950_end-->

<!--321a6b2e-ff3a-4319-95a2-312953015781_begin-->

#### Standard_M192ims_v2 is being retired.  
  
Workloads running Standard_M192ims_v2 are deleted and associated application data is lost.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=community-support-for-standardm192imsv2-is-ending-on-31-march-2027)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 321a6b2e-ff3a-4319-95a2-312953015781  

<!--321a6b2e-ff3a-4319-95a2-312953015781_end-->

<!--046927b3-bbf7-460d-86fc-d2b10f7f5f00_begin-->

#### Standard_M192is_v2 is being retired.  
  
Workloads running Standard_M192is_v2 are deleted and associated application data is lost.  
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** Medium
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=community-support-for-standardm192isv2-is-ending-on-31-march-2027)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 046927b3-bbf7-460d-86fc-d2b10f7f5f00  

<!--046927b3-bbf7-460d-86fc-d2b10f7f5f00_end-->

<!--604fb48f-017f-4239-9a9c-e46d6c48132e_begin-->

#### Test Azure Virtual Machine Scale Sets Resiliency with a Chaos Experiment  
  
Run an S3 Compute Zone Down chaos experiment to validate zonal resiliency of your VMSS Scale Sets. Chaos experiments inject failures and might affect targeted resources. Start with non-production environments and use approved maintenance windows for production workloads.
  
**Potential benefits**: Improve outage readiness and validate zone resilience.

**Impact:** High
  
For more information, see [Scenarios and outage templates for Chaos Studio Workspaces - Azure Chaos Studio](/azure/chaos-studio/chaos-studio-scenarios)  

ResourceType: microsoft.compute/virtualmachinescalesets  
Recommendation ID: 604fb48f-017f-4239-9a9c-e46d6c48132e  

<!--604fb48f-017f-4239-9a9c-e46d6c48132e_end-->

<!--1c5fb9ab-77aa-4298-9caf-2a38f9feecdb_begin-->

#### Virtual machines in NCv3-series are retiring
  
To avoid any disruption to your service, change the VM sizing for your workloads from the current NCv3-series VMs to the newer VM series in the same NC product line.
  
**Potential benefits**: Avoid potential disruptions and use new capabilities.

**Impact:** High
  
For more information, see [Azure updates](https://azure.microsoft.com/updates?id=standardnc6sv3-standardnc12sv3-and-standardnc24sv3-azure-virtual-machines-will-be-retired-on-september-30-2025).  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 1c5fb9ab-77aa-4298-9caf-2a38f9feecdb  

<!--1c5fb9ab-77aa-4298-9caf-2a38f9feecdb_end-->

<!--articleBody-->
