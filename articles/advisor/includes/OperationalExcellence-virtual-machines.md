---
ms.service: azure
ms.topic: include
ms.date: 11/25/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Virtual Machines
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Virtual Machines  
  
<!--4b25fc0f-b045-423b-a85a-241978696e36_begin-->

#### In-Place Upgrade to Ubuntu Pro with zero downtime for Extended Security  
  
Given Ubuntu 18.04 LTS is out of standard support, customers are required to upgrade to Ubuntu Pro enable Extended Security Maintenance until 2028. Ubuntu Pro is a premium image delivering the most comprehensive open source security while expanding the package coverage to over 23,000 packages.  
  
**Potential benefits**: Ubuntu Pro enables Extended Security Maintenance until 2028.  

**Impact:** High
  
For more information, see [In-place upgrade to Ubuntu Pro Linux images on Azure - Azure Virtual Machines](https://aka.ms/ubuntupro)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 4b25fc0f-b045-423b-a85a-241978696e36  


<!--4b25fc0f-b045-423b-a85a-241978696e36_end-->

<!--de7ddac0-29e6-4bff-a812-519d18184982_begin-->

#### Enable Trusted Launch foundational excellence, and modern security for Existing Generation 2 VM(s)  
  
Trusted Launch (TL) offers a modern and operational technologies for Azure virtual machines, using Secure Boot, virtual TPM, and guest attestation. This Generation 2 VM(s) have an opportunity to upgrade to Trusted Launch. Ensure this VM(s) has both an image and VM size that it's TL compatible.  
  
**Potential benefits**: Boost Gen2 VM security by protecting against rootkits  

**Impact:** High
  
For more information, see [Trusted Launch for Azure VMs - Azure Virtual Machines](/azure/virtual-machines/trusted-launch)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: de7ddac0-29e6-4bff-a812-519d18184982  


<!--de7ddac0-29e6-4bff-a812-519d18184982_end-->


<!--acc30c87-0979-4a35-b4c4-918869897844_begin-->

#### Add explicit outbound method to disable default outbound for Virtual Machine Scale Sets  
  
Use an explicit connectivity method such as NAT gateway or a Public IP. After March 31, 2026, new virtual networks will default to creation of private subnets, which are intentionally designed to block default outbound access connectivity.  
  
**Potential benefits**: Secure and explicit outbound access for new subnets  

**Impact:** Medium
  
For more information, see [Default Outbound Access in Azure - Azure Virtual Network](https://aka.ms/defaultoutboundretirement)  

ResourceType: microsoft.compute/virtualmachinescalesets/virtualmachines/networkinterfaces  
Recommendation ID: acc30c87-0979-4a35-b4c4-918869897844  


<!--acc30c87-0979-4a35-b4c4-918869897844_end-->

<!--2881ca3a-070d-40fb-9471-83783ff487c0_begin-->

#### Enable VM Insights for virtual machines  
  
Your virtual machines don’t have VM Insights enabled. Turn it on to collect performance and dependency data for better troubleshooting, right-sizing, and health monitoring in Azure Monitor.  
  
**Potential benefits**: Gain performance and dependency visibility  

**Impact:** Medium
  
For more information, see [Enable VM Insights - Azure Monitor](/azure/azure-monitor/vm/vminsights-enable-overview)  

ResourceType: microsoft.compute/virtualmachines  
Recommendation ID: 2881ca3a-070d-40fb-9471-83783ff487c0  


<!--2881ca3a-070d-40fb-9471-83783ff487c0_end-->

<!--articleBody-->
