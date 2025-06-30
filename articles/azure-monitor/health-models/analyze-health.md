---
title: Analyze health state of Azure Monitor health models (Preview)
description: Describes the different views available to view the health state of your Azure Monitor health models and their included entities.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 06/27/2025
---

# Analyze health state of Azure Monitor health models (preview)
This article describes the views available to analyze the current health of your [Azure Monitor health model](./overview.md) and its health history over time.

The following table briefly describes each view, while the sections below provide more details on each.

| View | Description |
|:---|:---|
| [Graph](#graph-view) | Shows the latest snapshot of the health model with its full structure displayed and the current state of each node. |
| [Timeline](#timeline-view) | Shows the health state of the model over time, allowing you to drill down into specific time periods. |
| [Entity details](#entity-details) | Shows the health state of a specific entity, including its signals and health history. |


## Graph view
The graph view is useful for understanding the current health of your workload and its components or for viewing its health at a specific point in time. It shows the latest snapshot of a health model with its full structure displayed and the current state of each node. Select the **Timestamp** option to view the health model at a specific time in the past. 

:::image type="content" source="./media/analyze-health/graph-view.png" lightbox="./media/analyze-health/graph-view.png" alt-text="Screenshot of a health model resource in the Azure portal with the Graph pane selected.":::


## Timeline view
The timeline view is useful for tracking the health of your workload or application over time and drilling down into particular time periods. When you open the view, the root entity is displayed, which you can expand the other entities in your health model. Change the **Timespan** to change the date range displayed. The time grain is chosen automatically based on the size of the time window.

Click on a particular time slice to view details. From this view, you can select to either zoom the timeline view to that time range or open the [graph view](#graph-view) snapshot for the model at that time.

:::image type="content" source="./media/analyze-health/timeline-view.png" lightbox="./media/analyze-health/timeline-view.png" alt-text="Screenshot of a health model resource in the Azure portal with the Table view pane selected.":::


## Entity details
Select an entity in the graph or timeline view to open the entity details pane. This shows the current health state of the entity, its signals, and its health history over time.
To drill down on an entity's health state, hover over it to view its type and current health state and then click on the entity to view its detail. The entity detail includes the last measurement of each signal and the entity's health over time. 

:::image type="content" source="./media/analyze-health/entity-detail.png" lightbox="./media/analyze-health/entity-detail.png" alt-text="Screenshot of the Entity detail dialog for a health model resource in the Azure portal.":::

The sections in the entity details pane are described below.

**Entity details**<br>
The **Entity details** section displays the entity's name, type, current health state, and other details.

**Alerts**<br>
The **Alerts** section displays any active alerts for the entity. Click on an alert to view its details.

**History**<br>
The **History** section provides a history of the health of the application over the selected timespan. The following table describes the tabs in this section.

| Tab | Description |
|:---|:---|
| Timeline | Shows the health of the entity over time, and you can expand to show the health of each signal. Change the **Timespan** to change the date range displayed. |
| Analysis | Shows the percentage time that the entity was in a healthy state over the last 24 hours, 7 days, and 30 days. |

**Insights**<br>
The **Insights** section provides the latest value of each signal and other data to assess the current state of the entity. The following table describes the tabs in this section.

| Tab | Description |
|:---|:---|
| Signals | Shows the current health state of each signal associated with the entity. Click on a signal for more in depth analysis. |
| Alerts | Displays any open alerts for the entity. |
| Resource health | Shows the current [Azure Resource health](../../service-health/overview.md) status of the entity. |
| Change analysis | Any changes to the resource detected by [Change analysis](/azure/governance/resource-graph/changes/get-resource-changes). This helps you identify whether any issues were related to configuration changes.   |

## Next steps
- [Configure a health model using the designer](./designer.md).
- [Understand the concepts of health models](./concepts.md).