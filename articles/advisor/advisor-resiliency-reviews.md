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

In this article, you learn how to enable and access resiliency reviews prepared for you, triage, manage, implement, and track the lifecycle of each recommendation.

## Terminology

| Term or phrase | Detail |
|:--- |:--- |
| Triage recommendation | To accept or reject a recommendation. |
| Manage recommendation lifecycle | To mark a recommendation as `completed`, `postponed or dismissed`, `in progress`, or `not started`. You only manage a recommendation is in the **Accepted** state. |

## How it works

After you request a review, Microsoft Cloud Solution Architect engineers perform extensive analysis, curate the list of prioritized recommendations, and publish a resiliency review. You triage the recommendations and implement each one. Your Microsoft account team works with you to facilitate the process.

The following table defines the responsible parties for Advisor actions.

| Responsibility | Detail |
|:--- |:--- |
| Request a resiliency review | Customer using your Customer Success Account Manager or aligned Cloud Solution Architect. |
| Analyze workload configuration, perform the review using the Well Architected Reliability Assessment and prepare recommendations | Microsoft account team. Team members include Account Managers, Engineers, and Cloud Solution Architects. |
| Triage recommendations to accept or reject the recommendations | Customer. Triage is done by team members who have authority to make decisions about workload optimization priorities. |
| Manage the lifecycle of each recommendation | Customer. Setting the status of accepted recommendation as `completed`, `postponed or dismissed`, `in progress`, or `not started`. |
| Implement recommendations that were accepted | Customer. Implementation is done by engineers who are responsible for managing resources and the configuration. |
| Facilitate implementation | Microsoft account team using your support contract. |

## Enable reviews

Resiliency reviews are available to customers with Unified or Premier Support contracts using a Well Architected Reliability Assessment. To initiate a review, reach out to your Customer Success Account Manager. You can find contact information in [Services Hub](https://serviceshub.microsoft.com "Microsoft Services Hub").

Your Microsoft account team works with you to collect information about the workload. They need to know which subscriptions are used for the workload, and which subscriptions they should use to publish the review and recommendations. You need to work with the owner of the subscription to configure permissions for your team.

## View and triage recommendations

To view or triage recommendations, or to manage the lifecycle of each recommendation, requires specific role permissions. For definitions, see [Terminology](#terminology).

[!INCLUDE [Reviews and personalized recommendations](./includes/advisor-permissions-review-recommendations.md)]

### Access reviews

Find resiliency reviews created by your Microsoft account team.

If a new review is available to you, you see a notification banner on top of Advisor. A **New** review is one with all recommendations in the **Pending** state.

[!INCLUDE [Open Azure Advisor Dashboard](./includes/advisor-open-dashboard.md)]

3.  On the menu for Advisor, select **Manage** > **Reviews (Preview)**.

    A list of reviews opens. At the top of the pane, you see the number of **Total Reviews** and review **Recommendations**, and a graph of **Reviews by status**.

4.  Use search, filters, and sorting to find the review you need. You can filter reviews by one of the **Status equals** states shown next, or choose **All** (the default) to see all reviews. If you don't see a review for your subscription, make sure the review subscription is included in the global portal filter. To see the reviews for a subscription, update the filter.

    | Filter | Detail |
    |:--- |:--- |
    | New | No recommendations are triaged, such as accepted or rejected. |
    | In progress | Some recommendations aren't triaged. |
    | Triaged | All recommendations are triaged. |
    | Completed | All accepted-state recommendations are implemented, postponed, or dismissed. |

:::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews pane." lightbox="./media/advisor-reviews-highlight-reviews-preview.png" source="./media/advisor-reviews-highlight-reviews.png" type="content":::

At the top of the reviews pane, use **Feedback** to tell the platform about your experience. To refresh the pane, use the **Refresh** button.

> [!NOTE]
> If you have no reviews, the **Reviews** menu item on the menu for Advisor is hidden.

### Review recommendations

The triage process includes reviewing recommendations and making decisions on which to implement. Use **Accept** and **Reject** actions to capture your decision. Accepted recommendations are available to engineers on your team on **Reliability** pane.

:::image alt-text="Screenshot of the Azure Advisor Reliability menu highlight." lightbox="./media/advisor-reliability-highlight-reliability-preview.png" source="./media/advisor-reliability-highlight-reliability.png" type="content":::

1.  On **Reviews**, select the name of a review to open the recommendations list.

    For new reviews, recommendations are set to **Pending** state.

1.  Take a note of priority for each recommendation. To help you decide which recommendation should be implemented first, your account team defines the **Priority**.

    :::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendation list pane with pending recommendations." lightbox="./media/advisor-reviews-contoso-company-pending-preview.png" source="./media/advisor-reviews-contoso-company-pending.png" type="content":::

1.  To get detailed information for a recommendation, select the **Title** or the **Impacted resources** view link.

    A pane opens with **Description**, **Potential benefits**, and **Notes** details from your Microsoft account team along with the list of impacted resources or subscriptions.

    :::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendation list pane with the details pane of a selected recommendation." lightbox="./media/advisor-reviews-contoso-company-traffic-manager-monitor-status-online-preview.png" source="./media/advisor-reviews-contoso-company-traffic-manager-monitor-status-online.png" type="content":::

1.  If all recommendations for the review are triaged, none appear in the **Pending** view.

    To view the triaged recommendations, select the **Accepted** or **Rejected** tabs.

### Recommendation priority

The priority of a recommendation is based on the impact value and urgency of the suggested improvements. Your Microsoft account team sets recommendation priority. If a recommendation is targeting multiple resources or subscriptions, you have to accept the recommendation for all resources or subscriptions.

| Priority | Detail |
|:--- |:--- |
| Critical | The most important recommendations that can have a significant impact value on your Azure resources. The recommendations should be addressed as soon as possible to avoid potential issues such as security breaches, data loss, or service outages. |
| High | The recommendations that can improve the performance, reliability, or cost efficiency of your Azure resources. The recommendations should be addressed in a timely manner to optimize your Azure deployments. |
| Medium | The recommendations that can enhance the operational excellence or user experience of your Azure resources. The recommendations should be considered and implemented if the recommendations align with your business goals and requirements. |
| Low | The recommendations that can provide extra benefits or insights for your Azure resources. The recommendations should be reviewed and implemented if the recommendations are relevant and feasible for your scenario. |
| Informational | The recommendations that can help you learn more about the features and capabilities of Azure. The recommendations don't require any action, but the recommendations help you discover new ways to use Azure. |

### Accept recommendations

You must accept recommendations for your engineering team to start implementation. After a review recommendation is accepted, the recommendation becomes available on the **Reliability** pane from there you acted on the recommendation.

1.  On a review recommendations details pane, accept one or more recommendations.

    *   To accept a single recommendation, select **Accept**.

    *   To accept multiple recommendations, select the checkbox next to each recommendation and select **Accept**.

1.  Accepted recommendations are moved to the **Accepted** tab.

    On **Recommendations** > **Reliability**, accepted recommendations are visible for engineers on your team.

    :::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendation list pane of accepted recommendations." lightbox="./media/resiliency-reviews/resiliency-review-recommendation-list-accepted.png" source="./media/resiliency-reviews/resiliency-review-recommendation-list-accepted.png" type="content":::

1.  If you accept a recommendation by mistake, select **Reset** to move it back to the **Pending** state.

### Reject recommendations

If a recommendation is targeting to multiple resources or subscriptions, you have to reject the recommendation for all resources or subscriptions.

1.  On a review recommendations details pane, reject one or more recommendations.

    > [!NOTE]
    > If you need to select a different reason, reject one recommendation at a time.

    *   To reject a single recommendation.

        1.  Select a recommendation and select a reason when you reject a recommendation.

        1.  Select one of the reasons from the list of available options.

            :::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendations reject options." lightbox="./media/resiliency-reviews/resiliency-review-recommendation-reject-options-medium.png" source="./media/resiliency-reviews/resiliency-review-recommendation-reject-options-medium.png" type="content":::

    *   To reject multiple recommendations and apply the same reason to all selected recommendations.

        1.  Select the checkbox next to each recommendation.

        1.  Select the reason when you reject the recommendations. Select one of the reasons from the list of available options.

1.  The rejected recommendations are moved to the **Rejected** tab. 

    On **Recommendations** > **Reliability**, rejected recommendations aren't visible for engineers on your team.

    :::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendations pane of rejected recommendations." lightbox="./media/resiliency-reviews/resiliency-review-recommendation-list-rejected.png" source="./media/resiliency-reviews/resiliency-review-recommendation-list-rejected.png" type="content":::

1.  If you reject a recommendation by mistake, select **Reset** to move it back to the **Pending** state.

> [!NOTE]
> The reason for the rejection is visible to your Microsoft account team. The reason helps your Microsoft account team understand workload context and your business priorities better. Additionally, the platform uses the information to improve the quality of recommendations.

## Implement recommendations

After review recommendations are triaged, all recommendations with **Accepted** status become available on the Advisor **Reliability** pane with links to the resources needing action. Typically, an engineer on your team implements the recommendations by going to the resource pane and making the recommended change. Separately track the implementation of the recommendation for each targeted resource or subscription.

For definitions on recommendation states, see [Terminology](#terminology).

### Prerequisites to implement recommendations

For details on permissions to act on recommendations, see [Roles and permissions](./permissions.md "Roles and permissions | Azure Advisor | Microsoft Learn").

### Access accepted review recommendations

On **Recommendations** > **Reliability**, view the **Accepted** review recommendations for the **Reliability** pillar, by default.

The recommendations are grouped by type.

| Type | Detail |
|:--- |:--- |
| Reviews | The recommendations that are part of a review for a selected workload. |
| Automated | The recommendations that are the standard Advisor recommendations for the selected subscriptions. |

> [!NOTE]
> If none of your resiliency review recommendations are in the **Accepted** state, the **Reviews** tab is hidden.

:::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendations pane of accepted recommendations." lightbox="./media/resiliency-reviews/resiliency-review-recommendation-list-accepted.png" source="./media/resiliency-reviews/resiliency-review-recommendation-list-accepted.png" type="content":::

You can filter the recommendations by subscription, priority, and workload; and sort the recommendation list.

You can sort recommendations using following column headers. **Priority** (**Critical**, **High**, **Medium**, **Low**, **Informational**), **Description**, **Impacted resources**, **Review name**, **Potential benefits**, or **Last updated** date.

### View recommendation details

Select a recommendation description to open a details pane. Your Microsoft account team adds the **Description**, **Potential benefits**, and **Notes** when the review is prepared.

:::image alt-text="Screenshot of the Azure Advisor Reliability pane for a Resiliency Reviews recommendation." lightbox="./media/resiliency-reviews/resiliency-review-reliability-page-detail.png" source="./media/resiliency-reviews/resiliency-review-reliability-page-detail.png" type="content":::

The options in the **Reliability** recommendations detail differ from the options in the **Reviews** recommendations detail. Here, a developer on your team opens the **Impacted resources** link and takes direct action.

For details on recommendation priority, see [Recommendation priority](#recommendation-priority).

### Manage recommendation lifecycle

Recommendation status is a valuable indicator for determining what actions need to be taken.

*   After you begin to implement a recommendation, mark it as **In progress**.

*   After the recommendation is implemented, the recommended action is taken, update the status to **Completed**.

    On **Review**, after all recommendations are marked a **Completed** in a review the review is also marked as **Completed**.

*   You can also postpone the recommendation for action later.

*   You can dismiss a recommendation if you don't plan to implement it. If you dismiss the recommendation, you must give a reason, just as you must give a reason if you reject a recommendation in a review.

:::image alt-text="Screenshot of the Azure Advisor Resiliency Reviews recommendations dismiss options." lightbox="./media/resiliency-reviews/resiliency-review-recommendation-dismiss-options-medium.png" source="./media/resiliency-reviews/resiliency-review-recommendation-dismiss-options-medium.png" type="content":::

## Review maintenance

The engineers on your Microsoft account team keep track of the results of your actions on resiliency reviews and continue to refine the recommendation reviews accordingly.

## Related articles

For more information about Azure Advisor, see the following articles.

*   [Introduction to Azure Advisor](./advisor-overview.md "Introduction to Azure Advisor | Azure Advisor | Microsoft Learn")

*   [Azure Advisor portal basics](./advisor-get-started.md "Azure Advisor portal basics | Azure Advisor | Microsoft Learn")

*   [Azure Advisor REST API](/rest/api/advisor "Azure Advisor REST API | Microsoft Learn")

For more information about specific Advisor recommendations, see the following articles.

*   [Reliability workbook](./advisor-workbook-reliability.md "Reliability workbook | Azure Advisor | Microsoft Learn")

*   [Reliability recommendations](./advisor-reference-reliability-recommendations.md "Reliability recommendations | Azure Advisor | Microsoft Learn")
