---
title: Example log table queries for LogicAppWorkflowRuntime
description:  Example queries for LogicAppWorkflowRuntime log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the LogicAppWorkflowRuntime table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Count of failed workflow operations from Logic App Workflow Runtime  


Count of failed workflow operations from Logic App Workflow Runtime in selected time range for each workflow.  

```query
LogicAppWorkflowRuntime
| where Status == "Failed"
| summarize count() by WorkflowName
```

