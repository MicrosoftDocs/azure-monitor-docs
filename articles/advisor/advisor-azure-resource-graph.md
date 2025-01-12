---
title: Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: article
ms.date: 03/12/2020
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

## Next steps

For more information about Azure Advisor, go to:

* [Introduction to Azure Advisor](advisor-overview.md)
* [Azure Advisor portal basics](advisor-get-started.md)
* [Azure Advisor REST API](/rest/api/advisor/)

To learn more about specific Advisor recommendations, see:

* [Reliability](advisor-reference-reliability-recommendations.md)
* [Security](advisor-security-recommendations.md)
* [Performance](advisor-reference-performance-recommendations.md)
* [Cost](advisor-reference-cost-recommendations.md)
* [Operational excellence](advisor-reference-operational-excellence-recommendations.md)



