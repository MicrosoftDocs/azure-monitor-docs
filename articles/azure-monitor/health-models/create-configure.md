---
title: Create and configure a health model resource in Azure Monitor (Preview)
description: Learn now to create a new Azure Monitor health model.
ms.topic: conceptual
author: bwren
ms.author: bwren
ms.date: 06/27/2025
---

# Create a new Azure Monitor health model (Preview)

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



## Configure a health model
When you create a new health model, it will include an entity for each of the Azure resources in the service group, but non of the entities will be monitored. The next step is to configure the health model by adding  signals to each entity to measure their health and optionally add alerts to notify you when the health state of an entity changes.

You'll perform most of the configuration in the **Designer**, which is a visual tool that provides access to all the configuration options for the entities in the health model. Get complete detail on the designer and the different configuration options it provides in [Use the Azure Monitor health model designer](./designer.md).

The following sections describe the different views aside from the designer that are available in the available in the Azure portal.

### Entities view
The Entities view includes a list of all the entities in the health model with their current health state. You can open the same [Entity editor](./entities.md#entity-editor) from this view as you can in the designer view by selecting an entity and clicking **Edit**.

This view is useful for quickly finding and editing the signals and alerts for entities in the model. Use it as an alternative to the designer view when you want to focus on the entities and their properties rather than the visual layout of the model.

:::image type="content" source="media/create/entities-view.png" lightbox="media/designer/entities-view.png" alt-text="Screenshot of entities view.":::

### Discovery view
The discovery view allows you to configure the service group and auto-discovery settings for the health model. This includes changing the identity used for accessing the service group.

:::image type="content" source="media/create/discovery-view.png" lightbox="media/designer/discovery-view.png" alt-text="Screenshot of discovery view.":::

> [!NOTE]
> If you remove the service group for the health model, the health model will include only the root entity, and you'll receive a warning message that the health model will not be populated.

### Signal definitions
The signal definitions view provides a list of all the [signal definitions](./signals.md) in the health model and their thresholds. It can be useful for understanding the signals that are available in the model and their current thresholds and for cleaning up any unused signals.

You can't add or edit signal definitions from this view, but you can delete any signals that aren't used by any entities in the model. Select any entities to delete and click **Delete** at the top of the screen. This button will be disabled if any signals that are in use are selected.

:::image type="content" source="media/designer/signal-definitions-view.png" lightbox="media/designer/signal-definitions-view.png" alt-text="Screenshot of signal definitions view.":::


### Authentication settings
The authentication settings view lets you view and manage the authentication settings available in the health model. Each entity in the model uses an authentication setting to access to the Azure resource being monitored, and different entities may require different authentication settings. 

When you create a new authentication setting, you can select from the managed identities in the health model that are managed from the **Identity** menu item. Delete an entity by selecting it and them clicking ***Delete**.

:::image type="content" source="media/designer/authentication-settings.png" lightbox="media/designer/signal-definitions-view.png" alt-text="Screenshot of authentication settings view.":::





## Next steps
- [Configure a health model using the designer](./designer.md).
- [Understand the concepts of health models](./concepts.md).