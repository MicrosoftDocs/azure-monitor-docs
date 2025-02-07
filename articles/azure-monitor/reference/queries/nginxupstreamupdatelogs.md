---
title: Example log table queries for NginxUpstreamUpdateLogs
description:  Example queries for NginxUpstreamUpdateLogs log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 02/05/2025

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the NginxUpstreamUpdateLogs table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Show NGINXaaS upstream update logs  


A list of upstream update logs sorted by time.  

```query
NginxUpstreamUpdateLogs
| sort by TimeGenerated asc
| take 100
```

