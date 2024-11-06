---
title: Example log table queries for ACSCallSummaryUpdates
description:  Example queries for ACSCallSummaryUpdates log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/04/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the ACSCallSummaryUpdates table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Call duration percentiles  


Calculates the average call duration in seconds, as well as the 50%, 90%, and 99% call duration percentiles.  

```query
ACSCallSummaryUpdates
// Get the distinct combinations of CorrelationId, CallDuration
| distinct CorrelationId, CallDuration
// Calculate average and percentiles (50%, 90%, and 99%) of call durations (in seconds)
| summarize avg(CallDuration), percentiles(CallDuration, 50, 90, 99)
```

