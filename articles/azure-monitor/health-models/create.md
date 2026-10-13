---
title: Azure Monitor health model portal quickstart (preview)
description: In this quickstart, create an Azure Monitor health model in the Azure portal, configure its managed identity, and verify the deployment.
ms.topic: quickstart
ms.date: 08/26/2026
ai-usage: ai-assisted
#customer intent: As an Azure user, I want to create my first health model in the Azure portal so that I can begin modeling my workload health.
---

# Quickstart: Create an Azure Monitor health model in the Azure portal (preview)

In this quickstart, you create an Azure Monitor health model in the Azure portal, configure its managed identity, and verify that the model is ready for configuration.

## Prerequisites

- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- At least one Azure resource that you want to monitor.
- Required monitoring data available for the signals you plan to configure.
- At least the **Contributor** role on the resource group or inherited from the subscription.
- The **Role Based Access Control Administrator** or **Owner** role to assign required permissions to the health model's managed identities.

## Permissions required

To manage the health model after deployment, you need at least the **Contributor** role on the model. To view it, you need at least the **Reader** role.

The model's managed identity needs the **Reader** role on represented Azure resources. It needs the **Monitoring Reader** role on any Log Analytics or Azure Monitor workspaces that its signals query. Azure doesn't assign these roles automatically. Assign the required roles to each system-assigned or user-assigned identity that the model uses.

## Create a health model

1. In the [Azure portal](https://portal.azure.com), search for and select **Health models**.
1. Select **Create**.

   :::image type="content" source="media/create/create-from-health-model.png" lightbox="media/create/create-from-health-model.png" alt-text="Screenshot of the Health models page with the Create command highlighted." border="true":::

1. On the **Basics** tab, select a subscription and resource group, enter a name for the health model, and select a supported region.
1. On the **Identity** tab, keep the system-assigned managed identity enabled. Optionally, add a user-assigned managed identity.
1. On the **Tags** tab, optionally add tags to categorize the health model.
1. Select **Review + create**, and then select **Create** after validation succeeds.

   :::image type="content" source="media/create/create-health-model-basics.png" lightbox="media/create/create-health-model-basics.png" alt-text="Screenshot of the Basics tab for creating a new health model in the Azure portal." border="true":::

The deployment typically finishes in less than a minute.

## Identity

The managed identities you select during deployment appear under **Authentication settings** in the designer. Add an identity to the resource's **Identity** page before you create an authentication setting for it. Use authentication settings to select which managed identity accesses telemetry for specific entities.

## Verify the health model

1. Select **Go to resource** when the deployment finishes.
1. On the health model **Overview** page, verify that **Provisioning state** is **Succeeded**.
1. Under **Health**, select **Designer**. Verify that the designer contains the root entity for the new model.

The health model is now ready for entities, relationships, and signals.

## Clean up resources

If you don't plan to continue configuring the health model, delete it to avoid retaining an unused resource.

1. On the health model **Overview** page, select **Delete**.
1. Enter the health model name, and then select **Delete**.

Deleting the health model removes its entities, relationships, signals, and configuration. It doesn't delete the Azure resources that the model monitored.

## Next step

> [!div class="nextstepaction"]
> [Configure a health model using the designer](./designer.md)
