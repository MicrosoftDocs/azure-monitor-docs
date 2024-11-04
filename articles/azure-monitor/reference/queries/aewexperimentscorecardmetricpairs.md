---
title: Example log table queries for AEWExperimentScorecardMetricPairs
description:  Example queries for AEWExperimentScorecardMetricPairs log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/04/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AEWExperimentScorecardMetricPairs table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Latest scorecard results for a given feature  


Query the latest experiment scorecard result for a given feature.  

```query
// Latest scorecard results for a given feature
// set the feature flag name to query
let QueryFeature = "MyFeatureFlag";
AEWExperimentAssignmentSummary
| where FeatureName == QueryFeature
| summarize arg_max(MaxTimeGenerated, AllocationId)
| join kind=inner AEWExperimentScorecards on AllocationId
| summarize arg_max(TimeGenerated, ScorecardId)
| join kind=inner AEWExperimentScorecardMetricPairs on ScorecardId
| project
    ScorecardId, MetricId, MetricDisplayName, MetricKind, MetricTags,
    TreatmentVariant, TreatmentCount, TreatmentMetricValue,
    ControlVariant, ControlCount, ControlMetricValue,
    TreatmentEffect, RelativeDifference, PValue, Insights
```

