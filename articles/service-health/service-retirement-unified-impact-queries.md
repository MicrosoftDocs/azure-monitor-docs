---
title: Identify impacted resources for service retirements using Azure Resource Graph
description: Correlate Azure Service Health retirement events with Azure Advisor recommendations to identify impacted resources without new APIs.
ms.topic: how-to
ms.date: 06/29/2026
---
# Identify impacted resources for service retirements by using Azure Resource Graph

This article explains what to do when your workflow starts from a Service Health retirement event and you need to correlate that signal to impacted resources. If you already consume Azure Advisor retirement recommendations through API, workbook, or the recommendations pane, use those channels directly for impacted-resource details where available.

## Conceptual model: Signal → Action

| Layer  | Azure service        | Responsibility                                       |
|--------|----------------------|------------------------------------------------------|
| Signal | Azure Service Health | Announces service retirement (tracking ID, timeline) |
| Join   | Azure Resource Graph | Correlates the signal with remediation data          |
| Action | Azure Advisor        | Identifies impacted resources and guidance           |

Azure Resource Graph serves as the supported integration point between service lifecycle awareness and execution. 

For more information about Resource Graph queries refer to [Resource Graph Overview](azure-resource-graph-overview.md). 

## When to use ARG vs. Advisor API
- Use **ARG** when your workflow starts from a Service Health retirement tracking ID and you need to correlate that signal to impacted resources across subscriptions.
- Use the **Advisor API/workbook/recommendations** pane when you already consume retirement recommendations and need impacted-resource details where available.


## Prerequisites

- Access to target Azure subscriptions
- Access to **Azure Resource Graph Explorer**
- Familiarity with basic ***Kusto Query Language (KQL)**
- **Azure public cloud scope** (if applicable to the same channel support as the current public guide)
- **Tracking ID source** (where it comes from in the workflow)
- **Coverage caveat** (impacted-resource availability isn't comprehensive)
- **Reader access** to target subscriptions
- **ARG Explorer** or the equivalent ARG execution path


>[!NOTE]
>This pattern depends on the supported retirement metadata already being available in Azure Resource Graph.

### Data sources used

| ARG table              | Description                         |
|------------------------|-------------------------------------|
| ServiceHealthResources | Service retirement lifecycle events |
| AdvisorResources       | Service retirement recommendations  |


### Advisor recommended metadata sample payload
```json
{
  "id": "/providers/Microsoft.Advisor/metadata/dc85da5531e554e0af38b9f06d26dac01a3c75c4c91a60b08778c83acfaad336",
  "name": "dc85da5531e554e0af38b9f06d26dac01a3c75c4c91a60b08778c83acfaad336",
  "type": "microsoft.advisor/metadata",
  "properties": {
    "recommendationTypeId": "e877d6d4-e952-4f8a-a4c4-5f90e5ac1da9",
    "recommendationSubCategory": "ServiceUpgradeAndRetirement",
    "resourceMetadata": {
      "action": {
        "recommendedActionButtonText": "",
        "actionApplicabilityScope": "",
        "isRecommendedAction": false,
        "description": null,
        "actionType": "Blade",
        "extensionName": "HubsExtension",
        "actionId": "051cfb90-f2d9-4efa-a2ac-fe7a6ead9d4e",
        "caption": null,
        "bladeName": "ResourceMenuBlade",
        "metadata": {
          "id": "{resourceId}"
        }
      },
      "singular": "Availability test",
      "plural": "Availability tests"
    },
    "exposedMetadataProperties": {
      "SupportedSDKLanguages": null,
      "AdditionalColumns": null,
      "CostSavingInfo": null,
      "Tip": null
    },
    "recommendationCategory": "HighAvailability",
    "supportedResourceType": "microsoft.insights/webtests",
    "recommendationImpact": "Medium",
    "detailedDescription": "To ensure you can continue to run single-step availability tests in your application insights resources, transition to standard tests. Ping tests are removed from your resources. ",
    "recommendationScope": "Public",
    "potentialBenefits": "Avoid potential disruptions and use new capabilities",
    "recommendationDataSourceQuery": "resources | where type == 'microsoft.insights/webtests' and properties.Kind == 'ping' | project subscriptionId, id",
    "learnMoreLink": "https://azure.microsoft.com/updates?id=transition-to-using-standard-tests-for-singlestep-availability-testing-in-azure-monitor-application-insights-by-30-september%22,
    "displayName": "The URL ping test capability of the application insights feature for Azure Monitor is being retired.",
    "priorityScore": 0.94,
    "lastRefreshed": "2026-06-23T10:57:47.3066458Z",
    "language": "en",
    "actions": [
    {
        "recommendedActionButtonText": "",
        "actionApplicabilityScope": "",
        "isRecommendedAction": false,
        "description": "Transition to using standard tests",
        "actionType": "Document",
        "actionId": "654f0880-edd0-4eea-9265-d2153628e197",
        "caption": "Transition to using standard tests",
        "isPostfixRequired": false,
        "documentLink": "https://learn.microsoft.com/azure/azure-monitor/app/availability?tabs=standard"
      }
    ],
    "recommendationIngestionType": "Automated",
    "label": "The URL ping test capability of the application insights feature for Azure Monitor is being retired.",
    "sourceProperties": {
      "serviceRetirement": {
        "retirementFeatureName": "Single URL Ping Test",
        "retirementDate": "2026-09-30T00:00:00Z",
        "serviceHealth": {
          "trackingIds": [
            "3KYM-7_G"
          ],
          "ashUrls": [
            "https://app.azure.com/h/3KYM-7_G/"
          ]
        }
      }
    }
  }
}
```

### Query: Join with Service Health events (Full Signal + Action View)

```kql
// Get Service Retirement metadata mappings: TrackingId -> RecommendationTypeId
advisorresources
| where type == "microsoft.advisor/metadata"
| extend props = parse_json(properties)
| where props.recommendationSubCategory ==  "ServiceUpgradeAndRetirement"
| where isnotempty(props.sourceProperties.serviceRetirement.serviceHealth.trackingIds)
| mv-expand trackingId = props.sourceProperties.serviceRetirement.serviceHealth.trackingIds
| extend trackingId = tostring(trackingId)
| extend recommendationTypeId = tostring(props.recommendationTypeId)
| distinct trackingId, recommendationTypeId
| join kind=inner (
    // Get active Service Retirement recommendations: RecommendationTypeId -> impacted resources
    advisorresources
    | where type == "microsoft.advisor/recommendations"
    | extend props = parse_json(properties)
    | where props.extendedProperties.recommendationSubCategory == "ServiceUpgradeAndRetirement"
    | where isempty(props.tracked)
    | where tostring(props.platformState) == "New"
    | extend recommendationTypeId = tostring(props.recommendationTypeId)
    | extend resourceId = tolower(tostring(props.resourceMetadata.resourceId))
    | distinct recommendationTypeId, resourceId, subscriptionId
) on recommendationTypeId
| join kind=inner (
    // Get Service Health event details
    servicehealthresources
    | where type =~ "microsoft.resourcehealth/events"
    | extend props = parse_json(properties)
    | where tostring(props.EventType) == "HealthAdvisory"
    | extend trackingId = tostring(props.TrackingId)
    | extend title = tostring(props.Title)
    | extend status = tostring(props.Status)
    | extend retirementDate = todatetime(props.ImpactMitigationTime)
    | distinct trackingId, title, status, retirementDate, subscriptionId
) on trackingId
| distinct resourceId, [title], retirementDate, status, trackingId
```

### Query sample payload
```json
{
  "resourceId": "/subscriptions/f2a74056-fc6e-41fd-ae49-248688b52f01/resourcegroups/rg-loadtesting/providers/microsoft.storage/storageaccounts/rgloadtestinga4ee",
  "title": "Retirement notice: Migrate your legacy Azure general-purpose v1 account to a general-purpose v2 account",
  "retirementDate": "2026-10-13T00:00:00Z",
  "status": "Active",
  "trackingId": "XTKT-BW8"
}
```


## How to run the query
1. **Use the Tracking ID to identify an incident**

   *Each Azure Service Health incident has a unique Tracking ID.*
    - This ID connects all updates and events related to that incident.
    -  Use it to quickly find all relevant messages and track progress until the issue is resolved.


1. **Run the query in Resource Graph Explorer**

    To retrieve details about incidents or related resources, run the provided query in [Azure Resource Graph Explorer](https://ms.portal.azure.com/#servicemenu/Microsoft_Azure_Resources/ResourceManager/resourcegraphexplorer).


1. **Review the key information in the results**
   
    *When you run the query (or check APIs), look for these important details*:

    - Service Health status
    - Tracking ID
    - Impacted resources
    - Retirement date
    - Retiring feature
    - Any additional recommended details



1. **Check the impacted resources in Azure Advisor**

    You can also view affected resources in the [Azure portal](https://ms.portal.azure.com/#view/Microsoft_Azure_Expert/AdvisorMenuBlade/~/HighAvailability).

      1.  Go to Azure Advisor
      1.  Open the Reliability section
      1.  Filter by Subcategory = `ServiceUpgradeAndRetirement`
  
  From there, follow the recommended actions to address or remediate the retirement impact.



### What this enables

- Programmatic identification of resources impacted by a service retirement.
- Retirement readiness dashboards and reporting.
- Automated remediation for tracking using Logic Apps or runbooks.
- Consistent customer patterns without per-team correlation logic.

### Summary

- **Azure Service Health** tells you *what is changing*.
- **Azure Advisor** tells you *what to do*.
- **Azure Resource Graph** connects the two using supported platform capabilities.

This pattern can also be used for maintenance, security advisories, and breaking changes.

### For more information

- [Impacted resources from Azure retirements](impacted-resources-retirements.md)
- [Service Health Frequently asked questions](service-health-faq.yml)
- [Service Health Portal](service-health-portal-update.md)
- [How to create Service Health alerts](alerts-activity-log-service-notifications-portal.md)
- [Azure Resource health sample queries](./resource-graph-samples.md)
