---
title: Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: concept-article
ms.date: 04/13/2026
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

## Recommendation state fields
The `advisorresources` table includes fields that represent the lifecycle state of each recommendation. Use the following **consolidated state fields** when querying recommendation status:

| Field | Description | Example values |
| :-- | :-- | :-- |
| `properties.recommendationStatus` | The current consolidated status of the recommendation. This is the single source of truth for recommendation state. | `New, Completed` |
| `properties.completionType` | How the recommendation was resolved or completed. Only populated when `recommendationStatus` is `Completed`. | `SystemVerified`|
| `properties.lastUpdated` | Timestamp of the most recent state change for the recommendation. | `2026-04-09T11:41:28Z` |

> [!IMPORTANT] Important: The `advisorresources` table also contains internal fields named `customerState` and `platformState`. These are **internal implementation details** and should **not** be used by customers. Always use
> `recommendationStatus` as the single source of truth for a recommendation's current state.

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


## Examples

### Get active cost recommendations

```kusto
advisorresources
| where type =~ 'microsoft.advisor/recommendations'
| where isempty(properties.tracked) or properties.tracked == false
| extend termMatch = iff((isnotnull(properties.extendedProperties) and isnotempty(properties.extendedProperties.term) and properties.extendedProperties.term == 'P3Y'), true, false)
| extend lookbackPeriodMatch = iff((isnotnull(properties.extendedProperties) and isnotempty(properties.extendedProperties.lookbackPeriod) and properties.extendedProperties.lookbackPeriod == '30'), true, (properties.recommendationTypeId == '84b1a508-fc21-49da-979e-96894f1665df' and isempty(properties.extendedProperties.lookbackPeriod) and "30" == "30"))
| extend riFilterCondition = iff((termMatch == true and lookbackPeriodMatch == true), true, (isnull(properties.extendedProperties) or (not(bag_has_key(properties.extendedProperties, "term")) and not(bag_has_key(properties.extendedProperties, "lookbackPeriod")))))
| where iff(properties.recommendationTypeId in ("0169a2e1-c7bf-4c37-90b8-0714811c82d3", "06ad499a-0952-48d3-b061-ec81c9cabb8b", "0d524e8d-4cfd-4db5-9f91-8b4bb5235a8e", "0eb54047-acd9-4f26-8ffb-8cec713782d6", "10aedd06-621e-4b4f-a45c-5256573e0191", "148cdd60-97e8-426b-a7b9-141b7cb4bc2f", "171f87ad-4ead-42fc-8f32-a3b18d451837", "1b8c5187-32a6-4a2f-8ca1-b0b7d6ce9e86", "32755df6-aa2f-48d7-9ab7-92b8a80352ea", "3327646a-c325-417f-a3e3-36ae7119da69", "3f6c5689-6a05-4896-a6e0-c6f8a22a44c2", "407b6ad6-8e0b-40e7-9384-643520cae0ed", "5b8ddf04-be28-44ec-ab2c-a63a34d1de13", "680a5388-28aa-44e8-88af-32e3598dc869", "6dcd6657-7a07-404a-b462-db76946f6a97", "84b1a508-fc21-49da-979e-96894f1665df", "885cd4f5-dfa0-4d68-bbfd-00f89fc2b69c", "8ee30d6b-2c73-452a-b4ad-e4386cd6f7d0", "a205074f-8049-48b3-903f-556f5e530ae3", "a8fd63ce-4600-43eb-af33-a6d5481f5930", "db621e98-4a20-4942-b174-c455dc71dbae", "f0382960-6906-4b0d-add3-ed12690bff31", "89515250-1243-43d1-b4e7-f9437cedffd8", "9ed827e8-2a1c-45f3-93f0-df6962034a33", "dadc1876-61e3-42fc-a70e-e863bbc460b6", "7ac18a52-fb6c-4931-8d9d-ef5efff6acf0"), riFilterCondition, true)
| project id, stableId = name, subscriptionId, resourceGroup, properties
| join kind = leftouter  (advisorresources | where type =~ 'microsoft.advisor/configurations' | where isempty(resourceGroup) == true | project subscriptionId, excludeRecomm = properties.exclude, lowCpuThreshold = properties.lowCpuThreshold) on subscriptionId
| extend isActive1 = iff(isempty(excludeRecomm), true, tobool(excludeRecomm) == false)
| extend isActive2 = iff((properties.recommendationTypeId in ("e10b1381-5f0a-47ff-8c7b-37bd13d7c974", "94aea435-ef39-493f-a547-8408092c22a7")), iff((isnotempty(lowCpuThreshold) and isnotnull(properties.extendedProperties) and isnotempty(properties.extendedProperties.MaxCpuP95)), todouble(properties.extendedProperties.MaxCpuP95) < todouble(lowCpuThreshold), iff((isnull(properties.extendedProperties) or isempty(properties.extendedProperties.MaxCpuP95) or todouble(properties.extendedProperties.MaxCpuP95) < 100), true, false)), true)
| where isActive1 == true and isActive2 == true
| join kind = leftouter  (advisorresources | where type =~ 'microsoft.advisor/configurations' | where isnotempty(resourceGroup) == true | project subscriptionId, resourceGroup, excludeProperty = properties.exclude) on subscriptionId, resourceGroup
| extend isActive3 = iff(isempty(excludeProperty), true, tobool(excludeProperty) == false)
| where isActive3 == true
| summarize by id, stableId, subscriptionId, resourceGroup, tostring(properties)
| extend properties = parse_json(properties)
| extend extendedProperties = properties.extendedProperties
| extend workloadList = iff((isnotempty(extendedProperties) and isnotempty(extendedProperties.workloads)), replace("'", '"', tostring(extendedProperties.workloads)), dynamic(null))
| extend workloadList=parse_json(tostring(workloadList))
| mv-expand workload = workloadList
| extend workloadName = tostring(workload.WorkloadName)
| summarize make_set(workloadName) by id, stableId, subscriptionId, resourceGroup, workloadName, tostring(properties)
| extend properties = parse_json(properties)
| extend recommendationTypeId = tostring(properties.recommendationTypeId)
| extend resourceId = tolower(tostring(properties.resourceMetadata.resourceId))
| extend _nonSubResource = extract('providers/(.*)', 1, resourceId, typeof(string))
| extend resourceType = iff(isnotempty(_nonSubResource), strcat(split(_nonSubResource, '/')[0], '/', split(_nonSubResource, '/')[1]), 'microsoft.subscriptions/subscriptions')
| extend category = tostring(properties.category)
| extend impact = tolower(tostring(properties.impact))
| extend description = ''
| extend lastUpdate = tostring(properties.lastUpdated)
| extend recommendationStatus = iff(isnotempty(properties.recommendationStatus), tostring(properties.recommendationStatus), 'New')
| extend extendedProperties = properties.extendedProperties
| extend recommendationSubcategory = tostring(extendedProperties.recommendationSubCategory)
| extend annualSavingsAmount = toreal(extendedProperties.annualSavingsAmount)
| extend savingsCurrency = tostring(extendedProperties.savingsCurrency)
| extend PotentialMonthlyCarbonSavings =  todouble(coalesce(extendedProperties.PotentialMonthlyCarbonSavings, extendedProperties.potentialMonthlyCarbonSavings))
| extend descriptionOfChanges = tostring(extendedProperties.descriptionOfChanges), recommendationCostImplication = tostring(extendedProperties.recommendationCostImplication)
| project subscriptionId, recommendationTypeId, recommendationSubcategory, resourceType, category, impact, resourceId, description, lastUpdate, annualSavingsAmount, savingsCurrency, resourceGroup, PotentialMonthlyCarbonSavings, descriptionOfChanges, recommendationCostImplication, workloadName, recommendationStatus, extendedProperties
| where recommendationStatus == 'New'
| where category == "Cost"
| summarize annualSavingsAmount=sum(annualSavingsAmount), subscriptionId=any(subscriptionId), resourceType=any(resourceType), resourceGroup=any(resourceGroup), recommendationSubcategory=any(recommendationSubcategory), category=any(category), resourceList = make_set(tolower(resourceId)), impact=any(impact), PotentialMonthlyCarbonSavings = iif(array_length(make_set(PotentialMonthlyCarbonSavings)) > 0, sum(PotentialMonthlyCarbonSavings), double(null)), description=any(description), maxLastUpdate=max(lastUpdate), recommendationCount = dcount(recommendationTypeId), instanceCount = count(), extendedProperties = any(extendedProperties) by savingsCurrency, recommendationTypeId
| extend savings = pack('annualSavingsAmount', annualSavingsAmount, 'savingsCurrency', savingsCurrency)
| extend impactNumber = case(impact == 'high', '0', impact == 'medium', '1', '2')
| summarize maxLastUpdate = max(maxLastUpdate), recommendationCount = sum(recommendationCount), instanceCount = sum(instanceCount), resourceCount = array_length(make_set(resourceList)), savings = make_set_if(savings, savings.annualSavingsAmount != 0), category = any(category), impactNumber = any(impactNumber), description = any(description), potentialBenefitsComputed = max(annualSavingsAmount), potentialMonthlyCarbonSavings = max(PotentialMonthlyCarbonSavings), retirementFeatureName = any(extendedProperties.retirementFeatureName), retirementDate = any(extendedProperties.retirementDate) by recommendationTypeId
| join kind=leftouter (advisorresources | where type =~ 'microsoft.advisor/recommendations' | where isempty(properties.tracked) or properties.tracked == false | where isempty(properties.recommendationStatus) or properties.recommendationStatus != 'Dismissed' | extend _termMatch = iff((isnotnull(properties.extendedProperties) and isnotempty(properties.extendedProperties.term) and properties.extendedProperties.term == 'P3Y'), true, false) | extend _lookbackMatch = iff((isnotnull(properties.extendedProperties) and isnotempty(properties.extendedProperties.lookbackPeriod) and properties.extendedProperties.lookbackPeriod == '30'), true, (properties.recommendationTypeId == '84b1a508-fc21-49da-979e-96894f1665df' and isempty(properties.extendedProperties.lookbackPeriod) and "30" == "30")) | extend _riFilter = iff((_termMatch == true and _lookbackMatch == true), true, (isnull(properties.extendedProperties) or (not(bag_has_key(properties.extendedProperties, "term")) and not(bag_has_key(properties.extendedProperties, "lookbackPeriod"))))) | where iff(properties.recommendationTypeId in ("0169a2e1-c7bf-4c37-90b8-0714811c82d3", "06ad499a-0952-48d3-b061-ec81c9cabb8b", "0d524e8d-4cfd-4db5-9f91-8b4bb5235a8e", "0eb54047-acd9-4f26-8ffb-8cec713782d6", "10aedd06-621e-4b4f-a45c-5256573e0191", "148cdd60-97e8-426b-a7b9-141b7cb4bc2f", "171f87ad-4ead-42fc-8f32-a3b18d451837", "1b8c5187-32a6-4a2f-8ca1-b0b7d6ce9e86", "32755df6-aa2f-48d7-9ab7-92b8a80352ea", "3327646a-c325-417f-a3e3-36ae7119da69", "3f6c5689-6a05-4896-a6e0-c6f8a22a44c2", "407b6ad6-8e0b-40e7-9384-643520cae0ed", "5b8ddf04-be28-44ec-ab2c-a63a34d1de13", "680a5388-28aa-44e8-88af-32e3598dc869", "6dcd6657-7a07-404a-b462-db76946f6a97", "84b1a508-fc21-49da-979e-96894f1665df", "885cd4f5-dfa0-4d68-bbfd-00f89fc2b69c", "8ee30d6b-2c73-452a-b4ad-e4386cd6f7d0", "a205074f-8049-48b3-903f-556f5e530ae3", "a8fd63ce-4600-43eb-af33-a6d5481f5930", "db621e98-4a20-4942-b174-c455dc71dbae", "f0382960-6906-4b0d-add3-ed12690bff31", "89515250-1243-43d1-b4e7-f9437cedffd8", "9ed827e8-2a1c-45f3-93f0-df6962034a33", "dadc1876-61e3-42fc-a70e-e863bbc460b6", "7ac18a52-fb6c-4931-8d9d-ef5efff6acf0"), _riFilter, true) | extend recommendationTypeId = tostring(properties.recommendationTypeId) | extend recommendationStatus = iff(isnotempty(properties.recommendationStatus), tostring(properties.recommendationStatus), 'New') | extend resourceId = tolower(tostring(properties.resourceMetadata.resourceId)) | extend _nonSubResource = extract('providers/(.*)', 1, resourceId, typeof(string)) | extend resourceType = iff(isnotempty(_nonSubResource), strcat(split(_nonSubResource, '/')[0], '/', split(_nonSubResource, '/')[1]), 'microsoft.subscriptions/subscriptions') | where tostring(properties.category) == "Cost" | summarize totalResourceCount = dcount(resourceId), completedResourceCount = dcountif(resourceId, recommendationStatus == 'Completed'), instanceTotalCount = count(), instanceCompletedCount = countif(recommendationStatus == 'Completed') by recommendationTypeId) on recommendationTypeId
| sort by impactNumber asc, recommendationTypeId asc
```

## Related articles

*  [Quickstart: Run Resource Graph query using Azure portal](/azure/governance/resource-graph/first-query-portal)
