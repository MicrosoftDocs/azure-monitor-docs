---
title: Example log table queries for AADUserRiskEvents
description:  Example queries for AADUserRiskEvents log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AADUserRiskEvents table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Recent user risk events  


Gets list of the top 100 active user risk events.  

```query
AADUserRiskEvents
| where DetectedDateTime > ago(1d)
| where RiskState == "atRisk"
| take 100
```



### Active user risk detections  


Gets a list of active user risk detections.  

```query
AADUserRiskEvents
| summarize arg_max(LastUpdatedDateTime, *) by RequestId, UserId
| where RiskState == "atRisk"
```

