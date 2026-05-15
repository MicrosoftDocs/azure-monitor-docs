---
title: Create and configure a health model resource in Azure Monitor (Preview)
description: Learn how to create a new Azure Monitor health model.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/13/2026
ai-usage: ai-assisted
---

# Create a new Azure Monitor health model (preview)

[Azure Monitor health models](./overview.md) allow you to define and track the health of your Azure workloads and the resources they depend on. This article describes different methods for creating and configuring health models. 

## Prerequisites
Before you create a health model, make sure you have:

- Access to an Azure subscription where you can create a health model resource.
- At least one Azure resource that you want to monitor.
- Required monitoring data available for the signals you plan to configure.

## Permissions required

**To create a health model:**
- You must have at least **Contributor** role on the resource group or inherited from the subscription where you want to create the health model. If you create a new resource group for the health model, then you must have the **Contributor** role on the subscription.

**To manage an existing health model:**
- You must have at least **Monitoring Contributor** role on the health model.

**To view an existing health model:**
- You must have at least **Monitoring Reader** role on the health model.

**Managed identity**<br>
The managed identity that you select for the health model requires the following permissions. If you use a system assigned managed identity, these permissions are automatically assigned. If you use a user assigned managed identity, you must assign the following permissions before you create the health model.

- **Monitoring Reader** on Azure resources represented by entities in the model.
- **Monitoring Reader** on the Log Analytics workspace and Azure Monitor workspace if you create those signals.

If you use discovery, the managed identity might require additional read permissions on the discovery scope and any resources that discovery needs to enumerate.


## Create a health model
From the **Health Models** menu in the Azure portal, select **Create**.

:::image type="content" source="media/create/create-from-health-model.png" lightbox="media/create/create-from-health-model.png" alt-text="Screenshot creating health model from health model menu.":::

Provide the details for the new health model in the following table.

| Tab | Description |
|:---|:---|
| **Basics** | Select the subscription, resource group, and region for the health model in addition to a descriptive name. The Azure resources don't need to be in the same subscription or resource group as the health model. |
| **Identity** | Configure the identity that the health model uses to discover entities and access telemetry. This identity is also used by default for Azure resource entities, although you can later configure different authentication settings for specific entities. See [Permissions required](#permissions-required). |
| **Tags** | Add any [tags](/azure/azure-resource-manager/management/tag-resources) to help categorize the health model in your environment. |



## Configure a health model
When you create a new health model, start by adding entities manually or configuring discovery to populate entities automatically. Next, configure the health model by adding signals to each entity to measure health and optionally add alerts to notify you when the health state of an entity changes.

You'll perform most of the configuration in the **Designer**, which is a visual tool that provides access to all the configuration options for the entities in the health model. Get complete details on the designer and the different configuration options it provides in [Configure an Azure Monitor health model using the designer](./designer.md).

The following sections describe the different views aside from the designer that are available in the Azure portal.

### Entities view
The Entities view is useful for quickly finding and editing the signals and alerts for entities in the model. Use it as an alternative to the designer view when you want to focus on the entities and their properties rather than the visual layout of the model.

The view includes a list of all the entities in the health model with their current health state. You can open the same [Entity editor](./designer.md#entity-properties) from this view as you can in the designer view by clicking the entity link.

Modify the filter to show only entities matching particular criteria. For example, set the **Contains signals** filter to **Doesn't contain signals** to list only those entities that don't have any signal definitions associated with them. You can then select each of those entities to add signal definitions.

:::image type="content" source="media/create/entities-view.png" lightbox="media/create/entities-view.png" alt-text="Screenshot of entities view.":::

### Signal definitions
The signal definitions view is useful for understanding the signals that are available in the model and their current thresholds and for cleaning up any unused signals. It provides a list of all the [signal definitions](./designer.md#signal-definitions) in the health model and their thresholds.

You can't add or edit signal definitions from this view, because that requires the context of an entity, but you can delete any signal definitions that aren't used by any entities in the model (indicated by the green tick icon). Select any signal definitions to delete and click **Delete** at the top of the screen. This button will be disabled if any signals that are in use are selected.

:::image type="content" source="media/create/signal-definitions-view.png" lightbox="media/create/signal-definitions-view.png" alt-text="Screenshot of signal definitions view.":::


### Authentication settings
The authentication settings view lets you view and manage the authentication settings available in the health model. Each entity in the model uses an authentication setting to access to the Azure resource being monitored, and different entities may require different authentication settings. 

When you create a new authentication setting, you can select from the managed identities in the health model that are managed from the **Identity** menu item. Delete an entity by selecting it and them clicking **Delete**.

:::image type="content" source="media/create/authentication-settings.png" lightbox="media/create/authentication-settings.png" alt-text="Screenshot of authentication settings view.":::





## Next steps
- [Configure a health model using the designer](./designer.md).
- [Understand the concepts of health models](./concepts.md).
