---
title: Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: concept-article
ms.date: 05/11/2026
---

# Query for Advisor data in Azure Resource Graph

Advisor resources are now onboarded to [Azure Resource Graph](https://azure.microsoft.com/features/resource-graph/), which lays the foundation to many at-scale customer scenarios for Advisor recommendations. Before, the following scenarios weren't possible to do at scale, but can now be achieved using Azure Resource Graph:

* Performing complex queries for all your subscriptions in the Azure portal.
* Summarizing recommendations by category types (like reliability, performance) and impact types (high, medium, low).
* Viewing all recommendations for a particular recommendation type.
* Counting impacted resources by recommendation category.

:::image source="./media/azure-resource-graph.png" type="content" alt-text="Screenshot showing Advisor in Azure Resource Graph Explorer.":::

## Advisor resource types in Azure Graph

Available Advisor resource types in [Resource Graph](/azure/governance/resource-graph/):

There are three resource types available for querying under Advisor resources. Here's the list of the resources that are now available for querying in Resource Graph.

* Microsoft.Advisor/configurations
* Microsoft.Advisor/recommendations
* Microsoft.Advisor/suppressions

These resource types are listed under a new table named as *AdvisorResources*, which you can also query in the Resource Graph Explorer in the Azure portal.

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

### Example A: Query active (new) recommendations

```advisorresources
| where type =~ 'microsoft.advisor/recommendations'
| where properties.recommendationStatus == 'New'
| project
    id,
    subscriptionId,
    resourceGroup,
    category = tostring(properties.category),
    impact = tostring(properties.impact),
    description = tostring(properties.shortDescription.solution),
    recommendationStatus = tostring(properties.recommendationStatus),
    lastUpdated = todatetime(properties.lastUpdated)
```
### Example B: Query completed recommendations

```advisorresources
| where type =~ 'microsoft.advisor/recommendations'
| where properties.recommendationStatus == 'Completed'
| project
    id,
    subscriptionId,
    resourceGroup,
    category = tostring(properties.category),
    description = tostring(properties.shortDescription.solution),
    recommendationStatus = tostring(properties.recommendationStatus),
    completionType = tostring(properties.completionType),
    lastUpdated = todatetime(properties.lastUpdated)
| order by lastUpdated desc
```

### Example C: Get active cost recommendations

```advisorresources 
| where type =~ 'microsoft.advisor/recommendations' 
| where isempty(properties.tracked) or properties.tracked == false 
| project id, stableId = name, subscriptionId, resourceGroup, properties 
| where properties.recommendationStatus == "New"
| project
    id,
    stableId,
    subscriptionId,
    resourceGroup,
    properties
| join kind = leftouter  (
    advisorresources
    | where type =~ 'microsoft.advisor/configurations'
    | where isempty(resourceGroup) == true
    | project
        subscriptionId,
        excludeRecomm = properties.exclude,
        lowCpuThreshold = properties.lowCpuThreshold)
    on subscriptionId
| extend isActive1 = iff(isempty(excludeRecomm), true, tobool(excludeRecomm) == false)
| extend isActive2 = iff((properties.recommendationTypeId in ("e10b1381-5f0a-47ff-8c7b-37bd13d7c974", "94aea435-ef39-493f-a547-8408092c22a7")), iff((isnotempty(lowCpuThreshold) and isnotnull(properties.extendedProperties) and isnotempty(properties.extendedProperties.MaxCpuP95)), todouble(properties.extendedProperties.MaxCpuP95) < todouble(lowCpuThreshold), iff((isnull(properties.extendedProperties) or isempty(properties.extendedProperties.MaxCpuP95) or todouble(properties.extendedProperties.MaxCpuP95) < 100), true, false)), true)
| where isActive1 == true and isActive2 == true
| join kind = leftouter  (
    advisorresources
    | where type =~ 'microsoft.advisor/configurations'
    | where isnotempty(resourceGroup) == true
    | project subscriptionId, resourceGroup, excludeProperty = properties.exclude)
    on subscriptionId, resourceGroup
| extend isActive3 = iff(isempty(excludeProperty), true, tobool(excludeProperty) == false)
| where isActive3 == true
| project  id, stableId, subscriptionId, resourceGroup, tostring(properties)
| extend properties = parse_json(properties)
| extend extendedProperties = properties.extendedProperties
| extend recommendationTypeId = tostring(properties.recommendationTypeId)
| extend resourceType = tostring(properties.impactedField)
| extend category = tostring(properties.category)
| extend impact = tolower(tostring(properties.impact))
| extend resourceId = tolower(properties.resourceMetadata.resourceId)
| extend description = tostring(properties.shortDescription.solution)
| extend lastUpdate = tostring(properties.lastUpdated)
| extend extendedProperties = properties.extendedProperties
| extend recommendationSubcategory = tostring(extendedProperties.recommendationSubCategory)
| extend annualSavingsAmount = toreal(extendedProperties.annualSavingsAmount)
| extend savingsCurrency = tostring(extendedProperties.savingsCurrency)
| extend term = tostring(extendedProperties.term)
| extend lookbackPeriod = tostring(extendedProperties.lookbackPeriod)
| where category == 'Cost'
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
| join kind=leftouter (resources | project joinID = toupper(id), tags) on $left.joinID == $right.joinID
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

## Related articles

*  [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal)
