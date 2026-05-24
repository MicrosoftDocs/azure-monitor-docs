---
title: Configure entities in Azure Monitor health models (preview)
description: Learn how to configure entities in Azure Monitor health models.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/13/2026
ai-usage: ai-assisted
---

# Configure entities in Azure Monitor health models (preview)
Entities are the building blocks of an Azure Monitor health model. Each entity represents a specific resource or component in your environment and is used to track its health state. This article explains how to configure entities and their monitoring properties.

## Entities in the designer
Entities are represented as nodes in the Azure Monitor health model [designer](./designer.md). In addition to the name and resource type, each entity includes icons that identify the different types of monitoring that have been configured for it as shown in the following image. Click **Edit** on an entity to open the [Entity editor](#entity-properties), which allows you to configure the properties of the entity and to create and assign [signals](./signals.md) and [alerts](./alerts.md). 

:::image type="content" source="media/designer/entity.png" lightbox="media/designer/entity.png" alt-text="Screenshot of an entity in the designer view with its icons identified.":::

> [!NOTE]
> You can also open the entity editor from the [entities view](#entities). 

## Entity properties

The **General** tab of the entity editor allows you to configure the properties of the entity described in the following table. 

| Setting | Description |
|:---|:---|
| Name | Automatically assigned unique name of the entity. |
| Display name | The name of the entity as it appears in the health model. This defaults to the name of the Azure resource but can be modified later. |
| Impact | Determines how the health state of this entity is propagated to its parent as described in [Impact](./concepts.md#health-propagation-settings). |
| Icon | Icon to display in the health model. *Use associated resource icon* uses the icon from the resource type represented by the entity. The icon is for display only. It doesn't affect the operation of the entity in any way. |
| Health objective | The target health objective for this entity as described in [Health objective](./concepts.md#health-objective). This is an optional value. |
| Canvas position | X and Y coordinates of the entity on the canvas. This is automatically set when you drag the entity around the canvas. You can also manually set these values to position the entity in a specific location. |
| Tags | One or more optional name/value pairs to assign to the entity. Labels are used to group entities together for reporting and filtering purposes. You can use the same label on multiple entities. |


:::image type="content" source="media/entities/entity-editor.png" lightbox="media/entities/entity-editor.png" alt-text="Screenshot of authentication settings view.":::

## Signals
The **Signals** tab of the [entity editor](#entity-properties) allows you to create or edit signals and assign them to the entity. See [Signals in Azure Monitor health models](./signals.md).


## Alerts
The **Alerts** tab of the [entity editor](#entity-properties) allows you to configure alerts for the entity. See [Alerts in Azure Monitor health models](./alerts.md).


## Entities view
The Entities view is useful for quickly finding and editing the signals and alerts for entities in the model. Use it as an alternative to the designer view when you want to focus on the entities and their properties rather than the visual layout of the model.

The view includes a list of all the entities in the health model with their current health state. You can open the same [Entity editor](./designer.md#entity-properties) from this view as you can in the designer view by clicking the entity link.

Modify the filter to show only entities matching particular criteria. For example, set the **Contains signals** filter to **Doesn't contain signals** to list only those entities that don't have any signal definitions associated with them. You can then select each of those entities to add signal definitions.

:::image type="content" source="media/create/entities-view.png" lightbox="media/create/entities-view.png" alt-text="Screenshot of entities view.":::


## Next steps
- [Understand the concepts of health models](./concepts.md).
- [Configure signals in health models](./signals.md).
- [Configure alerts in health models](./alerts.md).
- [Analyze health state of the health model and its entities](./analyze-health.md).