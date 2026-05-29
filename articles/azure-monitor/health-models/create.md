---
title: Create a new Azure Monitor health model (preview)
description: Learn how to create a new Azure Monitor health model.
ms.topic: how-to
author: bwren
ms.author: bwren
ms.date: 05/25/2026
ai-usage: ai-assisted
---

# Create a new Azure Monitor health model (preview)

[Azure Monitor health models](./overview.md) allow you to define and track the health of your Azure workloads and the resources they depend on. This article describes how to create a health model in the Azure portal.

## Prerequisites
Before you create a health model, make sure you have:

- Access to an Azure subscription where you can create a health model resource.
- At least one Azure resource that you want to monitor.
- Required monitoring data available for the signals you plan to configure.

## Permissions required

- To create a health model, you must have at least **Contributor** role on the resource group or inherited from the subscription
- To manage an existing health model, you must have at least **Monitoring Contributor** role on the health model.
- To view an existing health model, you must have at least **Monitoring Reader** role on the health model.

## Create a health model
From the **Health Models** menu in the Azure portal, select **Create**.

:::image type="content" source="media/create/create-from-health-model.png" lightbox="media/create/create-from-health-model.png" alt-text="Screenshot creating health model from health model menu.":::

Provide the details for the new health model in the following table.

| Tab | Description |
|:---|:---|
| **Basics** | Select the subscription, resource group, and region for the health model in addition to a descriptive name. The Azure resources don't need to be in the same subscription or resource group as the health model. |
| **Identity** | Configure the identity that the health model uses to discover entities and access telemetry. This identity is also used by default for Azure resource entities, although you can later configure different authentication settings for specific entities. See [Permissions required](#permissions-required). |
| **Tags** | Add any [tags](/azure/azure-resource-manager/management/tag-resources) to help categorize the health model in your environment. |

## Identity
Health models require one or more managed identities to access monitoring data for the resources monitored in the model and for running discoveries. On the **Identity** tab when you create the health model, you can select whether to enable a system identity and add one or more user assigned managed identities to use for the health model. These identities are available for use in the health model after creation, and you can manage them from the **Authentication settings** view in the designer.

Any managed identities that you add to the health model require the following permissions. For a system assigned managed identity, these permissions are automatically assigned. For a user assigned managed identity, you must assign the following permissions.

- **Monitoring Reader** on Azure resources represented by entities in the model.
- **Monitoring Reader** on the Log Analytics workspace and Azure Monitor workspace if you create those signals.

If you don't add the identities when the health model is created, you can add them later from the designer. First add them to the **Identity** tab and then create an authentication setting that references the new identity from the **Authentication settings** view.

:::image type="content" source="media/create/authentication-settings.png" lightbox="media/create/authentication-settings.png" alt-text="Screenshot of authentication settings view.":::

## Next steps
- [Configure a health model using the designer](./designer.md).
- [Understand the concepts of health models](./concepts.md).
