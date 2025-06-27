---
title: Create and configure a health model resource in Azure Monitor
description: Learn now to create a health model resource.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 12/12/2023
---

# Create and configure an Azure Monitor health model

[Azure Monitor health models](./overview.md) allow you to define and track the health of your Azure workloads and the resources they depend on. This article describes different methods for creating and configuring health models. 

## Prerequisites
Before you create a health model, you must have a [service group](/azure/governance/service-groups/overview) that includes the Azure resources you want to monitor. See [Quickstart: Create a service group (preview) in the portal](/azure/governance/service-groups/create-service-group-portal).

## Permissions required

**To create a health model:**
- You must have at least **Contributor** role on the resource group or inherited from the subscription where you want to create the health model. If you create a new resource group for the health model, then you must have the **Contributor** role on the subscription.

**To manage an existing health model:**
- You must have at least **Monitoring Contributor** role on the health model.
- •	To add resources to your health model you must add them as Members to your Service Group. Adding members to a service group requires at least **Contributor** role on the service.

**To view an existing health model:**
- You must have at least **Monitoring Reader** role on the health model.
- To view the service group, you must have **Service Group reader** on the service group.

**Managed entity**<br>
The managed identity that you select for the health model requires the following permissions. If you use a system assigned managed identity, these permissions are automatically assigned. If you use a user assigned managed identity, you must assign the following permissions before you create the health model.

- **Service Group reader** on the service group. 
- **Monitoring reader** on any members in the service group.
- **Monitoring reader** on the Log Analytics workspace and Azure Monitor workspace if you create those signals.


## Create a health model
There are two methods to create an Azure Monitor health model in the Azure portal.


**Service groups menu**<br>
From the menu for the service group, select **Monitoring**  and then click **creating a health model**. This will open the **Create a new Azure Monitor health model** pane where you can provide the details for the new health model.

:::image type="content" source="media/create-configure/create-from-service-group.png" lightbox="media/create-configure/create-from-service-group.png" alt-text="Screenshot creating health model from service group.":::

**Health models menu**<br>
From the **Health Models** menu in the Azure portal, select **Create**.

:::image type="content" source="media/create-configure/create-from-health-model.png" lightbox="media/create-configure/create-from-health-model.png" alt-text="Screenshot creating health model from health model menu.":::

Using either method, you need to provide the details for the new health model in the following table.

| Tab | Description |
|:---|:---|
| **Basics** | Select the subscription, resource group, and region for the health model in addition to a descriptive name. The Azure resources don't need to be in the same subscription or resource group as the health model. |
| **Identity** | Configure the identity for the health model access the service group. This is use to enumerate the members of the service group and add them as entities to the health model. It's also used by default to access telemetry for the Azure resources represented by each entity, although this identity can later be changed for each entity. See [Permissions required](#permissions-required) for the requirements of this identity. |
| **Discovery** | Select a service group for the health model. An entity will be created for each member of the service group. Select the option to **Add recommended signals** to automatically add a set of recommended signals to each entity for that Azure resource type. |
| **Tags** | Add any [tags](/azure/azure-resource-manager/management/tag-resources) to help categorize the health model in your environment. |


## Azure portal views
The following table describes the different views that are available in the Azure portal for working with the health model once it's been created. Each is described in further details below.

| View | Description |
|:---|:---|
| [Designer](#designer-view) | Primary tool for visually configuring Azure Monitor health models. |
| [Entities](#entities-view) | View a list of all the entities in the health model with their current health state.  |
| [Discovery](#discovery-view) | Configures the service group and auto-discovery settings for the health model. | 
| [Signal definitions](#signal-definitions) | View a list of all the signal definitions in the health model.  |
| [Authentication settings](#authentication-settings) | Create and edit authentication methods for accessing telemetry data from the Azure resources in the health model.|

## Designer view
The designer is the primary tool that you'll use for visually configuring Azure Monitor health models. You can modify the arrangement of the entities that will translate to the [Graph](./analyze-health.md#graph-view) view which give you a visual representation of the current health state of your workload. You can also use the designer to create and edit signals, assign them to entities, and define health  alert rules. When you open the designer view, you're presented with the *canvas*, which is where you'll configure the [entities](./entities.md) that make up your health model.

:::image type="content" source="media/create-configure/designer-canvas.png" lightbox="media/create-configure/designer-canvas.png" alt-text="Screenshot of a health model resource in the Azure portal with the Designer pane selected.":::

### Command bar

:::image type="content" source="media/create-configure/toolbar.png" lightbox="media/create-configure/toolbar.png" alt-text="Screenshot of designer command bar.":::

The following table describes the options available in the command bar in the designer.

| Option | Description |
|:-------|:------------|
| Manage service group members | Launch service group management so you can add and remove members that will be included in the health model. It can take up to 5 minutes for a new member of a service group to appear in the health model. |
| Save changes | Sends all edits to the server for persistence and validation. Until you click **Save changes**, changes only exist in the browser. The save only applies to changes in the canvas such as rearranging entities. Any edits to an entity are saved when **Save** is clicked in the entity editor. |
| Discard changes | Discards all changes up to the last save point. |
| Undo | Undo the last change. |
| Refresh | Redraws the model from the last save point. |
| Arrange | Automatically arranges the position of the entities on the canvas. |
| Download image | Downloads a PNG of the current view. |
| Configure view | Select different options for display on the designer canvas. |

### Arranging entities
You can click and drag entities to move them around the canvas. You can also use the mouse wheel to zoom in and out of the canvas. The position of the entity doesn't affect its operation in any way. The layout is saved when you save the model and will be restored when you reopen the model with either the [designer](#designer-view) or the [graph](./analyze-health.md#graph-view). Use the **Arrange** option to reposition the entities on the canvas in a more organized manner.

### Entities
Entities are represented as nodes in the designer view. Icons on each entity identify different the different types of monitoring that have been configured for it as shown in the following image.

:::image type="content" source="media/create-configure/entity.png" lightbox="media/create-configure/entity.png" alt-text="Image of an entity in the designer view.":::

## Entities view
The Entities view includes a list of all the entities in the health model with their current health state. You can open the same [Entity editor](./entities.md#entity-editor) from this view as you can in the designer view by selecting an entity and clicking **Edit**.

This view is useful for quickly finding and editing the signals and alerts for entities in the model. Use it as an alternative to the designer view when you want to focus on the entities and their properties rather than the visual layout of the model.

:::image type="content" source="media/create-configure/entities-view.png" lightbox="media/create-configure/entities-view.png" alt-text="Screenshot of entities view.":::

## Discovery view
The discovery view allows you to configure the service group and auto-discovery settings for the health model. This includes changing the identity used for accessing the service group.

:::image type="content" source="media/create-configure/discovery-view.png" lightbox="media/create-configure/discovery-view.png" alt-text="Screenshot of discovery view.":::

> [!NOTE]
> If you remove the service group for the health model, the health model will include only the root entity, and you'll receive a warning message that the health model will not be populated.

## Signal definitions
The signal definitions view provides a list of all the [signal definitions](./signals.md) in the health model and their thresholds. It can be useful for understanding the signals that are available in the model and their current thresholds and for cleaning up any unused signals.

You can't add or edit signal definitions from this view, but you can delete any signals that aren't used by any entities in the model. Select any entities to delete and click **Delete** at the top of the screen. This button will be disabled if any signals that are in use are selected.

:::image type="content" source="media/create-configure/signal-definitions-view.png" lightbox="media/create-configure/signal-definitions-view.png" alt-text="Screenshot of signal definitions view.":::


## Authentication settings
The authentication settings view lets you view and manage the authentication settings available in the health model. Each entity in the model uses an authentication setting to access to the Azure resource being monitored, and different entities may require different authentication settings. 

When you create a new authentication setting, you can select from the managed identities in the health model that are managed from the **Identity** menu item. Delete an entity by selecting it and them clicking ***Delete**.

:::image type="content" source="media/create-configure/authentication-settings.png" lightbox="media/create-configure/signal-definitions-view.png" alt-text="Screenshot of authentication settings view.":::


## Next steps
