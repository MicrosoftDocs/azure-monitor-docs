---
title: Signals in Azure Monitor health models (preview)
description: Learn signal concepts and configuration for Azure Monitor health models, including signal types, data sources, definitions, and thresholds.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/14/2026
ai-usage: ai-assisted
---

# Signals in Azure Monitor health models (preview)
Signals determine the health of entities in [Azure Monitor health models](./overview.md). This article explains signal concepts and details how to configure and tune signals in the designer.


### Signal types
The following table describes signal types and their data sources.

| Signal type | Data source |
|:---|:---|
| Azure resource | Samples a [platform metric](../essentials/data-platform-metrics.md) from a specific resource and compares it against numeric thresholds. |
| Log Analytics workspace | Runs a [log query](../logs/queries.md) from a Log Analytics workspace and evaluates the result. |
| Azure Monitor workspace | Runs a [PromQL query](../metrics/metrics-explorer.md) from an Azure Monitor workspace and evaluates the result. |

## Configure signals in the designer
To configure signals for an entity, open the [Designer](./designer.md), select the entity, and then select **Edit**. 

On the **Signals** tab, configure these properties when you add the first signal for a signal type:

| Property | Description |
|:---|:---|
| Data source | Source that signal assignments use for evaluation and threshold comparison. Each entity can use one data source per signal type. |
| Authentication setting | Authentication used to read from the data source. The model managed identity is used by default. Select another authentication setting when needed. |

For discovery scenarios, make sure the managed identity has required read permissions for discovery scope and data sources. For details, see [Permissions required](./create.md#permissions-required).






## Reusable signals
Rather than manually create every signal, there are two options to use signals that have already been defined.

| Reusable signal | Description |
|:---|:---|
| Recommended signals | Prebuilt signals for supported resource types with default degraded and unhealthy thresholds. |
| Signal definitions | Reusable signal configurations that you create once and apply across multiple entities for consistent logic and easier maintenance. |
| Import from alert rule | Automtically create signals from alert rules applied to the Azure resource. |


### Add signal assignments
When you select **Add signal assignment**, use one of the following options:

- **Select existing** - Reuse a signal definition already used in the model.
- **Recommended** - Add recommended signals and default thresholds for supported resource types.
- **Create new** - Create a new signal definition for the entity.

### Recommended signals
Recommended signals provide a fast starting point for supported Azure resource types. They include predefined metrics and default degraded and unhealthy thresholds that you can tune after assignment.

Use recommended signals to bootstrap quickly, and then adjust thresholds based on workload behavior and service-level objectives.

## Configure signal types
### Azure resource signals
Azure resource signals evaluate supported metrics for the resource type represented by the entity.

:::image type="content" source="media/designer/azure-resource-signals.png" lightbox="media/designer/azure-resource-signals.png" alt-text="Screenshot of Azure resource signals for an entity.":::

Common properties include metric namespace, metric name, dimension filters, aggregation type, time grain, and degraded/unhealthy thresholds.

### Log Analytics workspace signals
Log Analytics workspace signals run a KQL query and compare the returned numeric value to thresholds.

:::image type="content" source="media/designer/log-signals.png" lightbox="media/designer/log-signals.png" alt-text="Screenshot of log signals for an entity.":::

The query must return a single record with a numeric value. If multiple records are returned, only the first record is used.

Example query:

```kusto
ContainerLogV2
| where _ResourceId == '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.containerservice/managedclusters/my-cluster'
| where LogSource == 'stderr'
| summarize value = count()
```

### Azure Monitor workspace signals
Azure Monitor workspace signals evaluate Prometheus data by running a PromQL query. Use this signal type when workloads use [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md).

The query must return a single record with a numeric value. If multiple records are returned, only the first record is used.

## Signal definitions and thresholds
A signal definition contains all properties required to evaluate a signal and map results to health states.

You can reuse a definition across entities, or create separate definitions for the same metric with different thresholds.

:::image type="content" source="media/designer/signal-definitions.png" lightbox="media/designer/signal-definitions.png" alt-text="Screenshot of list of signal definitions.":::

Each definition supports:

- **Degraded threshold** - Optional threshold for degraded state.
- **Unhealthy threshold** - Required threshold for unhealthy state.

Choose comparison operators and threshold values based on expected workload behavior.

### Signal definitions
The signal definitions view is useful for understanding the signals that are available in the model and their current thresholds and for cleaning up any unused signals. It provides a list of all the [signal definitions](./designer.md#signal-definitions) in the health model and their thresholds.

You can't add or edit signal definitions from this view, because that requires the context of an entity, but you can delete any signal definitions that aren't used by any entities in the model (indicated by the green tick icon). Select any signal definitions to delete and click **Delete** at the top of the screen. This button will be disabled if any signals that are in use are selected.

:::image type="content" source="media/create/signal-definitions-view.png" lightbox="media/create/signal-definitions-view.png" alt-text="Screenshot of signal definitions view.":::

## Next steps
- [Configure a health model using the designer](./designer.md)
- [Configure alerts in health models](./alerts.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
