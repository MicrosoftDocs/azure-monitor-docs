---
title: Configure an Azure Monitor health model using the designer (Preview)
description: Learn how to use the designer to configure an Azure Monitor health model.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/25/2026
ai-usage: ai-assisted
---

# Configure an Azure Monitor health model using the designer (preview)
The **Designer** is the primary tool for visually configuring [Azure Monitor health models](./overview.md). This article provides the details of different operations and common tasks that you can perform in the designer. Before you read this article, you should be familiar with the [concepts of health models](./concepts.md).

## Canvas
When you open the designer view, you're presented with the *canvas*, which is where you'll configure the [entities](./concepts.md#entities) that make up your health model. A new health model starts with a single [root entity](./concepts.md#entities). 

:::image type="content" source="media/designer/designer-canvas.png" lightbox="media/designer/designer-canvas.png" alt-text="Screenshot of a health model resource in the Azure portal with the Designer pane selected.":::

The following table describes the options available in the command bar in the designer.

| Option | Description |
|:-------|:------------|
| Add entity | Add a generic entity](./concepts.md#generic-entity) or one or more [Azure resource entities](./concepts.md#entities) to the canvas. If you add multiple Azure resource entities, any detected relationships between them will automatically be created. |
| Clone selection | Create a copy of the selected entity or entities. The cloned entities will have the same properties, signals, relationships, and alerts as the original, but with a different name. |
| Delete | Delete the selected entity or entities. Deleting an entity also deletes any relationships. |
| Save changes | Sends all edits to the server for persistence and validation. Until you click **Save changes**, changes only exist in the browser. The save only applies to changes in the canvas such as rearranging entities. Any edits to an entity are saved when **Save** is clicked in the entity editor. |
| Discard changes | Discards all changes up to the last save point. |
| Undo | Undo the last change. |
| Refresh | Redraws the model from the last save point. |
| Arrange | Automatically arranges the position of the entities on the canvas. |
| Download image | Downloads a PNG of the current view. |
| Configure view | Select different options for display on the designer canvas. |

> [!NOTE]
> For discovery concepts and configuration details, see [Discover entities for Azure Monitor health models](./discoveries.md).

## Entities

Entities are represented as nodes in the designer view. In addition to the name and resource type, each entity includes icons that identify the different types of monitoring that have been configured for it as shown in the following image. Click **Edit** on an entity to open the [Entity editor](#entity-properties), which allows you to configure the properties of the entity and to create and assign [signals](./signals.md) and [alerts](./alerts.md). 

:::image type="content" source="media/designer/entity.png" lightbox="media/designer/entity.png" alt-text="Screenshot of an entity in the designer view with its icons identified.":::

> [!NOTE]
> You can also open the entity editor from the [entities view](#entities). 

### Select entities
Select a single entity by clicking on it. Select multiple entities by holding down the ctrl key and dragging on the canvas to select multiple entities within the area you drag over. When multiple entities are selected, any operation you perform will apply to all selected entities. For example, if you click **Delete** with multiple entities selected, then all selected entities will be deleted.

### Arrange entities

You can click and drag entities to move them around the canvas. You can also use the mouse wheel to zoom in and out of the canvas. The position of the entity doesn't affect its operation in any way. The layout is saved when you save the model and will be restored when you reopen the model with either the designer or the [Graph](./analyze-health.md#graph-view). Use the **Arrange** option to reposition the entities on the canvas in a more organized manner.

### Add an entity
Click **Add** on the toolbar to add an entity to the mode. 

- If you select an Azure Resource, a dialog box opens where you can select one or more resources to add to the model. 
    - If you select a single resource, a dialog opens with the [entity editor](#entity-properties) for the new entity. 
    - If you select multiple resources, any relationships between them will be added to the model with the new entities. 
- If you select a generic entity, a dialog opens with the [entity editor](#entity-properties) for the new entity. 

You can optionally configure properties and signals for the entity before saving it. Then position the entity where you want it on the canvas and create relationships between it and other entities in the model.

## Relationships

To create a [relationship](./concepts.md#relationship) between two entities, either click the bottom handle of the parent entity and drag the line to the top handle of the child entity or click and drag from the top handle of the child to the bottom handle of the parent. Each entity (except the root entity which can't have a parent) can have multiple children and multiple parents. 

You can't move a relationship to a new parent or child. Instead, delete the relationship and create a new one. To delete a relationship, click on it and either click **Delete** or press the delete key.

Click on a relationship to view its properties. You can change the display name of the relationship and give it one or more tags.

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

:::image type="content" source="media/designer/entity-editor.png" lightbox="media/designer/entity-editor.png" alt-text="Screenshot of authentication settings view.":::

## Signals
The **Signals** tab of the [entity editor](#entity-properties) allows you to create or edit signals and assign them to the entity. See [Signals in Azure Monitor health models](./signals.md).


## Alerts
The **Alerts** tab of the [entity editor](#entity-properties) allows you to configure alerts for the entity. See [Alerts in Azure Monitor health models](./alerts.md).


## Entities view
The Entities view is useful for quickly finding and editing the signals and alerts for entities in the model. Use it as an alternative to the designer view when you want to focus on the entities and their properties rather than the visual layout of the model.

The view includes a list of all the entities in the health model with their current health state. You can open the same [Entity editor](./designer.md#entity-properties) from this view as you can in the designer view by clicking the entity link.

Modify the filter to show only entities matching particular criteria. For example, set the **Contains signals** filter to **Doesn't contain signals** to list only those entities that don't have any signal definitions associated with them. You can then select each of those entities to add signal definitions.

:::image type="content" source="media/designer/entities-view.png" lightbox="media/designer/entities-view.png" alt-text="Screenshot of entities view.":::


## Next steps
- [Understand the concepts of health models](./concepts.md).
- [Configure signals in health models](./signals.md).
- [Configure alerts in health models](./alerts.md).
- [Analyze health state of the health model and its entities](./analyze-health.md).