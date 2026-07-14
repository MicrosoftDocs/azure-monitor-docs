---
title: Supported log categories - Microsoft.Databricks/workspaces
description: Reference for Microsoft.Databricks/workspaces in Azure Monitor Logs.
ms.topic: generated-reference
ms.date: 07/14/2026
ms.custom: Microsoft.Databricks/workspaces, naam

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script.

---

# Supported logs for Microsoft.Databricks/workspaces

The following table lists the types of logs available for the Microsoft.Databricks/workspaces resource type.


|Category|Costs to export|Log table|[Supports basic log plan](/azure/azure-monitor/logs/basic-logs-configure?tabs=portal-1#compare-the-basic-and-analytics-log-data-plans)|[Supports ingestion-time transformation](/azure/azure-monitor/essentials/data-collection-transformations)|Example queries|
|---|---|---|---|---|---|
|Databricks Accounts|No|[DatabricksAccounts](/azure/azure-monitor/reference/tables/databricksaccounts)<p>Databricks Accounts audit logs.|Yes|Yes||
|Databricks Lakehouse Apps|Yes||No|No||
|Databricks Brick Store HttpGateway|Yes||No|No||
|Databricks Budget Policy Central|Yes||No|No||
|Databricks Capsule8 Container Security Scanning Reports|Yes|[DatabricksCapsule8Dataplane](/azure/azure-monitor/reference/tables/databrickscapsule8dataplane)<p>Audit logs for Databricks service capsule8-alerts-dataplane.|Yes|No||
|Databricks Clam AV Scan|Yes|[DatabricksClamAVScan](/azure/azure-monitor/reference/tables/databricksclamavscan)<p>Audit logs for Databricks clamav scan service|Yes|No||
|Databricks Cloud Storage Metadata|Yes||No|No||
|Databricks Cluster Libraries|Yes|[DatabricksClusterLibraries](/azure/azure-monitor/reference/tables/databricksclusterlibraries)<p>Audit logs for actions taken on cluster libraries in Databricks.|Yes|No||
|Databricks Cluster Policies|Yes||No|No||
|Databricks Clusters|No|[DatabricksClusters](/azure/azure-monitor/reference/tables/databricksclusters)<p>Databricks Clusters audit logs.|Yes|Yes||
|Databricks Dashboards|Yes||No|No||
|Databricks DatabricksSQL|Yes|[DatabricksSQL](/azure/azure-monitor/reference/tables/databrickssql)<p>Audit logs for events related to creation, modification etc. of Databricks SQL endpoints.|Yes|No||
|Databricks Data Monitoring|Yes||No|No||
|Databricks Data Rooms|Yes||No|No||
|Databricks File System|No|[DatabricksDBFS](/azure/azure-monitor/reference/tables/databricksdbfs)<p>Databricks DBFS audit logs.|Yes|Yes||
|Databricks Delta Pipelines|Yes|[DatabricksDeltaPipelines](/azure/azure-monitor/reference/tables/databricksdeltapipelines)<p>Databricks delta pipelines audit logs.|Yes|No||
|Databricks Feature Store|Yes|[DatabricksFeatureStore](/azure/azure-monitor/reference/tables/databricksfeaturestore)<p>Audit logs for events related to Databricks ML Feature Store operations.|Yes|Yes||
|Databricks Files|Yes||No|No||
|Databricks Filesystem Logs|Yes||No|No||
|Databricks Genie|Yes|[DatabricksGenie](/azure/azure-monitor/reference/tables/databricksgenie)<p>Audit logs for Databricks workspaces customer support access events.|Yes|Yes||
|Databricks Git Credentials|Yes|[DatabricksGitCredentials](/azure/azure-monitor/reference/tables/databricksgitcredentials)<p>Databricks Git credentials audit logs.|Yes|No||
|Databricks Global Init Scripts|Yes|[DatabricksGlobalInitScripts](/azure/azure-monitor/reference/tables/databricksglobalinitscripts)<p>Audit logs for events related to creation, modification etc. of Databricks cluster global init scripts.|Yes|Yes||
|Databricks Groups|Yes||No|No||
|Databricks IAM Role|Yes|[DatabricksIAMRole](/azure/azure-monitor/reference/tables/databricksiamrole)<p>Audit logs for events of changing IAM role ACLs.|Yes|No||
|Databricks Ingestion|Yes||No|No||
|Instance Pools|No|[DatabricksInstancePools](/azure/azure-monitor/reference/tables/databricksinstancepools)<p>Databricks Instance Pools audit logs.|Yes|Yes||
|Databricks Jobs|No|[DatabricksJobs](/azure/azure-monitor/reference/tables/databricksjobs)<p>Databricks Jobs audit logs.|Yes|Yes||
|Databricks Lakeview configuration|Yes||No|No||
|Databricks Lineage Tracking|Yes||No|No||
|Databricks Marketplace Consumer|Yes||No|No||
|Databricks Marketplace Provider|Yes||No|No||
|Databricks MLFlow Acled Artifact|Yes|[DatabricksMLflowAcledArtifact](/azure/azure-monitor/reference/tables/databricksmlflowacledartifact)<p>Audit logs for events of reading and writing Databricks MLflow ACLed artifacts.|Yes|Yes||
|Databricks MLFlow Experiment|Yes|[DatabricksMLflowExperiment](/azure/azure-monitor/reference/tables/databricksmlflowexperiment)<p>Audit logs for events related to manipulation of Databricks MLflow experiments.|Yes|Yes||
|Databricks Model Registry|Yes|[DatabricksModelRegistry](/azure/azure-monitor/reference/tables/databricksmodelregistry)<p>Databricks model registry audit logs.|Yes|No||
|Databricks Notebook|No|[DatabricksNotebook](/azure/azure-monitor/reference/tables/databricksnotebook)<p>Databricks Notebook audit logs.|Yes|Yes||
|Databricks Online Tables|Yes||No|No||
|Databricks Partner Hub|Yes|[DatabricksPartnerHub](/azure/azure-monitor/reference/tables/databrickspartnerhub)<p>Audit logs for Databricks partner hub service.|Yes|No||
|Databricks Predictive Optimization|Yes||No|No||
|Databricks Role Based Access Control|Yes||No|No||
|Databricks Remote History Service|Yes|[DatabricksRemoteHistoryService](/azure/azure-monitor/reference/tables/databricksremotehistoryservice)<p>Audit logs for events adding and deleting credentials for Databricks remote history service.|Yes|Yes||
|Databricks Repos|Yes|[DatabricksRepos](/azure/azure-monitor/reference/tables/databricksrepos)<p>Databricks repos audit logs.|Yes|No||
|Databricks Request For Access Events|Yes||No|No||
|Databricks Secrets|No|[DatabricksSecrets](/azure/azure-monitor/reference/tables/databrickssecrets)<p>Databricks Secrets audit logs.|Yes|Yes||
|Databricks Serverless Real-Time Inference|Yes|[DatabricksServerlessRealTimeInference](/azure/azure-monitor/reference/tables/databricksserverlessrealtimeinference)<p>Audit logs from Databricks model serving v2 API service.|Yes|No||
|Databricks SQL Analytics|Yes||No|No||
|Databricks SQLPermissions|No|[DatabricksSQLPermissions](/azure/azure-monitor/reference/tables/databrickssqlpermissions)<p>Databricks SQL Permissions audit logs.|Yes|Yes||
|Databricks SSH|No|[DatabricksSSH](/azure/azure-monitor/reference/tables/databricksssh)<p>Databricks SSH audit logs.|Yes|Yes||
|Databricks Unity Catalog|Yes|[DatabricksUnityCatalog](/azure/azure-monitor/reference/tables/databricksunitycatalog)<p>Databricks unity catalog audit logs.|Yes|No||
|Databricks Vector Search|Yes||No|No||
|Databricks Webhook Notifications|Yes||No|No||
|Databricks Web Terminal|Yes|[DatabricksWebTerminal](/azure/azure-monitor/reference/tables/databrickswebterminal)<p>Databricks web terminal audit logs.|Yes|No||
|Databricks Workspace|No|[DatabricksWorkspace](/azure/azure-monitor/reference/tables/databricksworkspace)<p>Databricks Workspace audit logs.|Yes|Yes||
|Databricks Workspace Files|Yes||No|No||

## Next Steps

* [Learn more about resource logs](/azure/azure-monitor/essentials/platform-logs-overview)
* [Stream resource logs to Event Hubs](/azure/azure-monitor/essentials/resource-logs#send-to-azure-event-hubs)
* [Change resource log diagnostic settings using the Azure Monitor REST API](/rest/api/monitor/diagnosticsettings)
* [Analyze logs from Azure storage with Log Analytics](/azure/azure-monitor/essentials/resource-logs#send-to-log-analytics-workspace)
* [Optimize log queries in Azure Monitor](/azure/azure-monitor/logs/query-optimization)
* [Aggregate data in a Log Analytics workspace by using summary rules (Preview)](/azure/azure-monitor/logs/summary-rules)
