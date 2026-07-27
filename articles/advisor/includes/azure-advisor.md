---
ms.service: azure-advisor
ms.topic: include
ms.date: 07/24/2026
author: ikhapova
ms.author: ikhapova
---

### Potential cost savings from recommendations

This query calculates the monthly cost savings of [Azure Advisor](../advisor-overview.md) recommendations.

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

# [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az graph query -q "advisorresources | where type =~ "microsoft.advisor/metadata" | where tostring(properties.language)=="en" | where tostring(properties.recommendationCategory)=="Cost" | extend recommendationTypeId=tostring(properties.recommendationTypeId) | project recommendationTypeId,     metadataSolution=tostring(properties.label) | join kind=inner (     advisorresources | where type =~ "microsoft.advisor/recommendations" | extend recommendationTypeId=tostring(properties.recommendationTypeId) | extend         resources=tostring(properties.resourceMetadata.resourceId),         savings=todouble(properties.extendedProperties.savingsAmount),         tracked=tobool(properties.tracked),        recommendationSolution=tostring(properties.label),         currency=tostring(properties.extendedProperties.savingsCurrency) | project recommendationTypeId,resources,savings,tracked,recommendationSolution,currency ) on recommendationTypeId | extend solution = iff(tracked == true, recommendationSolution, metadataSolution) | summarize     dcount_resources=dcount(resources),     sum_savings=bin(sum(savings),0.01)     by solution,currency | where sum_savings > 0 | project solution,dcount_resources,sum_savings,currency | order by sum_savings desc"
```

# [Azure PowerShell](#tab/azure-powershell)

```azurepowershell-interactive
Search-AzGraph -Query "advisorresources | where type =~ "microsoft.advisor/metadata" | where tostring(properties.language)=="en" | where tostring(properties.recommendationCategory)=="Cost" | extend recommendationTypeId=tostring(properties.recommendationTypeId) | project recommendationTypeId,     metadataSolution=tostring(properties.label) | join kind=inner (     advisorresources | where type =~ "microsoft.advisor/recommendations" | extend recommendationTypeId=tostring(properties.recommendationTypeId) | extend         resources=tostring(properties.resourceMetadata.resourceId),         savings=todouble(properties.extendedProperties.savingsAmount),         tracked=tobool(properties.tracked),        recommendationSolution=tostring(properties.label),         currency=tostring(properties.extendedProperties.savingsCurrency) | project recommendationTypeId,resources,savings,tracked,recommendationSolution,currency ) on recommendationTypeId | extend solution = iff(tracked == true, recommendationSolution, metadataSolution) | summarize     dcount_resources=dcount(resources),     sum_savings=bin(sum(savings),0.01)     by solution,currency | where sum_savings > 0 | project solution,dcount_resources,sum_savings,currency | order by sum_savings desc"
```

# [Portal](#tab/azure-portal)



- Azure portal: <a href="https://portal.azure.com/#blade/HubsExtension/ArgQueryBlade/query/AdvisorResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.advisor%2frecommendations%27%0a%7c%20where%20properties.category%20%3d%3d%20%27Cost%27%0a%7c%20extend%0a%09resources%20%3d%20tostring(properties.resourceMetadata.resourceId)%2c%0a%09savings%20%3d%20todouble(properties.extendedProperties.savingsAmount)%2c%0a%09solution%20%3d%20tostring(properties.shortDescription.solution)%2c%0a%09currency%20%3d%20tostring(properties.extendedProperties.savingsCurrency)%0a%7c%20summarize%0a%09dcount(resources)%2c%0a%09bin(sum(savings)%2c%200.01)%0a%09by%20solution%2c%20currency%0a%7c%20project%20solution%2c%20dcount_resources%2c%20sum_savings%2c%20currency%0a%7c%20order%20by%20sum_savings%20desc" target="_blank">portal.azure.com</a>
- Azure Government portal: <a href="https://portal.azure.us/#blade/HubsExtension/ArgQueryBlade/query/AdvisorResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.advisor%2frecommendations%27%0a%7c%20where%20properties.category%20%3d%3d%20%27Cost%27%0a%7c%20extend%0a%09resources%20%3d%20tostring(properties.resourceMetadata.resourceId)%2c%0a%09savings%20%3d%20todouble(properties.extendedProperties.savingsAmount)%2c%0a%09solution%20%3d%20tostring(properties.shortDescription.solution)%2c%0a%09currency%20%3d%20tostring(properties.extendedProperties.savingsCurrency)%0a%7c%20summarize%0a%09dcount(resources)%2c%0a%09bin(sum(savings)%2c%200.01)%0a%09by%20solution%2c%20currency%0a%7c%20project%20solution%2c%20dcount_resources%2c%20sum_savings%2c%20currency%0a%7c%20order%20by%20sum_savings%20desc" target="_blank">portal.azure.us</a>
- Microsoft Azure operated by 21Vianet portal: <a href="https://portal.azure.cn/#blade/HubsExtension/ArgQueryBlade/query/AdvisorResources%0a%7c%20where%20type%20%3d%3d%20%27microsoft.advisor%2frecommendations%27%0a%7c%20where%20properties.category%20%3d%3d%20%27Cost%27%0a%7c%20extend%0a%09resources%20%3d%20tostring(properties.resourceMetadata.resourceId)%2c%0a%09savings%20%3d%20todouble(properties.extendedProperties.savingsAmount)%2c%0a%09solution%20%3d%20tostring(properties.shortDescription.solution)%2c%0a%09currency%20%3d%20tostring(properties.extendedProperties.savingsCurrency)%0a%7c%20summarize%0a%09dcount(resources)%2c%0a%09bin(sum(savings)%2c%200.01)%0a%09by%20solution%2c%20currency%0a%7c%20project%20solution%2c%20dcount_resources%2c%20sum_savings%2c%20currency%0a%7c%20order%20by%20sum_savings%20desc" target="_blank">portal.azure.cn</a>

---
