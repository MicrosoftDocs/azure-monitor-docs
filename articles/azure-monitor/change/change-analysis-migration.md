---
title: Migrate to the Change Analysis API powered by Azure Resource Graph
description: Learn how to migrate to the Change Analysis API powered by Azure Resource Graph and what it has to offer.
ms.topic: conceptual
ms.author: hannahhunter
author: hhunter-ms
ms.date: 10/29/2024
ms.subservice: change-analysis
---

# Migrate to the Change Analysis API powered by Azure Resource Graph

To better support you as you scale in Azure, the Azure Monitor Change Analysis (classic) API is being retired. The experience will be replaced by the Change Analysis API powered by Azure Resource Graph (ARG).

## How to migrate

You can migrate your services to the Change Analysis API powered by ARG in one of two ways, depending on your integration scenario.

### Via PowerShell or Azure CLI

If you're using PowerShell or Azure CLI for resource changes, refer to the [Get resource changes](/azure/governance/resource-graph/changes/get-resource-changes) guide to migrate to Change Analysis API powered by ARG. 

To query Change Analysis API powered by ARG:

1.	**Install ARG's Graph Query Extension.**  
    You'll be prompted to install this extension via the command line if it's not already installed.

1.	**Utilize Kusto Query Language (KQL).** 
    ARG queries use the full power of KQL, enabling more granular filtering to see specific values, as opposed to returning all values like the classic method.

To review how you’re using the classic experience, refer to the following links. You can perform queries within a specified time range and scope them by subscription, resource group, or resource.

- **PowerShell:** [`Get-AzChangeAnalysis` (`Az.ChangeAnalysis`)](/powershell/module/az.changeanalysis/get-azchangeanalysis) 
- **Azure CLI:** [`az change-analysis`](/cli/azure/change-analysis)

[Learn more using guidance provided by ARG](/azure/governance/resource-graph/changes/get-resource-changes).

### Via SDK

If you're calling the Change Analysis REST API directly (without CLI or PowerShell) via the ARG .NET SDK or the Change Analysis .NET SDK, use the following links: 

- **ARG Change Analysis SDK:** [`ResourceGraphExtensions` Class (`Azure.ResourceManager.ResourceGraph`)](/dotnet/api/azure.resourcemanager.resourcegraph.resourcegraphextensions)

    Here are some code samples for the resources table: [`azure-sdk-for-net/sdk/resourcegraph/Azure.ResourceManager.ResourceGraph/samples/Generated/Samples/Sample_TenantResourceExtensions.cs`](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/resourcegraph/Azure.ResourceManager.ResourceGraph/samples/Generated/Samples/Sample_TenantResourceExtensions.cs) 

- **Classic SDK:** [`ChangeAnalysisExtensions` Class](/dotnet/api/azure.resourcemanager.changeanalysis.changeanalysisextensions) 

## What Change Analysis API powered by ARG provides 

At a high level, the updated Change Analysis API offers: 

- **Real-time Insights:** Monitor changes occurring on your resources [directly within the Azure portal](https://portal.azure.com/#view/Microsoft_Azure_OneInventory/ResourceChangesOverview.ReactView). 

- **Granular Filtering:** Filter changes based on the type of change: creation, updates, deletions, subscriptions, resource groups, and timeframes. 

- **Grouping Capabilities:** Group changes by various parameters such as subscription, resource group, type, resource, change type, client type, and more. 

- **Change Actor Identification:** Gain visibility into the individuals responsible for making changes and the methods used for those modifications. 

- **Cross-query:** Join across tables to look for changes based on dynamic values in the current resources’ configurations, such as tags and location.

- **Alerting:** With ARG’s Log Analytics connector, create alerts on your changes, such as when a change to a resource was made through the Azure portal.

[Learn more about Change Analysis API powered by ARG.](/azure/governance/resource-graph/changes/resource-graph-changes)  

## Compare Azure Monitor Change Analysis (Classic) and Change Analysis API powered by ARG

| Feature/experience | Azure Monitor Change Analysis (classic) | Change Analysis APIs from ARG | 
| ------------------ | ----------------------------- | --------------------------------------- |
| Time range | 14 days | 14 days |
| Supported resource types | [Use Change Analysis (classic) in Azure Monitor to find web-app issues](./change-analysis.md) | [Supported Azure Resource Manager resource types](/azure/governance/resource-graph/reference/supported-tables-resources) |
| Web App in-app data (app settings, file changes, env vars) | Yes | No |
| Automatic onboarding for data collection | No | Yes |
| Resource type | `Microsoft.ChangeAnalysis/changes` and `Microsoft.ChangeAnalysis/ resourcechanges` | `Microsoft.Resources/ resources` |
| [Change Actor](/azure/governance/resource-graph/changes/get-resource-changes) | No | Yes |
| ARG query support | No | Yes |
| Granular filtering (including Change Type and Change Actor filters) | No | Yes |
| Grouping | No | Yes |
| Integration with Power BI | No | Yes |

## Next steps

Learn more about the Change Analysis API powered by ARG:
- [Analyze changes to your Azure resources](/azure/governance/resource-graph/changes/resource-graph-changes)
- [Get resource changes](/azure/governance/resource-graph/changes/get-resource-changes)
- [View resource changes in the portal](/azure/governance/resource-graph/changes/view-resource-changes)