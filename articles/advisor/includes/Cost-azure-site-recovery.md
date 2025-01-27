---
ms.service: azure
ms.topic: include
ms.date: 01/26/2025
author: kanika1894
ms.author: kapasrij
ms.custom: Cost Azure Site Recovery
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Site Recovery  
  
<!--83cf9b6e-1b82-4a1d-9151-7581dda7a26e_begin-->

#### Use differential or incremental backup for database workloads  
  
For SQL/HANA DBs in Azure VMs being backed up to Azure, using daily differential with weekly full backup is often more cost-effective than daily fully backups. For HANA, Azure Backup also supports incremental backup which is even more cost effective.  
  
**Potential benefits**: Optimize costs without impacting RPO  

**Impact:** Medium
  
For more information, see [FAQ — Back up SAP HANA databases on Azure VMs - Azure Backup ](https://aka.ms/DBBackupCostOptimization)  

ResourceType: microsoft.recoveryservices/vaults  
Recommendation ID: 83cf9b6e-1b82-4a1d-9151-7581dda7a26e  


<!--83cf9b6e-1b82-4a1d-9151-7581dda7a26e_end-->

<!--articleBody-->
