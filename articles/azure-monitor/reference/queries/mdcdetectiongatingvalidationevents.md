---
title: Example log table queries for MDCDetectionGatingValidationEvents
description:  Example queries for MDCDetectionGatingValidationEvents log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 09/26/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the MDCDetectionGatingValidationEvents table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### All recent Gating validation events  


Get all Gating validation events published in the last 24 hours.  

```query
source
| project
	AzureResourceId,	
    Region,
    Action,
    RuleProperties,
    AdmissionControlVersions,
	EvaluatedResourceKind,
	EvaluatedResourceName,
    EvaluatedResourceParentKind,
    EvaluatedResourceParentName,
    EvaluatedResourceDetails,
	Namespace,
	TimeGenerated
```

