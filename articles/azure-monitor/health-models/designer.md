---
title: Configure an Azure Monitor health model using the designer (Preview)
description: Learn how to use the designer to configure an Azure Monitor health model.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 06/27/2025
---

# Configure an Azure Monitor health model using the designer (preview)
The **Designer** is the primary tool for visually configuring [Azure Monitor health models](./overview.md). This article provides the details of different operations and common tasks that you can perform in the designer. Before you read this article, you should be familiar with the [concepts of health models](./concepts.md).

## Canvas
When you open the designer view, you're presented with the *canvas*, which is where you'll configure the [entities](./concepts.md#entities) that make up your health model. A new health model will have a single [root entity](./concepts.md#root-entity) and an [Azure resource entity](./concepts.md#azure-resource-entity) for each member of the service group the health model is based on. Each Azure resource entity will be a direct child of the root entity, but you can modify these relationships as described below.

:::image type="content" source="media/designer/designer-canvas.png" lightbox="media/designer/designer-canvas.png" alt-text="Screenshot of a health model resource in the Azure portal with the Designer pane selected.":::

The following table describes the options available in the command bar in the designer.

:::image type="content" source="media/designer/toolbar.png" lightbox="media/designer/toolbar.png" alt-text="Screenshot of designer command bar.":::

| Option | Description |
|:-------|:------------|
| Manage service group members | Launch service group management so you can add and remove members that will be included in the health model. It can take up to 5 minutes for a new member of a service group to appear in the health model. |
| Add entity | Add a [generic entity](./concepts.md#generic-entity) to the canvas. |
| Save changes | Sends all edits to the server for persistence and validation. Until you click **Save changes**, changes only exist in the browser. The save only applies to changes in the canvas such as rearranging entities. Any edits to an entity are saved when **Save** is clicked in the entity editor. |
| Discard changes | Discards all changes up to the last save point. |
| Undo | Undo the last change. |
| Refresh | Redraws the model from the last save point. |
| Arrange | Automatically arranges the position of the entities on the canvas. |
| Download image | Downloads a PNG of the current view. |
| Configure view | Select different options for display on the designer canvas. |

## Entities

Entities are represented as nodes in the designer view. In addition to the name and resource type, each entity includes icons that identify the different types of monitoring that have been configured for it as shown in the following image. Click **Edit** on an entity to open the [Entity editor](#entity-properties), which allows you to configure the properties of the entity and to create and assign signals and alerts. 

:::image type="content" source="media/designer/entity.png" lightbox="media/designer/entity.png" alt-text="Screenshot of an entity in the designer view with its icons identified.":::

> [!NOTE]
> You can also open the entity editor from the [entities view](#entities). 

## Arranging entities

You can click and drag entities to move them around the canvas. You can also use the mouse wheel to zoom in and out of the canvas. The position of the entity doesn't affect its operation in any way. The layout is saved when you save the model and will be restored when you reopen the model with either the designer or the [Graph](./analyze-health.md#graph-view). Use the **Arrange** option to reposition the entities on the canvas in a more organized manner.

## Create an edit relationships
[Relationships](./concepts.md#relationship) determine health propagation between entities in the health model. To create a relationship between two entities, either click the bottom handle of the parent entity and drag the line to the top handle of the child entity or click and drag from the top handle of the child to the bottom handle of the parent. Each entity (except the root entity which can't have a parent) can have multiple children and multiple parents. To delete a relationship, click on it and either click **Delete** or press the delete key.


## Add a generic entity

Click **Add** on the toolbar to add a generic entity to the model. A dialog opens with the [entity editor](#entity-properties) for the new entity. You can optionally configure properties and signals for the entity before saving it. Then position the entity where you want it on the canvas and create relationships between it and other entities in the model.

## Entity properties
The **General** tab of the entity editor allows you to configure the properties of the entity described in the following table. 

| Setting | Description |
|:---|:---|
| Name | Automatically assigned unique name of the entity. |
| Display name | The name of the entity as it appears in the health model. This defaults to the name of the Azure resource but can be modified later. |
| Kind | Azure resource type represented by the entity. This property can't be changed. |
| Impact | Determines how the health state of this entity is propagated to its parent as described in [Impact](./concepts.md#impact). |
| Icon | Icon to display in the health model. *Use associated resource icon* uses the icon from the resource type represented by the entity. The icon is for display only. It doesn't affect the operation of the entity in any way. |
| Health objective | The target health objective for this entity as described in [Health objective](./concepts.md#health-objective). This is an optional value. |
| Canvas position | X and Y coordinates of the entity on the canvas. This is automatically set when you drag the entity around the canvas. You can also manually set these values to position the entity in a specific location. |
| Labels | One of more optional name/value pairs to assign to the entity. Labels are used to group entities together for reporting and filtering purposes. You can use the same label on multiple entities. |


## Signals
The **Signals** tab of the [entity editor](#entities) allows you to create or edit signals and assign to the entity. There is a section for each type of signal described in [Signal details](#signal-details). If a signal type is defined for the entity, then you can configure its details. If not, then you're given an option to enable that type.

:::image type="content" source="media/designer/signals-empty.png" lightbox="media/designer/signals-empty.png" alt-text="Screenshot of signals page for an entity.":::

### Data source
When you add the first signal of a particular type to an entity, you must specify the data source for that signal type and the authentication that will be used to access it. The signals that are added to the entity will use this data source to apply their logic and compare to their threshold. Each entity can have only one data source for each signal type, but you can have multiple signals of that type that use the same data source. Each signal type uses a different type of data source that you must configure for each entity. See the data source for each signal type in [Signals](./concepts.md#signals).

### Authentication setting
The **Authentication setting** specifies the authentication setting used by the entity to access the data source. The managed identity you specified when you created the health model is used by default. You can create additional settings in the [Authentication settings](./create.md#authentication-settings) view.

An icon specifies whether the method has required access to collect telemetry from the resource. Click **Change** to select another authentication setting. . See [Permissions required](./create.md#permissions-required) for the managed identity requirements.

### Add and remove signals
Each type of signal has the following options. Click on a signal to edit its definition.

- **Add signal assignment:** -  Select from existing signals in the health model or from a set of 
- **Remove assignment** -  Enabled when one or more signals are selected. Removes the signal assignment from the entity, but doesn't delete the signal definition. The signal can still be assigned to other entities in the model.

### Add assignments
When you click **Add a signal assignment** in the entity editor, the options will vary depending on the signal type. 

- **Select existing:** - Select from existing metric signals that have been added to other entities in the health model. This allows you to reuse the same signal definition across multiple entities. 
- **Recommended:** - Select from a set of recommended signals and thresholds for the resource type. Once you select a recommended signal, it's added to existing signals. Azure resource signals only.
- **Create new:** - Create a new metric signal definition. This allows you to define a custom metric signal for the entity that can be used with other entities of the same type.

### Thresholds
Thresholds are numeric values that are compared to the value of the signal to determine the health state of the entity. Each signal definition has two thresholds, one for the **Degraded** state and one for the **Unhealthy** state. The degraded threshold is optional, but the unhealthy threshold is required. 

You can specify the operator for each threshold to determine how the signal value is compared. Some signals might indicate a degraded or unhealthy state when the value is above the threshold, while others might indicate a degraded or unhealthy state when the value is below the threshold. 

To define both thresholds for a signal definition ensure that degraded threshold is set to a value that is less than the unhealthy threshold. The degraded state will be set if the signal value is between the degraded and unhealthy thresholds. If the signal value is above the unhealthy threshold, then the entity is set to the unhealthy state. If the signal value is below the degraded threshold, then the entity is set to the healthy state.


### Signal details
The details required for each signal will vary depending on its type.

### [Azure resource](#tab/azureresource)
#### Azure resource signals
Azure resource signals sample the value of a [platform metric](../essentials/data-platform-metrics.md) from a particular resource and compare against a numeric threshold to determine the health state. Only metric definitions that are supported for the resource type of the Azure resource represented by the entity are available.


:::image type="content" source="media/designer/azure-resource-signals.png" lightbox="media/designer/azure-resource-signals.png" alt-text="Screenshot of Azure resource signals for an entity.":::

#### Signal properties

The following tables describe the properties that define an Azure resource signal definition.


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

:::image type="content" source="media/designer/log-signals.png" lightbox="media/designer/log-signals.png" alt-text="Screenshot of log signals for an entity.":::

#### Log Analytics workspace
Before you can create a Log Analytics workspace signal, you must specify the workspace to query and the authentication that the health model will use to access it. You can only specify a single workspace for each entity, but you can have multiple signals using different log queries from this workspace.

#### Log query
The log query must return a single record with a numeric value. If the record includes multiple columns, then you can specify which column to use as the signal value. The query should return a single record. If it returns multiple records, then only the first record is used.

The following example shows a log query that returns a count of error logs in the last hour. 

```kusto
ContainerLogV2
| where _ResourceId == '/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/my-resource-group/providers/microsoft.containerservice/managedclusters/my-cluster' 
| where LogSource == 'stderr'
| summarize value = count()
```

#### Signal properties
The following table describes the properties that define Log Analytics workspace signal definition.

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

#### Azure Monitor workspace
Before you can create an Azure Monitor workspace signal, you must specify the workspace to query and the authentication that the health model will use to access it. You can only specify a single workspace for each entity.

#### Signal properties
The following table describes the properties that define Azure Monitor workspace signal definition.


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

#### Signal definitions
A signal definition includes all of the properties required to uniquely define the signal and the thresholds that determine the health state to set. This allows different definitions to be used for the signal but with different thresholds.

You might use the same metric to measure the health of multiple entities, but different entities might require different thresholds. In this case, you would create multiple signal definitions using the same metric but with different thresholds. In the following example, there are two definitions for **Percentage CPU** because they have different thresholds.

:::image type="content" source="media/designer/signal-definitions.png" lightbox="media/designer/signal-definitions.png" alt-text="Screenshot of list of signal definitions." :::


### Alerts
The **Alerts** tab of the [entity editor](#entities) allows you to configure alerts for the entity as described in [Alerts](./concepts.md#alerts). 

You can enable either the **Degraded** or **Unhealthy** state or both. The only configuration required is the **Severity** of the alert which aligns with the severity values of other Azure Monitor alerts. The alert will fire when the health state of the entity changes to the selected state. Only one alert will be created for the entity even if multiple signals match this severity.

You can optionally select up to five [action groups](../alerts/action-groups.md) to notify your team or take corrective action when the alert is created. 

:::image type="content" source="media/designer/entity-editor-alerts.png" lightbox="media/designer/entity-editor-alerts.png" alt-text="Screenshot of alert configuration in the entity editor.":::




## Next steps
- [Understand the concepts of health models](./concepts.md).
- [Analyze health state of the health model and its entities](./analyze-health.md).