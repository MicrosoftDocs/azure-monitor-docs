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




## Next steps
