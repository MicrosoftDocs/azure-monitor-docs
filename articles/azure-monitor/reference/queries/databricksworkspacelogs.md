---
title: Example log table queries for DatabricksWorkspaceLogs
description:  Example queries for DatabricksWorkspaceLogs log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/24/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the DatabricksWorkspaceLogs table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### List all Databricks Diagnostic Settings categories  


Databricks Diagnostic Settings categories used to go to separate tables. This query lists all categories that are now in the DatabricksWorkspaceLogs table and those that are still in their own tables.  

```query
union isfuzzy=true
DatabricksAccounts,
DatabricksCapsule8Dataplane,
DatabricksClamAVScan,
DatabricksClusterLibraries,
DatabricksClusters,
DatabricksDatabricksSQL,
DatabricksDBFS,
DatabricksDeltaPipelines,
DatabricksFeatureStore,
DatabricksFiles,
DatabricksGenie,
DatabricksGitCredentials,
DatabricksGlobalInitScripts,
DatabricksIAMRole,
DatabricksInstancePools,
DatabricksJobs,
DatabricksMLflowAcledArtifact,
DatabricksMLflowExperiment,
DatabricksModelRegistry,
DatabricksNotebook,
DatabricksPartnerHub,
DatabricksRemoteHistoryService,
DatabricksRepos,
DatabricksSecrets,
DatabricksServerlessRealTimeInference,
DatabricksSQL,
DatabricksSQLPermissions,
DatabricksSSH,
DatabricksUnityCatalog,
DatabricksWebTerminal,
DatabricksWorkspace,
DatabricksBrickStoreHttpGateway,
DatabricksDashboards,
DatabricksCloudStorageMetadata,
DatabricksPredictiveOptimization,
DatabricksDataMonitoring,
DatabricksIngestion,
DatabricksMarketplaceConsumer,
DatabricksLineageTracking,
DatabricksFilesystem,
DatabricksLakeviewConfig,
| distinct Category, Type
```

