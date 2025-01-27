---
title: Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: article
ms.date: 12/02/2024
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

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md)

*   [Azure Advisor portal basics](./advisor-get-started.md)

*   [Use Advisor score](./azure-advisor-score.md)

*   [Azure Advisor REST API](/rest/api/advisor)

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md)

*   [Reduce service costs by using Azure Advisor](./advisor-reference-cost-recommendations.md)

*   [Performance recommendations](./advisor-reference-performance-recommendations.md)

*   [Review security recommendations](/azure/defender-for-cloud/review-security-recommendations "Review security recommendations | Defender for Cloud | Microsoft Learn")

*   [Operational excellence recommendations](./advisor-reference-operational-excellence-recommendations.md)
