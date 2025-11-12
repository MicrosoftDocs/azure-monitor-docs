---
title: Configure Azure Advisor recommendations view
description: View and filter Azure Advisor recommendations to reduce noise.
ms.topic: how-to
ms.date: 11/11/2025
---

# Configure the Azure Advisor recommendations view

Azure Advisor provides recommendations to help you optimize your Azure deployments. Within Advisor, you have access to a few features that help you narrow down your recommendations to only the ones that matter to you.

## Configure subscriptions and resource groups

Advisor gives you the ability to select subscriptions and resource groups that matter to you and your organization. You only see recommendations for the subscriptions and resource groups that you select. By default, all are selected. Configuration settings apply to the subscription or resource group, so the same settings apply to everyone that has access to that subscription or resource group. Configuration settings can be changed in the Azure portal or programmatically.

To make changes in the Azure portal:

1. Open [Azure Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.

1. Select **Configuration** from the menu.

    :::image type="content" source="./media/view-recommendations/configuration.png" alt-text="Screenshot showing the Resources heading on the Configuration pane in Azure Advisor.":::

1. Select the checkbox in the **Include** column for any subscriptions or resource groups to receive Advisor recommendations. If the box is disabled, you might not have permission to make a configuration change on that subscription or resource group. Learn more about [permissions in Azure Advisor](permissions.md).

1. Select **Apply** at the bottom after you make a change.

## Dismiss and postpone recommendations

Advisor allows you to dismiss or postpone recommendations on a single resource. If you dismiss a recommendation, you don't see it again unless you manually activate it. However, postponing a recommendation allows you to specify a duration after which the recommendation is automatically activated again. Postponing can be done in the Azure portal or programmatically.

### Postpone a single recommendation in the Azure portal 

1. Open [Azure Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.
1. To view your recommendations, select a recommendation category.
1. Select a recommendation from the list of recommendations.
1. Select **Postpone** or **Dismiss** for the recommendation you want to postpone or dismiss.

     :::image type="content" source="./media/view-recommendations/postpone-dismiss.png" alt-text="Screenshot showing the Use Managed Disks page highlighting the Select column and the Postpone or Dismiss actions for a single recommendation.":::

### Postpone or dismiss multiple recommendations in the Azure portal

1. Open [Azure Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.
1. To view your recommendations, select a recommendation category.
1. Select a recommendation from the list of recommendations.
1. Select the checkbox at the left of the row for all resources you want to postpone or dismiss the recommendation.
1. Select **Postpone** or **Dismiss** in the upper-left corner of the table.

     :::image type="content" source="./media/view-recommendations/postpone-dismiss-multiple.png" alt-text="Screenshot showing the Use Managed Disks page highlighting the Select column and the Postpone or Dismiss actions.":::

> [!NOTE]
> You need Contributor or Owner permission to dismiss or postpone a recommendation. Learn more about permissions in Advisor.

If the selection boxes are disabled, recommendations might still be loading. Wait for all recommendations to load before you try to postpone or dismiss.

### Reactivate a postponed or dismissed recommendation

You can activate a recommendation that was postponed or dismissed. This action can be done in the Azure portal or programmatically. In the Azure portal:

1. Open [Advisor](https://aka.ms/azureadvisordashboard) in the Azure portal.

1. Change the filter on the **Overview** pane to **Postponed**. Advisor then displays postponed or dismissed recommendations.

    <!--
    :::image alt-text="The recommendations filtered by the Postponed & Dismissed status in Azure Advisor." lightbox="./media/view-recommendations/activate-postponed.png" source="./media/view-recommendations/activate-postponed.png" type="content":::
    -->

1. Select a category to see **Postponed** and **Dismissed** recommendations.

1. Select a recommendation from the list of recommendations. This action opens recommendations with the **Postponed & Dismissed** tab already selected to show the resources for which this recommendation was postponed or dismissed.

1. Select **Activate** at the end of the row. The recommendation is now active for that resource and removed from the table. The recommendation is visible on the **Active** tab.

     :::image type="content" source="./media/view-recommendations/activate-postponed-2.png" alt-text="Screenshot showing the Enable Soft Delete pane highlighting the Postponed & Dismissed heading and the Activate action in the Action column.":::

## Related articles

*   [Customize recommendations view](./advisor-customize-list-view.md)

*   [Roles and permissions](./permissions.md)
