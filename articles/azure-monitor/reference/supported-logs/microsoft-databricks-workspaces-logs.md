---
title: Supported log categories - Microsoft.Databricks/workspaces
description: Reference for Microsoft.Databricks/workspaces in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 04/16/2025
ms.custom: Microsoft.Databricks/workspaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Databricks/workspaces

The following table lists the types of logs available for the Microsoft.Databricks/workspaces resource type.


|Category|Category display name| Log table| [Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)| Example queries |Costs to export|
|---|---|---|---|---|---|---|
|`accounts` |Databricks Accounts |[DatabricksAccounts](/azure/azure-monitor/reference/tables/databricksaccounts)<p>Databricks Accounts audit logs.|Yes|Yes||No |
|`Apps` |Databricks Lakehouse Apps ||No|No||Yes |
|`BrickStoreHttpGateway` |Databricks Brick Store HttpGateway ||No|No||Yes |
|`BudgetPolicyCentral` |Databricks Budget Policy Central ||No|No||Yes |
|`capsule8Dataplane` |Databricks Capsule8 Container Security Scanning Reports |[DatabricksCapsule8Dataplane](/azure/azure-monitor/reference/tables/databrickscapsule8dataplane)<p>Audit logs for Databricks service capsule8-alerts-dataplane.|Yes|No||Yes |
|`clamAVScan` |Databricks Clam AV Scan |[DatabricksClamAVScan](/azure/azure-monitor/reference/tables/databricksclamavscan)<p>Audit logs for Databricks clamav scan service|Yes|No||Yes |
|`CloudStorageMetadata` |Databricks Cloud Storage Metadata ||No|No||Yes |
|`clusterLibraries` |Databricks Cluster Libraries |[DatabricksClusterLibraries](/azure/azure-monitor/reference/tables/databricksclusterlibraries)<p>Audit logs for actions taken on cluster libraries in Databricks.|Yes|No||Yes |
|`ClusterPolicies` |Databricks Cluster Policies ||No|No||Yes |
|`clusters` |Databricks Clusters |[DatabricksClusters](/azure/azure-monitor/reference/tables/databricksclusters)<p>Databricks Clusters audit logs.|Yes|Yes||No |
|`Dashboards` |Databricks Dashboards ||No|No||Yes |
|`databrickssql` |Databricks DatabricksSQL |[DatabricksSQL](/azure/azure-monitor/reference/tables/databrickssql)<p>Audit logs for events related to creation, modification etc. of Databricks SQL endpoints.|Yes|No||Yes |
|`DataMonitoring` |Databricks Data Monitoring ||No|No||Yes |
|`DataRooms` |Databricks Data Rooms ||No|No||Yes |
|`dbfs` |Databricks File System |[DatabricksDBFS](/azure/azure-monitor/reference/tables/databricksdbfs)<p>Databricks DBFS audit logs.|Yes|Yes||No |
|`deltaPipelines` |Databricks Delta Pipelines |[DatabricksDeltaPipelines](/azure/azure-monitor/reference/tables/databricksdeltapipelines)<p>Databricks delta pipelines audit logs.|Yes|No||Yes |
|`featureStore` |Databricks Feature Store |[DatabricksFeatureStore](/azure/azure-monitor/reference/tables/databricksfeaturestore)<p>Audit logs for events related to Databricks ML Feature Store operations.|Yes|Yes||Yes |
|`Files` |Databricks Files ||No|No||Yes |
|`Filesystem` |Databricks Filesystem Logs ||No|No||Yes |
|`genie` |Databricks Genie |[DatabricksGenie](/azure/azure-monitor/reference/tables/databricksgenie)<p>Audit logs for Databricks workspaces customer support access events.|Yes|Yes||Yes |
|`gitCredentials` |Databricks Git Credentials |[DatabricksGitCredentials](/azure/azure-monitor/reference/tables/databricksgitcredentials)<p>Databricks Git credentials audit logs.|Yes|No||Yes |
|`globalInitScripts` |Databricks Global Init Scripts |[DatabricksGlobalInitScripts](/azure/azure-monitor/reference/tables/databricksglobalinitscripts)<p>Audit logs for events related to creation, modification etc. of Databricks cluster global init scripts.|Yes|Yes||Yes |
|`Groups` |Databricks Groups ||No|No||Yes |
|`iamRole` |Databricks IAM Role |[DatabricksIAMRole](/azure/azure-monitor/reference/tables/databricksiamrole)<p>Audit logs for events of changing IAM role ACLs.|Yes|No||Yes |
|`Ingestion` |Databricks Ingestion ||No|No||Yes |
|`instancePools` |Instance Pools |[DatabricksInstancePools](/azure/azure-monitor/reference/tables/databricksinstancepools)<p>Databricks Instance Pools audit logs.|Yes|Yes||No |
|`jobs` |Databricks Jobs |[DatabricksJobs](/azure/azure-monitor/reference/tables/databricksjobs)<p>Databricks Jobs audit logs.|Yes|Yes||No |
|`LakeviewConfig` |Databricks Lakeview configuration ||No|No||Yes |
|`LineageTracking` |Databricks Lineage Tracking ||No|No||Yes |
|`MarketplaceConsumer` |Databricks Marketplace Consumer ||No|No||Yes |
|`MarketplaceProvider` |Databricks Marketplace Provider ||No|No||Yes |
|`mlflowAcledArtifact` |Databricks MLFlow Acled Artifact |[DatabricksMLflowAcledArtifact](/azure/azure-monitor/reference/tables/databricksmlflowacledartifact)<p>Audit logs for events of reading and writing Databricks MLflow ACLed artifacts.|Yes|Yes||Yes |
|`mlflowExperiment` |Databricks MLFlow Experiment |[DatabricksMLflowExperiment](/azure/azure-monitor/reference/tables/databricksmlflowexperiment)<p>Audit logs for events related to manipulation of Databricks MLflow experiments.|Yes|Yes||Yes |
|`modelRegistry` |Databricks Model Registry |[DatabricksModelRegistry](/azure/azure-monitor/reference/tables/databricksmodelregistry)<p>Databricks model registry audit logs.|Yes|No||Yes |
|`notebook` |Databricks Notebook |[DatabricksNotebook](/azure/azure-monitor/reference/tables/databricksnotebook)<p>Databricks Notebook audit logs.|Yes|Yes||No |
|`OnlineTables` |Databricks Online Tables ||No|No||Yes |
|`partnerHub` |Databricks Partner Hub |[DatabricksPartnerHub](/azure/azure-monitor/reference/tables/databrickspartnerhub)<p>Audit logs for Databricks partner hub service.|Yes|No||Yes |
|`PredictiveOptimization` |Databricks Predictive Optimization ||No|No||Yes |
|`RBAC` |Databricks Role Based Access Control ||No|No||Yes |
|`RemoteHistoryService` |Databricks Remote History Service |[DatabricksRemoteHistoryService](/azure/azure-monitor/reference/tables/databricksremotehistoryservice)<p>Audit logs for events adding and deleting credentials for Databricks remote history service.|Yes|Yes||Yes |
|`repos` |Databricks Repos |[DatabricksRepos](/azure/azure-monitor/reference/tables/databricksrepos)<p>Databricks repos audit logs.|Yes|No||Yes |
|`RFA` |Databricks Request For Access Events ||No|No||Yes |
|`secrets` |Databricks Secrets |[DatabricksSecrets](/azure/azure-monitor/reference/tables/databrickssecrets)<p>Databricks Secrets audit logs.|Yes|Yes||No |
|`serverlessRealTimeInference` |Databricks Serverless Real-Time Inference |[DatabricksServerlessRealTimeInference](/azure/azure-monitor/reference/tables/databricksserverlessrealtimeinference)<p>Audit logs from Databricks model serving v2 API service.|Yes|No||Yes |
|`sqlanalytics` |Databricks SQL Analytics ||No|No||Yes |
|`sqlPermissions` |Databricks SQLPermissions |[DatabricksSQLPermissions](/azure/azure-monitor/reference/tables/databrickssqlpermissions)<p>Databricks SQL Permissions audit logs.|Yes|Yes||No |
|`ssh` |Databricks SSH |[DatabricksSSH](/azure/azure-monitor/reference/tables/databricksssh)<p>Databricks SSH audit logs.|Yes|Yes||No |
|`unityCatalog` |Databricks Unity Catalog |[DatabricksUnityCatalog](/azure/azure-monitor/reference/tables/databricksunitycatalog)<p>Databricks unity catalog audit logs.|Yes|No||Yes |
|`VectorSearch` |Databricks Vector Search ||No|No||Yes |
|`WebhookNotifications` |Databricks Webhook Notifications ||No|No||Yes |
|`webTerminal` |Databricks Web Terminal |[DatabricksWebTerminal](/azure/azure-monitor/reference/tables/databrickswebterminal)<p>Databricks web terminal audit logs.|Yes|No||Yes |
|`workspace` |Databricks Workspace |[DatabricksWorkspace](/azure/azure-monitor/reference/tables/databricksworkspace)<p>Databricks Workspace audit logs.|Yes|Yes||No |
|`WorkspaceFiles` |Databricks Workspace Files ||No|No||Yes |

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
