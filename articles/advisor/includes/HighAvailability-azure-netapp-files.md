---
ms.service: azure
ms.topic: include
ms.date: 06/24/2025
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

#### Configure a snapshot for the Azure NetApp Files volume  
  
Configure a snapshot for the Azure NetApp Files volume. Restore a snapshot to a new volume, restore a single file using a client, or revert an existing volume using a snapshot.  
  
**Potential benefits**: Add data protection for the Azure NetApp Files volume.  

**Impact:** High
  
For more information, see [How Azure NetApp Files snapshots work](/azure/azure-netapp-files/snapshots-introduction)  

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

<!--c70fc854-2814-4b03-9b93-8ad7b918bfcf_begin-->

#### Configure a backup for the Azure NetApp Files volume  
  
Configure a backup for the Azure NetApp Files volume. An Azure NetApp Files backup provides a fully managed backup solution for long-term recovery, archiving, and compliance. An Azure NetApp Files backup expands the data protection provided by Azure NetApp Files volume.  
  
**Potential benefits**: Add data protection for the Azure NetApp Files volume.  

**Impact:** Medium
  
For more information, see [Configure policy-based backups for Azure NetApp Files](/azure/azure-netapp-files/backup-configure-policy-based)  

ResourceType: microsoft.netapp/netappaccounts  
Recommendation ID: c70fc854-2814-4b03-9b93-8ad7b918bfcf  
Subcategory: DisasterRecovery

<!--c70fc854-2814-4b03-9b93-8ad7b918bfcf_end-->



<!--26f91380-cb68-4642-bb6f-1bce3c64c55e_begin-->

#### Create a cross-region replication relationship from the Azure NetApp Files volume to another volume  
  
Create a cross-region replication relationship from the Azure NetApp Files volume to an Azure NetApp Files volume in another region. Azure NetApp Files cross-region feature provides data protection between volumes in different regions.  
  
**Potential benefits**: Protect data for volumes in different regions.  

**Impact:** Medium
  
For more information, see [Cross-region replication of Azure NetApp Files volumes](/azure/azure-netapp-files/cross-region-replication-introduction)  

ResourceType: microsoft.netapp/netappaccounts  
Recommendation ID: 26f91380-cb68-4642-bb6f-1bce3c64c55e  
Subcategory: DisasterRecovery

<!--26f91380-cb68-4642-bb6f-1bce3c64c55e_end-->


<!--7a48f43e-8615-4ce0-8039-83b9d24f945a_begin-->

#### Create a cross-zone replication relationship from the Azure NetApp Files volume to another volume  
  
Create a cross-zone replication relationship from the Azure NetApp Files volume to an Azure NetApp Files volume in another availability zone. The Azure NetApp Files cross-zone replication feature provides data protection between volumes in different availability zones.  
  
**Potential benefits**: Protect data for volumes in different availability zones.  

**Impact:** Medium
  
For more information, see [Cross-zone replication of Azure NetApp Files volumes](/azure/azure-netapp-files/cross-zone-replication-introduction)  

ResourceType: microsoft.netapp/netappaccounts  
Recommendation ID: 7a48f43e-8615-4ce0-8039-83b9d24f945a  
Subcategory: DisasterRecovery

<!--7a48f43e-8615-4ce0-8039-83b9d24f945a_end-->


<!--64936c6e-8236-4875-8234-109ab34576fe_begin-->

#### End of Support for increase to IP route limit for Basic network features  
  
An Azure NetApp Files volume using Basic network features is subject to an IP route limit of 1600. IP route limits aren't adjustable. To prevent the IP route limit, migrate volumes to Standard network features from Basic network features.  
  
**Potential benefits**: Increase the number of IP routes.  

**Impact:** High
  
For more information, see [Configure network features for an Azure NetApp Files volume](https://aka.ms/standardnetwork)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 64936c6e-8236-4875-8234-109ab34576fe  
Subcategory: ServiceUpgradeAndRetirement

<!--64936c6e-8236-4875-8234-109ab34576fe_end-->

<!--articleBody-->
