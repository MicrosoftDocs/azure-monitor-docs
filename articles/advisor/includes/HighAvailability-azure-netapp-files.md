---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure NetApp Files
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure NetApp Files  
  
<!--2e795f35-fce6-48dc-a5ac-6860cb9a0442_begin-->

#### Configure AD DS Site for Azure Netapp Files AD Connector  
  
If Azure NetApp Files can't reach assigned AD DS site domain controllers, the domain controller discovery process queries all domain controllers. Unreachable domain controllers may be used, causing issues with volume creation, client queries, authentication, and AD connection modifications.  
  
**Potential benefits**: Optimize DNS Connectivity with Azure Netapp Files  

**Impact:** High
  
For more information, see [Understand guidelines for Active Directory Domain Services site design and planning ](https://aka.ms/anfsitescoping)  

ResourceType: microsoft.netapp/netappaccounts  
Recommendation ID: 2e795f35-fce6-48dc-a5ac-6860cb9a0442  
Subcategory: Other

<!--2e795f35-fce6-48dc-a5ac-6860cb9a0442_end-->

<!--4e112555-7dc0-4f33-85e7-18398ac41345_begin-->

#### Ensure Roles assigned to Microsoft.NetApp Delegated Subnet has Subnet Read Permissions  
  
Roles that are required for the management of Azure NetApp Files resources, must have "Microsoft.network/virtualNetworks/subnets/read" permissions on the subnet that is delegated to Microsoft.NetApp If the role, whether Custom or Built-In doesn't have this permission, then Volume Creations will fail  
  
**Potential benefits**: Prevent volume creation failures by ensuring subnet/read permissions  

**Impact:** High
  
  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 4e112555-7dc0-4f33-85e7-18398ac41345  
Subcategory: HighAvailability

<!--4e112555-7dc0-4f33-85e7-18398ac41345_end-->

<!--8754f0ed-c82a-497e-be31-c9d701c976e1_begin-->

#### Review SAP configuration for timeout values used with Azure NetApp Files  
  
High availability of SAP while used with Azure NetApp Files relies on setting proper timeout values to prevent disruption to your application. Review the 'Learn more' link to ensure your configuration meets the timeout values as noted in the documentation.  
  
**Potential benefits**: Improve resiliency of SAP Application on ANF  

**Impact:** High
  
For more information, see [Get started with SAP on Azure VMs ](/azure/sap/workloads/get-started)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 8754f0ed-c82a-497e-be31-c9d701c976e1  
Subcategory: Other

<!--8754f0ed-c82a-497e-be31-c9d701c976e1_end-->

<!--cda11061-35a8-4ca3-aa03-b242dcdf7319_begin-->

#### Implement disaster recovery strategies for your Azure NetApp Files resources  
  
To avoid data or functionality loss during a regional or zonal disaster, implement common disaster recovery techniques such as cross region replication or cross zone replication for your Azure NetApp Files volumes.  
  
**Potential benefits**: Manage disaster recovery easily with Azure NetApp Files replication features  

**Impact:** High
  
For more information, see [Understand data protection and disaster recovery options in Azure NetApp Files ](https://aka.ms/anfcrr)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: cda11061-35a8-4ca3-aa03-b242dcdf7319  
Subcategory: DisasterRecovery

<!--cda11061-35a8-4ca3-aa03-b242dcdf7319_end-->

<!--e4bebd74-387a-4a74-b757-475d2d1b4e3e_begin-->

#### Azure Netapp Files - Enable Continuous Availability for SMB Volumes  
  
For Continuous Availability, we recommend enabling Server Message Block (SMB) volume for your Azure Netapp Files.  
  
**Potential benefits**: Prevent application disruptions by enabling Continuous Availability for SMB volumes  

**Impact:** High
  
For more information, see [Enable Continuous Availability on existing Azure NetApp Files SMB volumes ](https://aka.ms/anfdoc-continuous-availability)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: e4bebd74-387a-4a74-b757-475d2d1b4e3e  
Subcategory: HighAvailability

<!--e4bebd74-387a-4a74-b757-475d2d1b4e3e_end-->

<!--articleBody-->
