---
title: Migrate to the Change Analysis API powered by Azure Resource Graph
description: Learn how to migrate to the Azure Monitor Change Analysis API powered by Azure Resource Graph and what it has to offer.
ms.topic: upgrade-and-migration-article
ms.date: 03/25/2025
---

# Migrate to the Change Analysis API powered by Azure Resource Graph

Azure Monitor Change Analysis (classic) is moving to [Azure Resource Graph](/azure/governance/resource-graph/changes/get-resource-changes) on 10/31/2025. In this guide, you learn:

> [!div class="checklist"]
> - How to migrate your services to the Change Analysis API powered by Azure Resource Graph. 
> - What the Azure Resource Graph Change Analysis API provides.
> - How the Change Analysis API compares with Change Analysis (classic).

## How to migrate

You can migrate your services to the Change Analysis API powered by Resource Graph in one of two ways, depending on your integration scenario.

### Via PowerShell or the Azure CLI

If you're using PowerShell or the Azure CLI for resource changes, refer to [Get resource changes](/azure/governance/resource-graph/changes/get-resource-changes) to migrate to the Change Analysis API powered by Resource Graph.

To query the Change Analysis API powered by Resource Graph:

1. Install the Graph Query extension for Resource Graph.
    You're prompted to install this extension via the command line if it isn't already installed.

1. Use Kusto Query Language (KQL).
    Resource Graph queries use the full power of KQL, which provides granular filtering so that you can see specific values. The classic method returns all values.

To review how you're using the classic experience, refer to the following links. You can perform queries within a specified time range and scope them by subscription, resource group, or resource.

- **PowerShell**: [`Get-AzChangeAnalysis` (`Az.ChangeAnalysis`)](/powershell/module/az.changeanalysis/get-azchangeanalysis)
- **Azure CLI**: [`az change-analysis`](/cli/azure/change-analysis)

Learn more by using the [Resource Graph guidance](/azure/governance/resource-graph/changes/get-resource-changes).

### Via SDK

If you're calling the Change Analysis REST API directly (without CLI or PowerShell) via the Resource Graph .NET SDK or the Change Analysis .NET SDK, use the following links:

- **Resource Graph Change Analysis SDK**: [`ResourceGraphExtensions` Class (`Azure.ResourceManager.ResourceGraph`)](/dotnet/api/azure.resourcemanager.resourcegraph.resourcegraphextensions)

    Here are some code samples for the resources table: [`azure-sdk-for-net/sdk/resourcegraph/Azure.ResourceManager.ResourceGraph/tests/Generated/Samples/Sample_TenantResourceExtensions.cs`](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/resourcegraph/Azure.ResourceManager.ResourceGraph/tests/Generated/Samples/Sample_TenantResourceExtensions.cs)

- **Classic SDK**: [`ChangeAnalysisExtensions` Class](/dotnet/api/azure.resourcemanager.changeanalysis.changeanalysisextensions)

## What the Change Analysis API powered by Resource Graph provides

At a high level, the updated Change Analysis API offers:

- **Real-time insights**: Monitor changes occurring on your resources [directly within the Azure portal](https://portal.azure.com/#view/Microsoft_Azure_OneInventory/ResourceChangesOverview.ReactView).
- **Granular filtering**: Filter changes based on the type of change, such as creation, updates, deletions, subscriptions, resource groups, and timeframes.
- **Grouping capabilities**: Group changes by various parameters, such as subscription, resource group, type, resource, change type, client type, and more.
- **Change actor identification**: Gain visibility into the individuals responsible for making changes and the methods used for those modifications.
- **Cross-query**: Join across tables to look for changes based on dynamic values in the current resources' configurations, such as tags and location.
- **Alerting**: With the Resource Graph Log Analytics connector, create alerts on your changes, such as when a change to a resource was made through the Azure portal.

Learn more about the [Change Analysis API powered by Resource Graph](/azure/governance/resource-graph/changes/resource-graph-changes).

## Compare Azure Monitor Change Analysis (classic) and the Change Analysis API powered by Resource Graph

| Feature/experience | Azure Monitor Change Analysis (classic) | Change Analysis APIs from Resource Graph | 
| ------------------ | ----------------------------- | --------------------------------------- |
| Time range | 14 days | 14 days |
| Supported resource types | [Use Change Analysis (classic) in Azure Monitor to find web app issues](./change-analysis.md) | [Supported Resource Manager resource types](/azure/governance/resource-graph/reference/supported-tables-resources) |
| Web app in-app data (app settings, file changes, environmental variables) | Yes | No |
| Automatic onboarding for data collection | No | Yes |
| Resource type | `Microsoft.ChangeAnalysis/changes` and `Microsoft.ChangeAnalysis/ resourcechanges` | `Microsoft.ResourceGraph/ resourceChanges` |
| [Change Actor](/azure/governance/resource-graph/changes/get-resource-changes) | No | Yes |
| Resource Graph query support | No | Yes |
| Granular filtering (including Change Type and Change Actor filters) | No | Yes |
| Grouping | No | Yes |
| Integration with Power BI | No | Yes |

## Related content

Learn more about the Change Analysis API powered by Resource Graph:

- [Analyze changes to your Azure resources](/azure/governance/resource-graph/changes/resource-graph-changes)
- [Get resource changes](/azure/governance/resource-graph/changes/get-resource-changes)
- [View resource changes in the portal](/azure/governance/resource-graph/changes/view-resource-changes)
