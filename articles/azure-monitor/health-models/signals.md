---
title: Signals in Azure Monitor health models (preview)
description: Learn signal concepts and configuration for Azure Monitor health models, including signal types, data sources, definitions, and thresholds.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/25/2026
ai-usage: ai-assisted
---

# Create and configure signals in Azure Monitor health models (preview)
[Signals](./concepts.md#signals) determine the health of entities in [Azure Monitor health models](./overview.md). This article explains how to configure and tune signals in the designer.

## Signal types
Each entity in a health model can use any of the available signal types described in the following table.

| Signal type | Data source |
|:---|:---|
| Azure resource | Samples a [platform metric](../essentials/data-platform-metrics.md) from a specific resource and compares it against numeric thresholds. |
| Log Analytics workspace | Runs a [log query](../logs/queries.md) from a Log Analytics workspace and evaluates the result. |
| Azure Monitor workspace | Runs a [PromQL query](../metrics/metrics-explorer.md) from an Azure Monitor workspace and evaluates the result. |

## Configure signals in the designer
The **Signals** tab of the [entity editor](./designer.md#entities) allows you to create or edit signals and assign them to the entity. If a signal type is defined for the entity, then you can configure its details. If not, then you're given an option to enable and configure that type.

:::image type="content" source="media/signals/signals-empty.png" lightbox="media/signals/signals-empty.png" alt-text="Screenshot of signals page for an entity.":::

When you add the first signal of a particular type to an entity, you must specify the following properties. You can change these properties later.

| Property | Description |
|:---|:---|
| Data source | The signals that are added to the entity will access this data source to apply their logic and compare to their threshold. Each entity can have only one data source for each signal type, but you can have multiple signals of that type that use the same data source. Each signal type uses a different type of data source that you must configure for each entity. See the data source for each signal type in [Signal types](#signal-types). |
| Authentication setting | The **Authentication setting** specifies the authentication setting used by the entity to access the data source. The managed identity you specified when you created the health model is used by default. You can create additional settings in the [Authentication settings](./create.md#identity) view.<br><br>An icon specifies whether the method has required access to collect telemetry from the resource. Click **Change** to select another authentication setting. . See [Permissions required](./create.md#permissions-required) for the managed identity requirements. |

## Add signal assignment
When you click **Add a signal assignment** in the entity editor, you have multiple options.

| Option | Description |
|:---|:---|
| Create new | Create a new metric signal for the entity and optionally save as a signal definition. |
| Signal definitions | Select from [signal definitions](#signal-definitions) that you previously created in the current health model. |
| Recommended | Select from a predefined set of recommended signals and thresholds for the resource type. (Azure resource signals only) |
| Import from alert rules | Create a signal based on existing alert rules that are defined for the Azure resource represented by the entity. The same signal and criteria from the alert rule is used for the new signal. |

## Signal details

The details required for each signal will vary depending on its type.

### [Azure resource](#tab/azureresource)
### Azure resource signals
Azure resource signals sample the value of a [platform metric](../essentials/data-platform-metrics.md) from a particular resource and compare against a numeric threshold to determine the health state. Only metric definitions that are supported for the resource type of the Azure resource represented by the entity are available.


:::image type="content" source="media/signals/azure-resource-signals.png" lightbox="media/signals/azure-resource-signals.png" alt-text="Screenshot of Azure resource signals for an entity.":::

### Signal properties

The following tables describe the properties that define an Azure resource signal.


| Setting | Description |
|:---|:---|
| Display name | The name of the signal as it appears in the health model. This defaults to the name of the metric but can be modified later. |
| Refresh interval | The interval at which the metric data is refreshed. This is typically set to 1 minute, but can be set to a longer interval if desired. |
| Metric namespace | The namespace of the metric. Each resource type will typically have a single namespace, but some resource types may have multiple. Each namespace has its own set of metrics. |
| Metric | Metric to use for the signal. In the Azure portal, you can select from a list of all metrics in the selected namespace. The most commonly used metrics for the resource type are listed at the top. |
| Description | Description of the metric. This is a read-only value that is provided by the metric definition. |
| Dimension | Dimension for the signal if the metric supports them. Dimensions are used to define difference instances of the metric on the Azure resource.  |
| Dimension filter | Only available if a dimension is selected. Filters data for only the specified dimension value. |
| Aggregation Type | Method used to aggregate the different data samples over the *Time grain*. Metric data is sampled every minute, so there will typically be multiple values collected over the time grain specified for the signal. Different aggregations will be available for different metrics.<br><br>Examples of common aggregations include:<br><br>- Average - Average of the values collected over the time grain<br>- Maximum - Maximum of the different values collected over the time grain<br>- Total - Sum total of the values collected over the time grain |
| Time grain | Length of time over which metric values are collected and then aggregated using the specified aggregation method. |
| Degraded threshold | If this calculation is true, and the Unhealthy calculation is false, then the state of the entity is set to **Degraded**. If both this and the Unhealthy calculation are false, then the health of the entity is set to **Healthy**. Select **Remove threshold** to not use a degraded threshold. |
| Unhealthy threshold | If this calculation is true, then the state of the entity is set to **Unhealthy**. If this calculation is false, then the **Degraded** threshold is checked. |

### [Log Analytics workspace](#tab/loganalyticsworkspace)

### Log Analytics workspace signals
Log Analytics workspace signals run a [log query](../logs/queries.md) against a Log Analytics workspace and compare the results to the thresholds to determine the health state. Use log signals to search for errors in log data or to perform complex calculations on numeric data stored in the Log Analytics workspace.

:::image type="content" source="media/signals/log-signals.png" lightbox="media/signals/log-signals.png" alt-text="Screenshot of log signals for an entity.":::

### Log Analytics workspace
Before you can create a Log Analytics workspace signal, you must specify the workspace to query and the authentication that the health model will use to access it. You can only specify a single workspace for each entity, but you can have multiple signals using different log queries from this workspace.

### Log query
The log query must return a single record with a numeric value. If the record includes multiple columns, then you can specify which column to use as the signal value. The query should return a single record. If it returns multiple records, then only the first record is used.

The following example shows a log query that returns a count of error logs in the last hour. 

```kusto
ContainerLogV2
| where _ResourceId == '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.containerservice/managedclusters/my-cluster' 
| where LogSource == 'stderr'
| summarize value = count()
```

### Signal properties
The following table describes the properties that define Log Analytics workspace signal.

| Setting | Description |
|:---|:---|
| Display name | Name of the signal as it appears in the health model. |
| Refresh interval | How often the query should be run. |
| Query text | The text of the log query to run. Click **Edit query** to create a new query or edit an existing one. Log Analytics interface is displayed where you can write queries and test the results. |
| Query time range | The time range for the records retrieved by the query. It will only retrieve data from this time range. The value is set in the query editor when you edit the query. |
| Value column name | The name of the column returned from the query that contains the value to compare to the thresholds for each health state. |
| Data unit | Label for the units of the value returned from the query. This doesn't affect the results but only how the value is displayed. |
| Degraded threshold | If this calculation is true, and the Unhealthy calculation is false, then the state of the entity is set to **Degraded**. If both this and the Unhealthy calculation are false, then the health of the entity is set to **Healthy**. |
| Unhealthy threshold | If this calculation is true, then the state of the entity is set to **Unhealthy**. If this calculation is false, then the **Degraded** threshold is checked. |


### [Azure Monitor workspace](#tab/azuremonitorworkspace)

### Azure Monitor workspace signals
Azure Monitor workspace signals run a [PromQL query](../metrics/metrics-explorer.md) to analyze Prometheus data and evaluate the results to determine the health state. Use Azure Monitor workspace signals in place of metric signals for resources that have metric data scraped by [Azure Monitor managed service for Prometheus](../essentials/prometheus-metrics-overview.md). The log query must return a single record with a numeric value. 

### Azure Monitor workspace
Before you can create an Azure Monitor workspace signal, you must specify the workspace to query and the authentication that the health model will use to access it. You can only specify a single workspace for each entity.

### Signal properties
The following table describes the properties that define Azure Monitor workspace signal.


| Setting | Description |
|:---|:---|
| Display name | Name of the signal as it appears in the health model. |
| Refresh interval | How often the query should be run. |
| Query text | The text of the PromQL query to run. The query must return a single record with a numeric value. If it returns multiple records, then only the first record is used. |
| Query time range | The time range for the records retrieved by the query. It will only retrieve data from this time range.  |
| Data unit | The unit of measurement for the signal data. |
| Degraded threshold | If this calculation is true, and the Unhealthy calculation is false, then the state of the entity is set to **Degraded**. If both this and the Unhealthy calculation are false, then the health of the entity is set to **Healthy**. |
| Unhealthy threshold | If this calculation is true, then the state of the entity is set to **Unhealthy**. If this calculation is false, then the **Degraded** threshold is checked. |

---


## Thresholds
Thresholds are numeric values that are compared to the value of the signal to determine its health state. Each signal definition has two thresholds, one for the **Degraded** state and one for the **Unhealthy** state. The degraded threshold is optional, but the unhealthy threshold is required. 

You can specify the operator for each threshold to determine how the signal value is compared. Some signals might indicate a degraded or unhealthy state when the value is above the threshold, while others might indicate a degraded or unhealthy state when the value is below the threshold. 

To define both thresholds for a signal definition ensure that degraded threshold is set to a value that is less than the unhealthy threshold. The degraded state will be set if the signal value is between the degraded and unhealthy thresholds. If the signal value is above the unhealthy threshold, then the entity is set to the unhealthy state. If the signal value is below the degraded threshold, then the entity is set to the healthy state.



## Signal definitions
Rather than create a new signal for each entity, you can define a signal once and reuse it across multiple entities by creating a signal definition. Signal definitions are reusable configurations that define a specific signal and its associated thresholds. 

To create a signal definition, select **Save as new signal definition** when editing a signal instead of **Add to entity**. 

:::image type="content" source="media/signals/save-signal-definition.png" lightbox="media/signals/save-signal-definition.png" alt-text="Screenshot showing Save as new signal definition in the signal editor.":::

Signal definitions are displayed along with other signals for an entity, but have a unique icon to distinguish them from other signals.

:::image type="content" source="media/signals/sample-signal-definition.png" lightbox="media/signals/sample-signal-definition.png" alt-text="Screenshot showing sample signal definition.":::

To add a signal definition to another entity, select **Signal definitions** to choose from the available signal definitions.

:::image type="content" source="media/signals/add-signal-definition.png" lightbox="media/signals/add-signal-definition.png" alt-text="Screenshot showing signal definition option in the signal editor.":::


Edit signal definitions in the designer as you would edit any other signal. When you edit the signal definition for one entity, the changes will be applied to all entities that use that signal definition. You might use the same metric to measure the health of multiple entities, but different entities might require different thresholds. In this case, create multiple signal definitions with different thresholds.

The **Signal definitions** view lists all of the signal definitions in the health model. Click on any signal definition to view its details including the entities that use it.

:::image type="content" source="media/signals/signal-definitions-view.png" lightbox="media/signals/signal-definitions-view.png" alt-text="Screenshot showing the signal definitions view.":::

To delete a signal definition, open the signal definitions view, select any signal definitions to delete, and click **Delete** at the top of the screen. This button will be disabled if any of the selected signals are in use by an entity in the health model.

## Next steps
- [Configure a health model using the designer](./designer.md)
- [Configure alerts in health models](./alerts.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
