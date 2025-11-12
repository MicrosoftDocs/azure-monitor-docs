---
title: Customize recommendations view using filters and grouping
description: Customize recommendations view using filters and grouping in the Azure portal.
ms.topic: how-to
ms.date: 11/11/2025

---

# Customize view

This article explains how to effectively use filtering and grouping options when viewing recommendations.

## Filters

Filters help you to focus on the recommendations that are most relevant to your needs. You can apply multiple filters simultaneously to refine your results. For instance, after choosing specific resource groups, you can further filter by recommendation impact or select another filtering option to refine the list even more.

Some filters, like **Subscription**, **Resource Group**, and **Resource Type**, are visible by default in Azure Advisor. Others can be added as needed with the **Add filter** button, allowing you further customize your recommendations view.

:::image alt-text="Screenshot of all recommendations list with filters in Azure Advisor" lightbox="./media/advisor-all-recommendations-filters.png" source="./media/advisor-all-recommendations-filters-preview.png" type="content":::
 
### Resources filters

*   **Subscription**: View recommendations for selected subscriptions.

*   **Resource Group**: View recommendations for selected resource groups.

*   **Resource Type**: Focus on specific services like Virtual Machines, Storage Accounts, and so on.

*   **Workload**: View recommendations for specific workloads.
    Contact your account team to add new workloads to the workload filter or edit workload names.

*   **Tags**: Use tags to filter by business unit, workload, or team.

> [!TIP]
> **Tags** are especially useful for comparing Advisor scores across teams or prioritizing actions based on ownership.

### Recommendations filters

*   **Recommendation status**: Choose between `Active` and `Postponed & Dismissed`.

*   **Impact**: Select one or more values: `High`, `Medium`, and `Low`.

*   **Recommendation Type**: Focus on specific recommendation.

*   **Subcategory**: Focus on specific optimization area. Available for `Cost`, `Reliability`, `Performance`, and `Operational excellence`.

*   **Commitments**: Applies to reservations recommendations, available for `Cost` only.

## Grouping

Grouping helps you organize recommendations into logical categories.

### Grouping Options

*   `Subcategory` \(not supported for `Security` recommendations\)

*   `Subscription`

*   `Resource Group`

*   `Resource Type`

*   `Workload`

*   `No grouping`

:::image alt-text="Screenshot of Cost recommendations grouped by subcategory in Azure Advisor" lightbox="./media/advisor-cost-grouping.png" source="./media/advisor-cost-grouping-preview.png" type="content":::
 
## Related resources

*   [Configure the Azure Advisor recommendations view](./view-recommendations.md)
