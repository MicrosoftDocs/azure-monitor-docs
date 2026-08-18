---
title: Cost optimization in Azure Monitor
description: Recommendations for reducing costs in Azure Monitor.
ms.topic: best-practice
ms.date: 08/07/2026
ms.reviewer:
ai-usage: ai-assisted
---

# Cost optimization in Azure Monitor

Cost optimization means reducing unnecessary expenses and improving operational efficiencies. Reduce your cost for Azure Monitor by understanding your configuration options and the opportunities to reduce the amount of data that it collects. Before you use this article, review [Azure Monitor cost and usage](cost-usage.md) to understand the different ways that Azure Monitor charges and how to view your monthly bill.

This article provides cost optimization recommendations for Azure Monitor, aligned with the [cost optimization pillar of the Azure Well-Architected Framework](/azure/well-architected/cost-optimization/). Each section covers a specific Azure Monitor feature and describes configuration choices that reduce data collection and lower your bill.

## Azure Monitor Logs cost optimization

[!INCLUDE [waf-logs-cost](../logs/includes/waf-logs-cost.md)]

## Azure resource cost optimization

### Design checklist

> [!div class="checklist"]
> * Collect only critical resource log data from Azure resources.

### Configuration recommendations

| Recommendation | Benefit |
|:---------------|:--------|
| Collect only critical resource log data from Azure resources. | When you create [diagnostic settings](../platform/diagnostic-settings.md) to send [resource logs](../platform/resource-logs.md) for your Azure resources to a Log Analytics database, only specify those categories that you require. Since diagnostic settings don't allow granular filtering of resource logs, use a [workspace transformation](../data-collection/data-collection-transformations.md#workspace-transformation-dcr) to filter unneeded data for those resources that use a [supported table](../reference/tables-features.md). See [Diagnostic settings in Azure Monitor](../platform/diagnostic-settings.md#controlling-costs) for details on how to configure diagnostic settings and using transformations to filter their data. |

## Alert cost optimization

[!INCLUDE [waf-alerts-cost](../alerts/includes/waf-alerts-cost.md)]

## Virtual machine cost optimization

[!INCLUDE [waf-vm-cost](../vm/includes/waf-vm-cost.md)]

## Container cost optimization

[!INCLUDE [waf-containers-cost](../containers/includes/waf-containers-cost.md)]

## Application Insights cost optimization

[!INCLUDE [waf-application-insights-cost](../app/includes/waf-application-insights-cost.md)]

## Next steps

* [Azure Monitor cost and usage](cost-usage.md)
* [Azure Monitor Logs cost calculations and options](../logs/cost-logs.md)
* [Get started monitoring an Azure resource](../platform/monitor-azure-resource.md)
