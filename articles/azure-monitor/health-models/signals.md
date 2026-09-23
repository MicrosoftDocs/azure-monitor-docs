---
title: Signals in Azure Monitor health models (preview)
description: Learn signal concepts and configuration for Azure Monitor health models, including signal types, data sources, definitions, and thresholds.
ms.topic: how-to
ms.date: 09/10/2026
ai-usage: ai-assisted
---

# Create and configure signals in Azure Monitor health models (preview)
[Signals](./concepts.md#signals) determine the health of entities in [Azure Monitor health models](./overview.md). This article explains how to configure and tune signals in the designer.

## Signal types
Each entity in a health model can use any of the available signal types described in the following table.

| Signal type | Data source |
|:---|:---|
| Dependencies | Specifies how the health state of dependent entities is aggregated on the entity. |
| Azure resource | Samples a [platform metric](../metrics/data-platform-metrics.md) from a specific resource and compares it against numeric thresholds. |
| Log Analytics workspace | Runs a [log query](../logs/queries.md) from a Log Analytics workspace and evaluates the result. |
| Azure Monitor workspace | Runs a [PromQL query](../metrics/metrics-explorer.md) from an Azure Monitor workspace and evaluates the result. |
| Azure Resource Health | Uses the [Azure Resource Health](../../service-health/resource-health-overview.md) status of the resource represented by the entity, so platform-reported availability contributes to the entity's health state. |
| External health | Data for externally evaluated signals from your application or other monitoring systems. For more information, see [Submit data for externally evaluated signals](./health-report-ingestion.md). |

## Configure signals in the designer
The **Signals** tab of the [entity editor](./designer.md#entities) allows you to create or edit signals and assign them to the entity. If a data source is defined for the entity, then you can configure its details. If not, then you're given an option to enable and configure that type.

:::image type="content" source="media/signals/signals-empty.png" lightbox="media/signals/signals-empty.png" alt-text="Screenshot of signals page for an entity.":::

When you add a data source to an entity, you must specify the following properties. You can change these properties later.

| Property | Description |
|:---|:---|
| Target Azure resource | The signals that you add to the entity access this data source to apply their logic and compare to their threshold. Each entity can have only one data source for each signal type, but you can have multiple signals of that type that use the same data source. Each signal type uses a different type of data source that you must configure for each entity. See the data source for each signal type in [Signal types](#signal-types). |
| Authentication setting | The **Authentication setting** specifies the authentication setting used by the entity to access the data source. The managed identity you specified when you created the health model is used by default. You can create additional settings in the [Authentication settings](./create.md#identity) view.<br><br>An icon specifies whether the method has required access to collect telemetry from the resource. Select **Change** to select another authentication setting. See [Permissions required](./create.md#permissions-required) for the managed identity requirements. |

To modify the data source configuration and save the entity, your user identity needs at least **Reader** access to the target Azure resource. Otherwise, the UI shows an error: _"The associated Azure resource was not found. It might not exist, or you don't have access to it."_

## Add signal assignment
When you select **Add metric/log query/Prometheus signal** in the entity editor, you have multiple options.

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
Azure resource signals sample the value of a [platform metric](../metrics/data-platform-metrics.md) from a particular resource and compare it against a numeric threshold to determine the health state. The signal supports only metric definitions that the represented Azure resource type supports.

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
| Threshold type | Determines how signal values are compared to thresholds. Select **Static** to use the fixed degraded and unhealthy values that you specify, or **Dynamic** to let the signal learn the metric's normal behavior. For more information, see [Dynamic thresholds](./concepts.md#dynamic-thresholds). |
| Sensitivity | Available for dynamic thresholds. Controls how easily the signal reacts to deviations from the machine learning-computed baseline. |
| Degraded threshold | If this calculation is true, and the Unhealthy calculation is false, then the state of the entity is set to **Degraded**. If both this and the Unhealthy calculation are false, then the health of the entity is set to **Healthy**. Select **Remove threshold** to not use a degraded threshold. |
| Unhealthy threshold | If this calculation is true, then the state of the entity is set to **Unhealthy**. If this calculation is false, then the **Degraded** threshold is checked. |

When you set **Threshold type** to **Dynamic**, the signal editor shows the **Sensitivity** setting.

### [Log Analytics workspace](#tab/loganalyticsworkspace)

### Log Analytics workspace signals
Log Analytics workspace signals run a [log query](../logs/queries.md) against a Log Analytics workspace and compare the results to the thresholds to determine the health state. Use log signals to search for errors in log data or to perform complex calculations on numeric data stored in the Log Analytics workspace.

:::image type="content" source="media/signals/log-signals.png" lightbox="media/signals/log-signals.png" alt-text="Screenshot of log signals for an entity.":::

### Log Analytics workspace
Before you can create a Log Analytics workspace signal, you must specify the workspace to query and the authentication that the health model will use to access it. You can only specify a single workspace for each entity, but you can have multiple signals using different log queries from this workspace.

> [!TIP]
> If you need to reference multiple workspaces in the same entity (for example, due to a split in diagnostic settings), use composition: create one entity per workspace, and then connect them to a common parent entity.

### Log query
The log query must return a single record with a numeric value. If the record includes multiple columns, then you can specify which column to use as the signal value. The query should return a single record. If it returns multiple records, then only the first record is used.

The following example shows a log query that returns a count of error logs in the last hour.

```kusto
ContainerLogV2
| where _ResourceId == '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.containerservice/managedclusters/my-cluster'
| where LogSource == 'stderr'
| summarize value = count()
```

The Azure portal provides a visual editor for log queries.

- Use **Insert template** to see the available query template strings and insert them into the query. This command is disabled when the cursor isn't inside a string literal.
- Use **Open in Logs view** to preview query results for a richer authoring experience.
  - Run the query to apply your changes.
  - Query template strings resolve to their actual values, so the Logs view provides accurate results.
  - When you return from the Logs view, resolved values are parsed back into query template strings.

> [!IMPORTANT]
> The Logs view uses your user identity, while signal evaluation uses the identity of the health model. Depending on the permissions assigned to each identity, the query might fail or return different data.

:::image type="content" source="media/signals/log-query-editor.png" lightbox="media/signals/log-query-editor.png" alt-text="Screenshot of log query editor.":::


### Signal properties
The following table describes the properties that define Log Analytics workspace signal.

| Setting | Description |
|:---|:---|
| Display name | Name of the signal as it appears in the health model. |
| Refresh interval | How often the query should be run. |
| Query text | The text of the log query to run. Select **Edit query** to create a new query or edit an existing one. The Log Analytics interface is displayed where you can write queries and test the results. |
| Query time range | The time range for the records retrieved by the query. It will only retrieve data from this time range. The value is set in the query editor when you edit the query. |
| Value column name | The name of the column returned from the query that contains the value to compare to the thresholds for each health state. |
| Data unit | Label for the units of the value returned from the query. This doesn't affect the results but only how the value is displayed. |
| Degraded threshold | If this calculation is true, and the Unhealthy calculation is false, then the state of the entity is set to **Degraded**. If both this and the Unhealthy calculation are false, then the health of the entity is set to **Healthy**. |
| Unhealthy threshold | If this calculation is true, then the state of the entity is set to **Unhealthy**. If this calculation is false, then the **Degraded** threshold is checked. |

### [Azure Monitor workspace](#tab/azuremonitorworkspace)

### Azure Monitor workspace signals
Azure Monitor workspace signals run a [PromQL query](../metrics/metrics-explorer.md) to analyze Prometheus data and evaluate the results to determine the health state. Use Azure Monitor workspace signals in place of metric signals for resources that have metric data scraped by [Azure Monitor managed service for Prometheus](../metrics/prometheus-metrics-overview.md). The log query must return a single record with a numeric value.

:::image type="content" source="media/signals/prometheus-signals.png" lightbox="media/signals/prometheus-signals.png" alt-text="Screenshot of PromQL signals for an entity.":::

### Azure Monitor workspace
Before you can create an Azure Monitor workspace signal, you must specify the workspace to query and the authentication that the health model will use to access it. You can only specify a single workspace for each entity.

### PromQL query

The Azure portal provides a visual editor for Prometheus queries.

- Use **Insert template** to see the available query template strings and insert them into the query. This command is disabled when the cursor isn't inside a string literal.

:::image type="content" source="media/signals/prometheus-query-editor.png" lightbox="media/signals/prometheus-query-editor.png" alt-text="Screenshot of Prometheus query editor.":::

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

## Query templates
Both Log Analytics and Azure Monitor workspace signals support a predefined set of **template strings**. Use templates within string literals in your queries. The health model dynamically replaces them when running signal evaluation.

The following table lists all supported template strings.

| Template string | Description |
|:---|:---|
| `{{healthmodel.name}}` | The name of the health model. |
| `{{entity.name}}` | The name of the entity that owns the signal. |
| **Azure resource templates** | |
| `{{entity.azureResourceId}}` | The full resource ID of the Azure resource associated with the entity. |
| `{{entity.azureResourceId.name}}` | The name of the Azure resource associated with the entity. |
| `{{entity.azureResourceId.resourceGroupName}}` | The name of the resource group that contains the Azure resource associated with the entity. |
| `{{entity.azureResourceId.subscriptionId}}` | The subscription ID of the Azure resource associated with the entity. |
| **Log Analytics workspace templates** | |
| `{{entity.logAnalyticsWorkspaceResourceId}}` | The full resource ID of the Log Analytics workspace associated with the entity. |
| `{{entity.logAnalyticsWorkspaceResourceId.name}}` | The name of the Log Analytics workspace associated with the entity. |
| `{{entity.logAnalyticsWorkspaceResourceId.resourceGroupName}}` | The name of the resource group that contains the Log Analytics workspace associated with the entity. |
| `{{entity.logAnalyticsWorkspaceResourceId.subscriptionId}}` | The subscription ID of the Log Analytics workspace associated with the entity. |
| **Azure Monitor workspace templates** | |
| `{{entity.azureMonitorWorkspaceResourceId}}` | The full resource ID of the Azure Monitor workspace associated with the entity. |
| `{{entity.azureMonitorWorkspaceResourceId.name}}` | The name of the Azure Monitor workspace associated with the entity. |
| `{{entity.azureMonitorWorkspaceResourceId.resourceGroupName}}` | The name of the resource group that contains the Azure Monitor workspace associated with the entity. |
| `{{entity.azureMonitorWorkspaceResourceId.subscriptionId}}` | The subscription ID of the Azure Monitor workspace associated with the entity. |

The following example shows a Log Analytics query that uses a template string:

```kusto
ContainerLogV2
| where _ResourceId == '{{entity.azureResourceId}}'
| where LogSource == 'stderr'
| summarize value = count()
```

Use any template in either query type. For example, you can reference `{{entity.azureResourceId}}` or `{{entity.azureMonitorWorkspaceResourceId}}` in a log signal query.

Signal definitions are a common use case for query templates. Create a signal definition that uses a query template, and apply it to multiple entities. The signal uses each entity’s context during evaluation, so you don’t need to adjust the query manually.

## Azure Resource Health signals
Azure Resource Health signals use Azure platform health information as a signal on an entity. This signal surfaces whether resource availability or platform-reported issues are contributing to the entity's health state, alongside the metric and query signals that you define.

Add an Azure Resource Health signal from the **Signals** tab of the [entity editor](./designer.md#entities), under the entity's Azure resource data source. For more information about the underlying status, see [Azure Resource Health overview](../../service-health/resource-health-overview.md).

:::image type="content" source="media/signals/resource-health-signal.png" lightbox="media/signals/resource-health-signal.png" alt-text="Screenshot of the entity editor Signals tab with the Resource Health signal enabled for an entity's Azure resource.":::

Azure Resource Health isn't supported by every resource type. The setting can be disabled for Azure resources that don't support Resource Health.

## Thresholds
Thresholds are numeric values that you compare to the value of the signal to determine its health state. Each signal definition has two thresholds, one for the **Degraded** state and one for the **Unhealthy** state. The degraded threshold is optional, but the unhealthy threshold is required.

Specify the operator for each threshold to determine how the signal value is compared. Some signals indicate a degraded or unhealthy state when the value is above the threshold, while others indicate a degraded or unhealthy state when the value is below the threshold.

To define both thresholds for a signal definition ensure that degraded threshold is set to a value that is less than the unhealthy threshold. The degraded state will be set if the signal value is between the degraded and unhealthy thresholds. If the signal value is above the unhealthy threshold, then the entity is set to the unhealthy state. If the signal value is below the degraded threshold, then the entity is set to the healthy state.

## Signal definitions
Instead of creating a new signal for each entity, you can define a signal once and reuse it across multiple entities by creating a signal definition. Signal definitions are reusable configurations that define a specific signal and its associated thresholds.

To create a signal definition, select **Save as new signal definition** when editing a signal instead of **Add to entity**.

:::image type="content" source="media/signals/save-signal-definition.png" lightbox="media/signals/save-signal-definition.png" alt-text="Screenshot showing Save as new signal definition in the signal editor.":::

Signal definitions are displayed along with other signals for an entity, but have a unique icon to distinguish them from other signals.

:::image type="content" source="media/signals/sample-signal-definition.png" lightbox="media/signals/sample-signal-definition.png" alt-text="Screenshot showing sample signal definition.":::

To add a signal definition to another entity, select **Signal definitions** to choose from the available signal definitions.

:::image type="content" source="media/signals/add-signal-definition.png" lightbox="media/signals/add-signal-definition.png" alt-text="Screenshot showing signal definition option in the signal editor.":::


Edit signal definitions in the designer as you would edit any other signal. When you edit the signal definition for one entity, the changes will be applied to all entities that use that signal definition. You might use the same metric to measure the health of multiple entities, but different entities might require different thresholds. In this case, create multiple signal definitions with different thresholds.

The **Signal definitions** view lists all of the signal definitions in the health model. Select any signal definition to view its details, including the entities that use it.

:::image type="content" source="media/signals/signal-definitions-view.png" lightbox="media/signals/signal-definitions-view.png" alt-text="Screenshot showing the signal definitions view.":::

To delete a signal definition, open the signal definitions view, select any signal definitions to delete, and select **Delete** at the top of the screen. This button is disabled if any of the selected signals are in use by an entity in the health model.

## Signal grouping
Organize signals into aggregation groups to control health-state evaluation. Signal groups use aggregation rules to calculate a group health state, which contributes to the health state of the entity.

- All signal types can be added to any group.
- A signal can be a member of multiple groups.
- Ungrouped signals contribute directly to the entity's health state.

:::image type="content" source="media/signals/signal-groups-designer.png" lightbox="media/signals/signal-groups-designer.png" alt-text="Screenshot of signal group configuration in designer.":::

:::image type="content" source="media/signals/signal-groups-health-detail.png" lightbox="media/signals/signal-groups-health-detail.png" alt-text="Screenshot of signal group health evaluation.":::

### Example

The following example contains an entity with four signals of different types and two signal groups.

- Signal 1 is ungrouped and **Healthy**.
- Group 1 uses **Healthy limit** aggregation with **Absolute** values, a degraded threshold of 1, and an unhealthy threshold of 0. Its health state is **Degraded**.
  - Signal 2 is **Degraded**.
  - Signal 3 is **Healthy**.
  - Signal 4 is **Unhealthy**.
- Group 2 uses **Worst of** aggregation. Its health state is **Healthy**.
  - Signal 3 is **Healthy** and is also a member of Group 1.

Group 1 has one healthy signal out of three. The healthy signal count meets the degraded threshold of 1 but stays above the unhealthy threshold of 0, so the group is degraded. Because Group 1 is degraded, the entity's overall health state is **Degraded**.

### Set up

To configure your first signal group:

1. Go to the entity editor in the designer.
1. Configure data sources.
1. In the **Signals** section, select **Signal grouping**.
1. Select **Create signal group**.
1. Configure **Display name** and **Aggregation type**.
1. Select **Save**.

The new signal group appears in the signal list. You can now add signals to it. To add signals to the group:

1. Select one or more signals. If the entity has no signals, add a signal first. You can select a signal that's already in a group.
1. Select **Signal grouping**.
1. Select **Add selected signals to group**, and then select a group from the list.

To remove a signal from a group:

1. Select the signals that you want to remove from a group.
1. Select **Signal grouping**.
1. Select **Remove from group**.

Removing a signal from a group doesn't remove it from the entity.

### Configuration options

The following table describes the options for configuring a signal group.

| Setting | Options | Description |
|:---|:---|:---|
| Display name | Text. | Specifies the name shown for the signal group. |
| Aggregation type | **Worst of**, **Best of**, **Healthy limit**, or **Not-healthy limit**. | Determines how the health states of signals in the group combine to calculate the group health state:<br><br>- **Worst of**: Applies the worst health state in the group. This option is the default.<br>- **Best of**: Applies the best health state in the group.<br>- **Healthy limit**: Evaluates the number or percentage of healthy signals against the configured thresholds.<br>- **Not-healthy limit**: Evaluates the number or percentage of signals that aren't healthy against the configured thresholds. |
| Data unit | **Absolute** or **Percentage**. | Specifies whether thresholds use a signal count or a percentage of the signals included in the aggregation calculation. This setting is available only for **Healthy limit** and **Not-healthy limit**. |
| Degraded threshold | Numeric value. | Specifies when the group becomes degraded:<br><br>- **Healthy limit**: The healthy signal count or percentage must fall to or below this value. This value must be greater than the unhealthy threshold.<br>- **Not-healthy limit**: The not-healthy signal count or percentage must reach or exceed this value. This value must be less than the unhealthy threshold.<br><br>This threshold is optional. If you omit it, the group transitions directly between healthy and unhealthy. |
| Unhealthy threshold | Numeric value. | Specifies when the group becomes unhealthy:<br><br>- **Healthy limit**: The healthy signal count or percentage must fall to or below this value.<br>- **Not-healthy limit**: The not-healthy signal count or percentage must reach or exceed this value.<br><br>This threshold is required for **Healthy limit** and **Not-healthy limit**. |
| Ignore unknown | Selected or cleared. | Excludes signals that have an **Unknown** health state from aggregation calculations when selected. This option is selected by default and is available only for **Healthy limit** and **Not-healthy limit**. |


## Next steps
- [Configure a health model using the designer](./designer.md)
- [Configure alerts in health models](./alerts.md)
- [Analyze health state of the health model and its entities](./analyze-health.md)
