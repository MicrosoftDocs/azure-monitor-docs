---
ms.service: azure-monitor
ms.topic: include
ms.date: 12/30/2024
author: kanika1894
ms.author: kapasrij
ms.custom: HighAvailability Azure Site Recovery
  
# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 
  
---
  
## Azure Site Recovery  
  
<!--3ebfaf53-4d8c-4e67-a948-017bbbf59de6_begin-->

#### Enable soft delete for your Recovery Services vaults  
  
Soft delete helps you retain your backup data in the Recovery Services vault for an additional duration after deletion, giving you an opportunity to retrieve it before it's permanently deleted.  
  
**Potential benefits**: Helps recovery of backup data in cases of accidental deletion  

For more information, see [Soft delete for Azure Backup](/azure/backup/backup-azure-security-feature-cloud)  

<!--3ebfaf53-4d8c-4e67-a948-017bbbf59de6_end-->

<!--9b1308f1-4c25-4347-a061-7cc5cd6a44ab_begin-->

#### Enable Cross Region Restore for your recovery Services Vault  
  
Cross Region Restore (CRR) allows you to restore Azure VMs in a secondary region (an Azure paired region), helping with disaster recovery.  
  
**Potential benefits**: As one of the restore options, Cross Region Restore (CRR) allows you to restore Azure VMs in a secondary region, which is an Azure paired region.  

For more information, see [How to restore Azure VM data in Azure portal](/azure/backup/backup-azure-arm-restore-vms#cross-region-restore)  

<!--9b1308f1-4c25-4347-a061-7cc5cd6a44ab_end-->

<!--articleBody-->
