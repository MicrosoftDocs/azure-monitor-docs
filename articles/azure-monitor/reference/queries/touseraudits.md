---
title: Example log table queries for TOUserAudits
description:  Example queries for TOUserAudits log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 01/27/2025

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the TOUserAudits table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Auditing ToolchainOrchestrator Operations  


Lists of audit Toolchain orchestrator operations.  

```query
TOUserAudits
| where Message !startswith_cs "Request" 
| order by EdgeLocation, TimeGenerated desc
| project EdgeLocation, TimeGenerated, Message, OperatingResourceId, OperatingResourceK8SId, OperationName
| take 100
```



### Auditing ToolchainOrchestrator API requests  


Lists of audit Toolchain orchestrator api requests.  

```query
TOUserAudits
| where Message startswith_cs "Request" 
| order by EdgeLocation, TimeGenerated desc
| project EdgeLocation, TimeGenerated, Message, OperatingResourceId, OperatingResourceK8SId, OperationName
| take 100
```

