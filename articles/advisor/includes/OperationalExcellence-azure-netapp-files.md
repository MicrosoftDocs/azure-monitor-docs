---
ms.service: azure
ms.topic: include
ms.date: 08/12/2025
author: kanika1894
ms.author: kapasrij
ms.custom: OperationalExcellence Azure NetApp Files
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure NetApp Files  
  
<!--d35fd191-4fa0-4949-8517-50750bd9672e_begin-->

#### Configure standard networking for the Azure NetApp Files volume  
  
Convert the basic volume to standard with no downtime. The setting allows higher IP limits and standard virtual network features, such as network security groups and routes defined by user on delegated subnets.  
  
**Potential benefits**: Improve network routing.  

**Impact:** Medium
  
For more information, see [Configure network features for an Azure NetApp Files volume](/azure/azure-netapp-files/configure-network-features#edit-network-features-option-for-existing-volumes)  

ResourceType: microsoft.netapp/netappaccounts  
Recommendation ID: d35fd191-4fa0-4949-8517-50750bd9672e  


<!--d35fd191-4fa0-4949-8517-50750bd9672e_end-->

<!--f1a7425d-69fa-463e-a2b0-f1d37cb995cf_begin-->

#### Backup Vault Migration  
  
All the backups in the volume needs to be migrated to Backup Vault. Note, this recommendation will automatically disappear in 24 hours after you migrate all the volumes in your subscription.  
  
**Potential benefits**: Helps in managing Backups better  

**Impact:** Medium
  
For more information, see [Manage backup policies for Azure NetApp Files](https://aka.ms/anfdocs-backup)  

ResourceType: microsoft.netapp/netappaccounts  
Recommendation ID: f1a7425d-69fa-463e-a2b0-f1d37cb995cf  


<!--f1a7425d-69fa-463e-a2b0-f1d37cb995cf_end-->

<!--464a7366-ddae-4d74-9187-386bfc45e4f5_begin-->

#### Avoid mounting issue by specifying NFSv4.1 mount options  
  
To avoid any issues with clients mounting NFSv4.2 and to comply with supportability, ensure the NFSv4.1 version is specified in mount options or the client's NFS client configuration is set to cap the NFS version at NFSv4.1.  
  
**Potential benefits**: Avoid Mounting Issues  

**Impact:** Medium
  
  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 464a7366-ddae-4d74-9187-386bfc45e4f5  


<!--464a7366-ddae-4d74-9187-386bfc45e4f5_end-->

<!--db4ccef4-d6aa-40a8-8d3c-b42ffc20a9a0_begin-->

#### Configure the network topology and the domain controllers  
  
Configure the network topology and the domain controller to match the requirements of Azure NetApp Files. The platform detected that the domain controller configured in the Azure NetApp Files Active Directory Connector isn't available and results in application disruption.  
  
**Potential benefits**: Normalized access to volume.  

**Impact:** Medium
  
For more information, see [Understand guidelines for Active Directory Domain Services site design and planning](/azure/azure-netapp-files/understand-guidelines-active-directory-domain-service-site#ad-ds-requirements)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: db4ccef4-d6aa-40a8-8d3c-b42ffc20a9a0  


<!--db4ccef4-d6aa-40a8-8d3c-b42ffc20a9a0_end-->

<!--95c1a2fb-ee2f-40bf-b3b4-ee8fc3fd94dd_begin-->

#### Avoid volume availability issues with Azure NetApp Files  
  
Avoid volume availability issues by specifying your preference for the volume. Contact your Account Representative with your desired volume's state.  
  
**Potential benefits**: Sustained Volume Availability  

**Impact:** High
  
For more information, see [Service levels for Azure NetApp Files](/azure/azure-netapp-files/azure-netapp-files-service-levels)  

ResourceType: microsoft.netapp/netappaccounts/capacitypools/volumes  
Recommendation ID: 95c1a2fb-ee2f-40bf-b3b4-ee8fc3fd94dd  


<!--95c1a2fb-ee2f-40bf-b3b4-ee8fc3fd94dd_end-->

<!--articleBody-->
