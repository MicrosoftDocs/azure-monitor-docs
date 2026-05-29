---
title: Platform logs supported resource types and categories (Preview)
description: Reference for resource types, category streams, and destination tables supported for platform logs export by using data collection rules.
ms.topic: reference
ms.date: 05/28/2026
ms.custom: ai-assisted
---

# Platform logs supported resource types and categories (Preview)

This article lists resource types and category streams currently supported for platform telemetry export by using data collection rules (DCRs).

Use stream specifications in the format:

```text
<resource-provider>/<resource-type>:<category-or-Logs-Group-All>
```

Examples:

```text
microsoft.app/managedenvironments:Logs-Group-All
microsoft.dbformysql/flexibleservers:MySqlAuditLogs
```

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

## Related content

- [Collect platform logs with data collection rules](platform-logs-collect.md)
- [Supported log categories by resource type](../reference/supported-logs/logs-index.yml)
