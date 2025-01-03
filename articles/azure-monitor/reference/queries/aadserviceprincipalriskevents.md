---
title: Example log table queries for AADServicePrincipalRiskEvents
description:  Example queries for AADServicePrincipalRiskEvents log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/16/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AADServicePrincipalRiskEvents table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Active service principal risk detections  


Gets a list of active service principal risk detections.  

```query
AADServicePrincipalRiskEvents
| summarize arg_max(LastUpdatedDateTime, *) by RequestId, ServicePrincipalId
| where RiskState == "atRisk"
```

