---
title: Example log table queries for TOUserDiagnostics
description:  Example queries for TOUserDiagnostics log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 01/27/2025

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the TOUserDiagnostics table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Toolchain orchestrator target provider and solution deployment failures  


Lists of Toolchain orchestrator target provider and solution deployment failures.  

```query
TOUserDiagnostics 
| where Message startswith "solution.(*SolutionManager).Reconcile" or Message contains ".Apply"
| order by EdgeLocation, TimeGenerated asc
| project EdgeLocation, TimeGenerated, Message, OperatingResourceId, OperatingResourceK8SId, OperationName
| take 100
```

