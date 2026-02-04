---
title: Configure Azure Advisor recommendations view
description: View and filter Azure Advisor recommendations to reduce noise.
ms.topic: how-to
ms.date: 11/11/2025
---

# Configure recommendations

Azure Advisor provides recommendations to help you optimize your Azure deployments. Within Advisor, you have access to a few features that help you narrow down your recommendations to only the ones that matter to you.

## Configure subscriptions and resource groups

Advisor gives you the ability to select subscriptions and resource groups that matter to you and your organization. You only see recommendations for the subscriptions and resource groups that you select. By default, all are selected. Configuration settings apply to the subscription or resource group, so the same settings apply to everyone that has access to that subscription or resource group. Configuration settings can be changed in the Azure portal or programmatically.

To make changes in the Azure portal:

1. Open [Azure Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.

1. Select **Configuration** from the menu.

    :::image type="content" source="./media/view-recommendations/configuration.png" alt-text="Screenshot showing the Resources heading on the Configuration pane in Azure Advisor.":::

1. Select the checkbox in the **Include** column for any subscriptions or resource groups to receive Advisor recommendations. If the box is disabled, you might not have permission to make a configuration change on that subscription or resource group. Learn more about [permissions in Azure Advisor](permissions.md).

1. Select **Apply** at the bottom after you make a change.

## Related articles

*   [Customize recommendations view](./advisor-customize-view.md)

*   [Roles and permissions](./permissions.md)
