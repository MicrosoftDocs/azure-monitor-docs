---
title: Example log table queries for ContainerRegistryLoginEvents
description:  Example queries for ContainerRegistryLoginEvents log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the ContainerRegistryLoginEvents table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Show login events reported over the last hour  


A list of login event logs, sorted by time (earliest logs shown first).  

```query
ContainerRegistryLoginEvents
| where TimeGenerated > ago(1h)
| sort by TimeGenerated asc
```

