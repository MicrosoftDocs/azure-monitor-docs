---
title: Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: concept-article
ms.date: 07/24/2026
---

# Query for Advisor data in Azure Resource Graph

You can find Advisor data in [Azure Resource Graph](https://azure.microsoft.com/features/resource-graph/), a service that lets you explore your Azure resources by using fast, at-scale queries across subscriptions. Use it to:

- Get a single, cross-subscription view of your recommendations without switching contexts.
- Spot where to focus first by grouping recommendations by category (such as reliability or performance) and impact (high, medium, or low).
- Gauge the scope of a specific recommendation type by counting the resources it affects across your environment.

All Advisor data is stored in the `advisorresources` table. Query this table to work with the full set of Advisor resource types, including:

- `microsoft.advisor/recommendations` – active recommendations for your resources.
- `microsoft.advisor/advisorscore` – Advisor score data, with breakdowns by category and subcategory.
- `microsoft.advisor/configurations` – Advisor configuration settings.
- `microsoft.advisor/metadata` – reference metadata for recommendation categories and types.

## Recommendation state fields
The `advisorresources` table includes fields that represent the lifecycle state of each recommendation. Use the following **consolidated state fields** when querying recommendation status:

| Field | Description | Example values |
| :-- | :-- | :-- |
| `properties.recommendationStatus` | The current consolidated status of the recommendation. This is the single source of truth for recommendation state. | `New, InProgress, Completed, Postponed, Dismissed` |
| `properties.completionType` | How the recommendation was resolved or completed. Only populated when `recommendationStatus` is `Completed`. | `MarkedByUser, SystemVerified`|
| `properties.lastUpdated` | Timestamp of the most recent state change for the recommendation. | `2026-04-09T11:41:28Z` |

> [!IMPORTANT]
> The **advisorresources** table includes system fields such as *customerState* and *platformState*. These fields may change and should not be relied on. To determine the current state of a recommendation, use the *recommendationStatus* field.

## Examples

### Active (new) recommendations

```kusto
advisorresources
| where type =~ "microsoft.advisor/metadata"
| where tostring(properties.language) == "en"
| extend recommendationTypeId=tostring(properties.recommendationTypeId)
| project
    recommendationTypeId,
    category=tostring(properties.recommendationCategory),
    impact=tostring(properties.recommendationImpact),
    metadataDescription=tostring(properties.label)
| join kind=inner (
    advisorresources
    | where type =~ "microsoft.advisor/recommendations"
    | where properties.recommendationStatus == "New"
    | extend recommendationTypeId=tostring(properties.recommendationTypeId)
    | project
        recommendationTypeId,
        id,
        subscriptionId,
        resourceGroup,
        tracked=tobool(properties.tracked),
        recommendationDescription=tostring(properties.label),
        recommendationStatus=tostring(properties.recommendationStatus),
        lastUpdated=todatetime(properties.lastUpdated)
    )
    on recommendationTypeId
| extend description = iff(tracked == true, recommendationDescription, metadataDescription)
| project
    id,
    subscriptionId,
    resourceGroup,
    category,
    impact,
    description,
    recommendationStatus,
    lastUpdated
```
### Completed recommendations

```kusto
advisorresources
| where type =~ "microsoft.advisor/metadata"
| where tostring(properties.language) == "en"
| extend recommendationTypeId=tostring(properties.recommendationTypeId)
| project
    recommendationTypeId,
    category=tostring(properties.recommendationCategory),
    metadataDescription=tostring(properties.label)
| join kind=inner (
    advisorresources
    | where type =~ "microsoft.advisor/recommendations"
    | where properties.recommendationStatus == "Completed"
    | extend recommendationTypeId=tostring(properties.recommendationTypeId)
    | project
        recommendationTypeId,
        id,
        subscriptionId,
        resourceGroup,
        tracked=tobool(properties.tracked),
        recommendationDescription=tostring(properties.label),
        recommendationStatus=tostring(properties.recommendationStatus),
        completionType=tostring(properties.completionType),
        lastUpdated=todatetime(properties.lastUpdated)
    )
    on recommendationTypeId
| extend description = iff(tracked == true, recommendationDescription, metadataDescription)
| project
    id,
    subscriptionId,
    resourceGroup,
    category,
    description,
    recommendationStatus,
    completionType,
    lastUpdated
```
> [!NOTE]
> The **Completed** state for security recommendations in the Advisor table in Azure Resource Graph may not reflect the current status. To determine the accurate state of a security recommendation, refer to its status in Microsoft Defender for Cloud.

### Active cost recommendations

```kusto
advisorresources
| where type =~ "microsoft.advisor/metadata"
| where tostring(properties.language) == "en"
| where tostring(properties.recommendationCategory) == "Cost"
| project
    recommendationTypeId = tostring(properties.recommendationTypeId),
    category = tostring(properties.recommendationCategory),
    impact = tolower(tostring(properties.recommendationImpact)),
    recommendationSubcategory = tostring(properties.recommendationSubCategory),
    resourceType = tolower(tostring(properties.supportedResourceType)),
    metadataDescription = tostring(properties.label)
| join kind=inner (
    advisorresources
    | where type =~ 'microsoft.advisor/recommendations'
    | where isempty(properties.tracked) or properties.tracked == false
    | project
        id,
        stableId = name,
        subscriptionId,
        resourceGroup,
        properties
    | where properties.recommendationStatus == "New"
    | project
        id,
        stableId,
        subscriptionId,
        resourceGroup,
        properties
    | join kind=leftouter (
        advisorresources
        | where type =~ 'microsoft.advisor/configurations'
        | where isempty(resourceGroup) == true
        | project
            subscriptionId,
            excludeRecomm = properties.exclude,
            lowCpuThreshold = properties.lowCpuThreshold
        )
        on subscriptionId
    | extend isActive1 = iff(isempty(excludeRecomm), true, tobool(excludeRecomm) == false)
    | extend isActive2 =
        iff(
    properties.recommendationTypeId in (
        "e10b1381-5f0a-47ff-8c7b-37bd13d7c974",
        "94aea435-ef39-493f-a547-8408092c22a7"
        ),
    iff(
    isnotempty(lowCpuThreshold)
        and isnotnull(properties.extendedProperties)
        and isnotempty(properties.extendedProperties.MaxCpuP95),
    todouble(properties.extendedProperties.MaxCpuP95) < todouble(lowCpuThreshold),
    iff(
    isnull(properties.extendedProperties)
        or isempty(properties.extendedProperties.MaxCpuP95)
        or todouble(properties.extendedProperties.MaxCpuP95) < 100,
    true,
    false
)
),
    true
)
    | where isActive1 == true and isActive2 == true
    | join kind=leftouter (
        advisorresources
        | where type =~ 'microsoft.advisor/configurations'
        | where isnotempty(resourceGroup)
        | project
            subscriptionId,
            resourceGroup,
            excludeProperty = properties.exclude
        )
        on subscriptionId, resourceGroup
    | extend isActive3 = iff(isempty(excludeProperty), true, tobool(excludeProperty) == false)
    | where isActive3 == true
    | project id, stableId, subscriptionId, resourceGroup, tostring(properties)
    | extend properties = parse_json(properties)
    | extend extendedProperties = properties.extendedProperties
    | extend recommendationTypeId = tostring(properties.recommendationTypeId)
    | extend resourceId = tolower(tostring(properties.resourceMetadata.resourceId))
    | extend lastUpdate = tostring(properties.lastUpdated)
    | extend annualSavingsAmount = toreal(extendedProperties.annualSavingsAmount)
    | extend savingsCurrency = tostring(extendedProperties.savingsCurrency)
    | extend term = tostring(extendedProperties.term)
    | extend lookbackPeriod = tostring(extendedProperties.lookbackPeriod)
    | project
        recommendationTypeId,
        subscriptionId,
        resourceId,
        lastUpdate,
        annualSavingsAmount,
        savingsCurrency,
        term,
        lookbackPeriod,
        resourceGroup,
        extendedProperties
    )
    on recommendationTypeId
| extend description = metadataDescription
| project
    subscriptionId,
    recommendationTypeId,
    recommendationSubcategory,
    resourceType,
    category,
    impact,
    resourceId,
    description,
    lastUpdate,
    annualSavingsAmount,
    savingsCurrency,
    term,
    lookbackPeriod,
    resourceGroup,
    extendedProperties,
    joinID = toupper(resourceId)
| join kind=leftouter (
    resources
    | project
        joinID = toupper(id),
        tags
    )
    on joinID
| project
    subscriptionId,
    recommendationTypeId,
    recommendationSubcategory,
    resourceType,
    category,
    impact,
    resourceId,
    description,
    lastUpdate,
    annualSavingsAmount,
    savingsCurrency,
    term,
    lookbackPeriod,
    resourceGroup,
    extendedProperties,
    tags
```
### Potential cost savings from recommendations

```kusto
advisorresources
| where type =~ "microsoft.advisor/metadata"
| where tostring(properties.language)=="en"
| where tostring(properties.recommendationCategory)=="Cost"
| extend recommendationTypeId=tostring(properties.recommendationTypeId)
| project recommendationTypeId,
    metadataSolution=tostring(properties.label)
| join kind=inner (
    advisorresources
    | where type =~ "microsoft.advisor/recommendations"
    | extend recommendationTypeId=tostring(properties.recommendationTypeId)
    | extend
        resources=tostring(properties.resourceMetadata.resourceId),
        savings=todouble(properties.extendedProperties.savingsAmount),
        tracked=tobool(properties.tracked),
        recommendationSolution=tostring(properties.label),
        currency=tostring(properties.extendedProperties.savingsCurrency)
    | project recommendationTypeId,resources,savings,tracked,recommendationSolution,currency
) on recommendationTypeId
| extend solution = iff(tracked == true, recommendationSolution, metadataSolution)
| summarize
    dcount_resources=dcount(resources),
    sum_savings=bin(sum(savings),0.01)
    by solution,currency
| where sum_savings > 0
| project solution,dcount_resources,sum_savings,currency
| order by sum_savings desc
```

## Related articles

*  [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal)
