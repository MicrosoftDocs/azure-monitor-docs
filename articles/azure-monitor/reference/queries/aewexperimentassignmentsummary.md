---
title: Example log table queries for AEWExperimentAssignmentSummary
description:  Example queries for AEWExperimentAssignmentSummary log table
ms.topic: reference
ms.service: azure-monitor
ms.author: edbaynash
author: EdB-MSFT
ms.date: 11/04/2024

# NOTE:  This content is automatically generated using API calls to Azure. Any edits made on these files will be overwritten in the next run of the script. 

---

# Queries for the AEWExperimentAssignmentSummary table

For information on using these queries in the Azure portal, see [Log Analytics tutorial](/azure/azure-monitor/logs/log-analytics-tutorial). For the REST API, see [Query](/rest/api/loganalytics/query).


### Variant assignment counts by features  


List the total number of assignments for each variant in feature allocations.  

```query
// Variant assignment counts by features
AEWExperimentAssignmentSummary
| summarize
    IsControlVariant = take_any(IsControlVariant),
    AllocationPercentage = take_any(AllocationPercentage),
    AssignmentEventCount = sum(AssignmentEventCount),
    EarliestAssignment = min(MinTimeGenerated),
    LatestAssignment = max(MaxTimeGenerated)
    by FeatureName, AllocationId, Variant
| order by FeatureName asc, LatestAssignment desc, Variant asc
```



### Latest scorecard metadata for a given feature  


Query the latest experimentscorecard metadata for a given feature.  

```query
// Latest scorecard metadata for a given feature
// set the feature flag name to query
let QueryFeature = "MyFeatureFlag";
AEWExperimentAssignmentSummary
| where FeatureName == QueryFeature
| summarize MaxTimeGenerated=max(MaxTimeGenerated), Variants=make_set(Variant, 1000) by AllocationId
| summarize arg_max(MaxTimeGenerated, *)
| join kind=inner AEWExperimentScorecards on AllocationId
| summarize arg_max(TimeGenerated, ScorecardId)
| project
    FeatureName, AllocationId, Variants,
    ScorecardId, AnalysisStartTime, AnalysisEndTime, Insights
```



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

