---
title: Azure Advisor resiliency reviews
description: Optimize resource resiliency with custom recommendation reviews.
ms.service: azure
ms.topic: how-to
author: tiffanywangmicrosoft
ms.author: tiffanywang
ms.date: 04/22/2025

---

# Azure Advisor Resiliency Reviews

Azure Advisor Resiliency Reviews help you focus on the most important recommendations to optimize your cloud deployments and improve resiliency. Review recommendations are tailored to the needs of your workload and include custom ones curated by your Microsoft account team using Azure best practices and prioritized automated recommendations.

You can find resiliency reviews in [Azure Advisor](https://aka.ms/azureadvisordashboard "Overview | Advisor | Microsoft Azure"), which serves as your single-entry point for Azure Well Architected Framework (WAF) assessments of industry best practices.

In this article, you learn how to enable and access resiliency reviews prepared for you manage, implement, and track the lifecycle of each recommendation.

## Terminology

| Term or phrase | Detail |
|:--- |:--- |
| Manage recommendation status| To mark a recommendation as: `Completed`, `Postponed`, or `Dismissed`|

## Changes to recommendation process

The triage process is deprecated and replaced with a new process.

- `Pending`,'not started', 'in progress', and `Accepted` are now combined into only `Active`.
- `Rejected` is now `Dismissed`.
- `Completed` and `Postponed` remain unchanged.

## How it works

After you request a review, Microsoft Cloud Solution Architect engineers perform extensive analysis, curate the list of prioritized recommendations, and publish a resiliency review.

The following table defines the responsible parties for Advisor actions.

| Responsibility | Detail |
|:--- |:--- |
| Request a resiliency review | Customer using your Customer Success Account Manager or aligned Cloud Solution Architect. |
| Analyze workload configuration, perform the review using the Well Architected Reliability Assessment, and prepare recommendations | Microsoft account team. Team members include Account Managers, Engineers, and Cloud Solution Architects. |
| Manage recommendation status | Customer. Set the status of recommendation as: `Completed`, `Postponed`, or `Dismissed`. |
| Implement recommendations | Customer. Engineers responsible for managing resources and the configuration. |
| Facilitate implementation | Microsoft account team using your support contract. |

## Enable reviews

Customers with Unified or Premier Support contracts can access resiliency reviews by using a Well Architected Reliability Assessment. To initiate a review, reach out to your Customer Success Account Manager. You can find contact information in [Services Hub](https://serviceshub.microsoft.com "Microsoft Services Hub").


Your Microsoft account team works with you to collect information about the workload. They need to know which subscriptions are used for the workload, and which subscriptions they should use to publish the review and recommendations. You need to work with the owner of the subscription to configure permissions for your team.

## View recommendations

To view recommendations or manage the status of each recommendation, you need specific role permissions. For definitions, see [Terminology](#terminology).

[!INCLUDE [Reviews and personalized recommendations](./includes/advisor-permissions-review-recommendations.md)]

### Access reviews

Find resiliency reviews created by your Microsoft account team.

If a new review is available to you, you see a notification banner on top of Advisor. A **New** review is one with all recommendations in the **Active** state.

[!INCLUDE [Open Azure Advisor Dashboard](./includes/advisor-open-dashboard.md)]

1.  On the menu for Advisor, select **Manage** > **Reviews (Preview)**.
1.  A list of reviews opens. At the top of the pane, you see the number of **Total Reviews** and review **Recommendations**, and a graph of **Reviews by status**.
1.  Use search, filters, and sorting to find the review you need. You can filter reviews by one of the **Status equals** states shown next, or choose **All** (the default) to see all reviews. If you don't see a review for your subscription, make sure the review subscription is included in the global portal filter. To see the reviews for a subscription, update the filter.

### Review status

| Filter | Detail |
|:--- |:--- |
| New | All recommendations are active |
| In progress | At least one recommendation is moved to 'non-active' |
| Completed | All recommendations are either complete or marked as 'dismissed' |

:::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews pane." lightbox="./media/advisor-reviews-highlight-reviews-preview.png" source="./media/advisor-reviews-highlight-reviews.png" type="content":::

At the top of the reviews pane, use **Feedback** to tell the platform about your experience. To refresh the pane, use the **Refresh** button.

> [!NOTE]
> If you have no reviews, the **Reviews** menu item on the menu for Advisor is hidden.

### Review recommendations

Manage recommendation statuses through four steps: `active`, `dismissed`, `completed`, and `postponed`. Engineers on your team can access recommendations on the **Reliability** pane.

:::image alt-text="Screenshot of the Azure Advisor Reliability menu highlight." lightbox="./media/advisor-reliability-highlight-reliability-2.png" source="./media/advisor-reliability-highlight-reliability-2.png" type="content":::

1.  On **Reviews**, select the name of a review to open the recommendations list.

    For new reviews, recommendations are set to **Active** state.

1.  Note the priority for each recommendation. To help you decide which recommendation to implement first, your account team defines the **Priority**.

    :::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendation list pane with pending recommendations." lightbox="./media/advisor-reviews-contoso-company-pending-preview.png" source="./media/advisor-reviews-contoso-company-pending.png" type="content":::

### Recommendation priority

The priority of a recommendation is based on the impact value and urgency of the suggested improvements. Your Microsoft account team sets recommendation priority. If a recommendation targets multiple resources or subscriptions, you must accept the recommendation for all resources or subscriptions.

| Priority | Detail |
|:--- |:--- |
| Critical | The most important recommendations that can have a significant impact value on your Azure resources. Address these recommendations as soon as possible to avoid potential issues such as security breaches, data loss, or service outages. |
| High | Recommendations that can improve the performance, reliability, or cost efficiency of your Azure resources. Address these recommendations in a timely manner to optimize your Azure deployments. |
| Medium | Recommendations that can enhance the operational excellence or user experience of your Azure resources. Consider and implement these recommendations if they align with your business goals and requirements. |
| Low | Recommendations that can provide extra benefits or insights for your Azure resources. Review and implement these recommendations if they're relevant and feasible for your scenario. |
| Informational | Recommendations that can help you learn more about the features and capabilities of Azure. These recommendations don't require any action, but they help you discover new ways to use Azure. |

### Prerequisites to implement recommendations

For details on permissions to act on recommendations, see [Roles and permissions](./permissions.md "Roles and permissions | Azure Advisor | Microsoft Learn").

### Access review recommendations

On **Recommendations** > **Reliability**, view the **Active** review recommendations under the **Reviews** tab.

The recommendations are grouped by type.

You can filter the recommendations by subscription, priority, and workload. You can also sort the recommendation list.


You can sort recommendations by using the following column headers: **Priority** (**Critical**, **High**, **Medium**, **Low**, **Informational**), **Description**, **Impacted resources**, **Review name**, **Potential benefits**, or **Last updated** date.


### View recommendation details

Select a recommendation description to open a details pane. Your Microsoft account team adds the **Description**, **Potential benefits**, and **Notes** when they prepare the review.


:::image alt-text="Screenshot of the Azure Advisor Reliability pane for a Resiliency Reviews recommendation." lightbox="./media/resiliency-reviews/resiliency-review-reliability-page-detail.png" source="./media/resiliency-reviews/resiliency-review-reliability-page-detail.png" type="content":::

The options in the **Reliability** recommendations detail differ from the options in the **Reviews** recommendations detail. Here, a developer on your team opens the **Impacted resources** link and takes direct action.

For details on recommendation priority, see [Recommendation priority](#recommendation-priority).

### Manage recommendation status

Recommendation status helps you decide what action to take. Review each available recommendation status: 


* **Active**: New recommendations identified by the Azure Advisor system.


* **Postponed**: Temporarily hides a recommendation for a set period. After that period, the recommendation automatically reappears.


* **Dismissed**: Permanently removes an item from view until you choose to reactivate it.


* **Completed**: The recommended action is successfully applied to the resource, or the recommendation no longer applies. You can mark a recommendation as completed manually, or Azure Advisor can automatically mark it as completed if it verifies that recommendation no longer applies.


:::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendations dismiss options." lightbox="./media/resiliency-reviews/resiliency-review-recommendation-dismiss-options-medium.png" source="./media/resiliency-reviews/resiliency-review-recommendation-dismiss-options-medium.png" type="content":::

## Review maintenance

The engineers on your Microsoft account team track the results of your actions on resiliency reviews and continue to refine the recommendation reviews accordingly.


## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability workbook](./advisor-workbook-reliability.md "Reliability workbook | Azure Advisor | Microsoft Learn")

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md "Reliability recommendations | Azure Advisor | Microsoft Learn")
