---
title: Migrate to the Azure Resource Graph Change Analysis offering | Microsoft Docs
description: Learn how to migrate to the Azure Resource Graph Change Analysis and what it has to offer.
ms.topic: conceptual
ms.author: hannahhunter
author: hhunter-ms
ms.date: 09/27/2024
ms.subservice: change-analysis
---

# Migrate to the Azure Resource Graph Change Analysis offering

To better support all Azure subscriptions at scale, Azure Monitor Change Analysis is being retired and the experience will be replaced by Azure Resource Graph (ARG) Change Analysis. 

## How to migrate

You can migrate your services to the Azure Resource Graph Change Analysis experience in one of three ways, depending on how your integration scenario. 

> [!NOTE]
> If you have a different integration scenario than the three outlined in this article, [fill out this form](https://forms.office.com/r/JANQSpj0za), explain your integration scenario(s) to the team, and work with them to find a solution. 

# [Azure portal](#tab/portal)

You can [access the Azure Resource Graph Change Analysis experience in the portal](https://ms.portal.azure.com/#view/Microsoft_Azure_OneInventory/ResourceChangesOverview.ReactView). 

[See this table for differences in change data.](#differences-between-azure-monitor-change-analysis-classic-and-azure-resource-graph-change-analysis) If you only view resource changes through the portal UI, you don't need to do anything to migrate. All Change Analysis data in the portal is updated to use Azure Resource Graph's new UI.

[Learn more about the Azure Resource Graph Change Analysis portal experience.](/governance/resource-graph/changes/view-resource-changes.md)

# [PowerShell/Azure CLI](#tab/powershell-cli)

If you're using PowerShell or the Azure CLI to query Azure Monitor Change Analysis (classic), you can perform queries within a specified time range and scope them by subscription, resource group, or resource. For the classic experience, you may have used the following:

- **PowerShell:** [`Get-AzChangeAnalysis` (`Az.ChangeAnalysis`)](/powershell/module/az.changeanalysis/get-azchangeanalysis.md) 
- **Azure CLI:** [`az change-analysis`](/cli/azure/change-analysis.md)

For migrating to Azure Resource Graph Change Analysis, you can query Azure Resource Graph's API for resource changes. To get started querying Azure Resource Graph Change Analysis: 

1. **Install their Graph Query Extension.**  

   You will be prompted to install this extension via the command line if it's not already installed. 

1. **Utilize Kusto Query Language (KQL).**  

   Azure Resource Graph queries leverage the full power of KQL, enabling more granular filtering to see specific values, as opposed to returning all values like the classic method. 

[Learn more using guidance provided by Azure Resource Graph](/governance/resource-graph/changes/get-resource-changes.md).

# [REST APIs](#tab/rest-apis)

If you're calling the Change Analysis REST API directly (without CLI or PowerShell), use the following links: 

- **Classic SDK:** [`ChangeAnalysisExtensions` Class](/dotnet/api/azure.resourcemanager.changeanalysis.changeanalysisextensions.md) 

- **ARG Change Analysis SDK:** [`ResourceGraphExtensions` Class (`Azure.ResourceManager.ResourceGraph`)](/dotnet/api/azure.resourcemanager.resourcegraph.resourcegraphextensions.md)

Here are some code samples for the resources table: 
[`azure-sdk-for-net/sdk/resourcegraph/Azure.ResourceManager.ResourceGraph/samples/Generated/Samples/Sample_TenantResourceExtensions.cs`](https://github.com/Azure/azure-sdk-for-net/blob/main/sdk/resourcegraph/Azure.ResourceManager.ResourceGraph/samples/Generated/Samples/Sample_TenantResourceExtensions.cs) 

---

## What Azure Resource Graph Change Analysis provides 

At a high level, the Azure Resource Graph Change Analysis offers the following: 

Real-time Insights: Monitor changes occurring on your resources directly within the Azure Portal here. 

Granular Filtering: Filter changes based on creation, updates, or deletions, as well as subscriptions, resource groups, and timeframes. 

Grouping Capabilities: Group changes by various parameters such as subscription, resource group, type, resource, change type, client type, and more. 

Change Actor Identification: Gain visibility into the individuals responsible for making changes and the methods used for those modifications. 

[Learn more about the Azure Resource Graph Change Analysis.](/governance/resource-graph/changes/resource-graph-changes.md)  

## Differences between Azure Monitor Change Analysis (Classic) and Azure Resource Graph Change Analysis

| Feature/experience | Azure Monitor Change Analysis | Azure Resource Graph Change Analysis | 
| ------------------ | ----------------------------- | --------------------------------------- |
| Data: Time range | 14 days | 14 days |
| Data: "Tracked" resources | Yes | Yes |
| Data: "Proxy" resources | Yes, onboarding required | Yes, onboarding required |
| Data: Web App - App Settings | Yes | No |
| Data: Web App - File changes | Yes | No |
| Data: Web App - Env Vars | Yes | No |
| Data: Onboarding for data collection | Yes, starting customer's first interaction per subscription with AzMon CA on Portal UX. This collects proxy resource and web app data listed elsewhere. | Automatic for all Azure customers |
| API: Endpoint | `Microsoft.ChangeAnalysis/changes` and `Microsoft.ChangeAnalysis/ resourcechanges` | `Microsoft.Resources/ resources` |
| UX: List of changes | Yes | Yes |
| UX: Side by side snapshot compare | Yes | Yes, but not for deleted resources |
| UX: Filter - Subscription, resource group, resource, time range | Yes | Yes |
| UX: Filter - Entire tenant | No | Yes |
| UX: Count of create, update, delete changes | No | Yes |
| Data/UX: Change Actor | No | Yes |
| UX: Change levels | Yes (normal/important/noisy) | Yes (normal/important) |

## Next steps

Learn more about the Azure Resource Graph Change Analysis:
- [Analyze changes to your Azure resources](/governance/resource-graph/changes/resource-graph-changes.md)
- [Get resource changes](/governance/resource-graph/changes/get-resource-changes.md)
- [View resource changes in the portal](/governance/resource-graph/changes/view-resource-changes.md)