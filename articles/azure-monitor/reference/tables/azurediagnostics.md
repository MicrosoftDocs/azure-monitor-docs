---
title: Azure Monitor Logs reference - AzureDiagnostics
description: Reference for AzureDiagnostics table in Azure Monitor Logs.
ms.topic: reference
ms.service: azure-monitor
ms.subservice: logs
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/20/2024
custom: Hardcoded description from azurediagnostics-stub.md.
---

# AzureDiagnostics

Stores resource logs for Azure services that use Azure Diagnostics mode. Resource logs describe the internal operation of Azure resources.

The resource log for each Azure service has a unique set of columns. The AzureDiagnostics table includes the most common columns used by Azure services. If a resource log includes a column that doesn't already exist in the AzureDiagnostics table, that column is added the first time that data is collected. If the maximum number of 500 columns is reached, data for any additional columns is added to a dynamic column.

Azure services that use resource-specific mode store data in a table specific to that service and don't use the AzureDiagnostics table. See [Azure resource logs](/azure/azure-monitor/platform/resource-logs#send-to-log-analytics-workspace) for details on the differences. See [Resources using Azure Diagnostics mode](#resources-using-azure-diagnostics-mode) for the services that use Azure Diagnostics.

> [!NOTE]
> The AzureDiagnostics table is a custom log table created exclusively by the Azure Monitor pipeline the first time an Azure resource begins sending logs in Azure Diagnostics mode. Unlike other tables, the AzureDiagnostics table can't be created via an ARM template or tables API. Consequently, it's not possible to modifying the table's default retention values before its creation.

## AdditionalFields column

Unlike other tables, **AzureDiagnostics** is much more susceptible to exceeding the 500 column limit imposed for any table in a Log Analytics workspace due to the wide assortment of Azure Resources capable of sending data to this table. To ensure that no data is lost due to the number of active columns exceeding this 500 column limit, AzureDiagnostics column creation is handled in a different manner to other tables.

The AzureDiagnostics table in every workspace contains at a minimum, the same [200 columns](#azurediagnostics-table-columns). For workspaces created before January 19, 2021, the table also contains any columns that were already in place before this date. When data is sent to a column not already in place:

- If the total number of columns in **AzureDiagnostics** in the current workspace doesn't exceed 500, a new column is created just like with any other table.
- If the total number of columns is at or above 500, the excess data is added to a dynamic property bag column called **AdditionalFields** as a property.

### Example

To illustrate this behavior, imagine that as of (deployment date) the AzureDiagnostics table in our workspace looks as follows:

| Column 1 | Column 2 | Column 3 | ... | Column 498 |
|:---|:---|:---|:---|:---|
| abc | def | 123 | ... | 456 |
| ... | ... | ... | ... | ... |

A resource that sends data to **AzureDiagnostics** then adds a new dimension to their data that they call **NewInfo1**. Since the table still has fewer than 500 columns, the first time an event occurs that contains data for this new dimension adds a new column to the table:

| Column 1 | Column 2 | Column 3 | ... | Column 498 | NewInfo1_s |
|:---|:---|:---|:---|:---|:---|
| abc | def | 123 | ... | 456 | xyz |
| ... | ... | ... | ... | ... | ... |

You can return this new data in a simple query:

```kusto
AzureDiagnostics | where NewInfo1_s == "xyz"
```

At a later date, another resource sends data to **AzureDiagnostics** that adds new dimensions called **NewInfo2** and **NewInfo3**. Because the table has reached 500 columns in this workspace, the new data goes into the **AdditionalFields** column:

| Column 1 | Column 2 | Column 3 | ... | Column 498 | NewInfo1_s | AdditionalFields |
|:---|:---|:---|:---|:---|:---|:---|
| abc | def | 123 | ... | 456 | xyz | {"NewInfo2":"789","NewInfo3":"qwerty"} |
| ... | ... | ... | ... | ... | ... | ... |

You can still query for this data, but you must extract it from the property bag using any of the dynamic property operators in KQL:

```kusto
AzureDiagnostics
| where AdditionalFields.NewInfo2 == "789" and AdditionalFields.NewInfo3 == "qwerty"
```

### Tips on using the `AdditionalFields` column

While query best practices such as always filtering by time as the first clause in the query should be followed, there are some other recommendations you should consider when working with AdditionalFields:

- You must typecast data before performing further operations on it. For example, if you have a column  called **Perf1Sec_i** and a property in **AdditionalFields** called **Perf2Sec**, and you want to calculate total perf by adding both values, you can use the following: `AzureDiagnostics | extend TotalPerfSec = Perf1Sec_i + toint(AdditionalFields.Perf2Sec) | ....`.
- Use [where](/azure/data-explorer/kusto/query/whereoperator) clauses to reduce the data volume to the smallest possible before writing any complex logic to significantly improve performance. **TimeGenerated** is one column that should always be reduced to the smallest possible window. In the case of **AzureDiagnostics**, an additional filter should always be included at the top of the query around the resource types that are being queried using the **ResourceType** column.
- When querying large volumes of data, it's sometimes more efficient to do a filter on **AdditionalFields** as a whole rather than parsing it. For example, for large volumes of data, `AzureDiagnostics | where AdditionalFields has "Perf2Sec"` is often more efficient than `AzureDiagnostics | where isnotnull(toint(AdditionalFields.Perf2Sec))`.


## Resources using Azure Diagnostics mode

The following services use Azure diagnostics mode for their resource logs and send data to the Azure Diagnostics table. See [Azure resource logs](/azure/azure-monitor/platform/resource-logs) for details on this configuration.
> [!NOTE]
> All other resources send data to resource-specific tables.

|Service name | resourceType|
|---|---|
|MicrosoftSqlAzureTelemetryv3 | microsoft.sql/servers/databases|
|MicrosoftAzureCosmosDB | microsoft.documentdb/databaseaccounts|
|AzureFirewall | microsoft.network/azurefirewalls|
|AzureApplicationGatewayService | microsoft.network/applicationgateways |
|AKSCustomerData | microsoft.containerservice/managedclusters |
|AzureFrontdoor | microsoft.cdn/profiles |
|LNMAgentService | microsoft.network/networksecuritygroups |
|MicrosoftOrcasBreadthServers | microsoft.dbforpostgresql/flexibleservers |
|servicebus | microsoft.eventhub/namespaces |
|AzureFrontdoor | microsoft.network/frontdoors |
|AzureKeyVault | microsoft.keyvault/vaults |
|AzureDataLake | microsoft.datalakestore/accounts |
|ApiManagement | microsoft.apimanagement/service |
|MicrosoftSqlAzureTelemetryv3 | microsoft.sql/managedinstances |
|ASAzureRP | microsoft.analysisservices/servers |
|MicrosoftOrcasBreadthServers | microsoft.dbformysql/flexibleservers |
|servicebus | microsoft.servicebus/namespaces |
|AzureIotHub | microsoft.devices/iothubs |
|MicrosoftSqlAzureTelemetryv2 | microsoft.dbforpostgresql/servers |
|MicrosoftSqlAzureTelemetryv2 | microsoft.dbformariadb/servers |
|MicrosoftAutomation | microsoft.automation/automationaccounts |
|TrafficManager | microsoft.network/trafficmanagerprofiles |
|MicrosoftOrcasBreadthServers | microsoft.dbforpostgresql/servergroupsv2 |
|AzureSearch | microsoft.search/searchservices |
|AzureHybrid | microsoft.network/virtualnetworkgateways |
|MicrosoftSqlAzureTelemetryv3 | microsoft.sql/managedinstances/databases |
|PBIDedicatedRP | microsoft.powerbidedicated/capacities |
|AzureHybrid | microsoft.network/vpngateways |
|MicrosoftDatafactory | microsoft.datafactory/factories |
|MicrosoftCognitiveServices | microsoft.cognitiveservices/accounts |
|AzureRecoveryServices | microsoft.recoveryservices/vaults |
|AzureBatch | microsoft.batch/batchaccounts |
|AzureHybrid | microsoft.network/p2svpngateways |
|MicrosoftSqlAzureTelemetryv2 | microsoft.dbformysql/servers |
|AzureKeyVault | microsoft.keyvault/managedhsms |
|NetMon | microsoft.network/publicipaddresses |
|AzureDataLake | microsoft.datalakeanalytics/accounts |
|MicrosoftStreamanalytics | microsoft.streamanalytics/streamingjobs |
|servicebus | microsoft.relay/namespaces |
|AzureIotDps | microsoft.devices/provisioningservices |
|MicrosoftAzureCosmosDB | microsoft.documentdb/cassandraclusters |
|MicrosoftAzureCosmosDB | microsoft.documentdb/mongoclusters |
|AKSCustomerData | microsoft.containerservice/fleets |
|PBIDedicatedRP | microsoft.powerbi/tenants/workspaces |
|AzureFrontdoor | microsoft.cdn/cdnwebapplicationfirewallpolicies |
|AzureHybrid | microsoft.network/expressroutecircuits |
|MicrosoftAzureCosmosDB | microsoft.dbforpostgresql/flexibleservers |
|NetMon | microsoft.network/publicipprefixes |
|AzureCdn | microsoft.cdn/profiles/endpoints |


### Azure Diagnostics mode or resource-specific mode

The following services use either Azure diagnostics mode or resource-specific mode for their resource logs depending on the diagnostics settings configuration. When using resource-specific mode, these resources don't send data to the AzureDiagnostics table. See [Azure resource logs](/azure/azure-monitor/platform/resource-logs) for details on this configuration.

|Service name | resourceType|
|---|---|
| API Management Services |Microsoft.ApiManagement|
| Azure Cosmos DB |Microsoft.DocumentDB/databaseAccounts|
| Data factories (V2) |Microsoft.DataFactory|
| Recovery Services vaults(Backup)| Microsoft.RecoveryServices/vaults|
| Firewalls|Microsoft.Network/azureFirewalls|

## AzureDiagnostics table columns

|Column|Type|Description|
|---|---|---|
|action_id_s|String||
|action_name_s|String||
|action_s|String||
|ActivityId_g|Guid||
|AdditionalFields|||
|AdHocOrScheduledJob_s|String||
|application_name_s|String||
|audit_schema_version_d|Double||
|avg_cpu_percent_s|String||
|avg_mean_time_s|String||
|backendHostname_s|String||
|Caller_s|String||
|callerId_s|String||
|CallerIPAddress|String||
|calls_s|String||
|Category|String||
|client_ip_s|String||
|clientInfo_s|String||
|clientIP_s|String||
|clientIp_s|String||
|clientIpAddress_s|String||
|clientPort_d|Double||
|code_s|String||
|collectionName_s|String||
|conditions_destinationIP_s|String||
|conditions_destinationPortRange_s|String||
|conditions_None_s|String||
|conditions_protocols_s|String||
|conditions_sourceIP_s|String||
|conditions_sourcePortRange_s|String||
|CorrelationId|String||
|count_executions_d|Double||
|cpu_time_d|Double||
|database_name_s|String||
|database_principal_name_s|String||
|DatabaseName_s|String||
|db_id_s|String||
|direction_s|String||
|dop_d|Double||
|duration_d|Double||
|duration_milliseconds_d|Double||
|DurationMs|BigInt||
|ElasticPoolName_s|String||
|endTime_t|DateTime||
|Environment_s|String||
|error_code_s|String||
|error_message_s|String||
|errorLevel_s|String||
|event_class_s|String||
|event_s|String||
|event_subclass_s|String||
|event_time_t|DateTime||
|EventName_s|String||
|execution_type_d|Double||
|executionInfo_endTime_t|DateTime||
|executionInfo_exitCode_d|Double||
|executionInfo_startTime_t|DateTime||
|host_s|String||
|httpMethod_s|String||
|httpStatus_d|Double||
|httpStatusCode_d|Double||
|httpStatusCode_s|String||
|httpVersion_s|String||
|id_s|String||
|identity_claim_appid_g|Guid||
|identity_claim_ipaddr_s|String||
|instanceId_s|String||
|interval_end_time_d|Double||
|interval_start_time_d|Double||
|ip_s|String||
|is_column_permission_s|String||
|isAccessPolicyMatch_b|Bool||
|JobDurationInSecs_s|String||
|JobFailureCode_s|String||
|JobId_g|Guid||
|jobId_s|String||
|JobOperation_s|String||
|JobOperationSubType_s|String||
|JobStartDateTime_s|String||
|JobStatus_s|String||
|JobUniqueId_g|Guid||
|Level|String||
|log_bytes_used_d|Double||
|logical_io_reads_d|Double||
|logical_io_writes_d|Double||
|LogicalServerName_s|String||
|macAddress_s|String||
|matchedConnections_d|Double||
|max_cpu_time_d|Double||
|max_dop_d|Double||
|max_duration_d|Double||
|max_log_bytes_used_d|Double||
|max_logical_io_reads_d|Double||
|max_logical_io_writes_d|Double||
|max_num_physical_io_reads_d|Double||
|max_physical_io_reads_d|Double||
|max_query_max_used_memory_d|Double||
|max_rowcount_d|Double||
|max_time_s|String||
|mean_time_s|String||
|Message|String||
|min_time_s|String||
|msg_s|String||
|num_physical_io_reads_d|Double||
|object_id_d|Double||
|object_name_s|String||
|OperationName|String||
|OperationVersion|String||
|partitionKey_s|String||
|physical_io_reads_d|Double||
|plan_id_d|Double||
|policy_s|String||
|policyMode_s|String||
|primaryIPv4Address_s|String||
|priority_d|Double||
|properties_enabledForDeployment_b|Bool||
|properties_enabledForDiskEncryption_b|Bool||
|properties_enabledForTemplateDeployment_b|Bool||
|properties_s|String||
|properties_sku_Family_s|String||
|properties_sku_Name_s|String||
|properties_tenantId_g|Guid||
|query_hash_s|String||
|query_id_d|Double||
|query_max_used_memory_d|Double||
|query_plan_hash_s|String||
|query_time_d|Double||
|querytext_s|String||
|receivedBytes_d|Double||
|Region_s|String||
|requestCharge_s|String||
|requestQuery_s|String||
|requestResourceId_s|String||
|requestResourceType_s|String||
|requestUri_s|String||
|reserved_storage_mb_s|String||
|Resource|String||
|resource_actionName_s|String||
|resource_location_s|String||
|resource_originRunId_s|String||
|resource_resourceGroupName_s|String||
|resource_runId_s|String||
|resource_subscriptionId_g|Guid||
|resource_triggerName_s|String||
|resource_workflowId_g|Guid||
|resource_workflowName_s|String||
|ResourceGroup|String||
|_ResourceId|String|A unique identifier for the resource that the record is associated with|
|ResourceProvider|String||
|ResourceProvider|String||
|ResourceType|String||
|ResourceType|String||
|response_rows_d|Double||
|resultCode_s|String||
|ResultDescription|String||
|ResultDescription|String||
|resultDescription_ChildJobs_s|String||
|resultDescription_ErrorJobs_s|String||
|resultMessage_s|String||
|ResultSignature|String||
|ResultType|String||
|ResultType|String||
|rootCauseAnalysis_s|String||
|routingRuleName_s|String||
|rowcount_d|Double||
|ruleName_s|String||
|RunbookName_s|String||
|RunOn_s|String||
|schema_name_s|String||
|sentBytes_d|Double||
|sequence_group_id_g|Guid||
|sequence_number_d|Double||
|server_principal_sid_s|String||
|session_id_d|Double||
