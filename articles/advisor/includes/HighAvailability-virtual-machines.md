---
ms.service: azure-monitor
ms.topic: include
ms.date: 01/13/2025
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

For more information, see [https://aka.ms/aa_avset_manageddisk_learnmore](https://aka.ms/aa_avset_manageddisk_learnmore)  

<!--02cfb5ef-a0c1-4633-9854-031fbda09946_end-->

<!--d4102c0f-ebe3-4b22-8fe0-e488866a87af_begin-->

#### Use Azure Disks with Zone Redundant Storage (ZRS) for higher resiliency and availability  
  
Azure Disks with ZRS provide synchronous replication of data across three Availability Zones in a region, making the disk tolerant to zonal failures without disruptions to applications. For higher resiliency and availability, migrate disks from LRS to ZRS.  
  
**Potential benefits**: By designing your applications to use ZRS Disks, your data is replicated across 3 Availability Zones, making your disk resilient to a zonal outage  

For more information, see [Convert a disk from LRS to ZRS](https://aka.ms/migratedisksfromLRStoZRS)  

<!--d4102c0f-ebe3-4b22-8fe0-e488866a87af_end-->

<!--ed651749-cd37-4fd5-9897-01b416926745_begin-->

#### Enable virtual machine replication to protect your applications from regional outage  
  
Virtual machines are resilient to regional outages when replication to another region is enabled. To reduce adverse business impact during an Azure region outage, we recommend enabling replication of all business-critical virtual machines.  
  
**Potential benefits**: Ensure business continuity in case of any Azure region outage  

For more information, see [Quickstart: Set up disaster recovery to a secondary Azure region for an Azure VM](https://aka.ms/azure-site-recovery-dr-azure-vms)  

<!--ed651749-cd37-4fd5-9897-01b416926745_end-->

<!--bcfeb92b-fe93-4cea-adc6-e747055518e9_begin-->

#### Update your outbound connectivity protocol to Service Tags for Azure Site Recovery  
  
IP address-based allowlisting is a vulnerable way to control outbound connectivity for firewalls, Service Tags are a good  alternative. We highly recommend the use of Service Tags, to allow connectivity to Azure Site Recovery services for the machines.  
  
**Potential benefits**: Ensures better security, stability and resiliency than hard coded IP Addresses  

For more information, see [About networking in Azure virtual machine disaster recovery](https://aka.ms/azure-site-recovery-using-service-tags)  

<!--bcfeb92b-fe93-4cea-adc6-e747055518e9_end-->

<!--58d6648d-32e8-4346-827c-4f288dd8ca24_begin-->

#### Upgrade the standard disks attached to your premium-capable VM to premium disks  
  
Using Standard SSD disks with premium VMs may lead to suboptimal performance and latency issues. We recommend that you consider upgrading the standard disks to premium disks. For any Single Instance Virtual Machine using premium storage for all Operating System Disks and Data Disks, we guarantee Virtual Machine Connectivity of at least 99.9%. When choosing to upgrade, there are two factors to consider. The first factor is that upgrading requires a VM reboot and that takes 3-5 minutes to complete. The second is if the VMs in the list are mission-critical production VMs, evaluate the improved availability against the cost of premium disks.  
  
**Potential benefits**: Improved availability with single VM SLA available only when all disks are premium  

For more information, see [Azure managed disk types](https://aka.ms/aa_storagestandardtopremium_learnmore)  

<!--58d6648d-32e8-4346-827c-4f288dd8ca24_end-->

<!--57ecb3cd-f2b4-4cad-8b3a-232cca527a0b_begin-->

#### Upgrade VM from Premium Unmanaged Disks to Managed Disks at no additional cost  
  
Azure Managed Disks provide higher resiliency, simplified service management, higher scale target and more choices among several disk types. Your VM is using premium unmanaged disks that can be migrated to managed disks at no additional cost through the portal in less than 5 minutes.  
  
**Potential benefits**: Leverage higher resiliency and other benefits of Managed Disks  

For more information, see [Introduction to Azure managed disks](https://aka.ms/md_overview)  

<!--57ecb3cd-f2b4-4cad-8b3a-232cca527a0b_end-->

<!--11f04d70-5bb3-4065-b717-1f11b2e050a8_begin-->

#### Upgrade your deprecated Virtual Machine image to a newer image  
  
Virtual Machines (VMs) in your subscription are running on images scheduled for deprecation. Once the image is deprecated, new VMs can't be created from the deprecated image. To prevent disruption to your workloads, upgrade to a newer image. (VMRunningDeprecatedImage)  
  
**Potential benefits**: Minimize any potential disruptions to your VM workloads  

For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

<!--11f04d70-5bb3-4065-b717-1f11b2e050a8_end-->

<!--937d85a4-11b2-4e13-a6b5-9e15e3d74d7b_begin-->

#### Upgrade to a newer offer of Virtual Machine image  
  
Virtual Machines (VMs) in your subscription are running on images scheduled for deprecation. Once the image is deprecated, new VMs can't be created from the deprecated image.  To prevent disruption to your workloads, upgrade to a newer image. (VMRunningDeprecatedOfferLevelImage)  
  
**Potential benefits**: Minimize any potential disruptions to your VM workloads  

For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

<!--937d85a4-11b2-4e13-a6b5-9e15e3d74d7b_end-->

<!--681acf17-11c3-4bdd-8f71-da563c79094c_begin-->

#### Upgrade to a newer SKU of Virtual Machine image  
  
Virtual Machines (VMs) in your subscription are running on images scheduled for deprecation. Once the image is deprecated, new VMs can't be created from the deprecated image.  To prevent disruption to your workloads, upgrade to a newer image.  
  
**Potential benefits**: Minimize any potential disruptions to your VM workloads  

For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

<!--681acf17-11c3-4bdd-8f71-da563c79094c_end-->

<!--53e0a3cb-3569-474a-8d7b-7fd06a8ec227_begin-->

#### Provide access to mandatory URLs missing for your Azure Virtual Desktop environment  
  
For a session host to deploy and register to Windows Virtual Desktop (WVD) properly, you need a set of URLs in the 'allowed list' in case your VM runs in a restricted environment. For specific URLs missing from your allowed list, search your application event log for event 3702.  
  
**Potential benefits**: Ensure successful deployment and session host functionality when using Windows Virtual Desktop service  

For more information, see [Required FQDNs and endpoints for Azure Virtual Desktop](/azure/virtual-desktop/safe-url-list)  

<!--53e0a3cb-3569-474a-8d7b-7fd06a8ec227_end-->

<!--00e4ac6c-afa3-4578-a021-5f15e18850a2_begin-->

#### Align location of resource and resource group  
  
To reduce the impact of region outages, co-locate your resources with their resource group in the same region. This way, Azure Resource Manager stores metadata related to all resources within the group in one region. By co-locating, you reduce the chance of being affected by region unavailability.  
  
**Potential benefits**: Reduce write failures due to region outages  

For more information, see [What is Azure Resource Manager?](/azure/azure-resource-manager/management/overview#resource-group-location-alignment)  

<!--00e4ac6c-afa3-4578-a021-5f15e18850a2_end-->

<!--066a047a-9ace-45f4-ac50-6325840a6b00_begin-->

#### Use Availability zones for better resiliency and availability  
  
Availability Zones (AZ) in Azure help protect your applications and data from datacenter failures. Each AZ is made up of one or more datacenters equipped with independent power, cooling, and networking. By designing solutions to use zonal VMs, you can isolate your VMs from failure in any other zone.  
  
**Potential benefits**: Usage of zonal VMs protect your apps from zonal outage in any other zones.  

For more information, see [Move Azure single instance VMs from regional to zonal target availability zones](/azure/virtual-machines/move-virtual-machines-regional-zonal-portal)  

<!--066a047a-9ace-45f4-ac50-6325840a6b00_end-->

<!--39fb2718-a2ae-4662-a8c9-cd8df23f01eb_begin-->

#### Migrate to Virtual Machine Scale Sets Flex  
  
Migrate workloads from virtual machine (VM) to Virtual Machine Scale Sets Flex for deployment across zones or within the same zone across different fault domains. The platform plans to deprecate availability sets.  
  
**Potential benefits**: Availability across zones or across different fault domains  

For more information, see [Migrate deployments and resources to Virtual Machine Scale Sets in Flexible orchestration](https://aka.ms/MigrateToVMSSFlex)  

<!--39fb2718-a2ae-4662-a8c9-cd8df23f01eb_end-->

<!--490262e8-313c-431f-a143-a9c2cadba41b_begin-->

#### DNS Servers should be configured at the Virtual Network level  
  
Set the DNS Servers for the VM at the Virtual Network level to ensure consistency throughout the environment. In the configuration of the primary network interface, DNS Servers setting should be set to Inherit from virtual network.  
  
**Potential benefits**: Ensures consistency and reliable name resolution  

For more information, see [Name resolution for resources in Azure virtual networks](https://aka.ms/azvnetnameres)  

<!--490262e8-313c-431f-a143-a9c2cadba41b_end-->

<!--651c7925-17a3-42e5-85cd-73bd095cf27f_begin-->

#### Enable Backups on your Virtual Machines  
  
Secure your data by enabling backups for your virtual machines.  
  
**Potential benefits**: Protection of your Virtual Machines  

For more information, see [What is the Azure Backup service?](/azure/backup/backup-overview)  

<!--651c7925-17a3-42e5-85cd-73bd095cf27f_end-->

<!--3b739bd1-c193-4bb6-a953-1362ee3b03b2_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image version  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. Upgrade to newer version of the image to prevent disruption to your workload.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

<!--3b739bd1-c193-4bb6-a953-1362ee3b03b2_end-->

<!--3d18d7cd-bdec-4c68-9160-16a677d0f86a_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image offer  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. To prevent disruption to your workload, upgrade to newer offer of the image.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

<!--3d18d7cd-bdec-4c68-9160-16a677d0f86a_end-->

<!--44abb62e-7789-4f2f-8001-fa9624cb3eb3_begin-->

#### Upgrade your Virtual Machine Scale Set to alternative image SKU  
  
VMSS in your subscription are running on images that have been scheduled for deprecation. Once the image is deprecated, your Virtual Machine Scale Set workloads would no longer scale out. To prevent disruption to your workload, upgrade to newer SKU of the image.  
  
**Potential benefits**: Minimize any potential disruptions to your Virtual Machine Scale Set workloads  

For more information, see [Deprecated Azure Marketplace images - Azure Virtual Machines ](https://aka.ms/DeprecatedImagesFAQ)  

<!--44abb62e-7789-4f2f-8001-fa9624cb3eb3_end-->

<!--b4d988a9-85e6-4179-b69c-549bdd8a55bb_begin-->

#### Enable automatic repair policy on Azure Virtual Machine Scale Sets (VMSS)  
  
Enabling automatic instance repairs helps achieve high availability by maintaining a set of healthy instances. If an unhealthy instance is found by the Application Health extension or load balancer health probe, automatic instance repairs attempt to recover the instance by triggering repair actions.  
  
**Potential benefits**: Increase resiliency by automating repair of failed instances  

For more information, see [Automatic instance repairs for Azure Virtual Machine Scale Sets](https://aka.ms/vmss-automatic-repair)  

<!--b4d988a9-85e6-4179-b69c-549bdd8a55bb_end-->

<!--ce8bb934-ce5c-44b3-a94c-1836fa7a269a_begin-->

#### Configure Virtual Machine Scale Set automated scaling by metrics  
  
Optimize resource utilization, reduce costs, and enhance application performance with custom autoscale based on a metric. Automatically add Virtual Machine instances based on real-time metrics such as CPU, memory, and disk operations. Ensure high availability while maintaining cost-efficiency.  
  
**Potential benefits**: Ensures high availability while maintaining cost-efficiency  

For more information, see [Overview of autoscale with Azure Virtual Machine Scale Sets](https://aka.ms/VMSSCustomAutoscaleMetric)  

<!--ce8bb934-ce5c-44b3-a94c-1836fa7a269a_end-->

<!--2b5cf6e5-2792-49b2-9ec0-0e901be6488b_begin-->

#### Convert Standard to Premium disk for higher uptime  
  
Use a Premium SSD managed disk in a Single Instance virtual machine for the highest uptime. Conversion is allowed from a Standard managed disk to a Premium managed disk.  
  
**Potential benefits**: Enhanced performance, configurability, and uptime  

For more information, see [Best practices for achieving high availability with Azure virtual machines and managed disks](https://aka.ms/disks-high-availability)  

<!--2b5cf6e5-2792-49b2-9ec0-0e901be6488b_end-->

<!--e5e707f2-f41f-4aa6-bccf-3fb9748e5b66_begin-->

#### Add additional VM or use Premium disks for higher uptime  
  
Add a second instance VM to Availability Set or upgrade to Premium SSD managed disks for highest uptime.  
  
**Potential benefits**: Enhanced performance, configurability, and uptime  

For more information, see [Best practices for achieving high availability with Azure virtual machines and managed disks](https://aka.ms/disks-high-availability)  

<!--e5e707f2-f41f-4aa6-bccf-3fb9748e5b66_end-->

<!--articleBody-->
