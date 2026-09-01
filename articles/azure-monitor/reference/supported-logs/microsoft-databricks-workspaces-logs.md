---
title: Supported log categories - Microsoft.Databricks/workspaces
description: Reference for Microsoft.Databricks/workspaces in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 08/21/2026
ms.custom: Microsoft.Databricks/workspaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Databricks/workspaces

The following table lists the types of logs available for the Microsoft.Databricks/workspaces resource type.


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|accounts|No|[DatabricksAccounts](/azure/azure-monitor/reference/tables/databricksaccounts)<p>Databricks Accounts audit logs.|Yes|Yes||
|Apps|Yes||No|No||
|BrickStoreHttpGateway|Yes||No|No||
|BudgetPolicyCentral|Yes||No|No||
|capsule8Dataplane|Yes|[DatabricksCapsule8Dataplane](/azure/azure-monitor/reference/tables/databrickscapsule8dataplane)<p>Audit logs for Databricks service capsule8-alerts-dataplane.|Yes|No||
|clamAVScan|Yes|[DatabricksClamAVScan](/azure/azure-monitor/reference/tables/databricksclamavscan)<p>Audit logs for Databricks clamav scan service|Yes|No||
|CloudStorageMetadata|Yes||No|No||
|clusterLibraries|Yes|[DatabricksClusterLibraries](/azure/azure-monitor/reference/tables/databricksclusterlibraries)<p>Audit logs for actions taken on cluster libraries in Databricks.|Yes|No||
|ClusterPolicies|Yes||No|No||
|clusters|No|[DatabricksClusters](/azure/azure-monitor/reference/tables/databricksclusters)<p>Databricks Clusters audit logs.|Yes|Yes||
|Dashboards|Yes||No|No||
|databrickssql|Yes|[DatabricksSQL](/azure/azure-monitor/reference/tables/databrickssql)<p>Audit logs for events related to creation, modification etc. of Databricks SQL endpoints.|Yes|No||
|DataMonitoring|Yes||No|No||
|DataRooms|Yes||No|No||
|dbfs|No|[DatabricksDBFS](/azure/azure-monitor/reference/tables/databricksdbfs)<p>Databricks DBFS audit logs.|Yes|Yes||
|deltaPipelines|Yes|[DatabricksDeltaPipelines](/azure/azure-monitor/reference/tables/databricksdeltapipelines)<p>Databricks delta pipelines audit logs.|Yes|No||
|featureStore|Yes|[DatabricksFeatureStore](/azure/azure-monitor/reference/tables/databricksfeaturestore)<p>Audit logs for events related to Databricks ML Feature Store operations.|Yes|Yes||
|Files|Yes||No|No||
|Filesystem|Yes||No|No||
|genie|Yes|[DatabricksGenie](/azure/azure-monitor/reference/tables/databricksgenie)<p>Audit logs for Databricks workspaces customer support access events.|Yes|Yes||
|gitCredentials|Yes|[DatabricksGitCredentials](/azure/azure-monitor/reference/tables/databricksgitcredentials)<p>Databricks Git credentials audit logs.|Yes|No||
|globalInitScripts|Yes|[DatabricksGlobalInitScripts](/azure/azure-monitor/reference/tables/databricksglobalinitscripts)<p>Audit logs for events related to creation, modification etc. of Databricks cluster global init scripts.|Yes|Yes||
|Groups|Yes||No|No||
|iamRole|Yes|[DatabricksIAMRole](/azure/azure-monitor/reference/tables/databricksiamrole)<p>Audit logs for events of changing IAM role ACLs.|Yes|No||
|Ingestion|Yes||No|No||
|instancePools|No|[DatabricksInstancePools](/azure/azure-monitor/reference/tables/databricksinstancepools)<p>Databricks Instance Pools audit logs.|Yes|Yes||
|jobs|No|[DatabricksJobs](/azure/azure-monitor/reference/tables/databricksjobs)<p>Databricks Jobs audit logs.|Yes|Yes||
|LakeviewConfig|Yes||No|No||
|LineageTracking|Yes||No|No||
|MarketplaceConsumer|Yes||No|No||
|MarketplaceProvider|Yes||No|No||
|mlflowAcledArtifact|Yes|[DatabricksMLflowAcledArtifact](/azure/azure-monitor/reference/tables/databricksmlflowacledartifact)<p>Audit logs for events of reading and writing Databricks MLflow ACLed artifacts.|Yes|Yes||
|mlflowExperiment|Yes|[DatabricksMLflowExperiment](/azure/azure-monitor/reference/tables/databricksmlflowexperiment)<p>Audit logs for events related to manipulation of Databricks MLflow experiments.|Yes|Yes||
|modelRegistry|Yes|[DatabricksModelRegistry](/azure/azure-monitor/reference/tables/databricksmodelregistry)<p>Databricks model registry audit logs.|Yes|No||
|notebook|No|[DatabricksNotebook](/azure/azure-monitor/reference/tables/databricksnotebook)<p>Databricks Notebook audit logs.|Yes|Yes||
|OnlineTables|Yes||No|No||
|partnerHub|Yes|[DatabricksPartnerHub](/azure/azure-monitor/reference/tables/databrickspartnerhub)<p>Audit logs for Databricks partner hub service.|Yes|No||
|PredictiveOptimization|Yes||No|No||
|RBAC|Yes||No|No||
|RemoteHistoryService|Yes|[DatabricksRemoteHistoryService](/azure/azure-monitor/reference/tables/databricksremotehistoryservice)<p>Audit logs for events adding and deleting credentials for Databricks remote history service.|Yes|Yes||
|repos|Yes|[DatabricksRepos](/azure/azure-monitor/reference/tables/databricksrepos)<p>Databricks repos audit logs.|Yes|No||
|RFA|Yes||No|No||
|secrets|No|[DatabricksSecrets](/azure/azure-monitor/reference/tables/databrickssecrets)<p>Databricks Secrets audit logs.|Yes|Yes||
|serverlessRealTimeInference|Yes|[DatabricksServerlessRealTimeInference](/azure/azure-monitor/reference/tables/databricksserverlessrealtimeinference)<p>Audit logs from Databricks model serving v2 API service.|Yes|No||
|sqlanalytics|Yes||No|No||
|sqlPermissions|No|[DatabricksSQLPermissions](/azure/azure-monitor/reference/tables/databrickssqlpermissions)<p>Databricks SQL Permissions audit logs.|Yes|Yes||
|ssh|No|[DatabricksSSH](/azure/azure-monitor/reference/tables/databricksssh)<p>Databricks SSH audit logs.|Yes|Yes||
|unityCatalog|Yes|[DatabricksUnityCatalog](/azure/azure-monitor/reference/tables/databricksunitycatalog)<p>Databricks unity catalog audit logs.|Yes|No||
|VectorSearch|Yes||No|No||
|WebhookNotifications|Yes||No|No||
|webTerminal|Yes|[DatabricksWebTerminal](/azure/azure-monitor/reference/tables/databrickswebterminal)<p>Databricks web terminal audit logs.|Yes|No||
|workspace|No|[DatabricksWorkspace](/azure/azure-monitor/reference/tables/databricksworkspace)<p>Databricks Workspace audit logs.|Yes|Yes||
|WorkspaceFiles|Yes||No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
