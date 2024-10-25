---
title: Azure Advisor data in Azure Resource Graph
description: Make queries for Advisor data in Azure Resource Graph
ms.topic: article
ms.date: 03/12/2020
---

# Query for Azure Advisor data in Resource Graph Explorer (Azure Resource Graph)

Azure Advisor resources are now onboarded to [Azure Resource Graph](https://azure.microsoft.com/features/resource-graph/), which lays the foundation to many at-scale customer scenarios for Azure Advisor recommendations. Scenarios that weren't possible before to do at scale, that can now can be achieved using Azure Resource Graph, are:

* The capability to perform complex query for all your subscriptions in the Azure portal.
* Recommendations summarized by category types (like reliability, performance) and impact types (high, medium, low).
* All recommendations for a particular recommendation type.
* Impacted resource count by recommendation category.

![Azure Advisor in Azure resource graph explorer](./media/azure-resource-graph-1.png)  

## Azure Advisor resource types in Azure Graph

Available Azure Advisor resource types in [Resource Graph](/azure/governance/resource-graph/):

There are three resource types available for querying under Azure Advisor resources. Here's the list of the resources that are now available for querying in Resource Graph.

* Microsoft.Advisor/configurations
* Microsoft.Advisor/recommendations
* Microsoft.Advisor/suppressions

These resource types are listed under a new table named as *AdvisorResources*, which you can also query in the Resource Graph Explorer in the Azure portal.

## Next steps

For more information about Azure Advisor, see:

* [Introduction to Azure Advisor](advisor-overview.md)
* [Get started with Azure Advisor](advisor-get-started.md)
* [Azure Advisor REST API](/rest/api/advisor/)

For specific Azure Advisor recommendations, see:

* [Cost](advisor-cost-recommendations.md)
* [Reliability](advisor-high-availability-recommendations.md)
* [Performance](advisor-performance-recommendations.md)
* [Security](advisor-security-recommendations.md)
* [Operational excellence](advisor-operational-excellence-recommendations.md)

