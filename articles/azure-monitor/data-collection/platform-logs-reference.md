---
title: Platform logs supported resource types and regions (Preview)
description: Reference for resource types, category streams, destination tables, and regions supported for platform logs export by using data collection rules.
ms.topic: reference
ms.date: 05/28/2026
ms.custom: ai-assisted
---

# Platform logs supported resource types and regions (Preview)

This article lists resource types, category streams, destination tables, and regions currently supported for [platform log export by using data collection rules (DCRs)](./platform-logs-collect.md).

## Supported resource types

Use stream specifications in the format:

`<resource-provider>/<resource-type>:<category-or-Logs-Group-All>`

To collect all log categories for a resource type, use Logs-Group-All. For example:
`microsoft.app/managedenvironments:Logs-Group-All`

To collect a specific log category, use the category name:
`microsoft.dbformysql/flexibleservers:MySqlAuditLogs
`

Examples:

`microsoft.app/managedenvironments:Logs-Group-All'
'microsoft.dbformysql/flexibleservers:MySqlAuditLogs'


| Resource name | Resource provider | Log categories | Log table |
|---|---|---|---|
| Container registries | `Microsoft.ContainerRegistry/registries` | `ContainerRegistryLoginEvents`, `ContainerRegistryRepositoryEvents` | `ContainerRegistryLoginEvents`, `ContainerRegistryRepositoryEvents` |
| Container Apps managed environments | `microsoft.app/managedenvironments` | `AppEnvSessionConsoleLogs`, `AppEnvSessionLifeCycleLogs`, `AppEnvSessionPoolEventLogs`, `ContainerAppConsoleLogs`, `ContainerAppHTTPLogs`, `ContainerAppSystemLogs` | `ContainerAppConsoleLogs`, `ContainerAppSystemLogs` |
| Azure VMware Solution private clouds | `microsoft.avs/privateclouds` | `vmwaresyslog` | `AVSSyslog` |
| Azure Sphere catalogs | `microsoft.azuresphere/catalogs` | `AuditLogs`, `DeviceEvents` | `ASCAuditLogs`, `ASCDeviceEvents` |
| Chaos experiments | `microsoft.chaos/experiments` | `ExperimentOrchestration` | `ChaosStudioExperimentEventLogs` |
| Confidential Ledger managed CCFs | `microsoft.confidentialledger/managedccfs` | `applicationlogs` | `CCFApplicationLogs` |
| Azure Managed Grafana | `microsoft.dashboard/grafana` | `GrafanaLoginEvents`, `GrafanaUsageInsightsEvents` | `AGSGrafanaLoginEvents`, `AGSGrafanaUsageInsightsEvents` |
| Data replication vaults | `microsoft.datareplication/replicationvaults` | `HealthEvents`, `JobEvents`, `ProtectedItems`, `ReplicationExtensions`, `ReplicationPolicies`, `ReplicationVaults` | `ASRv2ProtectedItems`, `ASRv2ReplicationVaults` |
| Azure Database for MySQL flexible servers | `microsoft.dbformysql/flexibleservers` | `MySqlAuditLogs`, `MySqlSlowLogs` | `AzureDiagnostics` |
| Azure Database for PostgreSQL flexible servers | `microsoft.dbforpostgresql/flexibleservers` | `PostgreSQLFlexDatabaseXacts`, `PostgreSQLFlexPGBouncer`, `PostgreSQLFlexQueryStoreRuntime`, `PostgreSQLFlexSessions`, `PostgreSQLLogs` | `AzureDiagnostics` |
| Azure Database for PostgreSQL server groups v2 | `microsoft.dbforpostgresql/servergroupsv2` | `PostgreSQLLogs` | `AzureDiagnostics` |
| DevOps infrastructure pools | `microsoft.devopsinfrastructure/pools` | `ProvisioningLogs` | `MDPResourceLog` |
| Azure Load Testing | `microsoft.loadtestservice/loadtests` | `OperationLogs` | `AzureLoadTestingOperation` |
| Network managers | `microsoft.network/networkmanagers` | `ConnectivityConfigurationChange`, `NetworkGroupMembershipChange`, `RuleCollectionChange` | `AVNMConnectivityConfigurationChange`, `AVNMNetworkGroupMembershipChange`, `AVNMRuleCollectionChange` |
| Network Cloud cluster managers | `microsoft.networkcloud/clustermanagers` | `ClusterManagerDeployOrUpgradeLogs` | `NCMClusterOperationsLogs` |
| Network Cloud storage appliances | `microsoft.networkcloud/storageappliances` | `StorageApplianceAlert`, `StorageApplianceAudit`, `StorageApplianceLogs` | `NCSStorageAlerts`, `NCSStorageLogs` |
| Azure traffic collectors | `microsoft.networkfunction/azuretrafficcollectors` | `ATCMicrosoftPeeringMetadata`, `ATCPrivatePeeringMetadata`, `ExpressRouteCircuitIpfix` | `ATCMicrosoftPeeringMetadata`, `ATCPrivatePeeringMetadata`, `ATCExpressRouteCircuitIpfix` |
| Service Networking traffic controllers | `microsoft.servicenetworking/trafficcontrollers` | `TrafficControllerAccessLog`, `TrafficControllerFirewallLog` | `AGCAccessLogs`, `AGCFirewallLogs` |
| Azure Managed Lustre | `microsoft.storagecache/amlfilesystems` | `AmlfsAuditEvent` | N/A |
| Azure HPC Cache | `microsoft.storagecache/caches` | `AscCacheOperationEvent`, `AscUpgradeEvent`, `AscWarningEvent` | `StorageCacheOperationEvents`, `StorageCacheWarningEvents` |
| Azure Storage Mover | `microsoft.storagemover/storagemovers` | `CopyLogsFailed`, `JobRunLogs` | `StorageMoverCopyLogsFailed`, `StorageMoverJobRunLogs` |
| NGINX deployments | `nginx.nginxplus/nginxdeployments` | `NginxLogs`, `NginxSecurityLogs`, `NginxUpstreamUpdateLogs` | `NGXOperationLogs`, `NGXSecurityLogs`, `NginxUpstreamUpdateLogs` |

## Supported regions

You can create platform telemetry DCRs and monitor resources in the following Azure regions. The DCR must be deployed in a supported region.

- Australia Central
- Australia East
- Australia Southeast
- Austria East
- Canada Central
- Canada East
- Central India
- Central US
- Central US EUAP
- Chile Central
- East Asia
- East US
- East US 2
- East US 2 EUAP
- Indonesia Central
- Italy North
- Japan East
- Japan West
- Jio India West
- Korea Central
- Korea South
- Malaysia West
- Mexico Central
- New Zealand North
- North Central US
- North Europe
- Norway East
- Poland Central
- South Africa North
- South Central US
- Southeast Asia
- Sweden Central
- Switzerland North
- Taiwan North
- UK South
- UK West
- West Central US
- West Europe
- West US
- West US 2
- West US 3

> [!NOTE]
> The DCR and destination resource must be in the same region. For Log Analytics workspace destinations, monitored resources can be in any supported region. For storage account and Event Hubs destinations, monitored resources must be in the same region as the DCR and destination.

## Related content

- [Collect platform logs with data collection rules](platform-logs-collect.md)
