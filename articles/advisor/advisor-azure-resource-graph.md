---
title: Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: article
ms.date: 10/27/2025
---

# Query for Advisor data in Resource Graph Explorer (Azure Resource Graph)

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

## Examples

### Get active cost recommendations

```kusto
advisorresources 
| where type =~ 'microsoft.advisor/recommendations' 
| where (properties.category == 'Security' and properties.lastUpdated > ago(60h)) or properties.lastUpdated >= ago(1d) 
| where isempty(properties.tracked) or properties.tracked == false 
| project id, stableId = name, subscriptionId, resourceGroup, properties 
| join kind = leftouter (
    advisorresources
    | where type =~ 'microsoft.advisor/suppressions' 
    | extend tokens = split(id, '/') 
    | extend stableId = iff(array_length(tokens) > 3, tokens[(array_length(tokens) - 3)], '') 
    | extend expirationTimeStamp = todatetime(iff(strcmp(tostring(properties.ttl), '-1') == 0, '9999-12-31', properties.expirationTimeStamp)) 
    | where expirationTimeStamp > now() 
    | project
        suppressionId = tostring(properties.suppressionId),
        stableId,
        expirationTimeStamp)
    on stableId 
| project
    id,
    stableId,
    subscriptionId,
    resourceGroup,
    properties,
    expirationTimeStamp,
    suppressionId
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
| summarize
    expirationTimeStamp = max(expirationTimeStamp),
    suppressionIds = make_list(suppressionId)
    by id, stableId, subscriptionId, resourceGroup, tostring(properties)
| extend properties = parse_json(properties)
| extend extendedProperties = properties.extendedProperties
| extend properties = parse_json(properties)
| extend recommendationTypeId = tostring(properties.recommendationTypeId)
| extend resourceType = tostring(properties.impactedField)
| extend category = tostring(properties.category)
| extend impact = tolower(tostring(properties.impact))
| extend resourceId = tolower(substring(id, 0, strlen(id) - 81))
| extend description = tostring(properties.shortDescription.solution)
| extend lastUpdate = tostring(properties.lastUpdated)
| extend isRecommendationActive = (isnull(expirationTimeStamp) or isempty(expirationTimeStamp))
| extend extendedProperties = properties.extendedProperties
| extend recommendationSubcategory = tostring(extendedProperties.recommendationSubCategory)
| extend annualSavingsAmount = toreal(extendedProperties.annualSavingsAmount)
| extend savingsCurrency = tostring(extendedProperties.savingsCurrency)
| extend term = tostring(extendedProperties.term)
| extend lookbackPeriod = tostring(extendedProperties.lookbackPeriod)
| where isRecommendationActive == 1
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

*  [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal.md)
