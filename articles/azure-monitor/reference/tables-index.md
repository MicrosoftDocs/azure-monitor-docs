---
title: Azure Monitor Resource log / log analytics tables
description: Field definitions for Azure Monitor resource log / log analytics tables.
author: EdB-MSFT
ms.topic: reference
ms.service: azure-monitor
ms.date: 09/26/2024
ms.author: edbaynash
ms.reviewer: lualderm

---

# Azure Monitor Resource log / log analytics tables

[Azure Monitor resource logs](/azure/azure-monitor/essentials/platform-logs-overview) are logs emitted by Azure services that describe the operation of those services or resources. All resource logs available through Azure Monitor share a common top-level schema. Each service has the flexibility to emit unique properties for its own events. When exported to a [Log Analytics workspace](/azure/azure-monitor/logs/log-analytics-workspace-overview) the logs are stored in tables. This set of articles contains field definitions for the log analytics tables. The table definitions are also available in the Log Analytics workspace.  

## Resource log / log analytics tables


### Analysis Services  

microsoft.analysisservices/servers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### API Management services  

Microsoft.ApiManagement/service  

- [APIMDevPortalAuditDiagnosticLog](./tables/apimdevportalauditdiagnosticlog.md)
- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [ApiManagementGatewayLogs](./tables/apimanagementgatewaylogs.md)
- [ApiManagementWebSocketConnectionLogs](./tables/apimanagementwebsocketconnectionlogs.md)

### App Services  

Microsoft.Web/sites  

- [AzureActivity](./tables/azureactivity.md)
- [LogicAppWorkflowRuntime](./tables/logicappworkflowruntime.md)
- [AppServiceAuthenticationLogs](./tables/appserviceauthenticationlogs.md)
- [AppServiceServerlessSecurityPluginData](./tables/appserviceserverlesssecurityplugindata.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AppServiceAppLogs](./tables/appserviceapplogs.md)
- [AppServiceAuditLogs](./tables/appserviceauditlogs.md)
- [AppServiceConsoleLogs](./tables/appserviceconsolelogs.md)
- [AppServiceFileAuditLogs](./tables/appservicefileauditlogs.md)
- [AppServiceHTTPLogs](./tables/appservicehttplogs.md)
- [FunctionAppLogs](./tables/functionapplogs.md)
- [AppServicePlatformLogs](./tables/appserviceplatformlogs.md)
- [AppServiceIPSecAuditLogs](./tables/appserviceipsecauditlogs.md)

### Application Gateway for Containers  

Microsoft.ServiceNetworking/TrafficControllers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AGCAccessLogs](./tables/agcaccesslogs.md)

### Application Gateways  

Microsoft.Network/applicationGateways  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AGWAccessLogs](./tables/agwaccesslogs.md)
- [AGWPerformanceLogs](./tables/agwperformancelogs.md)
- [AGWFirewallLogs](./tables/agwfirewalllogs.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Application Insights  

microsoft.insights/components  

- [AzureActivity](./tables/azureactivity.md)
- [AppAvailabilityResults](./tables/appavailabilityresults.md)
- [AppBrowserTimings](./tables/appbrowsertimings.md)
- [AppDependencies](./tables/appdependencies.md)
- [AppEvents](./tables/appevents.md)
- [AppMetrics](./tables/appmetrics.md)
- [AppPageViews](./tables/apppageviews.md)
- [AppPerformanceCounters](./tables/appperformancecounters.md)
- [AppRequests](./tables/apprequests.md)
- [AppSystemEvents](./tables/appsystemevents.md)
- [AppTraces](./tables/apptraces.md)
- [AppExceptions](./tables/appexceptions.md)

### Automation account  

Microsoft.Automation/AutomationAccounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [Heartbeat](./tables/heartbeat.md)
- [Update](./tables/update.md)
- [UpdateSummary](./tables/updatesummary.md)
- [UpdateRunProgress](./tables/updaterunprogress.md)

### AVS Private Cloud  

microsoft.avs/privateClouds  

- [AVSSyslog](./tables/avssyslog.md)

### Azure Active Directory Logs  

microsoft.aadiam/tenants  

- [AADB2CRequestLogs](./tables/aadb2crequestlogs.md)

### Azure AD Domain Services  

Microsoft.AAD/domainServices  

- [AzureActivity](./tables/azureactivity.md)
- [AADDomainServicesDNSAuditsDynamicUpdates](./tables/aaddomainservicesdnsauditsdynamicupdates.md)
- [AADDomainServicesDNSAuditsGeneral](./tables/aaddomainservicesdnsauditsgeneral.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AADDomainServicesAccountLogon](./tables/aaddomainservicesaccountlogon.md)
- [AADDomainServicesAccountManagement](./tables/aaddomainservicesaccountmanagement.md)
- [AADDomainServicesDirectoryServiceAccess](./tables/aaddomainservicesdirectoryserviceaccess.md)
- [AADDomainServicesLogonLogoff](./tables/aaddomainserviceslogonlogoff.md)
- [AADDomainServicesPolicyChange](./tables/aaddomainservicespolicychange.md)
- [AADDomainServicesPrivilegeUse](./tables/aaddomainservicesprivilegeuse.md)

### Azure API for FHIR  

Microsoft.HealthcareApis/services  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [MicrosoftHealthcareApisAuditLogs](./tables/microsofthealthcareapisauditlogs.md)

### Azure Arc Enabled Kubernetes  

Microsoft.Kubernetes/connectedClusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ContainerImageInventory](./tables/containerimageinventory.md)
- [ContainerInventory](./tables/containerinventory.md)
- [ContainerLog](./tables/containerlog.md)
- [ContainerLogV2](./tables/containerlogv2.md)
- [ContainerNodeInventory](./tables/containernodeinventory.md)
- [ContainerServiceLog](./tables/containerservicelog.md)
- [Heartbeat](./tables/heartbeat.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [KubeEvents](./tables/kubeevents.md)
- [KubeMonAgentEvents](./tables/kubemonagentevents.md)
- [KubeNodeInventory](./tables/kubenodeinventory.md)
- [KubePodInventory](./tables/kubepodinventory.md)
- [KubePVInventory](./tables/kubepvinventory.md)
- [KubeServices](./tables/kubeservices.md)
- [Perf](./tables/perf.md)
- [Syslog](./tables/syslog.md)
- [ArcK8sAudit](./tables/arck8saudit.md)
- [ArcK8sAuditAdmin](./tables/arck8sauditadmin.md)
- [ArcK8sControlPlane](./tables/arck8scontrolplane.md)

### Azure Arc Provisioned Clusters  

Microsoft.HybridContainerservice/Provisionedclusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ContainerImageInventory](./tables/containerimageinventory.md)
- [ContainerInventory](./tables/containerinventory.md)
- [ContainerLog](./tables/containerlog.md)
- [ContainerLogV2](./tables/containerlogv2.md)
- [ContainerNodeInventory](./tables/containernodeinventory.md)
- [ContainerServiceLog](./tables/containerservicelog.md)
- [KubeEvents](./tables/kubeevents.md)
- [KubeNodeInventory](./tables/kubenodeinventory.md)
- [KubePodInventory](./tables/kubepodinventory.md)
- [KubePVInventory](./tables/kubepvinventory.md)
- [KubeServices](./tables/kubeservices.md)
- [KubeMonAgentEvents](./tables/kubemonagentevents.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [Perf](./tables/perf.md)
- [Syslog](./tables/syslog.md)
- [Heartbeat](./tables/heartbeat.md)

### Azure Attestation  

Microsoft.Attestation/attestationProviders  

- [AzureActivity](./tables/azureactivity.md)
- [AzureAttestationDiagnostics](./tables/azureattestationdiagnostics.md)

### Azure Autonomous Development Platform workspace  

Microsoft.AutonomousDevelopmentPlatform/workspaces  

- [AzureActivity](./tables/azureactivity.md)
- [ADPRequests](./tables/adprequests.md)
- [ADPAudit](./tables/adpaudit.md)
- [ADPDiagnostics](./tables/adpdiagnostics.md)

### Azure Blockchain Service  

Microsoft.Blockchain/blockchainMembers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [BlockchainApplicationLog](./tables/blockchainapplicationlog.md)
- [BlockchainProxyLog](./tables/blockchainproxylog.md)

### Azure Cache for Redis  

microsoft.cache/redis  

- [ACRConnectedClientList](./tables/acrconnectedclientlist.md)
- [ACREntraAuthenticationAuditLog](./tables/acrentraauthenticationauditlog.md)
- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)

### Azure Cache for Redis Enterprise  

Microsoft.Cache/redisEnterprise  

- [REDConnectionEvents](./tables/redconnectionevents.md)

### Azure CloudHsm  

Microsoft.HardwareSecurityModules/cloudHsmClusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [CloudHsmServiceOperationAuditLogs](./tables/cloudhsmserviceoperationauditlogs.md)

### Azure Cosmos DB  

Microsoft.DocumentDb/databaseAccounts  

- [AzureActivity](./tables/azureactivity.md)
- [CDBDataPlaneRequests](./tables/cdbdataplanerequests.md)
- [CDBPartitionKeyStatistics](./tables/cdbpartitionkeystatistics.md)
- [CDBPartitionKeyRUConsumption](./tables/cdbpartitionkeyruconsumption.md)
- [CDBQueryRuntimeStatistics](./tables/cdbqueryruntimestatistics.md)
- [CDBMongoRequests](./tables/cdbmongorequests.md)
- [CDBCassandraRequests](./tables/cdbcassandrarequests.md)
- [CDBGremlinRequests](./tables/cdbgremlinrequests.md)
- [CDBTableApiRequests](./tables/cdbtableapirequests.md)
- [CDBControlPlaneRequests](./tables/cdbcontrolplanerequests.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Azure Cosmos DB for MongoDB (vCore)  

Microsoft.DocumentDB/mongoClusters  

- [VCoreMongoRequests](./tables/vcoremongorequests.md)

### Azure Cosmos DB for PostgreSQL  

Microsoft.DBForPostgreSQL/servergroupsv2  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AzureMetrics](./tables/azuremetrics.md)

### Azure Data Explorer Clusters  

Microsoft.Kusto/Clusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [FailedIngestion](./tables/failedingestion.md)
- [SucceededIngestion](./tables/succeededingestion.md)
- [ADXIngestionBatching](./tables/adxingestionbatching.md)
- [ADXCommand](./tables/adxcommand.md)
- [ADXQuery](./tables/adxquery.md)
- [ADXTableUsageStatistics](./tables/adxtableusagestatistics.md)
- [ADXTableDetails](./tables/adxtabledetails.md)
- [ADXJournal](./tables/adxjournal.md)

### Azure Data Manager for Energy  

Microsoft.OpenEnergyPlatform/energyServices  

- [OEPAirFlowTask](./tables/oepairflowtask.md)
- [OEPElasticOperator](./tables/oepelasticoperator.md)
- [OEPElasticsearch](./tables/oepelasticsearch.md)
- [OEPAuditLogs](./tables/oepauditlogs.md)
- [OEPDataplaneLogs](./tables/oepdataplanelogs.md)

### Azure Data Transfer  

Microsoft.AzureDataTransfer/connections  

- [DataTransferOperations](./tables/datatransferoperations.md)

### Azure Database for MariaDB Servers  

Microsoft.DBforMariaDB/servers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Azure Database for MySQL Flexible Servers  

Microsoft.DBForMySQL/flexibleServers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AzureMetrics](./tables/azuremetrics.md)

### Azure Database for MySQL Servers  

Microsoft.DBforMySQL/servers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Azure Database for PostgreSQL Flexible Servers  

Microsoft.DBForPostgreSQL/flexibleServers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AzureMetrics](./tables/azuremetrics.md)

### Azure Database for PostgreSQL Servers  

Microsoft.DBforPostgreSQL/servers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Azure Database for PostgreSQL Servers V2  

Microsoft.DBforPostgreSQL/serversv2  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Azure Databricks Services  

Microsoft.Databricks/workspaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [DatabricksBrickStoreHttpGateway](./tables/databricksbrickstorehttpgateway.md)
- [DatabricksDashboards](./tables/databricksdashboards.md)
- [DatabricksCloudStorageMetadata](./tables/databrickscloudstoragemetadata.md)
- [DatabricksPredictiveOptimization](./tables/databrickspredictiveoptimization.md)
- [DatabricksDataMonitoring](./tables/databricksdatamonitoring.md)
- [DatabricksIngestion](./tables/databricksingestion.md)
- [DatabricksMarketplaceConsumer](./tables/databricksmarketplaceconsumer.md)
- [DatabricksLineageTracking](./tables/databrickslineagetracking.md)
- [DatabricksFilesystem](./tables/databricksfilesystem.md)
- [DatabricksAccounts](./tables/databricksaccounts.md)
- [DatabricksClusters](./tables/databricksclusters.md)
- [DatabricksDBFS](./tables/databricksdbfs.md)
- [DatabricksInstancePools](./tables/databricksinstancepools.md)
- [DatabricksJobs](./tables/databricksjobs.md)
- [DatabricksNotebook](./tables/databricksnotebook.md)
- [DatabricksSQL](./tables/databrickssql.md)
- [DatabricksSQLPermissions](./tables/databrickssqlpermissions.md)
- [DatabricksSSH](./tables/databricksssh.md)
- [DatabricksSecrets](./tables/databrickssecrets.md)
- [DatabricksWorkspace](./tables/databricksworkspace.md)
- [DatabricksFeatureStore](./tables/databricksfeaturestore.md)
- [DatabricksGenie](./tables/databricksgenie.md)
- [DatabricksGlobalInitScripts](./tables/databricksglobalinitscripts.md)
- [DatabricksIAMRole](./tables/databricksiamrole.md)
- [DatabricksMLflowAcledArtifact](./tables/databricksmlflowacledartifact.md)
- [DatabricksMLflowExperiment](./tables/databricksmlflowexperiment.md)
- [DatabricksRemoteHistoryService](./tables/databricksremotehistoryservice.md)
- [DatabricksGitCredentials](./tables/databricksgitcredentials.md)
- [DatabricksWebTerminal](./tables/databrickswebterminal.md)
- [DatabricksDatabricksSQL](./tables/databricksdatabrickssql.md)

### Azure Digital Twins  

Microsoft.DigitalTwins/digitalTwinsInstances  

- [AzureActivity](./tables/azureactivity.md)
- [ADTDataHistoryOperation](./tables/adtdatahistoryoperation.md)
- [ADTDigitalTwinsOperation](./tables/adtdigitaltwinsoperation.md)
- [ADTEventRoutesOperation](./tables/adteventroutesoperation.md)
- [ADTModelsOperation](./tables/adtmodelsoperation.md)
- [ADTQueryOperation](./tables/adtqueryoperation.md)

### Azure Health Data Services de-identification service  

Microsoft.HealthDataAIServices/deidServices  

- [AHDSDeidAuditLogs](./tables/ahdsdeidauditlogs.md)

### Azure HPC Cache  

Microsoft.StorageCache/caches  

- [StorageCacheOperationEvents](./tables/storagecacheoperationevents.md)
- [StorageCacheUpgradeEvents](./tables/storagecacheupgradeevents.md)
- [StorageCacheWarningEvents](./tables/storagecachewarningevents.md)

### Azure Load Testing  

Microsoft.LoadTestService/loadtests  

- [AzureActivity](./tables/azureactivity.md)
- [AzureLoadTestingOperation](./tables/azureloadtestingoperation.md)

### Azure Managed CCF  

Microsoft.ConfidentialLedger/ManagedCCFs  

- [CCFApplicationLogs](./tables/ccfapplicationlogs.md)

### Azure Managed Instance for Apache Cassandra  

Microsoft.DocumentDB/cassandraClusters  

- [AzureActivity](./tables/azureactivity.md)
- [CassandraAudit](./tables/cassandraaudit.md)
- [CassandraLogs](./tables/cassandralogs.md)

### Azure Managed Lustre  

Microsoft.StorageCache/amlFilesytems  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AFSAuditLogs](./tables/afsauditlogs.md)

### Azure Managed Workspace for Grafana  

Microsoft.Dashboard/grafana  

- [AzureActivity](./tables/azureactivity.md)
- [AGSGrafanaLoginEvents](./tables/agsgrafanaloginevents.md)

### Azure Monitor autoscale settings  

Microsoft.Insights/AutoscaleSettings  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AutoscaleEvaluationsLog](./tables/autoscaleevaluationslog.md)
- [AutoscaleScaleActionsLog](./tables/autoscalescaleactionslog.md)

### Azure Monitor Workspace  

Microsoft.Monitor/accounts  

- [AMWMetricsUsageDetails](./tables/amwmetricsusagedetails.md)

### Azure Operator Insights - Data Product  

Microsoft.NetworkAnalytics/DataProducts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AOIDigestion](./tables/aoidigestion.md)
- [AOIDatabaseQuery](./tables/aoidatabasequery.md)
- [AOIStorage](./tables/aoistorage.md)

### Azure PlayFab  

Microsoft.PlayFab/titles  

- [PFTitleAuditLogs](./tables/pftitleauditlogs.md)

### Azure Sentinel  

microsoft.securityinsights  

- [SecurityAlert](./tables/securityalert.md)
- [SecurityEvent](./tables/securityevent.md)
- [DnsAuditEvents](./tables/dnsauditevents.md)
- [CommonSecurityLog](./tables/commonsecuritylog.md)
- [ASimWebSessionLogs](./tables/asimwebsessionlogs.md)
- [PurviewDataSensitivityLogs](./tables/purviewdatasensitivitylogs.md)
- [ASimDhcpEventLogs](./tables/asimdhcpeventlogs.md)
- [ASimFileEventLogs](./tables/asimfileeventlogs.md)
- [ASimUserManagementActivityLogs](./tables/asimusermanagementactivitylogs.md)
- [ASimRegistryEventLogs](./tables/asimregistryeventlogs.md)
- [ASimAuditEventLogs](./tables/asimauditeventlogs.md)
- [ASimAuthenticationEventLogs](./tables/asimauthenticationeventlogs.md)
- [ASimDnsActivityLogs](./tables/asimdnsactivitylogs.md)
- [ASimNetworkSessionLogs](./tables/asimnetworksessionlogs.md)
- [ASimProcessEventLogs](./tables/asimprocesseventlogs.md)
- [ThreatIntelObjects](./tables/threatintelobjects.md)
- [ThreatIntelIndicators](./tables/threatintelindicators.md)

### Azure Sphere  

Microsoft.AzureSphere/catalogs  

- [ASCAuditLogs](./tables/ascauditlogs.md)
- [ASCDeviceEvents](./tables/ascdeviceevents.md)

### Azure Spring Apps  

Microsoft.AppPlatform/Spring  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AppPlatformLogsforSpring](./tables/appplatformlogsforspring.md)
- [AppPlatformSystemLogs](./tables/appplatformsystemlogs.md)
- [AppPlatformIngressLogs](./tables/appplatformingresslogs.md)
- [AppPlatformBuildLogs](./tables/appplatformbuildlogs.md)
- [AppPlatformContainerEventLogs](./tables/appplatformcontainereventlogs.md)

### Azure Stack HCI  

Microsoft.AzureStackHCI/VirtualMachines  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ADAssessmentRecommendation](./tables/adassessmentrecommendation.md)
- [ADReplicationResult](./tables/adreplicationresult.md)
- [ComputerGroup](./tables/computergroup.md)
- [ContainerLog](./tables/containerlog.md)
- [DnsEvents](./tables/dnsevents.md)
- [DnsInventory](./tables/dnsinventory.md)
- [SecurityBaselineSummary](./tables/securitybaselinesummary.md)
- [SQLAssessmentRecommendation](./tables/sqlassessmentrecommendation.md)
- [ConfigurationChange](./tables/configurationchange.md)
- [ConfigurationData](./tables/configurationdata.md)
- [Event](./tables/event.md)
- [Heartbeat](./tables/heartbeat.md)
- [Perf](./tables/perf.md)
- [ProtectionStatus](./tables/protectionstatus.md)
- [SecurityBaseline](./tables/securitybaseline.md)
- [SecurityEvent](./tables/securityevent.md)
- [Syslog](./tables/syslog.md)
- [Update](./tables/update.md)
- [UpdateRunProgress](./tables/updaterunprogress.md)
- [UpdateSummary](./tables/updatesummary.md)
- [VMBoundPort](./tables/vmboundport.md)
- [VMConnection](./tables/vmconnection.md)
- [VMComputer](./tables/vmcomputer.md)
- [VMProcess](./tables/vmprocess.md)
- [W3CIISLog](./tables/w3ciislog.md)
- [WindowsFirewall](./tables/windowsfirewall.md)
- [WireData](./tables/wiredata.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [HealthStateChangeEvent](./tables/healthstatechangeevent.md)
- [CommonSecurityLog](./tables/commonsecuritylog.md)

### Azure Stack HCI  

Microsoft.AzureStackHCI/clusters  

- [Perf](./tables/perf.md)
- [Event](./tables/event.md)

### Azure Storage Mover  

Microsoft.StorageMover/storageMovers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [StorageMoverCopyLogsFailed](./tables/storagemovercopylogsfailed.md)
- [StorageMoverCopyLogsTransferred](./tables/storagemovercopylogstransferred.md)
- [StorageMoverJobRunLogs](./tables/storagemoverjobrunlogs.md)

### Azure Traffic Collector  

Microsoft.NetworkFunction/AzureTrafficCollectors  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ATCExpressRouteCircuitIpfix](./tables/atcexpressroutecircuitipfix.md)
- [ATCPrivatePeeringMetadata](./tables/atcprivatepeeringmetadata.md)

### Azure Virtual Network Manager  

Microsoft.Network/networkManagers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AVNMNetworkGroupMembershipChange](./tables/avnmnetworkgroupmembershipchange.md)
- [AVNMRuleCollectionChange](./tables/avnmrulecollectionchange.md)
- [AVNMConnectivityConfigurationChange](./tables/avnmconnectivityconfigurationchange.md)
- [AVNMIPAMPoolAllocationChange](./tables/avnmipampoolallocationchange.md)

### Bastions  

Microsoft.Network/bastionHosts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [MicrosoftAzureBastionAuditLogs](./tables/microsoftazurebastionauditlogs.md)

### Batch Accounts  

microsoft.batch/batchaccounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Bot Services  

Microsoft.BotService/botServices  

- [AzureActivity](./tables/azureactivity.md)
- [ABSBotRequests](./tables/absbotrequests.md)

### CDN Profiles  

Microsoft.Cdn/profiles  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Chaos Experiment  

Microsoft.Chaos/experiments  

- [AzureActivity](./tables/azureactivity.md)
- [ChaosStudioExperimentEventLogs](./tables/chaosstudioexperimenteventlogs.md)

### Cognitive Services  

microsoft.cognitiveservices/accounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Communication Services  

Microsoft.Communication/CommunicationServices  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ACSChatIncomingOperations](./tables/acschatincomingoperations.md)
- [ACSSMSIncomingOperations](./tables/acssmsincomingoperations.md)
- [ACSAuthIncomingOperations](./tables/acsauthincomingoperations.md)
- [ACSBillingUsage](./tables/acsbillingusage.md)
- [ACSCallDiagnostics](./tables/acscalldiagnostics.md)
- [ACSCallSurvey](./tables/acscallsurvey.md)
- [ACSCallClientOperations](./tables/acscallclientoperations.md)
- [ACSCallClientMediaStatsTimeSeries](./tables/acscallclientmediastatstimeseries.md)
- [ACSCallSummary](./tables/acscallsummary.md)
- [ACSEmailSendMailOperational](./tables/acsemailsendmailoperational.md)
- [ACSEmailStatusUpdateOperational](./tables/acsemailstatusupdateoperational.md)
- [ACSEmailUserEngagementOperational](./tables/acsemailuserengagementoperational.md)
- [ACSCallRecordingIncomingOperations](./tables/acscallrecordingincomingoperations.md)
- [ACSCallRecordingSummary](./tables/acscallrecordingsummary.md)
- [ACSCallClosedCaptionsSummary](./tables/acscallclosedcaptionssummary.md)
- [ACSJobRouterIncomingOperations](./tables/acsjobrouterincomingoperations.md)
- [ACSRoomsIncomingOperations](./tables/acsroomsincomingoperations.md)
- [ACSCallAutomationIncomingOperations](./tables/acscallautomationincomingoperations.md)
- [ACSCallAutomationMediaSummary](./tables/acscallautomationmediasummary.md)
- [ACSAdvancedMessagingOperations](./tables/acsadvancedmessagingoperations.md)

### Container Apps  

Microsoft.App/managedEnvironments  

- [AzureActivity](./tables/azureactivity.md)
- [ContainerAppConsoleLogs](./tables/containerappconsolelogs.md)
- [ContainerAppSystemLogs](./tables/containerappsystemlogs.md)
- [AppEnvSpringAppConsoleLogs](./tables/appenvspringappconsolelogs.md)

### Container Registries  

Microsoft.ContainerRegistry/registries  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ContainerRegistryLoginEvents](./tables/containerregistryloginevents.md)
- [ContainerRegistryRepositoryEvents](./tables/containerregistryrepositoryevents.md)

### Data Collection Rules  

Microsoft.Insights/datacollectionrules  

- [DCRLogErrors](./tables/dcrlogerrors.md)

### Data factories  

Microsoft.DataFactory/factories  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [ADFActivityRun](./tables/adfactivityrun.md)
- [ADFPipelineRun](./tables/adfpipelinerun.md)
- [ADFTriggerRun](./tables/adftriggerrun.md)
- [ADFSandboxActivityRun](./tables/adfsandboxactivityrun.md)
- [ADFSandboxPipelineRun](./tables/adfsandboxpipelinerun.md)
- [ADFSSISIntegrationRuntimeLogs](./tables/adfssisintegrationruntimelogs.md)
- [ADFSSISPackageEventMessageContext](./tables/adfssispackageeventmessagecontext.md)
- [ADFSSISPackageEventMessages](./tables/adfssispackageeventmessages.md)
- [ADFSSISPackageExecutableStatistics](./tables/adfssispackageexecutablestatistics.md)
- [ADFSSISPackageExecutionComponentPhases](./tables/adfssispackageexecutioncomponentphases.md)
- [ADFSSISPackageExecutionDataStatistics](./tables/adfssispackageexecutiondatastatistics.md)

### Data Lake Analytics  

Microsoft.DataLakeAnalytics/accounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Data Lake Storage Gen1  

Microsoft.DataLakeStore/accounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Data Share  

Microsoft.DataShare/accounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [MicrosoftDataShareSentSnapshotLog](./tables/microsoftdatasharesentsnapshotlog.md)
- [MicrosoftDataShareReceivedSnapshotLog](./tables/microsoftdatasharereceivedsnapshotlog.md)

### Defender for Storage Settings  

Microsoft.Security/DefenderForStorageSettings  

- [StorageMalwareScanningResults](./tables/storagemalwarescanningresults.md)

### Desktop Virtualization Application Groups  

Microsoft.DesktopVirtualization/applicationGroups  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [WVDErrors](./tables/wvderrors.md)
- [WVDCheckpoints](./tables/wvdcheckpoints.md)
- [WVDManagement](./tables/wvdmanagement.md)

### Desktop Virtualization Host Pools  

Microsoft.DesktopVirtualization/hostPools  

- [WVDAgentHealthStatus](./tables/wvdagenthealthstatus.md)
- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [WVDConnections](./tables/wvdconnections.md)
- [WVDErrors](./tables/wvderrors.md)
- [WVDCheckpoints](./tables/wvdcheckpoints.md)
- [WVDManagement](./tables/wvdmanagement.md)
- [WVDHostRegistrations](./tables/wvdhostregistrations.md)
- [WVDConnectionNetworkData](./tables/wvdconnectionnetworkdata.md)
- [WVDSessionHostManagement](./tables/wvdsessionhostmanagement.md)
- [WVDAutoscaleEvaluationPooled](./tables/wvdautoscaleevaluationpooled.md)
- [WVDConnectionGraphicsDataPreview](./tables/wvdconnectiongraphicsdatapreview.md)

### Desktop Virtualization workspaces  

Microsoft.DesktopVirtualization/workspaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [WVDFeeds](./tables/wvdfeeds.md)
- [WVDErrors](./tables/wvderrors.md)
- [WVDCheckpoints](./tables/wvdcheckpoints.md)
- [WVDManagement](./tables/wvdmanagement.md)

### Dev Centers  

Microsoft.DevCenter/devcenters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [DevCenterDiagnosticLogs](./tables/devcenterdiagnosticlogs.md)
- [DevCenterResourceOperationLogs](./tables/devcenterresourceoperationlogs.md)
- [DevCenterBillingEventLogs](./tables/devcenterbillingeventlogs.md)

### Device Provisioning Services  

Microsoft.Devices/ProvisioningServices  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### DNS Resolver Policies  

Microsoft.Network/dnsResolverPolicies  

- [AzureActivity](./tables/azureactivity.md)
- [DNSQueryLogs](./tables/dnsquerylogs.md)

### Dynamics 365 Customer Insights  

Microsoft.D365CustomerInsights/instances  

- [AzureActivity](./tables/azureactivity.md)
- [CIEventsAudit](./tables/cieventsaudit.md)
- [CIEventsOperational](./tables/cieventsoperational.md)

### Event Grid Domains  

Microsoft.EventGrid/domains  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AegDeliveryFailureLogs](./tables/aegdeliveryfailurelogs.md)
- [AegPublishFailureLogs](./tables/aegpublishfailurelogs.md)
- [AegDataPlaneRequests](./tables/aegdataplanerequests.md)

### Event Grid Namespaces  

Microsoft.EventGrid/namespaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [EGNSuccessfulMqttConnections](./tables/egnsuccessfulmqttconnections.md)
- [EGNFailedMqttConnections](./tables/egnfailedmqttconnections.md)
- [EGNMqttDisconnections](./tables/egnmqttdisconnections.md)
- [EGNFailedMqttPublishedMessages](./tables/egnfailedmqttpublishedmessages.md)
- [EGNFailedMqttSubscriptions](./tables/egnfailedmqttsubscriptions.md)
- [EGNSuccessfulHttpDataPlaneOperations](./tables/egnsuccessfulhttpdataplaneoperations.md)
- [EGNFailedHttpDataPlaneOperations](./tables/egnfailedhttpdataplaneoperations.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Event Grid Partner Namespaces  

Microsoft.EventGrid/partnerNamespaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AegPublishFailureLogs](./tables/aegpublishfailurelogs.md)
- [AegDataPlaneRequests](./tables/aegdataplanerequests.md)

### Event Grid Partner Topics  

Microsoft.EventGrid/partnerTopics  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AegDeliveryFailureLogs](./tables/aegdeliveryfailurelogs.md)

### Event Grid System Topics  

Microsoft.EventGrid/systemTopics  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AegDeliveryFailureLogs](./tables/aegdeliveryfailurelogs.md)

### Event Grid Topics  

Microsoft.EventGrid/topics  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AegDataPlaneRequests](./tables/aegdataplanerequests.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AegDeliveryFailureLogs](./tables/aegdeliveryfailurelogs.md)
- [AegPublishFailureLogs](./tables/aegpublishfailurelogs.md)

### Event Hubs  

Microsoft.EventHub/namespaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AZMSApplicationMetricLogs](./tables/azmsapplicationmetriclogs.md)
- [AZMSOperationalLogs](./tables/azmsoperationallogs.md)
- [AZMSRunTimeAuditLogs](./tables/azmsruntimeauditlogs.md)
- [AZMSDiagnosticErrorLogs](./tables/azmsdiagnosticerrorlogs.md)
- [AZMSVnetConnectionEvents](./tables/azmsvnetconnectionevents.md)
- [AZMSArchiveLogs](./tables/azmsarchivelogs.md)
- [AZMSAutoscaleLogs](./tables/azmsautoscalelogs.md)
- [AZMSKafkaCoordinatorLogs](./tables/azmskafkacoordinatorlogs.md)
- [AZMSKafkaUserErrorLogs](./tables/azmskafkausererrorlogs.md)
- [AZMSCustomerManagedKeyUserLogs](./tables/azmscustomermanagedkeyuserlogs.md)

### Experiment Workspace  

Microsoft.Experimentation/experimentWorkspaces  

- [AzureActivity](./tables/azureactivity.md)
- [AEWAuditLogs](./tables/aewauditlogs.md)
- [AEWComputePipelinesLogs](./tables/aewcomputepipelineslogs.md)
- [AEWAssignmentBlobLogs](./tables/aewassignmentbloblogs.md)

### ExpressRoute Circuits  

Microsoft.Network/expressRouteCircuits  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Firewalls  

Microsoft.Network/azureFirewalls  

- [AZFWNetworkRule](./tables/azfwnetworkrule.md)
- [AZFWFatFlow](./tables/azfwfatflow.md)
- [AZFWFlowTrace](./tables/azfwflowtrace.md)
- [AZFWApplicationRule](./tables/azfwapplicationrule.md)
- [AZFWThreatIntel](./tables/azfwthreatintel.md)
- [AZFWNatRule](./tables/azfwnatrule.md)
- [AZFWIdpsSignature](./tables/azfwidpssignature.md)
- [AZFWDnsQuery](./tables/azfwdnsquery.md)
- [AZFWInternalFqdnResolutionFailure](./tables/azfwinternalfqdnresolutionfailure.md)
- [AZFWNetworkRuleAggregation](./tables/azfwnetworkruleaggregation.md)
- [AZFWApplicationRuleAggregation](./tables/azfwapplicationruleaggregation.md)
- [AZFWNatRuleAggregation](./tables/azfwnatruleaggregation.md)
- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Front Doors  

Microsoft.Network/frontdoors  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### HDInsight Clusters  

Microsoft.HDInsight/Clusters  

- [AzureActivity](./tables/azureactivity.md)
- [HDInsightKafkaLogs](./tables/hdinsightkafkalogs.md)
- [HDInsightKafkaMetrics](./tables/hdinsightkafkametrics.md)
- [HDInsightHBaseLogs](./tables/hdinsighthbaselogs.md)
- [HDInsightHBaseMetrics](./tables/hdinsighthbasemetrics.md)
- [HDInsightStormLogs](./tables/hdinsightstormlogs.md)
- [HDInsightStormMetrics](./tables/hdinsightstormmetrics.md)
- [HDInsightStormTopologyMetrics](./tables/hdinsightstormtopologymetrics.md)
- [HDInsightGatewayAuditLogs](./tables/hdinsightgatewayauditlogs.md)
- [HDInsightAmbariSystemMetrics](./tables/hdinsightambarisystemmetrics.md)
- [HDInsightAmbariClusterAlerts](./tables/hdinsightambariclusteralerts.md)
- [HDInsightSparkApplicationEvents](./tables/hdinsightsparkapplicationevents.md)
- [HDInsightSparkBlockManagerEvents](./tables/hdinsightsparkblockmanagerevents.md)
- [HDInsightSparkEnvironmentEvents](./tables/hdinsightsparkenvironmentevents.md)
- [HDInsightJupyterNotebookEvents](./tables/hdinsightjupyternotebookevents.md)
- [HDInsightSparkExecutorEvents](./tables/hdinsightsparkexecutorevents.md)
- [HDInsightSparkExtraEvents](./tables/hdinsightsparkextraevents.md)
- [HDInsightSparkJobEvents](./tables/hdinsightsparkjobevents.md)
- [HDInsightSparkSQLExecutionEvents](./tables/hdinsightsparksqlexecutionevents.md)
- [HDInsightSparkStageEvents](./tables/hdinsightsparkstageevents.md)
- [HDInsightSparkStageTaskAccumulables](./tables/hdinsightsparkstagetaskaccumulables.md)
- [HDInsightSparkTaskEvents](./tables/hdinsightsparktaskevents.md)
- [HDInsightSparkLogs](./tables/hdinsightsparklogs.md)
- [HDInsightSecurityLogs](./tables/hdinsightsecuritylogs.md)
- [HDInsightRangerAuditLogs](./tables/hdinsightrangerauditlogs.md)
- [HDInsightHiveAndLLAPLogs](./tables/hdinsighthiveandllaplogs.md)
- [HDInsightHiveAndLLAPMetrics](./tables/hdinsighthiveandllapmetrics.md)
- [HDInsightHadoopAndYarnLogs](./tables/hdinsighthadoopandyarnlogs.md)
- [HDInsightHadoopAndYarnMetrics](./tables/hdinsighthadoopandyarnmetrics.md)
- [HDInsightOozieLogs](./tables/hdinsightoozielogs.md)
- [HDInsightHiveQueryAppStats](./tables/hdinsighthivequeryappstats.md)
- [HDInsightHiveTezAppStats](./tables/hdinsighthivetezappstats.md)

### Health Data Services  

Microsoft.HealthcareApis/workspaces  

- [AHDSMedTechDiagnosticLogs](./tables/ahdsmedtechdiagnosticlogs.md)
- [AHDSDicomDiagnosticLogs](./tables/ahdsdicomdiagnosticlogs.md)
- [AHDSDicomAuditLogs](./tables/ahdsdicomauditlogs.md)

### Integration Account.  

Microsoft.Logic/integrationAccounts  

- [AzureActivity](./tables/azureactivity.md)

### Intune Specialist Reports.  

microsoft.intune/operations  

- [Windows365AuditLogs](./tables/windows365auditlogs.md)

### IoT Hub  

Microsoft.Devices/IotHubs  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [IoTHubDistributedTracing](./tables/iothubdistributedtracing.md)
- [InsightsMetrics](./tables/insightsmetrics.md)

### Key Vaults  

Microsoft.KeyVault/vaults  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AZKVAuditLogs](./tables/azkvauditlogs.md)
- [AZKVPolicyEvaluationDetailsLogs](./tables/azkvpolicyevaluationdetailslogs.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Kubernetes Services  

Microsoft.ContainerService/managedClusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ContainerImageInventory](./tables/containerimageinventory.md)
- [ContainerInventory](./tables/containerinventory.md)
- [ContainerLog](./tables/containerlog.md)
- [ContainerLogV2](./tables/containerlogv2.md)
- [ContainerNodeInventory](./tables/containernodeinventory.md)
- [ContainerServiceLog](./tables/containerservicelog.md)
- [Heartbeat](./tables/heartbeat.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [KubeEvents](./tables/kubeevents.md)
- [KubeMonAgentEvents](./tables/kubemonagentevents.md)
- [KubeNodeInventory](./tables/kubenodeinventory.md)
- [KubePodInventory](./tables/kubepodinventory.md)
- [KubePVInventory](./tables/kubepvinventory.md)
- [KubeServices](./tables/kubeservices.md)
- [Perf](./tables/perf.md)
- [Syslog](./tables/syslog.md)
- [AKSAudit](./tables/aksaudit.md)
- [AKSAuditAdmin](./tables/aksauditadmin.md)
- [AKSControlPlane](./tables/akscontrolplane.md)

### Load Balancers  

Microsoft.Network/LoadBalancers  

- [ALBHealthEvent](./tables/albhealthevent.md)
- [AzureActivity](./tables/azureactivity.md)

### Log Analytics workspaces  

Microsoft.OperationalInsights/Workspaces  

- [LAQueryLogs](./tables/laquerylogs.md)
- [LASummaryLogs](./tables/lasummarylogs.md)
- [AzureMetricsV2](./tables/azuremetricsv2.md)

### Logic Apps  

Microsoft.Logic/workflows  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [LogicAppWorkflowRuntime](./tables/logicappworkflowruntime.md)

### Machine Learning  

Microsoft.MachineLearningServices/workspaces  

- [AzureActivity](./tables/azureactivity.md)
- [AmlOnlineEndpointConsoleLog](./tables/amlonlineendpointconsolelog.md)
- [AmlOnlineEndpointTrafficLog](./tables/amlonlineendpointtrafficlog.md)
- [AmlOnlineEndpointEventLog](./tables/amlonlineendpointeventlog.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AmlComputeClusterEvent](./tables/amlcomputeclusterevent.md)
- [AmlComputeClusterNodeEvent](./tables/amlcomputeclusternodeevent.md)
- [AmlComputeJobEvent](./tables/amlcomputejobevent.md)
- [AmlRunStatusChangedEvent](./tables/amlrunstatuschangedevent.md)
- [AmlComputeCpuGpuUtilization](./tables/amlcomputecpugpuutilization.md)
- [AmlComputeInstanceEvent](./tables/amlcomputeinstanceevent.md)
- [AmlDataLabelEvent](./tables/amldatalabelevent.md)
- [AmlDataSetEvent](./tables/amldatasetevent.md)
- [AmlDataStoreEvent](./tables/amldatastoreevent.md)
- [AmlDeploymentEvent](./tables/amldeploymentevent.md)
- [AmlEnvironmentEvent](./tables/amlenvironmentevent.md)
- [AmlInferencingEvent](./tables/amlinferencingevent.md)
- [AmlModelsEvent](./tables/amlmodelsevent.md)
- [AmlPipelineEvent](./tables/amlpipelineevent.md)
- [AmlRunEvent](./tables/amlrunevent.md)

### Machine Learning  

Microsoft.MachineLearningServices/registries  

- [AzureActivity](./tables/azureactivity.md)
- [AmlRegistryReadEventsLog](./tables/amlregistryreadeventslog.md)
- [AmlRegistryWriteEventsLog](./tables/amlregistrywriteeventslog.md)

### Media Services  

Microsoft.Media/mediaservices  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AMSKeyDeliveryRequests](./tables/amskeydeliveryrequests.md)
- [AMSMediaAccountHealth](./tables/amsmediaaccounthealth.md)
- [AMSLiveEventOperations](./tables/amsliveeventoperations.md)
- [AMSStreamingEndpointRequests](./tables/amsstreamingendpointrequests.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Microsoft App Configuration  

Microsoft.AppConfiguration/configurationStores  

- [AzureActivity](./tables/azureactivity.md)
- [AACHttpRequest](./tables/aachttprequest.md)
- [AACAudit](./tables/aacaudit.md)

### Microsoft Connected Cache  

Microsoft.ConnectedCache/CacheNodes  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [MCCEventLogs](./tables/mcceventlogs.md)

### Microsoft Connected Vehicle Platform  

Microsoft.ConnectedVehicle/platformAccounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [MCVPOperationLogs](./tables/mcvpoperationlogs.md)
- [MCVPAuditLogs](./tables/mcvpauditlogs.md)

### Microsoft Container Instances Services  

Microsoft.ContainerInstance/containerGroups  

- [ContainerInstanceLog](./tables/containerinstancelog.md)
- [ContainerEvent](./tables/containerevent.md)

### Microsoft Defender for Cloud  

Microsoft.Security/Security  

- [SecurityAttackPathData](./tables/securityattackpathdata.md)

### Microsoft Graph Logs  

Microsoft.Graph/tenants  

- [AzureActivity](./tables/azureactivity.md)
- [SigninLogs](./tables/signinlogs.md)
- [AuditLogs](./tables/auditlogs.md)

### Microsoft Playwright Testing  

Microsoft.AzurePlaywrightService/accounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)

### Microsoft.AgFoodPlatform/farmBeats  

Microsoft.AgFoodPlatform/farmBeats  

- [AgriFoodFarmManagementLogs](./tables/agrifoodfarmmanagementlogs.md)
- [AgriFoodWeatherLogs](./tables/agrifoodweatherlogs.md)
- [AgriFoodSatelliteLogs](./tables/agrifoodsatellitelogs.md)
- [AgriFoodFarmOperationLogs](./tables/agrifoodfarmoperationlogs.md)
- [AgriFoodProviderAuthLogs](./tables/agrifoodproviderauthlogs.md)
- [AgriFoodApplicationAuditLogs](./tables/agrifoodapplicationauditlogs.md)
- [AgriFoodModelInferenceLogs](./tables/agrifoodmodelinferencelogs.md)
- [AgriFoodInsightLogs](./tables/agrifoodinsightlogs.md)
- [AgriFoodJobProcessedLogs](./tables/agrifoodjobprocessedlogs.md)
- [AgriFoodSensorManagementLogs](./tables/agrifoodsensormanagementlogs.md)

### Microsoft.OpenLogisticsPlatform/Workspaces  

Microsoft.OpenLogisticsPlatform/Workspaces  

- [OLPSupplyChainEvents](./tables/olpsupplychainevents.md)
- [OLPSupplyChainEntityOperations](./tables/olpsupplychainentityoperations.md)

### Microsoft.Purview/accounts  

Microsoft.Purview/accounts  

- [AzureActivity](./tables/azureactivity.md)
- [PurviewScanStatusLogs](./tables/purviewscanstatuslogs.md)
- [PurviewDataSensitivityLogs](./tables/purviewdatasensitivitylogs.md)
- [PurviewSecurityLogs](./tables/purviewsecuritylogs.md)

### Network Devices (Operator Nexus)  

Microsoft.ManagedNetworkFabric/networkDevices  

- [Azuremetrics](./tables/azuremetrics.md)
- [AzureActivity](./tables/azureactivity.md)
- [MNFDeviceUpdates](./tables/mnfdeviceupdates.md)
- [MNFSystemStateMessageUpdates](./tables/mnfsystemstatemessageupdates.md)
- [MNFSystemSessionHistoryUpdates](./tables/mnfsystemsessionhistoryupdates.md)

### Network Interfaces  

Microsoft.Network/networkinterfaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Network Security Groups  

Microsoft.Network/NetworkSecurityGroups  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Network Security Perimeters  

Microsoft.Network/NetworkSecurityPerimeters  

- [NSPAccessLogs](./tables/nspaccesslogs.md)

### Network Watcher - Connection Monitor  

Microsoft.Network/NetworkWatchers/Connectionmonitors  

- [AzureActivity](./tables/azureactivity.md)
- [NWConnectionMonitorTestResult](./tables/nwconnectionmonitortestresult.md)
- [NWConnectionMonitorPathResult](./tables/nwconnectionmonitorpathresult.md)
- [NWConnectionMonitorDNSResult](./tables/nwconnectionmonitordnsresult.md)

### Nexus BareMetal Machines  

Microsoft.NetworkCloud/bareMetalMachines  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [NCBMSystemLogs](./tables/ncbmsystemlogs.md)
- [NCBMSecurityLogs](./tables/ncbmsecuritylogs.md)
- [NCBMSecurityDefenderLogs](./tables/ncbmsecuritydefenderlogs.md)
- [NCBMBreakGlassAuditLogs](./tables/ncbmbreakglassauditlogs.md)

### Nexus Cluster Managers  

Microsoft.NetworkCloud/clusterManagers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [NCMClusterOperationsLogs](./tables/ncmclusteroperationslogs.md)

### Nexus Clusters  

Microsoft.NetworkCloud/clusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [NCCKubernetesLogs](./tables/ncckuberneteslogs.md)
- [NCCVMOrchestrationLogs](./tables/nccvmorchestrationlogs.md)

### Nexus Storage Appliances  

Microsoft.NetworkCloud/storageAppliances  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [NCSStorageAudits](./tables/ncsstorageaudits.md)
- [NCSStorageAlerts](./tables/ncsstoragealerts.md)
- [NCSStorageLogs](./tables/ncsstoragelogs.md)

### NGINXaaS  

NGINX.NGINXPLUS/nginxDeployments  

- [NGXOperationLogs](./tables/ngxoperationlogs.md)
- [NGXSecurityLogs](./tables/ngxsecuritylogs.md)

### Power BI Datasets  

Microsoft.PowerBI/tenants  

- [PowerBIDatasetsTenant](./tables/powerbidatasetstenant.md)

### Power BI Datasets  

Microsoft.PowerBI/tenants/workspaces  

- [PowerBIDatasetsWorkspace](./tables/powerbidatasetsworkspace.md)

### Power BI Embedded  

microsoft.powerbidedicated/capacities  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Project CI Workspace  

Microsoft.DataCollaboration/workspaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ACICollaborationAudit](./tables/acicollaborationaudit.md)

### Public IP Addresses  

Microsoft.Network/PublicIpAddresses  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Recovery Services Vaults  

Microsoft.RecoveryServices/Vaults  

- [AzureActivity](./tables/azureactivity.md)
- [ASRJobs](./tables/asrjobs.md)
- [ASRReplicatedItems](./tables/asrreplicateditems.md)
- [AzureBackupOperations](./tables/azurebackupoperations.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [CoreAzureBackup](./tables/coreazurebackup.md)
- [AddonAzureBackupJobs](./tables/addonazurebackupjobs.md)
- [AddonAzureBackupAlerts](./tables/addonazurebackupalerts.md)
- [AddonAzureBackupPolicy](./tables/addonazurebackuppolicy.md)
- [AddonAzureBackupStorage](./tables/addonazurebackupstorage.md)
- [AddonAzureBackupProtectedInstance](./tables/addonazurebackupprotectedinstance.md)

### Relay  

Microsoft.Relay/namespaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AZMSVnetConnectionEvents](./tables/azmsvnetconnectionevents.md)
- [AZMSHybridConnectionsEvents](./tables/azmshybridconnectionsevents.md)

### Search Services  

Microsoft.Search/searchServices  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Service Bus  

Microsoft.ServiceBus/namespaces  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)
- [AZMSOperationalLogs](./tables/azmsoperationallogs.md)
- [AZMSVnetConnectionEvents](./tables/azmsvnetconnectionevents.md)
- [AZMSRunTimeAuditLogs](./tables/azmsruntimeauditlogs.md)
- [AZMSApplicationMetricLogs](./tables/azmsapplicationmetriclogs.md)
- [AZMSDiagnosticErrorLogs](./tables/azmsdiagnosticerrorlogs.md)

### Service Fabric Clusters  

Microsoft.ServiceFabric/clusters  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)

### SignalR  

Microsoft.SignalRService/SignalR  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [SignalRServiceDiagnosticLogs](./tables/signalrservicediagnosticlogs.md)

### SignalR Service WebPubSub  

Microsoft.SignalRService/WebPubSub  

- [AzureActivity](./tables/azureactivity.md)
- [WebPubSubHttpRequest](./tables/webpubsubhttprequest.md)
- [WebPubSubMessaging](./tables/webpubsubmessaging.md)
- [WebPubSubConnectivity](./tables/webpubsubconnectivity.md)

### SQL Databases  

Microsoft.Sql/servers/databases  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### SQL Managed Instances  

Microsoft.Sql/managedInstances  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### SQL Servers  

microsoft.sql/servers  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Storage Accounts  

Microsoft.Storage/storageAccounts  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [StorageTableLogs](./tables/storagetablelogs.md)
- [StorageQueueLogs](./tables/storagequeuelogs.md)
- [StorageFileLogs](./tables/storagefilelogs.md)
- [StorageBlobLogs](./tables/storagebloblogs.md)

### Stream Analytics jobs  

microsoft.streamanalytics/streamingjobs  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Synapse Workspaces  

Microsoft.Synapse/workspaces  

- [AzureActivity](./tables/azureactivity.md)
- [SynapseRbacOperations](./tables/synapserbacoperations.md)
- [SynapseGatewayApiRequests](./tables/synapsegatewayapirequests.md)
- [SynapseSqlPoolExecRequests](./tables/synapsesqlpoolexecrequests.md)
- [SynapseSqlPoolRequestSteps](./tables/synapsesqlpoolrequeststeps.md)
- [SynapseSqlPoolDmsWorkers](./tables/synapsesqlpooldmsworkers.md)
- [SynapseSqlPoolWaits](./tables/synapsesqlpoolwaits.md)
- [SynapseSqlPoolSqlRequests](./tables/synapsesqlpoolsqlrequests.md)
- [SynapseIntegrationPipelineRuns](./tables/synapseintegrationpipelineruns.md)
- [SynapseLinkEvent](./tables/synapselinkevent.md)
- [SynapseIntegrationActivityRuns](./tables/synapseintegrationactivityruns.md)
- [SynapseIntegrationTriggerRuns](./tables/synapseintegrationtriggerruns.md)
- [SynapseBigDataPoolApplicationsEnded](./tables/synapsebigdatapoolapplicationsended.md)
- [SynapseBuiltinSqlPoolRequestsEnded](./tables/synapsebuiltinsqlpoolrequestsended.md)
- [SQLSecurityAuditEvents](./tables/sqlsecurityauditevents.md)
- [SynapseScopePoolScopeJobsEnded](./tables/synapsescopepoolscopejobsended.md)
- [SynapseScopePoolScopeJobsStateChange](./tables/synapsescopepoolscopejobsstatechange.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [SynapseDXCommand](./tables/synapsedxcommand.md)
- [SynapseDXFailedIngestion](./tables/synapsedxfailedingestion.md)
- [SynapseDXIngestionBatching](./tables/synapsedxingestionbatching.md)
- [SynapseDXQuery](./tables/synapsedxquery.md)
- [SynapseDXSucceededIngestion](./tables/synapsedxsucceededingestion.md)
- [SynapseDXTableUsageStatistics](./tables/synapsedxtableusagestatistics.md)
- [SynapseDXTableDetails](./tables/synapsedxtabledetails.md)

### System Center Virtual Machine Manager  

Microsoft.SCVMM/VirtualMachines  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ADAssessmentRecommendation](./tables/adassessmentrecommendation.md)
- [ADReplicationResult](./tables/adreplicationresult.md)
- [ComputerGroup](./tables/computergroup.md)
- [ContainerLog](./tables/containerlog.md)
- [DnsEvents](./tables/dnsevents.md)
- [DnsInventory](./tables/dnsinventory.md)
- [SecurityBaselineSummary](./tables/securitybaselinesummary.md)
- [SQLAssessmentRecommendation](./tables/sqlassessmentrecommendation.md)
- [ConfigurationChange](./tables/configurationchange.md)
- [ConfigurationData](./tables/configurationdata.md)
- [Event](./tables/event.md)
- [Heartbeat](./tables/heartbeat.md)
- [Perf](./tables/perf.md)
- [ProtectionStatus](./tables/protectionstatus.md)
- [SecurityBaseline](./tables/securitybaseline.md)
- [SecurityEvent](./tables/securityevent.md)
- [Syslog](./tables/syslog.md)
- [Update](./tables/update.md)
- [UpdateRunProgress](./tables/updaterunprogress.md)
- [UpdateSummary](./tables/updatesummary.md)
- [VMBoundPort](./tables/vmboundport.md)
- [VMConnection](./tables/vmconnection.md)
- [VMComputer](./tables/vmcomputer.md)
- [VMProcess](./tables/vmprocess.md)
- [W3CIISLog](./tables/w3ciislog.md)
- [WindowsFirewall](./tables/windowsfirewall.md)
- [WireData](./tables/wiredata.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [HealthStateChangeEvent](./tables/healthstatechangeevent.md)
- [CommonSecurityLog](./tables/commonsecuritylog.md)

### Time Series Insights Environments  

Microsoft.TimeSeriesInsights/environments  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [TSIIngress](./tables/tsiingress.md)

### Toolchain orchestrator  

Microsoft.ToolchainOrchestrator/diagnostics  

- [AzureActivity](./tables/azureactivity.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Traffic Manager Profiles  

Microsoft.Network/trafficmanagerprofiles  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Video Indexer  

Microsoft.VideoIndexer/accounts  

- [VIAudit](./tables/viaudit.md)
- [VIIndexing](./tables/viindexing.md)

### Virtual Machine Scale Sets  

Microsoft.Compute/virtualMachineScaleSets  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ConfigurationChange](./tables/configurationchange.md)
- [ConfigurationData](./tables/configurationdata.md)
- [ContainerLog](./tables/containerlog.md)
- [Event](./tables/event.md)
- [Heartbeat](./tables/heartbeat.md)
- [Perf](./tables/perf.md)
- [ProtectionStatus](./tables/protectionstatus.md)
- [SecurityBaseline](./tables/securitybaseline.md)
- [SecurityEvent](./tables/securityevent.md)
- [Syslog](./tables/syslog.md)
- [Update](./tables/update.md)
- [UpdateRunProgress](./tables/updaterunprogress.md)
- [UpdateSummary](./tables/updatesummary.md)
- [VMBoundPort](./tables/vmboundport.md)
- [VMConnection](./tables/vmconnection.md)
- [VMComputer](./tables/vmcomputer.md)
- [VMProcess](./tables/vmprocess.md)
- [W3CIISLog](./tables/w3ciislog.md)
- [WindowsFirewall](./tables/windowsfirewall.md)
- [WireData](./tables/wiredata.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [CommonSecurityLog](./tables/commonsecuritylog.md)

### Virtual machines  

Microsoft.Compute/VirtualMachines  

- [Heartbeat](./tables/heartbeat.md)
- [W3CIISLog](./tables/w3ciislog.md)
- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ADAssessmentRecommendation](./tables/adassessmentrecommendation.md)
- [ADReplicationResult](./tables/adreplicationresult.md)
- [ComputerGroup](./tables/computergroup.md)
- [ContainerLog](./tables/containerlog.md)
- [DnsEvents](./tables/dnsevents.md)
- [DnsInventory](./tables/dnsinventory.md)
- [SecurityBaselineSummary](./tables/securitybaselinesummary.md)
- [SQLAssessmentRecommendation](./tables/sqlassessmentrecommendation.md)
- [ConfigurationChange](./tables/configurationchange.md)
- [ConfigurationData](./tables/configurationdata.md)
- [Event](./tables/event.md)
- [Perf](./tables/perf.md)
- [ProtectionStatus](./tables/protectionstatus.md)
- [SecurityBaseline](./tables/securitybaseline.md)
- [SecurityEvent](./tables/securityevent.md)
- [Syslog](./tables/syslog.md)
- [Update](./tables/update.md)
- [UpdateRunProgress](./tables/updaterunprogress.md)
- [UpdateSummary](./tables/updatesummary.md)
- [VMBoundPort](./tables/vmboundport.md)
- [VMConnection](./tables/vmconnection.md)
- [VMComputer](./tables/vmcomputer.md)
- [VMProcess](./tables/vmprocess.md)
- [WindowsFirewall](./tables/windowsfirewall.md)
- [WireData](./tables/wiredata.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [HealthStateChangeEvent](./tables/healthstatechangeevent.md)
- [CommonSecurityLog](./tables/commonsecuritylog.md)

### Virtual Network Gateways  

Microsoft.Network/virtualNetworkGateways  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Virtual Networks  

Microsoft.Network/virtualNetworks  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### Virtual Private Network Gateways  

Microsoft.Network/vpnGateways  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [AzureDiagnostics](./tables/azurediagnostics.md)

### VMware  

Microsoft.ConenctedVMwarevSphere/VirtualMachines  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)
- [ADAssessmentRecommendation](./tables/adassessmentrecommendation.md)
- [ADReplicationResult](./tables/adreplicationresult.md)
- [ComputerGroup](./tables/computergroup.md)
- [ContainerLog](./tables/containerlog.md)
- [DnsEvents](./tables/dnsevents.md)
- [DnsInventory](./tables/dnsinventory.md)
- [SecurityBaselineSummary](./tables/securitybaselinesummary.md)
- [SQLAssessmentRecommendation](./tables/sqlassessmentrecommendation.md)
- [ConfigurationChange](./tables/configurationchange.md)
- [ConfigurationData](./tables/configurationdata.md)
- [Event](./tables/event.md)
- [Heartbeat](./tables/heartbeat.md)
- [Perf](./tables/perf.md)
- [ProtectionStatus](./tables/protectionstatus.md)
- [SecurityBaseline](./tables/securitybaseline.md)
- [SecurityEvent](./tables/securityevent.md)
- [Syslog](./tables/syslog.md)
- [Update](./tables/update.md)
- [UpdateRunProgress](./tables/updaterunprogress.md)
- [UpdateSummary](./tables/updatesummary.md)
- [VMBoundPort](./tables/vmboundport.md)
- [VMConnection](./tables/vmconnection.md)
- [VMComputer](./tables/vmcomputer.md)
- [VMProcess](./tables/vmprocess.md)
- [W3CIISLog](./tables/w3ciislog.md)
- [WindowsFirewall](./tables/windowsfirewall.md)
- [WireData](./tables/wiredata.md)
- [InsightsMetrics](./tables/insightsmetrics.md)
- [HealthStateChangeEvent](./tables/healthstatechangeevent.md)
- [CommonSecurityLog](./tables/commonsecuritylog.md)

### Workload Monitor  

Microsoft.WorkloadMonitor/monitors  

- [AzureActivity](./tables/azureactivity.md)
- [AzureMetrics](./tables/azuremetrics.md)

### Workload Monitoring of Azure Monitor Insights  

Microsoft.Insights/WorkloadMonitoring  

- [InsightsMetrics](./tables/insightsmetrics.md)

## Next steps

- [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
- [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
- [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
