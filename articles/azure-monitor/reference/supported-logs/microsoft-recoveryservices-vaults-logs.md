---
title: Supported log categories - Microsoft.RecoveryServices/Vaults
description: Reference for Microsoft.RecoveryServices/Vaults in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.RecoveryServices/Vaults, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.RecoveryServices/Vaults

The following table lists the types of logs available for the Microsoft.RecoveryServices/Vaults resource type.

For a list of supported metrics, see [Supported metrics - Microsoft.RecoveryServices/Vaults](../supported-metrics/microsoft-recoveryservices-vaults-metrics.md)


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`AddonAzureBackupAlerts` |Addon Azure Backup Alert Data |[AddonAzureBackupAlerts](/azure/azure-monitor/reference/tables/addonazurebackupalerts)|No|Yes||No |
|`AddonAzureBackupJobs` |Addon Azure Backup Job Data |[AddonAzureBackupJobs](/azure/azure-monitor/reference/tables/addonazurebackupjobs)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/addonazurebackupjobs)|No |
|`AddonAzureBackupPolicy` |Addon Azure Backup Policy Data |[AddonAzureBackupPolicy](/azure/azure-monitor/reference/tables/addonazurebackuppolicy)|No|Yes||No |
|`AddonAzureBackupProtectedInstance` |Addon Azure Backup Protected Instance Data |[AddonAzureBackupProtectedInstance](/azure/azure-monitor/reference/tables/addonazurebackupprotectedinstance)|No|Yes||No |
|`AddonAzureBackupStorage` |Addon Azure Backup Storage Data |[AddonAzureBackupStorage](/azure/azure-monitor/reference/tables/addonazurebackupstorage)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/addonazurebackupstorage)|No |
|`ASRReplicatedItems` |Azure Site Recovery Replicated Items Details |[ASRReplicatedItems](/azure/azure-monitor/reference/tables/asrreplicateditems)<p>This table contains details of Azure Site Recovery (ASR) replicated items, such as associated vault, policy, replication health, failover readiness. etc. Data is pushed once a day to this table for all replicated items, to provide the latest information for each item.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/asrreplicateditems)|Yes |
|`AzureBackupOperations` |Azure Backup Operations |[AzureBackupOperations](/azure/azure-monitor/reference/tables/azurebackupoperations)<p>This table contains details of Azure Backup operations.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/azurebackupoperations)|Yes |
|`AzureBackupReport` |Azure Backup Reporting Data |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`AzureSiteRecoveryEvents` |Azure Site Recovery Events |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`AzureSiteRecoveryJobs` |Azure Site Recovery Jobs |[ASRJobs](/azure/azure-monitor/reference/tables/asrjobs)<p>This table contains records of Azure Site Recovery (ASR) jobs such as failover, test failover, reprotection etc., with key details for monitoring and diagnostics, such as the replicated item information, duration, status, description and so on. Whenever an ASR job is completed (i.e., succeeded or failed), a corresponding record for the job is sent to this table. You can view history of ASR jobs by querying this table over a larger time range, provided your workspace has the required retention configured.|No|Yes|[Queries](/azure/azure-monitor/reference/queries/asrjobs)|No |
|`AzureSiteRecoveryProtectedDiskDataChurn` |Azure Site Recovery Protected Disk Data Churn |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`AzureSiteRecoveryRecoveryPoints` |Azure Site Recovery Recovery Points |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`AzureSiteRecoveryReplicatedItems` |Azure Site Recovery Replicated Items |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`AzureSiteRecoveryReplicationDataUploadRate` |Azure Site Recovery Replication Data Upload Rate |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`AzureSiteRecoveryReplicationStats` |Azure Site Recovery Replication Stats |[AzureDiagnostics](/azure/azure-monitor/reference/tables/azurediagnostics)<p>Logs from multiple Azure resources.|No|No|[Queries](/azure/azure-monitor/reference/queries/azurediagnostics#queries-for-microsoftrecoveryservices)|No |
|`CoreAzureBackup` |Core Azure Backup Data |[CoreAzureBackup](/azure/azure-monitor/reference/tables/coreazurebackup)|No|Yes|[Queries](/azure/azure-monitor/reference/queries/coreazurebackup)|No |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
